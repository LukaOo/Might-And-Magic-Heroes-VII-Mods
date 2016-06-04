//=============================================================================
// H7EffectSpecialCapStat
//
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialCapStat extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);

var() bool mCapOrFloor<DisplayName="True - Cap, False - Floor">;
var() float mCap<DisplayName="Cap Value (for Creature power relation calculation)">;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	//this is a persitant effect, that is never executed, but read by other part of the code
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_MOD_POWER","H7TooltipReplacement");
}

function string GetValue(int nr)
{
	return class'H7GameUtility'.static.FloatToString( mCap , true );
}

function String GetDefaultString()
{
	return class'H7GameUtility'.static.FloatToString( mCap );
}

function Texture2d GetIcon()
{
	return class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mStatIconsInText.GetStatIcon(STAT_ATTACK);
}
