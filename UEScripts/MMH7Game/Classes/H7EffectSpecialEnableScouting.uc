//=============================================================================
// H7EffectSpecialEnableScouting
//
// Enable scouting for an adventure hero.
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialEnableScouting extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);


function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<H7IEffectTargetable> targets;
	local H7IEffectTargetable target;

	effect.GetTargets( targets );

	foreach targets(target)
	{
		if(H7AdventureHero(target) != none)
		{
			H7AdventureHero(target).SetCanScout(true);
		}
	}
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_SCOUT","H7TooltipReplacement");
}
