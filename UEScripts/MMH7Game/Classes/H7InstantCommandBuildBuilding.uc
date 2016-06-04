//=============================================================================
// H7InstantCommandBuildBuilding
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandBuildBuilding extends H7InstantCommandBase;

var private H7Town mTown;
var private string mBuildingId;

function Init( H7Town town, string buildingId )
{
	mTown = town;
	mBuildingId = buildingId;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mTown = H7Town(eventManageable);
	mBuildingId = command.StringParameter;
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_BUILD_BUILDING;
	command.StringParameter = mBuildingId;
	command.IntParameters[0] = mTown.GetID();
	
	return command;
}

function Execute()
{
	local H7AdventureHud hud;

	mTown.BuildBuildingComplete( mBuildingId );

	// notify gui
	if(mTown.GetPlayer().IsControlledByLocalPlayer())
	{
		hud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();
		if(hud.GetTownBuildingCntl().GetPopup().IsVisible())
		{
			hud.GetTownBuildingCntl().BuildBuilingComplete();
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
