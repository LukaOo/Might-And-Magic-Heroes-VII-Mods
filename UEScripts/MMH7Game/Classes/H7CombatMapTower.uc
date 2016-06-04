/*=============================================================================
 * H7CombatMapTower
 * 
 * Copyright 2013 Limbic Entertainment All Rights Reserved.
 * =============================================================================*/
class H7CombatMapTower extends H7CombatObstacleFracturedObject;

// tower unit archetype used to spawn a tower unit inside the tower obstacle
var(Tower) protected archetype H7TowerUnit						mTowerUnitArchetype<DisplayName=Tower unit>;
// obstacle that replaces the tower when the player doesnt have the building for having towers
var(Tower) protectedwrite archetype H7CombatObstacleFracturedObject	mObstacleArchetype<DisplayName=Tower Obstacle>;
// the tower will never shoot, it will be always a pilar
var(Tower) protectedwrite archetype bool mIsAlwaysPilar<DisplayName=Always pilar>;

// mesh that rotates to the target when shooting
var(Visuals) protected bool                     mUseStaticAimingMesh<DisplayName=Use Static Mesh for Aiming>;
var(Visuals) protected StaticMeshComponent  	mAimingMesh<DisplayName=Aiming mesh|ToolTip=Used this if the Tower has no Animations for Attacking/Idling|EditCondition=mUseStaticAimingMesh>;
var(Visuals) protected bool				    	mShouldAimingMeshRotate<DisplayName=Should the aiming mesh rotate>;
var(Visuals) protected float                    mShootingEventTime<DisplayName=Projectile Spawn Time>;
var(Audio) protected AkEvent                    mShootingSound <DisplayName=Shooting sound>;

var protected H7TowerUnit mTowerUnit;
var protected MeshComponent mCurrentMesh;
var protected SkeletalMeshComponent mSkeletalAimingMesh;
var protected AnimNodePlayCustomAnim mAnimNode;

// aiming variables
var protected Vector	mTargetLocation;
var protected Rotator	mStartRot;
var protected float		mAimingTime;

function bool IsIdling() { return false; }

function H7TowerUnit GetTowerUnitArchetype() { return mTowerUnitArchetype; } 
function H7TowerUnit GetTowerUnit() { return mTowerUnit; }

simulated function Init()
{
	super.Init();

	mTowerUnit = Spawn( class'H7TowerUnit', self,, Location, Rotation, H7TowerUnit( DynamicLoadObject( PathName( mTowerUnitArchetype ), class'H7TowerUnit') ) );
	mTowerUnit.Init();
	mTowerUnit.SetCell( class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid().GetCellByIntPoint( GetGridPos() ) );
	mTowerUnit.SetTowerObstacle( self );
	if(!mUseStaticAimingMesh)
	{
		mSkeletalAimingMesh = SkeletalMeshComponent;
		
		mAnimNode = AnimNodePlayCustomAnim( mSkeletalAimingMesh.FindAnimNode( 'GeneralNode' ) );
		if(mSkeletalAimingMesh == none)
		{
			;
			return;
		}
		mAnimNode.PlayCustomAnim( 'Idle',1.0f,,,true,true);
	}
	mCurrentMesh = mUseStaticAimingMesh ? mAimingMesh : mSkeletalAimingMesh;
}

simulated function ModifyHitpoints( int modval )
{
	super.ModifyHitpoints( modval );

	if( mCurrentHitpoints == 0 )
	{
		mTowerUnit.GetCombatArmy().RemoveTower( mTowerUnit );
		if( mCurrentMesh != none )
		{
			mCurrentMesh.SetHidden( true );
		}
	}
}

simulated function EObstacleLevel GetLevel()
{
	if( mCurrentHitpoints >= mHitpoints )
	{
		return OL_UNTOUCHED;
	}
	else if( mCurrentHitpoints > 0 )
	{
		return OL_DEMOLISHED;
	}
	return OL_DESTROYED;
}

simulated function H7CombatObstacleObject PlaceObstacle( H7SiegeTownData siegeTownData, Vector spawnLocation )
{
	local string archetypePath;
	local H7CombatObstacleObject obstacleToAdd;

	if( siegeTownData.WallAndGateLevel == 0 )
	{
		// we dont have towers because there are no walls
		Destroy();
		return none;
	}

	if( siegeTownData.HasShootingTowers && !mIsAlwaysPilar )
	{
		// we have shooting towers
		obstacleToAdd = Spawn( class'H7CombatMapTower', self,, Location, Rotation, siegeTownData.SiegeObstacleTower );
	}
	else
	{
		archetypePath = PathName( siegeTownData.SiegeObstacleTower.mObstacleArchetype );
		if( siegeTownData.WallAndGateLevel > 1 )
		{
			archetypePath = archetypePath $ siegeTownData.WallAndGateLevel;
		}
		// the town doesnt have the building that allows to have shooting towers
		obstacleToAdd = Spawn( mObstacleArchetype.Class, self,, Location, Rotation,  H7CombatObstacleFracturedObject( DynamicLoadObject( archetypePath, class'H7CombatObstacleFracturedObject' ) ) );
	}

	Destroy();
	return obstacleToAdd;
}

simulated function Vector GetProjectileImpactPos()
{
	mLastImpactPos = GetMeshCenter();
	if( GetLevel() == OL_DESTROYED )
	{
		mLastImpactPos.Z = GetHeight() * 0.8f;
	}
	else
	{
		mLastImpactPos.Z = GetHeight() * ( 0.4f + ( 0.6f * float(mCurrentHitpoints) / float(mHitpoints) ) );
		mLastImpactPos.Y += Rand( 220 ) - 110;
		mLastImpactPos.X -= 10 + Rand( 25 );
	}

	return mLastImpactPos;
}

simulated delegate OnFaceTargetFinishedFunc(){}
simulated delegate OnShootFunc(){}
simulated function FaceTarget( H7IEffectTargetable target, delegate<OnFaceTargetFinishedFunc> onFaceTargetFinished )
{
	OnFaceTargetFinishedFunc = onFaceTargetFinished;

	if( (mAimingMesh == none && mUseStaticAimingMesh) || !mShouldAimingMeshRotate )
	{
		OnFaceTargetFinishedFunc();
	}
	else
	{
		mTargetLocation = Actor( target ).Location;
		GotoState('Aiming');
	}
}

simulated function PlayShootAnim( optional delegate<OnShootFunc> onShoot )
{
	OnShootFunc = onShoot;
	if(mUseStaticAimingMesh)
	{
		GotoState('Waiting');
		OnShootFunc();
	}
	else
	{
		OnShootFunc = onShoot;
		GotoState('Shooting');
	}
}

simulated function SwitchToIdle()
{
	GotoState('Waiting');
}

simulated function float GetAnimTimeLeft()
{
	if(!mUseStaticAimingMesh)
	{
		return mAnimNode.GetCustomAnimNodeSeq().GetTimeLeft();
	}
	
	return 0.0f;
}

auto simulated state Waiting
{
	function bool IsIdling() { return true; }

	simulated event BeginState(name previousStateName)
	{
		if(!mUseStaticAimingMesh && mAnimNode != none)
		{
			mAnimNode.PlayCustomAnim( 'Idle', 1.0f,,,true, true);
		}
	}
}

simulated state Shooting
{
	function bool IsIdling() { return false; }

	simulated event BeginState(name previousStateName)
	{
		if(mAnimNode != none && !class'H7SpectatorHUDCntl'.static.GetInstance().GetPopup().IsVisible())
		{
			mAnimNode.PlayCustomAnim( 'Attack', 1.0f,,,false,true);
			self.PlayAkEvent( mShootingSound,,,true,self.Location);
		}
		SetTimer( mShootingEventTime, false, nameof(StartShoot));
	}
}

function StartShoot()
{
	OnShootFunc();
	if( mAnimNode != none )
	{
		SetTimer( (mAnimNode.GetCustomAnimNodeSeq().AnimSeq.SequenceLength-mShootingEventTime), false, nameof(FinishShootAnim));
	}
	else
	{
		FinishShootAnim();
	}
}

function FinishShootAnim()
{
	GotoState('Waiting');
}

simulated state Aiming
{
	function bool IsIdling() { return false; }

	simulated event BeginState(name previousStateName)
	{
		mStartRot = mUseStaticAimingMesh ? mAimingMesh.Rotation : mSkeletalAimingMesh.Rotation;
		mAimingTime = 0;
	}

	simulated event Tick(float deltaTime)
	{
		local Rotator lerpRot, targetRot;
		local float oldRot;

		oldRot = mCurrentMesh.Rotation.Yaw;

		targetRot = GetOptimalTargetRotation( Location, mTargetLocation );
		targetRot.Yaw -= (90 * DegToUnrRot);
		mAimingTime += deltaTime;

		lerpRot = mStartRot;
		lerpRot.Yaw = Lerp( mStartRot.Yaw, targetRot.Yaw, mAimingTime );

		mCurrentMesh.SetRotation( lerpRot );
		mTowerUnit.SetRotation( lerpRot );

		if( Abs( oldRot - targetRot.Yaw ) <= Abs( mCurrentMesh.Rotation.Yaw - targetRot.Yaw ) )
		{
			lerpRot = mStartRot;
			lerpRot.Yaw = targetRot.Yaw;
			mCurrentMesh.SetRotation( lerpRot );
			mTowerUnit.SetRotation( lerpRot );

			OnFaceTargetFinishedFunc();
		}
	}

	protected simulated function Rotator GetOptimalTargetRotation(Vector from, Vector to)
	{
		local Rotator lTargetRot1, lTargetRot2;

		lTargetRot1 = rotator(to - from);
		lTargetRot2 = lTargetRot1;
	
		if(lTargetRot1.Yaw < 0)
		{
			lTargetRot2.Yaw += 65540;
		}
		else
		{
			lTargetRot2.Yaw -= 65540;
		}

		// Check which of the two rotation possibilities is optimal
		if(abs(mStartRot.Yaw - lTargetRot1.Yaw) < abs(mStartRot.Yaw - lTargetRot2.Yaw))
		{
			return lTargetRot1;
		}
		else
		{
			return lTargetRot2;
		}
	}
}

