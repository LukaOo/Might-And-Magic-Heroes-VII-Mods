//=============================================================================
// H7InstantCommandLetEnemyFlee
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandLetEnemyFlee extends H7InstantCommandBase;

var private H7AdventureArmy mRemoveThisArmy;
var private H7AdventureArmy mRemover;

function Init( H7AdventureArmy removeThis, H7AdventureArmy remover )
{
	mRemoveThisArmy = removeThis;
	mRemover = remover;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mRemoveThisArmy = H7AdventureHero( eventManageable ).GetAdventureArmy();
	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[1] );
	mRemover = H7AdventureHero( eventManageable ).GetAdventureArmy();
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_LET_GO;
	command.IntParameters[0] = mRemoveThisArmy.GetHero().GetID();
	command.IntParameters[1] = mRemover.GetHero().GetID();
	
	return command;
}

function Execute()
{
	local MPSimTurnOngoingStartCombat ongoingStartCombat;

	if( class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager() != none )
	{
		// reset the ongoingstartcombat if a neutral army joins a player army
		ongoingStartCombat = class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager().GetOngoingStartCombat();
		if( ongoingStartCombat.Source == mRemover.GetHero() && ongoingStartCombat.Target == mRemoveThisArmy.GetHero() && ongoingStartCombat.Target.GetPlayer().IsNeutralPlayer() )
		{
			class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager().ResetOngoingStartCombat();
		}
	}

	class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetAdventureController().RemoveArmy( mRemoveThisArmy );
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mRemover.GetPlayer();
}
