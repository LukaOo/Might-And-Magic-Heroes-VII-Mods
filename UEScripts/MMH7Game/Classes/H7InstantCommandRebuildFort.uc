//=============================================================================
// H7InstantCommandRebuildFort
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandRebuildFort extends H7InstantCommandBase;

var protected H7Fort mFort;
var protected H7AdventureHero mVisitingHero;

function Init( H7Fort fort, H7AdventureHero visitingHero )
{
	mFort = fort;
	mVisitingHero = visitingHero;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mFort = H7Fort(eventManageable);

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[1] );
	mVisitingHero = H7AdventureHero(eventManageable);
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_REBUILD_FORT;
	command.IntParameters[0] = mFort.GetID();
	command.IntParameters[1] = mVisitingHero.GetID();
	
	return command;
}

function Execute()
{
	mFort.ConfirmRebuildComplete();
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
	return mFort.GetLocation();
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mVisitingHero.GetPlayer();
}
