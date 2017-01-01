#include "stdafx.h"
#include "HookBase.h"
#include "SdkBase.h"
#include "SdkClasses.h"
#include "SDK_HEADERS\MMH7Game_f_structs.h"
#include "GameLog.h"

/*
# ========================================================================================= #
# Initialization														
# ========================================================================================= #
*/

struct ModObjectBuilder_execCreateCombatAI_Parms
{
	class AH7CombatController*                         controller; 
	class AH7AiCombatMap*                              ReturnValue;                                            		// 0x0054 (0x0050) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

struct ModObjectBuilder_execCreateAISensors_Parms
{
	TArray< class UH7AiSensorBase* >                   ReturnValue;                                          		// 0x0054 (0x0050) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

int InitAdventureAIFunc ( __int64 This, __int64 Stack_frame, void* pResult )
{
	AH7AdventureController* controller = (AH7AdventureController*)This;
	FFrame * Stack = (FFrame*) Stack_frame;

	static UFunction* pInitAdventureAIFunc = NULL;
	if ( ! pInitAdventureAIFunc )
		pInitAdventureAIFunc = (UFunction*) UObject::FindObject<UObject>("Function mmh7aimod.AIModAdventureAiBuilder.InitAdventureAI");
	LOG(LL_VERBOSE) << "InitAdventureAIFunc:modf " << pInitAdventureAIFunc << '\n';
	AH7AdventureController_execInitAdventureAI_Parms *fParams =  new AH7AdventureController_execInitAdventureAI_Parms();
	LOG(LL_VERBOSE) << "InitAdventureAIFunc:mAi1 " << controller->mAI << '\n';
	controller->ProcessEvent ( pInitAdventureAIFunc, fParams, NULL );
	LOG(LL_VERBOSE) << "InitAdventureAIFunc:mAi2 " << controller->mAI << '\n';
	return 0xfd59e56d;
}

int  InitInitCombatAI ( __int64 This, __int64 Stack_frame, void* pResult )
{
	AH7CombatController* controller = (AH7CombatController*)This;
	FFrame * Stack = (FFrame*) Stack_frame;
    int retval = ((ProcessInternalPtr)OriginalProcessInternal->get())(This,  Stack_frame, pResult);

	static UFunction* pInitCombatAIFunc = NULL;
	if ( ! pInitCombatAIFunc )
		pInitCombatAIFunc = (UFunction*) UObject::FindObject<UObject>("Function mmh7aimod.AIModObjectsBuilder.createCombatAI");
	LOG(LL_VERBOSE) << "InitInitCombatAI: modf" << pInitCombatAIFunc << '\n';
	ModObjectBuilder_execCreateCombatAI_Parms *fParams =  new ModObjectBuilder_execCreateCombatAI_Parms();
	fParams-> controller = controller;
	fParams->ReturnValue = NULL;
	controller->ProcessEvent ( pInitCombatAIFunc, fParams, NULL );
	controller->mAI = fParams->ReturnValue;
	LOG(LL_VERBOSE) << "InitInitCombatAI: mAi" << controller->mAI << '\n';
	return retval;
}

int  SetupCombatSensorsFunc ( __int64 This, __int64 Stack_frame, void* pResult )
{
	UH7AiCombatSensors* sensors = (UH7AiCombatSensors*)This;
	FFrame * Stack = (FFrame*) Stack_frame;
    int retval = ((ProcessInternalPtr)OriginalProcessInternal->get())(This,  Stack_frame, pResult);

	static UFunction* pSetupCombatSensors = NULL;
	if ( ! pSetupCombatSensors )
		pSetupCombatSensors = (UFunction*) UObject::FindObject<UObject>("Function mmh7aimod.AIModObjectsBuilder.createCombatAISensors");
	LOG(LL_VERBOSE) << "SetupCombatSensorsFunc: modf" << pSetupCombatSensors << '\n';
	ModObjectBuilder_execCreateAISensors_Parms *fParams = new ModObjectBuilder_execCreateAISensors_Parms();
	sensors->ProcessEvent (pSetupCombatSensors, fParams, NULL );
	memcpy(&sensors->mSensors, &fParams->ReturnValue, sizeof(fParams->ReturnValue));
 return retval;
}

int SetupAdventureSensorsFunc ( __int64 This, __int64 Stack_frame, void* pResult )
{
	UH7AiAdventureSensors* sensors = (UH7AiAdventureSensors*)This;
	FFrame * Stack = (FFrame*) Stack_frame;
    int retval = ((ProcessInternalPtr)OriginalProcessInternal->get())(This,  Stack_frame, pResult);
	static UFunction* pSetupAdventureSensors = NULL;
	if ( ! pSetupAdventureSensors )
		pSetupAdventureSensors = (UFunction*) UObject::FindObject<UObject>("Function mmh7aimod.AIModObjectsBuilder.createAdventureAISensors");
	LOG(LL_VERBOSE) << "SetupAdventureSensorsFunc:modf " << pSetupAdventureSensors << '\n';
	ModObjectBuilder_execCreateAISensors_Parms *fParams = new ModObjectBuilder_execCreateAISensors_Parms();
	sensors->ProcessEvent (pSetupAdventureSensors, fParams, NULL );
	memcpy(&sensors->mSensors, &fParams->ReturnValue, sizeof(fParams->ReturnValue));
    return retval; 
}
