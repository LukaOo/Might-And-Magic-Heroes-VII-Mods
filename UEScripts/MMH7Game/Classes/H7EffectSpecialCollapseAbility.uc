//=============================================================================
// H7EffectSpecialCollapseAbility
//
// - modifies damage dealt to creature on the middle tile of "Stone Spikes"
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialCollapseAbility extends Object 
	implements(H7IEffectDelegate) 
	hidecategories(Object)
	native(Tussi);


///** Modify damage of this hero ability. Only the main target's damage will be modified (has to be a unit). */
//var(CollapseDamageModifier) H7HeroAbility mAbility <DisplayName=Ability which Damage Will Be Modified>;
/** The multiplier for the damage. */
var(CollapseDamageModifier) float mModifierValue <DisplayName=Modify Damage with this>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7CombatResult currentResult;
	local array<H7IEffectTargetable> myTargets;
	local array<H7IEffectTargetable> allTargets;
	local int i;

	if(isSimulated)
		currentResult = class'H7ReplicationInfo'.static.GetInstance().GetGameProcessor().GetMainResult();
	else
		currentResult = class'H7ReplicationInfo'.static.GetInstance().GetGameProcessor().GetCurrentResult();

	allTargets = currentResult.GetDefenders();

	// remove old targets so they won't produce any irritating tooltips
	effect.ClearCachedTargets();
	effect.GetTargets( myTargets );

	for(i=0; i<allTargets.Length; ++i)
	{
		if(myTargets.Find(allTargets[i]) != -1)
		{
			currentResult.AddMultiplier(MT_COLLAPSE, mModifierValue, i);
			currentResult.UpdateDamageRange(i);
		}
	}
}

function String GetTooltipReplacement()
{
	return class'H7Loca'.static.LocalizeSave("TTR_ADD_COUNTER","H7TooltipReplacement");
}

