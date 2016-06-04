//=============================================================================
// H7InstantCommandDismissCreatureStack
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandDismissCreatureStack extends H7InstantCommandBase;

var private H7AdventureHero mHero;
var private int mCreatureStackIndex;

function Init( H7AdventureHero hero, int creatureStackIndex )
{
	mHero = hero;
	mCreatureStackIndex = creatureStackIndex;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mHero = H7AdventureHero(eventManageable);
	mCreatureStackIndex = command.IntParameters[1];	
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;
	
	command.Type = ICT_DISMISS_CREATURESTACK;
	command.IntParameters[0] = mHero.GetID();
	command.IntParameters[1] = mCreatureStackIndex;
	
	return command;
}

function Execute()
{
	mHero.GetAdventureArmy().RemoveCreatureStackByIndexComplete( mCreatureStackIndex );
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mHero.GetPlayer();
}
