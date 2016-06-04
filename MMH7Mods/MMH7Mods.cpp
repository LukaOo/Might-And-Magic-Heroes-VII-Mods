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




#pragma comment( lib, "psapi.lib" )

const std::string logpath("C:\\Users\\Dima\\Documents\\GitHub\\Might-And-Magic-Heroes-VII-Mods\\logs\\mod_inject.log");
std::ofstream clog(logpath.c_str());

DWORD64 GObjects = 0;
DWORD64 GNames = 0;
DWORD64 ModuleBaseAddr = 0;
std::shared_ptr<VMTManager> _vmt;
std::shared_ptr<CombatDumper> _combat_dumper;
ProcessInternalHooks _hook_func_list;

///
/// Declare static features
///
CombatFeaturizerPtr _combatFeatures;

//void init_ptrs_list(); 
//DWORD64 funcs_ptrs[0x58]; 

const DWORD ProcessEventsLength = 0x24A;

std::set<std::string> __functions_filter;

bool is_f_filter(char* fname)
{
	if( !strcmp(fname, "Function MMH7Game.H7CombatMapCell.SetForeshadow")) return true;
	if( !strcmp(fname,"Function MMH7Game.H7CombatMapCell.UpdateSelectionType")) return true;
	if( !strcmp(fname,"Function MMH7Game.H7CombatMapCell.GetObstacle")) return true;
  return false;
}

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
  // Initialize core pointers 
  Init_Core();

  // Initialize all function to be detoured
  Init_Functions();

  _combatFeatures.reset(new CombatFeaturizer());
  _combat_dumper.reset(new CombatDumper(clog, _combatFeatures) );
   
  UObject* pObject = UObject::GObjObjects()->Data[UObject_index];
  UFunction* pAICombatMapThink = (UFunction*)UObject::FindObject<UObject>(FUNCTION_THINK);
  if( pAICombatMapThink != NULL)
  {
	  clog << "pAICombatMapThink: addr " << SDKMC_SSHEX(pAICombatMapThink,8) << " func addr: " <<  SDKMC_SSHEX(pAICombatMapThink->Func,8) 
		   << " Offset: " << SDKMC_SSHEX((DWORD64)pAICombatMapThink->Func - ModuleBaseAddr,8) << "\n"; 
  }
 // clog << "Object Name: " << pObject->GetFullName() << "\n";
 // for ( int i = 0; i < UObject::GObjObjects()->Num(); i++ ){
 //		UObject* p = UObject::GObjObjects()->Data[ i ];
 //		if ( ! p )
 //			continue;
 // 		clog <<  "Object: "<<  p->GetFullName() << " num: " << i << " nidx: " << p->Name.Index << " addr:" <<SDKMC_SSHEX(p,8) << "\n";
 // }
   
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

  
  //int c =  _vmt->GetCountSize();
  
  //for( int x=0; x < c; x++)
  //{
  //    clog << "\tHooking ProcessEvent: Index: " << x << " ptr: " << SDKMC_SSHEX(funcs_ptrs[x],8) << std::endl;
  //   _vmt->HookFunction((void*)funcs_ptrs[82], 82);
  //}

  //_vmt->DumpVmt(clog);
	 //Sleep(10000);
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

int __fastcall hkProcessInternal ( __int64 This, __int64 Stack_frame, void* pResult )
{
	FFrame* pStack = (FFrame*) Stack_frame;
	UObject* pthis = (UObject* ) This;
	bool isResolveCombat=false;
    

	if ( pStack && pthis &&  !is_f_filter( pStack->Node->GetFullName() ) )
	{
		time_t t = time(NULL);
		struct tm *tm = localtime(&t);
		char date[20];
		strftime(date, sizeof(date), "%Y-%m-%d %H:%M:%S", tm);
		clog << date << " [" << GetCurrentThreadId() << "] Object: " << SDKMC_SSHEX(pthis, 8) << ", name: " << pthis->GetFullName();
		if ( pStack->Node )
		{
			clog << ", func: " << pStack ->Node->GetFullName();  
		}
		std::string func(pStack ->Node->GetFullName());

		ProcessInternalPtr pHookFunc =  _hook_func_list.Get(func);
		if( pHookFunc ) return pHookFunc(This, Stack_frame, pResult);

		if ( pStack->Locals != NULL && !strcmp("Function MMH7Game.H7CommandQueue.StartUnitCommand", pStack ->Node->GetFullName() ))
		{
			UH7CommandQueue_execStartUnitCommand_Parms *params = (UH7CommandQueue_execStartUnitCommand_Parms*) pStack->Locals;
			clog << " Playerindex: " << params->PlayerIndex;
		}

		if ( pStack->Locals != NULL && !strcmp("Function MMH7Game.H7CreatureStack.DataChanged", pStack ->Node->GetFullName() ))
		{
			AH7CreatureStack_execDataChanged_Parms *params = (AH7CreatureStack_execDataChanged_Parms* ) pStack->Locals;
			if( params && params->cause.Data ){
				std::wstring s(params->cause.Data);
				std::string  s2(s.begin(), s.end());
				clog << " Len: " << params->cause.Count << " cause: " << s2.c_str();
				
			}
		}

		if ( pStack->Locals != NULL && !strcmp("Function MMH7Game.H7CommandQueue.Enqueue", pStack ->Node->GetFullName() ))
		{
			UH7CommandQueue_execEnqueue_Parms* params = (UH7CommandQueue_execEnqueue_Parms*) pStack->Locals;
			if( params->Cmd )
			{
				clog << " Command type: " << (int) params->Cmd->mCommandType; 
				if( params->Cmd->mPath.Data){
					clog << " Path:"; 
					for ( int i = 0; i < params->Cmd->mPath.Count; i++){
						clog << " X:" << params->Cmd->mPath.Data[i]->mPosition.X;
                        clog << " Y:" << params->Cmd->mPath.Data[i]->mPosition.Y;
					}
				}

				if( params->Cmd->mSource )
					clog << " Source: " << params->Cmd->mSource->GetFullName(); 
			

				if( params->Cmd->mAbility )
					clog << " Ability: " << params->Cmd->mAbility->GetFullName();

				if( params->Cmd->mAbilityTarget )
					clog << " Ability Target: " << params->Cmd->mAbilityTarget->GetFullName();

			}
		}


		if ( pStack->Locals != NULL && !strcmp("Function MMH7Game.H7GameProcessor.ResolveCombat", pStack ->Node->GetFullName() ))
		{
           UH7GameProcessor_execResolveCombat_Parms* params = (UH7GameProcessor_execResolveCombat_Parms*) pStack->Locals;
		   isResolveCombat = true;
		   if( params )
		   {
			   clog << " isMainResult: " << params->isMainResult << " retvalue: " << params->ReturnValue << 
				   "result action: " << SDKMC_SSHEX(params->Result, 8);
		   }
		}

		if( pStack->Locals != NULL &&!strcmp("Function MMH7Game.H7CreatureStack.MoveCreature",  pStack ->Node->GetFullName()) )
		{
		   
		   AH7CreatureStack_execMoveCreature_Parms* params = (AH7CreatureStack_execMoveCreature_Parms*) pStack->Locals;
		   clog << " Sizeof path: " << params->Path.Count;
		      if (params->Target != NULL)
			  {
		         clog << " Move target name: " 
			     << params->Target->GetFullName();
			  }
            
		}

		if( pStack->Locals != NULL  && !strcmp(FUNCTION_THINK, pStack ->Node->GetFullName()))
		{
			AH7AiCombatMap_execThink_Parms* params = (AH7AiCombatMap_execThink_Parms*) pStack->Locals;

			clog <<", Unit addr: " << SDKMC_SSHEX(params->Unit, 8);

			if( params->Unit )
			{
		
				clog << " p1: " <<  SDKMC_SSHEX(params->Unit->VfTable_IH7IEffectTargetable.Dummy, 8)
					 << " p2: " << SDKMC_SSHEX(params->Unit->VfTable_IH7ICaster.Dummy, 8);
				clog << " name: " << params->Unit->mName.Data;
				//UFunction* pFunction = (UFunction*) *(__int64 *)(Stack_frame + 20);
				//if( pFunction != NULL && (DWORD64)pFunction > 0x000007FFF0000000ll )
				//{
				//	clog << " Name: " << pFunction->GetFullName();
				//}

				//clog   << " Function: Addr: " << SDKMC_SSHEX(pFunction, 8) << " In stack: " << SDKMC_SSHEX(pStack->Node, 8);
				//clog   << " Object: " << SDKMC_SSHEX(pStack->Object, 8) << " Stack: " << SDKMC_SSHEX(pStack->Stack, 8)
				//	   << " Locals: " << SDKMC_SSHEX(pStack->Locals, 8);
				//clog << " Result: Addr: " << SDKMC_SSHEX(pResult, 8);
			}
	
			
		}

		clog << std::endl;
	}

	int retval = ((ProcessInternalPtr)OriginalProcessInternal->get())(This,  Stack_frame, pResult);

	if ( isResolveCombat ){

		UH7GameProcessor_execResolveCombat_Parms* params = (UH7GameProcessor_execResolveCombat_Parms*) pStack->Locals;
		
		if( params && params->Result )
		{
			clog << " isMainResult: " << params->isMainResult << " retvalue: " << params->ReturnValue << 
				    "result action: " << params->Result->mAction << std::endl;
		}
	}

  return retval;
}

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

	clog << "GNames Address: " << SDKMC_SSHEX(GNames, 8) << "\n";
}

void Init_Functions()
{
	_hook_func_list.Add("Function MMH7Game.H7Command.CommandPlay", hkH7Command_CommandPlay);
	_hook_func_list.Add("Function MMH7Game.H7Command.CommandStop", hkH7Command_CommandStop);
	_hook_func_list.Add("Function MMH7Game.H7CombatController.GetInstance", CombatDumper_ProcessInternal);
}


// #include "./hard_hack/ProcEventTempl.h"
