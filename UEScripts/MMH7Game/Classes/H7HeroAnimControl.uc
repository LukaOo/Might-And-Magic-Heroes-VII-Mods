//=============================================================================
// H7HeroAnimControl
//=============================================================================
// Plays the animations of the hero and his sounds
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7HeroAnimControl extends Actor
	dependson(H7StructsAndEnumsNative)
	native;


var protected AnimationData					mAnimations[EHeroAnimation.HA_MAX];

var protected H7EditorHero					mOwner;
var protected array<H7HeroEvent>			mHeroEvents;

var protected bool                          mIsOnShip;
var protected bool                          mHeroIdleSoundPlayed;

var protected array<AnimNodePlayCustomAnim>	mAnimNodes;
var protected array<SkelControlSingleBone> mBigHeadNodes;

function array<AnimNodePlayCustomAnim> GetAnimNodes() { return mAnimNodes; }
function array<SkelControlSingleBone> GetBigHeadNodes() { return mBigHeadNodes; }

// methods
// =======

function Init( H7EditorHero heroOwner )
{
	local AnimNodePlayCustomAnim currentAnimaNode;
	local SkelControlSingleBone currentBigHeadNode;
	local H7AchievementManager achManager;

	mOwner = heroOwner;

	mAnimNodes.Length = 0; // reset array

	mOwner.GetVisuals();

	// horse
	currentAnimaNode = mOwner.mHorseSkeletalMesh != none ? AnimNodePlayCustomAnim(mOwner.mHorseSkeletalMesh.FindAnimNode( 'GeneralNode' )) : none;
	if( currentAnimaNode != none )
	{
		mAnimNodes.AddItem( currentAnimaNode );
	}
	currentAnimaNode = (mOwner.GetAdventureArmy() != None && mOwner.GetAdventureArmy().mHorseMesh != none) ? AnimNodePlayCustomAnim(mOwner.GetAdventureArmy().mHorseMesh.FindAnimNode( 'GeneralNode' )) : none;
	if( currentAnimaNode != none )
	{
		mAnimNodes.AddItem( currentAnimaNode );
	}
	// hero
	currentAnimaNode = mOwner.mHeroSkeletalMesh != none ? AnimNodePlayCustomAnim(mOwner.mHeroSkeletalMesh.FindAnimNode( 'GeneralNode' )) : none;
	if( currentAnimaNode != none )
	{
		mAnimNodes.AddItem( currentAnimaNode );
	}
	currentAnimaNode = (mOwner.GetAdventureArmy() != None && mOwner.GetAdventureArmy().SkeletalMeshComponent != none) ? AnimNodePlayCustomAnim(mOwner.GetAdventureArmy().SkeletalMeshComponent.FindAnimNode( 'GeneralNode' )) : none;
	if( currentAnimaNode != none )
	{
		mAnimNodes.AddItem( currentAnimaNode );
	}

	// big head nodes
	
	if(class'H7PlayerProfile'.static.GetInstance() != none && class'H7PlayerProfile'.static.GetInstance().GetAchievementManager() != none)
	{
		achManager = class'H7PlayerProfile'.static.GetInstance().GetAchievementManager();
	}

	currentBigHeadNode = mOwner.mHorseSkeletalMesh != none ? SkelControlSingleBone(mOwner.mHorseSkeletalMesh.FindSkelControl( 'BigHead' )) : none;
	if( currentBigHeadNode != none )
	{
		if(achManager != none)
		{
			currentBigHeadNode.SetSkelControlActive(achManager.GetStateReward_BH() && achManager.CanRewardBeUsed());
		}
		mBigHeadNodes.AddItem( currentBigHeadNode );
	}
	currentBigHeadNode = (mOwner.GetAdventureArmy() != None && mOwner.GetAdventureArmy().mHorseMesh != none) ? SkelControlSingleBone(mOwner.GetAdventureArmy().mHorseMesh.FindSkelControl( 'BigHead' )) : none;
	if( currentBigHeadNode != none )
	{
		if(achManager != none)
		{
			currentBigHeadNode.SetSkelControlActive(achManager.GetStateReward_BH() && achManager.CanRewardBeUsed());
		}
		mBigHeadNodes.AddItem( currentBigHeadNode );
	}
	currentBigHeadNode = mOwner.mHeroSkeletalMesh != none ? SkelControlSingleBone(mOwner.mHeroSkeletalMesh.FindSkelControl( 'BigHead' )) : none;
	if( currentBigHeadNode != none )
	{
		if(achManager != none)
		{
			currentBigHeadNode.SetSkelControlActive(achManager.GetStateReward_BH() && achManager.CanRewardBeUsed());
		}
		mBigHeadNodes.AddItem( currentBigHeadNode );
	}
	currentBigHeadNode = (mOwner.GetAdventureArmy() != None && mOwner.GetAdventureArmy().SkeletalMeshComponent != none) ? SkelControlSingleBone(mOwner.GetAdventureArmy().SkeletalMeshComponent.FindSkelControl( 'BigHead' )) : none;
	if( currentBigHeadNode != none )
	{
		if(achManager != none)
		{
			currentBigHeadNode.SetSkelControlActive(achManager.GetStateReward_BH() && achManager.CanRewardBeUsed());
		}
		mBigHeadNodes.AddItem( currentBigHeadNode );
	}


	if(mOwner.GetVisuals() != none)
	{
		mHeroEvents = mOwner.GetVisuals().GetHeroEvents();
	}

	GotoState( 'Idling' );
	SetIdleBridgeFrequency();

	//To calculate and set the WWise playback speed
	if(mOwner.GetAnimSoundSpeedManipulator() != 0)
	{
		mOwner.ChangeUnitAnimationSoundSpeed();
	}

	CheckMovementType();
}

function CheckMovementType()
{
	if(mOwner.GetAdventureArmy()!=None)
	{
		mIsOnShip = mOwner.GetAdventureArmy().GetShip() != none;
	}
	else
	{
		mIsOnShip=false;
	}
	mOwner.SetMovementAudioType();
}

function SetIdleBridgeFrequency()
{
	local AnimNodeRandom idleAnimNodeRandom;
	local float idleLength;
	local AnimSequence currentAnimSeq;
	local SkeletalMeshComponent skelMesh;

	if( mAnimNodes.Length == 0 )
	{
		return;
	}

	skelMesh = mAnimNodes[0].SkelComponent;
	if( skelMesh.AnimSets.Length == 0 )
	{
		return;
	}

	foreach skelMesh.AnimSets[0].Sequences( currentAnimSeq )
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

	idleAnimNodeRandom = AnimNodeRandom( skelMesh.FindAnimNode( 'IdleRandom' ) );
	if( idleAnimNodeRandom != none)
	{
		idleAnimNodeRandom.RandomInfo[0].LoopCountMin = 20 / idleLength;
		idleAnimNodeRandom.RandomInfo[0].LoopCountMax = 40 / idleLength;
		idleAnimNodeRandom.RandomInfo[0].LoopCount = Rand( idleAnimNodeRandom.RandomInfo[0].LoopCountMax ) % idleAnimNodeRandom.RandomInfo[0].LoopCountMax;
		idleAnimNodeRandom.RandomInfo[1].Chance = 1.f;
	}
	//Enables the correct idle bridge regarding the maptype
	mOwner.EnableAdventureIdleBridge(mOwner.IsA('H7AdventureHero'));

	CheckMovementType();
}

function AddWeaponAttachments( H7EditorHero heroOwner, SkeletalMeshComponent baseComp ,array<H7WeaponAttachment> weaponAttachments, DynamicLightEnvironmentComponent dynamicLightEnv )
{
	local H7WeaponAttachment currentAttachment;
	local SkeletalMeshComponent meshComp;

	foreach weaponAttachments( currentAttachment )
	{
		meshComp = new class'SkeletalMeshComponent'( currentAttachment.WeaponSkeletalMesh );
		meshComp.SetLightEnvironment( dynamicLightEnv );
		meshComp.SetActorCollision( true, true, true );
		meshComp.SetTraceBlocking( true, true );

		if( currentAttachment.IsSocketAttached )
		{
			baseComp.AttachComponentToSocket( meshComp, currentAttachment.SocketAttachName );
		}
		else
		{
			heroOwner.AttachComponent( meshComp );
			mAnimNodes.AddItem( AnimNodePlayCustomAnim( meshComp.FindAnimNode( 'GeneralNode' ) ) );
		}
	}
}

delegate OnFinishedAnimFunc(){}
delegate OnHitFunc(){}
function PlayAnim( EHeroAnimation heroAnimation, optional delegate<OnFinishedAnimFunc> onFinishedAnim, optional delegate<OnHitFunc> onHit )
{
	;
	
	CheckMovementType();

	if(heroAnimation == HA_NONE )
	{
		if(onFinishedAnim != none) { onFinishedAnim(); }
		if(onHit != none) { onHit(); }
		return;
	}
	// if the timer is not yet triggered, trigger it and reset the timer
	if( IsTimerActive( nameof(OnAttackHit) ) )
	{
		OnAttackHit();
		SetTimer( 0, false, nameof(OnAttackHit) );
	}

	OnFinishedAnimFunc = onFinishedAnim;
	OnHitFunc = onHit;

	GotoState( mAnimations[heroAnimation].StateName );
}

// plays a custom animation on all the skeletal meshes (hero and mount)
protected function PlayCustomAnimOnAll( EHeroAnimation animId, float rate, float blendInTime, float blendOutTime, bool doLooping, bool doOverride )
{
	local AnimNodePlayCustomAnim currentAnim;
	local name animName;
	local float gS;
	local array<AnimNotifyEvent> animEvents;
	local AnimNotifyEvent animEvent;

	CheckMovementType();

	gS = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();
	animName = mAnimations[animId].AnimName;

	//To calculate and set the WWise playback speed
	if(mOwner.GetAnimSoundSpeedManipulator() != 0)
	{
		mOwner.ChangeUnitAnimationSoundSpeed();
	}

	foreach mAnimNodes( currentAnim )
	{
		if (currentAnim != None)
		{
			if(currentAnim.GetCustomAnimNodeSeq().AnimSeq != none && currentAnim.GetCustomAnimNodeSeq().AnimSeq.Notifies.Length > 0)
			{
				animEvents = currentAnim.GetCustomAnimNodeSeq().AnimSeq.Notifies;
				foreach animEvents(animEvent)
				{
					if(animEvent.Notify == none || !animEvent.Notify.IsA('AnimNotify_Sound')) continue;
					AnimNotify_Sound(animEvent.Notify).VolumeMultiplier = class'H7SoundController'.static.GetInstance().GetSoundVolume();
				}
			}

			currentAnim.PlayCustomAnim( animName, rate * gS, blendInTime / gS, blendOutTime / gS, doLooping, doOverride );
			;
		}
	}
}

// pauses the currently played custom animation on all the skeletal meshes (creature and weapons)
function ModifyRateCurrentAnimation( float newRate )
{
	local AnimNodePlayCustomAnim currentAnim;

	//To calculate and set the WWise playback speed
	if( mOwner == none ) { ; ScriptTrace(); return; }

	mOwner.ChangeUnitAnimationSoundSpeed(newRate);

	foreach mAnimNodes( currentAnim )
	{
		if (currentAnim != None && currentAnim.GetCustomAnimNodeSeq() != none )
		{
			currentAnim.GetCustomAnimNodeSeq().Rate = newRate;
		}
	}
}

// stops a custom animation on all the skeletal meshes (hero and mount)
protected function StopCustomAnimOnAll( EHeroAnimation animId, float blendOutTime )
{	
	local AnimNodePlayCustomAnim currentAnim;

	foreach mAnimNodes( currentAnim )
	{
		if (currentAnim != None)
		{
			currentAnim.StopCustomAnim( blendOutTime );
		}
	}
}

function bool IsPlayingAnim()
{
	local AnimNodePlayCustomAnim currentAnim;

	foreach mAnimNodes( currentAnim )
	{
		if (currentAnim != None && (currentAnim.bIsPlayingCustomAnim || currentAnim.BlendTimeToGo > 0.05f ))
		{
			return true;
		}
	}

	return false;
}


// Return largest TimeLeft from all playing seqences
function float GetCurrentAnimNodeTimeLeft()
{
	local float TimeLeft;
	local int i;
	
	TimeLeft = 0.0f;

	for( i = 0; i < mAnimNodes.Length; ++i)
	{
		if(mAnimNodes[i].GetCustomAnimNodeSeq().GetTimeLeft() > TimeLeft)
		{
			TimeLeft = mAnimNodes[i].GetCustomAnimNodeSeq().GetTimeLeft();
		}
	}

	return TimeLeft;
}


auto state NotInitialized
{
}

state Idling
{
	simulated event BeginState( Name PreviousStateName )
	{
		StopCustomAnimOnAll( HA_IDLE, 0.15f );
		CheckMovementType();

		if( mOwner.GetFaction() != none )
		{
			mOwner.PlayHeroSound(HEROTYPE_MAGIC, mIsOnShip ? HEROSOUND_SHIP_IDLE : HEROSOUND_MOUNTED_IDLE );
			mHeroIdleSoundPlayed = true;
		}
	}

	simulated event EndState( Name NewStateName )
	{
		if(mOwner == none)
		{
			GotoState( 'NotInitialized' );
			return;
		}

		if( mOwner.GetFaction() != none )
		{
			mOwner.PlayHeroSound(HEROTYPE_MAGIC, mIsOnShip ? HEROSOUND_SHIP_IDLE_END : HEROSOUND_MOUNTED_IDLE_END );
			mHeroIdleSoundPlayed = false;
		}
		else
		{
			class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("Faction not set for"@mOwner@mOwner.GetName(),MD_QA_LOG);;
		}
	}
}

state Moving
{
	simulated event BeginState( Name PreviousStateName )
	{
		local float AnimSpeed;

		AnimSpeed = 1.7f;
		// the faster the gamespeed, the not-so-fast the animation should play (prevents jittery at 400%)
		AnimSpeed *= FMin( class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed() / 2, 2.8f );

		PlayCustomAnimOnAll( HA_MOVE, AnimSpeed, 0.25f, 0.1f, true, false );

		CheckMovementType();

		if( mOwner.GetFaction() != none )
		{
			mOwner.PlayHeroSound(HEROTYPE_MAGIC, mIsOnShip ? HEROSOUND_MOVE_SHIP : HEROSOUND_MOUNTED_MOVE );
			
			if(mIsOnShip)
			{
				mOwner.EnableUnitMoveSound(false);
			}
			else
			{
				mOwner.EnableUnitMoveSound(true);
			}
		}
		else
		{
			class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("Faction not set for"@mOwner@mOwner.GetName(),MD_QA_LOG);;
		}
	}

	simulated event EndState( Name NewStateName )
	{
		mOwner.EnableUnitMoveSound(false);

		if( mOwner.GetFaction() != none )
		{
			mOwner.PlayHeroSound(HEROTYPE_MAGIC, mIsOnShip ? HEROSOUND_MOVE_SHIP_END : HEROSOUND_MOUNTED_MOVE_END );
		}
		else
		{
			class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("Faction not set for"@mOwner@mOwner.GetName(),MD_QA_LOG);;
		}
	}


}

state TurningLeft
{
	simulated event BeginState( Name PreviousStateName )
	{
		PlayCustomAnimOnAll( HA_TURNLEFT, 1.55f, 0.2f / class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed(), 0.4f / class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed(), false, true );
		
		CheckMovementType();

		if(mIsOnShip)
		{
			mOwner.EnableUnitMoveSound(false);
		}
		else
		{
			mOwner.EnableUnitMoveSound(true);
		}

		if( mOwner.GetFaction() != none )
		{
			mOwner.PlayHeroSound(HEROTYPE_MAGIC, mIsOnShip ? HEROSOUND_SHIP_TURNING : HEROSOUND_MOUNTED_TURNLEFT );
		}
		else
		{
			class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("Faction not set for"@mOwner@mOwner.GetName(),MD_QA_LOG);;
		}
	}
}

state TurningRight
{
	simulated event BeginState( Name PreviousStateName )
	{
		PlayCustomAnimOnAll( HA_TURNRIGHT, 1.55f, 0.2f / class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed(), 0.4f / class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed(), false, true );

		CheckMovementType();

		if(mIsOnShip)
		{
			mOwner.EnableUnitMoveSound(false);
		}
		else
		{
			mOwner.EnableUnitMoveSound(true);
		}

		if( mOwner.GetFaction() != none )
		{
			mOwner.PlayHeroSound(HEROTYPE_MAGIC, mIsOnShip ? HEROSOUND_SHIP_TURNING : HEROSOUND_MOUNTED_TURNRIGHT );

		}
		else
		{
			class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("Faction not set for"@mOwner@mOwner.GetName(),MD_QA_LOG);;
		}
	}
}

state Attacking
{
	simulated event BeginState( Name PreviousStateName )
	{
		CheckMovementType();
		PlayCustomAnimOnAll( HA_ATTACK, 1.f, 0.3f, 0.3f, false, true );
		SetTimer( GetEventTime( HE_ATTACK_HIT_TIME ), false, nameof(OnAttackHit) );
		mOwner.PlayHeroSound(HEROTYPE_MAGIC, HEROSOUND_MOUNTED_RANGEATTACK );
	}

Begin:
	FinishAnim( mAnimNodes[0].GetCustomAnimNodeSeq() );
	OnFinishedAnimFunc();
	PlayAnim( HA_IDLE );
}

function OnAttackHit()
{
	OnHitFunc();
}

state DoingAbility
{
	simulated event BeginState( Name PreviousStateName )
	{
		CheckMovementType();
		PlayCustomAnimOnAll( HA_ABILITY, 1.f, 0.3f, 0.3f, false, true );
		SetTimer( GetEventTime( HE_ABILITY_CAST_TIME ), false, nameof(OnAttackHit) );
		mOwner.PlayHeroSound(HEROTYPE_MAGIC, HEROSOUND_MOUNTED_RANGEATTACK );
	}

Begin:
	FinishAnim( mAnimNodes[0].GetCustomAnimNodeSeq() );
	OnFinishedAnimFunc();
	PlayAnim( HA_IDLE );
}

state DoingVictory
{
	simulated event BeginState( Name PreviousStateName )
	{
		CheckMovementType();
		PlayCustomAnimOnAll( HA_VICTORY, 1.f, 0.5f, 0.5f, false, true );
		if(mOwner.GetFaction() != none)
		{
			mOwner.PlayHeroSound(HEROTYPE_MAGIC, HEROSOUND_MOUNTED_VICTORY );
		}
	}

Begin:
	if(mAnimNodes.Length > 0)
	{
		FinishAnim( mAnimNodes[0].GetCustomAnimNodeSeq() );
	}
	PlayAnim( HA_IDLE );
}

protected function float GetEventTime( EHeroEventType eventType )
{
	local H7HeroEvent heroEvent;

	foreach mHeroEvents( heroEvent )
	{
		if( heroEvent.EventType == eventType )
		{
			return heroEvent.Time / class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();
		}
	}


	if(eventType == HE_ABILITY_CAST_TIME)
	{
		return 2.1166f / class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();
	}

	//`warn( "Missing eventType" @ eventType @ "on hero" @ mOwner.GetName() );
	return 1.0f;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

