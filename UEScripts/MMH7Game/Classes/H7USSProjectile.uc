//=============================================================================
// H7USSProjectile
//=============================================================================
// Projectile used in the combat 
//=============================================================================
// Copyright 2014 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7USSProjectile extends Actor
	hidecategories(Object,Attachment,Collision,Physics,Advanced,Debug,Mobile,Movement,Display)
	dependson( H7StructsAndEnumsNative );

/** List of units who are affected by the spell **/
var protected array<H7IEffectTargetable> mAffectedTargets;
/** Helper list to monitor what units have already been affected by this projectile to prevent multiple applications of effects **/
var protected array<H7IEffectTargetable> mHitTargets;
/** ??? **/
var protected H7BaseAbility mAbility;

/** Movement speed of the projectile **/
var(projectile) protected float                     mMovementSpeed<DisplayName=Movement speed>;
/** Particle effect that will represent the projectile **/
var(projectile) protected ParticleSystemComponent   mProjectileFX<DisplayName=Projectile particle effect>;
/** The projectile's type, describes the trajectory **/
var(Projectile) protected EProjectileType           mProjectileType<DisplayName=Type of Projectile>;
/** Sets the height where a PT_AIRDROP type projectile will spawn **/
var(Projectile) protected int                       mAirdropHeight<DisplayName=Airdrop projectile spawn height>;
/** Sets the height where a PT_BOMBARD type projectile will peak **/
var(Projectile) protected int                       mBombardHeight<DisplayName=Bombard projectile apex>;
/** Sets the acceleration which will be added after the projectile reaches the apex **/
var(Projectile) protected float                     mBombardAcceleration<DisplayName=Bombard projectile post-apex acceleration>;
/** Sets the deceleration which will be subtracted before the projectile reaches the apex, but the speed will never go below half the "Movement speed" **/
var(Projectile) protected float                     mBombardDeceleration<DisplayName=Bombard projectile pre-apex deceleration>;
/** The projectile gets definitely destroyed after this amount of seconds. **/
var(Projectile) protected float                     mMaxLifeTime<DisplayName=Maximum projectile lifetime>;
/** If set, the projectile's particle effect is played until the projectile's lifetime is over. Else, it stops playing on impact. **/
var(Projectile) protected bool                      mIsPersistent<DisplayName=Play particle FX until end of lifetime?>;
/** The amount of seconds the particle effect should play before it gets destroyed. **/
var(Projectile) protected float                     mParticleFXLifeTime<DisplayName=Particle FX lifetime|EditCondition=mIsPersistent>;

// Trajectory variables
var protected Vector                    mStartPos;
var protected Vector                    mTargetPos;
var protected Vector                    mMovementDir;
var protected Vector                    mCurrentBeamEndPos;
var protected float                     mTargetDistance;
var protected float                     mPassedTimeSinceSpawn;
var protected float                     mCurrentMovementSpeed;

/** Says if the projectile has reached its destination **/
var protected bool                      mIsHitTriggered;

var protected name                      mBeamEndName;

function float GetAirdropHeight()               { return mAirdropHeight; }
function bool IsBeam()                          { return mProjectileType == PT_BEAM; }
function EProjectileType GetProjectileType()    { return mProjectileType; }

delegate OnHitFunc( H7IEffectTargetable unit ){}
delegate OnFinishFunc(){}

/**
 * Initialises the projectile for a target location.
 * 
 * @param target            The location of the target
 * @param affectedTargets   The targets who will be affected by this projectile
 * @param ability           The ability associated with this projectile
 * @param onFinishExternal  The delegate function which is called when the projectile finishes its journey
 * @param onHitExternal     The delegate function which is called when the projectile hits something
 * 
 * */
function InitForLocation( Vector target, array<H7IEffectTargetable> affectedTargets, H7BaseAbility ability, optional delegate<OnFinishFunc> onFinishExternal, optional delegate<OnHitFunc> onHitExternal )
{
	local Vector xyTarget,xyStart;

	OnFinishFunc = onFinishExternal;
	OnHitFunc = onHitExternal;

	mAbility = ability;
	mAffectedTargets = affectedTargets;
	;
	
	if( mProjectileFX != none )
	{
		AttachComponent( mProjectileFX );
		mProjectileFX.ActivateSystem();
	}

	mStartPos = Location;
	
	mTargetPos = target;

	mMovementDir = Normal( mTargetPos - Location );
	xyTarget = mTargetPos;
	xyTarget.Z = 0.0f;
	xyStart = mStartPos;
	xyStart.Z = 0.0f;
	mTargetDistance = class'H7Math'.static.GetDistance( xyTarget, xyStart );
	mCurrentMovementSpeed = mMovementSpeed;

	SetRotation( Rotator( mMovementDir ) );

	if( mProjectileType == PT_BEAM )
	{
		mCurrentBeamEndPos = Location;
		mProjectileFX.SetVectorParameter( mBeamEndName, mTargetPos );
	}
	else if( mProjectileType == PT_AIRDROP )
	{
		mStartPos = mTargetPos;
		mStartPos.Z = mAirdropHeight;
		SetLocation( mStartPos );
		mMovementDir = Normal( mTargetPos - mStartPos );
	}
}

event Tick( float deltaTime )
{
	CustomTimeDilation = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();

	super.Tick( deltaTime );

	UpdateParticleFXLifetime(deltaTime);
	UpdatePassedTime(deltaTime);
	
	switch( mProjectileType )
	{
		case PT_BULLET:
			UpdateNormalProjectile( deltaTime );
			break;
		case PT_BOMBARD:
			UpdateBombardProjectile( deltaTime );
			break;
		case PT_AIRDROP:
			UpdateAirdropProjectile( deltaTime );
			break;
		case PT_BEAM:
			UpdateBeam( deltaTime );
			break;
	}
}

protected function UpdateParticleFXLifetime(float deltaTime)
{
	if(mPassedTimeSinceSpawn >= mParticleFXLifeTime && mIsPersistent)
	{
		FinishParticleFX();
	}
}

protected function UpdatePassedTime(float deltaTime)
{
	local H7IEffectTargetable target;

	mPassedTimeSinceSpawn += deltaTime;

	if(mPassedTimeSinceSpawn >= mMaxLifeTime)
	{
		if(!mIsHitTriggered)
		{
			DoImpact();

			foreach mAffectedTargets( target )
			{
				OnHitFunc( target );
			}

			Finish();
		}
	}
}

// UPDATE FUNCTIONS START

// THESE FUNCTIONS UPDATE THE PROJECTILE MOVEMENT BASED ON THEIR TYPE (TRAJECTORY)
protected function UpdateBeam( float deltaTime )
{
	local Vector newDir;
	local H7IEffectTargetable target;
	SetLocation( H7Unit( Owner ).GetSocketLocation( H7Unit( Owner ).GetProjectileStartSocketName() ) );
	
	if( !mIsHitTriggered )
	{
		mCurrentBeamEndPos += mMovementDir * mMovementSpeed * deltaTime;
		newDir = Normal(mTargetPos - mCurrentBeamEndPos);

		// check if reached the target position
		if( (mMovementDir.X > 0 && newDir.X < 0) || (mMovementDir.X < 0 && newDir.X > 0) || (mMovementDir.Y > 0 && newDir.Y < 0) || (mMovementDir.Y < 0 && newDir.Y > 0) )
		{
			DoImpact();

			// call hit on all affected units

			foreach mAffectedTargets( target )
			{
				if( mAffectedTargets.Find( target ) != -1 && mHitTargets.Find( target ) == -1 )
				{
					// add hit target to hit units list to not hit them mutliple times
					mHitTargets.AddItem( target );
					// call hit on currently passing unit
					OnHitFunc( target );
				}
			}

			Finish();
		}
	}
}

protected function UpdateNormalProjectile( float deltaTime )
{
	local Vector newDir;
	local H7IEffectTargetable target;
	local H7CombatMapGridController gridController;
	local H7CombatMapCell cell;

	gridController = class'H7CombatMapGridController'.static.GetInstance();

	if( !mIsHitTriggered )
	{
		Move( mMovementDir * mMovementSpeed * deltaTime );
		newDir = Normal( mTargetPos - Location );

		cell = gridController.GetCell( Location );

		;

		if( cell != none )
		{
			target = cell.GetTargetable();
		}

		if( target != none && mAffectedTargets.Find( target ) != -1 && mHitTargets.Find( target ) == -1 )
		{
			// add hit target to hit units list to not hit them mutliple times
			mHitTargets.AddItem( target );
			// call hit on currently passing unit
			OnHitFunc( target );
		}

		// check if reached the target position
		if( (mMovementDir.X > 0 && newDir.X < 0) || (mMovementDir.X < 0 && newDir.X > 0) || (mMovementDir.Y > 0 && newDir.Y < 0) || (mMovementDir.Y < 0 && newDir.Y > 0) )
		{
			DoImpact();
			Finish();
		}

	}
}

protected function UpdateAirdropProjectile( float deltaTime )
{
	local Vector newDir;
	local H7IEffectTargetable target;

	if( !mIsHitTriggered )
	{
		Move( mMovementDir * mMovementSpeed * deltaTime );
		newDir = Normal(mTargetPos - Location);

		;

		// check if reached the target position
		if( (mMovementDir.Z > 0 && newDir.Z < 0) || (mMovementDir.Z < 0 && newDir.Z > 0)  )
		{
			DoImpact();

			// call hit on all affected units
			foreach mAffectedTargets( target )
			{
				OnHitFunc( target );
			}

			Finish();
		}
	}
}

protected function UpdateBombardProjectile( float deltaTime )
{
	local Vector newDir;
	local Vector predictPos,targetPos;
	local Vector xyStart,xyCurrent;
	local float currentDistance, advance;
	local H7IEffectTargetable target;

	if( !mIsHitTriggered )
	{
		predictPos = Location + mMovementDir * mMovementSpeed * deltaTime;
		
		xyCurrent = predictPos;
		xyCurrent.Z = 0.0f;
		xyStart = mStartPos;
		xyStart.Z = 0.0f;

	    currentDistance = class'H7Math'.static.GetDistance( xyStart, xyCurrent );
		
		advance = currentDistance / mTargetDistance;
		if( advance > 1.0f ) 
		{
			advance = 1.0f;
		}
		targetPos = VLerp( mStartPos, mTargetPos, advance );
	    targetPos.Z += Sin( advance * Pi ) * mBombardHeight;
		
		// now we deduct the real movement direction
		mMovementDir = Normal(targetPos-Location);

		if( advance > 0.5f && mBombardAcceleration > 0 )
		{
			mCurrentMovementSpeed += mBombardAcceleration;
			Move( mMovementDir * mCurrentMovementSpeed * deltaTime );
		}
		else if( advance < 0.5f && mBombardDeceleration > 0 )
		{
			if( mCurrentMovementSpeed > mMovementSpeed / 2 )
			{
				mCurrentMovementSpeed -= mBombardDeceleration;
			}
			Move( mMovementDir * mCurrentMovementSpeed * deltaTime );
		}
		else
		{
			Move( mMovementDir * mCurrentMovementSpeed * deltaTime );
		}

		// set the right direction
		SetRotation(rotator(mMovementDir));

		newDir = Normal(mTargetPos - Location);

		// check if reached the target position
		if( (mMovementDir.X > 0 && newDir.X < 0) || (mMovementDir.X < 0 && newDir.X > 0) || (mMovementDir.Y > 0 && newDir.Y < 0) || (mMovementDir.Y < 0 && newDir.Y > 0) )
		{
			DoImpact();

			// call hit on all affected units
			foreach mAffectedTargets( target )
			{
				OnHitFunc( target );
			}

			Finish();
		}
	}
}

//UPDATE FUNCTIONS END

/**
 * The final call before lifecycle end of the projectile
 * to finish all FX.
 * 
 * */
protected function Finish()
{
	OnFinishFunc();
	FinishParticleFX();
}

protected function FinishParticleFX()
{
	if(mProjectileFX != none)
	{
		mProjectileFX.DeactivateSystem();
	}
}

protected function DoImpact()
{
	SetLocation( mTargetPos );
	
	mIsHitTriggered = true;

	// stop the projectile fx
	if( mProjectileFX != none )
	{
		mProjectileFX.DeactivateSystem();
	}
}

