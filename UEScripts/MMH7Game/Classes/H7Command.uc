//=============================================================================
// H7Command
//=============================================================================
// Each caster has its own command structure. The command setup is either 
// determined by user input or by the units AI functions. The sequence of
// animations, movement, etc. is handled within the Update()-method once it is
// started by Play().
//
// If you add a new parameter, remember that needs to be replicated also, so 
// talk to Manuel
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7Command extends Object dependson( H7Player, H7StructsAndEnumsNative )
	native;


// active command type
var protected EUnitCommand			mCommandType;
// active command tag
var protected ECommandTag			mCommandTag;
// source unit the command is issued to
var protected H7ICaster				mSource;
// path for moving
var protected array<H7BaseCell>		mPath;
// ability that will be casted if the command is UC_ABILITY
var protected H7BaseAbility			mAbility;
// units and obstacles that will be hit by the ability
var protected H7IEffectTargetable	mAbilityTarget;
// whether we need to replicate or not
var protected bool					mDoMPSynchronization;

var protected bool                  mDoOOSCheck;
// direction of this command
var protected Edirection			mAbilityDirection;
// Replace Fake Attacker
var protected bool					mReplaceFakeAttacker;
// Insert the command to the head of the command queue Head
var protected bool					mInsertHead;
// Optional int parameter when all the stuff above is not enough
var protected int					mNumParam;
// Optional HitCell should hold actual cell under mouse, used for abilities with TARGET_AREA
var protected H7CombatMapCell		mTrueHitCell;

var protected H7FXStruct            mFX;

var protected bool                  mWasInterrupted;

// true if command is processed, false if stopped
var protected bool				mRunning;
// allows delegate functions to stop the command
var protected bool mInterruptOnNextUpdate;
// allows a hero sound then triggering the combatoverview
var protected H7Faction         mFaction;

var protected bool                              mRaisedEvents;


//get/set methods
// ==========================

function int                        GetNumParam()                                           { return mNumParam; }
function EUnitCommand				GetCommand()											{ return mCommandType; }
function ECommandTag				GetCommandTag()											{ return mCommandTag; }
function 				            SetCommandTag( ECommandTag tag )						{ mCommandTag = tag; }
function							SetCommandSource( H7ICaster unit )						{ mSource = unit; }
function H7ICaster					GetCommandSource()                                      { return mSource; }
function array<H7BaseCell>			GetPath()												{ return mPath; }
function bool                       IsMPSynchronized()                                      { return mDoMPSynchronization; }
function bool                       GetDoOOSCheck()                                         { return mDoOOSCheck; }
function bool                       ReplaceFakeAttacker()                                   { return mReplaceFakeAttacker; }
function bool                       InsertHead()                                            { return mInsertHead; }
function H7FXStruct                 GetFX()                                                 { return mFX; }
function                            SetFX( H7FXStruct fx )                                  { mFX = fx; }
function bool					    WasInterrupted()                                        { return mWasInterrupted; }
function                            SetInterrupted( bool val )                              { mWasInterrupted = val; }

function						    SetAbility( H7BaseAbility ability )						{ mAbility = ability; }
function H7BaseAbility   		    GetAbility()											{ return mAbility; }
function						    SetAbilityTarget( H7IEffectTargetable target )	        { mAbilityTarget = target; }
function H7IEffectTargetable		GetAbilityTarget()	                                    { return mAbilityTarget; }
function EDirection                 GetAbilityDirection()                                   { return mAbilityDirection; }

function bool					    IsRunning()												{ return mRunning; }

function bool                       ShouldInterruptOnNextUpdate()                           { return mInterruptOnNextUpdate; }
function                            SetInterruptOnNextUpdate( bool stop )                   { mInterruptOnNextUpdate = stop; }

function bool                       HasRaisedEvents()                                       { return mRaisedEvents; }
function                            SetHasRaisedEvents(bool hasRaised)                      { mRaisedEvents = hasRaised; }
function H7CombatMapCell			GetTrueHitCell()										{ return mTrueHitCell; }

// methods
// =======

static function H7Command CreateCommand(	H7ICaster caster,
											EUnitCommand commandType,
											optional ECommandTag commandTag = ACTION_MAX,
											optional H7BaseAbility ability,
											optional H7IEffectTargetable target,
											optional array<H7BaseCell> path,
											optional bool doMPSynchronization = true,
											optional EDirection direction = EDirection_MAX,
											optional bool replaceFakeAttacker = false,
											optional bool insertHead = false,
											optional int numParam = -1,
											optional H7CombatMapCell trueHitCell,
											optional bool doOOSCheck = true)
{
	local H7Command command;
	
	command = new class'H7Command';
	command.InitCommand( caster, commandType, commandTag, ability, target, path, doMPSynchronization, direction, replaceFakeAttacker, insertHead, numParam, trueHitCell, doOOSCheck );
	
	return command;
}

protected function InitCommand(
						H7ICaster source,
						EUnitCommand commandType,
						optional ECommandTag commandTag,
						optional H7BaseAbility ability,
						optional H7IEffectTargetable target,
						optional array<H7BaseCell> path,
						optional bool doMPSynchronizaton,
						optional EDirection direction = EDirection_MAX,
						optional bool replaceFakeAttacker = false,
						optional bool insertHead = false,
						optional int numParam = -1,
						optional H7CombatMapCell trueHitCell,
						optional bool doOOSCheck)
{
	mSource = source;
	mCommandType = commandType;
	mCommandTag = commandTag;
	mAbility = ability;
	mAbilityTarget = target;
	mPath = path;
	mDoMPSynchronization = doMPSynchronizaton;
	mAbilityDirection = direction;
	mReplaceFakeAttacker = replaceFakeAttacker;
	mInsertHead = insertHead;
	mNumParam = numParam;
	mTrueHitCell = trueHitCell;
	mDoOOSCheck = doOOSCheck;

	mRaisedEvents = false;
}

// starts the playback of the command
function CommandPlay()
{
	local H7ICaster source;
	local H7EventContainerStruct container;

	if( !mRunning )
	{
		if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
		{
			class'H7CombatMapGridController'.static.GetInstance().SetDecalDirty( true );
		}

		if( class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() 
			&& mSource.GetPlayer() == class'H7AdventureController'.static.GetInstance().GetLocalPlayer()
			&& mCommandType != UC_MOVE)
		{
			class'H7PlayerController'.static.GetPlayerController().SetCommandRequested(false);
			class'H7PlayerController'.static.GetPlayerController().GetHud().UnblockAllFlashMovies();
		}

		source = GetCommandSource();
		container.Targetable = GetAbilityTarget(); // TODO: it only needs the targetable?

		if( H7CreatureStack( source ) != none && ( GetCommandTag() == ACTION_RANGE_ATTACK || GetCommandTag() == ACTION_MELEE_ATTACK ) )
		{
			H7CreatureStack( source ).DoLuckRoll( container );
		}
		else if( H7EditorHero( source ) != none && GetCommandTag() == ACTION_ABILITY )
		{
			H7EditorHero( source ).DoLuckRoll( container );
		}

		class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();

		if( H7Unit( mSource ) != none )
		{
			H7Unit( mSource ).StatusChanged();
		}
		mRunning = true;
		mSource.GetEffectManager().AddToFXQueue( mFX, mFX.mSource );
		
		switch( mCommandType )
		{
			case UC_MOVE: 
				CmdInit_Move(); 
				break;
			case UC_ABILITY:
				CmdInit_Ability();
				break;
			case UC_VISIT:
				CmdInit_Visit(); 
				break;
			case UC_RECRUIT:
				CmdInit_Recruit(); 
				break;
			case UC_MEET:
				CmdInit_Meet();
				break;
			case UC_GARRISON:
				CmdInit_Garrison();
				break;
			case UC_SKIP_TURN:
				CmdInit_SkipTurn();
				break;
			case UC_UPGRADE:
				CmdInit_Upgrade();
				break;

			default:
				;
		}
	}
}


function bool ShouldMakeTurn()
{
	local H7ICaster caster;

	caster = GetCommandSource();

	return (
		    class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() &&
		    H7Unit( caster ) != none &&
		    GetCommandTag() != ACTION_RETALIATE &&
		    GetCommandTag() != ACTION_RANGED_RETALIATE &&
		    GetCommandTag() != ACTION_REPEAT &&
			GetCommandTag() != ACTION_DOUBLE_MELEE_ATTACK &&
			GetCommandTag() != ACTION_DOUBLE_RANGED_ATTACK &&
		    ( GetAbility() == none ||
		    !GetAbility().IsEqual(  H7Unit( caster ).GetWaitAbility() ) )
		    );
}


// stops the playback of the command (this should only be called internaly, but can be used to force completion)
function CommandStop()
{
	local bool notFinished;
	local array<H7Command> cmds;
	if(class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() )
	{
		if( class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() )
		{
			if(class'H7AdventureController'.static.GetInstance() != none && mSource.GetPlayer() == class'H7AdventureController'.static.GetInstance().GetLocalPlayer())
			{
				class'H7PlayerController'.static.GetPlayerController().SetCommandRequested(false);
			}
		}
		else
		{
			class'H7PlayerController'.static.GetPlayerController().SetCommandRequested(false);
		}
	}

	if( !mRunning )
	{
		;
		ScriptTrace();
	}

	if( H7AdventureHero( mSource ) != none && H7AdventureHero( mSource ).GetAiLastScoreAction() != none && mCommandType != UC_MOVE )
	{
		H7AdventureHero( mSource ).GetAdventureArmy().SetAiTensionValue( H7AdventureHero( mSource ).GetAiLastScoreAction().mABID, 1.0f );
	}
	;
	if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() )
	{
		if( class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() )
		{
			class'H7AdventureController'.static.GetInstance().CalculateInputAllowed( mSource.GetPlayer() );
		}
		else
		{
			class'H7AdventureController'.static.GetInstance().CalculateInputAllowed();
		}
	}
	else
	{
		class'H7CombatController'.static.GetInstance().CalculateInputAllowed();
	}

	if( mRunning )
	{
		class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();
		mRunning = false;
		;

		// don't end turn on MOVE_ATTACK, because this commands adds a MELEE_ATTACK
		// anyway and would call MakeTurn two times which results in skipped morale turns
		if( ShouldMakeTurn() && GetCommandTag() != ACTION_MOVE_ATTACK )
		{
			notFinished = H7Unit( mSource ).MakeTurn();
			if( notFinished )
			{
				class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().SetInitiativeInfo();
			}
		}

		if( H7CombatHero( mSource ) != none )
		{
			// recalculate attack count before CanMakeAction check
			H7Unit( mSource ).ClearStatCache();
			
			cmds = class'H7CombatController'.static.GetInstance().GetCommandQueue().GetCmdsForCaster( mSource );
			if( H7CombatHero( mSource ).CanMakeAction() && cmds.Length == 0 )
			{
				class'H7CombatController'.static.GetInstance().SetPreviousActiveUnit();
			}
		}

		if( H7CreatureStack( mSource ) != none && H7CreatureStack( mSource ).ShouldRestoreRotationAfterTurn() && !H7CreatureStack( mSource ).HasDelayedCommand() )
		{
			H7CreatureStack( mSource ).RestoreRotation();
			H7CreatureStack( mSource ).AfterStrikeAndReturnMove();
			class'H7CombatController'.static.GetInstance().RefreshAllUnits();
			class'H7CombatMapGridController'.static.GetInstance().RecalculateReachableCells();
		}

		if( H7WarUnit( mSource ) != none )
			H7WarUnit( mSource ).PrepareDefaultAbility();
	}
}

function CommandFinish()
{
	local H7CombatMapGridController gridCntl;
	local H7CombatController cmbtCntl;
	local H7Unit unit;
	local H7CreatureStack stack;

	gridCntl = class'H7CombatMapGridController'.static.GetInstance();
	cmbtCntl = class'H7CombatController'.static.GetInstance();
	if( gridCntl == none || cmbtCntl == none )
	{
		return;
	}

	unit = H7Unit( mSource );
	stack = H7CreatureStack( unit );

	if( stack != none )
	{
		stack.GetPathfinder().ForceUpdate();
	}

	if( unit != none && unit.CanMakeAction() )
	{
		gridCntl.SetDecalDirty( true );
		
		if( unit == cmbtCntl.GetActiveUnit() )
		{
			if( stack != none )
			{
				if( stack.CanMove() && ( cmbtCntl.AllAnimationsDone() || ( !cmbtCntl.AllAnimationsDone() && cmbtCntl.GetCommandQueue().IsEmpty() ) ) )
				{
					gridCntl.CalculateReachableCellsFor( stack, stack.GetMovementPoints() );
					stack.GetPathfinder().ForceUpdate();
				}
				if( mCommandType == UC_MOVE )
				{
					stack.SetMovedThisTurn( false );
				}
				if( stack.CanMakeAction() )
				{
					cmbtCntl.DoNewUnitHudUpdates();
				}
			}

			if( unit.CanAttack() )
			{
				unit.PrepareDefaultAbility();
				cmbtCntl.RefreshAllUnits();
			}
		}
	}

	cmbtCntl.CalculateInputAllowed();
}

// It returns false if the command has finished, otherwise true if it is still running
function bool CommandUpdate()
{   
	if( mRunning )
	{   
		switch( mCommandType )
		{
			case UC_MOVE: 
				return CmdUpd_Move();
			case UC_ABILITY:
				return CmdUpd_Ability();
		}
		class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();
	}
	return mRunning;
}

// ==========================================
// state functions for each different command
// ==========================================

// === MOVE
// ========
protected function CmdInit_Move()
{
	local H7EventContainerStruct container;

	if( H7Unit( mSource ) != none )
	{

		container.Action = ACTION_MOVE;
		container.ActionSchool = ABILITY_SCHOOL_NONE;
		container.Path = mPath;
		container.Targetable = H7Unit( mSource );

		H7Unit( mSource ).SetLastWalkedPath( mPath );

		H7Unit( mSource ).SetWaiting( false );

		if( mSource.GetEntityType() == UNIT_CREATURESTACK )
		{
			H7CreatureStack(mSource).MoveCreature( mPath );
			H7CreatureStack(mSource).TriggerEvents( ON_MOVE, false, container );
			H7CreatureStack(mSource).SetMovedThisTurn( true );
		}
		else if( mSource.GetEntityType() == UNIT_HERO ) // HERO adventure
		{
			H7AdventureHero(mSource).GetAdventureArmy().HandleVisitSlotLeaving();
			if(mCommandTag == ACTION_MOVE_ROTATE)
			{
				H7AdventureHero(mSource).RotateHero( mNumParam );
			}
			else
			{
				H7AdventureHero(mSource).MoveHero( mPath,,(mCommandTag != ACTION_MOVE_NO_FOLLOW) );
			}
			mSource.TriggerEvents( ON_MOVE, false, container );
		}
		else
		{
			;
			ScriptTrace();
			CommandStop();
		}
	}
}

protected function bool CmdUpd_Move()
{
	if( H7Unit( mSource ) != none && !H7Unit( mSource ).IsMoving() )
	{
		H7Unit( mSource ).EndMoving( false );
		
		if(class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() && mSource.GetPlayer() == class'H7AdventureController'.static.GetInstance().GetLocalPlayer())
		{
			class'H7PlayerController'.static.GetPlayerController().SetCommandRequested(false);
			class'H7PlayerController'.static.GetPlayerController().GetHud().UnblockAllFlashMovies();
		}

		CommandStop();
	}
	if( mSource.GetEntityType() == UNIT_HERO )
	{
		if( H7AdventureHero(mSource).GetPlayer().IsControlledByAI() && H7AdventureHero(mSource).GetCurrentMovementPoints() < 1.0f )
		{
			H7AdventureHero(mSource).EndMoving( false );
			CommandStop();
		}
	}
	return mRunning;
}

function OnAttackFaceTargetDone()
{
	local H7Unit sourceUnit;

	sourceUnit = H7Unit( mSource );

	if( sourceUnit != none )
	{
		class'H7CameraActionController'.static.GetInstance().StartAttackAction(sourceUnit, H7Unit( mAbilityTarget ), mCommandTag == ACTION_RETALIATE, false);

		if(mCommandTag == ACTION_RETALIATE)
		{
			StartRetaliationAttack();
		}
		else
		{
			H7CreatureStack( sourceUnit ).GetCreature().GetAnimControl().PlayAnim( CAN_IDLE );
			StartMeleeAttack();
		}
	}
	else
	{
		;
		ScriptTrace();
		CommandStop();
	}
}

function StartMeleeAttack()
{
	local H7CombatController combatController;
	local H7Unit sourceUnit;

	combatController = class'H7CombatController'.static.GetInstance();
	sourceUnit = H7Unit( mSource );

	if( sourceUnit.GetCurrentLuckType() == GOOD_LUCK )
	{
		if( H7CreatureStack( sourceUnit ).GetCreature().IsCritAnimPlayedForRanged() )
		{
			H7CreatureStack( sourceUnit ).GetCreature().GetAnimControl().PlayAnim( sourceUnit.GetPreparedAbility().GetCreatureAnimation(), OnAttackFinished, OnAttackHit );
		}
		else
		{
			H7CreatureStack( sourceUnit ).GetCreature().GetAnimControl().PlayAnim( CAN_CRITICAL_ATTACK, OnAttackFinished, OnAttackHit );
		}
	}
	else
	{
		if( combatController.GetActiveUnit().GetPreparedAbility() == none )
			combatController.GetActiveUnit().PrepareAbility( combatController.GetActiveUnit().GetMeleeAttackAbility() );

		combatController.GetActiveUnit().GetPreparedAbility().SetTarget( mAbilityTarget );

		H7CreatureStack( sourceUnit ).GetCreature().GetAnimControl().PlayAnim( combatController.GetActiveUnit().GetPreparedAbility().GetCreatureAnimation(), OnAttackFinished, OnAttackHit );
	}
}

function StartRetaliationAttack()
{
	local H7CombatController combatController;
	local H7Unit sourceUnit;
	local H7Unit targetUnit;

	combatController = class'H7CombatController'.static.GetInstance();

	sourceUnit = H7Unit( mSource );
	targetUnit = H7Unit( mAbilityTarget );

	if( sourceUnit.GetCurrentLuckType() == GOOD_LUCK )
	{
		if( H7CreatureStack( sourceUnit ).GetCreature().IsCritAnimPlayedForRanged() )
		{
			H7CreatureStack( sourceUnit ).GetCreature().GetAnimControl().PlayAnim( sourceUnit.GetPreparedAbility().GetCreatureAnimation(), OnAttackFinished, OnAttackHit );
		}
		else
		{
			H7CreatureStack( sourceUnit ).GetCreature().GetAnimControl().PlayAnim( CAN_CRITICAL_ATTACK, OnAttackFinished, OnAttackHit );
		}
	}
	else
	{
		combatController.GetActiveUnit().GetPreparedAbility().SetTarget( H7IEffectTargetable(targetUnit) );
		H7CreatureStack( sourceUnit ).GetCreature().GetAnimControl().PlayAnim( sourceUnit.GetPreparedAbility().GetCreatureAnimation(), OnAttackFinished, OnAttackHit );
	}
}
 
function OnAttackHit()
{
	mSource.GetPreparedAbility().Activate( mAbilityTarget, false, mAbilityDirection );
}

function OnAttackFinished()
{
	mAbility.Finish();
}

// === RANGE ATTACK
// ================

function OnRangeAttackFaceTargetDone()
{
	if( mSource.GetEntityType() == UNIT_CREATURESTACK )
	{
		class'H7CameraActionController'.static.GetInstance().StartAttackAction(H7Unit( mSource ), H7Unit( mAbilityTarget ), mCommandTag == ACTION_RANGED_RETALIATE, true);

		if(mCommandTag == ACTION_RANGED_RETALIATE)
		{
			StartRangedAttack();
		}
		else
		{
			H7CreatureStack(mSource).GetCreature().GetAnimControl().PlayAnim( CAN_IDLE );
			H7CreatureStack(mSource).SetTimer(0.5, false, 'StartRangedAttack', self);
		}
	}
	else if( mSource.GetEntityType() == UNIT_WARUNIT )
	{
		// we dont pass OnRangeAttackFinished as parameter to PlayAnim because we want the command to finish when the range attack finishes
		H7WarUnit(mSource).GetAnimControl().PlayAnim( H7WarUnit(mSource).GetOrientedAttackAnimId(),, OnRangeAttackShoot );
	}
	else if( mSource.GetEntityType() == UNIT_TOWER )
	{
		H7TowerUnit(mSource).PlayShootAnim( OnRangeAttackShoot );
	}
	else
	{
		OnRangeAttackShoot();
	}
}

function StartRangedAttack()
{
	local H7Unit sourceUnit;

	sourceUnit = H7Unit( mSource );

	if( sourceUnit.GetCurrentLuckType() == GOOD_LUCK )
	{
		if( H7CreatureStack( sourceUnit ).GetCreature().IsCritAnimPlayedForRanged() )
		{
			H7CreatureStack( sourceUnit ).GetCreature().GetAnimControl().PlayAnim( CAN_CRITICAL_ATTACK,,, OnRangeAttackShoot );
		}
		else
		{
			H7CreatureStack( sourceUnit ).GetCreature().GetAnimControl().PlayAnim( mAbility.GetCreatureAnimation(),,, OnRangeAttackShoot );
		}
	}
	else
	{
		// we dont pass OnRangeAttackFinished as parameter to PlayAnim because we want the command to finish when the range attack finishes
		H7CreatureStack( sourceUnit ).GetCreature().GetAnimControl().PlayAnim( mAbility.GetCreatureAnimation(),,, OnRangeAttackShoot );
	}
}

function OnRangeAttackFinished()
{
	mAbility.Finish();
}

function OnRangeAttackShoot()
{
	mSource.GetPreparedAbility().Activate( mAbilityTarget, false, mAbilityDirection );
}



// === ABILITY
// ===========
protected function bool CmdInit_Ability()
{
	local H7BaseAbility ability;
	local int manaCost;
	local H7EditorHero hero;
	local H7IEffectTargetable tmpTarget;

	if( mAbility == none ) return false;
	
	mSource.PrepareAbility( mAbility );
	ability = mSource.GetAbilityManager().GetAbilityByID( mAbility.GetID() );

	if( ability == none )
	{
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(mSource.GetName() @ "wants to execute ability: none",MD_QA_LOG);;
	}
	
	ability.SetCasting( true );

	tmpTarget = mAbilityTarget;
	if( H7BaseCell( mAbilityTarget ) != none )
	{
		tmpTarget = H7BaseCell( tmpTarget ).GetTargetable();
	}
	mAbilityTarget = tmpTarget;

	if( H7Unit( mSource ) != none )
	{
		// additional handling for special combat map actions
		if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
		{
			// ACT or WAIT
			if( ability != mSource.GetAbilityManager().GetAbility( H7Unit( mSource ).GetWaitAbility() ) )
			{
				H7Unit( mSource ).SetWaiting( false );
			}
			else
			{
				class'H7CombatMapGridController'.static.GetInstance().ResetSelectedAndReachableCells();
				H7Unit( mSource ).SetWaiting( true );
				H7Unit( mSource ).SetWaitClick( true );
				class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("WAIT_BUTTON_CLICK");
			}
			
			// DEFEND 
			if( H7CreatureStack( mSource ) != none && ability == mSource.GetAbilityManager().GetAbility( H7CreatureStack( mSource ).GetDefendAbility() )  )
			{
				class'H7CombatMapGridController'.static.GetInstance().ResetSelectedAndReachableCells();
				H7Unit( mSource ).ClearTurns();
			}
		}
		
		// use mana in case that the source is the hero
		if( mSource.GetEntityType() == UNIT_HERO )
		{
			hero = H7EditorHero( mSource );
			if( ability.IsA( 'H7HeroAbility' ) )
			{
				manaCost = H7HeroAbility( ability ).GetManaCost();
			}

			if( manaCost > hero.GetCurrentMana() )
			{
				;
			}
			hero.UseMana( manaCost );
			hero.PlayHeroSound(HEROTYPE_MAGIC, HEROSOUND_MOUNTED_ABILITY );
		}
	}
	
	;

	if(!class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() || !class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetCombatController().IsInTacticsPhase())
	{
		ability.DoParticleFXCaster( mSource );
	}
	// doing default normal or range attack
	if( H7Unit( mSource ) != none &&
		( mSource.IsDefaultAttackActive() ||
		( mSource.GetPreparedAbility() != none && ( mSource.GetPreparedAbility().ShouldMoveToTarget() || mSource.GetPreparedAbility().ShouldTurnTowardsTarget() ) ) ))
	{
		if( ability.IsRanged() )
		{
			if(mSource.GetEntityType() == UNIT_CREATURESTACK)
			{
				H7CreatureStack(mSource).FaceTarget( mAbilityTarget, OnRangeAttackFaceTargetDone );
			}
			else if(mSource.GetEntityType() == UNIT_WARUNIT)
			{
				H7WarUnit(mSource).FaceTargetObstacle( mAbilityTarget, OnRangeAttackFaceTargetDone );
			}
			else if(mSource.GetEntityType() == UNIT_TOWER)
			{
				H7TowerUnit(mSource).FaceTarget( H7Unit( mAbilityTarget ), OnRangeAttackFaceTargetDone );
			}
			else
			{
				;
				ScriptTrace();
				CommandStop();
			}
		}
		else
		{
			if( mSource.GetEntityType() == UNIT_CREATURESTACK )
			{
				H7CreatureStack(mSource).FaceTarget( mAbilityTarget, OnAttackFaceTargetDone );
			}
			else if( mSource.GetEntityType() == UNIT_HERO )
			{
				H7CombatHero(mSource).GetAnimControl().PlayAnim( HA_ATTACK, OnAttackFinished, OnAttackHit );
			}
			else
			{
				;
				ScriptTrace();
				CommandStop();
			}
		}
	}
	else // doing the abilities
	{
		PlaySourceUnitAnimation( ability );
	}

	return mRunning;
}

protected function PlaySourceUnitAnimation( H7BaseAbility ability )
{
	//local H7Unit unit;

	if( mSource.GetEntityType() == UNIT_CREATURESTACK )
	{
		H7CreatureStack(mSource).GetCreature().GetAnimControl().PlayAnim( ability.GetCreatureAnimation(),,OnStartAbility, OnStartAbility );
	}
	else if ( mSource.GetEntityType() == UNIT_HERO )
	{
		//unit = H7Unit(mSource);
		H7EditorHero(mSource).GetAnimControl().PlayAnim( ability.GetHeroAnimation(),, OnStartAbility );
		//// disabled coolcam for heroes since player can't see the FX/damage on the target unit
		//if(!ability.IsEqual(unit.GetWaitAbility()))
		//{
		//	class'H7CameraActionController'.static.GetInstance().StartAbilityCastAction(unit);
		//}
	}
	else if( mSource.GetEntityType() == UNIT_WARUNIT )
	{
		if( H7WarUnit( mSource ).GetWarUnitClass() == WCLASS_SUPPORT ||
			( H7WarUnit( mSource ).GetWarUnitClass() == WCLASS_HYBRID && H7WarUnit( mSource ).GetPreparedAbility().IsEqual( H7WarUnit( mSource ).GetSupportAbility() ) ) )
		{
			if( ability.GetAnimation() != UAN_ABILITY && ability.GetAnimation() != UAN_ABILITY2 )
			{
				OnStartAbility();
			}
			else
			{
				H7WarUnit(mSource).GetAnimControl().PlayAnim( WA_ABILITY,, OnStartAbility );
			}
		}
		else
		{
			OnStartAbility();
		}
	}
	else
	{
		// stuff that does not animate will have their ability executed instantly
		OnStartAbility();
	}
}

protected function OnStartAbility()
{
	mSource.GetAbilityManager().GetAbilityByID( mAbility.GetID() ).Activate( mAbilityTarget, false, mAbilityDirection, mTrueHitCell );

}

protected function bool CmdUpd_Ability()
{
	if( !mSource.GetPreparedAbility().IsCasting() )
	{
		if( H7Unit( mSource ) != none )
		{
			H7Unit( mSource ).ResetPreparedAbility();
		}
		CommandStop();
	}

	return mRunning;
}

// === VISIT
// ===============

protected function bool CmdInit_Visit()
{
	local H7Dwelling dwelling;
	local H7Mine mine;
	local H7AreaOfControlSite site;
	local H7Player currentPlayer;
	local bool hostileVisit;
	local H7AdventureHero hero;
	local H7AdventureController advCntl;
	local H7VisitableSite targetSite;
	local H7AreaOfControlSiteLord siteLord;
	local H7InstantCommandDoCombat instantCommand;

	hostileVisit = false;
	hero = H7AdventureHero( mSource );
	advCntl = class'H7AdventureController'.static.GetInstance();
	currentPlayer = hero.GetPlayer();
	targetSite = H7VisitableSite(mAbilityTarget);

	if( targetSite != none )
	{
		// visiting logic goes here
		targetSite.OnVisit( hero );

		if( targetSite.IsA( 'H7AreaOfControlSite' ) )
		{
			site = H7AreaOfControlSite( targetSite );

			if( site.GetPlayer().IsPlayerHostile( currentPlayer ) )
			{
				;
				hostileVisit = true;
			}
			if( site.GetGarrisonArmy() != none && site.GetGarrisonArmy().HasUnits() && hostileVisit )
			{
				;
				if( site.IsA( 'H7Town') || site.IsA( 'H7Fort' ) || site.IsA( 'H7Garrison' ) )
				{
					;
					if(hero.GetPlayer().IsControlledByLocalPlayer() || hero.GetPlayer().IsControlledByAI())
					{
						// beforeBattleArea for the other players will be sent with the command
						advCntl.SetBeforeBattleArea( site );
					}
				}

				if(hero.GetIsScripted() || hero.GetPlayer().IsControlledByAI()==true)
				{
					// bypass combat screen and directly start the fight
					hero.PlayHeroSound(HEROTYPE_MAGIC, HEROSOUND_ENGAGE_COMBAT);
					instantCommand = new class'H7InstantCommandDoCombat';
					if( site.GetPlayer().IsControlledByAI() )
					{
						if(class'H7AdventureController'.static.GetInstance().GetAI().IsAiEnabled())
						{
							if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
							instantCommand.Init( hero, site.GetGarrisonArmy().GetHero(), true, false, site );
							class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( instantCommand );
						}
					}
					else if( class'H7AdventureController'.static.GetInstance().GetForceQuickCombat()==FQC_ALWAYS ||
						    (class'H7AdventureController'.static.GetInstance().GetForceQuickCombat()==FQC_AGAINST_AI && site.GetPlayer().GetPlayerType()==PLAYER_HUMAN) )
					{
						instantCommand.Init( hero, site.GetGarrisonArmy().GetHero(), true, false, site );
						class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( instantCommand );
					}
					else
					{
						instantCommand.Init( hero, site.GetGarrisonArmy().GetHero(), false, false, site );
						class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( instantCommand );
					}
					
				}
				else
				{
					class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetCombatPopUpCntl().ShowStartCombatPopUp( hero.GetAdventureArmy(), site.GetGarrisonArmy() );
					class'H7Camera'.static.GetInstance().SetFocusActor(site, currentPlayer.GetPlayerNumber());
				}
			}
		}

		// Handle actual visiting
		if( targetSite.IsA( 'H7Town' ) || targetSite.IsA( 'H7Fort' ) )
		{
			siteLord = H7AreaOfControlSiteLord( targetSite );

			;
			// Town info goes here
			if( hostileVisit )
			{
				// TODO Attacking goes here
				;

			}
			// to avoid warnings
			siteLord = siteLord;
		}
		else if( targetSite.IsA( 'H7Dwelling' ) )
		{
			dwelling = H7Dwelling( targetSite );

			;
			// Hiring goes here
			if( hostileVisit )
			{
				// TODO Hostile hiring goes here
				;
			}
					
			// to avoid warnings
			dwelling = dwelling;
		}
		else if( targetSite.IsA( 'H7Mine' ) )
		{
			mine = H7Mine( targetSite );
			;

			if( hostileVisit )
			{
				if( !mine.CanBePlunderedByPlayer(currentPlayer))
				{
					;
					class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR,mine.Location, hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_CANNOT_PLUNDER_MINE","H7FCT"));
					class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("INVALID_SELECT");
				}
				else
				{
					// Plunder goes here
					mine.Plunder( hero );
					;
				}
			}
			else
			{
				// could have been tagged in targetSite.OnVisit( hero );
				// class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR,mine.Location,"Friendly Visit does nothing");
			}
		}

		// apply pickup cost
		if( H7IPickable( targetSite ) != none )
		{
			targetSite.WorldInfo.MyEmitterPool.SpawnEmitter( advCntl.GetConfig().mPickUpParticle, targetSite.Location, targetSite.Rotation );
			;
		}

		CommandStop();
		hero.ClearScriptedBehaviour();
	}
	else if( mSource.GetEntityType() == UNIT_HERO )
	{
		if( H7AdventureHero(mSource).GetPlayer().IsControlledByAI() && H7AdventureHero(mSource).GetCurrentMovementPoints() <= 0 )
		{
			CommandStop();
			hero.ClearScriptedBehaviour();
		}
	}

	return mRunning;
}

// === RECRUIT
// ===============

protected function bool CmdInit_Recruit()
{
	if( H7AreaOfControlSiteLord( mAbilityTarget ) != none && mAbilityTarget.GetPlayer() == mSource.GetPlayer() )
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		H7AreaOfControlSiteLord( mAbilityTarget ).AiPickupCreatures();
	}
	CommandStop();
	return mRunning;
}

// === MEET
// ===============

protected function bool CmdInit_Meet()
{
	local H7AdventureHero hero;
	local H7AdventureArmy attackingArmy, defendingArmy;
	local H7CombatArmy defendingArmyCombat;
	local H7EventContainerStruct eventStructSource, eventStructTarget;
	local H7HeroEventParam eventParam;
	local H7InstantCommandDoCombat instantCommand;
	local H7AdventureController adventureController;
	local H7PlayerController thePlayerController;
	local H7ReplicationInfo theReplicationInfo;
	
	adventureController = class'H7AdventureController'.static.GetInstance();
	thePlayerController = class'H7PlayerController'.static.GetPlayerController();
	theReplicationInfo = class'H7ReplicationInfo'.static.GetInstance();

	hero = H7AdventureHero(mAbilityTarget);

	if( hero != none )
	{
		;

		// visiting logic goes here
		//add visiting call here!!!
		eventStructSource.Targetable = hero;
		eventStructTarget.Targetable = H7AdventureHero( mSource );
		attackingArmy = H7AdventureHero( mSource ).GetAdventureArmy();
		defendingArmy = hero.GetAdventureArmy();

		// safeguard to prevent a second battle against some undead army
		if( hero.IsDead()==true || H7AdventureHero(mSource).IsDead()==true || defendingArmy.IsBeingRemoved()==true || attackingArmy.IsBeingRemoved()==true )
		{
			CommandStop();
			return mRunning;
		}

		;
		if( hero.GetAdventureArmy().IsNPC() )
		{
			if( hero.GetAdventureArmy().IsTalking() )
			{
				// talk
				eventParam = new class'H7HeroEventParam';
				eventParam.mEventHeroTemplate = H7AdventureHero(mSource).GetAdventureArmy().GetHeroTemplateSource();
				eventParam.mEventPlayerNumber = H7AdventureHero(mSource).GetAdventureArmy().GetPlayerNumber();
				eventParam.mEventTargetArmy = hero.GetAdventureArmy();
				class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_TalkedToNPC', eventParam, H7AdventureHero(mSource).GetAdventureArmy());

				H7AdventureHero( mSource ).TriggerEvents( ON_MEET, false, eventStructSource );
				hero.TriggerEvents( ON_MEET, false, eventStructTarget );
			}
			// else: "I have nothing to say, please leave me alone!"
		}
		else if( mSource.GetPlayer() == hero.GetPlayer() )
		{
			// ally trading logic goes here
			if( attackingArmy.GetPlayer().IsControlledByAI() && defendingArmy.GetPlayer().IsControlledByAI() )
			{
				attackingArmy.MergeArmiesAI( defendingArmy );
			}
			else
			{
				thePlayerController.GetAdventureHud().GetHeroTradeWindowCntl().Update( H7AdventureHero(mSource), hero);
			}
			H7AdventureHero( mSource ).TriggerEvents( ON_MEET, false, eventStructSource );
			hero.TriggerEvents( ON_MEET, false, eventStructTarget );
		}
		else if( mSource.GetPlayer().IsPlayerAllied( hero.GetPlayer() ) )
		{
			// ally trading logic goes here
			if( attackingArmy.GetPlayer().IsControlledByAI() && defendingArmy.GetPlayer().IsControlledByAI() )
			{
				attackingArmy.MergeArmiesAI( defendingArmy );
			}
			else
			{
				thePlayerController.GetAdventureHud().GetHeroTradeWindowCntl().Update( H7AdventureHero(mSource), hero, true);
			}
			H7AdventureHero( mSource ).TriggerEvents( ON_MEET, false, eventStructSource );
			hero.TriggerEvents( ON_MEET, false, eventStructTarget );
		}
		else
		{
			if( !attackingArmy.HasUnits() && defendingArmy.GetPlayerNumber() != PN_NEUTRAL_PLAYER ) 
			{
				CommandStop();

				// @NIEMIEC @FIXME It makes double message sometimes!!
				class'H7FCTController'.static.GetInstance().StartFCT( FCT_ERROR, defendingArmy.GetTargetLocation(), attackingArmy.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_NO_ARMY","H7FCT") );

				return mRunning;	
			}

			if( attackingArmy.GetPlayer().IsControlledByAI() && defendingArmy.GetPlayer().IsControlledByAI() && adventureController.GetAIAllowQuickCombat() )
			{
				adventureController.NegotiateAI( attackingArmy, defendingArmy );
			}
			else
			{
				;
				// the actual call to DoQuickCombat comes from H7QuickCombatPopUpCntl.BtnStartQuickCombatClicked
		 
				if( (defendingArmy.HasUnits() || (theReplicationInfo.IsSimTurns() && !defendingArmy.GetPlayer().IsControlledByAI())) && !class'H7AdventureGridManager'.static.GetInstance().IsWinAllCheatUsed() )
				{
					// attacker is AI or scripted ...
					if(  H7AdventureHero(mSource).GetIsScripted() || H7AdventureHero(mSource).GetPlayer().IsControlledByAI() )
					{
						hero.PlayHeroSound(HEROTYPE_MAGIC, HEROSOUND_ENGAGE_COMBAT);

						instantCommand = new class'H7InstantCommandDoCombat';

						// defender is human and NOT controlled by AI and has not enforced quickcombat and we are not in PIE
						if( defendingArmy.GetPlayer().IsControlledByAI()==false && 
							defendingArmy.GetPlayer().GetPlayerType()==PLAYER_HUMAN &&
							adventureController.GetForceQuickCombat()!=FQC_ALWAYS &&
							adventureController.GetForceQuickCombat()!=FQC_AGAINST_AI &&
							!class'Engine'.static.GetCurrentWorldInfo().IsPlayInEditor())
						{
							instantCommand.Init( attackingArmy.GetHero(), defendingArmy.GetHero(), false, false, defendingArmy.GetGarrisonedSite() );
							theReplicationInfo.GetInstantCommandManager().StartCommand( instantCommand );
						}
						else if(adventureController.GetAI().IsAiEnabled())
						{
							instantCommand.Init( attackingArmy.GetHero(), defendingArmy.GetHero(), true, false, defendingArmy.GetGarrisonedSite() );
							theReplicationInfo.GetInstantCommandManager().StartCommand( instantCommand );
						}
					}
					// attacker is human against neutral stack
					else if( defendingArmy.GetPlayerNumber()==PN_NEUTRAL_PLAYER )
					{
						adventureController.Negotiate( attackingArmy, defendingArmy );
					}
					// attacker is human against enemy
					else
					{
						thePlayerController.GetHud().GetCombatPopUpCntl().ShowStartCombatPopUp( attackingArmy, defendingArmy );
						class'H7Camera'.static.GetInstance().SetFocusActor(defendingArmy, attackingArmy.GetPlayerNumber());
						//Play combat overview HeroPopUp sound
						hero = attackingArmy.GetHero();
						hero.PlayHeroSound(HEROTYPE_MAGIC, HEROSOUND_COMBAT_SCREEN_START);
					}
				}
				else
				{
					defendingArmyCombat = defendingArmy.CreateCombatArmyUsingAdventureArmy( defendingArmy, false );
					defendingArmyCombat.SetWonBattle( false );
					defendingArmy.UpdateAfterCombat( defendingArmyCombat, attackingArmy.GetPlayerNumber() );
					defendingArmyCombat.Destroy();

					if( defendingArmy.GetHero().IsHero() )
					{
						defendingArmy.TransferItems( attackingArmy );
					}
				}
			}
		}
		// Handle actual visiting
		CommandStop();
	}
	else
	{
		CommandStop();
	}

	return mRunning;
}

// === GARRISON
// ===============

protected function bool CmdInit_Garrison()
{
	if( H7AreaOfControlSiteLord( mAbilityTarget ) != none && mAbilityTarget.GetPlayer() == mSource.GetPlayer() )
	{
		H7AreaOfControlSiteLord( mAbilityTarget ).TransferHeroComplete( ARMY_NUMBER_VISIT, ARMY_NUMBER_GARRISON );
	}
	CommandStop();
	return mRunning;
}

// === SKIP TURN
// ===============

protected function bool CmdInit_SkipTurn()
{
	CommandStop();
	class'H7CombatController'.static.GetInstance().SkipTurn();
	return mRunning;
}

// === UPGRADE
// ===============

protected function bool CmdInit_Upgrade()
{
	if( mAbilityTarget!=None && mAbilityTarget.GetPlayer()==mSource.GetPlayer() && class'H7AdventureController'.static.GetInstance().GetAI().IsAiEnabled() )
	{
		if( mAbilityTarget.IsA('H7Town') )
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			H7Town(mAbilityTarget).AiUpgradeCreatures();
		}
		else if( mAbilityTarget.IsA('H7Dwelling') )
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			H7Dwelling(mAbilityTarget).AiUpgradeCreatures();
		}
	}
	CommandStop();
	return mRunning;
}

// debugging helper
// ================

function DebugLogSelf()
{
	;
	if( mRunning == true )
	{
		;
	}
	else
	{
		;
	}
	;
	;
	
}

