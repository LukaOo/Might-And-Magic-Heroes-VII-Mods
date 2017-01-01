#include "StdAfx.h"
#include <fstream>
#include <iomanip>
#include <algorithm>
#include "HookBase.h"
#include "SdkClasses.h"
#include "GameLog.h"

HooksHolderPtr __hooksHolder;


HooksHolder& HooksHolder::GetHolder()
{
	return *__hooksHolder;
}

HookFunction::HookFunction(const char* name)
{
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

PrefixMapper::PrefixMapper(std::string *prefix,  std::vector<std::string> *exceptions) : HookFunction() {
	_exceptions = exceptions;
	_prefix = prefix;
}

int PrefixMapper::Func(__int64 This, __int64 Stack_frame, void* pResult) {
	UObject* pthis = (UObject* ) This;
	FFrame* pStack = (FFrame*) Stack_frame;
	std::string fname(pStack->Node->GetFullName());
	if (std::find(_exceptions->begin(), _exceptions->end(), fname) != _exceptions->end()) {
		return 0;
	}
	fname.replace(0, _prefix->length(), *_targetPrefix);
	UFunction* targetFunction = (UFunction*) UObject::FindObject<UObject>(const_cast<char *>(fname.c_str()));
	if (!targetFunction) {
		return 0;
	}
	pthis->ProcessEvent ( targetFunction, pStack->Locals, NULL );
	UProperty* rProperty;
			// function property array
		std::vector< UProperty* > vProperty;
			// get function properties
		for ( UProperty* pProperty = (UProperty*) pFunction->Children; pProperty; pProperty = (UProperty*) pProperty->Next )
		{
			if ( pProperty->ElementSize > 0 )
				vProperty.push_back ( pProperty );
		}
				// sort vProperty array using pProperty -> Offset
		sort ( vProperty.begin(), vProperty.end(), SortProperty );

	memcpy (pResult, &(pStack->Locals), sizeof(pStack->Locals) );
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
		
			LOG(LL_VERBOSE) << "Execution try: "<< pthis->GetFullName() <<", func: " << func << '\n'; 
		if (__hooksHolder->CallFunc(func, This, Stack_frame, pResult, retval) ) {
			LOG(LL_VERBOSE) << "Execution done: "<< pthis->GetFullName() <<", func: " << func << '\n';
		    return retval;
		}


	}
	LOG(LL_VERBOSE) << "Execution org try: " << pStack->Node->GetFullName() << "-" << pthis <<'\n'; 
	retval = ((ProcessInternalPtr)OriginalProcessInternal->get())(This,  Stack_frame, pResult);
	LOG(LL_VERBOSE) << "Execution org done: " << pStack->Node->GetFullName() << '\n'; 
  return retval; 
}

