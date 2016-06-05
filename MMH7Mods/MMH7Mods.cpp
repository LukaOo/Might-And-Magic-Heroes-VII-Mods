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





#pragma comment( lib, "psapi.lib" )

DWORD64 GObjects = 0;
DWORD64 GNames = 0;
DWORD64 ModuleBaseAddr = 0;
std::shared_ptr<VMTManager> _vmt;
std::shared_ptr<ModsConfig> __Cfg;
std::ofstream clog; 


//void init_ptrs_list(); 
//DWORD64 funcs_ptrs[0x58]; 

const DWORD ProcessEventsLength = 0x24A;

std::set<std::string> __functions_filter;

typedef void (*pThink)( void* thisptr, class AH7Unit* Unit, float DeltaTime) ;

pThink oldThink = 0;
//ProcessEventPtr pOriginalProcessEvent = 0;
//ProcessInternalPtr OriginalProcessInternal = 0;

VMTManager::DetourPtr OriginalProcessInternal;

void __stdcall hkThink ( void * pthis, class AH7Unit* Unit, float DeltaTime )
{
	clog << " Think: Caller_object: Addr: " << SDKMC_SSHEX(pthis, 8);

    if( oldThink != NULL )
	{
		(*oldThink)(pthis, Unit, DeltaTime);
	}
}

CRITICAL_SECTION CriticalSection;
// Initialize any function to be detoured as ProcessInternall
#define FUNCTION_THINK "Function MMH7Game.H7AiCombatMap.Think"

void OnAttach()
{
  __Cfg.reset(new ModsConfig() );
  clog.open(__Cfg->GetLogName().c_str());
  __hooksHolder.reset(new HooksHolder());

  // Initialize core pointers 
  Init_Core();

  // Initialize all function to be detoured
  Init_Functions();
   
  // UObject* pObject = UObject::GObjObjects()->Data[UObject_index];
  // clog << "Object Name: " << pObject->GetFullName() << "\n";
  // for ( int i = 0; i < UObject::GObjObjects()->Num(); i++ ){
  //		UObject* p = UObject::GObjObjects()->Data[ i ];
  //		if ( ! p )
  //			continue;
  //		clog <<  "Object: "<<  p->GetFullName() << " num: " << i << " nidx: " << p->Name.Index << " addr:" <<SDKMC_SSHEX(p,8) << "\n";
  // }

  // return;

  UFunction* pAICombatMapThink = (UFunction*)UObject::FindObject<UObject>(FUNCTION_THINK);

  if( pAICombatMapThink != NULL)
  {
	  clog << "pAICombatMapThink: addr " << SDKMC_SSHEX(pAICombatMapThink,8) << " func addr: " <<  SDKMC_SSHEX(pAICombatMapThink->Func,8) 
		   << " Offset: " << SDKMC_SSHEX((DWORD64)pAICombatMapThink->Func - ModuleBaseAddr,8) << "\n"; 
  }
  else{
	  clog << "Getting address for '" << FUNCTION_THINK << "' failed" << "\n";
	  clog << "Detour failed " << '\n';
	  return ;
  }

  UObject* pAICombatMap = UObject::FindObject<UObject>("Class MMH7Game.H7AiCombatMap");

  if( pAICombatMap == NULL ){
     clog << " Can not find object: H7AICombatMap " << std::endl;
	 return;
  }

  _vmt.reset(new VMTManager((LPVOID *)pAICombatMap));
  _vmt->DumpVmt(clog);
  //
  clog << "Started detour : " << SDKMC_SSHEX( pAICombatMapThink->Func, 8) << std::endl;

  OriginalProcessInternal = _vmt->DetourFunction(pAICombatMapThink->Func, hkProcessInternal);
  if ( OriginalProcessInternal->get() == NULL || 
	   !OriginalProcessInternal->Start()){
	  clog << "Detouring function failed" << std::endl;
	  return;
  }

  
  clog << "Detour ok: " << SDKMC_SSHEX( OriginalProcessInternal->get(), 8) << std::endl;

}


void TraceStack()
{
	unsigned int   i;
	void         * stack[ 100 ];
	unsigned short frames;


	frames = CaptureStackBackTrace( 0, 100, stack, NULL );

	for( i = 1; i < frames; i++ )
	{
		clog << std::dec << i << "\t" << SDKMC_SSHEX((DWORD64)stack[i], 8) << "\t" << SDKMC_SSHEX(((DWORD64)stack[i] - ModuleBaseAddr),8) << "\n";    
	}
}


static int entry_count = 0;
void         * stack[ 100 ];



void __fastcall hkProcessEvent ( void* pthis, class UFunction* pFunction, void* pParams, void* pResult)
{
	time_t t = time(NULL);
    struct tm *tm = localtime(&t);
    char date[20];
    strftime(date, sizeof(date), "%Y-%m-%d %H:%M", tm);
	clog << date << " Caller_object: Addr: " << SDKMC_SSHEX(pthis, 8);
	if(pthis != NULL)
	{
		clog << " Name: " <<  ((UObject*)pthis)->GetFullName()
			 << " Function: Addr: " << SDKMC_SSHEX(pFunction, 8);

		// log here
		if( pFunction != NULL && (DWORD64)pFunction > 0x000007FFF0000000ll )
		{
			clog << pFunction << std::endl;
			clog << " Name: " << pFunction->GetFullName();
		}

		clog  << " Params: Addr: "   << SDKMC_SSHEX(pParams, 8);

		if( pParams != NULL && (DWORD64)pParams > 0x000007FFF0000000ll)
		{
			clog << pParams << std::endl;
			clog << " Name: " << ((UObject*) pParams)->GetFullName();
		}

		clog << " Result:  Addr:"   << SDKMC_SSHEX(pResult, 8);

		if( pResult != NULL && (DWORD64)pResult > 0x000007FFF0000000ll)
		{
			clog << pResult << std::endl;
			clog << " Name: " << ((UObject*)pResult)->GetFullName();
		}

	}
	clog << std::endl;
	// call original function
	// (*(ProcessEventPtr)_vmt->GetOriginalFuncPtr(ProcessEvent_Index))(pthis,  pFunction, pParams, pResult);
	// pOriginalProcessEvent(pthis,  pFunction, pParams, pResult);
}


void DumpH7Command(UH7Command* command)
{
	clog << "Command_Dump: is_run: " << command->mRunning << " type: " << std::dec << (int)command->mCommandType;
	if( command->mPath.Data){
		clog << " Path:"; 
		for ( int i = 0; i < command->mPath.Count; i++){
			clog << " X:" << command->mPath.Data[i]->mPosition.X;
            clog << " Y:" << command->mPath.Data[i]->mPosition.Y;
		}
	}

	if( command->mSource )
	{
		clog << " " << command->mSource->GetFullName();
		if( !strcmp("H7CreatureStack TheWorld.PersistentLevel.H7CreatureStack", command->mSource->GetFullName() ))
		{
			AH7CreatureStack* creature = (AH7CreatureStack*) command->mSource;
			clog << " Source stack size: " << creature->mStackSize << " Top stack size: " << creature->mTopCreatureHealth;
			clog << " grid pos: (" << creature->mGridPos.X << "," << creature->mGridPos.Y << ")";
		}
	}
	clog << "\n";
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
	clog << "Base Address: " << SDKMC_SSHEX(baseAddress,8) << "\n";
	// get GObjects
	GObjects =  baseAddress + GObjects_Offset;

	clog << "GObjects Address: " << SDKMC_SSHEX(GObjects, 8) << "\n";

	GNames =  baseAddress + GNames_Offset;

	clog << "GNames Address: " << SDKMC_SSHEX(GNames, 8) << std::endl;

}


// #include "./hard_hack/ProcEventTempl.h"
