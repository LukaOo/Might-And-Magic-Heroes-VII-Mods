//=============================================================================
// H7InstantCommandUpgradeDwelling
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandUpgradeDwelling extends H7InstantCommandBase;

var private H7Dwelling mDwelling;

function Init( H7Dwelling dwelling )
{
	mDwelling = dwelling;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mDwelling = H7Dwelling(eventManageable);
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_UPGRADE_DWELLING;
	command.IntParameters[0] = mDwelling.GetID();
	
	return command;
}

function Execute()
{
	local H7AdventureHud hud;

	mDwelling.UpgradeComplete();

	// notify gui
	if(mDwelling.GetPlayer().IsControlledByLocalPlayer())
	{
		hud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();
		if(hud.GetTownRecruitmentCntl().GetPopup().IsVisible())
		{
			hud.GetTownRecruitmentCntl().UpgradeDwellingComplete();
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
	return mDwelling.GetLocation();
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mDwelling.GetPlayer();
}
