//=============================================================================
// H7AttackCameraAction
//
// Copyright 1998-2014 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7AttackCameraAction extends H7CameraAction;


const CELL_CHECK_INTERVAL = 100;
const OBSTACLES_HIGHT_TRESHHOLD = 50;

var() float mStartYawOffset<DisplayName=Yaw Offset>;
var() float mStartPitchOffset<DisplayName=Pitch Offset>;
var() float mPitchCreatureHeightMultiplicator<DisplayName=Pitch Offset Creature Height Multiplicator>;
var() float mYawSpeed<DisplayName=Yaw Speed>;
var() float mStartFOV<DisplayName=Field of View>;
var() float mViewingDistance<DisplayName=Base Viewing Distance>;
var() float mViewingDistanceCreatureHeightMultiplicator<DisplayName=Viewing Distance Creature Height Multiplicator>;
var() float mTargetPositionZOffset<DisplayName=Target Position Z Offset>;
var() float mTargetPositionSideOffset<DisplayName=Target Position Side Offset>;
var() bool mIsRanged<DisplayName=Is Ranged>;
var() float mAnimDuration<DisplayName=Duration>;

var Rotator mBaseRotation;
var Rotator mDirection;
var Vector mTargetPos;
var H7Unit mAttacker;
var H7IEffectTargetable mDefender;
var H7IEffectTargetable mPrimaryTarget;
var int mYawMoveDirection;
var bool mDidShake;

var float mCurrentYawOffset;
var float mTargetYawOffset;
var float mCurrentPitchOffset;
var float mTargetPitchOffset;
var float mRandomOffsetDuration;
var float mRandomOffsetTimer;



function Init(H7Unit attacker, H7IEffectTargetable defender)
{
	super.BaseInit(mAnimDuration, none);

	mAttacker = attacker;
	mDefender = defender;
}

function StartAction()
{
	local float height;
	local Vector meshCenterAttacker, meshCenterDefender;
	super.StartAction();

	if(mIsRanged && mPrimaryTarget != none)
	{
		if( H7Unit( mPrimaryTarget ) != none )
		{
			height = H7Unit( mPrimaryTarget ).GetHeightPos( 0.0f ).Z;
		}
		else if( H7CombatObstacleObject( mPrimaryTarget ) != none )
		{
			height = H7CombatObstacleObject( mPrimaryTarget ).GetHeight();
		}
		mViewingDistance += height * mViewingDistanceCreatureHeightMultiplicator;
	}
	else
	{
		mViewingDistance += GetMaxCreatureHeight() * mViewingDistanceCreatureHeightMultiplicator;
	}

	CalculateCamAngle(false);
	CalculateTargetPos();

	//FlushPersistentDebugLines();

	meshCenterAttacker = mAttacker.GetMeshCenter();

	if( H7Unit( mDefender ) != none )
	{
		meshCenterDefender = H7Unit( mDefender ).GetMeshCenter();
	}
	else if( H7CombatObstacleObject( mDefender ) != none )
	{
		meshCenterDefender = H7CombatObstacleObject( mDefender ).GetMeshCenter();
	}


	if( CheckForObstacles(mAttacker, false) ||
		CheckForObstacles(mAttacker, true) || 
		CheckForObstacles(mDefender, false) || 
		CheckForObstacles(mDefender, true) || 
		CheckColission(meshCenterAttacker, meshCenterDefender))
	{
		CalculateCamAngle(true);
		CalculateTargetPos();

		if( CheckForObstacles(mAttacker, false) || 
			CheckForObstacles(mAttacker, true) || 
			CheckForObstacles(mDefender, false) || 
			CheckForObstacles(mDefender, true) || 
			CheckColission(meshCenterAttacker, meshCenterDefender))
		{
			StopAction();
			return;
		}
	}

	mCam.SetTargetVRP(mTargetPos);
	mCam.SetCurrentVRP(mTargetPos);
	mCam.SetFOV(mStartFOV);

	mCam.SetCurrentRotation(mBaseRotation);
	mCam.SetTargetRotation(mBaseRotation);
	mCam.SetTargetViewingDistance(mViewingDistance);

	StartNewRandomOffset();
}

function bool CheckForObstacles(H7IEffectTargetable target, bool endPosition)
{
	local Vector camPos;
	local Rotator rot;
	local vector meshCenter;
	local H7CombatMapCell cell;
	local array<H7CombatMapCell> neighbours;

	rot = mBaseRotation;

	if(endPosition)
	{
		rot.Yaw += mYawSpeed * DegToUnrRot * mDuration * mYawMoveDirection;
	}

	camPos = mTargetPos - Vector(rot) * mViewingDistance;

	if( H7Unit( target ) != none )
	{
		// check if there is a warfare unit next to the unit
		cell = class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid().GetCellByIntPoint( H7Unit(target).GetGridPosition() );
		neighbours = cell.GetNeighbours();

		foreach neighbours(cell)
		{
			if(cell.HasWarfareUnit())
			{
				return true;
			}
		}

		meshCenter = H7Unit( target ).GetMeshCenter();
	}
	else if( H7CombatObstacleObject( target ) != none )
	{
		meshCenter = H7CombatObstacleObject( target ).GetMeshCenter();
	}

	return CheckColission(camPos, meshCenter);
}

function bool CheckColission(Vector start, Vector end)
{
	local Actor actorIterator;
	local H7CreatureStack creature;
	local Vector  hitLocation, hitNormal;

	foreach TraceActors( class'Actor', actorIterator, hitLocation, hitNormal, start, end )
	{
		if(!actorIterator.IsA('H7CreatureStack'))
		{
			//DrawDebugLine(start, end, 225, 0, 100, true);
			return true;
		}
		creature = H7CreatureStack(actorIterator);
		if(creature != mDefender && creature != mAttacker && !creature.IsDead())
		{
			//DrawDebugLine(start, end, 225, 0, 100, true);
			return true;
		}
		//DrawDebugLine(start, end, 0, 225, 100, true);
	}

	return false;
}

protected function float GetMaxCreatureHeight()
{
	local H7CreatureStack attackerCreature, defenderCreature;
	local float attackerHeight, defenderHeight;

	attackerCreature = H7CreatureStack(mAttacker);
	defenderCreature = H7CreatureStack(mDefender);

	if(attackerCreature != none)
	{
		attackerHeight = attackerCreature.GetHeight();
	}
	if(defenderCreature != none)
	{
		defenderHeight = defenderCreature.GetHeight();
	}

	return FMax(attackerHeight, defenderHeight);
}

function StartNewRandomOffset()
{
	local float randomDegree, randomDistance;

	mCurrentPitchOffset = mTargetPitchOffset;
	mCurrentYawOffset = mTargetYawOffset;
	mRandomOffsetTimer = 0;
	mRandomOffsetDuration = FRand() * 0.25f + 0.5f;
	randomDegree = FRand() * PI * 2;
	randomDistance = FRand() * 0.25f + 0.25f;
	mTargetPitchOffset = Sin(randomDegree) * randomDistance;
	mTargetYawOffset = Cos(randomDegree) * randomDistance;
}

function StopAction()
{
	super.StopAction();

	RevertCamToInitialValues();
}

private function CalculateTargetPos()
{
	local Vector pos1, pos2;
	local Rotator rot;

	pos1 = mAttacker.GetMeshCenter();
	if( H7Unit( mDefender ) != none )
	{
		pos2 = H7Unit( mDefender ).GetMeshCenter();
	}
	else if( H7CombatObstacleObject( mDefender ) != none )
	{
		pos2 = H7CombatObstacleObject( mDefender ).GetMeshCenter();
	}

	if(mIsRanged)
	{
		if(pos1.Y >= pos2.Y)
		{
			mPrimaryTarget = mAttacker;
			mTargetPos = pos1;
		}
		else
		{
			mPrimaryTarget = mDefender;
			mTargetPos = pos2;
		}
	}
	else
	{
		mTargetPos = (pos1 + pos2) / 2;
		mTargetPos.Z = FMax(pos1.Z, pos2.Z);
	}

	rot = mDirection;
	rot.Pitch = 0;
	rot.Yaw += 90 * DegToUnrRot * mYawMoveDirection;

	mTargetPos.X += mTargetPositionSideOffset * Vector(rot).X;
	mTargetPos.Y += mTargetPositionSideOffset * Vector(rot).Y;

	mTargetPos.Z += mTargetPositionZOffset;
}

private function CalculateCamAngle(bool invert)
{
	local Vector pos1, pos2, swap, direction;
	local Rotator rot;

	pos1 = mAttacker.GetMeshCenter();
	if( H7Unit( mDefender ) != none )
	{
		pos2 = H7Unit( mDefender ).GetMeshCenter();
	}
	else if( H7CombatObstacleObject( mDefender ) != none )
	{
		pos2 = H7CombatObstacleObject( mDefender ).GetMeshCenter();
	}

	// make sure to not show the front part of the combat map
	if(pos2.Y > pos1.Y)
	{
		swap = pos1;
		pos1 = pos2;
		pos2 = swap;
	}

	// looking from pos1 towards pos2
	direction = pos2 - pos1;
	rot = Rotator(direction);
	mDirection = rot;
	if(pos1.X < pos2.X != invert)
	{
		rot.Yaw -= mStartYawOffset * DegToUnrRot;
		mYawMoveDirection = -1;
	}
	else
	{
		rot.Yaw += mStartYawOffset * DegToUnrRot;
		mYawMoveDirection = 1;
	}

	rot.Pitch = (mStartPitchOffset + GetMaxCreatureHeight() * mPitchCreatureHeightMultiplicator) * DegToUnrRot;
	mBaseRotation = rot;
}

function Update(float deltaTime)
{
	local float randomOffsetPercent;
	local Rotator rot;

	super.Update(deltaTime);

	if(!mDidShake && GetTimePassedInPer() > 0.6f)
	{
		mDidShake = true;
	}

	mRandomOffsetTimer += deltaTime;
	randomOffsetPercent = mRandomOffsetTimer / mRandomOffsetDuration;
	randomOffsetPercent = FClamp(randomOffsetPercent, 0, 1);
	randomOffsetPercent = FInterpEaseInOut(0, 1, randomOffsetPercent, 2);

	mBaseRotation.Yaw += mYawSpeed * DegToUnrRot * deltaTime * mYawMoveDirection;
	rot = mBaseRotation;
	rot.Yaw += DegToUnrRot * (mCurrentYawOffset + (mTargetYawOffset - mCurrentYawOffset) * randomOffsetPercent);
	rot.Pitch += DegToUnrRot *(mCurrentPitchOffset + (mTargetPitchOffset - mCurrentPitchOffset) * randomOffsetPercent);

	mCam.SetCurrentRotation(rot);
	mCam.SetTargetRotation(rot);

	if(mRandomOffsetTimer >= mRandomOffsetDuration)
	{
		StartNewRandomOffset();
	}
}

