//=============================================================================
// H7CommandQueue
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CommandQueue extends Object
	native;

/** FIFO ***/
var protected array<H7Command>	mCommandQueue;
var protected H7Command	        mCurrentCommand[9]; // 9 == PN_PLAYER_8 + 1, in the case of non sim-turn we use only the index 0

var protected ECommandTag	    mLastCommandExecuted;
var protected bool	            mWaitingForAnimEnd;
var protected bool              mReplaceFakeAttacker; // used for replacing the attacker set by H7CommandEffect (who is always the initiator of the source effect, which is not always true)
var protected H7CombatResult	mLastCommandResult;

var protected float             mDelayTimer;
var protected float             mDelayTime;

function SetLastCommandExecuted( ECommandTag LastCommandExecuted) { mLastCommandExecuted = LastCommandExecuted; }
function int GetQueueLength() { return mCommandQueue.Length; }

function bool IsCommandRunning()
{
	if( mWaitingForAnimEnd )
	{
		return true;
	}
	if( GetCurrentCommand() == none )
	{
		return false;
	}
	return GetCurrentCommand().IsRunning();
}

function bool IsCommandRunningForAnyPlayer()
{
	local int i, playerCount;

	if( mWaitingForAnimEnd )
	{
		return true;
	}

	playerCount = class'H7AdventureController'.static.GetInstance().GetNumOfPlayers();
	for( i=0; i < playerCount; i++)
	{
		if( mCurrentCommand[i] != none && mCurrentCommand[i].IsRunning() )
		{
			return true;
		}
	}

	return false;
}

function bool IsCommandRunningForCaster( H7ICaster caster )
{
	local H7Command currentCommand;
	
	if( mWaitingForAnimEnd )
	{
		return true;
	}

	currentCommand = GetCurrentCommand();
	if( currentCommand == none )
	{
		return false;
	}
	if( currentCommand.GetCommandSource().GetID() == caster.GetID() )
	{
		return currentCommand.IsRunning();
	}

	return false;
}

simulated function bool CanEnqueue()
{
	if(class'H7ReplicationInfo'.static.GetInstance().IsCombatMap())
	{
		return class'H7CombatController'.static.GetInstance().GetActiveUnit().CanMakeAction() && !class'H7CombatController'.static.GetInstance().GetActiveUnit().IsWaiting();
	}
	else
	{
		return true;
	}
}

/**
 * Insert command to queue
 * 
 * @param cmd           Command to be added
 * */
simulated function Enqueue( H7Command cmd )
{
	local H7IEffectTargetable target;
	local array<H7BaseCell> path;
	local int unitActionCounter, combatUnitTurnCounter;
	local int currentPlayer;
	local int movementPoints;
	local H7ICaster source;

	path = cmd.GetPath();
	if( cmd.GetCommand() == UC_MOVE && path.Length == 0 && cmd.GetCommandTag() != ACTION_MOVE_ROTATE )
	{
		;
		return;
	}

	if( cmd.GetCommand() == UC_ABILITY && cmd.GetCommandTag() == ACTION_INTERRUPT && class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() )
	{
		//`LOG_MP( "Ignoring an ACTION_INTERRUPT on" @ cmd.GetCommandSource().GetName() );
		return;
	}

	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() && class'H7CombatController'.static.GetInstance().IsBadMoraleDelayRunning() && cmd.IsMPSynchronized())
	{
		// don't allow any command during bad morale delay.
		class'H7ReplicationInfo'.static.PrintLogMessage("Tried to do an command during bad morale delay:"@cmd.GetCommand()@"source:"@cmd.GetCommandSource()@"target:"@cmd.GetAbilityTarget(), 0);;
		return;
	}

	mReplaceFakeAttacker = cmd.ReplaceFakeAttacker();
	mLastCommandResult = class'H7ReplicationInfo'.static.GetInstance().GetGameProcessor().GetCurrentResult();
	;

	// put on head
	target = cmd.GetAbilityTarget();
	if( cmd.GetCommandTag() == ACTION_INTERRUPT && H7ICaster( target ) != none )
	{
		;
		InterruptCaster( H7ICaster( target ) );
		;
		return;
	}
	;
	;
	if( cmd.GetAbility() != none )
	{
		;
		;
	}
	if( cmd.GetAbilityTarget() != none )
	{
		;
	}

	if( cmd.IsMPSynchronized() && class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() )
	{
		if(class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().IsControlledByLocalPlayer())
		{
			class'H7PlayerController'.static.GetPlayerController().SetCommandRequested(true);
		}
		unitActionCounter = class'H7ReplicationInfo'.static.GetInstance().GetUnitActionsCounter();
		combatUnitTurnCounter = class'H7ReplicationInfo'.static.GetInstance().GetCombatUnitTurnCounter();
		if(class'H7AdventureController'.static.GetInstance() != none)
		{
			currentPlayer = class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetPlayerNumber();
		}
		if(cmd.GetCommandSource().IsA('H7EditorHero') && cmd.GetCommand() == UC_MOVE)
		{
			source = cmd.GetCommandSource();
			movementPoints = int(H7EditorHero(source).GetCurrentMovementPoints() * 10000) + 1;
		}
		class'H7CombatPlayerController'.static.GetCombatPlayerController().SendPlayCommand( unitActionCounter, combatUnitTurnCounter, cmd.GetCommand(), cmd.GetCommandSource(), cmd.GetAbility(), 
			cmd.GetAbilityTarget(), class'H7ReplicationInfo'.static.GetInstance().GetTeleportTargetID(), cmd.GetPath(), cmd.GetCommandTag(), cmd.GetAbilityDirection(), cmd.ReplaceFakeAttacker(), cmd.InsertHead(), currentPlayer, cmd.GetTrueHitCell(),, cmd.GetDoOOSCheck(), movementPoints );
			
		if( class'H7CombatPlayerController'.static.GetCombatPlayerController().IsSimTurnCommandMode() )
		{
			class'H7PlayerController'.static.GetPlayerController().GetHud().BlockAllFlashMovies();
			return;
		}

		class'H7ReplicationInfo'.static.GetInstance().IncUnitActionsCounter();
	}
	
	mCommandQueue.InsertItem( cmd.InsertHead() ? 0 : mCommandQueue.Length, cmd );

	;
}

function H7Command GetCurrentCommand()
{
	if( class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() )
	{
		if(class'H7AdventureController'.static.GetInstance().IsSimTurnOfAI())
		{
			return mCurrentCommand[class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetPlayerNumber()];
		}
		else
		{
			return mCurrentCommand[class'H7AdventureController'.static.GetInstance().FindLocalPlayer().GetPlayerNumber()];
		}
	}
	else
	{
		return mCurrentCommand[0];
	}
}

/**
 *  Get Head / Front
 * */
protected function bool Dequeue( int playerIndex )
{
	local H7EventContainerStruct containerStruct;
	local H7ICaster source;
	local H7Command command;

	;

	command = GetFrontQueue( playerIndex );
	if( command != none )
	{
		if( command.GetAbility() != none )
			;
		else
			;

		// inform target about incoming command (in case the dude wants to insert something into head)
		if( command.GetAbilityTarget() != none )
		{
			;
			containerStruct.Action = command.GetCommandTag();
			containerStruct.EffectContainer = command.GetAbility();
			containerStruct.Targetable = command.GetAbilityTarget();
			containerStruct.Result = mLastCommandResult;
			if(command.GetAbility()!=None)
				containerStruct.ActionTag = command.GetAbility().GetTags();
			command.GetAbilityTarget().TriggerEvents( ON_PRE_NEXT_COMMAND, false, containerStruct);
		}

		// in case smth came and got head
		command = GetFrontQueue( playerIndex );
		if( command.GetAbility() != none )
			;
		else
			;

		if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
		{
			// if we wait for the creature to return to idle state before we start any new commands which might start new animations
			source = command.GetCommandSource();

			if( H7CreatureStack( source ) != none && H7CreatureStack( source ).GetCreature().GetAnimControl().GetStateName() != 'Idling' )
			{
				H7CreatureStack( source ).GetCreature().GetAnimControl().PlayAnim( CAN_IDLE );
				mWaitingForAnimEnd = true;
				return false;
			}
			else if(H7WarUnit( source ) != none && H7WarUnit( source ).GetAnimControl().GetStateName() != 'Idling')
			{
				if(H7WarUnit( source ).GetAnimControl().GetCurrentAnimNodeTimeLeft() <= class'WorldInfo'.static.GetWorldInfo().DeltaSeconds)
				{
					H7WarUnit( source ).GetAnimControl().PlayAnim( WA_IDLE );
					mWaitingForAnimEnd = true;
				}

				return false;
			}
			else if(H7CombatHero( source ) != none && H7CombatHero( source ).GetAnimControl().GetStateName() != 'Idling')
			{
				if(H7CombatHero( source ).GetAnimControl().GetCurrentAnimNodeTimeLeft() <= class'WorldInfo'.static.GetWorldInfo().DeltaSeconds)
				{
					H7CombatHero( source ).GetAnimControl().PlayAnim( HA_IDLE );
					mWaitingForAnimEnd = true;
				}

				return false;
			}
			else if(H7TowerUnit( source ) != none && !H7TowerUnit( source ).IsIdling())
			{
				if(H7TowerUnit( source ).GetAnimTimeLeft() <= class'WorldInfo'.static.GetWorldInfo().DeltaSeconds)
				{
					H7TowerUnit( source ).SwitchToIdle();
					mWaitingForAnimEnd = true;
				}

				return false;
			}
			else
			{
				mWaitingForAnimEnd =  false;
			}
		}
		
		;
		if( mCurrentCommand[playerIndex] != none && mCurrentCommand[playerIndex].GetAbility() != none )
		{
			;
		}
		else
		{
			;
		}
		containerStruct.Action = command.GetCommandTag();
		containerStruct.EffectContainer = command.GetAbility();
		containerStruct.Targetable = command.GetAbilityTarget();
		containerStruct.Result = mLastCommandResult;
		if( command.GetAbility() != none )
			containerStruct.ActionTag = command.GetAbility().GetTags();
		command.GetCommandSource().TriggerEvents( ON_PRE_COMMAND, false, containerStruct );
		mLastCommandExecuted = command.GetCommandTag();

		if( command.GetCommandTag() == ACTION_MOVE_ATTACK )
		{
			containerStruct.Path = command.GetPath();
			containerStruct.Targetable = command.GetAbilityTarget();
			command.GetCommandSource().TriggerEvents( ON_MOVE_ATTACK_START, false, containerStruct );
		}
		if( command.GetAbilityTarget() != none )
		{
			command.GetAbilityTarget().TriggerEvents( ON_PRE_COMMAND, false, containerStruct );
			if( command.GetCommandTag() == ACTION_RETALIATE || command.GetCommandTag() == ACTION_RANGED_RETALIATE )
			{
				command.GetAbilityTarget().TriggerEvents(ON_PRE_RETALIATION, false, containerStruct );
			}
		}

		mCurrentCommand[playerIndex] = command;
		PopFrontQueue( playerIndex );
		if( mCurrentCommand[playerIndex].GetAbility() != none)
		{
			;
		}
		;
		return true;
	}
	else 
	{
		;
		return false;
	}
}

// returns the front element in the queue and removes it
protected function H7Command GetFrontQueue( int playerIndex )
{
	local H7Command currentCommand;

	if( class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() )
	{
		foreach mCommandQueue( currentCommand )
		{
			if( currentCommand.GetCommandSource().GetPlayer().GetPlayerNumber() == playerIndex )
			{
				return currentCommand;
			}
		}
		return none;
	}
	else
	{
		if( mCommandQueue.Length > 0 )
		{
			currentCommand = mCommandQueue[0];
			return currentCommand;
		}
		else
		{
			return none;
		}
	}
}

function H7Command PopFrontQueue( int playerIndex )
{
	local H7Command currentCommand;

	currentCommand = GetFrontQueue( playerIndex );
	mCommandQueue.RemoveItem( currentCommand );
	return currentCommand;
}

/**
 * Dequeue if possible and extecute next command in chain
 ***/
protected function StartNextCommand( int playerIndex )
{
	if( Dequeue( playerIndex ) )
	{ 
		StartUnitCommand( playerIndex );
	}
}

/**
 * Update current command
 **/
function bool UpdateCommand()
{
	local int i, numPlayers;

	if( class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() )
	{
		numPlayers = class'H7AdventureController'.static.GetInstance().GetPlayers().length;
		for( i = 0; i < numPlayers; ++i )
		{
			UpdateCommandByPlayerIndex( i );
		}
		return true;
	}
	else
	{
		return UpdateCommandByPlayerIndex( 0 );
	}
}

protected function bool UpdateCommandByPlayerIndex( int playerIndex )
{
	local H7EventContainerStruct containerStruct;
	local H7ICaster caster;
	local H7Command currentCommand;
	local H7CombatResult currentResult;

	currentCommand = mCurrentCommand[playerIndex];
	if( currentCommand != none )
	{
		caster = currentCommand.GetCommandSource();
		if( H7Unit( caster ) != none && H7Unit( caster ).IsDead() )
		{
			;
			RemoveCmdsForCaster( caster );
			if( GetCurrentCommand() != none && 
				GetCurrentCommand().GetCommandSource() == caster && 
				GetCurrentCommand().IsRunning() &&
				class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() &&
				!class'H7CombatController'.static.GetInstance().IsSomeoneDying() )
			{
				GetCurrentCommand().CommandStop();
				GetCurrentCommand().CommandFinish();
				mCurrentCommand[0] = none;
			}
			return true;
		}
	}

	if( currentCommand == none )
	{
		if( mCommandQueue.Length == 0 )
		{
			return false;
		}
		else
		{
			StartNextCommand( playerIndex );
		}
	}
	else if( !currentCommand.CommandUpdate() )
	{
		if( mCommandQueue.Length == 0 )
		{
			if( currentCommand != none )
			{
				caster = currentCommand.GetCommandSource() ;

				if(!currentCommand.HasRaisedEvents())
				{
					containerStruct.Action = currentCommand.GetCommandTag();
					containerStruct.EffectContainer = currentCommand.GetAbility();
					containerStruct.Targetable = currentCommand.GetAbilityTarget();
					// try to get the last attack result for ON_TRIGGER_RETALIATION (current result may hold expired buff data)
					//containerStruct.Result = class'H7ReplicationInfo'.static.GetInstance().GetGameProcessor().GetLastAttackResult();
					// get the main result because it's the most up to date
					containerStruct.Result =  class'H7ReplicationInfo'.static.GetInstance().GetGameProcessor().GetMainResult();
					//containerStruct.Result = class'H7ReplicationInfo'.static.GetInstance().GetGameProcessor().GetCurrentResult();
					// store the real current result (it might be overwritten bei retaliation shenanigans!)
					currentResult = class'H7ReplicationInfo'.static.GetInstance().GetGameProcessor().GetCurrentResult();

					// if the last attack result was somehow none, use this
					if( containerStruct.Result == none )
					{
						containerStruct.Result = currentResult;
					}

					if(currentCommand.ReplaceFakeAttacker())
					{
						containerStruct.Result.SetAttacker(currentCommand.GetCommandSource());
					}

					if( currentCommand.GetAbility() != none )       { currentCommand.GetAbility().GetAllTags( containerStruct.ActionTag );  }
					
					currentCommand.GetCommandSource().TriggerEvents( ON_TRIGGER_RETALIATION, false, containerStruct );
					if( currentCommand.GetAbilityTarget() != none ) { currentCommand.GetAbilityTarget().TriggerEvents( ON_TRIGGER_RETALIATION, false, containerStruct ); }
					
					// switch out combat result to the correct one
					containerStruct.Result = currentResult;

					currentCommand.GetCommandSource().TriggerEvents( ON_PRE_POST_COMMAND, false, containerStruct );
					if( currentCommand.GetAbilityTarget() != none ) { currentCommand.GetAbilityTarget().TriggerEvents( ON_PRE_POST_COMMAND, false, containerStruct ); }

					currentCommand.GetCommandSource().TriggerEvents( ON_POST_COMMAND, false, containerStruct );
					if( currentCommand.GetAbilityTarget() != none ) { currentCommand.GetAbilityTarget().TriggerEvents( ON_POST_COMMAND, false, containerStruct ); }

					if( currentCommand.GetAbilityTarget() != none && currentCommand.GetCommandTag() == ACTION_RETALIATE || currentCommand.GetCommandTag() == ACTION_RANGED_RETALIATE )
					{
						currentCommand.GetAbilityTarget().TriggerEvents(ON_POST_RETALIATION, false, containerStruct );
						H7Unit( caster ).TriggerEvents(ON_POST_RETALIATION, false, containerStruct );
					}

					if(H7Unit( caster ) != none)
					{
						H7Unit( caster ).SetIgnoreAllegiances( false );
					}
						
					currentCommand.CommandFinish();
					currentCommand.SetHasRaisedEvents(true);
				}
			}
			mCurrentCommand[playerIndex] = none;
		}
		else
		{
			if( currentCommand != none )
			{
				caster = currentCommand.GetCommandSource() ;

				if(!currentCommand.HasRaisedEvents())
				{
					containerStruct.Action = currentCommand.GetCommandTag();
					containerStruct.EffectContainer = currentCommand.GetAbility();
					containerStruct.Targetable = currentCommand.GetAbilityTarget();
					// try to get the last attack result for ON_TRIGGER_RETALIATION (current result may hold expired buff data)
					containerStruct.Result = class'H7ReplicationInfo'.static.GetInstance().GetGameProcessor().GetLastAttackResult();
					//containerStruct.Result = class'H7ReplicationInfo'.static.GetInstance().GetGameProcessor().GetCurrentResult();
					// store the real current result (it might be overwritten bei retaliation shenanigans!)
					currentResult = class'H7ReplicationInfo'.static.GetInstance().GetGameProcessor().GetCurrentResult();

					// if the last attack result was somehow none, use this
					if( containerStruct.Result == none )
					{
						containerStruct.Result = currentResult;
					}

					if(currentCommand.ReplaceFakeAttacker())
					{
						containerStruct.Result.SetAttacker(currentCommand.GetCommandSource());
					}

					if( currentCommand.GetAbility() != none )       { currentCommand.GetAbility().GetAllTags( containerStruct.ActionTag );  }
					
					currentCommand.GetCommandSource().TriggerEvents( ON_TRIGGER_RETALIATION, false, containerStruct );
					if( currentCommand.GetAbilityTarget() != none ) { currentCommand.GetAbilityTarget().TriggerEvents( ON_TRIGGER_RETALIATION, false, containerStruct ); }
					
					// switch out combat result to the correct one
					containerStruct.Result = currentResult;

					currentCommand.GetCommandSource().TriggerEvents( ON_PRE_POST_COMMAND, false, containerStruct );
					if( currentCommand.GetAbilityTarget() != none ) { currentCommand.GetAbilityTarget().TriggerEvents( ON_PRE_POST_COMMAND, false, containerStruct ); }

					currentCommand.GetCommandSource().TriggerEvents( ON_POST_COMMAND, false, containerStruct );
					if( currentCommand.GetAbilityTarget() != none ) {currentCommand.GetAbilityTarget().TriggerEvents( ON_POST_COMMAND, false, containerStruct ); }

					if( currentCommand.GetAbilityTarget() != none && (currentCommand.GetCommandTag() == ACTION_RETALIATE || currentCommand.GetCommandTag() == ACTION_RANGED_RETALIATE ))
					{
						currentCommand.GetAbilityTarget().TriggerEvents(ON_POST_RETALIATION, false, containerStruct );
						H7Unit( caster ).TriggerEvents(ON_POST_RETALIATION, false, containerStruct );
					}

					if(H7Unit( caster ) != none)
					{
						H7Unit( caster ).SetIgnoreAllegiances( false );
					}

					currentCommand.CommandFinish();
					currentCommand.SetHasRaisedEvents(true);
				}
			}
			StartNextCommand( playerIndex );
		}
	}
	return true;
}

/***
 * Remove item in queue with given index 
 * */
protected function Remove(int index)
{
	mCommandQueue.Remove( index, 1);
}

/**
 * Removes all commands for a certain caster in the queue 
 * */
function RemoveCmdsForCaster( H7ICaster caster )
{
	local int  i;
	local array<int> commandsToRemove;

	for( i=0;i<mCommandQueue.Length; ++i)
	{
		if( mCommandQueue[i].GetCommandSource().GetID() == caster.GetID() )
		{
			commandsToRemove.AddItem( i );
		}
	}
	
	for ( i=0; i<commandsToRemove.Length;++i)
	{
		Remove( commandsToRemove[i] );
	}	
}

/**
 * Removes all commands with a certain target in the queue 
 * */
function RemoveCmdsForTarget( H7IEffectTargetable target )
{
	local int  i;
	local array<int> commandsToRemove;
	local H7ICaster source;

	for( i=0;i<mCommandQueue.Length; ++i)
	{
		if( mCommandQueue[i].GetAbilityTarget() == none ) continue;

		if( mCommandQueue[i].GetAbilityTarget().GetID() == target.GetID() )
		{
			source = mCommandQueue[i].GetCommandSource();
			if( mCommandQueue[i].GetCommand() == UC_ABILITY && H7CreatureStack( source ) != none )
			{
				// BugFix - Preemtive Strike vs. Arcane Empowerment
				if(class'H7CombatController'.static.GetInstance().GetActiveUnit() ==  H7CreatureStack( source ) )
				{
					 H7CreatureStack( source ).MakeTurn( true, true );
				}

				if( source == GetCurrentCommand().GetCommandSource() )
				{
					if( GetCurrentCommand().GetCommandTag() == ACTION_MOVE_ATTACK && GetCurrentCommand().GetAbilityTarget() == mCommandQueue[i].GetAbilityTarget() )
					{
						if( mLastCommandExecuted == ACTION_MOVE_ATTACK )
						{
							mLastCommandExecuted = ACTION_MOVE;
						}
						GetCurrentCommand().SetCommandTag( ACTION_MOVE );
					}
				}
			}
			commandsToRemove.AddItem( i );
		}
	}
	for ( i=0; i<commandsToRemove.Length;++i)
	{
		Remove( commandsToRemove[i] );
	}
}

/**
 * Gets all commands for a certain caster in the queue 
 * */
function array<H7Command> GetCmdsForCaster( H7ICaster caster )
{
	local int  i, playerCount;
	local array<H7Command> commands;

	for( i=0;i<mCommandQueue.Length; ++i)
		if( mCommandQueue[i].GetCommandSource().GetID() == caster.GetID() )
			commands.AddItem( mCommandQueue[i] );

	playerCount = class'H7AdventureController'.static.GetInstance() != none ? class'H7AdventureController'.static.GetInstance().GetNumOfPlayers() : 3;
	for( i=0; i < playerCount; i++)
	{
		if( mCurrentCommand[i] != none && mCurrentCommand[i].GetCommandSource().GetID() == caster.GetID() )
		{
			commands.AddItem( mCurrentCommand[i] );
		}
	}
	
	return commands;
}

protected function StartUnitCommand( int playerIndex )
{
	local H7Command currentCommand;

	currentCommand = mCurrentCommand[playerIndex];
	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() || !class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() || currentCommand.GetCommandSource().GetPlayer().IsControlledByLocalPlayer() )
	{
		class'H7PlayerController'.static.GetPlayerController().SetIsUnrealInputAllowed( false );
	}

	;	

	currentCommand.CommandPlay();
	if( currentCommand.GetCommandSource().GetPreparedAbility() != none ) // OPTIONAL might not be neccessary everytime. ie if default ability
	{
		class'H7PlayerController'.static.GetPlayerController().GetHud().GetSpellbookCntl().GetQuickBar().UnSelectSpell();
		class'H7PlayerController'.static.GetPlayerController().GetHud().GetSpellbookCntl().RemoveSpellFromCursor();
	}
	currentCommand.GetCommandSource().DataChanged("StartUnitCommand");
}

function bool IsReadyToEndTurn()
{
	// if the last command executed is ACTION_MOVE_ATTACK, we cannot end the turn because we have to execute yet the attack (can happen in multiplayer that the attack command is not yet in the queue)
	return mCommandQueue.Length == 0 && GetCurrentCommand() == none && mLastCommandExecuted != ACTION_MOVE_ATTACK;
}

protected function InterruptCaster( H7ICaster caster )
{
	local int i, playerCount;

	playerCount = class'H7AdventureController'.static.GetInstance() != none ? class'H7AdventureController'.static.GetInstance().GetNumOfPlayers() : 3;
	for( i=0; i < playerCount; i++)
	{
		if( mCurrentCommand[i] != none && mCurrentCommand[i].GetCommandSource() == caster )
		{
			mCurrentCommand[i].SetInterruptOnNextUpdate( true );
		}
	}

	RemoveCmdsForCaster( caster );
}

function bool IsEmpty()
{
	return ( ( ( GetCurrentCommand() != none && !IsCommandRunning() ) || GetCurrentCommand() == none ) && mCommandQueue.Length == 0 );
}

function Clear()
{
	if( !IsEmpty() )
	{
		if(GetCurrentCommand() != none || GetCurrentCommand().GetCommandSource() != none )
		{
			InterruptCaster( GetCurrentCommand().GetCommandSource() );
		}
		else
		{
			;
		}

	}

	mCommandQueue.Length = 0;

	if(mLastCommandResult!=None)
		mLastCommandResult.ClearResult();
}
