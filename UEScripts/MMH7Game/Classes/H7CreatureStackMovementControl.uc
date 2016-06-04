//=============================================================================
// H7CreatureStackMovementControl
//=============================================================================
//
// Class that handles high-level commands for units and takes care of 
// triggering the correct states for all movement types 
//
//=============================================================================
// Copyright 1998-2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CreatureStackMovementControl extends Actor
	native;

const MAX_DIST_1X1_FLYUNITS_WALK = 1;
const MAX_DIST_2X2_FLYUNITS_WALK = 2;
const MAX_DIST_1X1_TELEPORTUNITS_WALK = 2;
const MAX_DIST_2X2_TELEPORTUNITS_WALK = 3;

/** Movement speed dilation should be larger than other dilation modifiers */
const MOVE_SPEED_DILATION = 2;

var protected H7CreatureStackMover			mWalkMover;
var protected H7CreatureStackFlyer			mFlyMover;
var protected H7CreatureStackTeleporter		mTeleportMover;
var protected H7CreatureStackGhostWalker	mGhostWalkMover;
var protected H7CreatureStackJumper	        mJumpMover;
var protected H7CreatureStackBaseMover		mCurrentMover;
var protected H7Unit						mOwner;

function H7CreatureStackBaseMover	GetCurrentMover()	{ return mCurrentMover; }
function H7CreatureStackFlyer		GetFlyMover()		{ return mFlyMover; }
function H7CreatureStackJumper		GetJumpMover()		{ return mJumpMover; }
function H7CreatureStackGhostWalker GetGhostMover()     { return mGhostWalkMover; }

function Initialize(H7Unit unit)
{
	mOwner = unit;

	if( H7AdventureHero( mOwner ) != none )
	{
		mWalkMover = Spawn(class'H7CreatureStackMover', mOwner);
		mWalkMover.Initialize( unit );
		mWalkMover.SetOwner( self );
	}
	else
	{
		mWalkMover = Spawn(class'H7CreatureStackMover', mOwner);
		mWalkMover.Initialize( unit );
		mWalkMover.SetOwner( self );

		mFlyMover = Spawn(class'H7CreatureStackFlyer', mOwner);
		mFlyMover.Initialize( unit );
		mFlyMover.SetOwner( self );

		mTeleportMover = Spawn(class'H7CreatureStackTeleporter', mOwner);
		mTeleportMover.Initialize( unit );
		mTeleportMover.SetOwner( self );

		mGhostWalkMover = Spawn(class'H7CreatureStackGhostWalker', mOwner);
		mGhostWalkMover.Initialize( unit );
		mGhostWalkMover.SetOwner( self );

		mJumpMover = Spawn(class'H7CreatureStackJumper', mOwner);
		mJumpMover.Initialize( unit );
		mJumpMover.SetOwner( self );
	}

	mCurrentMover = none;
}

function MoveStack(array<H7BaseCell> path, optional H7IEffectTargetable target)
{
	CalculateCurrentMover( path );

	if( mOwner.GetEntityType() == UNIT_CREATURESTACK )
	{
		H7CreatureStack(mOwner).RemoveCreatureFromCell();
	}

	mCurrentMover.MoveStack(path, target);
}

function RotateStack(rotator targetRot)
{
	CalculateCurrentMover();

	mCurrentMover.RotateStack(targetRot);
}

function LerpStackToLocation( Vector targetLocation )
{
	if( !IsMoving() )
	{
		if( mCurrentMover == none )
		{
			CalculateCurrentMover();
		}

		if( mCurrentMover != none )
		{
			mCurrentMover.SetLerpToLocation( targetLocation );
		}
	}
}

function LerpStackToRotation( Rotator targetRotation )
{
	if( !IsMoving() )
	{
		if( mCurrentMover == none )
		{
			CalculateCurrentMover();
		}

		if( mCurrentMover != none )
		{
			mCurrentMover.SetLerpToRotation( targetRotation );
		}
	}
}

delegate OnAttackStackFinishedFunc(){}
function AttackStack( H7IEffectTargetable target, delegate<OnAttackStackFinishedFunc> onAttackStackFinished ) 
{
	CalculateCurrentMover();
	mCurrentMover.AttackStack( target, onAttackStackFinished );
}

function bool IsMoving()
{
	if( mCurrentMover != none )
	{
		return mCurrentMover.IsMoving();
	}

	return false;
}

function CalculateCurrentMover( optional array<H7BaseCell> path )
{
	local bool shouldFlyUnitWalk;
	local H7BaseCell cell;

	if( mOwner.GetEntityType() == UNIT_CREATURESTACK )
	{
		if( H7CreatureStack(mOwner).CanFly())
		{
			if( H7CreatureStack(mOwner).GetCreature().GetUnitBaseSize() == CELLSIZE_1x1 )
			{
				shouldFlyUnitWalk = path.Length <= MAX_DIST_1X1_FLYUNITS_WALK;
			}
			else
			{
				shouldFlyUnitWalk = path.Length <= MAX_DIST_2X2_FLYUNITS_WALK;
			}
			if( shouldFlyUnitWalk )
			{
				foreach path( cell )
				{
					if( H7CombatMapCell(cell).HasCreatureStack() || H7CombatMapCell(cell).HasObstacle() )
					{
						shouldFlyUnitWalk = false;
					}
				}
			}
			if( shouldFlyUnitWalk )
			{
				mCurrentMover = mWalkMover;
			}
			else
			{
				mCurrentMover = mFlyMover;
			}
		}
		else if( H7CreatureStack(mOwner).CanTeleport() )
		{
			if( H7CreatureStack(mOwner).GetCreature().GetUnitBaseSize() == CELLSIZE_1x1 )
			{
				shouldFlyUnitWalk = path.Length <= MAX_DIST_1X1_TELEPORTUNITS_WALK;
			}
			else
			{
				shouldFlyUnitWalk = path.Length <= MAX_DIST_2X2_TELEPORTUNITS_WALK;
			}

			if( shouldFlyUnitWalk )
			{
				foreach path( cell )
				{
					if( H7CombatMapCell(cell).HasCreatureStack() || H7CombatMapCell(cell).HasObstacle() )
					{
						shouldFlyUnitWalk = false;
					}
				}
			}
			if( shouldFlyUnitWalk )
			{
				mCurrentMover = mWalkMover;
			}
			else
			{
				mCurrentMover = mTeleportMover;
			}
		}
		else if( H7CreatureStack(mOwner).CanGhostWalk() )
		{
			mCurrentMover = mGhostWalkMover;
		}
		else if ( H7CreatureStack(mOwner).CanJump() )
		{
			mCurrentMover = mJumpMover;
		}
		else
		{
			mCurrentMover = mWalkMover;
		}
	}
	else // hero of adventuremap
	{
		mCurrentMover = mWalkMover;
	}
}

simulated event Destroyed()
{
	if( mWalkMover != none )
	{
		mWalkMover.Destroy();
	}
	if( mFlyMover != none )
	{
		mFlyMover.Destroy();
	}
	if( mTeleportMover != none )
	{
		mTeleportMover.Destroy();
	}
	if( mGhostWalkMover != none )
	{
		mGhostWalkMover.Destroy();
	}
	if( mJumpMover != none )
	{
		mJumpMover.Destroy();
	}
	if( mCurrentMover != none )
	{
		mCurrentMover.Destroy();
	}
	mOwner = none;

	super.Destroyed();
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
