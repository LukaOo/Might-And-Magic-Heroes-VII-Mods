//=============================================================================
// H7SimTurnInstantCommand
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7SimTurnInstantCommand extends H7SimTurnBaseCommand;

var MPInstantCommand mData;
var H7InstantcommandBase mCommand;

function SetCommand( MPInstantCommand newCommand )
{
	mData = newCommand;
	mCommand = class'H7InstantCommandManager'.static.CreateInstantCommand(mData);
}

function ExecuteCommand() 
{
	local H7CombatPlayerController combatController;
	
	combatController = class'H7CombatPlayerController'.static.GetCombatPlayerController();
	mData.UnitActionsCounter = mSimTurnCommandManager.GetUnitActionCounter();
	combatController.SendInstantCommand( mData, true );
}

function bool CanBeExecuted()
{
	local Vector interceptLocation;

	if(mCommand.WaitForInterceptingCommands())
	{
		interceptLocation = mCommand.GetInterceptLocation();
		// there are other armies moving around
		if( IsAnyoneMovingAround( interceptLocation, interceptLocation ) )
		{
			return false;
		}

		// there is an ongoing start combat around
		if( mSimTurnCommandManager.IsOngoingStartCombatAround( interceptLocation, interceptLocation ) )
		{
			return false;
		}
	}
	return true;
}

// if the conditions of the command are different in the server than the sender of the command -> cancel it and send cancel's reason to the sender
function bool CancelCommandIfIlegal() { return false; }


function int GetSourceId() { return -1; }
function int GetTargetId() { return -1; }

function bool IsRetreat( int targetId ) { return false; }

function UpdateTradeFinished( H7AdventureHero target ){}

function string GetDebugInfo() { return mSender @ "->" @ mData.Type; }

function bool IsDoNormalCombat()
{
	return mData.Type == ICT_DO_COMBAT && !H7InstantCommandDoCombat(mCommand).IsQuickCombat();
}
