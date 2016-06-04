 // Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
class H7SeqCon_ArmyHas extends H7SeqCon_TimePassed
	implements(H7IConditionable)
	abstract
	native;

// The Army to be checked
var(Properties) protected H7AdventureArmy mArmy<DisplayName="Check specific Army"|EditCondition=!mUseInteractingArmy>;
/* Use the army that triggered this condition. */
var(Properties) protected bool mUseInteractingArmy<DisplayName="Use Interacting Army">;

var protected H7AdventureArmy mInteractingArmy;

function protected bool IsConditionFulfilled()
{
	local H7AdventureArmy armyToCheckAgainst;

	armyToCheckAgainst = (mInteractingArmy != none && mUseInteractingArmy) ? mInteractingArmy : mArmy;

	if(armyToCheckAgainst == none)
	{
		return false;
	}
	else
	{	
		return IsConditionFulfilledForArmy(armyToCheckAgainst);
	}
}

function protected bool IsConditionFulfilledForArmy(H7AdventureArmy army)
{
	return false;   // Implement in extending classes
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
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

