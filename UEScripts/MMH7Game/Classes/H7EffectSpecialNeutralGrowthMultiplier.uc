//=============================================================================
// H7EffectSpecialNeutralGrowthMultiplier
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialNeutralGrowthMultiplier extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);

var() float   mMultiplier<DisplayName= Neutral Creature Stack Growth Multiplier (default=1.0) >;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	class'H7AdventureController'.static.GetInstance().SetNeutralGrowthMultiplier( mMultiplier );
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_NEUTRAL_STACK_GROWTH_MUL","H7TooltipReplacement");
}
