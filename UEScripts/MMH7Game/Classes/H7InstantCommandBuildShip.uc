//=============================================================================
// H7InstantCommandBuildShip
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandBuildShip extends H7InstantCommandBase;

var private H7EditorHero mHero;
var private H7Shipyard mShipyard;

function Init( H7EditorHero hero, H7Shipyard shipyard )
{
	mHero = hero;
	mShipyard = shipyard;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mHero = H7EditorHero(eventManageable);

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[1] );
	mShipyard = H7Shipyard(eventManageable);
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_BUILD_SHIP;
	command.IntParameters[0] = mHero.GetID();
	command.IntParameters[1] = mShipyard.GetID();
	
	return command;
}

function Execute()
{
	mShipyard.BuildComplete();
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mHero.GetPlayer();
}
