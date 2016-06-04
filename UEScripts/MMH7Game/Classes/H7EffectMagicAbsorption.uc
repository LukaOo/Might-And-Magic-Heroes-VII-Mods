//=============================================================================
// H7EffectMagicAbsorption
//
// 
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7EffectMagicAbsorption extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<H7IEffectTargetable> targets;
	local H7IEffectTargetable target;
	if( isSimulated ) return;

	if( effect == none || isSimulated ) return;

	effect.GetTargets( targets );

	foreach targets( target )
	{
		if( H7Unit( target ) != none )
		{
			H7Unit( target ).IncreaseBaseStatByID( STAT_MAGIC_ABS, container.Result.GetDamage() );
		}
	}
}

function String GetTooltipReplacement() 
{
	local string ttMessage;
	ttMessage = class'H7Loca'.static.LocalizeSave("TTR_CHARGES","H7TooltipReplacement");

	return ttMessage;
}
