//=============================================================================
// H7InstantCommandEndturn
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandAcceptMerge extends H7InstantCommandBase;

var private H7AdventureArmy mArmy;

function Init( H7AdventureArmy army )
{
	mArmy = army;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mArmy = H7AdventureHero(eventManageable).GetAdventureArmy();
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_ACCEPT_MERGE;
	command.IntParameters[0] = mArmy.GetHero().GetID();

	return command;
}

function Execute()
{
	if( mArmy.IsACaravan() && !mArmy.HasUnits( true ) )
	{
		class'H7AdventureController'.static.GetInstance().RemoveArmy( mArmy );
		mArmy.Destroy();
	}
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mArmy.GetPlayer();
}
