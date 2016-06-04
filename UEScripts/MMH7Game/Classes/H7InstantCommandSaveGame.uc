//=============================================================================
// H7InstantCommandSaveGame
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandSaveGame extends H7InstantCommandBase;

var private int mSaveGameSlotIndex;
var string mSaveGameName;

function Init( int saveGameSlot, string saveGameName )
{
	mSaveGameSlotIndex = saveGameSlot;
	mSaveGameName = saveGameName;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	mSaveGameSlotIndex = command.IntParameters[0];
	mSaveGameName = command.StringParameter;
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_SAVE_GAME;
	command.IntParameters[0] = mSaveGameSlotIndex;
	command.StringParameter = mSaveGameName;
	
	return command;
}

function Execute()
{
	class'H7ReplicationInfo'.static.PrintLogMessage("Saving game to slot"@mSaveGameSlotIndex, 0);;
	class'H7AdventurePlayerController'.static.GetAdventurePlayerController().SaveGameComplete( mSaveGameSlotIndex, SAVETYPE_MANUAL, mSaveGameName );
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return none;
}
