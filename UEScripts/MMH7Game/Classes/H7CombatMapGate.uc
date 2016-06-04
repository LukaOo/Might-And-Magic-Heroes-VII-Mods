/*=============================================================================
 * H7CombatMapGate
 * 
 * Copyright 2013 Limbic Entertainment All Rights Reserved.
 * =============================================================================*/
class H7CombatMapGate extends H7CombatObstacleFracturedObject
	native;

var(Gate) protected ParticleSystem mGateFX<DisplayName=Gate represented with an FX>;
var(Gate) protected ParticleSystem mDamagedGateFX<DisplayName=Damaged Gate represented with an FX>;
var(Gate) protected ParticleSystem mDestroyedGateFX<DisplayName=Destroyed Gate represented with an FX>;

var(Gate) protected archetype H7FracturedMeshActor mFracturedStaticMeshArchetypeLeft;
var(Gate) protected float mLeftGateOffset;
var(Gate) protected archetype H7FracturedMeshActor mFracturedStaticMeshArchetypeRight;
var(Gate) protected float mRightGateOffset;

var(Sound) protected AkEvent mGateOpen;
var(Sound) protected AkEvent mGateClose;

var protected ParticleSystemComponent mCurrentGateFX;

var(DEBUG) protected H7FracturedMeshActor mFracturedStaticMeshLeft;
var(DEBUG) protected H7FracturedMeshActor mFracturedStaticMeshRight;
var protected float mLerpTimer;
var protected Rotator mTargetRotLeft, mTargetRotRight;
var protected bool mIsOpening;
var protected bool mIsClosing;

var int mHitsTaken;

function H7FracturedMeshActor GetFracturedStaticMeshLeft() { return mFracturedStaticMeshLeft; }
function H7FracturedMeshActor GetFracturedStaticMeshRight() { return mFracturedStaticMeshRight; }

simulated event PostBeginPlay()
{
	local Vector flipVector, leftOffset, rightOffset;

	super.PostBeginPlay();

	leftOffset.Y = mLeftGateOffset;
	rightOffset.Y = mRightGateOffset;

	if( mFracturedStaticMeshArchetypeLeft != none && mFracturedStaticMeshArchetypeRight != none )
	{
		mFracturedStaticMeshLeft = Spawn( class'H7FracturedMeshActor', self,, Location + leftOffset,, mFracturedStaticMeshArchetypeLeft );
		flipVector = mFracturedStaticMeshLeft.FracturedStaticMeshComponent.Scale3D;
		mFracturedStaticMeshLeft.FracturedStaticMeshComponent.SetScale3D( flipVector );
		mFracturedStaticMeshRight = Spawn( class'H7FracturedMeshActor', self,,Location + rightOffset,, mFracturedStaticMeshArchetypeRight );
	}
}

simulated function H7CombatObstacleObject PlaceObstacle( H7SiegeTownData siegeTownData, Vector spawnLocation )
{
	local string archetypePath;
	local H7CombatObstacleObject obstacleToAdd;

	if( siegeTownData.WallAndGateLevel == 0 )
	{
		// we dont have gate
		mFracturedStaticMeshLeft.Destroy();
		mFracturedStaticMeshRight.Destroy();
		Destroy();
		return none;
	}

	// we have gate of level 1 or higher
	archetypePath = PathName( siegeTownData.SiegeObstacleGate );
	if( siegeTownData.WallAndGateLevel > 1 )
	{
		archetypePath = archetypePath $ siegeTownData.WallAndGateLevel;
	}
	obstacleToAdd = Spawn( class'H7CombatMapGate', self,, Location, Rotation, H7CombatMapGate( DynamicLoadObject( archetypePath, class'H7CombatMapGate') ) );
	mFracturedStaticMeshLeft.Destroy();
	mFracturedStaticMeshRight.Destroy();

	Destroy();
	return obstacleToAdd;
}

simulated function ApplyDamage( H7CombatResult result, int resultIdx, bool isForecast, optional bool isRetaliation = false, optional bool raiseEvent = true )
{
	super.ApplyDamage( result, resultIdx, isForecast, isRetaliation, raiseEvent );

	mHitsTaken++;

	if( GetLevel() == OL_DESTROYED )
	{
		mSpawnedFracturedMeshActor.FracturedStaticMeshComponent.SetTraceBlocking(false, false);
		mSpawnedFracturedMeshActor.SetCollision(false, false, true);

		mFracturedStaticMeshLeft.FracturedStaticMeshComponent.SetTraceBlocking(false, false);
		mFracturedStaticMeshLeft.SetCollision(false, false, true);
		mFracturedStaticMeshRight.FracturedStaticMeshComponent.SetTraceBlocking(false, false);
		mFracturedStaticMeshRight.SetCollision(false, false, true);
	}
}

simulated function ModifyHitpoints( int modval )
{
	local bool wasUntouched;

	wasUntouched = GetLevel() == OL_UNTOUCHED;

	super.ModifyHitpoints( modval );

	if( GetLevel() == OL_DESTROYED )
	{
		GotoState('DestroyedGate');
	}
	else if( GetLevel() == OL_DEMOLISHED && wasUntouched && IsInState('ClosedGate') )
	{
		if( mCurrentGateFX != none )
		{
			mCurrentGateFX.DeactivateSystem();
			mCurrentGateFX = WorldInfo.MyEmitterPool.SpawnEmitter( mDamagedGateFX, Location, Rotation );
			mCurrentGateFX.CustomTimeDilation = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();
		}
	}
}

simulated event Destroyed()
{
	super.Destroyed();

	if(mCurrentGateFX!=None) mCurrentGateFX.DeactivateSystem();
}

simulated function Vector GetProjectileImpactPos()
{
	mLastImpactPos = GetMeshCenter();
	if( GetLevel() == OL_DESTROYED )
	{
		mLastImpactPos.Z = GetHeight() * 0.25f;
	}
	else
	{
		mLastImpactPos.Z = GetHeight() * ( 0.5f + ( 0.5f * float(mCurrentHitpoints) / float(mHitpoints) ) );
		if (mHitsTaken % 2 == 0)
		{
			mLastImpactPos.Y += mMesh.Bounds.BoxExtent.Y * 0.575f;
		}
		else
		{
			mLastImpactPos.Y -= mMesh.Bounds.BoxExtent.Y * 0.575f;
		}
	}

	return mLastImpactPos;
}

simulated function TryOpenGate(){} // overwritted in the states
simulated protected function TryCloseGate(){} // overwritted in the states

auto simulated state ClosedGate
{
	event BeginState(name previousStateName)
	{
		CloseGate();

		if(mGateClose != none && !class'H7SpectatorHUDCntl'.static.GetInstance().GetPopup().IsVisible())
		{
			self.PlayAkEvent(mGateClose,,,true, self.Location);
		}
	}

	simulated function CloseGate()
	{
		if(class'H7ReplicationInfo'.static.GetInstance() != none)
		{
			mCurrentGateFX = WorldInfo.MyEmitterPool.SpawnEmitter( GetLevel() == OL_DEMOLISHED ? mDamagedGateFX : mGateFX, Location, Rotation );
			if(mCurrentGateFX != none)
			{
				mCurrentGateFX.CustomTimeDilation = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();
			}
		}
	}

	simulated function TryOpenGate()
	{
		GotoState('OpenedGate');
	}

}

simulated state OpenedGate
{
	simulated event BeginState(name previousStateName)
	{
		OpenGate();

		if(mGateOpen != none && !class'H7SpectatorHUDCntl'.static.GetInstance().GetPopup().IsVisible())
		{
			self.PlayAkEvent(mGateOpen,,,true, self.Location);
		}
	}

	simulated function OpenGate()
	{
		mIsOpening = true;
		mLerpTimer = 0.0f;
		if( mFracturedStaticMeshLeft != none && mFracturedStaticMeshRight != none )
		{
			mTargetRotLeft = mFracturedStaticMeshLeft.Rotation;
			mTargetRotLeft.Yaw -= 90 * DegToUnrRot;
			mTargetRotRight = mFracturedStaticMeshRight.Rotation;
			mTargetRotRight.Yaw += 90 * DegToUnrRot;
		}

		if(mCurrentGateFX != none)
		{
			mCurrentGateFX.CustomTimeDilation = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed() * 2.f;
			mCurrentGateFX.DeactivateSystem();
		}
	}

	simulated event Tick(float deltaTime)
	{
		if( mIsOpening )
		{
			LerpGateOpen( deltaTime );
		}
		else if( mIsClosing )
		{
			LerpGateClose( deltaTime );
		}
		else
		{
			// we only can close the gate when there is no unit moving
			if( class'H7CombatController'.static.GetInstance().GetActiveUnit().IsMoving() )
			{
				SetTimer( 0.f, true, nameof(TryCloseGate) ); // reset
			}
			else if( !IsTimerActive( nameof(TryCloseGate) ) )
			{
				SetTimer( 1.f, true, nameof(TryCloseGate) );
			}
		}
	}

	function LerpGateOpen( float deltaTime )
	{
		mLerpTimer += deltaTime * 0.25f * class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();
		if( mFracturedStaticMeshLeft != none && mFracturedStaticMeshRight != none )
		{
			mFracturedStaticMeshLeft.SetRotation( RLerp( mFracturedStaticMeshLeft.Rotation, mTargetRotLeft, mLerpTimer ) );
			mFracturedStaticMeshRight.SetRotation( RLerp( mFracturedStaticMeshRight.Rotation, mTargetRotRight, mLerpTimer ) );
		}
		if( mLerpTimer >= 0.17f * class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed() / 2 ) 
		{
			mLerpTimer = 0.0f;
			if( mFracturedStaticMeshLeft != none && mFracturedStaticMeshRight != none )
			{
				mFracturedStaticMeshLeft.SetRotation( mTargetRotLeft );
				mFracturedStaticMeshRight.SetRotation( mTargetRotRight );
			}
			mIsOpening = false;
			CheckDeadStacks(true);
		}
	}

	function LerpGateClose( float deltaTime )
	{
		mLerpTimer += deltaTime * 0.05f * class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed() / 2;
		if( mFracturedStaticMeshLeft != none && mFracturedStaticMeshRight != none )
		{
			mFracturedStaticMeshLeft.SetRotation( RLerp( mFracturedStaticMeshLeft.Rotation, mTargetRotLeft, mLerpTimer ) );
			mFracturedStaticMeshRight.SetRotation( RLerp( mFracturedStaticMeshRight.Rotation, mTargetRotRight, mLerpTimer ) );
		}

		if( mLerpTimer >= 0.1f * class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed() ) 
		{
			mLerpTimer = 0.0f;
			if( mFracturedStaticMeshLeft != none && mFracturedStaticMeshRight != none )
			{
				mFracturedStaticMeshLeft.SetRotation( mTargetRotLeft );
				mFracturedStaticMeshRight.SetRotation( mTargetRotRight );
			}
			mIsClosing = false;
			CheckDeadStacks();
			GotoState('ClosedGate');
		}
	}

	simulated protected function TryCloseGate()
	{
		local array<H7CombatMapCell> cells;
		local H7CombatMapCell currentCell;

		// if there are not anymore creatures on the gate's cells -> close the gate
		cells = GetCells();
		foreach cells(currentCell)
		{
			if( currentCell.GetCreatureStack() != none )
			{
				return;
			}
		}

		mIsClosing = true;
		if( mFracturedStaticMeshLeft != none && mFracturedStaticMeshRight != none )
		{
			mTargetRotLeft = mFracturedStaticMeshLeft.Rotation;
			mTargetRotLeft.Yaw += 90 * DegToUnrRot;
			mTargetRotRight = mFracturedStaticMeshRight.Rotation;
			mTargetRotRight.Yaw -= 90 * DegToUnrRot;
		}
		// register again the obstacle to the cells, because the creature overwrited the merge cells
		class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid().GetCellByIntPoint( GetGridPos() ).PlaceObstacle( self );
		SetTimer( 0.f, true, nameof(TryCloseGate) ); // reset
	}
}

function CheckDeadStacks(optional bool opening)
{
	local array<H7CombatMapCell> cells;
	local H7CombatMapCell currentCell;

	cells = GetCells();

	if(opening)
	{
		foreach cells(currentCell)
		{
			if( currentCell.HasDeadCreatureStack() )
			{
				currentCell.GetDeadCreatureStack().Show();
			}
		}
	}
	else
	{
		foreach cells(currentCell)
		{
			if( currentCell.HasDeadCreatureStack() )
			{
				currentCell.GetDeadCreatureStack().Hide();
			}
		}
	}
}

simulated state DestroyedGate
{
	simulated event BeginState(name previousStateName)
	{
		if(mCurrentGateFX != none)
		{
			mCurrentGateFX.DeactivateSystem();
			mCurrentGateFX = WorldInfo.MyEmitterPool.SpawnEmitter( mDestroyedGateFX, Location, Rotation );
			mCurrentGateFX.CustomTimeDilation = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();
		}
	}
}

