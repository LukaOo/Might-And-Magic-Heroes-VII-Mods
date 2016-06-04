//=============================================================================
// H7EffectSpecialSoulReaver
//
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialModifyManaCost extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);

var() array<H7ManaCostModifier> mManaCostModifiers<DisplayName=Mana Cost Modifiers>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	//this is a persitant effect, that is never executed, but read by other part of the code
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_MOD_MANA_COST_EFFECT","H7TooltipReplacement");
}

function string GetValue(int nr)
{
	return class'H7GameUtility'.static.FloatToString( mManaCostModifiers[0].mModifierValue , true );
}

function String GetDefaultString()
{
	return class'H7GameUtility'.static.FloatToString( mManaCostModifiers[0].mModifierValue );
}

function Texture2d GetIcon()
{
	return class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mStatIconsInText.GetStatIcon(STAT_MANA);
}
