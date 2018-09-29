#include "stdafx.h"
#include "SdkClasses.h"
#include "SDK_HEADERS\MMH7Game_f_structs.h"

#include "GameLog.h"
#include "AiAdventureMap.h"


AIAdventureMap::AIAdventureMap(AH7AdventureController* controller, 
	                           AH7AiAdventureMap* aiAdvMap,
	                           AH7AdventureGridManager* gridManager):
	_controller(controller),
	_aiAdvMap(aiAdvMap),
	_gridManager(gridManager)
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

	// at this point alwase attack first neutral
	if (numArmies > 0) {
		AH7AdventureHero* hero = (AH7AdventureHero*)Unit;
		LOG(LL_DEBUG) << "AI Role: " << int(hero->GetAiRole()) << "\n";
		LOG(LL_DEBUG) << "Init grid manager: " << _gridManager->IsInitialized() << "\n";
		if (_gridManager != NULL) {

			AH7AdventureArmy* advNeutralArmy = sensors_ctrl->GetNeutralArmyAdv(0);
			if (advNeutralArmy != NULL) {
				LOG(LL_DEBUG) << "Before army is attacked move to Location: " << advNeutralArmy->Location.X << ", " 
					          << advNeutralArmy->Location.Y << "," << advNeutralArmy->Location.Z << "\n";
				try {
					// grid manager does not have adventure controller pointer
					_gridManager->SetAdventureController(_controller);
					LOG(LL_DEBUG) << "Army set up adventure controller \n";
					AH7AdventureArmy* heroArmy = _gridManager->mAdventureController->GetSelectedArmy();
					if (heroArmy != NULL) {
						AH7AdventureHero* selectedHero = heroArmy->GetHero();
						if (selectedHero != NULL)
						{
							FVector herLoc = selectedHero->GetCell()->GetLocation();
							LOG(LL_DEBUG) << "Hero coord: " << herLoc.X << ", " << herLoc.Y << "\n";
							UH7AdventureMapCell* target =  _gridManager->GetCellByWorldLocation(advNeutralArmy->Location);
							LOG(LL_DEBUG) << "Target coord: " << target->GetLocation().X << ", " << target->GetLocation().Y << "\n";
							bool action_result = _gridManager->DoAttackArmy(advNeutralArmy->Location, 1, 1);
							LOG(LL_DEBUG) << "Army is attacked: " << int(action_result) << "\n";
						}
						else
						{
							LOG(LL_DEBUG) << "Can not get selected hero...\n";
						}
					}
				}
				catch (...)
				{
					LOG(LL_DEBUG) << "Unreal exeption...\n";
				}
			}
			else {
			   LOG(LL_DEBUG) << "Can not get adventure neutrals Army...\n";
			}

		}
		else {
		  LOG(LL_DEBUG) << "Can not create object UH7AiActionParam...\n";
		}

	}

	LOG(LL_DEBUG) << "Finished heroes turn...\n";
	_controller->FinishHeroTurn();
	_aiAdvMap->mThinkStep = 0;

	return result;
}