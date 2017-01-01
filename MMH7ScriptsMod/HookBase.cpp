#include "StdAfx.h"
#include <fstream>
#include <iomanip>
#include "HookBase.h"
#include "SdkClasses.h"
#include "GameLog.h"


HooksHolderPtr __hooksHolder;

///
/// Declare static features
///

HooksHolder& HooksHolder::GetHolder()
{
	return *__hooksHolder;
}

HookFunction::HookFunction(const char* name)
{
	__hooksHolder->__hook_func_list.Add(name, this);
}

HookFunctionToCallback::HookFunctionToCallback(const char* name, int (*callback)(__int64 This, __int64 Stack_frame, void* pResult)) : 
              HookFunction(name)
{
	_callback = callback;
}

int HookFunctionToCallback::Func(__int64 This, __int64 Stack_frame, void* pResult) {
	return _callback(This, Stack_frame, pResult);
}

bool HooksHolder::CallFunc(const std::string& funcName,
	                      __int64 This, __int64 Stack_frame, void* pResult,
	                      int& result)
{
	bool success = false;
	result=0;
	HookFunction* pHookFunc =  __hook_func_list.Get(funcName);
	if( pHookFunc ) 
	{ 
		result = pHookFunc->Func(This, Stack_frame, pResult);
		success = true;
	}
  return success;
}

void Init_Functions()
{

}

bool is_f_filter(char* fname)
{
	if( !strcmp(fname, "Function MMH7Game.H7CombatMapCell.SetForeshadow")) return true;
	if( !strcmp(fname,"Function MMH7Game.H7CombatMapCell.UpdateSelectionType")) return true;
	if( !strcmp(fname,"Function MMH7Game.H7CombatMapCell.GetObstacle")) return true;
  return false;
}

int __fastcall hkProcessInternal ( __int64 This, __int64 Stack_frame, void* pResult )
{
	FFrame* pStack = (FFrame*) Stack_frame;
	UObject* pthis = (UObject* ) This;
    int retval = 0;

	PDWORD64 _pdwVMT = (PDWORD64) *(DWORD64*) pthis;
	//LOG(LL_VERBOSE) << pthis->GetFullName()<< "vm PE adress:" << SDKMC_SSHEX(_pdwVMT[ProcessEvent_Index], 8) <<"\n";

	if ( pStack && pthis &&  !is_f_filter( pStack->Node->GetFullName() ) )
	{
		if( __gLog->Level() == LL_DEBUG )
		{
			LOGTS(LL_VERBOSE)  << " [" << GetCurrentThreadId() << "] Object: " << SDKMC_SSHEX(pthis, 8) << ", name: " << pthis->GetFullName();
			if ( pStack->Node )
			{
				LOG(LL_DEBUG) << ", func: " << pStack ->Node->GetFullName();  
			}
			LOG(LL_VERBOSE) << "\n";
		}
		std::string func(pStack ->Node->GetFullName());
		int retval = 0;
		
			//LOG(LL_VERBOSE) << "Execution try: "<< pthis->GetFullName() <<", func: " << func << '\n'; 
		if (__hooksHolder->CallFunc(func, This, Stack_frame, pResult, retval) ) {
			//LOG(LL_VERBOSE) << "Execution done: "<< pthis->GetFullName() <<", func: " << func << '\n';
		    return retval;
		} else {
			//LOG(LL_DEBUG) << "Execution problem: " << pStack->Node->GetFullName() << '\n'; 
			//Function is not hooked
		}


	}
	//LOG(LL_VERBOSE) << "Execution org try: " << pStack->Node->GetFullName() << "-" << pthis <<'\n'; 
	retval = ((ProcessInternalPtr)OriginalProcessInternal->get())(This,  Stack_frame, pResult);
	//LOG(LL_VERBOSE) << "Execution org done: " << pStack->Node->GetFullName() << '\n'; 
  return retval; 
}

