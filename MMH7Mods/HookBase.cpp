#include "StdAfx.h"
#include <fstream>
#include <iomanip>
#include "CombatDumper.h"
#include "HookBase.h"
#include "SdkClasses.h"



HooksHolderPtr __hooksHolder(new HooksHolder());
const std::string logpath("C:\\Users\\Dima\\Documents\\GitHub\\Might-And-Magic-Heroes-VII-Mods\\logs\\mod_inject.log");
std::ofstream clog(logpath.c_str());

///
/// Declare static features
///
CombatFeaturizerPtr _combatFeatures;

HooksHolder& HooksHolder::GetHolder()
{
	return *__hooksHolder;
}

HookFunction::HookFunction(HookBase *pBase, const char* name) : 
              _pBase(pBase)
{
	func_idx =  __hooksHolder->__hook_func_list.GetSize();
	__hooksHolder->__hook_func_list.Add(name, this);
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
	_combatFeatures.reset(new CombatFeaturizer());
	(*__hooksHolder)(CombatDumperPtr(new CombatDumper(clog, _combatFeatures)));
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
		int retval = 0;
		if (__hooksHolder->CallFunc(func, This, Stack_frame, pResult, retval) )
		    return retval;

	}

	retval = ((ProcessInternalPtr)OriginalProcessInternal->get())(This,  Stack_frame, pResult);

  return retval;
}

