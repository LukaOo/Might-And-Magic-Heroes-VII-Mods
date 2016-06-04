//=============================================================================
// H7EffectSpecialDecreaseRecruitingCosts
//
// - decrease recruiting costs by X percent
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialDecreaseRecruitingCosts extends Object 
	implements(H7IEffectDelegate) 
	hidecategories(Object)
	native(Tussi);

/** Reduces the costs of units by X percent in the targeted town(s). This reduces gold/currency costs only! */
var(DecreaseCosts) int mPercentage<DisplayName=Recruiting Cost Reduction (percent)|ClampMin=0|ClampMax=100>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<H7IEffectTargetable> targets;
	local H7IEffectTargetable target;
	local H7Town town;

	effect.GetTargets( targets );

	if(targets.Length == 0) { return; }

	foreach targets(target)
	{
		town = H7Town(target);

		if(town == none) { continue; }

		town.SetRecruitmentCostModifier(mPercentage * 0.01f);
	}
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_DECREASE_RECRUIT_COST","H7TooltipReplacement");
}

function String GetDefaultString()
{
	return String(mPercentage);
}

