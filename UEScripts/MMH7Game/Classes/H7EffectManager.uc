//=============================================================================
// H7EffectManager
//
// - 
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectManager extends Object
	native;

// the default creature size to scale the effects against. correlates to the bounding box height of a Crossbowman
const DefaultCreatureSize = 210.0f;

var protected H7Creature mCreature;
var protected array<H7FXStruct> mEffectQueue;
var protected array<H7FXStruct> mPermanentFX;

var protected array<ParticleSystemComponent> mPermanentComponents;

var protected ParticleSystemComponent mCurrentParticleSystem;

var protected Actor mOwner;
var protected H7Unit mUnitOwner;
var protected bool mIsInCombatMap;
var protected float mCurrentParticleMaxLifespan;
var protected bool mIgnoreCurrentParticle;

var protected bool mIsPlayingMaterialFX;

function bool	GetIgnoreCurrentParticle()	            { return mIgnoreCurrentParticle; }
function	    SetIgnoreCurrentParticle( bool value )	{ mIgnoreCurrentParticle = value; }

function bool IsAllEffectsFinished( optional out float currLifeSpan)
{
	currLifeSpan = 0.f;
	if(mCurrentParticleSystem != none)
	{
		if( mIgnoreCurrentParticle ) return true;

		if( mCurrentParticleMaxLifespan <= 0.0f )
		{

		}
		else if(mCurrentParticleSystem.bIsActive && !mIgnoreCurrentParticle)
		{
			currLifeSpan = mCurrentParticleMaxLifespan;
			return false;
		}
	}

	return mEffectQueue.Length == 0;
}

function Init( Actor unit )
{
	mOwner = unit;
	mUnitOwner = H7Unit( unit );
	mIsInCombatMap = class'H7ReplicationInfo'.static.GetInstance().IsCombatMap();
}

function NotifyMaterialFXCompleted()
{
	mIsPlayingMaterialFX = false;
}

function bool HasDuplicate( H7FXStruct effect )
{
	if ( mEffectQueue.Find( 'mVFX', effect.mVFX ) != INDEX_NONE )
	{
		return true;
	}

	return false; 
}

function StartMaterialFX(H7FXStruct effect)
{
	local H7FXStruct tmpEffect;
	local int i;
	local bool startFX;

	if(effect.mMaterialFX.Length == 0) { return; }
	
	tmpEffect = effect;

	for( i = 0; i < effect.mMaterialFX.Length; ++i )
	{
		if(effect.mMaterialFX[i].GotMaterialFX)
		{
			startFX = true;
			break;
		}
	}

	if( startFX )
	{
		mCreature = H7CreatureStack(mOwner).GetCreature();
		mCreature.StartSetEffectMaterialValues(tmpEffect);
		mIsPlayingMaterialFX = !effect.mIsPermanentFX;
	}
}

function StartFXAnimations(H7FXStruct effect)
{
	local ECreatureAnimation animation;
	animation = effect.mFXAnimations;

	if(animation != CAN_NONE && animation != CAN_IDLE)
	{
		mCreature = H7CreatureStack(mOwner).GetCreature();
		mCreature.GetAnimControl().PlayAnim(animation);
	}
}

function ChangeAnimationSpeed(H7FXStruct effect)
{
	local H7Creature creature;

	if(effect.mChangeAnimSpeed)
	{
		H7CreatureStack(mOwner).ChangeLocomotionSpeed(effect);
		creature = H7CreatureStack(mOwner).GetCreature();
		creature.ChangeAnimationSpeedFX(effect);
		AddPermanentEffect( effect );
	}
}

function AddToFXQueue( H7FXStruct effect, H7Effect source, optional bool isBeam, optional Vector src, optional vector target, optional bool playInstant = false, optional Rotator rotation )
{
	local float UnitSize;
	local H7CreatureStack UnitOwner;

	if( effect.mSkipQueue )
	{
		playInstant = true;
	}

	if( source == none )
	{
		return;
	}

	effect.mSource = source;

	effect.isBeam = isBeam;
	effect.source = src;
	effect.target = target;
	effect.rotation = rotation;
	
	if(source.GetSource().IsBuff())
	{
		ChangeAnimationSpeed(effect);
	}

	if( effect.mVFX == none && effect.mSFX != none && effect.mMaterialFX.Length == 0 && effect.mFXAnimations != CAN_NONE && effect.mFXAnimations != CAN_IDLE ) return;

	if( effect.mNoDuplicateVFX )
	{
		if( HasDuplicate( effect ) )
		{
			return;
		}
	}

	// override any 0 scale values because defaultproperties doesn't go through with 1.0f
	if( effect.mBaseScale == 0.0f )
	{
		effect.mScale = 1.0f;
	}
	else
	{
		effect.mScale = effect.mBaseScale;
	}
	
	if( effect.mScaleWithTarget )
	{
		if( mOwner.IsA( 'H7Unit' ) )
		{
			UnitOwner = H7CreatureStack(mOwner);
			if (UnitOwner != None)
			{
				UnitSize = UnitOwner.GetCreature().GetColliderHeight() * 2.0f;
				effect.mScale *= UnitSize / DefaultCreatureSize;
			}

		}
	}
	
	if( ( effect.mVFX != none && effect.mVFX.GetMaxLifespan(effect.mVFX.Delay) <= 0.0f ) || effect.mIsPermanentFX )
	{
		AddPermanentEffect( effect );
	}
	else if( playInstant )
	{
		Play( effect );
	}
	else
	{
		mEffectQueue.AddItem( effect );
	}
	
	if( mEffectQueue.Length == 1 )
	{
		Play();
	}
}

function AddPermanentEffect( H7FXStruct effect )
{
	local ParticleSystemComponent comp;

	mPermanentFX.AddItem( effect );

	if(effect.mMaterialFX.Length > 0)
	{
		StartMaterialFX(effect);
	}

	comp = PlayVFX( effect.mVFX, effect.mFXPosition, effect.mSocketName, effect.mScale, effect.target, effect.rotation );

	if(effect.mSFX != none)
	{
		PlaySFX(effect);
	}

	if( effect.isBeam ) UseBeam( comp, effect );
	mPermanentComponents.AddItem( comp );
}

function protected ClearFXQueue()
{
	mEffectQueue.Length = 0;

	if( mCurrentParticleSystem != none )
	{
		mCurrentParticleSystem.KillParticlesForced();
	}
}

function ResetFX()
{
	local ParticleSystemComponent currentComponent;
	local H7FXStruct currentFx;

	ClearFXQueue();

	foreach mPermanentComponents( currentComponent ) 
	{
		currentComponent.KillParticlesForced();
	}

	//Ensure all looping SFX are stopped on Reset
	foreach mPermanentFX( currentFx )
	{
		if(currentFx.mStopSFX != none)
		{
			class'H7SoundManager'.static.PlayAkEventOnActor(mOwner,currentFx.mStopSFX);
		}
	}

	mPermanentComponents.Length = 0;
	mPermanentFX.Length = 0;
}

function protected ParticleSystemComponent PlayVFX( ParticleSystem particle, EFXPosition pos, String socketName, float scale, Vector targetPos, Rotator rotation )
{
	local Vector spawnPosition;
	local ParticleSystemComponent particleComponent;
	local SkeletalMeshSocket socket;
	local SkeletalMeshComponent meshComp;
	local H7CreatureStack creatureStack;
	local Rotator finalRotation, emptyRot;

	if( particle == none ) return none;

	switch( pos )
	{
		case FXP_ABOVE_TARGET: 
			if( mOwner.IsA('H7Unit') ) 
			{
				spawnPosition = H7Unit( mOwner ).GetHeightPos(0.0f); 
			}
			else
			{
				spawnPosition = mOwner.GetTargetLocation();
			}
			break;
		case FXP_SOCKET: 
			if( mOwner.IsA('H7CreatureStack' ) )
			{   
				meshComp = H7CreatureStack( mOwner ).GetCreature().GetSkeletalMesh();
			}
			else if( mOwner.IsA('H7EditorHero') )
			{
				meshComp = H7EditorHero( mOwner ).mHeroSkeletalMesh;
			}
			else if( mOwner.IsA( 'H7WarUnit' ) )
			{
				meshComp = H7WarUnit( mOwner ).mSkeletalMesh;
			}

			if( meshComp != none )
			{
				socket = meshComp.GetSocketByName( Name( socketName ) );
				spawnPosition = socket != none ? socket.RelativeLocation + meshComp.GetBoneLocation( socket.BoneName ) : mOwner.GetTargetLocation();
			}
			else
			{
				spawnPosition = mOwner.GetTargetLocation();
			}
			break;
		case FXP_TARGET_POSITION:
			if( mOwner.IsA('H7Unit') ) 
			{
				spawnPosition = H7Unit( mOwner ).GetMeshCenter(); 
			}
			else
			{
				spawnPosition = mOwner.Location;
			}
			break;
		case FXP_BELOW_TARGET:
			spawnPosition = mOwner.Location;
			break;
		case FXP_HIT_POSITION:
			spawnPosition = targetPos;
			break;
	}

	if( rotation == emptyRot )
	{
		finalRotation = mOwner.Rotation;
	}
	else
	{
		finalRotation = rotation;
	}
	
	//TODO: see if not using emitterpool at all is an option
	if( H7Unit( mOwner ) != none && meshComp != none && pos == FXP_SOCKET )
	{
		particleComponent = new class'ParticleSystemComponent'();
		particleComponent.SetTemplate( particle );
		if (socketName == "RootHack")
		{
			meshComp.Owner.AttachComponent( particleComponent );
		}
		else
		{
			meshComp.AttachComponentToSocket( particleComponent, Name( socketName ) );
		}
	}
	else
	{
		particleComponent = particle != none ? mOwner.WorldInfo.MyEmitterPool.SpawnEmitter( particle, spawnPosition, finalRotation, mOwner ) : none;
	}


	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		class'H7CombatMapGridController'.static.GetInstance().AddParticleSystemToMonitorList( particleComponent );

	}
	
	if( particleComponent != none )
	{
		particleComponent.SetScale( scale );
		particleComponent.CustomTimeDilation = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();
		particleComponent.TranslucencySortPriority = 1;
	}
	
	//Give over mesh actor for mesh particle fx
	creatureStack = H7CreatureStack(mOwner);
	if(creatureStack != none && creatureStack.GetCreature().SkeletalMeshComponent != none && creatureStack.GetCreature().SkeletalMeshComponent.SkeletalMesh != none)
	{
		particleComponent.SetActorParameter('BoneSocketActor', creatureStack.GetCreature());
	}
	
	return particleComponent;

}

function protected PlayNext()
{
	mEffectQueue.Remove(0,1);

	if( mEffectQueue.Length == 0 )
	{
		ClearFXQueue();
		return;
	}
	
	Play();
}

function protected Play( optional H7FXStruct instantEffect )
{
	local H7FXStruct effectToPlay;
	local ParticleSystemComponent partComp;
	
	if( ( instantEffect.mVFX == none && instantEffect.mMaterialFX.Length == 0 ) )
	{
		if( mEffectQueue.Length > 0 )
		{
			effectToPlay = mEffectQueue[0];
			mEffectQueue.Remove( 0, 1 );
		}
	}
	else
	{
		effectToPlay = instantEffect;
	}

	if( effectToPlay.mVFX != none )
	{
		partComp = PlayVFX( effectToPlay.mVFX, effectToPlay.mFXPosition, effectToPlay.mSocketName, effectToPlay.mScale, effectToPlay.target, effectToPlay.rotation );
		if( effectToPlay.isBeam ) 
		{
			UseBeam( partComp, effectToPlay );
		}
	}

	if(effectToPlay.mSFX != none)
	{
		PlaySFX(effectToPlay);
	}

	StartMaterialFX(effectToPlay);
	StartFXAnimations(effectToPlay);
	
	if( instantEffect.mVFX == none )
	{
		mCurrentParticleMaxLifespan = 0.f;
		mIgnoreCurrentParticle = true;
		if( partComp != none )
		{
			mIgnoreCurrentParticle = false;
			mCurrentParticleMaxLifespan = partComp.GetMaxLifespan();
		}

		mCurrentParticleSystem = partComp;
	}
}

function PlaySFX(H7FXStruct effectToPlay)
{
	local H7Unit targetUnit;
	local Actor targetDummy;

	if( class'H7SpectatorHUDCntl'.static.GetInstance().GetPopup().IsVisible() )
	{
		return;
	}

	if(effectToPlay.mSFX != none)
	{
		switch(effectToPlay.mFXPosition)
		{
			case FXP_ABOVE_TARGET:
				//AnimSpeedChanges shouldn't affect spell sfx
				if(!effectToPlay.mChangeAnimSpeed)
				{
				class'H7SoundManager'.static.PlayAkEventOnActor(mOwner, effectToPlay.mSFX, true, true, mOwner.GetTargetLocation());
				}
				else
				{
					targetDummy = mOwner.Spawn(class'H7AkEventActorDummy',,,class'H7CombatMapGridController'.static.GetInstance().GetCell(effectToPlay.target).GetLocation());
					targetDummy.PlayAkEvent(effectToPlay.mSFX,true);
					targetDummy.Detach(mOwner);
					targetDummy.Destroy();
				}

				break;
			case FXP_SOCKET:
				//AnimSpeedChanges shouldn't affect spell sfx
				if(!effectToPlay.mChangeAnimSpeed)
				{
					class'H7SoundManager'.static.PlayAkEventOnActor(mOwner, effectToPlay.mSFX, true, true, mOwner.GetTargetLocation());
				}
				else
				{
					targetDummy = mOwner.Spawn(class'H7AkEventActorDummy',,,class'H7CombatMapGridController'.static.GetInstance().GetCell(effectToPlay.target).GetLocation());
					targetDummy.PlayAkEvent(effectToPlay.mSFX,true);
					targetDummy.Detach(mOwner);
					targetDummy.Destroy();
				}

				break;
			case FXP_TARGET_POSITION:
				//AnimSpeedChanges shouldn't affect spell sfx
				if(!effectToPlay.mChangeAnimSpeed)
				{
					class'H7SoundManager'.static.PlayAkEventOnActor(mOwner, effectToPlay.mSFX, true, true, mOwner.Location);
				}
				else
				{
					targetDummy = mOwner.Spawn(class'H7AkEventActorDummy',,,class'H7CombatMapGridController'.static.GetInstance().GetCell(effectToPlay.target).GetLocation());
					targetDummy.PlayAkEvent(effectToPlay.mSFX,true);
					targetDummy.Detach(mOwner);
					targetDummy.Destroy();
				}

				break;
			case FXP_BELOW_TARGET:
				//AnimSpeedChanges shouldn't affect spell sfx
				if(!effectToPlay.mChangeAnimSpeed)
				{
					class'H7SoundManager'.static.PlayAkEventOnActor(mOwner, effectToPlay.mSFX, true, true, mOwner.Location);
				}
				else
				{
					targetDummy = mOwner.Spawn(class'H7AkEventActorDummy',,,class'H7CombatMapGridController'.static.GetInstance().GetCell(effectToPlay.target).GetLocation());
					targetDummy.PlayAkEvent(effectToPlay.mSFX,true);
					targetDummy.Detach(mOwner);
					targetDummy.Destroy();
				}

				break;
			case FXP_HIT_POSITION:

				if(class'H7CombatMapGridController'.static.GetInstance() != none)
				{
					targetUnit = class'H7CombatMapGridController'.static.GetInstance().GetCell(effectToPlay.target).GetUnit();
				}
				
				if(targetUnit != none)
				{
					targetUnit.PlayAkEvent(effectToPlay.mSFX,true);
				}
				else
				{
					targetDummy = mOwner.Spawn(class'H7AkEventActorDummy',,,class'H7CombatMapGridController'.static.GetInstance().GetCell(effectToPlay.target).GetLocation());
					targetDummy.PlayAkEvent(effectToPlay.mSFX,true);
					targetDummy.Detach(mOwner);
					targetDummy.Destroy();
				}

				break;
		}
	}
}

function protected UseBeam( ParticleSystemComponent comp, H7FXStruct fx )
{
	comp.SetBeamSourcePoint( 0, fx.source, 0 );
	comp.SetVectorParameter( 'LinkBeamEnd', fx.target );
}

event RemovePermanentFXBySource( H7EffectContainer effect )
{
	local array<H7Effect> effects;
	local H7Effect currentEffect;
	
	effects = effect.GetAllEffects();

	foreach effects( currentEffect )
	{
		RemovePermanentFXByEffect( currentEffect );
	}
}

function RemovePermanentFXByEffect( H7Effect effect )
{
	local int i;
	
	for( i = mPermanentFX.Length; i > 0; --i )
	{
		if( mPermanentFX[i-1].mSource == effect )
		{
			if( mPermanentComponents[i-1] != none )
			{
				mPermanentComponents[i-1].KillParticlesForced();
				mPermanentComponents[i-1].SetActive(false);
			}
			//Stop Event for looping permanent vfx sfx
			if(mPermanentFX[i-1].mStopSFX != none)
			{
				class'H7SoundManager'.static.PlayAkEventOnActor( mOwner,mPermanentFX[i-1].mStopSFX  );
			}
			//Removes permanent animation and move speed fx
			if( mPermanentFX[i-1].mSource.GetFx().mChangeAnimSpeed )
			{
				RemovePermanentSpeedEffect( mPermanentFX[i-1].mSource.GetFx() );
			}

			mPermanentComponents.Remove(i-1,1);

			mPermanentFX.Remove(i-1,1);
		}
	}
}

function RemovePermanentSpeedEffect(H7FXStruct effect)
{
	local H7Creature creature;

	H7CreatureStack(mOwner).ChangeLocomotionSpeed(effect);

	creature = H7CreatureStack(mOwner).GetCreature();
	creature.ChangeAnimationSpeedFX(effect);
}

function RemoveAllPermanentFX()
{
	local int i;

	for( i = mPermanentFX.Length; i > 0; --i )
	{

		if( mPermanentComponents[i-1] != none )
		{
			mPermanentComponents[i-1].KillParticlesForced();
			mPermanentComponents[i-1].SetActive(false);
		}
		mPermanentComponents.Remove(i-1,1);

		mPermanentFX.Remove(i-1,1);
	}
}

event Update()
{
	if( IsPlaying() ) { return; }
	if( mIsInCombatMap && mUnitOwner != none && mUnitOwner.IsDead() ) { ResetFX (); }
	if( mEffectQueue.Length == 0 ) { return; }

	PlayNext();
}

function protected bool IsPlaying()
{
	return ( (mCurrentParticleSystem != none && mCurrentParticleSystem.bIsActive || mIsPlayingMaterialFX ) );
}
