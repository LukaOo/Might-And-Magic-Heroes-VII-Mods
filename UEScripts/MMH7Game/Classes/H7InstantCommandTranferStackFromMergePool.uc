//=============================================================================
// H7InstantCommandTranferStackFromMergePool
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandTranferStackFromMergePool extends H7InstantCommandBase;

var private H7AdventureArmy mArmy;
var private int mSourceIndex;
var private int mTargetIndex;

function Init( H7AdventureArmy army, int sourceIndex, int targetIndex )
{
	mArmy = army;
	mSourceIndex = sourceIndex;
	mTargetIndex = targetIndex;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mArmy = H7AdventureArmy(H7EditorHero(eventManageable).GetArmy());
	mSourceIndex = command.IntParameters[1];
	mTargetIndex = command.IntParameters[2];
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;
	
	command.Type = ICT_TRANSFER_STACK_FROM_MERGE_POOL;
	command.IntParameters[0] = mArmy.GetEditorHero().GetID();
	command.IntParameters[1] = mSourceIndex;
	command.IntParameters[2] = mTargetIndex;

	return command;
}

function Execute()
{
	local bool success;
	local array<H7BaseCreatureStack> poolStacks, armyStacks;
	local H7MergePool pool;

	pool = mArmy.GetAMergePool();
	poolStacks = pool.PoolStacks;
	armyStacks = mArmy.GetBaseCreatureStacks();
	success = class'H7BaseCreatureStack'.static.TransferCreatureStacksByArray( poolStacks, armyStacks, mSourceIndex, mTargetIndex);
	if(success)
	{
		mArmy.SetBaseCreatureStacks(armyStacks);
		mArmy.UpdateMergePool(pool.PoolKey,poolStacks);
	}
	SplitCreatureStackComplete(success, poolStacks);
}

private function SplitCreatureStackComplete( bool success, array<H7BaseCreatureStack> poolStacks )
{
	local H7AdventureHud hud;

	// notifies the active GUI about the completion of the creature split
	hud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();

	if( !mArmy.GetPlayer().IsControlledByLocalPlayer() ) // not my army, don't need to update GUI
	{
		return;
	}

	if(hud.GetCombatPopUpCntl().GetPopup().IsVisible()) // standalone merger is currently the popup
	{
		hud.GetCombatPopUpCntl().CompleteTransferForNonArmy(success, poolStacks);
	}
}

/**
 * Sim Turns:
 * Determines if this instant command waits for ongoing move/startCombat commands in the area of the command location
 */
function bool WaitForInterceptingCommands()
{
	return true;
}

/**
 * Sim Turns:
 * used to check for intersection with ongoing move commands
 */
function Vector GetInterceptLocation()
{
	local MPSimTurnOngoingStartCombat ongoingStartCombat;

	ongoingStartCombat = class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager().GetOngoingStartCombat();

	// the merging window when bribing a neutral stack should not be blocked, we dont want to block a split action when is happening with a neutral stacks
	if( ongoingStartCombat.Target != none && ongoingStartCombat.Target.GetPlayer().IsNeutralPlayer() && 
		(mArmy.GetEditorHero() == ongoingStartCombat.Target || mArmy.GetEditorHero() == ongoingStartCombat.Source) )
	{
		return vect( -100000000, -100000000, -100000000 );
	}

	return mArmy.GetEditorHero().GetLocation();
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mArmy.GetPlayer();
}
