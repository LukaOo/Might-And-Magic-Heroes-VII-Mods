//=============================================================================
// H7EffectSpecialIncreaseBuildingAmountPerDay
//
// - increase amount of buildings a player can build in one day
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialIncreaseBuildingAmountPerDay extends Object 
	implements(H7IEffectDelegate) 
	hidecategories(Object)
	native(Tussi);

/** Sets (NOT adds) the amount of buildings the player can build int the targeted town(s) per day. */
var(BuildAmount) protected int mAmount <DisplayName=Amount of Buildings the Player can Build in One Day>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<H7IEffectTargetable> targets;
	local H7IEffectTargetable target;
	local H7Town town;

	effect.GetTargets( targets );
	foreach targets(target)
	{
		town = H7Town(target);

		if(town == none) { continue; }

		town.SetMaxBuildingsPerDay(mAmount);
	}
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_INCREASE_BUILDING","H7TooltipReplacement");
}
