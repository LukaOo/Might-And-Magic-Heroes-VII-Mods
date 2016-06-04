//=============================================================================
// H7EffectSpecialProvideCover
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialProvideCover extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);

var( Cover ) bool mSetCoverValue<DisplayName=Set if target will have cover>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<H7IEffectTargetable> targets;
	local H7IEffectTargetable target;
	local H7CreatureStack stack;

	if( isSimulated ) { return; }

	effect.GetTargets( targets );

	foreach targets( target )
	{
		stack = H7CreatureStack( target );
		if( stack != none )
		{
			stack.SetHasCoverFromEffects( mSetCoverValue );
		}
	}
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_PROVIDE_COVER","H7TooltipReplacement");
}
