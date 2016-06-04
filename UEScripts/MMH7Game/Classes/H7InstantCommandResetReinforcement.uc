//=============================================================================
// H7InstantCommandRecruit
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandResetReinforcement extends H7InstantCommandBase;

var private H7AdventureArmy mArmy;
var private H7AdventureArmy mGarrisonedArmy;

function Init( H7AdventureArmy army, H7AdventureArmy garrisonedArmy )
{
	mArmy = army;
	mGarrisonedArmy = garrisonedArmy;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mArmy = H7AdventureHero(eventManageable).GetAdventureArmy();
	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[1] );
	mGarrisonedArmy = H7AdventureHero(eventManageable).GetAdventureArmy();
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_RESET_REINFORCEMENT;
	command.IntParameters[0] = mArmy.GetHero().GetID();
	command.IntParameters[1] = mGarrisonedArmy.GetHero().GetID();
	
	return command;
}

function Execute()
{
	local H7Player pl;
	local H7AdventureHud hud;
	
	pl = mArmy.GetPlayer();
	mArmy.SetBaseCreatureStacksToCopy(pl.GetOriginalReinforcementStacksArmy());
	mGarrisonedArmy.SetBaseCreatureStacksToCopy(pl.GetOriginalReinforcementStacksTown());

	if(pl.IsControlledByLocalPlayer())
	{
		hud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();
		if(hud.GetCombatPopUpCntl().GetPopup().IsVisible())
		{
			hud.GetCombatPopUpCntl().ResetTeleportComplete();
		}
	}
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mArmy.GetPlayer();
}
