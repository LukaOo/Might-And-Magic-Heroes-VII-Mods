 // Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
class H7SeqCon_ArmyHasCreaturesFromFaction extends H7SeqCon_ArmyHas
	native;

// The Faction to be checked
var(Properties) protected archetype H7Faction mFaction<DisplayName="Faction">;
// Amount of Faction Creatures
var(Properties) int mCreatureCounter<DisplayName="Amount of Faction Creatures"|ClampMin=0>;
// How to compare
var(Properties) ECompareOp mOper<DisplayName="Relation">;

function protected bool IsConditionFulfilledForArmy(H7AdventureArmy army)
{
	local array<H7BaseCreatureStack> stacks;
	local H7BaseCreatureStack stack;
	local int factionCounter;
	if(mFaction == none)
	{
		return false;
	}
	else
	{
		stacks = army.GetBaseCreatureStacks();
		foreach stacks(stack)
		{
			if(stack.GetStackType() != none && stack.GetStackType().GetFaction() == mFaction)
			{
				factionCounter += stack.GetStackSize();
			}
		}
	}
	return Eval(mOper, factionCounter, mCreatureCounter);
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

