//=============================================================================
// H7EffectSpecialGlobalTradeModifier
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialGlobalTradeModifier extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);

var() float   mGlobelTradeModifier <DisplayName=Global Trade Modifier>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{

	class'H7AdventureController'.static.GetInstance().SetGlobalTradeModifier( mGlobelTradeModifier );
}
	
function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_GLOBAL_TRADE_MOD","H7TooltipReplacement");
}
