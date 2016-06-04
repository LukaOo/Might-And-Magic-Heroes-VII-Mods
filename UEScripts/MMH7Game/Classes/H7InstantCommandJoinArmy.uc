//=============================================================================
// H7InstantCommandJoinArmy
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandJoinArmy extends H7InstantCommandBase;

var private H7AdventureArmy mArmyToJoin;
var private H7AdventureArmy mArmyJoiner;
var private bool mJoin;
var private bool mCanMerge;

function Init( H7AdventureArmy armyToJoin, H7AdventureArmy armyJoiner, bool join, bool canMerge )
{
	mArmyToJoin = armyToJoin;
	mArmyJoiner = armyJoiner;
	mJoin = join;
	mCanMerge = canMerge;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mArmyToJoin = H7AdventureHero(eventManageable).GetAdventureArmy();
	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[1] );
	mArmyJoiner = H7AdventureHero(eventManageable).GetAdventureArmy();
	mJoin = bool(command.IntParameters[2]);
	mCanMerge = bool(command.IntParameters[3]);
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_JOIN_ARMY;
	command.IntParameters[0] = mArmyToJoin.GetHero().GetID();
	command.IntParameters[1] = mArmyJoiner.GetHero().GetID();
	command.IntParameters[2] = int(mJoin);
	command.IntParameters[3] = int(mCanMerge);
	
	return command;
}

function Execute()
{
	local MPSimTurnOngoingStartCombat ongoingStartCombat;

	mArmyToJoin.JoinArmyComplete( mArmyJoiner, mJoin, mCanMerge );
	
	if( class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager() != none )
	{
		// reset the ongoingstartcombat if a neutral army joins a player army
		ongoingStartCombat = class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager().GetOngoingStartCombat();
		if( ongoingStartCombat.Source == mArmyToJoin.GetHero() && ongoingStartCombat.Target == mArmyJoiner.GetHero() && ongoingStartCombat.Target.GetPlayer().IsNeutralPlayer() )
		{
			class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager().ResetOngoingStartCombat();
		}
	}
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mArmyToJoin.GetPlayer();
}
