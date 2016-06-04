//=============================================================================
// H7EffectSpecialModifyTerrainMovementCost
//
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialModifyTerrainMovementCost extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);

var() array<H7TerrainCostModifier> mMovementCostModifiers<DisplayName=Movement Cost Modifiers>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_MOD_MOVE_COST","H7TooltipReplacement");
}
