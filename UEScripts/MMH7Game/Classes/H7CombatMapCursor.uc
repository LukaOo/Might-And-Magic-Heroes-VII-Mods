//=============================================================================
// H7CombatMapCursor
//
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CombatMapCursor extends Object
	dependson(H7StructsAndEnumsNative);


const WEST_ANGLE = 0;
const NORTH_WEST_ANGLE = 8192;
const NORTH_ANGLE = 16384;
const NORTH_EAST_ANGLE = 24576;
const EAST_ANGLE = 32768;
const SOUTH_EAST_ANGLE = 40960;
const SOUTH_ANGLE = 49152;
const SOUTH_WEST_ANGLE = 57344;

var protected H7CombatController mCombatController;
var protected H7CombatMapGridController	mGridController;

var protected H7CombatResultSignature mLastResultSignature;
var protected H7CombatResult mLastResult;
var protected ECursorType mLastCursor;
var protected Rotator mLastCursorRotation;
var protected bool mTooltipWasHandledThisFrame;
var protected int mCurrentAttackAngle;
var protected EDirection mCurrentDirection;
var protected bool mHideTooltipForAuraSpell;
var protected bool mHasActiveAuraTooltip;

var protected H7CombatMapCell mLastTargetedCell;

function H7CombatResult GetLastResult()         { return mLastResult; }
function EDirection     GetCurrentDirection()   { return GetMirroredDirection( mCurrentDirection ); }

function Setup(H7CombatController combatController, H7CombatMapGridController gridController)
{
	mCombatController = combatController;
	mGridController = gridController;
}

/* MOUSE DOCU:
UpdateCursor <- every frame
	UpdateTacticsCursor <- every frame during tactics
	UpdateCombatCursor  <- every frame during combat
		UpdateHeroAttackCursor  <- every frame if unit can be attacked by hero
		UpdateMovementCursor    <- every frame if unit can move there
		UpdateAbilityCursor     <- every frame if unit can use ability

(UnitOver || UnitOut || MouseOver)
	(ShowHUDUnitOverEffects)
		ShowUnitOverCursor -> redirects to UpdateCombatCursor
(MouseOver || UnitOut)
	ShowNormalHUDCursor	

*/

// called every frame! (not called if mouse is over hud)
function UpdateCursor( H7CombatMapCell hitCell, Vector hitLocation )
{
	local H7PlayerController playerControl;

	playerControl = class'H7PlayerController'.static.GetPlayerController();
	if( /*mCombatController.GetCommandQueue().IsCommandRunning()*/ !mCombatController.AllAnimationsDone() || ( mCombatController.GetActiveUnit() != none &&
		( !mCombatController.GetActiveUnit().GetPlayer().IsControlledByLocalPlayer() || mCombatController.GetActiveUnit().GetPlayer().IsControlledByAI() ) ) )
	{
		SetCursor( CURSOR_BUSY );
	}
	else if( hitCell == none ) // outside grid
	{
		if( mCombatController.GetActiveUnit() != none && mCombatController.GetActiveUnit().GetPreparedAbility() != none && mCombatController.GetActiveUnit().GetPreparedAbility().IsSpell() )
		{
			SetCursor( CURSOR_ABILITY_DENY );
		}
		else
		{
			class'H7PlayerController'.static.GetPlayerController().SetCursor( CURSOR_NORMAL );
		}
		H7CombatHud(playerControl.myHUD).GetCombatHudCntl().HideAbilityPreview("UpdateCursor");
	}
	else // inside grid
	{
		// we are currently in combat or in army deployment (tactics) phase ?
		if( mCombatController.IsInTacticsPhase() )
		{
			UpdateTacticsCursor( hitCell );
		}
		else
		{
			UpdateCombatCursor( hitCell, hitLocation );
		}
	}
}

protected function SetCursor( ECursorType cursorType, optional Rotator cursorRotation)
{
	//`log_dui("saving" @ cursorType @ cursorRotation.Yaw);
	mLastCursor = cursorType;
	if( mLastCursorRotation != cursorRotation && cursorType != CURSOR_UNAVAILABLE && cursorType != CURSOR_ABILITY_DENY )
	{
		class'H7CombatMapGridController'.static.GetInstance().ForceGridStateUpdate();
	}
	mLastCursorRotation = cursorRotation;
	class'H7PlayerController'.static.GetPlayerController().SetCursor(cursorType,cursorRotation);
}

// called every frame in combat phase! (not called if mouse is over hud)
protected function UpdateCombatCursor( H7CombatMapCell hitCell, Vector hitLocation )
{
	local H7PlayerController playerControl;
	local H7CreatureStack targetStack;
	local H7CombatObstacleObject targetObstacle;
	local H7Unit unit;
	local array<H7IEffectTargetable> targets;
	local H7IEffectTargetable target;
	local H7IEventManagingObject eventManageable;
	local array<H7CombatMapCell> mouseOverCells;
	local bool updateCursor;

	//`log_dui("UpdateCombatCursor hitcell=" @ hitCell.GetGridPosition().X @ hitcell.GetGridPosition().Y);
	playerControl = class'H7PlayerController'.static.GetPlayerController();

	targetStack = hitCell.GetCreatureStack();
	targetObstacle = hitCell.GetObstacle();
	target = hitCell.GetTargetable();

	unit = mCombatController.GetActiveUnit();

	// show busy cursor if the unit has executed a command
	if(  /*mCombatController.GetCommandQueue().IsCommandRunning() */ !mCombatController.GetCommandQueue().IsEmpty()
		|| unit == none
		|| ( unit != none && ( !unit.GetPlayer().IsControlledByLocalPlayer() || unit.GetPlayer().IsControlledByAI() ) ) )
	{
		SetCursor( CURSOR_BUSY );
		return;
	}

	updateCursor = true;

	// get current ability, current angle and current targetsUnderCursor, to see if we need to recalculate combatresult

	CalculateCurrentAttackAngle(hitcell.GetTargetable(), unit, hitLocation);
	
	targets = class'H7CombatMapGridController'.static.GetInstance().GetTargetsOnMouseOverCells();

	// HACK 
	// - when moving from wall/gate to a creature the hitCell is some 3 position distant cell that is wrong traced
	// - so targetStack is none, but targets uses a different system and has the correct targets
	// - this hack is to correct target by taking it out of targets
	// - unknown what happens if the wrong cell actually by coincidence has a creature
	if( targetStack == none && targets.Length > 0 && H7CreatureStack(targets[0]) != none )
	{
		//target = targets[0]; // not sure if needs to be cell or stack but seems to work // <- this line screwed up area targeting, do NOT put it in again!
		//targetStack = H7CreatureStack(targets[0]); // not sure if needed, because mainly target is used below
	}
	// HACK end

	// if targets are empty it's a movementrange/grid-in/out, we have to continue to get a cursor update
	if(targets.Length > 0 && WasAlreadyCalculated(unit.GetPreparedAbility(),targets,mCurrentAttackAngle,mCurrentDirection,updateCursor)) 
	{
		//`log_dui("no relevant change, preventing spam only updating tooltip position and cursortype");
		// updating tooltip(position)
		HandlePreviewTooltip(targets,target,mCurrentAttackAngle);

		if( !updateCursor )
		{
			// and mouse cursor, in case it was over the gui and became standard cursor
			SetCursor(mLastCursor,mLastCursorRotation);
		
			return;
		}
	}

	mouseOverCells = mGridController.GetMouseOverCells();
	//if( !updateCursor )
	//{
	mTooltipWasHandledThisFrame = false;

	if( hitCell.HasActiveAura() ) { UpdateAuraHovering( unit, hitCell ); mLastTargetedCell = hitCell; }
	else
	{
		if( mHasActiveAuraTooltip )
		{
			H7CombatHud(playerControl.myHUD).GetCombatHudCntl().HideAbilityPreview( "UpdateCombatCursor" );
		}
		mHasActiveAuraTooltip = false;
	}
	//}


	// check if the unit wants to use an ability
	if( unit.HasPreparedAbility() )
	{
		mLastTargetedCell = hitCell;

		if( unit.IsDefaultAttackActive() )
		{
			if( target != None && unit.GetPreparedAbility().CanCastOnTargetActor( target ) && unit.CanAttack() )
			{
				UpdateAbilityCursor( target, targets, hitLocation );
			}
			else if( unit.GetEntityType() == UNIT_CREATURESTACK && hitCell.IsForeshadow() && mouseOverCells.Length > 0 && !hitCell.HasWarfareUnit() )
			{
				UpdateMovementCursor(unit);
			}
			else if( unit.GetEntityType() == UNIT_WARUNIT && targetObstacle != none )
			{
				UpdateSiegeEngineAttackCursor( targetObstacle );
			}
			else
			{
				SetCursor( CURSOR_UNAVAILABLE );
				H7CombatHud(playerControl.myHUD).GetCombatHudCntl().HideAbilityPreview("UpdateCombatCursor");
			}
		}
		else if( !unit.GetPreparedAbility().IsRanged() || unit.GetPreparedAbility().IsDirectionalCast() )
		{
			if( target != None && unit.GetPreparedAbility().CanCastOnTargetActor( target ) && unit.CanAttack() )
			{
				targets.RemoveItem( unit );
				UpdateAbilityCursor( target, targets, hitLocation, true, unit.GetPreparedAbility().IsDirectionalCast(), unit.GetPreparedAbility().IsHeal(), hitCell );
			}
			else
			{
				UpdateAbilityCursor( target,,, true, unit.GetPreparedAbility().IsDirectionalCast(), unit.GetPreparedAbility().IsHeal(), hitCell );
			}
		}
		else if( unit.GetPreparedAbility().GetTargetType() != TARGET_SINGLE )
		{
			UpdateAbilityCursor( target, targets,,,,unit.GetPreparedAbility().IsHeal(), hitCell );
		}
		else if ( unit.GetPreparedAbility().CanAffectDead() && targetStack == none )  // only get a dead if no other unit is on this cell
		{
			targetStack = hitCell.GetDeadCreatureStack();
			UpdateAbilityCursor( targetStack,,,,,unit.GetPreparedAbility().IsHeal() );
		}
		else
		{
			if( class'H7ReplicationInfo'.static.GetInstance().GetTeleportTargetID() != INDEX_NONE )
			{
				eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( class'H7ReplicationInfo'.static.GetInstance().GetTeleportTargetID() );
			}
			//Check that if we have a teleport spell, and a valid targetable creature for it, change cursor
			if( unit.GetPreparedAbility().IsTeleportSpell() && class'H7ReplicationInfo'.static.GetInstance().GetTeleportTargetID() == INDEX_NONE )
			{
				if( class'H7Effect'.static.GetAlignmentType( unit, targetStack ) == AT_FRIENDLY )
				{
					SetCursor( CURSOR_POINTER );
				}
				else
				{
					SetCursor ( CURSOR_UNAVAILABLE );
				}
			}
			else if( unit.GetPreparedAbility().IsTeleportSpell() && class'H7ReplicationInfo'.static.GetInstance().GetTeleportTargetID() != INDEX_NONE )
			{
				if( class'H7CombatMapGridController'.static.GetInstance().CheckIfCellIsReachable( hitCell, H7CreatureStack( eventManageable ).GetUnitBaseSize() )
					&& class'H7CombatMapGridController'.static.GetInstance().CanPlaceCreature(hitCell.GetGridPosition(), H7CreatureStack( eventManageable ) ) )
				{
					SetCursor( CURSOR_TELEPORT );
				}
				else
				{
					SetCursor( CURSOR_TELEPORT_BLOCKED );
				}
			}
			else
			{
				UpdateAbilityCursor( target,,,,,unit.GetPreparedAbility().IsHeal() );
			}
		}
	}
	else if( unit.GetMoveCount() > 0 )
	{
		mLastTargetedCell = hitCell;
		if( unit.GetEntityType() == UNIT_CREATURESTACK && hitCell.IsForeshadow() && mouseOverCells.Length > 0 && !hitCell.HasWarfareUnit() )
		{
			UpdateMovementCursor( unit );
		}
	}
	else
	{
		SetCursor( CURSOR_POINTER );
		//`warn(unit @ "unit has no prepared ability");
		//scripttrace();
	}

	//if( !updateCursor )
	//{
	if(!mTooltipWasHandledThisFrame)
	{
		// if the code above did not ran into HandlePreviewTooltip, it means there is nothing to display, we reset and save
		//`log_dui("shut down tooltip, bc was not used this frame");
		mLastResult = none; 
		mLastResultSignature.ability = mCombatController.GetActiveUnit().GetPreparedAbility();
		if(mLastResultSignature.targets.Length > 0 && targets.Length > 0 && mLastResultSignature.targets[0] != targets[0])
		{
			//`log_dui("signature target goes from" @ mLastResultSignature.targets[0] @ "to" @ targets[0]);
		}
		mLastResultSignature.targets = targets;
		
		mLastResultSignature.cursorAngle = mCurrentAttackAngle;
		HandlePreviewTooltip(targets,target,mCurrentAttackAngle); // effectively shuts down tooltip
	}

	mLastResultSignature.cursorDirection = mCurrentDirection;
	//}
}

function CalculateCurrentAttackAngle(H7IEffectTargetable target, H7Unit selectedUnit, Vector hitLocation)
{
	local int cursorRot;
	local Rotator cursorRotation;
	local array<H7CombatMapCell> validPositions;
	local H7CombatMapCell nearestPosition;
	local H7CreatureStack attackingStack;
	local ECellSize size;
	local IntPoint targetDim;

	if(target == none || selectedUnit == none) return;

	attackingStack = H7CreatureStack(selectedUnit);

	if( selectedUnit.GetPreparedAbility() != none &&
		selectedUnit.GetPreparedAbility().IsRanged() &&
		!selectedUnit.GetPreparedAbility().IsDirectionalCast() )
	{
		mCurrentAttackAngle = 0;
		return;
	}

	mGridController.GetCombatGrid().GetAllAttackPositionsAgainst( target, selectedUnit, validPositions );
	// mouse angle
	if( H7Unit( target ) != none )
	{
		if( H7Unit( target ).GetUnitBaseSize() == CELLSIZE_1x1 )
		{
			targetDim.X = 1;
			targetDim.Y = 1;
		}
		else
		{
			targetDim.X = 2;
			targetDim.Y = 2;
		}
	}
	else if( H7CombatObstacleObject( target ) != none )
	{
		targetDim.X = H7CombatObstacleObject( target ).GetObstacleBaseSizeX();
		targetDim.Y = H7CombatObstacleObject( target ).GetObstacleBaseSizeY();
	}
	else
	{
		targetDim.X = 1;
		targetDim.X = 1;
	}
	cursorRotation = Rotator( class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid().GetCellByIntPoint( target.GetGridPosition() ).GetCenterPosByDimensions( targetDim ) - hitLocation );
	cursorRot = cursorRotation.Yaw;

	mCurrentDirection = GetDOA( cursorRotation, selectedUnit, target );

	if( attackingStack == none )
	{
		mCurrentAttackAngle = 0;
		return;
	}
	
	nearestPosition = mGridController.GetCombatGrid().GetNearestAttackPosition( validPositions, cursorRot, target.GetGridPosition(), attackingStack );
	// grid angle
	if(nearestPosition == none)
	{
		mCurrentAttackAngle = 0;
	}
	else
	{
		if( H7Unit( target ) != none )
		{
			size = H7Unit( target ).GetUnitBaseSize();
		}
		else if( H7CombatObstacleObject( target ) != none )
		{
			if( H7CombatObstacleObject( target ).GetObstacleBaseSizeX() == 1 )
			{
				size = CELLSIZE_1x1;
			}
			else
			{
				size = CELLSIZE_2x2;
			}
		}
		mCurrentAttackAngle = Rotator( class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid().GetCellByIntPoint( target.GetGridPosition() ).GetCenterPosBySize( size ) - nearestPosition.GetCenterPosBySize( attackingStack.GetUnitBaseSize() ) ).Yaw;
	}
}

// called every frame in tactics phase! (not called if mouse is over hud)
// also called ONCE when picking up units or dropping units in tactics phase
function UpdateTacticsCursor (H7CombatMapCell hitCell )
{
	local H7PlayerController playerControl;
	local H7CreatureStack unit;

	playerControl = class'H7PlayerController'.static.GetPlayerController();

	unit = mGridController.GetSelectedStack();
	if( unit == None )
	{
		playerControl.UnLoadCursorObject();
	}
	else
	{
		playerControl.SetCursorTexture( none , unit.GetCreature().GetIcon() );
	}

	if( hitCell != none)
	{
		if( hitcell.HasCreatureStack() && unit == none) 
		{
			SetCursor( CURSOR_ACTION ); // can pick up
		}
		else if( hitCell.IsForeshadow()  && unit != none)
		{
			SetCursor( CURSOR_ACTION ); // can place
		}
		else
		{
			SetCursor( CURSOR_ACTION_BLOCKED );
		}
	}
	else
	{
		if(playerControl.IsMouseOverHUD())
		{
			SetCursor( CURSOR_ACTION ); // just dropped or picked up unit from Deployment Bar
		}
		else
		{
			SetCursor( CURSOR_UNAVAILABLE );
		}
	}

}

protected function UpdateHeroAttackCursor(H7Unit targetStack)
{
	local array<H7IEffectTargetable> targets;

	SetCursor( CURSOR_ABILITY );

	//combatResult = mCombatController.DoAttack( targetStack, true );
	mCombatController.GetActiveUnit().GetPreparedAbility().SetTarget( targetStack );

	targets[0] = targetStack;

	HandlePreviewTooltip( targets, targetStack );
}

// now used for default melee attack as well
protected function UpdateAbilityCursor( H7IEffectTargetable target, optional array<H7IEffectTargetable> targets, optional Vector hitLocation, optional bool IsAbility = false, optional bool IsDirectional = false, bool isPositiveAbility = false, optional H7CombatMapCell hitCell )
{
	local H7PlayerController playerControl;
	local bool canCastOnAtLeastOne, skipPreviewCalculation;
	local Rotator cursorRot,gridRot;
	local array<H7CombatMapCell> validPositions;
	local H7CreatureStack selectedStack, targetStack;
	local H7CombatMapCell nearestPosition;
	local H7Unit targetUnit;
	local ECellSize size;

	if( H7CombatMapCell( target ) != none )
	{
		target = H7CombatMapCell( target ).GetTargetable();
	}
	targetUnit = H7Unit( target );
	targetStack = H7CreatureStack( target );

	skipPreviewCalculation = false;

	if( targets.Length == 0 && target != none )
	{
		targets.AddItem( target );
	}

	playerControl = class'H7PlayerController'.static.GetPlayerController();
	
	if( targets.Length > 0 )
	{
		if( !mCombatController.GetActiveUnit().GetPreparedAbility().IsRanged() )
		{
			selectedStack = H7CreatureStack( mCombatController.GetActiveUnit() );
			
			if( selectedStack != none && target != none && ( !IsAbility || mCombatController.GetActiveUnit().GetPreparedAbility().ShouldMoveToTarget()) )
			{
				mGridController.GetCombatGrid().GetAllAttackPositionsAgainst( target, selectedStack, validPositions );
				if( validPositions.Length > 0 )
				{
					if( targetUnit != none )
					{
						size = targetUnit.GetUnitBaseSize();
					}
					else if( H7CombatObstacleObject( target ) != none )
					{
						if( H7CombatObstacleObject( target ).GetObstacleBaseSizeX() == 1 )
						{
							size = CELLSIZE_1x1;
						}
						else
						{
							size = CELLSIZE_2x2;
						}
					}
					// mouse angle
					cursorRot = Rotator( mGridController.GetCombatGrid().GetCellByIntPoint( target.GetGridPosition() ).GetCenterPosBySize( size ) - hitLocation );
			
					nearestPosition = mGridController.GetCombatGrid().GetNearestAttackPosition( validPositions, cursorRot.Yaw, target.GetGridPosition(), selectedStack );
			
					// grid angle
					
					cursorRot.Yaw = Rotator( mGridController.GetCombatGrid().GetCellByIntPoint( target.GetGridPosition() ).GetCenterPosBySize( size ) - nearestPosition.GetCenterPosBySize( selectedStack.GetUnitBaseSize() ) ).Yaw;
					gridRot.Yaw = cursorRot.Yaw;

					// gui angle
					cursorRot.Yaw = GameplayAngleToGUIAngle( cursorRot.Yaw );
			
					if( !IsAbility ) // default melee
					{
						SetCursor( CURSOR_MELEE_N, cursorRot );
					}
					else if( IsAbility ) // directional spell (ranged)
					{
						// check if anything is attackable; if not, change cursor to "unavailable"
						canCastOnAtLeastOne = mCombatController.GetActiveUnit().GetPreparedAbility().CanCastOnTargetActor( target );
						if(!canCastOnAtLeastOne)
						{
							skipPreviewCalculation = true;
							SetCursor(isPositiveAbility ? CURSOR_ABILITY_DENY : CURSOR_UNAVAILABLE);
						}
						else
						{
							if(!isPositiveAbility)
							{
								SetCursor( CURSOR_MELEE_N, cursorRot ); // using melee cursor for now OPTIONAL: directional spell cursor ?
							}
							else
							{
								SetCursor( CURSOR_ABILITY ); // healing ability or stuff -> no sword thingy on cursor!
							}
						}
					}

					if( !skipPreviewCalculation )
						HandlePreviewTooltip( targets, target, gridRot.Yaw );
					else
					{
						H7CombatHud(playerControl.myHUD).GetCombatHudCntl().HideAbilityPreview("UpdateAbilityCursor");
					}
				}
			}
			else
			{
				canCastOnAtLeastOne = mCombatController.GetActiveUnit().GetPreparedAbility().CanCastOnTargetActor( target );
				SetCursor( canCastOnAtLeastOne ? CURSOR_ABILITY : CURSOR_ABILITY_DENY );
				if( canCastOnAtLeastOne )
				{
					HandlePreviewTooltip( targets, target, gridRot.Yaw, hitCell );
				}
				else
				{
					H7CombatHud(playerControl.myHUD).GetCombatHudCntl().HideAbilityPreview("UpdateAbilityCursor");
				}
			}
		}
		else
		{
			canCastOnAtLeastOne = mCombatController.GetActiveUnit().GetPreparedAbility().CanCastOnTargetActor( target );
			if( canCastOnAtLeastOne )
			{
				selectedStack = H7CreatureStack( mCombatController.GetActiveUnit() );
				if( mCombatController.GetActiveUnit().IsRanged() && mCombatController.GetActiveUnit().IsDefaultAttackActive() && selectedStack != none  )
				{
					if( selectedStack.GetAttackRange() == CATTACKRANGE_FULL || mGridController.GetCombatGrid().UnitsInHalfRange( selectedStack, targetStack ) )
					{
						SetCursor( CURSOR_SHOT );
					}
					else
					{
						SetCursor( CURSOR_SHOT_UNSIGHTED );
					}
				}
				else if( IsDirectional )
				{
					cursorRot.Yaw = class'H7GameUtility'.static.DirectionToAngle( mCurrentDirection );
					SetCursor( CURSOR_MELEE_N, cursorRot ); // using melee cursor for now OPTIONAL: directional spell cursor ?
				}
				else
				{
					SetCursor( CURSOR_ABILITY );
				}
				
				HandlePreviewTooltip( targets, target, gridRot.Yaw, hitCell );
			}
			else
			{
				if( mCombatController.GetActiveUnit().IsRanged() && mCombatController.GetActiveUnit().IsDefaultAttackActive() )
				{
					SetCursor( CURSOR_UNAVAILABLE );
				}
				else
				{
					SetCursor( CURSOR_ABILITY_DENY );
				}
				//HandlePreviewTooltip( targets, target );
				H7CombatHud(playerControl.myHUD).GetCombatHudCntl().HideAbilityPreview("UpdateAbilityCursor");
			}
		}
	}
	else
	{
		SetCursor( CURSOR_UNAVAILABLE );
		H7CombatHud(playerControl.myHUD).GetCombatHudCntl().HideAbilityPreview("UpdateAbilityCursor");
	}
	
}

protected function UpdateAuraHovering( H7Unit activeUnit, H7CombatMapCell auraCell )
{
	local H7PlayerController playerControl;
	local H7CombatResult resa, overallResa;
	local array<H7BaseAbility> abilities;
	local array<H7IEffectTargetable> targets;
	local int i;

	playerControl = class'H7PlayerController'.static.GetPlayerController();

	if( auraCell == mLastTargetedCell || auraCell == none ) return; // no need for recalc

	overallResa = new class'H7CombatResult';

	if( H7EditorHero( activeUnit ) != none )
	{
		mHasActiveAuraTooltip = false;
		return;
	}
	else
	{
		mCombatController.GetGridController().GetAuraManager().GetAuraAbilitiesForCell( auraCell, abilities );
		
		for( i = 0; i < abilities.Length; ++i )
		{
			if( abilities[i] != none && H7HeroAbility( abilities[i] ) != none && !abilities[i].IsPassive() )
			{
				if( abilities[i].GetTargetType() == TARGET_SINGLE ) continue; // teleport + hover -> game crash, so skip that thing

				resa = new class'H7CombatResult';

				abilities[i].SetTarget( activeUnit );
				targets.AddItem( activeUnit );
				abilities[i].SetTargets( targets );

				resa = GetResultForEnterAura( abilities[i], activeUnit );
				if( resa == none || resa.GetAttacker() == none ) continue;
				resa.SetContainer( abilities[i] );
				class'H7ReplicationInfo'.static.GetInstance().GetGameProcessor().SimulateDamageEffect( resa, 0 );

				abilities[i].SetTarget( none );
				targets.Length = 0;
				abilities[i].SetTargets( targets );

				overallResa.MergeValueFromOther( resa );
				resa.ClearResult();
			}
		}
	}

	if( overallResa != none && overallResa.GetDefenderCount() > 0 )
	{
		mHasActiveAuraTooltip = true;
		mLastResultSignature.ability = overallResa.GetContainer();
		mLastResultSignature.targets = overallResa.GetDefenders();
		mLastResultSignature.cursorAngle = mCurrentAttackAngle;
		mLastResultSignature.cursorDirection = mCurrentDirection;
		mLastResultSignature.extendedVersion = class'H7CombatHudCntl'.static.GetInstance().GetDamageTooltipSystem().ShowExtentedTooltip();

		H7CombatHud( playerControl.myHUD ).GetCombatHudCntl().ShowAbilityPreview( overallResa );
	}
}

private function H7CombatResult GetResultForEnterAura( H7EffectContainer ability, H7Unit target ) //array<H7Effect> effects, H7Unit target, H7ICaster caster)
{
	local array<H7Effect> effects;
	local H7CombatResult resa;
	local H7EffectContainer cont;
	local H7BaseBuff buff;
	local int i;

	ability.GetEffects( effects, ability.GetInitiator() );
	for( i = 0; i < effects.Length; ++i )
	{
		if( !effects[i].RankCheck( ability.GetInitiator() ) ) continue;

		if( effects[i].GetTrigger().mTriggerType == ON_APPLY_AURA
			|| H7BaseBuff( ability ) != none && effects[i].GetTrigger().mTriggerType == ON_INIT )
		{
			if( H7EffectDamage( effects[i] ) != none )
			{
				effects[i].ClearCachedTargets();
				resa = H7EffectDamage( effects[i] ).GenerateCombatAction( resa );
				mLastResult = resa;
				if( resa != none ) { resa.AddTriggeredEffect( effects[i], 0 ); resa.SetAttacker( ability.GetInitiator() ); return resa; }
			}
			else if( H7EffectWithSpells( effects[i] ) != none && H7EffectWithSpells( effects[i] ).GetData().mSpellStruct.mSpellOperation == ADD_BUFF )
			{
				cont = H7EffectWithSpells( effects[i] ).GetData().mSpellStruct.mSpell;
				if( cont == none ) continue;

				buff = H7BaseBuff( cont );
				if( buff == none ) continue;

				buff = new buff.Class( buff );
				buff.Init( target, ability.GetInitiator(), true );

				resa = GetResultForEnterAura(buff, target);
				mLastResult = resa;
				if( resa != none ) { resa.SetAttacker( ability.GetInitiator() ); return resa; }
			}
			// else: ignore
		}
	}

	return resa;
}

protected function UpdateMovementCursor(H7Unit unit)
{
	if( unit.GetEntityType() == UNIT_CREATURESTACK )
	{
		// OPTIONAL special cursor for ghostwalk? (GDD did not specify)
		if( H7CreatureStack(unit).CanFly() )
		{
			SetCursor( CURSOR_MOVE_FLY );
		}
		else if( H7CreatureStack(unit).CanTeleport() )
		{
			SetCursor( CURSOR_MOVE_TELEPORT );
		}
		else
		{
			SetCursor( CURSOR_MOVE_WALK );
		}
	}
}

function UpdateSiegeEngineAttackCursor( H7IEffectTargetable target )
{
	local H7PlayerController playerControl;
	local H7CombatResult combatResult;
	playerControl = class'H7PlayerController'.static.GetPlayerController();
	SetCursor( CURSOR_SHOT );

	combatResult = mCombatController.GetActiveUnit().GetPreparedAbility().Activate( target, true, GetMirroredDirection( mCurrentDirection ) );
	H7CombatHud( playerControl.myHUD ).GetCombatHudCntl().ShowAbilityPreview( combatResult );
}

function UpdateCombatCursorWithSpell(optional H7BaseAbility spell)
{
	// set cursor icon for drag&drop
	if(spell != none)
	{
		class'H7PlayerController'.static.GetPlayerController().SetCursorTexture(none, spell.GetIcon() , 40 , 0 , 40 , 40);
	}
	else
	{
		class'H7PlayerController'.static.GetPlayerController().UnLoadCursorObject();
	}
}

// when mouse is over the Initiative Bar
function ShowUnitOverCursor( H7Unit targetUnit )
{
	//`log_dui("Cursor over inibar-unit");
	// act as if the mouse cursor hit the unit on the 3dworld: (on the grid field location to be exact)
	if(class'H7CombatController'.static.GetInstance().IsInTacticsPhase())
	{
		// nothing in tactics
	}
	else
	{
		UpdateCombatCursor(
			class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid().GetCellByIntPoint(targetUnit.GetGridPosition() ),
			class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid().GetCellByIntPoint( targetUnit.GetGridPosition() ).GetLocation()
		);
	}
}

// called when 
function ShowNormalHUDCursor()
{
	local H7PlayerController playerControl;

	playerControl = class'H7PlayerController'.static.GetPlayerController();
	class'H7PlayerController'.static.GetPlayerController().SetCursor(CURSOR_ACTION);
	H7CombatHud(playerControl.myHUD).GetCombatHudCntl().HideAbilityPreview("ShowNormalHUDCursor");
}

// expects to be called every frame
// - to either switch between normal/extended
// - to update position
// - to calculate and display new result
// - shot down
// returns true if there was a change
function bool HandlePreviewTooltip(array<H7IEffectTargetable> targets, H7IEffectTargetable target, optional int angle, optional H7CombatMapCell hitCell)
{
	//`log_dui("HandlePreviewTooltip");
	mTooltipWasHandledThisFrame = true;
	if( !WasAlreadyCalculated( mCombatController.GetActiveUnit().GetPreparedAbility(), targets, angle ) )
	{
		;
		mLastResult = mCombatController.GetActiveUnit().GetPreparedAbility().Activate( target, true, GetMirroredDirection( mCurrentDirection ), hitCell );
		mLastResultSignature.ability = mCombatController.GetActiveUnit().GetPreparedAbility();
		mLastResultSignature.targets = targets;
		mLastResultSignature.cursorAngle = angle;
		// calculate new, by setting targets in ability, doing simulated containerattack and sending result to tooltip and saving result here
		;
		CheckIfTooltipNecessary( mCombatController.GetActiveUnit().GetPreparedAbility() );
		class'H7PlayerController'.static.GetPlayerController().GetCombatMapHud().GetCombatHudCntl().ShowAbilityPreview(mLastResult);
		return true;
	}
	else 
	{
		//`log_dui("WasAlreadyCalculated, showing old result:" @ targets.Length @ angle @ mLastResult);
		if( mLastResult != none && mLastResult.ShowsSomething() && !mHideTooltipForAuraSpell )
		{
			// just update position, or change between normal and extended version
			if(mLastResultSignature.extendedVersion == class'H7CombatHudCntl'.static.GetInstance().GetDamageTooltipSystem().ShowExtentedTooltip())
			{
				// only update position&turn visible, if already visible
				if( !class'H7CombatHudCntl'.static.GetInstance().GetDamageTooltipSystem().IsVisible() )
				{
					class'H7CombatHudCntl'.static.GetInstance().ShowAbilityPreview(mLastResult);
				}
				class'H7CombatHudCntl'.static.GetInstance().UpdateAbilityPreviewPosition(); // also turns tooltip visible
			}
			else
			{
				mLastResultSignature.extendedVersion = class'H7CombatHudCntl'.static.GetInstance().GetDamageTooltipSystem().ShowExtentedTooltip();
				class'H7CombatHudCntl'.static.GetInstance().ShowAbilityPreview(mLastResult);
			}
		}
		else if( !mHasActiveAuraTooltip )
		{
			//`log_dui("old result is empty, shutting down toolip"); // how did an empty result arrive and was ever saved anyway?
			class'H7CombatHudCntl'.static.GetInstance().HideAbilityPreview();
		}
		return false;
	}
}

function CheckIfTooltipNecessary( H7EffectContainer container )
{
	// TODO add more checks to not make other tooltips disappear?
	mHideTooltipForAuraSpell = ( H7HeroAbility( mCombatController.GetActiveUnit().GetPreparedAbility() ) != none &&
		H7HeroAbility( mCombatController.GetActiveUnit().GetPreparedAbility() ).IsSpell() &&
		H7HeroAbility( mCombatController.GetActiveUnit().GetPreparedAbility() ).IsAura() );
}

function bool WasAlreadyCalculated(H7EffectContainer container,array<H7IEffectTargetable> targets,optional int angle, optional EDirection direction, optional bool updateOnlyCursor = false )
{
	local H7IEffectTargetable target;
	local H7EffectDamage dmg;
	local int i;
	local bool isInCache, isSummon;

	isInCache = true;

	if( container == none || ( mHasActiveAuraTooltip && targets.Length == 0 ) )
	{
		return true;
	}
	
	if(targets.Length != mLastResultSignature.targets.Length)
	{
		isInCache = false;
		;
	}
	else
	{
		foreach targets(target,i)
		{
			if(mLastResultSignature.targets[i] != target) 
			{
				isInCache = false;
				;
			}
		}
	}

	// since damage is the only thing that gets previewed, skip abilities that don't deal any damage
	dmg = container.GetDamageEffect( mCombatController.GetActiveUnit() );
	isSummon = H7BaseAbility( container ) == none || ( H7BaseAbility( container ) != none && H7BaseAbility( container ).IsSummoningSpell() );
	if( isSummon ) return false;
	if( dmg == none )
	{
		// update cursor for directional casts
		if( H7BaseAbility( container ) == none || !H7BaseAbility( container ).IsDirectionalCast() )
		{
			updateOnlyCursor = true;
			if(!isInCache) { ; }
			return true;
		}

		// don't update anything
		updateOnlyCursor = false;
		if(!isInCache) { ; }
		return true;
	}

	if(!container.IsEqual(mLastResultSignature.ability)) 
	{
		isInCache = false;
		;
	}

	if( angle != mLastResultSignature.cursorAngle ) 
	{
		// don't give a shit about the ranged attacks; flanking isn't possible here anyway.
		if(H7BaseAbility(container) == none || !H7BaseAbility(container).IsRanged())
		{
			isInCache = false;
			;
		}
	}
	
	if( H7BaseAbility( container ) == none || H7BaseAbility( container ).IsDirectionalCast() )
	{
		isInCache = false;
	}
	
	
	return isInCache;
}

protected function EDirection GetDOA( Rotator cursorRotation, H7Unit attacker, H7IEffectTargetable target )
{
	local int sectors, attackerDim, targetDim, i, sectorAngle, r1, r2, offset;
	local EDirection dir;

	attackerDim = attacker.GetUnitBaseSizeInt();
	if( H7Unit( target ) != none )
	{
		targetDim = H7Unit( target ).GetUnitBaseSizeInt();
	}
	else if( H7CombatObstacleObject( target ) != none )
	{
		if( H7CombatObstacleObject( target ).GetObstacleBaseSizeX() == 1 )
		{
			targetDim = CELLSIZE_1x1+1;
		}
		else
		{
			targetDim = CELLSIZE_2x2+1;
		}
	}
	
	sectors = 4*(attackerDim + targetDim);
	sectorAngle = 65536/sectors;

	offset = ((attackerDim + targetDim) % 2 == 0) ? sectorAngle/2 : 0;
	cursorRotation.Yaw += offset;

	for(i = 0; i < sectors; i++)
	{
		r1 = i * sectorAngle;
		r2 = (i + 1) * sectorAngle;
		
		if( (cursorRotation.Yaw >= 0 && cursorRotation.Yaw >= r1 && cursorRotation.Yaw <= r2) ||
			(cursorRotation.Yaw < 0 &&  (cursorRotation.Yaw + 65536) >= r1 && (cursorRotation.Yaw + 65536) <= r2))
		{
			dir = GetSnappedDirection(cursorRotation.Yaw - offset, sectorAngle);
			return dir;
		}
	}

	return EDirection_MAX;
}

protected function EDirection GetSnappedDirection( int cursorRotation, int sectorAngle )
{
	cursorRotation = (cursorRotation >= 0) ? cursorRotation : cursorRotation + 65536;
	
	if(cursorRotation > NORTH_WEST_ANGLE - (sectorAngle/2) && cursorRotation <= NORTH_WEST_ANGLE + (sectorAngle/2))
	{
		return NORTH_WEST;
	}
	else if(cursorRotation > NORTH_EAST_ANGLE - (sectorAngle/2) && cursorRotation <= NORTH_EAST_ANGLE + (sectorAngle/2))
	{
		return NORTH_EAST;
	}
	else if(cursorRotation > SOUTH_EAST_ANGLE - (sectorAngle/2) && cursorRotation <= SOUTH_EAST_ANGLE + (sectorAngle/2))
	{
		return SOUTH_EAST;
	}
	else if(cursorRotation > SOUTH_WEST_ANGLE - (sectorAngle/2) && cursorRotation <= SOUTH_WEST_ANGLE + (sectorAngle/2))
	{
		return SOUTH_WEST;
	}
	else if(cursorRotation > NORTH_EAST_ANGLE + (sectorAngle/2) && cursorRotation <= SOUTH_EAST_ANGLE - (sectorAngle/2))
	{
		return EAST;
	}
	else if(cursorRotation > SOUTH_EAST_ANGLE + (sectorAngle/2) && cursorRotation <= SOUTH_WEST_ANGLE - (sectorAngle/2))
	{
		return SOUTH;
	}
	else if(cursorRotation > NORTH_WEST_ANGLE + (sectorAngle/2) && cursorRotation <= NORTH_EAST_ANGLE - (sectorAngle/2))
	{
		return NORTH;
	}
	else
	{
		return WEST;
	}
}

function private EDirection GetMirroredDirection( EDirection direction )
{
	switch( direction )
	{
		case NORTH: return SOUTH;
		case NORTH_EAST: return SOUTH_WEST;
		case EAST: return WEST;
		case SOUTH_EAST: return NORTH_WEST;
		case SOUTH: return NORTH;
		case SOUTH_WEST: return NORTH_EAST;
		case WEST: return EAST;
		case NORTH_WEST: return SOUTH_EAST;
	}
}

protected function int GameplayAngleToGUIAngle(int gameplayAngle)
{
	local int cameraCorrection;
	local H7Camera combatCamera;

	combatCamera = class'H7Camera'.static.GetInstance();

	cameraCorrection =  combatCamera.GetDefaultRotationAngle() - combatCamera.GetCurrentRotationAngle();

	return gameplayAngle + cameraCorrection;
}
