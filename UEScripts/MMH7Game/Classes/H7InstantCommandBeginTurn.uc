//=============================================================================
// H7InstantCommandBeginTurn
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandBeginTurn extends H7InstantCommandBase;

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_BEGIN_TURN;
	
	return command;
}

function Execute()
{
	class'H7AdventureController'.static.GetInstance().BeginTurn();
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return class'H7AdventureController'.static.GetInstance().GetLocalPlayer();
}
