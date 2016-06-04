//=============================================================================
// H7SimTurnCommandManager
//
// Showdebug simturns: shows the real time debug info on screen
//
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7SimTurnCommandManager extends Object
	dependson(H7StructsAndEnumsNative);

var protected array<H7SimTurnBaseCommand>		mCommandQueue;
var protected int								mUnitActionCounter;
var protected array<MPSimTurnOngoingTrade>		mOngoingTrades;
var protected array<H7AdventureHero>            mOngoingInteractions; // popups etc
var protected MPSimTurnOngoingStartCombat		mOngoingStartCombat; // only can be one ongoing start combat at the same time
var protected float                             mStartCombatTime;

// used to set the Sender of the next command that will be added to the mCommandQueue
var protected H7CombatPlayerController	mNextAddCommandPlayerController;

var protected bool mIsNormalCombatTriggered; // a start combat instant command was executed (not quickcombat), all the commands will be canceled until the combat starts

function SetNextAddCommandPlayerController( H7CombatPlayerController newPlayerController )	{ mNextAddCommandPlayerController = newPlayerController; }
function UpdateUnitActionCounter( int newUnitActionCounter )								{ mUnitActionCounter = newUnitActionCounter; }
function int GetUnitActionCounter()															{ return mUnitActionCounter; }
function MPSimTurnOngoingStartCombat GetOngoingStartCombat()								{ return mOngoingStartCombat; }

function AddCommand( int unitActionCounter, EUnitCommand command, ECommandTag commandTag, H7ICaster commandSource, H7IEffectTargetable target, int teleportTarget, array<H7BaseCell> path, 
	optional H7BaseAbility ability = none, optional EDirection direction, optional bool replaceFakeAttacker, optional bool insertHead, optional H7CombatMapCell trueHitCell, optional bool doOOSCheck, optional int movementPoints )
{
	local MPCommand newCommand;
	local H7SimTurnNormalCommand newSimTurnCommand;
	local H7AdventurePlayerController adventurePlayerController;

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
	newCommand.TeleportTarget = teleportTarget;
	newCommand.TrueHitCell = trueHitCell;
	newCommand.doOOSCheck = doOOSCheck;
	newCommand.movementPoints = movementPoints;

	newSimTurnCommand = new class'H7SimTurnNormalCommand';
	newSimTurnCommand.SetCommand( newCommand );
	newSimTurnCommand.SetSender( mNextAddCommandPlayerController );
	newSimTurnCommand.SetSimTurnCommandManager( self );

	// a retreat move should have maximum priority because can happen that other commands are waiting for the retreat to finish
	if( mOngoingStartCombat.Target != none && mOngoingStartCombat.TargetAnswer == STSCA_RETREAT && mOngoingStartCombat.Target == commandSource )
	{
		if( command != UC_MOVE && mCommandQueue.Length > 0 && mCommandQueue[0].GetSender() == newSimTurnCommand.GetSender() )
		{
			// put the command that is not move in the second position, the first is occupied by the move command
			mCommandQueue.InsertItem( 1, newSimTurnCommand );
		}
		else
		{
			// put the retreat at the front of the queue
			mCommandQueue.InsertItem( 0, newSimTurnCommand );
		}
	}
	else
	{
		// put the command at the bottom of the queue
		mCommandQueue.AddItem( newSimTurnCommand );
	}

	if(command == UC_VISIT && target.IsA('H7Town') && target.GetPlayer() == commandSource.GetPlayer())
	{
		// don't reset end turn if player just opened town screen by a visit command
		return;
	}
	// reset end turn state if it was set for this player
	adventurePlayerController = H7AdventurePlayerController(mNextAddCommandPlayerController);
	if(adventurePlayerController != none && adventurePlayerController.GetPlayerReplicationInfo().IsTurnFinished())
	{
		adventurePlayerController.GetPlayerReplicationInfo().ResetTurnFinished();
		adventurePlayerController.ResetEndTurn();
	}
}

function AddInstantCommand( MPInstantCommand instantCommand )
{
	local H7SimTurnInstantCommand newSimTurnCommand;
	local H7AdventurePlayerController adventurePlayerController;

	newSimTurnCommand = new class'H7SimTurnInstantCommand';
	newSimTurnCommand.SetCommand(instantCommand);
	newSimTurnCommand.SetSender( mNextAddCommandPlayerController );
	newSimTurnCommand.SetSimTurnCommandManager( self );

	mCommandQueue.AddItem(newSimTurnCommand);

	// reset end turn state if it was set for this player
	adventurePlayerController = H7AdventurePlayerController(mNextAddCommandPlayerController);
	if(adventurePlayerController != none && adventurePlayerController.GetPlayerReplicationInfo().IsTurnFinished() && instantCommand.Type != ICT_END_TURN)
	{
		adventurePlayerController.GetPlayerReplicationInfo().ResetTurnFinished();
		adventurePlayerController.ResetEndTurn();
	}
}

// returns true if a command was removed from the queue
function bool Update()
{
	local H7SimTurnBaseCommand currentCommand;

	// if the on going combat takes too much time -> reset
	if( mOngoingStartCombat.StartTimer != 0 && class'WorldInfo'.static.GetWorldInfo().RealTimeSeconds - mOngoingStartCombat.StartTimer > 60.f )
	{
		FinishOngoingStartCombat( false, true, false );
	}

	foreach mCommandQueue( currentCommand )
	{
		// looking for commands that can be executed 
		// and that doesn't have another command of the same player in the queue with closer position to the front of the queue
		if( currentCommand.CanBeExecuted() && IsFirstCommandOfPlayer( currentCommand ) )
		{
			// if the command was not canceled -> execute (send it to all the players)
			if( mIsNormalCombatTriggered || currentCommand.CancelCommandIfIlegal() )
			{
				;
				if(class'WorldInfo'.static.GetWorldInfo().RealTimeSeconds < mStartCombatTime + 3.5f)
				{
					// allow to do instant commands for 3 more seconds before the combat starts
					RemoveAllNormalCommands( currentCommand.GetSender() );
					if(currentCommand.isA('H7SimTurnNormalCommand'))
					{
						return true;
					}
				}
				else
				{
					// remove all the commands of the player
					RemoveAllCommands( currentCommand.GetSender() );
					return true;
				}
			}
			
			currentCommand.ExecuteCommand();
			++mUnitActionCounter;

			// check if the move is the pending retreat
			if( mOngoingStartCombat.TargetAnswer == STSCA_RETREAT && currentCommand.IsRetreat( mOngoingStartCombat.Target.GetID() )  )
			{
				FinishOngoingStartCombat( true, false, false );
			}

			// register the start of a normal combat
			if( currentCommand.IsDoNormalCombat() )
			{
				mIsNormalCombatTriggered = true;
				mStartCombatTime = class'WorldInfo'.static.GetWorldInfo().RealTimeSeconds;
			}

			// remove the command
			mCommandQueue.RemoveItem( currentCommand );
			
			return true;
		}
	}

	return false;
}

//  if thePlayer == none -> remove all the commands of all the players
protected function RemoveAllCommands( optional H7CombatPlayerController thePlayer = none )
{
	local int i;

	for( i = mCommandQueue.Length - 1; i >= 0; --i )
	{
		if( thePlayer == none || mCommandQueue[i].GetSender() == thePlayer )
		{
			mCommandQueue.Remove( i, 1 );
		}
	}
}

//  if thePlayer == none -> remove all the commands of all the players
protected function RemoveAllNormalCommands( optional H7CombatPlayerController thePlayer = none )
{
	local int i;

	for( i = mCommandQueue.Length - 1; i >= 0; --i )
	{
		if( thePlayer == none || mCommandQueue[i].GetSender() == thePlayer )
		{
			if(mCommandQueue[i].IsA('H7SimTurnNormalCommand'))
			{
				mCommandQueue.Remove( i, 1 );
			}
		}
	}
}

// false -> there is another command of the same player that is closer to the front of the queue
protected function bool IsFirstCommandOfPlayer( H7SimTurnBaseCommand command )
{
	local H7SimTurnBaseCommand currentCommand;

	foreach mCommandQueue( currentCommand )
	{
		if( command == currentCommand )
		{
			return true;
		}
		if( command.GetSender() == currentCommand.GetSender() )
		{
			return false;
		}
	}
	return false;
}

// returns the next command in the queue that is attached to a move (UC_MEET, UC_VISIT), if doesnt find anyone return none
function H7SimTurnBaseCommand GetCommandAttachedToMove( H7SimTurnBaseCommand moveCommand )
{
	local H7SimTurnBaseCommand currentCommand;
	local bool startSearching;

	startSearching = false;
	foreach mCommandQueue( currentCommand )
	{
		if( startSearching )
		{
			if( currentCommand.GetSender() == moveCommand.GetSender() )
			{
				return currentCommand;
			}
		}
		else
		{
			if( moveCommand == currentCommand )
			{
				startSearching = true;
			}
		}
	}
	return none;
}

function InsergOngoingInteraction( H7AdventureHero source )
{
	mOngoingInteractions.AddItem( source );
}

function RemoveOngoingInteraction( H7AdventureHero source )
{
	mOngoingInteractions.RemoveItem(source);
}

function InsertOngoingTrade( H7AdventureHero source, H7AdventureHero target )
{
	local MPSimTurnOngoingTrade trade;

	trade.Source = source;
	trade.Target = target;
	mOngoingTrades.AddItem( trade );
}

function RemoveOngoingTrade( H7AdventureHero source )
{
	local H7SimTurnBaseCommand currentCommand;
	local int i;

	for( i=0; i<mOngoingTrades.Length; ++i )
	{
		if( mOngoingTrades[i].Source == source )
		{
			foreach mCommandQueue( currentCommand )
			{
				currentCommand.UpdateTradeFinished( mOngoingTrades[i].Target );
			}
			mOngoingTrades.Remove( i, 1 );
			return;
		}
	}
	class'H7ReplicationInfo'.static.PrintLogMessage("Trying to remove a trade that doesnt exist in the mOngoingTrades" @ source, 0);;
}

function bool IsInOngoingTrade( H7AdventureHero hero )
{
	local int i;

	for( i=0; i<mOngoingTrades.Length; ++i )
	{
		if( mOngoingTrades[i].Source == hero || mOngoingTrades[i].Target == hero )
		{
			return true;
		}
	}
	return false;
}

function CancelAllTrades()
{
	mOngoingTrades.Length = 0;
}

function CancelAllInteractions()
{
	mOngoingInteractions.Length = 0;
}

function CancelTrade( bool doCancelTrade, int heroId )
{
	local int i;

	if( doCancelTrade )
	{
		for( i = 0; i < mOngoingTrades.Length; ++i )
		{
			if( mOngoingTrades[i].Target.GetID() == heroId )
			{
				mOngoingTrades[i].Source.GetPlayer().GetAdventurePlayerController().SendCancelTrade();
			}
		}
	}
	else
	{
		// the player doesnt want to cancel the trade, remove all the commands with this heroid as source
		RemoveCommandsBySource( heroId );
	}
}

protected function RemoveCommandsBySource( int sourceId )
{
	local int i;

	for( i = mCommandQueue.Length - 1; i >= 0; --i )
	{
		if( mCommandQueue[i].GetSourceId() == sourceId )
		{
			mCommandQueue.Remove( i, 1 );
		}
	}
}

function InsertOngoingStartCombat( H7AdventureHero source, H7AdventureHero target )
{
	class'H7AdventurePlayerController'.static.GetAdventurePlayerController().ServerPauseTurnTimer(true);

	if( mOngoingStartCombat.Source == none && mOngoingStartCombat.Target == none )
	{
		mOngoingStartCombat.Source = source;
		mOngoingStartCombat.SourceAnswer = STSCA_NOT_SET;
		mOngoingStartCombat.Target = target;
		mOngoingStartCombat.TargetAnswer = STSCA_NOT_SET;
		mOngoingStartCombat.StartTimer = class'WorldInfo'.static.GetWorldInfo().RealTimeSeconds;
	}
	else if( mOngoingStartCombat.Target == source && mOngoingStartCombat.TargetAnswer == STSCA_RETREAT ) // counterattack (the retreating army attacks the attacking army)
	{
		// atttacking to a different player that the one that attacked first, tell him that the combat finished
		if( mOngoingStartCombat.Source.GetPlayer() != target.GetPlayer() )
		{
			mOngoingStartCombat.Source.GetPlayer().GetAdventurePlayerController().SendStartCombatFinished( true, false, false );
		}

		mOngoingStartCombat.Source = source;
		mOngoingStartCombat.SourceAnswer = STSCA_NOT_SET;
		mOngoingStartCombat.Target = target;
		mOngoingStartCombat.TargetAnswer = STSCA_NOT_SET;
		mOngoingStartCombat.StartTimer = class'WorldInfo'.static.GetWorldInfo().RealTimeSeconds;
	}
	else
	{
		;
	}
}

function HandleAnswerStartCombat( ESimTurnStartCombatAnswer answer, int heroId )
{
	local bool doQuickCombat;
	local H7InstantCommandDoCombat command;

	if( mOngoingStartCombat.Source == none || mOngoingStartCombat.Target == none )
	{
		;
		return;
	}
	else if( mOngoingStartCombat.Source.GetID() == heroId )
	{
		if( mOngoingStartCombat.SourceAnswer == STSCA_NOT_SET )
		{
			mOngoingStartCombat.SourceAnswer = answer;
		}
		else
		{
			class'H7ReplicationInfo'.static.PrintLogMessage("Getting an answer for a combat that has already one answer mOngoingStartCombat.SourceAnswer current:" @ mOngoingStartCombat.SourceAnswer @ " new:" @ answer, 0);;
			return;
		}
	}
	else if( mOngoingStartCombat.Target.GetID() == heroId )
	{
		if( mOngoingStartCombat.TargetAnswer == STSCA_NOT_SET )
		{
			mOngoingStartCombat.TargetAnswer = answer;
		}
		else
		{
			class'H7ReplicationInfo'.static.PrintLogMessage("Getting an answer for a combat that has already one answer mOngoingStartCombat.TargetAnswer current:" @ mOngoingStartCombat.TargetAnswer @ " new:" @ answer, 0);;
			return;
		}
	}
	else
	{
		;
		return;
	}

	if( mOngoingStartCombat.Target.GetPlayer().IsNeutralPlayer() || mOngoingStartCombat.Target.GetPlayer().IsControlledByAI())
	{
		// the attacker player finish the interaction with the neutral army
		ResetOngoingStartCombat();
	}
	if( mOngoingStartCombat.SourceAnswer != STSCA_NOT_SET && mOngoingStartCombat.TargetAnswer != STSCA_NOT_SET )
	{
		// both players answered
		if( mOngoingStartCombat.SourceAnswer == STSCA_CANCEL )
		{
			// cancel combat
			FinishOngoingStartCombat( false, true, false );
		}
		else if( mOngoingStartCombat.TargetAnswer == STSCA_RETREAT && mOngoingStartCombat.Target.GetCurrentMovementPoints() >= 1.f )
		{
			// retreat
			mOngoingStartCombat.Source.GetPlayer().GetAdventurePlayerController().SendTargetIsRetreating();
			mOngoingStartCombat.Target.GetPlayer().GetAdventurePlayerController().SendRetreatConceded( mOngoingStartCombat.Target.GetID() );
		}
		else 
		{
			// quick combat or normal combat
			if( mOngoingStartCombat.TargetAnswer == STSCA_RETREAT )
			{ 
				// targetplayer selected retreat when he didnt have enough movemnent points, we pick the answer of targetsource
				doQuickCombat = mOngoingStartCombat.TargetAnswer == STSCA_QUICK_COMBAT;
			}
			else
			{
				doQuickCombat = mOngoingStartCombat.SourceAnswer == STSCA_QUICK_COMBAT && mOngoingStartCombat.TargetAnswer == STSCA_QUICK_COMBAT;
			}

			if(!mOngoingStartCombat.Target.GetAdventureArmy().HasUnits() && !(mOngoingStartCombat.Target.GetAdventureArmy().IsGarrisoned() || mOngoingStartCombat.Target.GetAdventureArmy().IsGarrisonedButOutside()))
			{
				doQuickCombat = true;
			}
			command = new class'H7InstantCommandDoCombat';
			command.Init( mOngoingStartCombat.Source, mOngoingStartCombat.Target, doQuickCombat, false, mOngoingStartCombat.Target.GetAdventureArmy().GetGarrisonedSite() );
			FinishOngoingStartCombat( false, false, !doQuickCombat );
			if( !doQuickCombat )
			{
				OnStartNormalCombat();
			}
			class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
		}
	}
}

function FinishOngoingStartCombat( bool isRetreatFinished, bool isCombatCanceled, bool isNormalCombatAboutToBegin )
{
	mOngoingStartCombat.Target.GetPlayer().GetAdventurePlayerController().SendStartCombatFinished( isRetreatFinished, isCombatCanceled, isNormalCombatAboutToBegin );
	mOngoingStartCombat.Source.GetPlayer().GetAdventurePlayerController().SendStartCombatFinished( isRetreatFinished, isCombatCanceled, isNormalCombatAboutToBegin );
	ResetOngoingStartCombat();
}

function HandleRetreatCancelled( int heroId )
{
	if( mOngoingStartCombat.TargetAnswer == STSCA_RETREAT && mOngoingStartCombat.Target.GetID() == heroId )
	{
		FinishOngoingStartCombat(true, false, false);
	}
}

function ResetOngoingStartCombat()
{
	class'H7AdventurePlayerController'.static.GetAdventurePlayerController().ServerPauseTurnTimer(false);

	mOngoingStartCombat.Source = none;
	mOngoingStartCombat.SourceAnswer = STSCA_NOT_SET;
	mOngoingStartCombat.Target = none;
	mOngoingStartCombat.TargetAnswer = STSCA_NOT_SET;
	mOngoingStartCombat.StartTimer = 0;
}

function bool IsOngoingStartCombat( optional H7AdventureHero hero = none )
{
	// dont block the hero that wants to retreat
	if( hero == mOngoingStartCombat.Target )
	{
		return false;
	}

	return ( mOngoingStartCombat.Source != none && mOngoingStartCombat.Target != none );
}

// hero -> hero that we want to check
function bool IsOngoingStartCombatAround( Vector initialPos, Vector targetPos, optional H7AdventureHero hero = none )
{
	local float safeDistance, maxDistanceRetreat;

	if( mOngoingStartCombat.Source != none && mOngoingStartCombat.Target != none )
	{
		// dont block the hero that wants to retreat
		if( hero == mOngoingStartCombat.Target )
		{
			return false;
		}

		// we cannot let other armies to do any action in the area where the target army can retreat
		if( !mOngoingStartCombat.Target.GetPlayer().IsNeutralPlayer() )
		{
			maxDistanceRetreat = mOngoingStartCombat.Target.GetCurrentMovementPoints() * class'H7BaseCell'.const.CELL_SIZE;
		}

		safeDistance = VSize( targetPos - initialPos );
		safeDistance += maxDistanceRetreat;
		safeDistance += class'H7BaseCell'.const.CELL_SIZE * 4.f; // safe margin
		if( VSize( initialPos - mOngoingStartCombat.Target.GetCell().GetLocation() ) < safeDistance )
		{
			return true;
		}
	}

	return false;
}

function bool IsOngoingTradeAround( Vector initialPos, Vector targetPos )
{
	local MPSimTurnOngoingTrade currentOngoingTrade;
	local float safeDistance;

	foreach mOngoingTrades( currentOngoingTrade )
	{
		safeDistance = VSize( targetPos - initialPos );
		safeDistance += class'H7BaseCell'.const.CELL_SIZE * 4.f; // safe margin

		if( VSize( initialPos - currentOngoingTrade.Source.GetCell().GetLocation() ) < safeDistance )
		{
			return true;
		}
	}

	return false;
}

function bool IsOngoingInteractionAround(Vector initialPos, Vector targetPos )
{
	local H7AdventureHero hero;
	local float safeDistance;

	foreach mOngoingInteractions(hero)
	{
		safeDistance = VSize( targetPos - initialPos );
		safeDistance += class'H7BaseCell'.const.CELL_SIZE * 4.f; // safe margin

		if( VSize( initialPos - hero.GetCell().GetLocation() ) < safeDistance )
		{
			return true;
		}
	}

	return false;
}

function OnEndNormalCombat()
{
	mIsNormalCombatTriggered = false;
}

function OnStartNormalCombat()
{
	ResetOngoingStartCombat();
	CancelAllTrades();
	CancelAllInteractions();
	RemoveAllNormalCommands();
}

function OnEndTurn()
{
	ResetOngoingStartCombat();
	CancelAllTrades();
	CancelAllInteractions();
	RemoveAllCommands();
}

function RenderDebug( Canvas myCanvas )
{
	local H7SimTurnBaseCommand currentSimTurnCommand;
	local MPSimTurnOngoingTrade currentOngoingTrade;
	local H7AdventureHero currentHero;
	local Color textColor;
	local Font textFont;
	local int xPos, yPos, zPos, counter;
	local float lifeTime;

	textFont = Font'enginefonts.TinyFont';
	myCanvas.Font = textFont;
	myCanvas.DrawColor = textColor;
	
	xPos = 10;
	yPos = 120;
	zPos = 1000000;
	textColor = MakeColor( 255, 0, 0, 255 );
	myCanvas.SetPos( xPos, yPos, zPos );
	myCanvas.DrawColor = textColor;
	myCanvas.DrawText( "SIM TURNS DEBUG" );

	yPos += 15;
	textColor = MakeColor( 255, 255, 255, 255 );
	myCanvas.SetPos( xPos, yPos, zPos );
	myCanvas.DrawColor = textColor;
	myCanvas.DrawText( "mUnitActionCounter:" @ mUnitActionCounter );

	yPos += 15;
	textColor = MakeColor( 200, 200, 200, 255 );
	myCanvas.SetPos( xPos, yPos, zPos );
	myCanvas.DrawColor = textColor;
	lifeTime = mOngoingStartCombat.StartTimer == 0.f ? 0.f : class'WorldInfo'.static.GetWorldInfo().RealTimeSeconds - mOngoingStartCombat.StartTimer;
	myCanvas.DrawText( "mOngoingStartCombat:" @ mOngoingStartCombat.Source @ mOngoingStartCombat.SourceAnswer @ mOngoingStartCombat.Target @ mOngoingStartCombat.TargetAnswer @ lifeTime );

	yPos += 15;
	textColor = MakeColor( 255, 0, 0, 255 );
	myCanvas.SetPos( xPos, yPos, zPos );
	myCanvas.DrawColor = textColor;
	myCanvas.DrawText( "mOngoingTrades:" );
	foreach mOngoingTrades(currentOngoingTrade, counter )
	{
		yPos += 15;
		textColor = counter % 2 == 0 ? MakeColor( 255, 255, 255, 255 ) : MakeColor( 200, 200, 200, 255 );
		myCanvas.SetPos( xPos + 10, yPos, zPos );
		myCanvas.DrawColor = textColor;
		myCanvas.DrawText( "Source:" @ currentOngoingTrade.Source @ "Target:" @ currentOngoingTrade.Target );
	}

	yPos += 15;
	textColor = MakeColor( 255, 0, 0, 255 );
	myCanvas.SetPos( xPos, yPos, zPos );
	myCanvas.DrawColor = textColor;
	myCanvas.DrawText( "mOngoingInteractions:" );
	foreach mOngoingInteractions(currentHero, counter )
	{
		yPos += 15;
		textColor = counter % 2 == 0 ? MakeColor( 255, 255, 255, 255 ) : MakeColor( 200, 200, 200, 255 );
		myCanvas.SetPos( xPos + 10, yPos, zPos );
		myCanvas.DrawColor = textColor;
		myCanvas.DrawText( "Source:" @ currentHero );
	}

	yPos += 15;
	textColor = MakeColor( 255, 0, 0, 255 );
	myCanvas.SetPos( xPos, yPos, zPos );
	myCanvas.DrawColor = textColor;
	myCanvas.DrawText( "mCommandQueue:" );
	foreach mCommandQueue(currentSimTurnCommand )
	{
		yPos += 15;
		textColor = counter % 2 == 0 ? MakeColor( 255, 255, 255, 255 ) : MakeColor( 200, 200, 200, 255 );
		myCanvas.SetPos( xPos + 10, yPos, zPos );
		myCanvas.DrawColor = textColor;
		myCanvas.DrawText( currentSimTurnCommand.GetDebugInfo() );
	}
}
