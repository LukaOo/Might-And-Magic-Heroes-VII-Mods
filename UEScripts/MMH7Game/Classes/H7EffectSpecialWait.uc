//=============================================================================
// H7EffectSpecialWait
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialWait  extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);


function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7ICaster caster; 
	caster = effect.GetSource().GetCaster().GetOriginal();

	class'H7CombatController'.static.GetInstance().GetInitiativeQueue().Waited(  H7Unit( caster ) );
}


function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_WAIT","H7TooltipReplacement");
}
