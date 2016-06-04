//=============================================================================
// H7InstantCommandEndturn
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandEndturn extends H7InstantCommandBase;

var private H7Player mPlayer;

function Init( H7Player player )
{
	mPlayer = player;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	mPlayer = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber(EPlayerNumber(command.IntParameters[0]));
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_END_TURN;
	command.IntParameters[0] = mPlayer.GetID();

	return command;
}

function Execute()
{
	class'H7AdventureController'.static.GetInstance().EndMyTurnComplete();
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mPlayer;
}
