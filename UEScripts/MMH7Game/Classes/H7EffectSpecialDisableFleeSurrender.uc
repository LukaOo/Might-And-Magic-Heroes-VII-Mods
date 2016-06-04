//=============================================================================
// H7EffectSpecialSoulReaver
//
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialDisableFleeSurrender extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	//this is a persitant effect, that is never executed, but read by other part of the code
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_DISABLE_FLEE_SURRENDER","H7TooltipReplacement");
}
