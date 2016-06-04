//=============================================================================
// H7InstantCommandMergeArmiesAI
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandMergeArmiesAI extends H7InstantCommandBase;

var private H7AdventureArmy mSourceArmy;
var private H7AdventureArmy mReceivingArmy;
var private int mThreshold;

function Init( H7AdventureArmy sourceArmy, H7AdventureArmy receivingArmy, int threshold )
{
	mSourceArmy = sourceArmy;
	mReceivingArmy = receivingArmy;
	mThreshold = threshold;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mSourceArmy = H7AdventureHero(eventManageable).GetAdventureArmy();
	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[1] );
	mReceivingArmy = H7AdventureHero(eventManageable).GetAdventureArmy();
	mThreshold = command.IntParameters[2];
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;
	
	command.Type = ICT_MERGE_ARMIES_AI;
	command.IntParameters[0] = mSourceArmy.GetHero().GetID();
	command.IntParameters[1] = mReceivingArmy.GetHero().GetID();
	command.IntParameters[2] = mThreshold;

	return command;
}

function Execute()
{
	mSourceArmy.MergeArmiesAIComplete(mReceivingArmy, mThreshold);
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mSourceArmy.GetPlayer();
}
