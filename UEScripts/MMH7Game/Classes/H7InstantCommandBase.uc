//=============================================================================
// H7InstantCommandBase
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandBase extends Object;

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand mpData )
{
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
}

function Execute()
{
}

/**
 * Sim Turns:
 * Determines if this instant command waits for ongoing move/startCombat commands in the area of the command location
 */
function bool WaitForInterceptingCommands()
{
	return false;
}

/**
 * Sim Turns:
 * used to check for intersection with ongoing move commands
 */
function Vector GetInterceptLocation()
{
	return Vect(0, 0, 0);
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return none;
}
