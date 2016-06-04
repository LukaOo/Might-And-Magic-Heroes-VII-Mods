//=============================================================================
// H7SimTurnNormalCommand
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7SimTurnNormalCommand extends H7SimTurnBaseCommand;

var protected MPCommand mCommand;
var protected ESimTurnCommandState mState;

function int GetSourceId() { return mCommand.CommandSource.GetID(); }
function int GetTargetId() { return mCommand.Target.GetID(); }

function ESimTurnCommandState GetState() { return mState; }
function SetState( ESimTurnCommandState state ){ mState = state; }
function string GetDebugInfo() { return mSender @ "->" @ mCommand.CommandType @ "Source:" @ mCommand.CommandSource @ "Target:" @ mCommand.Target @ "Path:"@ mCommand.Path.Length; }

function SetCommand( MPCommand newCommand )
{
	mCommand = newCommand;
	mState = STCS_DEFAULT;
}

function ExecuteCommand()
{
	local H7AreaOfControlSite site;
	local H7ResourcePile pile;

	if( mCommand.CommandType == UC_VISIT )
	{
		pile = H7ResourcePile(mCommand.Target);
		if(pile != none && pile.IsChest())
		{
			mSimTurnCommandManager.InsergOngoingInteraction( H7AdventureHero( mCommand.CommandSource ) );
		}
				
		site = H7AreaOfControlSite( mCommand.Target );
		if( site != none )
		{
			if( site.GetGarrisonArmy() != none && site.GetGarrisonArmy().HasUnits() && site.GetPlayer().IsPlayerHostile( mCommand.CommandSource.GetPlayer() ) )
			{
				mSimTurnCommandManager.InsertOngoingStartCombat( H7AdventureHero( mCommand.CommandSource ), site.GetGarrisonArmy().GetHero() );
			}
		}

	}
	else if( mCommand.CommandType == UC_MEET )
	{
		// we need to know the original cell of target for UC_MEET, setting back the path to empty before executing the command
		mCommand.Path.Length = 0;

		// register the meeting
		if( mCommand.CommandSource.GetPlayer().IsPlayerHostile( mCommand.Target.GetPlayer() ) )
		{
			if( H7AdventureHero( mCommand.CommandSource ).GetAdventureArmy().GetCreatureAmountTotal() > 0 && (H7AdventureHero( mCommand.Target ).GetAdventureArmy().GetCreatureAmountTotal() > 0 || !H7AdventureHero( mCommand.Target ).GetPlayer().IsControlledByAI()) )
			{
				mSimTurnCommandManager.InsertOngoingStartCombat( H7AdventureHero( mCommand.CommandSource ), H7AdventureHero( mCommand.Target ) );
			}
		}
		else if( mCommand.CommandSource.GetPlayer() != mCommand.Target.GetPlayer() )
		{
			mSimTurnCommandManager.InsertOngoingTrade( H7AdventureHero( mCommand.CommandSource ), H7AdventureHero( mCommand.Target ) );
		}
	}

	class'H7CombatPlayerController'.static.GetCombatPlayerController().SendPlayCommand( mSimTurnCommandManager.GetUnitActionCounter(), class'H7ReplicationInfo'.static.GetInstance().GetCombatUnitTurnCounter(), mCommand.CommandType, mCommand.CommandSource, 
		mCommand.Ability, mCommand.Target, mCommand.TeleportTarget, mCommand.Path, mCommand.CommandTag, mCommand.Direction, mCommand.ReplaceFakeAttacker,mCommand.InsertHead, 0, mCommand.TrueHitCell, true, mCommand.doOOSCheck, mCommand.movementPoints );
}

function bool CanBeExecuted()
{
	local H7SimTurnBaseCommand commandAttachedToMove;
	local Vector targetLocation;

	if( mState != STCS_DEFAULT )
	{
		return false;
	}

	if( mCommand.CommandType == UC_MOVE )
	{
		if( mCommand.CommandTag == ACTION_MOVE_MEET || mCommand.CommandTag == ACTION_MOVE_VISIT )
		{
			commandAttachedToMove = mSimTurnCommandManager.GetCommandAttachedToMove( self );
			// the command cannot be executed until we get the other command that follows the move
			if( commandAttachedToMove == none )
			{
				return false;
			}
			// if the other command that follows the move cannot be executed, the move neither
			if( !commandAttachedToMove.CanBeExecuted() )
			{
				return false;
			}
		}

		// the army is in a trade with another one
		if( mSimTurnCommandManager.IsInOngoingTrade( H7AdventureHero( mCommand.CommandSource ) ) )
		{
			// request to the owner of the army, if he wants to cancel the trade
			mState = STCS_WAITING_RESPONSE_CANCEL_TRADE;
			mCommand.CommandSource.GetPlayer().GetAdventurePlayerController().SendRequestCancelTrade( mCommand.CommandSource.GetID() );
			return false;
		}

		targetLocation = mCommand.Path.Length == 0 ? mCommand.CommandSource.GetLocation() : mCommand.Path[mCommand.Path.Length-1].GetLocation();

		// there are other armies moving around
		if( IsAnyoneMovingAround( mCommand.CommandSource.GetLocation(), targetLocation, HasThePathATeleporter( mCommand.Path ) ) )
		{
			return false;
		}

		// there is an ongoing start combat around
		if( mSimTurnCommandManager.IsOngoingStartCombatAround( mCommand.CommandSource.GetLocation(), targetLocation, H7AdventureHero( mCommand.CommandSource ) ) )
		{
			return false;
		}

		// there is an ongoing trade around
		if( mSimTurnCommandManager.IsOngoingTradeAround( mCommand.CommandSource.GetLocation(), targetLocation ) )
		{
			return false;
		}

		// there is an ongoing interaction of a hero with something else
		if( mSimTurnCommandManager.IsOngoingInteractionAround( mCommand.CommandSource.GetLocation(), targetLocation ) )
		{
			return false;
		}
	}
	else
	{
		// if this is a meet or visit that will trigger an attack to an army, then cannot be executed if there are other armies moving because can happen
		// that one of this moving armies will attack an army (we can have only one combat at the same time)
		if( IsAttackArmyCommand() && ( IsAnyoneMovingAround( mCommand.CommandSource.GetLocation(), mCommand.CommandSource.GetLocation(), true ) 
			|| mSimTurnCommandManager.IsOngoingStartCombat( H7AdventureHero( mCommand.CommandSource ) ) ) )		{
			return false;
		}

		// there are other armies moving around
		if( IsAnyoneMovingAround( mCommand.CommandSource.GetLocation(), mCommand.CommandSource.GetLocation() ) )
		{
			return false;
		}

		// there is an ongoing start combat around
		if( mSimTurnCommandManager.IsOngoingStartCombatAround( mCommand.CommandSource.GetLocation(), mCommand.CommandSource.GetLocation(), H7AdventureHero( mCommand.CommandSource ) ) )
		{
			return false;
		}

		// there is an ongoing trade around
		if( mSimTurnCommandManager.IsOngoingTradeAround( mCommand.CommandSource.GetLocation(), mCommand.CommandSource.GetLocation() ) )
		{
			return false;
		}

		// there is an ongoing interaction of a hero with something else
		if( mSimTurnCommandManager.IsOngoingInteractionAround( mCommand.CommandSource.GetLocation(), mCommand.CommandSource.GetLocation() ) )
		{
			return false;
		}
	}

	return true;
}

// if the conditions of the command are different in the server than the sender of the command -> cancel it and send cancel's reason to the sender
function bool CancelCommandIfIlegal()
{
	if( mCommand.CommandType == UC_MOVE )
	{
		return CancelMoveCommandIfIlegal();
	}
	else if( mCommand.CommandType == UC_VISIT )
	{
		return CancelVisitCommandIfIlegal();
	}
	else if( mCommand.CommandType == UC_MEET )
	{
		return CancelMeetCommandIfIlegal();
	}
	return false;
}

protected function bool CancelMoveCommandIfIlegal()
{
	local H7SimTurnBaseCommand commandAttachedToMove;
	local array<H7BaseCell> originalPath;
	local H7BaseCell baseCell;
	local array<H7AdventureMapCell> path, convertedOriginalPath;
	local H7AdventureGridManager  gridManager;
	local H7AdventureHero hero;
	local float originalPathCost, newPathCost;

	// check if this move command has attach any other command (UC_MEET, UC_VISIT)
	// if the other command is ilegal then this move command is also ilegal and should be cancelled
	commandAttachedToMove = mSimTurnCommandManager.GetCommandAttachedToMove( self );
	if( commandAttachedToMove != none )
	{
		if( commandAttachedToMove.CancelCommandIfIlegal() )
		{
			return true;
		}
	}

	// checking if the path that the client sent for this move command is the same as the server
	hero = H7AdventureHero( mCommand.CommandSource );
	gridManager = class'H7AdventureGridManager'.static.GetInstance();
	originalPath = mCommand.Path;
	if( originalPath.Length == 0 )
	{
		return false;
	}

	path = gridManager.GetPathfinder().GetPath( hero.GetCell(), H7AdventureMapCell(originalPath[originalPath.Length-1]), hero.GetPlayer(), hero.GetAdventureArmy().HasShip() );

	if( originalPath.Length != path.Length )
	{
		class'H7ReplicationInfo'.static.PrintLogMessage("Cancel Movement, length not matching:" @ originalPath.Length @ path.Length, 0);;

		class'H7AdventurePlayerController'.static.GetAdventurePlayerController().SendUpdateHeroPosition(hero.GetID(), hero.GetCell().GetID());
		mSender.ClientCommandCancelled( STCCR_PATH_CHANGED );
		return true;
	}

	foreach originalPath(baseCell)
	{
		convertedOriginalPath.AddItem( H7AdventureMapCell(baseCell) );
	}
	originalPathCost = class'H7AdventureGridManager'.static.GetInstance().GetPathfinder().GetTotalPathCosts( convertedOriginalPath, hero.GetCell() );
	newPathCost = class'H7AdventureGridManager'.static.GetInstance().GetPathfinder().GetTotalPathCosts( path, hero.GetCell() );
	if( originalPathCost != newPathCost )
	{
		class'H7ReplicationInfo'.static.PrintLogMessage("Cancel Movement, path cost not matching:" @ originalPathCost @ newPathCost, 0);;
		class'H7AdventurePlayerController'.static.GetAdventurePlayerController().SendUpdateHeroPosition(hero.GetID(), hero.GetCell().GetID());
		mSender.ClientCommandCancelled( STCCR_PATH_CHANGED );
		return true;
	}

	return false;
}

protected function bool CancelVisitCommandIfIlegal()
{
	local H7IPickable pickable;

	pickable = H7IPickable( mCommand.Target );

	// check if someone already looted the pickable
	if( pickable != none && pickable.IsLooted() )
	{
		class'H7ReplicationInfo'.static.PrintLogMessage("Cancel Picking, already looted:" @ pickable, 0);;
		mSender.ClientCommandCancelled( STCCR_ALREADY_LOOTED );
		return true;
	}
	return false;
}

protected function bool CancelMeetCommandIfIlegal()
{
	local H7AdventureHero hero;

	hero = H7AdventureHero( mCommand.Target );

	// check if the army is dead or in a different cell
	if( hero.GetAdventureArmy().IsDead() || hero.GetAdventureArmy().GetCell() != mCommand.Path[0] )
	{
		class'H7ReplicationInfo'.static.PrintLogMessage("Cancel Meet, the army is not anymore in the original cell:" @ mCommand.Target, 0);;
		mSender.ClientCommandCancelled( STCCR_ARMY_IN_DIFFERENT_CELL );
		return true;
	}
	return false;
}

function UpdateTradeFinished( H7AdventureHero target )
{
	if( mState == STCS_WAITING_RESPONSE_CANCEL_TRADE && mCommand.CommandSource == target )
	{
		mState = STCS_DEFAULT;
	}
}

function bool IsRetreat( int targetId )
{
	return  mCommand.CommandType == UC_MOVE && mCommand.CommandSource.GetID() == targetId;
}

function bool IsAttackArmyCommand()
{
	local H7AreaOfControlSite site;

	if( mCommand.CommandType == UC_VISIT )
	{
		site = H7AreaOfControlSite( mCommand.Target );
		if( site != none )
		{
			if( site.GetGarrisonArmy() != none && site.GetGarrisonArmy().HasUnits() && site.GetPlayer().IsPlayerHostile( mCommand.CommandSource.GetPlayer() ) )
			{
				return true;
			}
		}

	}
	else if( mCommand.CommandType == UC_MEET )
	{
		// register the meeting
		if( mCommand.CommandSource.GetPlayer().IsPlayerHostile( mCommand.Target.GetPlayer() ) )
		{
			return true;
		}
	}

	return false;
}
