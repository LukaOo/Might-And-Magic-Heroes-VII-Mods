 // Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
class H7SeqCon_ArmyHasCreatures extends H7SeqCon_ArmyHas
	native;

// The Creature to be checked
var(Properties) protected archetype H7Creature mCreature<DisplayName="Creature">;
// Amount of Creatures
var(Properties) int mCreatureCounter<DisplayName="Amount of Faction Creatures"|ClampMin=0>;
// How to compare
var(Properties) ECompareOp mOper<DisplayName="Relation">;

function protected bool IsConditionFulfilledForArmy(H7AdventureArmy army)
{
	local array<H7BaseCreatureStack> stacks;
	local H7BaseCreatureStack stack;
	local int creatureCounter;
	if(mCreature == none)
	{
		return false;
	}
	else
	{
		stacks = army.GetBaseCreatureStacks();
		foreach stacks(stack)
		{
			if(stack.GetStackType() == mCreature)
			{
				creatureCounter += stack.GetStackSize();
			}
		}
	}
	return Eval(mOper, creatureCounter, mCreatureCounter);
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

