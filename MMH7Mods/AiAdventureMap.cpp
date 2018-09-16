#include "stdafx.h"
#include "SdkClasses.h"
#include "SDK_HEADERS\MMH7Game_f_structs.h"

#include "GameLog.h"
#include "AiAdventureMap.h"


AIAdventureMap::AIAdventureMap(AH7AdventureController* controller, AH7AiAdventureMap* aiAdvMap):
	_controller(controller),
	_aiAdvMap(aiAdvMap)
{
}


AIAdventureMap::~AIAdventureMap()
{
}

bool AIAdventureMap::Think(AH7Unit* Unit, float DeltaTime) 
{
	bool result = true;
	
	if (!_lock.try_lock()) return result;

	Locker lock_func(_lock);

	if ( _aiAdvMap->IsAiEnabled()) LOG(LL_DEBUG) << "AIAdventureMap::Think >> AiAdventureMap_ThinkFunc::AI enabled.\n";
	else LOG(LL_DEBUG) << "AIAdventureMap::Think >> AiAdventureMap_ThinkFunc::AI disabled.\n";

	if (Unit->GetEntityType() == 0) 
	{
		LOG(LL_DEBUG) << "AIAdventureMap::Think >> Unit hero\n";
	}

	// Get sensors input
	UH7AiSensorInputConst* sensors_ctrl = _aiAdvMap->mSensors->GetSensorIConsts();
	//sensors_ctrl->SetTargetTown(NULL);
	LOG(LL_DEBUG) << "AIAdventureMap::Think >> Input const calculate step: " << sensors_ctrl->mCalcStep << "\n";
	LOG(LL_DEBUG) << "AIAdventureMap::Think >> Delta time: " << DeltaTime << "\n";
	LOG(LL_DEBUG) << "AIAdventureMap::Think >> Think step: " << _aiAdvMap->mThinkStep << "\n";

	_aiAdvMap->mSensors->UpdateConsts(0, 1);
 	LOG(LL_DEBUG) << "Update consts. \n";
	sensors_ctrl->ResetCalcStep();
	int numArmies = sensors_ctrl->GetNeutralArmyNumAdv();
	LOG(LL_DEBUG) << "Number of neutral armies: " << numArmies << "\n";

	_controller->FinishHeroTurn();
	_aiAdvMap->mThinkStep = 0;
	
	return result;
}