//=============================================================================
// H7EffectDuration
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectDuration extends H7Effect;

var() protected H7DurationEffect  mData;
function H7DurationEffect GetData() { return mData; }

event bool ShowInTooltip()           { return !mData.mDontShowInTooltip; }

event InitSpecific(H7DurationEffect data, H7EffectContainer source,optional bool registerEffect=true)
{
	local H7EffectProperties properties;
	properties.mRank = data.mRank;
	properties.mGroup = data.mGroup;
	properties.mTags = data.mTags;
	properties.mTarget = data.mTarget;
	properties.mTrigger = data.mTrigger;
	properties.mFX = data.mFX;
	properties.mConditions = data.mConditions;

	super.InitEffect(properties, source,registerEffect);
	mData = data;

	// In case of spell scaling we need to calculate the modifier
	if( mData.mUseSpellScaling )
		SetModifier();
}

protected function SetModifier()
{
	local H7CombatResult result;
	
	// only works with heroes 
	if( mSourceOfEffect.GetCaster().GetEntityType() != UNIT_HERO )
		return; 

	result = super.GenerateCombatAction();
	
	if( mSourceOfEffect.GetTarget() != none ) 
		result.AddDefender( mSourceOfEffect.GetTarget() );
	
	// Calculation
	class'H7ReplicationInfo'.static.GetInstance().GetGameProcessor().Calculate_EffectDuration ( result );

	mData.mDuration.MaxValue = result.GetDamageHigh();
}

// This will be called on Initialize Buff
protected event Execute(optional bool isSimulated = false)
{
	// we need simulated buff init to know it's duration

	if( mData.mConditions.mConditionAbility )
	{
		if( !CasterConditionCheck( GetSource().GetCaster() ) )
		{
			return;
		}
	}

	if( mSourceOfEffect.IsA('H7BaseBuff' ) )
	{
		H7BaseBuff(mSourceOfEffect).SetDuration( mData.mDuration.MaxValue );
		H7BaseBuff(mSourceOfEffect).SetCurrentDuration( mData.mDuration.MaxValue, false ); // don't update GUI yet, it'll be updated by the buff manager
		H7BaseBuff(mSourceOfEffect).ResetSimDuration();
	}
	else if( mSourceOfEffect.IsA('H7BaseAbility') && H7BaseAbility( mSourceOfEffect ).IsAura() )
	{
		if( GetSource().GetCaster().GetOriginal().GetAbilityManager().GetAbility( H7BaseAbility( GetSource() ) ) != GetSource() )
		{
			H7BaseAbility( mSourceOfEffect ).SetAuraDuration( mData.mDuration.MaxValue );
		}
	}

	// no fx outside of combat
	if(class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() && class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetCombatController().IsInNonCombatPhase())
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
	else if( mSourceOfEffect.GetTarget() != none )
	{
		mSourceOfEffect.GetTarget().GetEffectManager().AddToFXQueue( mData.mFX, self );
	}
}


function int GetFinalDuration(optional out String formular)
{
	if(mData.mUseSpellScaling)
	{
		if(mSourceOfEffect.GetInitiator() == none)
		{
			formular = mData.mDurationScaling.mIntercept $ "+" $ mData.mDurationScaling.mSlope $ "*Magic"; // TODO cap
		}
	}
	
	// already contains the final calculated value (if it was possible to calculate in SetModifier() during init of this class)
	return mData.mDuration.MaxValue;
}
