//=============================================================================
// H7InstantCommandDestroyTownBuildings
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandDestroyTownBuildings extends H7InstantCommandBase;

var private H7Town mTown;
var private int mLevel;

function Init( H7Town town, int level )
{
	mTown = town;
	mLevel = level;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mTown = H7Town(eventManageable);
	mLevel = command.IntParameters[1];
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_DESTROY_TOWN_BUILDINGS;
	command.IntParameters[0] = mTown.GetID();
	command.IntParameters[1] = mLevel;
	
	return command;
}

function Execute()
{
	local H7AdventureHud hud;

	mTown.DestroyBuildingsOfLevelComplete( mLevel, false );

	if(mTown.GetPlayer().IsControlledByLocalPlayer())
	{
		hud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();
		if(hud.GetTownBuildingCntl().GetPopup().IsVisible())
		{
			hud.GetTownBuildingCntl().DestroyLevelComplete();
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
	return mTown.GetLocation();
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mTown.GetPlayer();
}
