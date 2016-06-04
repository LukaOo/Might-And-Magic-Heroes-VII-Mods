//=============================================================================
// H7InstantCommandFleeOrSurrender
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandFleeOrSurrender extends H7InstantCommandBase;

var private bool mIsFlee;

function Init( bool isFlee )
{
	mIsFlee = isFlee;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	mIsFlee = bool(command.IntParameters[0]);
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_FLEE_OR_SURRENDER;
	command.IntParameters[0] = int(mIsFlee);
	
	return command;
}

function Execute()
{
	if( mIsFlee )
	{
		class'H7CombatController'.static.GetInstance().SetActiveUnitCommand_FleeComplete();
	}
	else
	{
		class'H7CombatController'.static.GetInstance().SetActiveUnitCommand_SurrenderComplete();
	}
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return class'H7AdventureController'.static.GetInstance().GetLocalPlayer();
}
