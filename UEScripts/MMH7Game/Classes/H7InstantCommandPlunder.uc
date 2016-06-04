//=============================================================================
// H7InstantCommandPlunder
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandPlunder extends H7InstantCommandBase;

var private H7Mine mMine;
var private H7AdventureHero mHero;
var private H7Player mPlayer;

function Init( H7Mine mine, H7AdventureHero hero, H7Player dasPlayer )
{
	mMine = mine;
	mHero = hero;
	mPlayer = dasPlayer;;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mMine = H7Mine(eventManageable);
	if( command.IntParameters[1] != INDEX_NONE )
	{
		eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[1] );
		mHero = H7AdventureHero(eventManageable);
	}
	else
	{
		mHero = none;
	}
	mPlayer = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber(EPlayerNumber(command.IntParameters[2]));
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;
	
	command.Type = ICT_PLUNDER;
	command.IntParameters[0] = mMine.GetID();
	if( mHero != none )
	{
		command.IntParameters[1] = mHero.GetID();
	}
	else
	{
		command.IntParameters[1] = INDEX_NONE;
	}
	command.IntParameters[2] = mPlayer.GetID();

	return command;
}

function Execute()
{
	mMine.PlunderComplete( mHero, mPlayer );
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
	return mMine.GetLocation();
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mPlayer;
}
