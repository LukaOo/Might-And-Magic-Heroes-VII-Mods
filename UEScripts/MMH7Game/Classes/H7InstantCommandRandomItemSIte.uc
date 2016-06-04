//=============================================================================
// H7InstantCommandRandomItemSIte
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandRandomItemSIte extends H7InstantCommandBase;

var private H7RandomItemSite mRandomSite;

function Init( H7RandomItemSite randomSite )
{
	mRandomSite = randomSite;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mRandomSite = H7RandomItemSite(eventManageable);
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_RANDOM_ITEM_SITE;
	command.IntParameters[0] = mRandomSite.GetID();
	return command;
}

function Execute()
{
	mRandomSite.AcceptComplete();
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mRandomSite.GetPlayer();
}
