//=============================================================================
// H7InstantCommandManager
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandManager extends Object;

// returns: command was successfully executed
function bool StartCommand(H7InstantCommandBase command)
{
	local MPInstantcommand commandData;
	local bool isTactics;

	if(class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame())
	{
		// no commands after ending the turn
		if(class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().HasEndedTurn())
		{
			return false;
		}

		// don't ever send any AI commands from clients to server
		if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() &&
			command.GetPlayer() != none && command.GetPlayer().IsControlledByAI() && !class'H7AdventureController'.static.GetInstance().GetAI().IsAiEnabled())
		{
			return false;
		}

		// no player commands allowed during AIs turn in simturns
		if( class'H7AdventureController'.static.GetInstance() != none && !class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() && class'H7AdventureController'.static.GetInstance().IsSimTurnOfAI() && !command.GetPlayer().IsControlledByAI())
		{
			return false;
		}

		commandData = command.CreateMPCommand();
		commandData.UnitActionsCounter = class'H7ReplicationInfo'.static.GetInstance().GetUnitActionsCounter();
		if(class'H7AdventureController'.static.GetInstance() != none)
		{
			commandData.CurrentPlayer = class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetPlayerNumber();
		}
		class'H7CombatPlayerController'.static.GetCombatPlayerController().SendInstantCommand(commandData);

		isTactics = class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() && class'H7CombatController'.static.GetInstance().IsInState('Tactics');
	}


	if(!class'H7CombatPlayerController'.static.GetCombatPlayerController().IsSimTurnCommandMode() && !isTactics)
	{
		// executes the command instantly in the client where it was fired.
		ExecuteInstantCommand(command);
		return true;
	}
	else if( class'H7AdventureController'.static.GetInstance() == none || command.GetPlayer() == class'H7AdventureController'.static.GetInstance().GetLocalPlayer() )
	{
		// Waits response from server in sim turns or combat tactics
		class'H7PlayerController'.static.GetPlayerController().SetCommandRequested(true);
		class'H7PlayerController'.static.GetPlayerController().GetHud().BlockAllFlashMovies();
	}

	return false;
}

function ExecuteInstantCommand(H7InstantCommandBase command)
{
	local bool isTactics;
	isTactics = class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() 
		&& class'H7CombatController'.static.GetInstance().IsInState('Tactics')
		&& class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame();

	if(class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() || isTactics)
	{
		if(class'H7AdventureController'.static.GetInstance() != none)
		{
			if(command.GetPlayer() == class'H7AdventureController'.static.GetInstance().GetLocalPlayer())
			{
				class'H7PlayerController'.static.GetPlayerController().SetCommandRequested(false);
				class'H7PlayerController'.static.GetPlayerController().GetHud().UnblockAllFlashMovies();
			}
		}
		else
		{
			if(command.GetPlayer() == class'H7CombatController'.static.GetInstance().GetLocalPlayer())
			{
				class'H7PlayerController'.static.GetPlayerController().SetCommandRequested(false);
				class'H7PlayerController'.static.GetPlayerController().GetHud().UnblockAllFlashMovies();
			}
		}
	}

	class'H7ReplicationInfo'.static.GetInstance().IncUnitActionsCounter();
	command.Execute();

	class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();
}

/**
 * Creates an Instant command instance from data send from multiplayer
 */
static function H7InstantCommandBase CreateInstantCommand(MPInstantCommand data)
{
	local H7InstantCommandBase command;

	switch( data.Type )
	{
		case ICT_CHEAT_BUILD_ALL:
			command = new class'H7InstantCommandBuildAll';
			break;
				
		case ICT_CHEAT_TELEPORT:
			command = new class'H7InstantCommandCheatTeleport';
			break;

		case ICT_END_TURN:
			command = new class'H7InstantCommandEndturn';
			break;

		case ICT_BEGIN_TURN:
			command = new class'H7InstantCommandBeginTurn';
			break;

		case ICT_HERO_ADD_XP:
			command = new class'H7InstantCommandHeroAddXp';
			break;

		case ICT_INCREASE_RESOURCE:
			command = new class'H7InstantCommandIncreaseResource';
			break;

		case ICT_TRADE_RESOURCE:
			command = new class'H7InstantCommandTransferResource';
			break;

		case ICT_TELEPORT_TO_TOWN:
			command = new class'H7InstantCommandTeleportToTown';
			break;

		case ICT_DO_COMBAT:
			command = new class'H7InstantCommandDoCombat';
			break;

		case ICT_INVENTORY_ACTION:
			command = new class'H7InstantCommandInventoryAction';
			break;
				
		case ICT_DISMISS_CREATURESTACK:
			command = new class'H7InstantCommandDismissCreatureStack';
			break;
				
		case ICT_SPLIT_CREATURESTACK:
			command = new class'H7InstantCommandSplitCreatureStack';
			break;

		case ICT_BUILD_BUILDING:
			command = new class'H7InstantCommandBuildBuilding';
			break;

		case ICT_TRANSFER_HERO:
			command = new class'H7InstantCommandTransferHero';
			break;
				
		case ICT_RECRUIT:
			command = new class'H7InstantCommandRecruit';
			break;

		case ICT_RECRUIT_DIRECT:
			command = new class'H7InstantCommandRecruitDirect';
			break;

		case ICT_UPGRADE_UNIT:
			command = new class'H7InstantCommandUpgradeUnit';
			break;
				
		case ICT_UPGRADE_DWELLING:
			command = new class'H7InstantCommandUpgradeDwelling';
			break;

		case ICT_RECRUIT_HERO:
			command = new class'H7InstantCommandRecruitHero';
			break;

		case ICT_DESTRUCTION_OR_REPARATION:
			command = new class'H7InstantCommandStartDestructionOrReparation';
			break;

		case ICT_SET_GOVERNOR:
			command = new class'H7InstantCommandSetGovernor';
			break;

		case ICT_START_CARAVAN:
			command = new class'H7InstantCommandStartCaravan';
			break;

		case ICT_REBUILD_FORT:
			command = new class'H7InstantCommandRebuildFort';
			break;

		case ICT_DESTROY_TOWN_BUILDINGS:
			command = new class'H7InstantCommandDestroyTownBuildings';
			break;

		case ICT_FLEE_OR_SURRENDER:
			command = new class'H7InstantCommandFleeOrSurrender';
			break;
				
		case ICT_CHEAT_STAT_CHANGE:
			command = new class'H7InstantCommandCheatStatChange';
			break;

		case ICT_CHEAT_WIN_LOSE:
			command = new class'H7InstantCommandCheatWinLose';
			break;

		case ICT_INCREASE_SKILL:
			command = new class'H7InstantCommandIncreaseSkill';
			break;

		case ICT_LEARN_ABILITY_FROM_SKILL:
			command = new class'H7InstantCommandLearnAbility';
			break;

		case ICT_OVERWRITE_SKILL:
			command = new class'H7InstantCommandOverwriteSkill';
			break;
				
		case ICT_JOIN_ARMY:
			command = new class'H7InstantCommandJoinArmy';
			break;

		case ICT_RECRUIT_WARFARE:
			command = new class'H7InstantCommandRecruitWarfare';
			break;

		case ICT_PLUNDER:
			command = new class'H7InstantCommandPlunder';
			break;

		case ICT_LET_GO:
			command = new class'H7InstantCommandLetEnemyFlee';
			break;

		case ICT_TRANSFER_STACK_FROM_MERGE_POOL:
			command = new class'H7InstantCommandTranferStackFromMergePool';
			break;

		case ICT_SELECT_SPECIALISATION:
			command = new class'H7InstantCommandSelectSpecialisation';
			break;

		case ICT_ENTER_LEAVE_SHELTER:
			command = new class'H7InstantCommandEnterLeaveShelter';
			break;

		case ICT_SET_AUTO_COMBAT:
			command = new class'H7InstantCommandSetAutoCombat';
			break;

		case ICT_SAVE_GAME:
			command = new class'H7InstantCommandSaveGame';
			break;

		case ICT_RECYCLE_ARTIFACT:
			command = new class'H7InstantCommandRecycleArtifact';
			break;

		case ICT_DOUBLE_ARMY:
			command = new class'H7InstantCommandDoubleArmy';
			break;

		case ICT_DISMISS_HERO:
			command = new class'H7InstantCommandDismissHero';
			break;

		case ICT_INCREASE_HERO_STAT:
			command = new class'H7InstantCommandIncreaseHeroStat';
			break;

		case ICT_BUY_SCROLL:
			command = new class'H7InstantCommandBuyScroll';
			break;

		case ICT_ACCEPT_MERGE:
			command = new class'H7InstantCommandAcceptMerge';
			break;

		case ICT_TRANSFER_WAR_UNIT:
			command = new class'H7InstantCommandTransferWarUnit';
			break;

		case ICT_SABOTAGE:
			command = new class'H7InstantCommandSabotage';
			break;

		case ICT_THIEVES_GUILD_PLUNDER:
			command = new class'H7InstantCommandThievesGuildPlunder';
			break;

		case ICT_BUY_ARTIFACT_MERCHANT:
			command = new class'H7InstantCommandBuyArtifactMerchant';
			break;

		case ICT_BUY_ARTIFACT_BLACK_MARKET:
			command = new class'H7InstantCommandBuyArtifactBlackMarket';
			break;

		case ICT_SELL_ARTIFACT:
			command = new class'H7InstantCommandSellArtifact';
			break;

		case ICT_SACRIFICE:
			command = new class'H7InstantCommandSacrifice';
			break;

		case ICT_RESET_REINFORCEMENT:
			command = new class'H7InstantCommandResetReinforcement';
			break;

		case ICT_CONFIRM_REINFORCEMENT:
			command = new class'H7InstantCommandConfirmReinforcement';
			break;
		
		case ICT_BUILD_SHIP:
			command = new class'H7InstantCommandBuildShip';
			break;

		case ICT_USE_FERTILITY_IDOL:
			command = new class'H7InstantCommandUseFertilityIdol';
			break;
		
		case ICT_RANDOM_ITEM_SITE:
			command = new class'H7InstantCommandRandomItemSIte';
			break;

		case ICT_MERGE_ARMIES_AI:
			command = new class'H7InstantCommandMergeArmiesAI';
			break;

		case ICT_UNIFY_ARMY:
			command = new class'H7InstantCommandUnifyStacks';
			break;

		case ICT_MERGE_ARMIES_LORD:
			command = new class'H7InstantCommandMergeArmiesLord';
			break;

		case ICT_MERGE_ARMIES_ADVENTURE:
			command = new class'H7InstantCommandMergeArmiesAdventure';
			break;
	}

	if(command != none)
	{
		command.InitFromMPData(data);
	}

	return command;
}
