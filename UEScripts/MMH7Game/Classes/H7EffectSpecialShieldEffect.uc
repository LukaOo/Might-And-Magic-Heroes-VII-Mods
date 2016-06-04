//=============================================================================
// H7EffectSpeciaCelestialAmor
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialShieldEffect extends Object implements(H7IEffectDelegate)
	native(Tussi);



var() H7SpellScaling                mMinShieldValue                      <DisplayName="Minimum Shield Value">;
var() H7SpellScaling                mMaxShieldValue                      <DisplayName="Maximum Shield Value">;
var() bool                          mMultiplyByMetamagic                 <DisplayName="Multiply by Metamagic">;

var int mShieldValue;
var H7Effect mEffect;

function Initialize( H7Effect effect ) 
{
	mEffect = effect;
}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local int magic,min,max; 
	local float randomFloat;
	local H7ICaster caster;
	
	mEffect = effect;
	caster = effect.GetSource().GetCasterOriginal();
	magic = caster.GetMagic();
    min = mMinShieldValue.mIntercept + mMinShieldValue.mSlope * magic;
    max = mMaxShieldValue.mIntercept + mMaxShieldValue.mSlope * magic;

	if( mMinShieldValue.mUseCap )
	{
		min = FMax( mMinShieldValue.mMinCap, FMin( min, mMinShieldValue.mMaxCap ) );
	}

	if( mMaxShieldValue.mUseCap )
	{
		max = FMax( mMaxShieldValue.mMinCap, FMin( max, mMaxShieldValue.mMaxCap ) );
	}

	randomFloat = isSimulated ? FRand() : class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomFloat();

	mShieldValue = Lerp( min, max, randomFloat );
	if( mMultiplyByMetamagic && H7EditorHero( caster ) != none )
	{
		mShieldValue *= H7EditorHero( caster ).GetMetamagic();
	}
	mEffect = none;
}

function H7RangeValue GetFinalDamageRange()
{
	local int magic,min,max;
	local H7RangeValue rangeValue;

	if(mEffect != none && mEffect.GetSource() != none && mEffect.GetSource().GetCasterOriginal() != none)
	{
		magic = mEffect.GetSource().GetCasterOriginal().GetMagic();

		min = mMinShieldValue.mIntercept + mMinShieldValue.mSlope * magic;
		max = mMaxShieldValue.mIntercept + mMaxShieldValue.mSlope * magic;

		if( mMinShieldValue.mUseCap )
		{
			min = FMax( mMinShieldValue.mMinCap, FMin( min, mMinShieldValue.mMaxCap ) );
		}

		if( mMaxShieldValue.mUseCap )
		{
			max = FMax( mMaxShieldValue.mMinCap, FMin( max, mMaxShieldValue.mMaxCap ) );
		}
		
		rangeValue.MaxValue = max;
		rangeValue.MinValue = min;
	}
	else
	{
		// OPTIONAL formulars
	}

	return rangeValue;
}

function ApplyShield( out H7CombatResult result, int resultIdx, bool isForecast )
{
	local int IncommingDamage;
    local H7IEffectTargetable target;
	local float absorbedAmount;
	local string msg; 

	if( isForecast) 
		return;

	IncommingDamage = result.GetDamage( resultIdx );
	target = mEffect.GetSource().GetTarget();
	absorbedAmount = FMax( IncommingDamage , mShieldValue );

	class'H7MessageSystem'.static.GetInstance().AddReplForNextMessage("%name",mEffect.GetSource().GetOwner().GetName());
	class'H7MessageSystem'.static.GetInstance().AddReplForNextMessage("%absorb",class'H7GameUtility'.static.FloatToString(absorbedAmount));
	class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("MSG_ABSORB",MD_LOG);

	if( mShieldValue <= IncommingDamage ) // shows deducted shield points and collapses shield
	{
		result.SetDamage( FMax( IncommingDamage - mShieldValue, 0 ), resultIdx );
		msg = string(mShieldValue);
		class'H7FCTController'.static.GetInstance().StartFCT(FCT_TEXT, H7CreatureStack( target).GetFloatingTextLocation(), none, msg,, mEffect.GetSource().GetIcon());
		
		mShieldValue = 0;
		
		if( mEffect.GetSource().IsBuff() )
		{
			target.GetBuffManager().RemoveBuff( H7BaseBuff( mEffect.GetSource() ) );
		}
	}
	else // shows deducted shield points
	{
		msg = class'H7GameUtility'.static.FloatToString( IncommingDamage );
		result.SetDamage( FMax( IncommingDamage - mShieldValue, 0 ) , resultIdx );
		class'H7FCTController'.static.GetInstance().StartFCT(FCT_TEXT, H7CreatureStack( target).GetFloatingTextLocation(), none, msg,, mEffect.GetSource().GetIcon());
		
		mShieldValue = mShieldValue - IncommingDamage ;	
	}
}

function string GetValue(int nr)
{
	local int magic,min,max; 
	magic = mEffect.GetSource().GetCasterOriginal().GetMagic();
	if(nr == 1)
	{
		min = mMinShieldValue.mIntercept + mMinShieldValue.mSlope * magic;
		if( mMinShieldValue.mUseCap )
		{
			min = FMax( mMinShieldValue.mMinCap, FMin( min, mMinShieldValue.mMaxCap ) );
		}
		return class'H7GameUtility'.static.FloatToString(min);
	}
	else if(nr == 2)
	{
		max = mMaxShieldValue.mIntercept + mMaxShieldValue.mSlope * magic;
		if( mMaxShieldValue.mUseCap )
		{
			max = FMax( mMaxShieldValue.mMinCap, FMin( max, mMaxShieldValue.mMaxCap ) );
		}
		return class'H7GameUtility'.static.FloatToString(max);
	}
	else if(nr == 3)
	{
		return class'H7GameUtility'.static.FloatToString(mShieldValue);
	}
	else
	{
		return "?";
	}
}

function String GetDefaultString()
{
	local int magic,min,max; 

	if(mShieldValue == 0)
	{
		magic = mEffect.GetSource().GetCasterOriginal().GetMagic();
		min = mMinShieldValue.mIntercept + mMinShieldValue.mSlope * magic;
		max = mMaxShieldValue.mIntercept + mMaxShieldValue.mSlope * magic;

		if( mMinShieldValue.mUseCap )
		{
			min = FMax( mMinShieldValue.mMinCap, FMin( min, mMinShieldValue.mMaxCap ) );
		}

		if( mMaxShieldValue.mUseCap )
		{
			max = FMax( mMaxShieldValue.mMinCap, FMin( max, mMaxShieldValue.mMaxCap ) );
		}

		return min $ "-" $ max;
	}
	else
	{
		return class'H7GameUtility'.static.FloatToString(mShieldValue);
	}
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_SHIELD","H7TooltipReplacement");
}

