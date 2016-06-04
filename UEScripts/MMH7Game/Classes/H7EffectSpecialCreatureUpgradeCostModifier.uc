//=============================================================================
// H7EffectSpecialCreatureUpgradeCostModifier
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialCreatureUpgradeCostModifier extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);


var() bool    mHasCreatureUpradeCostModifier <DisplayName= Set Creature Upgrade Cost>; 
var() float   mCreatureUpradeCostModifier <DisplayName=Creature Upgrade Cost Modifier>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	class'H7AdventureController'.static.GetInstance().SetHasUpgradeCostWeekEffect( mHasCreatureUpradeCostModifier );
	class'H7AdventureController'.static.GetInstance().SetUpgradeCostWeekEffect( mCreatureUpradeCostModifier );
}
	
function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_CREATURE_UPGR_COST_MOD","H7TooltipReplacement");
}
