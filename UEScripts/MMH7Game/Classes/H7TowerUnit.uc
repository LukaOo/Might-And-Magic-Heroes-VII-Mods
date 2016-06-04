//=============================================================================
// H7TowerUnit
//=============================================================================
// ...
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7TowerUnit extends H7Unit
	native;

var(Projectile) protected Vector				mProjectileStartPos<DisplayName=Projectile Start Position>;
var(Audio) protected AKEvent                    mTowerShootingSound<DisplayName=Tower Shooting Sound>;

var protected H7CombatMapGridController			mCombatGridController;
var protected H7CombatController				mCombatController;

var protected H7CombatMapCell					mCell;

// tower obstacle that contains this tower unit
var protected H7CombatMapTower					mTowerObstacle;

native function EUnitType		GetEntityType();
function EAbilitySchool		    GetSchool()                                     { return mRangedAttackAbilityTemplate.GetSchool(); }
function EAttackRange           GetAttackRange()                                { return CATTACKRANGE_FULL; }
function EMovementType          GetMovementType()                               { return CMOVEMENT_STATIC; }
function int                    GetStackSize()                                  { if(IsDead()) return 0; else return 1; } //TODO: WTF
function int                    GetInitialStackSize()                           { return 1; }
function int        			GetHitPoints()				                    { return mTowerObstacle.GetMaxHitpoints(); }
function int                    GetCurrentHitPoints()                           { return mTowerObstacle.GetHitpoints(); }

function bool					IsControlledByAI()									{ return true; }

function						SetCell( H7CombatMapCell cell )						{ mCell = cell; }
function H7CombatMapCell		GetCell()											{ return mCell; }

function						SetTowerObstacle( H7CombatMapTower towerObstacle )	{ mTowerObstacle = towerObstacle; }

function Init( optional bool fromSave )
{
	local array<H7BaseAbility> abilities;

	super.Init( fromSave );

	abilities.AddItem( GetRangedAttackAbility() );
	mAbilityManager.Init( self, abilities );

	mCombatController = class'H7CombatController'.static.GetInstance();
	mCombatGridController = class'H7CombatMapGridController'.static.GetInstance();

	mCombatController.GetArmyDefender().AddTower( self );
	SetArmy( mCombatController.GetArmyDefender() );
}

// the function is called to end the last turn for this unit and start with the new
function bool BeginTurn()
{
	super.BeginTurn();

	PrepareAbility( mAbilityManager.GetAbility( mRangedAttackAbilityTemplate ) );

	DebugLogSelf();

	return true;
}

protected function DebugLogSelf()
{
	;
}

native function Vector GetSocketLocation( name socketName );
delegate OnFaceTargetFinishedFunc(){}
delegate OnShootFunc(){}
function FaceTarget( H7Unit targetUnit, delegate<OnFaceTargetFinishedFunc> onFaceTargetFinished )
{
	mTowerObstacle.FaceTarget( targetUnit, onFaceTargetFinished );
}

function PlayShootAnim( optional delegate<OnShootFunc> onShoot )
{
	self.PlayAkEvent(mTowerShootingSound,true,,true);
	mTowerObstacle.PlayShootAnim( onShoot );
}

function SwitchToIdle()
{
	mTowerObstacle.SwitchToIdle();
}

function float GetAnimTimeLeft()
{
	return mTowerObstacle.GetAnimTimeLeft();
}

function bool IsIdling()
{
	return mTowerObstacle.IsIdling();
}
