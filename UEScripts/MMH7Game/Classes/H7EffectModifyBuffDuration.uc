//=============================================================================
// H7EffectModifyBuffDuration
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectModifyBuffDuration extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);

/** Adds this value on buff initialization (for later duration modification, use H7EffectSpecialBuffDurationModifier). */
var(ModifyBuffDuration) int mDurationModifierValue<DisplayName=Add Value To Duration>;

var bool mHasNoBuffs;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7BaseBuff buff;
	local array<H7IEffectTargetable> targets;

	if( isSimulated ) return;
	
	;
	// only with this trigger 
	if( effect.GetTrigger().mTriggerType == ON_ADD_BUFF ) // TODO what is this special case
		effect.GetSource().SetTarget( container.Targetable );
	
	effect.GetTargets( targets );

	// condition check / valid targets ?
	if( targets.Length <= 0 ) 
		return; 

	// get instance out of the container
	if( container.EffectContainer.IsBuff() )
	{
		buff = H7Basebuff( container.EffectContainer );
		buff.SetCurrentDuration( buff.GetCurrentDuration()  +  mDurationModifierValue );
	}
	else
	{
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("Tried to modify duration of a non-Buff object! Not good!",MD_QA_LOG);;
	}
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_BUFF_DURATION","H7TooltipReplacement");
}

function String GetDefaultString()
{
	return class'H7GameUtility'.static.FloatToString( mDurationModifierValue , true );
}
