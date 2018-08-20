// MMH7Hook.cpp : Defines the exported functions for the DLL application.
//

#include "stdafx.h"
#include "MMH7Mods.h"
#include <stdio.h>
#include <malloc.h>
#include <iomanip>
#include <Psapi.h>
#include "SdkHeaders.h"
#include "vmt.h"
#include <fstream>
#include <string>
#include <set>
#include <vector>
#include "HookBase.h"
#include "GameLog.h"
#include "AIMods.h"
#include "ModsTests.h"

#pragma comment( lib, "psapi.lib" )

DWORD64 GObjects = 0;
DWORD64 GNames = 0;
DWORD64 ModuleBaseAddr = 0;
std::shared_ptr<VMTManager> _vmt;
VMTManager* _vmtHints = NULL;


//void init_ptrs_list(); 
//DWORD64 funcs_ptrs[0x58]; 

const DWORD ProcessEventsLength = 0x24A;
const DWORD64 pBinCodeInterp = 0x000000014266DE40;

std::set<std::string> __functions_filter;

typedef void (*pThink)( void* thisptr, class AH7Unit* Unit, float DeltaTime) ;

pThink oldThink = 0;
ProcessEventPtr pOriginalProcessEvent = 0;
//ProcessInternalPtr OriginalProcessInternal = 0;

VMTManager::DetourPtr OriginalProcessInternal;
DWORD OriginalProcessEvent;

CRITICAL_SECTION CriticalSection;
// Initialize any function to be detoured as ProcessInternall
#define FUNCTION_THINK "Function MMH7Game.H7AiCombatMap.Think"

void Init_Variables()
{
  __gLog.reset(new GameLog());
  __hooksHolder.reset(new HooksHolder());

}

void Init_Hooks()
{
	new HookFunctionToCallback("Function MMH7Game.H7LoadingHints.InitHints", InitHintsFunc);
	new HookFunctionToCallback("Function MMH7Game.H7AdventureController.InitAdventureAI", InitAdventureAIFunc);
	new HookFunctionToCallback("Function MMH7Game.H7CombatController.InitCombatAI", InitInitCombatAI);
	new HookFunctionToCallback("Function MMH7Game.H7AiCombatSensors.Setup", SetupCombatSensorsFunc);
	new HookFunctionToCallback("Function MMH7Game.H7AiAdventureSensors.Setup", SetupAdventureSensorsFunc);
}

PDWORD dwOldVMT                                                 = NULL;

void OnAttach()
{
  // Init variables
  Init_Variables();

  // Initialize core pointers 
  Init_Core();

  // Initialize all function to be detoured
  Init_Functions();

  Init_Hooks();
  
  if(__gLog->Level() == LL_DEBUG)
  {
	  UObject* pObject = UObject::GObjObjects()->Data[UObject_index];
	  LOG(LL_VERBOSE) << "Object Name: " << pObject->GetFullName() << "\n";
	  for ( int i = 0; i < UObject::GObjObjects()->Num(); i++ ){
  			UObject* p = UObject::GObjObjects()->Data[ i ];
  			if ( ! p )
  				continue;
  			
			if(p->IsA(UFunction::StaticClass())) {
				UFunction* f = (UFunction*)p;
				//if((DWORD64)f->Func != 0x000000014266DE40l) {
					LOG(LL_VERBOSE) <<  "Function: " <<  p->GetFullName() << " func: " << SDKMC_SSHEX(f->Func,8) << " inative: " << f->iNative << " flags:" << f->FunctionFlags << "\n";
				//}
			} else if(p->IsA(UClass::StaticClass())) {
				UClass* c = (UClass*)p;
				LOG(LL_VERBOSE) <<  "Class: " <<  c->GetFullName() << " num: " << i << " nidx: " << c->Name.Index << " addr:" <<SDKMC_SSHEX(p,8) << "\n";
				//LOG(LL_VERBOSE) <<  "Object: " <<  p->GetFullName() << " num: " << i << " nidx: " << p->Name.Index << " addr:" <<SDKMC_SSHEX(p,8) << "\n";
		    }
	  }
  }

  UFunction* pAICombatMapThink = (UFunction*)UObject::FindObject<UObject>(FUNCTION_THINK);

  if( pAICombatMapThink != NULL)
  {
	  LOG(LL_VERBOSE) << "pAICombatMapThink: addr " << SDKMC_SSHEX(pAICombatMapThink,8) << " func addr: " <<  SDKMC_SSHEX(pAICombatMapThink->Func,8) 
		              << " Offset: " << SDKMC_SSHEX((DWORD64)pAICombatMapThink->Func - ModuleBaseAddr,8) << "\n"; 
  }
  else{
	  LOG(LL_VERBOSE) << "Getting address for '" << FUNCTION_THINK << "' failed" << "\n";
	  LOG(LL_VERBOSE) << "Detour failed " << '\n';
	  return ;
  }

  UObject* pAICombatMap = UObject::FindObject<UObject>("Class MMH7Game.H7AiCombatMap");

  if( pAICombatMap == NULL ){
     LOG(LL_VERBOSE) << " Can not find object: H7AICombatMap " << "\n";
	 return;
  }

  _vmt.reset(new VMTManager((LPVOID *)pAICombatMap));
  // _vmt->DumpVmt(clog);
  //
  LOG(LL_VERBOSE) << "Started detour : " << SDKMC_SSHEX( pAICombatMapThink->Func, 8) << '\n';

  OriginalProcessInternal = _vmt->DetourFunction(pAICombatMapThink->Func, hkProcessInternal);
  if ( OriginalProcessInternal->get() == NULL || 
	   !OriginalProcessInternal->Start()){
	  LOG(LL_VERBOSE) << "Detouring function failed" << '\n';
	  return;
  }
  
  LOG(LL_VERBOSE) << "Detour ok: " << SDKMC_SSHEX( OriginalProcessInternal->get(), 8) << '\n';
}

void TraceStack()
{
	unsigned int   i;
	void         * stack[ 100 ];
	unsigned short frames;


	frames = CaptureStackBackTrace( 0, 100, stack, NULL );

	for( i = 1; i < frames; i++ )
	{
		LOG(LL_DEBUG) << std::dec << i << "\t" << SDKMC_SSHEX((DWORD64)stack[i], 8) << "\t" << SDKMC_SSHEX(((DWORD64)stack[i] - ModuleBaseAddr),8) << "\n";    
	}
}


static int entry_count = 0;
void         * stack[ 100 ];

void __fastcall hkProcessEvent ( void* pthis, class UFunction* pFunction, void* pParams, void* pResult)
{
	LOGTS(LL_VERBOSE) << "hkPE Caller_object: Addr: " << SDKMC_SSHEX(pthis, 8);
	if(pthis != NULL)
	{
		LOG(LL_VERBOSE) << " Name: " <<  ((UObject*)pthis)->GetFullName()
			 << " Function: Addr: " << SDKMC_SSHEX(pFunction, 8);

		// log here
		if( pFunction != NULL && (DWORD64)pFunction > 0x000007FFF0000000ll )
		{
			LOG(LL_DEBUG) << pFunction << "\n";
			LOG(LL_VERBOSE) << "Function Name: " << pFunction->GetFullName();
		}

		LOG(LL_DEBUG)  << " Params: Addr: "   << SDKMC_SSHEX(pParams, 8);

		if( pParams != NULL && (DWORD64)pParams > 0x000007FFF0000000ll)
		{
			LOG(LL_DEBUG) << pParams << "\n";
			LOG(LL_VERBOSE) << "Params Name: " << ((UObject*) pParams)->GetFullName();
		}

		LOG(LL_DEBUG) << " Result:  Addr:"   << SDKMC_SSHEX(pResult, 8);

		if( pResult != NULL && (DWORD64)pResult > 0x000007FFF0000000ll)
		{
			LOG(LL_DEBUG) << pResult << "\n";
			LOG(LL_DEBUG) << " Name: " << ((UObject*)pResult)->GetFullName();
		}

	}

	LOG(LL_DEBUG) << '\n';
	// call original function
	pOriginalProcessEvent(pthis,  pFunction, pParams, pResult);
	// pOriginalProcessEvent(pthis,  pFunction, pParams, pResult);
}

MODULEINFO GetModuleInfo ( LPCTSTR lpModuleName )
{
	MODULEINFO miInfos = { NULL };

	HMODULE hmModule = GetModuleHandle ( lpModuleName );

	if ( hmModule )
	{
		GetModuleInformation ( GetCurrentProcess(), hmModule, &miInfos, sizeof ( MODULEINFO ) );
	}

	return miInfos;
}
/*
# ========================================================================================= #
# Initialization														
# ========================================================================================= #
*/

void Init_Core()
{
	MODULEINFO miGame = GetModuleInfo ( NULL );
	DWORD64 baseAddress = ModuleBaseAddr = (DWORD64)miGame.lpBaseOfDll;
	LOG(LL_VERBOSE) << "Base Address: " << SDKMC_SSHEX(baseAddress,8) << "\n";
	GObjects =  baseAddress + GObjects_Offset;
	LOG(LL_VERBOSE) << "GObjects Address: " << SDKMC_SSHEX(GObjects, 8) << "\n";
	GNames =  baseAddress + GNames_Offset;
	LOG(LL_VERBOSE) << "GNames Address: " << SDKMC_SSHEX(GNames, 8) << '\n';
}

// #include "./hard_hack/ProcEventTempl.h"
