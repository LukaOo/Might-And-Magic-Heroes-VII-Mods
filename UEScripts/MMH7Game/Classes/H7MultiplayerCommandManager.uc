//=============================================================================
// H7MultiplayerCommandManager
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7MultiplayerCommandManager extends Object
	dependson(H7StructsAndEnumsNative);

var protected array<MPCommand> mCommandQueue;
var protected array<MPInstantCommand> mInstantCommandQueue;
var protected array<MPOutOfSynchData> mOutOfSynchQueue;
var protected array<SynchUpData> mSynchUpData;

var protected MPCommand mLastCommand;
var protected MPInstantCommand mLastInstantCommand;
var protected bool loggedFirstOOS;
var protected float mNextCommandTimer;

var protected array<MPDamageApply> mDamageApplyQueue;

function AddCommand( int unitActionCounter, int unitTurnCounter, EUnitCommand command, ECommandTag commandTag, H7ICaster commandSource, H7IEffectTargetable target, int teleportTarget, array<H7BaseCell> path, int currentPlayer,
	optional H7BaseAbility ability = none, optional EDirection direction, optional bool replaceFakeAttacker, optional bool insertHead, optional H7CombatMapCell trueHitCell, optional bool doOOSCheck, optional int movementPoints )
{
	local MPCommand newCommand;

	newCommand.UnitActionsCounter = unitActionCounter;
	newCommand.CommandType = command;
	newCommand.CommandSource = commandSource;
	newCommand.Target = target;
	newCommand.Path = path;
	newCommand.Ability = ability;
	newCommand.CommandTag = commandTag;
	newCommand.Direction = direction;
	newCommand.ReplaceFakeAttacker = replaceFakeAttacker;
	newCommand.InsertHead = insertHead;
	newCommand.UnitTurnCounter = unitTurnCounter;
	newCommand.TeleportTarget = teleportTarget;
	newCommand.CurrentPlayer = currentPlayer;
	newCommand.TrueHitCell = trueHitCell;
	newcommand.doOOSCheck = doOOSCheck;
	newCommand.movementPoints = movementPoints;
	newCommand.CreationTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

	mCommandQueue.AddItem( newCommand );
}

function AddInstantCommand( MPInstantCommand instantCommand )
{
	mInstantCommandQueue.AddItem( instantCommand );
}

function AddOutOfSynchData( int unitActionCounter, int synchRNG, int idCounter, int unitsCount, int resCount, bool isCombat )
{
	local MPOutOfSynchData newOutOfSynchData;

	newOutOfSynchData.UnitActionsCounter = unitActionCounter;
	newOutOfSynchData.SynchRNG = synchRNG;
	newOutOfSynchData.IdCounter = idCounter;
	newOutOfSynchData.UnitsCount = unitsCount;
	newOutOfSynchData.ResCount = resCount;
	newOutOfSynchData.IsCombat = isCombat;

	mOutOfSynchQueue.AddItem( newOutOfSynchData );
}

function AddSynchUpData(int unitActionCounter, int synchRNG, int idCounter)
{
	local SynchUpData data;

	data.UnitActionsCounter = unitActionCounter;
	data.RNGCounter = synchRNG;
	data.IDCounter = idCounter;

	mSynchUpData.AddItem(data);
}

function AddDamageApply( int creatureStackId, int stackSize, int topCreatureHealth )
{
	local MPDamageApply newDamageApplyData;

	newDamageApplyData.CreatureStackId = creatureStackId;
	newDamageApplyData.StackSize = stackSize;
	newDamageApplyData.TopCreatureHealth = topCreatureHealth;
	newDamageApplyData.ExpirationTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds + 25.f;
	mDamageApplyQueue.AddItem( newDamageApplyData );
}

// returns true if the damage was found
function bool TryingDamageApply( int creatureStackId, int stackSize, int topCreatureHealth )
{
	local int i;

	for( i=0; i<mDamageApplyQueue.Length; ++i )
	{
		if( mDamageApplyQueue[i].CreatureStackId == creatureStackId && mDamageApplyQueue[i].StackSize == stackSize && mDamageApplyQueue[i].TopCreatureHealth == topCreatureHealth )
		{
			mDamageApplyQueue.Remove( i, 1 );
			return true;
		}

		// found the end of turn
		if( mDamageApplyQueue[i].CreatureStackId == -1 && mDamageApplyQueue[i].StackSize == -1 )
		{
			return false;
		}
	}

	return false;
}

function MPDamageApply GetNextDamageForStack(int creatureStackId)
{
	local MPDamageApply dmg;
	local int i;

	for( i=0; i<mDamageApplyQueue.Length; ++i )
	{
		if( mDamageApplyQueue[i].CreatureStackId == creatureStackId  )
		{
			dmg = mDamageApplyQueue[i];
			mDamageApplyQueue.Remove( i, 1 );
			return dmg;
		}

		// found the end of turn
		if( mDamageApplyQueue[i].CreatureStackId == -1 && mDamageApplyQueue[i].StackSize == -1 )
		{
			break;
		}
	}

	dmg.CreatureStackId = -1;
	return dmg;
}

// returns true if could end turn
function bool UpdateApplyDamageEndTurn()
{
	local int i;
	local H7IEventManagingObject eventManageable;
	local H7CreatureStack currentCreatureStack;
	local int endTurnIndex;

	endTurnIndex = -1;
	for( i=0; i<mDamageApplyQueue.Length; ++i )
	{
		// found the end of turn
		if( mDamageApplyQueue[i].CreatureStackId == -1 && mDamageApplyQueue[i].StackSize == -1 )
		{
			endTurnIndex = i;
			break;
		}
	}

	if( endTurnIndex != -1 )
	{
		if( class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetCounter() != mDamageApplyQueue[endTurnIndex].TopCreatureHealth )
		{
			class'H7ReplicationInfo'.static.PrintLogMessage("UpdateApplyDamageEndTurn RNG is out of sync. resync..." @ class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetCounter() @ mDamageApplyQueue[endTurnIndex].TopCreatureHealth, 0);;
			class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().SetCounter( mDamageApplyQueue[endTurnIndex].TopCreatureHealth );
		}

		for( i=0; i<endTurnIndex; ++i )
		{
			eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( mDamageApplyQueue[i].CreatureStackId );
			currentCreatureStack = H7CreatureStack(eventManageable);

			// apply the damage
			currentCreatureStack.SetStackSize( mDamageApplyQueue[i].StackSize );
			currentCreatureStack.SetTopCreatureHealth( mDamageApplyQueue[i].TopCreatureHealth );
			if( mDamageApplyQueue[i].StackSize <= 0 )
			{
				class'H7ReplicationInfo'.static.PrintLogMessage("UpdateApplyDamageEndTurn SET DEAD THE UNIT" @ currentCreatureStack.GetName(), 0);;
				currentCreatureStack.SetDead();
			}

			class'H7ReplicationInfo'.static.PrintLogMessage("UpdateApplyDamageEndTurn" @ mDamageApplyQueue[i].CreatureStackId @ mDamageApplyQueue[i].StackSize @ mDamageApplyQueue[i].TopCreatureHealth, 0);;
		}
		mDamageApplyQueue.Remove( 0, i + 1 );
	}

	return endTurnIndex != -1;
}

function bool IsExpiredApplyDamageEndTurn()
{
	local int i;

	for( i=0; i<mDamageApplyQueue.Length; ++i )
	{
		// found the end of turn
		if( mDamageApplyQueue[i].CreatureStackId == -1 && mDamageApplyQueue[i].StackSize == -1 && mDamageApplyQueue[i].ExpirationTime < class'WorldInfo'.static.GetWorldInfo().TimeSeconds )
		{
			return true;
		}
	}
	return false;
}

function bool IsReadyApplyDamageEndTurn()
{
	local int i;

	for( i=0; i<mDamageApplyQueue.Length; ++i )
	{
		// found the end of turn
		if( mDamageApplyQueue[i].CreatureStackId == -1 && mDamageApplyQueue[i].StackSize == -1 )
		{
			return true;
		}
	}
	return false;
}

function CleanDamageApplyQueue()
{
	mDamageApplyQueue.Length = 0;
}

function Update()
{
	if( mLastCommand.CommandSource != none && H7AdventureHero(mLastCommand.CommandSource) != none && H7AdventureHero(mLastCommand.CommandSource).IsMoving() )
	{
		mNextCommandTimer = class'WorldInfo'.static.GetWorldInfo().RealTimeSeconds + 0.3f;
		return;
	}

	if( class'WorldInfo'.static.GetWorldInfo().RealTimeSeconds <= mNextCommandTimer )
	{
		return;
	}


	if( !UpdateCommandQueue() )
	{
		UpdateInstantCommandQueue();
	}

	UpdateSynchUpQueue();
}

protected function bool UpdateCommandQueue()
{
	local MPCommand currentCommand;
	local H7BaseGameController baseGameController;
	local int unitActionsCounter, combatUnitTurnCounter, i;
	local H7Command command;

	baseGameController = class'H7BaseGameController'.static.GetBaseInstance();
	unitActionsCounter = class'H7ReplicationInfo'.static.GetInstance().GetUnitActionsCounter();
	combatUnitTurnCounter = class'H7ReplicationInfo'.static.GetInstance().GetCombatUnitTurnCounter();

	foreach mCommandQueue(currentCommand, i)
	{
		if( currentCommand.UnitActionsCounter == unitActionsCounter )
		{
			// set the hero as a ActiveUnit, if the command source is not the same as the current ActiveUnit
			if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
			{
				// the command needs to wait 2 seconds before being executed, so we are sure that all the DamagesApply will be ready
				if( currentCommand.CreationTime + 2.f > class'WorldInfo'.static.GetWorldInfo().TimeSeconds || currentCommand.UnitTurnCounter != combatUnitTurnCounter )
				{
					break;
				}
				if( class'H7CombatController'.static.GetInstance().GetActiveUnit() != currentCommand.CommandSource )
				{
					if( class'H7CombatController'.static.GetInstance().GetActiveUnit().GetCombatArmy().GetHero() == currentCommand.CommandSource )
					{
						class'H7CombatController'.static.GetInstance().SetActiveUnitHero();
					}
					else if (class'H7CombatController'.static.GetInstance().GetActiveUnit().GetCombatArmy().GetHero() == class'H7CombatController'.static.GetInstance().GetActiveUnit())
					{
						class'H7CombatController'.static.GetInstance().SetPreviousActiveUnit();
					}
					else
					{
						break;
					}
				}
			}
			else if( !class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() )
			{
				if( class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetPlayerNumber() != currentCommand.CurrentPlayer )
				{
					break;
				}
			}

			class'H7ReplicationInfo'.static.PrintLogMessage("CommandManager - PlayCommand"@ "UAC:" @ unitActionsCounter @ "Cmd:" @ currentCommand.CommandType @ "Src:" @ currentCommand.CommandSource.GetID() @ "Ability:" @ currentCommand.Ability @ "(" @ currentCommand.Ability != none ? currentCommand.Ability.GetName() : "" @ ")", 0);;
			UpdateOutOfSynchQueue();

			command = class'H7Command'.static.CreateCommand( currentCommand.CommandSource, currentCommand.CommandType, currentCommand.CommandTag, currentCommand.Ability, 
				currentCommand.Target, currentCommand.Path, false, currentCommand.Direction, currentCommand.ReplaceFakeAttacker, currentCommand.InsertHead,, currentCommand.TrueHitCell, currentCommand.doOOSCheck );

			// first we need to prepare the ability

			if( command.GetAbility() != none && command.GetAbility().GetTargetType() != NO_TARGET )
			{
				command.GetCommandSource().PrepareAbility( command.GetAbility() );
				command.GetCommandSource().GetPreparedAbility().Activate( command.GetAbilityTarget(), true, currentCommand.Direction, currentCommand.TrueHitCell );
			}
			baseGameController.GetCommandQueue().Enqueue( command );
			if(currentCommand.CommandSource.IsA('H7EditorHero') && currentCommand.CommandType == UC_MOVE)
			{
				H7EditorHero(currentCommand.CommandSource).SetCurrentMovementPoints(float(currentCommand.movementPoints) / 10000.f);
			}
			class'H7ReplicationInfo'.static.GetInstance().IncUnitActionsCounter();

			// fix for the teleport 
			class'H7ReplicationInfo'.static.GetInstance().SetTeleportTargetID(currentCommand.TeleportTarget);
			
			mCommandQueue.RemoveItem( currentCommand );
			mLastCommand = currentCommand;

			mNextCommandTimer = class'WorldInfo'.static.GetWorldInfo().RealTimeSeconds + 0.1f;
			return true;
		}
		else if( currentCommand.UnitActionsCounter < unitActionsCounter )
		{
			;
			mCommandQueue.RemoveItem( currentCommand );
			return false;
		}
	}

	return false;
}

protected function bool UpdateInstantCommandQueue()
{
	local MPInstantCommand currentInstantCommand;
	local H7InstantCommandBase instantCommand;
	local int unitActionsCounter;

	unitActionsCounter = class'H7ReplicationInfo'.static.GetInstance().GetUnitActionsCounter();

	foreach mInstantCommandQueue(currentInstantCommand)
	{
		if( currentInstantCommand.UnitActionsCounter == unitActionsCounter )
		{
			if(!class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() 
				&& !class'H7ReplicationInfo'.static.GetInstance().IsCombatMap()
				&& currentInstantCommand.CurrentPlayer != class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetPlayerNumber())
			{
				return false;
			}

			instantCommand = class'H7InstantCommandManager'.static.CreateInstantCommand(currentInstantCommand);

			class'H7ReplicationInfo'.static.PrintLogMessage("CommandManager - PlayInstantCommand"@ "UAC:" @ unitActionsCounter @ "Cmd:" @ currentInstantCommand.Type, 0);;
			// execute instant command
			class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().ExecuteInstantCommand(instantCommand);

			mInstantCommandQueue.RemoveItem( currentInstantCommand );
			mLastInstantCommand = currentInstantCommand;

			mNextCommandTimer = class'WorldInfo'.static.GetWorldInfo().RealTimeSeconds + 0.1f;
			return true;
		}
		else if( currentInstantCommand.UnitActionsCounter < unitActionsCounter )
		{
			;
			mInstantCommandQueue.RemoveItem( currentInstantCommand );
			return false;
		}
	}

	return false;
}

protected function bool UpdateOutOfSynchQueue()
{
	local MPOutOfSynchData currentOutOfSynchData;
	local int unitActionsCounter;

	unitActionsCounter = class'H7ReplicationInfo'.static.GetInstance().GetUnitActionsCounter();

	foreach mOutOfSynchQueue( currentOutOfSynchData )
	{
		if( currentOutOfSynchData.UnitActionsCounter == unitActionsCounter )
		{
			if( class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetCounter() != currentOutOfSynchData.SynchRNG )
			{
				GameWentOOS( "############# OUT OF SYNCH synchRNG:" @ class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetCounter() @ currentOutOfSynchData.SynchRNG @ "#############", OOS_RNG_COUNTER );
			}
			if( class'H7ReplicationInfo'.static.GetInstance().GetIdCounter() != currentOutOfSynchData.IdCounter )
			{
				GameWentOOS( "############# OUT OF SYNCH idCounter:" @ class'H7ReplicationInfo'.static.GetInstance().GetIdCounter() @ currentOutOfSynchData.IdCounter @ "#############", OOS_ID_COUNTER );
			}
			if(class'H7AdventureController'.static.GetInstance() != none && !currentOutOfSynchData.IsCombat)
			{
				if( class'H7AdventureController'.static.GetInstance().GetTotalUnitsCount() != currentOutOfSynchData.UnitsCount )
				{
					GameWentOOS( "############# OUT OF SYNCH unitsCount:" @ class'H7AdventureController'.static.GetInstance().GetTotalUnitsCount() @ currentOutOfSynchData.UnitsCount @ "#############", OOS_UNIT_COUNT );
				}
				// should only be enabled for testing versions since players having different resources state doesn't break the game
				//if( class'H7AdventureController'.static.GetInstance().GetTotalResCount() != currentOutOfSynchData.ResCount )
				//{
				//	GameWentOOS( "############# OUT OF SYNCH resCount:" @ class'H7AdventureController'.static.GetInstance().GetTotalResCount() @ currentOutOfSynchData.ResCount @ "#############" );
				//}
			}
			else if( class'H7AdventureController'.static.GetInstance() == none && currentOutOfSynchData.IsCombat )
			{
				if( class'H7CombatController'.static.GetInstance().GetTotalHealth() != currentOutOfSynchData.UnitsCount )
				{
					GameWentOOS( "############# OUT OF SYNCH unitsCount:" @ class'H7CombatController'.static.GetInstance().GetTotalHealth() @ currentOutOfSynchData.UnitsCount @ "#############", OOS_UNIT_COUNT );
				}
			}

			mOutOfSynchQueue.RemoveItem( currentOutOfSynchData );
			return true;
		}
		else if( currentOutOfSynchData.UnitActionsCounter < unitActionsCounter )
		{
			;
			mOutOfSynchQueue.RemoveItem( currentOutOfSynchData );
			return false;
		}
	}

	return false;
}

protected function UpdateSynchUpQueue()
{
	local SynchUpData data;
	local int unitActionsCounter;

	unitActionsCounter = class'H7ReplicationInfo'.static.GetInstance().GetUnitActionsCounter();

	foreach mSynchUpData( data )
	{
		if(data.UnitActionsCounter == unitActionsCounter)
		{
			class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().SetCounter(data.RNGCounter);
			class'H7ReplicationInfo'.static.GetInstance().SetIdCounter(data.IDCounter);
			mSynchUpData.RemoveItem(data);
			return;
		}
		else if(data.UnitActionsCounter < unitActionsCounter)
		{
			mSynchUpData.RemoveItem(data);
			return;
		}
	}
}

public function GameWentOOS( string msg, EOOSType oosType, optional bool syncMultiplayer = true )
{
	class'H7ReplicationInfo'.static.PrintLogMessage(msg, 0);;

	// dont show the OoS of the combat because we have the new system that fixes them
	//if( !class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	//{
	//popupMsg = `Localize("H7PopUp", "PU_GAME_WENT_OOS" , "MMH7Game" );
	//popupButton = `Localize("H7PopUp", "PU_OK" , "MMH7Game" );
	//class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().OKPopup(popupMsg, popupButton, OOSMessageConfirmed);
	//}

	if(class'H7AdventurePlayerController'.static.GetAdventurePlayerController() != none)
	{
		class'H7AdventurePlayerController'.static.GetAdventurePlayerController().DumpCurrentState();
	}

	// dont show the OoS of the combat because we have the new system that fixes them
	if( !class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		class'H7GUIOverlaySystemCntl'.static.GetInstance().GetSideBar().SetVisibleSave(true);
	}

	if(syncMultiplayer)
	{
		class'H7CombatPlayerController'.static.GetCombatPlayerController().SendGameWentOOS(msg, oosType);
	}
}

function OOSMessageConfirmed()
{
	class'H7ReplicationInfo'.static.GetInstance().GoToMainMenu();
}
