#include "stdafx.h"
#include "AIMod.h"
#include "SdkClasses.h"
#include "SDK_HEADERS\MMH7Game_f_structs.h"
#include "MMH7Mods.h"
#include "GameLog.h"
#include "AiAdventureMap.h"

AIModConfig::AIModConfig(const ModsConfig& config) :
	sectionName("AIMod"),
	isEnabled(config.GetValue((sectionName + "/Enabled").c_str(), false)),
	isAdventureMapEnabled(config.GetValue((sectionName + "/AdventureMapEnabled").c_str(), true)),
	isCombatEnabled(config.GetValue((sectionName + "/AdventureMapEnabled").c_str(), true))
{

}

AIMod::AIMod(const ModsConfig& config) : HookBase("AIMod"),
             _config( config ),
	        _fAiAdventureMap_Think(this)
{

}

AIMod::~AIMod()
{
}

int  AIMod::AiAdventureMap_ThinkFunc(__int64 This, __int64 Stack_frame, void* pResult)
{
	AH7AiAdventureMap* aiAdvMap = (AH7AiAdventureMap*)This;
	FFrame * Stack = (FFrame*)Stack_frame;
	AH7AiAdventureMap_execThink_Parms* Think_Parms = (AH7AiAdventureMap_execThink_Parms*)Stack->Locals;
	

	AH7AdventureController* controller = (AH7AdventureController*) UObject::FindObject<UObject>("Class MMH7Game.H7AdventureController");
	if (controller == NULL) {
		LOG(LL_VERBOSE) << " Can not find object: AH7AdventureController " << "\n";		
	}
	else {
		controller = controller->GetInstance();
		if(aiAdvMap == NULL) LOG(LL_VERBOSE) << " AH7AiAdventureMap pointer is NULL " << "\n";
		else {
			if (Stack->Object == NULL) LOG(LL_VERBOSE) << "Stack UObject pointer is NULL \n";
			else {
				if (Think_Parms == NULL) {
					LOG(LL_NORMAL) << " Error getting Think parameters (NULL)\n";
				}
				else {
					AIAdventureMap aiThinkLogic(controller, aiAdvMap); 
					if (aiThinkLogic.Think(Think_Parms->Unit, Think_Parms->DeltaTime))
						return 0;
				}
			}
		}
	}

	int retval = ((ProcessInternalPtr)OriginalProcessInternal->get())(This, Stack_frame, pResult);

	return retval;
}

