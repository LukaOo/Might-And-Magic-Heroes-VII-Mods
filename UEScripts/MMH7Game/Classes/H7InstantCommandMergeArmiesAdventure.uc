//=============================================================================
// H7InstantCommandMergeArmies
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandMergeArmiesAdventure extends H7InstantCommandBase;

var private H7AdventureArmy mFromArmy;
var private H7AdventureArmy mToArmy;

function Init( H7AdventureArmy fromArmy, H7AdventureArmy toArmy )
{
	mFromArmy = fromArmy;
	mToArmy = toArmy;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	mFromArmy = class'H7AdventureController'.static.GetInstance().GetArmyByHeroID(command.IntParameters[0]);
	mToArmy = class'H7AdventureController'.static.GetInstance().GetArmyByHeroID(command.IntParameters[1]);
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_MERGE_ARMIES_ADVENTURE;
	command.IntParameters[0] = mFromArmy.GetHero().GetID();
	command.IntParameters[1] = mToArmy.GetHero().GetID();

	return command;
}

function Execute()
{
	local H7AdventureHud hud;
	//local bool success;

	mToArmy.MergeArmy(mFromArmy, true);
	
	// notify gui
	if(mFromArmy.GetPlayer().IsControlledByLocalPlayer())
	{
		hud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();
		if(hud.GetHeroTradeWindowCntl().GetPopUp().IsVisible())
		{
			hud.GetHeroTradeWindowCntl().CompleteTransfer(true);
		}
	}
}

/**
 * Sim Turns:
 * Determines if this instant command waits for ongoing move/startCombat commands in the area of the command location
 */
function bool WaitForInterceptingCommands()
{
	return true;
}

/**
 * Sim Turns:
 * used to check for intersection with ongoing move commands
 */
function Vector GetInterceptLocation()
{
	return mFromArmy.GetHero().GetLocation();
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mFromArmy.GetPlayer();
}
