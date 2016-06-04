//=============================================================================
// H7InstantCommandTeleportToTown
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandTeleportToTown extends H7InstantCommandBase;

var private H7AdventureHero mHero;
var private H7Town mTown;
var private int mManaCost;

function Init( H7Town town, H7AdventureHero hero, int manaCost )
{
	mHero = hero;
	mTown = town;
	mManaCost = manaCost;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mHero = H7AdventureHero(eventManageable);
	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[1] );
	mTown = H7Town(eventManageable);
	mManaCost = command.IntParameters[2];	
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_TELEPORT_TO_TOWN;
	command.IntParameters[0] = mHero.GetID();
	command.IntParameters[1] = mTown.GetID();
	command.IntParameters[2] = mManaCost;
	
	return command;
}

function Execute()
{
	if( class'H7AdventurePlayerController'.static.GetAdventurePlayerController().TeleportTo( mTown.GetEntranceCell(), mHero.GetAdventureArmy() ) )
	{
		mHero.UseMana( mManaCost );

		mTown.OnVisit( mHero );
		mHero.SetCurrentMovementPoints( 0.0f );
		mHero.SetFinishedCurrentTurn(true);
	}
	else if( mHero.GetPlayer().IsControlledByLocalPlayer() )
	{
		class'H7FCTController'.static.GetInstance().StartFCT( FCT_ERROR, mHero.GetTargetLocation(), mHero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_TELEPORT_FAILED","H7FCT") );
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
	return mHero.GetPlayer();
}
