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
#include "CombatDumper.h"
#include "ArmyFeaturizer.h"
#include "CombatFeaturizer.h"
#include "HookBase.h"
#include "GameLog.h"





#pragma comment( lib, "psapi.lib" )

DWORD64 GObjects = 0;
DWORD64 GNames = 0;
DWORD64 ModuleBaseAddr = 0;
std::shared_ptr<VMTManager> _vmt;
std::shared_ptr<ModsConfig> __Cfg;
const std::string GameModuleName("MMH7Game-Win64-Shipping.exe");


//void init_ptrs_list(); 
//DWORD64 funcs_ptrs[0x58]; 

const DWORD ProcessEventsLength = 0x24A;

std::set<std::string> __functions_filter;

typedef void (*pThink)( void* thisptr, class AH7Unit* Unit, float DeltaTime) ;

pThink oldThink = 0;
//ProcessEventPtr pOriginalProcessEvent = 0;
//ProcessInternalPtr OriginalProcessInternal = 0;

VMTManager::DetourPtr OriginalProcessInternal;

CRITICAL_SECTION CriticalSection;
// Initialize any function to be detoured as ProcessInternall
#define FUNCTION_THINK "Function MMH7Game.H7AiCombatMap.Think"

bool Init_Variables()
{
	bool init = false;
  __Cfg.reset(new ModsConfig() );
  if (__Cfg->IsConfigured()) 
  {
	  __gLog.reset(new GameLog(*__Cfg));
	  __hooksHolder.reset(new HooksHolder());
	  init = true;
  }

  return init;
}

void OnAttach()
{
  // Init variables
  if (!Init_Variables()) {
	  std::cerr << "Initialization failed." << std::endl;
	  return;
  }

  LOG(LL_VERBOSE) << "Dll loaded into: " << __Cfg->GetProcessName() << "\n";
  if (GameModuleName != __Cfg->GetProcessName())
  {
	  LOG(LL_NORMAL) << "Process name '" << __Cfg->GetProcessName() << "' is not MMH7 game. Required name: " << GameModuleName << "\n";
	  return;
  }

  // Initialize core pointers 
  Init_Core();

  // Initialize all function to be detoured
  Init_Functions();
  
  if(__gLog->Level() == LL_DEBUG)
  {
	  UObject* pObject = UObject::GObjObjects()->Data[UObject_index];
	  LOG(LL_DEBUG) << "Object Name: " << pObject->GetFullName() << "\n";
	  for ( int i = 0; i < UObject::GObjObjects()->Num(); i++ ){
  			UObject* p = UObject::GObjObjects()->Data[ i ];
  			if ( ! p )
  				continue;
  			LOG(LL_DEBUG) <<  "Object: " <<  p->GetFullName() << " num: " << i << " nidx: " << p->Name.Index << " addr:" <<SDKMC_SSHEX(p,8) << "\n";
	  }
  }

  // return;

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
	LOGTS(LL_DEBUG) << " Caller_object: Addr: " << SDKMC_SSHEX(pthis, 8);
	if(pthis != NULL)
	{
		LOG(LL_DEBUG) << " Name: " <<  ((UObject*)pthis)->GetFullName()
			 << " Function: Addr: " << SDKMC_SSHEX(pFunction, 8);

		// log here
		if( pFunction != NULL && (DWORD64)pFunction > 0x000007FFF0000000ll )
		{
			LOG(LL_DEBUG) << pFunction << "\n";
			LOG(LL_DEBUG) << " Name: " << pFunction->GetFullName();
		}

		LOG(LL_DEBUG)  << " Params: Addr: "   << SDKMC_SSHEX(pParams, 8);

		if( pParams != NULL && (DWORD64)pParams > 0x000007FFF0000000ll)
		{
			LOG(LL_DEBUG) << pParams << "\n";
			LOG(LL_DEBUG) << " Name: " << ((UObject*) pParams)->GetFullName();
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
	// (*(ProcessEventPtr)_vmt->GetOriginalFuncPtr(ProcessEvent_Index))(pthis,  pFunction, pParams, pResult);
	// pOriginalProcessEvent(pthis,  pFunction, pParams, pResult);
}


void DumpH7Command(UH7Command* command)
{
	if( __gLog->Level() != LL_DEBUG) return;

	LOG(LL_DEBUG) << "Command_Dump: is_run: " << command->mRunning << " type: " << std::dec << (int)command->mCommandType;
	if( command->mPath.Data){
		LOG(LL_DEBUG) << " Path:"; 
		for ( int i = 0; i < command->mPath.Count; i++){
			LOG(LL_DEBUG) << " X:" << command->mPath.Data[i]->mPosition.X;
            LOG(LL_DEBUG) << " Y:" << command->mPath.Data[i]->mPosition.Y;
		}
	}

	if( command->mSource )
	{
		LOG(LL_DEBUG) << " " << command->mSource->GetFullName();
		if( !strcmp("H7CreatureStack TheWorld.PersistentLevel.H7CreatureStack", command->mSource->GetFullName() ))
		{
			AH7CreatureStack* creature = (AH7CreatureStack*) command->mSource;
			LOG(LL_DEBUG) << " Source stack size: " << creature->mStackSize << " Top stack size: " << creature->mTopCreatureHealth;
			LOG(LL_DEBUG) << " grid pos: (" << creature->mGridPos.X << "," << creature->mGridPos.Y << ")";
		}
	}
	LOG(LL_DEBUG) << "\n";
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
	// get GObjects
	GObjects =  baseAddress + GObjects_Offset;

	LOG(LL_VERBOSE) << "GObjects Address: " << SDKMC_SSHEX(GObjects, 8) << "\n";

	GNames =  baseAddress + GNames_Offset;

	LOG(LL_VERBOSE) << "GNames Address: " << SDKMC_SSHEX(GNames, 8) << '\n';

}


// #include "./hard_hack/ProcEventTempl.h"
