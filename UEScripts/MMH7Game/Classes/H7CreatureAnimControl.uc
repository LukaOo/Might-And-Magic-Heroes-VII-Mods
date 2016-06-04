//=============================================================================
// H7CreatureAnimControl
//=============================================================================
// Plays the animations of the creatures and its sounds
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CreatureAnimControl extends Actor
					dependson(H7HeroAnimControl);

const WAIT_TIME_TO_TRIGGER_SPECIAL_ANIM = 60.f; // seconds

var protected AnimationData mAnimations[ECreatureAnimation.CAN_MAX];

var protected H7Creature						mOwner;
var protected SkeletalMeshComponent				mSkelMesh;
var protected H7USSProjectile				    mProjectile;
var protected array<H7CreatureEvent>			mCreatureEvents;
var protectedwrite ECreatureAnimation           mCurrentAnim;

var protected AnimNodeSlot                      mAnimNode;
var protected array<AnimNodePlayCustomAnim>	    mWeaponAnimNodes;
var protected AnimNodeBlendList                 mDeadBlend, mStateBlend;
var protected AnimNodeSequence                  mDeadNode, mMoveNode, mTurnLeftNode, mTurnRightNode, mFlyNode;

var protected bool                              mIsDead;

// percentage of the time that will be cut at the end of the turning anim
var protected float                             mTurnAnimCutTime;
var protected AkEvent                           mStopAllAnimSFXAkEvent;


// methods
// =======

// overwritted in the states
function bool IsIdling() { return false; }
// overwritted in the states
function bool IsFlying() { return false; }

function bool IsDead() { return mIsDead; }

function float GetCurrentAnimTime()
{
	if( mAnimNode == none ) return 1.f;

	return mAnimNode.GetCustomAnimNodeSeq().GetTimeLeft();
}

function bool IsIdlingOrDefending()
{
	if(IsIdling()) return true;
	//`log_dui(mOwner.GetName() @ "not idling");
	return false;
}

function float GetAnimationDuration(ECreatureAnimation anim) 
{
	local float duration;

	if(mOwner == none || mOwner.GetSkeletalMesh() == none || mAnimations[anim].AnimName == '' )
	{
		return 0.f;
	}

	duration = mOwner.GetSkeletalMesh().GetAnimLength(mAnimations[anim].AnimName);

	return duration;
}

function Init( H7Creature creatureOwner, SkeletalMeshComponent skelComp, array<H7CreatureEvent> creatureEvents )
{
	mOwner = creatureOwner;
	mSkelMesh = skelComp;
	mCreatureEvents = creatureEvents;

	mAnimNode = AnimNodeSlot( mSkelMesh.FindAnimNode( 'CustomAnimSlot' ) );
	mDeadBlend = AnimNodeBlendList( mSkelMesh.FindAnimNode( 'DeadBlend' ) );
	mStateBlend = AnimNodeBlendList( mSkelMesh.FindAnimNode( 'StateBlend' ) );

	mDeadNode = AnimNodeSequence( mSkelMesh.FindAnimNode( 'DieNode' ) );
	mMoveNode = AnimNodeSequence( mSkelMesh.FindAnimNode( 'MoveNode' ) );
	mTurnLeftNode = AnimNodeSequence( mSkelMesh.FindAnimNode( 'TurnLeftNode' ) );
	mTurnRightNode = AnimNodeSequence( mSkelMesh.FindAnimNode( 'TurnRightNode' ) );
	mFlyNode = AnimNodeSequence( mSkelMesh.FindAnimNode( 'FlyNode' ) );

	SetIdleBridgeFrequency();

	//To calculate and set the WWise playback speed
	if(mOwner.GetAnimSoundSpeedManipulator() != 0)
	{
		mOwner.ChangeUnitAnimationSoundSpeed();
	}
}

function SetIdleBridgeFrequency()
{
	local AnimNodeRandom idleAnimNodeRandom;
	local float idleLength;
	local AnimSequence currentAnimSeq;

	foreach mSkelMesh.AnimSets[0].Sequences( currentAnimSeq )
	{
		if( currentAnimSeq.SequenceName == 'Idle' )
		{
			idleLength = currentAnimSeq.SequenceLength;
		}
	}

	if( idleLength == 0 )
	{
		;
		idleLength = 2.f;
	}
	
	idleAnimNodeRandom = AnimNodeRandom( mSkelMesh.FindAnimNode( 'IdleRandom' ) );
	idleAnimNodeRandom.RandomInfo[0].LoopCountMin = 50 / idleLength;
	idleAnimNodeRandom.RandomInfo[0].LoopCountMax = 100 / idleLength;
	idleAnimNodeRandom.RandomInfo[0].LoopCount = Rand( idleAnimNodeRandom.RandomInfo[0].LoopCountMax ) % idleAnimNodeRandom.RandomInfo[0].LoopCountMax;
	idleAnimNodeRandom.RandomInfo[0].PlayRateRange.X = FMin( 2.0f, class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed() ) * mOwner.CustomTimeDilation;
	idleAnimNodeRandom.RandomInfo[0].PlayRateRange.Y = FMin( 2.0f, class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed() ) * mOwner.CustomTimeDilation;
	idleAnimNodeRandom.RandomInfo[1].Chance = 1.f;
	idleAnimNodeRandom.RandomInfo[1].PlayRateRange.X = FMin( 2.0f, class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed() ) * mOwner.CustomTimeDilation;
	idleAnimNodeRandom.RandomInfo[1].PlayRateRange.Y = FMin( 2.0f, class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed() ) * mOwner.CustomTimeDilation;
	//Enables the correct idle bridge regarding the maptype
	mOwner.EnableAdventureIdleBridge(mOwner.IsA('H7AdventureHero'));
}

// plays a custom animation on all the skeletal meshes (creature and weapons)
protected function PlayCustomAnimOnAll( ECreatureAnimation animId, float rate, float blendInTime, float blendOutTime, bool doLooping, bool doOverride, optional float EndTime )
{
	local AnimNodePlayCustomAnim weaponAnimNode;
	local name animName;
	local float gS;

	gS = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();
	gS *= mOwner.CustomTimeDilation;
	;

	//To calculate and set the WWise playback speed
	if(mOwner.GetAnimSoundSpeedManipulator() != 0)
	{
		mOwner.ChangeUnitAnimationSoundSpeed();
	}

	// creature
	animName = mAnimations[animId].AnimName;
	if (mAnimNode != None)
	{
		mAnimNode.PlayCustomAnim( animName, rate * gS, blendInTime / gS, blendOutTime / gS, doLooping, doOverride, , EndTime * gS );
		;
	}

	// weapons
	foreach mWeaponAnimNodes( weaponAnimNode )
	{
		weaponAnimNode.PlayCustomAnim( animName, rate * gS, blendInTime / gS, blendOutTime / gS, doLooping, doOverride );
		;
	}
}

// plays a custom animation for a certain duration on all the skeletal meshes (creature and weapons)
protected function PlayCustomAnimByDurationOnAll( ECreatureAnimation animId, float duration, float blendInTime, float blendOutTime, bool doLooping, bool doOverride )
{
	local AnimNodePlayCustomAnim weaponAnimNode;
	local name animName;

	//To calculate and set the WWise playback speed
	if(mOwner.GetAnimSoundSpeedManipulator() != 0)
	{
		mOwner.ChangeUnitAnimationSoundSpeed();
	}

	// creature
	animName = mAnimations[animId].AnimName;
	if (mAnimNode != None)
	{
		mAnimNode.PlayCustomAnimByDuration( animName, duration * class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed() * mOwner.CustomTimeDilation, blendInTime, blendOutTime, doLooping, doOverride );
		;
	}

	// weapons
	foreach mWeaponAnimNodes( weaponAnimNode )
	{
		weaponAnimNode.PlayCustomAnimByDuration( animName, duration * class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed() * mOwner.CustomTimeDilation, blendInTime, blendOutTime, doLooping, doOverride );
		;
	}
}

// pauses the currently played custom animation on all the skeletal meshes (creature and weapons)
function ModifyRateCurrentAnimation( float newRate )
{
	local AnimNodePlayCustomAnim weaponAnimNode;
	local array<AnimNotifyEvent> animEvents;
	local AnimNotifyEvent animEvent;

	if( mAnimNode == none ) // shit happened (owner probably died)
	{
		;
		return;
	}

	;

	//To calculate and set the WWise playback speed
	mOwner.ChangeUnitAnimationSoundSpeed(newRate);

	// creature
	if( mAnimNode != none )
	{
		if(mAnimNode.GetCustomAnimNodeSeq() != None && mAnimNode.GetCustomAnimNodeSeq().AnimSeq != none && mAnimNode.GetCustomAnimNodeSeq().AnimSeq.Notifies.Length > 0)
		{
			animEvents = mAnimNode.GetCustomAnimNodeSeq().AnimSeq.Notifies;
			foreach animEvents(animEvent)
			{
				if(animEvent.Notify == none || !animEvent.Notify.IsA('AnimNotify_Sound'))
				{
					continue;
				}

				AnimNotify_Sound(animEvent.Notify).VolumeMultiplier = class'H7SoundController'.static.GetInstance().GetSoundVolume();
			}
		}

		if (mAnimNode.GetCustomAnimNodeSeq() != None)
		{
			mAnimNode.GetCustomAnimNodeSeq().Rate = newRate;
		}
	}

	SetIdleBridgeFrequency();
	// weapons
	foreach mWeaponAnimNodes( weaponAnimNode )
	{
		if(weaponAnimNode.GetCustomAnimNodeSeq().AnimSeq != none && weaponAnimNode.GetCustomAnimNodeSeq().AnimSeq.Notifies.Length > 0)
		{
			animEvents = weaponAnimNode.GetCustomAnimNodeSeq().AnimSeq.Notifies;
			foreach animEvents(animEvent)
			{
				if(animEvent.Notify == none || !animEvent.Notify.IsA('AnimNotify_Sound')) continue;
				AnimNotify_Sound(animEvent.Notify).VolumeMultiplier = class'H7SoundController'.static.GetInstance().GetSoundVolume();
			}
		}

		if (weaponAnimNode.GetCustomAnimNodeSeq() != None)
		{
			weaponAnimNode.GetCustomAnimNodeSeq().Rate = newRate;
		}
	}
}

// pauses the currently played custom animation on all the skeletal meshes (creature and weapons)
protected function PauseCustomAnimOnAll()
{
	ModifyRateCurrentAnimation( 0.f );
}

// stops a custom animation on all the skeletal meshes (creature and weapons)
protected function StopCustomAnimOnAll( ECreatureAnimation animId, float blendOutTime )
{
	local AnimNodePlayCustomAnim weaponAnimNode;
	local float gameSpeed;

	gameSpeed = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();
	gameSpeed *= mOwner.CustomTimeDilation;

	// creature
	if (mAnimNode != none)
	{
		mAnimNode.StopCustomAnim( blendOutTime / gameSpeed );
	}

	// weapons
	foreach mWeaponAnimNodes( weaponAnimNode )
	{
		weaponAnimNode.StopCustomAnim( blendOutTime / gameSpeed );
	}

	;
}

// overwritted in states
function BeginTurn(){}

delegate OnFinishedAnimFunc(){}
delegate OnHitFunc(){}
delegate OnShootFunc(){}
function PlayAnim( ECreatureAnimation creatureAnimation, optional delegate<OnFinishedAnimFunc> onFinishedAnim, optional delegate<OnHitFunc> onHit, optional delegate<OnShootFunc> onShoot )
{
	// do not play animations if we are dead
	if( mOwner.GetOwner() != none && mOwner.GetOwner().IsDead() && creatureAnimation != CAN_DIE )
	{
		;
		return;
	}
	;

	if(creatureAnimation == CAN_NONE )
	{
		if(onFinishedAnim != none) { onFinishedAnim(); }
		if(onHit != none) { onHit(); }
		if(onShoot != none) { onShoot(); }
		return;
	}

	// if the timer is not yet triggered, trigger it and reset the timer
	if( IsTimerActive( nameof(OnAttackHit) ) )
	{
		OnAttackHit();
		SetTimer( 0, false, nameof(OnAttackHit) );
	}

	if( IsTimerActive( nameof(OnRangeAttackShoot) ) )
	{
		OnRangeAttackShoot();
		SetTimer( 0, false, nameof(OnRangeAttackShoot) );
	}

	OnFinishedAnimFunc = onFinishedAnim;
	OnHitFunc = onHit;
	OnShootFunc = onShoot;
	mCurrentAnim = creatureAnimation;
	GotoState( mAnimations[creatureAnimation].StateName );
}

function FakeDyingAnimation(float secondsDelay)
{
	SetTimer(secondsDelay, false, nameof(FinishDying));

	mOwner.PlayDieSound();
	mOwner.PlayDeathEffects();
}

function ECreatureEventType GetCreatureEventByAnim( ECreatureAnimation anim )
{
	switch( anim )
	{
		case CAN_ATTACK:
			return CE_ATTACK_HIT_TIME;
		case CAN_CRITICAL_ATTACK:
			return CE_CRITICAL_ATTACK_HIT_TIME;
		case CAN_ABILITY:
			return CE_ABILITY_CAST_TIME;
		case CAN_ABILITY2:
			return CE_ABILITY_CAST_TIME2;
		case CAN_RANGE_ATTACK:
			return CE_RANGE_ATTACK_SHOOT_TIME;
		default:
			return CE_MAX;
	}
}

auto state Idling
{
	function bool IsIdling() { return true; }

	simulated event BeginState( Name PreviousStateName )
	{
		StopCustomAnimOnAll( CAN_IDLE, 0.3f );
		if(mDeadBlend != none)
		{
			mDeadBlend.SetActiveChild(0, 0.15f);
			if( mDeadNode != none )
			{
				mDeadNode.Rate = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed() * mOwner.CustomTimeDilation;
			}
		}
		if( mOwner != none )
			mOwner.RecalculatePostAnimInput();
		else if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
			class'H7CombatController'.static.GetInstance().CalculateInputAllowed();
	}
	
	function BeginTurn()
	{
		SetTimer( WAIT_TIME_TO_TRIGGER_SPECIAL_ANIM, false, nameof(TriggerIdleSpecialAnimation) );
	}
	
	simulated event EndState( Name NewStateName )
	{
		SetTimer( 0.f, false, nameof(TriggerIdleSpecialAnimation) ); // disable the timer
	}
}

protected function TriggerIdleSpecialAnimation()
{
	PlayAnim( CAN_IDLE_SPECIAL );
}

state IdlingSpecial
{
	function bool IsIdling() { return true; }

	simulated event BeginState( Name PreviousStateName )
	{
		PlayCustomAnimOnAll( CAN_IDLE_SPECIAL, 1.f, 0.5f, 0.5f, false, true );
		mOwner.PlayIdleSpecialSound();
	}

Begin:
	FinishAnim( mAnimNode.GetCustomAnimNodeSeq(), true );
	SetTimer( WAIT_TIME_TO_TRIGGER_SPECIAL_ANIM, false, nameof(TriggerIdleSpecialAnimation) );
	PlayAnim( CAN_IDLE );
}

state MoveStart
{
	simulated event BeginState( Name PreviousStateName )
	{
		mOwner.PlayAkEvent(mStopAllAnimSFXAkEvent,true);

		PlayCustomAnimOnAll( CAN_MOVE_START, 1.f, 0.15f, 0.0f, false, true );
		SetTimer( mAnimNode.GetCustomAnimNodeSeq().GetTimeLeft() - 0.1f, false );
		mOwner.EnableUnitMoveSound(true);
		mOwner.PlayMoveStartSound();
	}

	simulated event EndState( Name NewStateName )
	{
		StopCustomAnimOnAll( CAN_MOVE_START, 0.35f );
	}
}

state Moving
{
	simulated event BeginState( Name PreviousStateName )
	{
		local float gamespeed;

		mOwner.PlayAkEvent(mStopAllAnimSFXAkEvent,true);

		mOwner.EnableUnitMoveSound(true);
		if (mStateBlend != None)
		{
			gamespeed = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();
			gamespeed *= mOwner.CustomTimeDilation;
			mStateBlend.SetActiveChild(1, 0.35f / gamespeed);
			if( mMoveNode != none )
			{
				mMoveNode.Rate = gamespeed;
			}
		}
		mOwner.PlayRandomMoveSound();
	}

	simulated event EndState( Name NewStateName )
	{
		local float gamespeed;

		if (mStateBlend != None)
		{
			gamespeed = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();
			gamespeed *= mOwner.CustomTimeDilation;
			mStateBlend.SetActiveChild(0, 0.3f / gamespeed);
		}
		mOwner.EnableUnitMoveSound(false);
		mOwner.StopRandomMoveSound();
	}
}

state MoveEnd
{
	simulated event BeginState( Name PreviousStateName )
	{
		mOwner.PlayAkEvent(mStopAllAnimSFXAkEvent,true);

		PlayCustomAnimOnAll( CAN_MOVE_END, 1.f, 0.0f, 0.15f, false, true );
		SetTimer( mAnimNode.GetCustomAnimNodeSeq().GetTimeLeft() - 0.1f, false );
		mOwner.PlayMoveStartSound();
		mOwner.EnableUnitMoveSound(true);
	}
	
	simulated event EndState( Name NewStateName )
	{
		StopCustomAnimOnAll( CAN_MOVE_END, 0.35f );
		mOwner.EnableUnitMoveSound(false);
	}
}

state TurningLeft
{
	simulated event BeginState( Name PreviousStateName )
	{
		local float gamespeed;

		mOwner.PlayAkEvent(mStopAllAnimSFXAkEvent,true);

		if (mStateBlend != None)
		{
			gamespeed = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();
			gamespeed *= mOwner.CustomTimeDilation;
			mStateBlend.SetActiveChild(2, 0.25f / gamespeed);

			if( mTurnLeftNode != none )
			{
				mTurnLeftNode.Rate = gamespeed;
			}
		}

		mOwner.PlayTurnLeftSound();
		mOwner.EnableUnitMoveSound(true);
	}

	simulated event EndState( Name NewStateName )
	{
		local float gamespeed;

		if (mStateBlend != None)
		{
			gamespeed = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();
			gamespeed *= mOwner.CustomTimeDilation;
			mStateBlend.SetActiveChild(0, 0.3f / gamespeed);
		}

		mOwner.EnableUnitMoveSound(false);
	}
}

state TurningRight
{
	simulated event BeginState( Name PreviousStateName )
	{
		local float gamespeed;

		mOwner.PlayAkEvent(mStopAllAnimSFXAkEvent,true);

		if (mStateBlend != None)
		{
			gamespeed = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();
			gamespeed *= mOwner.CustomTimeDilation;
			mStateBlend.SetActiveChild(3, 0.25f / gamespeed);

			if( mTurnRightNode != none )
			{
				mTurnRightNode.Rate = gamespeed;
			}
		}

		mOwner.PlayTurnRightSound();
		mOwner.EnableUnitMoveSound(true);
	}

	simulated event EndState( Name NewStateName )
	{
		local float gamespeed;

		if (mStateBlend != None)
		{
			gamespeed = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();
			gamespeed *= mOwner.CustomTimeDilation;
			mStateBlend.SetActiveChild(0, 0.3f / gamespeed);
		}

		mOwner.EnableUnitMoveSound(false);
	}
}

protected function FinishDying()
{
	mIsDead = true;
	if( mOwner.GetOwner().IsSummoned() )
	{
		mOwner.GetOwner().DestroyCreatureStack();
	}
	else
	{
		mOwner.GetOwner().CreateDecay();
	}
}

function bool IsDying()
{
	return IsTimerActive( nameof( FinishDying ) );
}

state Dying
{
	simulated event BeginState( Name PreviousStateName )
	{
		mOwner.PlayAkEvent(mStopAllAnimSFXAkEvent,true);

		if(mDeadBlend != none)
		{
			mDeadBlend.SetActiveChild( 1, 0.2f );
			if( mDeadNode != none )
			{
				mDeadNode.Rate = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed() * mOwner.CustomTimeDilation;
			}
		}

		if( mDeadBlend != none && mDeadBlend.ActiveChildIndex == 1 && mDeadNode != None )
		{
			SetTimer(mDeadNode.GetTimeLeft() - 0.1f, false, nameof( FinishDying ) );
		}
		else
		{
			;
			SetTimer( 3.f, false, nameof( FinishDying ) );
		}

		mOwner.PlayDieSound();
		mOwner.PlayDeathEffects();
	}
}

state DoingAbility
{
	simulated event BeginState( Name PreviousStateName )
	{
		mOwner.PlayAkEvent(mStopAllAnimSFXAkEvent,true);

		PlayCustomAnimOnAll( CAN_ABILITY, 1.f, 0.5f, 0.5f, false, true );
		SetTimer( GetEventTime( CE_ABILITY_CAST_TIME ), false, nameof(OnAttackHit) );
		mOwner.PlayAbility1Sound();
	}

Begin:
	FinishAnim( mAnimNode.GetCustomAnimNodeSeq(), true );
	OnFinishedAnimFunc();
	PlayAnim( CAN_IDLE );
}

state DoingAbilitySecond
{
	simulated event BeginState( Name PreviousStateName )
	{
		mOwner.PlayAkEvent(mStopAllAnimSFXAkEvent,true);

		PlayCustomAnimOnAll( CAN_ABILITY2, 1.f, 0.5f, 0.5f, false, true );
		SetTimer( GetEventTime( CE_ABILITY_CAST_TIME2 ), false, nameof(OnAttackHit) );
		mOwner.PlayAbility1Sound();
	}

Begin:
	FinishAnim( mAnimNode.GetCustomAnimNodeSeq(), true );
	OnFinishedAnimFunc();
	PlayAnim( CAN_IDLE );
}

state Attacking
{
	simulated event BeginState( Name PreviousStateName )
	{
		mOwner.PlayAkEvent(mStopAllAnimSFXAkEvent,true);

		PlayCustomAnimOnAll( CAN_ATTACK, 1.f, 0.5f, 0.5f, false, true );
		SetTimer( GetEventTime( CE_ATTACK_HIT_TIME ), false, nameof(OnAttackHit) );
		mOwner.PlayAttackSound();
	}

Begin:
	FinishAnim( mAnimNode.GetCustomAnimNodeSeq(), true );
	OnFinishedAnimFunc();
	PlayAnim( CAN_IDLE );
}

state CriticalAttacking
{
	simulated event BeginState( Name PreviousStateName )
	{
		mOwner.PlayAkEvent(mStopAllAnimSFXAkEvent,true);

		PlayCustomAnimOnAll( CAN_CRITICAL_ATTACK, 1.f, 0.5f, 0.5f, false, true );
		SetTimer( GetEventTime( CE_CRITICAL_ATTACK_HIT_TIME ), false, nameof(OnAttackHit) );
		mOwner.PlayCriticalAttackSound();
	}

Begin:
	FinishAnim( mAnimNode.GetCustomAnimNodeSeq(), true );
	OnFinishedAnimFunc();
	PlayAnim( CAN_IDLE );
}

state RangeAttacking
{
	simulated event BeginState( Name PreviousStateName )
	{
		mOwner.PlayAkEvent(mStopAllAnimSFXAkEvent,true);

		PlayCustomAnimOnAll( CAN_RANGE_ATTACK, 1.f, 0.5f, 0.5f, false, true );
		SetTimer( GetEventTime( CE_RANGE_ATTACK_SHOOT_TIME ), false, nameof(OnRangeAttackShoot) );
		mOwner.PlayRangeAttackSound();
	}

Begin:
	FinishAnim( mAnimNode.GetCustomAnimNodeSeq(), true );
	OnFinishedAnimFunc();
	PlayAnim( CAN_IDLE );
}

state GettingHit
{
	simulated event BeginState( Name PreviousStateName )
	{
		mOwner.PlayAkEvent(mStopAllAnimSFXAkEvent,true);

		PlayCustomAnimOnAll( CAN_GET_HIT, 1.f, 0.5f, 0.5f, false, true );
		mOwner.PlayGetHitSound();
	}

Begin:
	FinishAnim( mAnimNode.GetCustomAnimNodeSeq(), true );
	PlayAnim( CAN_IDLE );
}

state DoingVictory
{
	simulated event BeginState( Name PreviousStateName )
	{
		mOwner.PlayAkEvent(mStopAllAnimSFXAkEvent,true);

		PlayCustomAnimOnAll( CAN_VICTORY, 1.f, 0.5f, 0.5f, false, true );
		mOwner.PlayVictorySound();
	}

	simulated event EndState( Name PreviousStateName )
	{
		mOwner.SetFadeInAnimDone( true );
	}

Begin:
	FinishAnim( mAnimNode.GetCustomAnimNodeSeq());
	PlayAnim( CAN_IDLE );
}

state Defending
{
	simulated event BeginState( Name PreviousStateName )
	{
		mOwner.PlayAkEvent(mStopAllAnimSFXAkEvent,true);

		//`log("Defending.BeginState");
		PlayCustomAnimOnAll( CAN_DEFEND, 1.f, 0.5f, 0.5f, false, true );
		OnAttackHit();
		mOwner.PlayDefendSound();
	}

	function bool IsIdlingOrDefending()
	{
		//`log_dui(mOwner.GetName() @ "Defending");
		return true;
	}

Begin: // TODO what is this
//`if(`notdefined(FINAL_RELEASE))
//	Sleep( 0.5f ); // we dont want to wait until the defend animation finishes to start the new turn
//	OnFinishedAnimFunc();
//	FinishAnim( mAnimNode.GetCustomAnimNodeSeq(), true );
//	PlayAnim( CAN_IDLE );
//`else
	//`log("Defending.Begin");
	FinishAnim( mAnimNode.GetCustomAnimNodeSeq(), true );
	OnFinishedAnimFunc();
	PlayAnim( CAN_IDLE );
//`endif
}

protected function StartFlyElevating()
{
	mOwner.GetOwner().GetMovementControl().GetFlyMover().StartElevating();
}

protected function StartJumpOff()
{
	mOwner.GetOwner().GetMovementControl().GetJumpMover().StartElevating();
}

state StartFlying
{
	function bool IsFlying() { return True; }

	simulated event BeginState( Name PreviousStateName )
	{
		local float startAnimDuration;
		local float startDelayCalculation, gamespeed, flystartelevating;

		mOwner.PlayAkEvent(mStopAllAnimSFXAkEvent,true);
		// this plays the whole animation from start to end. speed is irrelevant
		//PlayCustomAnimByDurationOnAll( CAN_START_FLY, animationDuration, 0.5f, 0.5f, false, true );
		// this plays the animation at a constant speed. ending time is irrelevant
		PlayCustomAnimOnAll( CAN_START_FLY, 1.0f, 0.25f, 0.25f, false, true );

		// also blend the fly loop behind it, to ensure a proper Start -> Loop blend
		if (mStateBlend != None)
		{
			gamespeed = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();
			gamespeed *= mOwner.CustomTimeDilation;
			mStateBlend.SetActiveChild(4, 0.25f / gamespeed);
			if( mFlyNode != none )
			{
				mFlyNode.Rate = gamespeed;
			}
		}

		startAnimDuration = GetAnimationDuration(CAN_START_FLY);

		mOwner.PlayFlyStartSound();
		mOwner.EnableUnitMoveSound(true);

		if( mOwner.GetVisuals().GetFlyStartElevating() == 0.f )
		{
			SetTimer( 0.01f, false, nameof(StartFlyElevating) );
		}
		else
		{
			gamespeed = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();
			gamespeed *= mOwner.CustomTimeDilation;
			flystartelevating = mOwner.GetVisuals().GetFlyStartElevating(); //0 - 1.0
		
			startDelayCalculation = startAnimDuration / gamespeed;
			startDelayCalculation = startDelayCalculation * flystartelevating;

			SetTimer( startDelayCalculation, false, nameof(StartFlyElevating) );
		}
	}

Begin:
	FinishAnim( mAnimNode.GetCustomAnimNodeSeq(), true );
	PlayAnim( CAN_LOOP_FLY );
}

state LoopFlying
{
	function bool IsFlying() { return True; }

	simulated event BeginState( Name PreviousStateName )
	{
		local float gamespeed;

		mOwner.PlayAkEvent(mStopAllAnimSFXAkEvent,true);

		if (mStateBlend != None)
		{
			gamespeed = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();
			gamespeed *= mOwner.CustomTimeDilation;
			mStateBlend.SetActiveChild(4, 0.25f / gamespeed);
			if( mFlyNode != none )
			{
				mFlyNode.Rate = gamespeed;
			}
		}

		mOwner.EnableUnitMoveSound(true);
		mOwner.PlayRandomFlySound();
	}
		
	simulated event EndState( Name NewStateName )
	{
		mOwner.EnableUnitMoveSound(false);
		mOwner.StopRandomFlySound();
	}
}

state EndFlying
{
	function bool IsFlying() { return True; }

	simulated event BeginState( Name PreviousStateName )
	{
		local float gamespeed;

		mOwner.PlayAkEvent(mStopAllAnimSFXAkEvent,true);

		gamespeed = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();
		gamespeed *= mOwner.CustomTimeDilation;

		// this plays the whole animation from start to end. speed is irrelevant
		//PlayCustomAnimByDurationOnAll( CAN_END_FLY, mOwner.GetOwner().GetMovementControl().GetFlyMover().GetEndFlyDuration() * ( 1.f + mOwner.GetVisuals().GetFlyEndLanding() ), 0.5f, 0.5f, false, true );
		// this plays the animation at a constant speed. ending time is irrelevant
		PlayCustomAnimOnAll( CAN_END_FLY, 1.0f, 0.35f, 0.25f, false, true );

		if (mStateBlend != None)
		{
			mStateBlend.SetActiveChild(0, 0.0f);
			if( mFlyNode != none )
			{
				mFlyNode.Rate = gamespeed;
			}
		}

		mOwner.EnableUnitMoveSound(true);
		mOwner.PlayFlyEndSound();
	}
	
	simulated event EndState( Name NewStateName )
	{
		mOwner.EnableUnitMoveSound(false);
	}
Begin:
	FinishAnim( mAnimNode.GetCustomAnimNodeSeq(), true );
	PlayAnim( CAN_IDLE );
}

state StartJumping
{
	function bool IsJumping() { return True; }

	simulated event BeginState( Name PreviousStateName )
	{
		local float timeLeft;
		mOwner.PlayAkEvent(mStopAllAnimSFXAkEvent,true);

		PlayCustomAnimOnAll( CAN_START_JUMP, 1.f, 0.25f, 0.5f, false, false );
		timeLeft = mAnimNode.GetCustomAnimNodeSeq().GetTimeLeft();
		mOwner.GetOwner().GetMovementControl().GetJumpMover().GotoState('WaitingElevating');
		SetTimer(timeLeft, false, nameof(StartJumpOff));
	}

Begin:
	FinishAnim( mAnimNode.GetCustomAnimNodeSeq(), false );
	//PlayAnim( CAN_LOOP_JUMP );
}

state LoopJumping
{
	function bool IsJumping() { return True; }

	simulated event BeginState( Name PreviousStateName )
	{
		mOwner.PlayAkEvent(mStopAllAnimSFXAkEvent,true);

		PlayCustomAnimOnAll( CAN_LOOP_JUMP, 1.f, 0.5f, 0.5f, true, false );
	}
		
	simulated event EndState( Name NewStateName )
	{
		StopCustomAnimOnAll( CAN_LOOP_JUMP, 0.5f );
	}
}

state EndJumping
{
	function bool IsJumping() { return True; }

	simulated event BeginState( Name PreviousStateName )
	{
		mOwner.PlayAkEvent(mStopAllAnimSFXAkEvent,true);

		PlayCustomAnimOnAll( CAN_END_JUMP, 1.f, 0.1f, 0.5f, false, false );
	}

Begin:
	FinishAnim( mAnimNode.GetCustomAnimNodeSeq(), true );
	PlayAnim( CAN_IDLE );
}

state FlyIn
{
	simulated event BeginState( Name PreviousStateName )
	{
		mOwner.PlayAkEvent(mStopAllAnimSFXAkEvent,true);

		PlayCustomAnimByDurationOnAll( CAN_FLY_IN, 1.5f, 0.5f, 0.5f, false, true );
	}

	simulated event EndState( Name NewStateName )
	{
		local float gamespeed;
		//StopCustomAnimOnAll( CAN_FLY_IN, 0.0f );

		if (mStateBlend != None)
		{
			gamespeed = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();
			gamespeed *= mOwner.CustomTimeDilation;
			mStateBlend.SetActiveChild(0, 0.3f / gamespeed);
		}
	}

Begin:
	FinishAnim( mAnimNode.GetCustomAnimNodeSeq(), true );
	PlayAnim( CAN_IDLE );
}

state FlyOut
{
	simulated event BeginState( Name PreviousStateName )
	{
		mOwner.PlayAkEvent(mStopAllAnimSFXAkEvent,true);

		PlayCustomAnimByDurationOnAll( CAN_FLY_OUT, 1.f, 0.5f, 0.5f, false, true );
	}

Begin:
	FinishAnim( mAnimNode.GetCustomAnimNodeSeq(), true );
	PlayAnim( CAN_LOOP_FLY );
}

state DivingLoop
{
	simulated event BeginState( Name PreviousStateName )
	{
		mOwner.PlayAkEvent(mStopAllAnimSFXAkEvent,true);

		PlayCustomAnimOnAll( CAN_DIVING_LOOP, 1.f, 0.5f, 0.5f, true, true );
	}
		
	simulated event EndState( Name NewStateName )
	{
		StopCustomAnimOnAll( CAN_DIVING_LOOP, 0.0f );
	}
}

function OnRangeAttackShoot()
{
	local SkeletalMeshComponent skelMesh;

	;

	class'H7Camera'.static.GetInstance().PlayCameraShake( GetShakeForEvent( GetCreatureEventByAnim( mCurrentAnim ) ), 1.0f );
	OnShootFunc();

	// hide the projectile that is attached to the creature
	skelMesh = GetProjectileSkelMesh();
	if( skelMesh != none )
	{
		skelMesh.SetHidden( true );
	}
}

// TODO OAK
protected function SkeletalMeshComponent GetProjectileSkelMesh()
{
	//local H7WeaponAttachment weaponAttachment;
	//local array<H7WeaponAttachment> weaponAttachmentArray;

	//weaponAttachmentArray = mOwner.GetWeaponAttachments();
	//foreach weaponAttachmentArray( weaponAttachment )
	//{
	//	if( weaponAttachment.IsProjectile )
	//	{
	//		return weaponAttachment.WeaponSkeletalMesh;
	//	}
	//}

	return none;
}


protected function OnAttackHit()
{
	class'H7Camera'.static.GetInstance().PlayCameraShake( GetShakeForEvent( GetCreatureEventByAnim( mCurrentAnim ) ), 1.0f );
	if( OnHitFunc != none )
	{
		OnHitFunc();
	}
	else
	{
		OnShootFunc();
	}

	mOwner.PlayAbility1EndSound();
}

protected function float GetEventTime( ECreatureEventType eventType )
{
	local H7CreatureEvent creatureEvent;

	foreach mCreatureEvents( creatureEvent )
	{
		if( creatureEvent.EventType == eventType )
		{
			return ( creatureEvent.Time / mOwner.CustomTimeDilation ) / class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();
		}
	}

	;

	return ( 1.0f * mOwner.CustomTimeDilation );
}

protected function CameraShake GetShakeForEvent( ECreatureEventType eventType )
{
	local H7CreatureEvent creatureEvent;

	if( eventType == CE_MAX ) return none;

	foreach mCreatureEvents( creatureEvent )
	{
		if( creatureEvent.EventType == eventType )
		{
			return creatureEvent.CameraShake;
		}
	}

	;

	return none;
}

function float GetCurrentAnimNodeTimeLeft()
{
	return mAnimNode.GetCustomAnimNodeSeq().GetTimeLeft();
}

function float GetCurrentAnimNodeTimeDuration()
{
	return mAnimNode.GetCustomAnimNodeSeq().GetAnimPlaybackLength();
}

function float GetCurrentAnimNodeRate()
{
	return mAnimNode.GetCustomAnimNodeSeq().Rate;
}

