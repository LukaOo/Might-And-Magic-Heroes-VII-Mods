//=============================================================================
// H7EffectLuck
//
// 
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7EffectLuck extends Object 
	implements(H7IEffectDelegate)
	hidecategories( Object )
	native(Tussi);

/** Good luck will modify to max damage, bad luck will modify to min damage */
var( Luck ) bool mGoodLuck<DisplayName=Is Good Luck?>;
var( Luck ) float mModifierValue<DisplayName=Damage Modifier>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7RangeValue range;
	local H7EffectDamage dmgEffect;
	local int i, defenderCount;

	if( isSimulated || container.Result == none ) return;

	defenderCount = container.Result.GetDefenderCount();

	for( i = 0; i < defenderCount; ++i )
	{
		range = container.Result.GetBaseDamageRange();
		dmgEffect = H7EffectDamage( container.Result.GetCurrentEffect() );
		if( dmgEffect != none && dmgEffect.GetData().mUseSpellScaling )
		{
			class'H7GameProcessor'.static.SpellScalingDamage( container.Result, i );
			range.MinValue = container.Result.GetDamageLow(i);
			range.MaxValue = container.Result.GetDamageHigh(i);
		}

		if( mGoodLuck )
		{
			range.MaxValue = range.MaxValue * mModifierValue;
			range.MinValue = range.MaxValue;
		}
		else
		{
			range.MinValue = range.MinValue * mModifierValue;
			range.MaxValue = range.MinValue;
		}
		
		container.Result.SetIsConstDamagerRange(true,i);
	}

	container.Result.SetBaseDamageRange( range );
	container.Result.UpdateDamageRange();
}

function String GetTooltipReplacement() 
{ 
	return class'H7Loca'.static.LocalizeSave("TTR_LUCKY","H7TooltipReplacement");
}

function String GetDefaultString()
{
	return class'H7Effect'.static.GetHumanReadablePercentAbs(mModifierValue);
}
