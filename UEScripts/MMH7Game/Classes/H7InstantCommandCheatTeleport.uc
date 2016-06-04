//=============================================================================
// H7InstantCommandCheatTeleport
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandCheatTeleport extends H7InstantCommandBase;

var private H7AdventureHero mHero;
var private H7AdventureMapCell mCell;

function Init( H7AdventureHero hero, H7AdventureMapCell cell )
{
	mHero = hero;
	mCell = cell;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mHero = H7AdventureHero(eventManageable);
	mCell = class'H7AdventureGridManager'.static.GetInstance().GetCell( command.IntParameters[1], command.IntParameters[2], command.IntParameters[3] );	
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_CHEAT_TELEPORT;
	command.IntParameters[0] = mHero.GetID();
	command.IntParameters[1] = mCell.GetCellPosition().x;
	command.IntParameters[2] = mCell.GetCellPosition().y;
	command.IntParameters[3] = mCell.GetGridOwner().GetID();
	
	return command;
}

function Execute()
{
	class'H7CheatWindowCntl'.static.TeleportHero(mHero, mCell);
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mHero.GetPlayer();
}
