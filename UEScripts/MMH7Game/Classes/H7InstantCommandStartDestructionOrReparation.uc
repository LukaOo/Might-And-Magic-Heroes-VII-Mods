//=============================================================================
// H7InstantCommandStartDestructionOrReparation
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandStartDestructionOrReparation extends H7InstantCommandBase;

var private H7DestructibleObjectManipulator mDestructibleObjects;

function Init( H7DestructibleObjectManipulator destructibleObjects )
{
	mDestructibleObjects = destructibleObjects;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mDestructibleObjects = H7DestructibleObjectManipulator(eventManageable);
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_DESTRUCTION_OR_REPARATION;
	command.IntParameters[0] = mDestructibleObjects.GetID();
	
	return command;
}

function Execute()
{
	mDestructibleObjects.StartDestructionOrReparationComplete();
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
	return mDestructibleObjects.GetLocation();
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	if(mDestructibleObjects.GetVisitingArmy() != none)
	{
		return mDestructibleObjects.GetVisitingArmy().GetPlayer();
	}
	else
	{
		return class'H7AdventureController'.static.GetInstance().GetLocalPlayer();
	}
}
