#include "StdAfx.h"
#include "HookBase.h"
#include "SdkBase.h"
#include "SdkClasses.h"
#include "SDK_HEADERS\MMH7Game_f_structs.h"
#include "GameLog.h"
#include "ModsTests.h"

int InitHintsFunc ( __int64 This, __int64 Stack_frame, void* pResult )
{
	FFrame* pStack = (FFrame*) Stack_frame;
	UObject* pthis = (UObject* ) This;
	UH7LoadingHints *hints = (UH7LoadingHints *) This;
    int retval = ((ProcessInternalPtr)OriginalProcessInternal->get())(This,  Stack_frame, NULL);
	//hints->mUsedHints.Clear();
	//hints->ProcessEvent ( pFnGetHints, &GetHints_Parms, NULL );
	for (int i=0; i<hints->mUsedHints.Num(); i++) {
		std::string hint("Scripts Mod is Enabled!");
		wchar_t* pHint = new wchar_t[ hint.length() + 1 ];
		std::copy( hint.begin(), hint.end(), pHint );
		//hints->mUsedHints(i) = pHint;
	}
	return retval;
}