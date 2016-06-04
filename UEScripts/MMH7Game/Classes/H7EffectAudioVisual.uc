//=============================================================================
// H7EffectAudioVisual
//
// - pure vfx/sfx container
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectAudioVisual extends H7Effect
	native(Tussi);

var() protected H7AudioVisualEffect mData;

function H7AudioVisualEffect GetData() { return mData; }

function bool ShowInTooltip()           { return !mData.mDontShowInTooltip; }

event InitSpecific(H7AudioVisualEffect data,H7EffectContainer source,optional bool registerEffect=true)
{
	local H7EffectProperties properties;
	properties.mRank = data.mRank;
	properties.mGroup = data.mGroup;
	properties.mTags = data.mTags;
	properties.mTarget = data.mTarget;
	properties.mTrigger = data.mTrigger;
	properties.mFX = data.mFX;
	data.mFX.mSource = self;
	properties.mConditions = data.mConditions;

	InitEffect(properties, source,registerEffect);
	mData = data;
}

protected event Execute(optional bool isSimulated = false)
{
	local array<H7IEffectTargetable> targets;
	local H7IEffectTargetable target;

	if( isSimulated ) { return; }

	// initialize all parameter from container

	if( mEffectTarget == TARGET_TARGET )
	{
		UnpackContainer();
	}


	// inform the defenders about the incoming FX (lol)
	GetTargets( targets );

	// no targets, no FX (aka "don't play dead people's caster effects")
	if( targets.Length == 0 )
	{
		return;
	}

	if( GetSource().IsAbility() && H7BaseAbility( GetSource() ).IsPassive() ) 
	{
		H7BaseAbility( GetSource() ).DoParticleFXCaster( GetSource().GetCasterOriginal() );
	}

	if( GetData().mFX.mUseCasterPosition ) 
	{
		GetSource().GetCasterOriginal().GetEffectManager().AddToFXQueue( mData.mFX, self );
	}
	else
	{
		foreach targets(target)
		{
			if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
			{
				target.GetEffectManager().AddToFXQueue( mData.mFX, self,,,class'H7CombatMapGridController'.static.GetInstance().GetCellLocation( target.GetGridPosition() ) );
			}
			else
			{
				target.GetEffectManager().AddToFXQueue( mData.mFX, self,,,class'H7AdventureGridManager'.static.GetInstance().GetCell( target.GetGridPosition().X, target.GetGridPosition().Y ).GetLocation() );
			}
		}
	}
}

function UnpackContainer( )
{
	if( GetEventContainer().Targetable != none ) 
	{
		SetUnitTargetOverwrite( GetEventContainer().Targetable );
	}
}
