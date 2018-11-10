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
			_pAdventureGridManager(NULL),
	        _pAdventureController(NULL),
			_pAttackingHero(NULL),
			_pDefendingHero(NULL),
	        _pCombatController(NULL),
	        _QuickCombatAllowed(1),
	        _fAiAdventureMap_Think(this),
			_fH7AdventureGridManager_PostBeginPlay(this),
	        _fGetInstance(this),
			_fH7InstantCommandDoCombat_Init(this),
	        _fH7InstantCommandDoCombat_Execute(this),
			_fH7CombatController_EndOfCombat_TravelBack(this),
			_fH7CombatController_GetInstance(this),
			_fH7AdventureController_DoBackToAdventureFromCombat(this)
{

}

AIMod::~AIMod()
{
}

int AIMod::H7AdventureGridManager_PostBeginPlay(__int64 This, __int64 Stack_frame, void* pResult)
{
	_pAdventureGridManager = (AH7AdventureGridManager*)This;
	FFrame* pStack = (FFrame*)Stack_frame;

	int retval = ((ProcessInternalPtr)OriginalProcessInternal->get())(This, Stack_frame, pResult);

	return retval;
}

int AIMod::GetInstanceFun(__int64 This, __int64 Stack_frame, void* pResult)
{
	FFrame* pStack = (FFrame*)Stack_frame;

	int retval = ((ProcessInternalPtr)OriginalProcessInternal->get())(This, Stack_frame, pResult);

	AH7AdventureController_execGetInstance_Parms* params = (AH7AdventureController_execGetInstance_Parms*)pResult;
	_pAdventureController = params->ReturnValue;
	if (_pAdventureController != NULL && _QuickCombatAllowed)
	{  
		// try disable quick combat
		_QuickCombatAllowed = _pAdventureController->GetAIAllowQuickCombat();
		LOG(LL_DEBUG) << "Try to disable ai quick comba, before" << _QuickCombatAllowed << "\n";
		_pAdventureController->SetAIAllowQuickCombat(0);
		_QuickCombatAllowed = _pAdventureController->GetAIAllowQuickCombat();

		LOG(LL_DEBUG) << "Try to disable ai quick combat, after" << _QuickCombatAllowed << "\n";
	}

	return retval;
}

int AIMod::H7AdventureController_DoBackToAdventureFromCombat(__int64 This, __int64 Stack_frame, void* pResult)
{
	FFrame* pStack = (FFrame*)Stack_frame;

	AH7AdventureController_execDoBackToAdventureFromCombat_Parms* pParams = (AH7AdventureController_execDoBackToAdventureFromCombat_Parms*)pStack->Locals;
	UH7AdventureMapCell* prevCell = NULL;
	FVector location;
	if (pParams != NULL && pParams->defeatArmy != NULL) 
	{
		prevCell = pParams->defeatArmy->GetCell();
		location = pParams->defeatArmy->Location;
	}
	int retval = ((ProcessInternalPtr)OriginalProcessInternal->get())(This, Stack_frame, pResult);

	if (pParams != NULL && pParams->defeatArmy != NULL && prevCell == 0)
	{
		// pParams->defeatArmy->mIsDead = 0;
		// pParams->defeatArmy->SetLocation(location);
		// pParams->defeatArmy->SetCell(prevCell, 1, 1, 1);
		// pParams->defeatArmy->ShowArmy();
		char * name = pParams->defeatArmy->GetFullName();
		LOG(LL_DEBUG) << "H7AdventureController_DoBackToAdventureFromCombat. DefeatArmy is " << name << "\n";
	}

	return retval;
}

int AIMod::H7InstantCommandDoCombat_Init(__int64 This, __int64 Stack_frame, void* pResult)
{
	UH7InstantCommandDoCombat* instantManager = (UH7InstantCommandDoCombat*)This;
	FFrame * Stack = (FFrame*)Stack_frame;
	UH7InstantCommandDoCombat_execInit_Parms* pInit_Params = (UH7InstantCommandDoCombat_execInit_Parms*)Stack->Locals;
	if ( pInit_Params != NULL )
	{
		_pAttackingHero = pInit_Params->attackingHero;
		_pDefendingHero = pInit_Params->defendingHero;

		if (!_QuickCombatAllowed && pInit_Params->isQuickCombat) {

			LOG(LL_DEBUG) << "H7InstantCommandDoCombat_Init QuickCombat flag is " << pInit_Params->isQuickCombat << "\n";
			pInit_Params->isQuickCombat = 0;
		}
	}
	int retval = ((ProcessInternalPtr)OriginalProcessInternal->get())(This, Stack_frame, pResult);
	
	return retval;
}

int AIMod::H7InstantCommandDoCombat_Execute(__int64 This, __int64 Stack_frame, void* pResult)
{
	UH7InstantCommandDoCombat* instantManager = (UH7InstantCommandDoCombat*)This;
	FFrame * Stack = (FFrame*)Stack_frame;
	int retval = 1;
	if (!_QuickCombatAllowed && _pAttackingHero != NULL && _pDefendingHero != NULL) {

		LOG(LL_DEBUG) << "H7InstantCommandDoCombat_Execute QuickCombat flag is " << _QuickCombatAllowed << "\n";
		_pAttackingHero->GetAdventureArmy()->CleanAllCombatMergePools();
		_pDefendingHero->GetAdventureArmy()->CleanAllCombatMergePools();
		if (_pDefendingHero->WorldInfo != NULL) {
			AH7PlayerReplicationInfo*  replicationInfo = ( AH7PlayerReplicationInfo*) _pDefendingHero->WorldInfo->GetALocalPlayerController()->PlayerReplicationInfo;
			if (replicationInfo != NULL)
			{
				// set combat player as spectator
				replicationInfo->SetCombatPlayerType(2);
			}
		}
		LOG(LL_DEBUG) << "H7InstantCommandDoCombat_Execute Start combat map \n";
		instantManager->StartCombatMap();
		LOG(LL_DEBUG) << "H7InstantCommandDoCombat_Execute End combat map \n";
	}
	else {
	    retval = ((ProcessInternalPtr)OriginalProcessInternal->get())(This, Stack_frame, pResult);
	}

	return retval;
}

int AIMod::H7CombatController_EndOfCombat_TravelBack(__int64 This, __int64 Stack_frame, void* pResult)
{
	if (_pCombatController != NULL) {
		bool comingFromAdvMap = _pCombatController->IsCombatComingFromAdventureMap();
		LOG(LL_DEBUG) << " H7CombatController_EndOfCombat_TravelBack IsCombatComingFromAdventureMap " << comingFromAdvMap << "\n";
	}
	int retval = ((ProcessInternalPtr)OriginalProcessInternal->get())(This, Stack_frame, pResult);

	return retval;
}

int AIMod::H7CombatController_GetInstance(__int64 This, __int64 Stack_frame, void* pResult)
{
	FFrame* pStack = (FFrame*)Stack_frame;

	int retval = ((ProcessInternalPtr)OriginalProcessInternal->get())(This, Stack_frame, pResult);

	AH7CombatController_execGetInstance_Parms* params = (AH7CombatController_execGetInstance_Parms*)pResult;
	_pCombatController = params->ReturnValue;

	return retval;
}


int  AIMod::AiAdventureMap_ThinkFunc(__int64 This, __int64 Stack_frame, void* pResult)
{
	AH7AiAdventureMap* aiAdvMap = (AH7AiAdventureMap*)This;
	FFrame * Stack = (FFrame*)Stack_frame;
	AH7AiAdventureMap_execThink_Parms* Think_Parms = (AH7AiAdventureMap_execThink_Parms*)Stack->Locals;
	
	if (_pAdventureController == NULL) {
		LOG(LL_VERBOSE) << " Can not find object: AH7AdventureController " << "\n";		
	}
	else {
		if(aiAdvMap == NULL) LOG(LL_VERBOSE) << " AH7AiAdventureMap pointer is NULL " << "\n";
		else {
		if (_pAdventureGridManager == NULL) LOG(LL_VERBOSE) << " AdventureGridManager pointer is NULL " << "\n";
		else {
			if (Stack->Object == NULL) LOG(LL_VERBOSE) << "Stack UObject pointer is NULL \n";
			else {
					if (Think_Parms == NULL) {
						LOG(LL_NORMAL) << " Error getting Think parameters (NULL)\n";
					}
					else {
						AIAdventureMap aiThinkLogic(_pAdventureController, aiAdvMap, _pAdventureGridManager);
						if (aiThinkLogic.Think(Think_Parms->Unit, Think_Parms->DeltaTime))
							return 0;
					}
				}
			}
		}
	}

	int retval = ((ProcessInternalPtr)OriginalProcessInternal->get())(This, Stack_frame, pResult);

	return retval;
}

