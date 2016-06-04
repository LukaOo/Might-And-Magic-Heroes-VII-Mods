//=============================================================================
// H7InstantCommandStartCaravan
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandStartCaravan extends H7InstantCommandBase;

var private H7CaravanArmy mCaravan;
var private H7AreaOfControlSiteLord mInitialSite;

function Init( H7CaravanArmy caravan, H7AreaOfControlSiteLord initialSite )
{
	mCaravan = caravan;
	mInitialSite = initialSite;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mCaravan = H7CaravanArmy(H7AdventureHero(eventManageable).GetAdventureArmy());
	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[1] );
	mInitialSite = H7AreaOfControlSiteLord(eventManageable);
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_START_CARAVAN;
	command.IntParameters[0] = mCaravan.GetHero().GetID();
	command.IntParameters[1] = mInitialSite.GetID();

	return command;
}

function Execute()
{
	mCaravan.StartCaravanComplete( mInitialSite );
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
	return mInitialSite.GetLocation();
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mCaravan.GetPlayer();
}
