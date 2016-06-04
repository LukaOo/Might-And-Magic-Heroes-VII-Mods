//=============================================================================
// H7EffectDurationModifier
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectDurationModifier extends H7Effect
	native(Tussi);

var() protected H7DurationModifierEffect    mData;
var protected int                         mModifierValue;
var protected EOperationType              mOperatorType;

function H7DurationModifierEffect GetData() { return mData; }

event bool ShowInTooltip()           { return !mData.mDontShowInTooltip; }

event InitSpecific(H7DurationModifierEffect data, H7EffectContainer source, optional bool registerEffect=true)
{
	local H7EffectProperties properties;
	properties.mRank = data.mRank;
	properties.mGroup = data.mGroup;
	properties.mTags = data.mTags;
	properties.mTarget = data.mTarget;
	properties.mTrigger = data.mTrigger;
	properties.mFX = data.mFX;
	properties.mConditions = data.mConditions;

	
	InitEffect(properties, source, registerEffect);
	
	mData = data;
	mModifierValue = mData.mModifierValue;
	mOperatorType = mData.mCombineOperation;
}

protected event Execute(optional bool isSimulated = false)
{
	local int  buffDuration;
	local H7BaseBuff buff;
	local H7BaseAbility ability;
	local H7IEffectTargetable target;
	local array<H7IEffectTargetable> targets;
	local H7ICaster owner; 

	if( mEffectTarget == TARGET_TARGET )
	{
		UnpackContainer();
	}

	;
	if( mSourceOfEffect.IsA('H7BaseBuff') )
	{
		buff = H7BaseBuff( mSourceOfEffect );
		buffDuration = isSimulated ? buff.GetSimulatedDuration() : buff.GetCurrentDuration();
		;
		
		GetTargetsByEffectTarget( targets, mEffectTarget );
		if( targets.Length > 0 )    { 	target = targets[0]; 		}
		else 		                {	target = buff.GetTarget();	}

		if( ConditionCheck( target, buff.GetInitiator(), false ) )
		{
			buffDuration = int( mSourceOfEffect.DoOperation( mOperatorType, buffDuration, mModifierValue ) );
			isSimulated ? buff.AddSimulatedDuration( self, buffDuration ) : buff.SetCurrentDuration( buffDuration, buffDuration > 0 ); // don't update GUI yet if buff gets removed; remove buff will do that for us
			
			if( mSourceOfEffect.GetSkillType() == SKT_BATTLERAGE )
			{
				owner =  mSourceOfEffect.GetOwner().GetOriginal();
				target =  H7Unit( owner );
			}

			if( buff.GetCurrentDuration() <= 0 && !isSimulated )
			{
				target.GetBuffManager().RemoveBuff( buff, mSourceOfEffect.GetInitiator() );
				mRemovedDuringExecution = true;
				target.DataChanged("OnBeginTurn");
			}
		}
	}
	else if( mSourceOfEffect.IsA('H7BaseAbility') && H7BaseAbility( mSourceOfEffect ).IsAura() )
	{
		if( GetSource().GetCaster().GetOriginal().GetAbilityManager().GetAbility( H7BaseAbility( GetSource() ) ) != GetSource() )
		{
			ability = H7BaseAbility( mSourceOfEffect );

			buffDuration = ability.GetAuraDuration();
			;
			buffDuration = int( mSourceOfEffect.DoOperation( mOperatorType, buffDuration, mModifierValue ) );
			ability.SetAuraDuration( buffDuration );
		

			if( ability.GetAuraDuration() <= 0 )
			{
				if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
				{
					class'H7CombatMapGridController'.static.GetInstance().GetAuraManager().RemoveAuraFromSource( GetSource() );
				}
				else
				{
					class'H7AdventureGridManager'.static.GetInstance().GetCurrentGrid().GetAuraManager().RemoveAuraFromSource( GetSource() );
				}
				mRemovedDuringExecution = true;
			}
		}
	}

	if( isSimulated ) return;

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
