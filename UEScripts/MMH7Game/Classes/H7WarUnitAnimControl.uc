//=============================================================================
// H7WarUnitAnimControl
//=============================================================================
// Plays the animations of the warunit and his sounds
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7WarUnitAnimControl extends Actor
	dependson(H7HeroAnimControl);


var protected AnimationData             mAnimations[EWarUnitAnimation.WA_MAX];
var protected H7WarUnit                 mOwner;
var protected H7USSProjectile		    mProjectile;
var protected AnimNodePlayCustomAnim    mAnimNode;
var protected AnimNodePlayCustomAnim    mAnimNode2;
var protected EWarUnitAnimation         mCurrentAnim;
var protected array<H7WarfareEvent> 	mAnimEvents;
var protected AnimNodeBlendList	        mDeadBlend;
var protected AnimNodeBlendList	        mDeadBlend2;

// methods
// =======

function Init( H7WarUnit warunitOwner, SkeletalMeshComponent skelComp, SkeletalMeshComponent skelComp2, array<H7WarfareEvent> warunitEvents  )
{
	mOwner = warunitOwner;
	mAnimNode = AnimNodePlayCustomAnim( skelComp.FindAnimNode( 'GeneralNode' ) );
	if( skelComp2 != none )
	{
		mAnimNode2 = AnimNodePlayCustomAnim( skelComp2.FindAnimNode( 'GeneralNode' ) );
	}
	mDeadBlend = AnimNodeBlendList( skelComp.FindAnimNode( 'DeadBlend' ) );
	if( skelComp2 != none )
	{
		mDeadBlend2 = AnimNodeBlendList( skelComp2.FindAnimNode( 'DeadBlend' ) );
	}
	mCurrentAnim = WA_IDLE;
	mAnimEvents = warunitEvents;
}

delegate OnFinishedAnimFunc(){}
delegate OnShootFunc(){}
function PlayAnim( EWarUnitAnimation wuAnimation, optional delegate<OnFinishedAnimFunc> onFinishedAnim, optional delegate<OnShootFunc> onShoot )
{
	;

	// if the timer is not yet triggered, trigger it and reset the timer
	if( IsTimerActive( nameof(OnRangeAttackShoot) ) )
	{
		OnRangeAttackShoot();
		SetTimer( 0, false, nameof(OnRangeAttackShoot) );
	}

	OnFinishedAnimFunc = onFinishedAnim;
	OnShootFunc = onShoot;

	mCurrentAnim = wuAnimation;

	GotoState( mAnimations[wuAnimation].StateName );
}

// plays a custom animation on all the skeletal meshes (hero and mount)
protected function PlayCustomAnimOnAll( EWarUnitAnimation animId, float rate, float blendInTime, float blendOutTime, bool doLooping, bool doOverride )
{
	local name animName;
	local float gS;

	gS = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();
	animName = mAnimations[animId].AnimName;
	if (mAnimNode != None)
	{
		mAnimNode.PlayCustomAnim( animName, rate * gS, blendInTime*gS, blendOutTime*gS, doLooping, doOverride );
		;
	}
	if (mAnimNode2 != None)
	{
		mAnimNode2.PlayCustomAnim( animName, rate * gS, blendInTime*gS, blendOutTime*gS, doLooping, doOverride );
		;
	}
}

// stops a custom animation on all the skeletal meshes (hero and mount)
protected function StopCustomAnimOnAll( EWarUnitAnimation animId, float blendOutTime )
{	
	if(mAnimNode != None)
	{
		mAnimNode.StopCustomAnim( blendOutTime );
	}
	if(mAnimNode2 != None)
	{
		mAnimNode2.StopCustomAnim( blendOutTime );
	}
}

// Return largest TimeLeft from all playing seqences
function float GetCurrentAnimNodeTimeLeft()
{
	local AnimNodePlayCustomAnim curr;

	curr = mAnimNode;
	if ( curr == none ) curr = mAnimNode2;

	if( curr == none ) // no anim node
		return 1.f;
	else if( mAnimNode != none && mAnimNode2 != none ) // all anim nodes!
		return (mAnimNode.GetCustomAnimNodeSeq().GetTimeLeft() > mAnimNode2.GetCustomAnimNodeSeq().GetTimeLeft()) ? mAnimNode.GetCustomAnimNodeSeq().GetTimeLeft() : mAnimNode2.GetCustomAnimNodeSeq().GetTimeLeft();
	else // one anim node
		return curr.GetCustomAnimNodeSeq().GetTimeLeft();
}

auto state Idling
{
	simulated event BeginState( Name PreviousStateName )
	{
		StopCustomAnimOnAll( WA_IDLE, 0.1f );
		mOwner.RecalculatePostAnimInput();
	}
}

state Hitting
{
	simulated event BeginState( Name PreviousStateName )
	{
		PlayCustomAnimOnAll( mCurrentAnim, 1.f, 0.1f, 0.1f, false, true );
	}

	Begin:
	FinishAnim( mAnimNode.GetCustomAnimNodeSeq(), true );
	OnFinishedAnimFunc();
	PlayAnim( WA_IDLE );
}

state RangeAttacking
{
	simulated event BeginState( Name PreviousStateName )
	{
		PlayCustomAnimOnAll( mCurrentAnim, 1.f, 0.1f, 0.1f, false, true );
		SetTimer( GetEventTime( WU_RANGE_ATTACK_TIME ), false, nameof(OnRangeAttackShoot) );
	}

Begin:
	FinishAnim( mAnimNode.GetCustomAnimNodeSeq(), true );
	OnFinishedAnimFunc();
	PlayAnim( WA_IDLE );
}

state DoAbility
{
	simulated event BeginState( Name PreviousStateName )
	{
		PlayCustomAnimOnAll( mCurrentAnim, 1.f, 0.1f, 0.1f, false, true );
		SetTimer( GetEventTime( WU_ABILITY_CAST_TIME ), false, nameof(OnRangeAttackShoot) ); // just use the shoot delegate
	}

Begin:
	FinishAnim( mAnimNode.GetCustomAnimNodeSeq(), true );
	OnFinishedAnimFunc();
	PlayAnim( WA_IDLE );
}

state Dying
{
	simulated event BeginState( Name PreviousStateName )
	{
		PlayCustomAnimOnAll( mCurrentAnim, 1.f, 0.1f, 0.1f, false, true );
		SetTimer( mAnimNode.GetCustomAnimNodeSeq().GetTimeLeft() - 0.1f, false, nameof(FinishDying) );
		if(mDeadBlend != none)
		{
			mDeadBlend.SetActiveChild(1, 0.2f);
		}
		if(mDeadBlend2 != none)
		{
			mDeadBlend2.SetActiveChild(1, 0.2f);
		}
		mOwner.PlayDeathEffect();
	}
}

function OnRangeAttackShoot()
{
	OnShootFunc();
}

protected function FinishDying()
{
}


protected function float GetEventTime(  EWarfareUnitEventType eventType )
{
	local H7WarfareEvent wuEvent;

	foreach mAnimEvents( wuEvent )
	{
		if( wuEvent.EventType == eventType )
		{
			return wuEvent.Time / class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();
		}
	}

	;

	return 1.0f;
}

