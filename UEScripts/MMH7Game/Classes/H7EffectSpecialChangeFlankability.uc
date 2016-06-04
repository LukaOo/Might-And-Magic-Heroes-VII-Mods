//=============================================================================
// H7EffectSpecialChangeFlankability
//
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialChangeFlankability extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);



var() protected bool mChangeFullFlanking<DisplayName=Change Full Flankability>;
var() protected bool mAllowFullFlanking<DisplayName=Allow Full Flanking against the target|EditCondition=mChangeFullFlanking>;
var() protected bool mChangeFlanking<DisplayName=Change Flankability>;
var() protected bool mAllowFlanking<DisplayName=Allow Flanking against the target|EditCondition=mChangeFlanking>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<H7IEffectTargetable> targets;
	local int i;

	if( isSimulated ) return;

	effect.GetTargets( targets );

	for( i = 0; i < targets.Length; ++i )
	{
		if( !targets[i].IsA('H7CreatureStack') ) continue;

		if( mChangeFlanking )
		{
			H7CreatureStack( targets[i] ).SetFlankability( mAllowFlanking );
		}
		if( mChangeFullFlanking )
		{
			H7CreatureStack( targets[i] ).SetFullFlankability( mAllowFullFlanking );
		}
	}
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_FLANKABILITY","H7TooltipReplacement");
}

