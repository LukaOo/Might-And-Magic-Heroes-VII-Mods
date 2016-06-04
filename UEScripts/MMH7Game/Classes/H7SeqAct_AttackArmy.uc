/*=============================================================================
 * H7SeqAct_AttackArmy
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================*/

class H7SeqAct_AttackArmy extends H7SeqAct_LatentArmyAction
	native;

/** The army that will be attacked */
var(Properties) protected H7AdventureArmy mDefendingArmy<DisplayName="Defending Army"|EditCondition=!mUseDefendingArmy>;
/** Use the army that triggered this action */
var(Properties) protected bool mUseDefendingArmy<DisplayName="Use interacting Army as Defending Army"|EditCondition=!mUseInteractingArmy>;

event H7AdventureArmy GetDefendingArmy() 
{
	local H7AdventureArmy interactingArmy;

	if((mDefendingArmy == none || mUseDefendingArmy) && Targets.Length > 0)
	{
		interactingArmy = H7AdventureArmy(Targets[0]);
		if(interactingArmy != none)
		{
			return interactingArmy;
		}
	}

	return mDefendingArmy;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 3;
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

