//=============================================================================
// H7InstantCommandCheatStatChange
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandCheatStatChange extends H7InstantCommandBase;

var private H7Unit mUnit;
var private EStat mStat;
var private int mNewValue;

function Init( H7Unit unitId, EStat stat, int newValue )
{
	mUnit = unitId;
	mStat = stat;
	mNewValue = newValue;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mUnit = H7Unit(eventManageable);
	mStat = EStat(command.IntParameters[1]);
	mNewValue = command.IntParameters[2];
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_CHEAT_STAT_CHANGE;
	command.IntParameters[0] = mUnit.GetID();
	command.IntParameters[1] = mStat;
	command.IntParameters[2] = mNewValue;
	
	return command;
}

function Execute()
{
	mUnit.SetBaseStatByID(mStat, mNewValue);
	mUnit.DataChanged();
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mUnit.GetPlayer();
}
