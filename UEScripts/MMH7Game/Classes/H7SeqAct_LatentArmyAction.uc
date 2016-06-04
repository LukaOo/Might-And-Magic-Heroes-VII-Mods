/*=============================================================================
 * H7SeqAct_LatentArmyAction
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================*/

class H7SeqAct_LatentArmyAction extends SeqAct_AIMoveToActor
	implements(H7IAliasable, H7IActionable)
	abstract
	native;

/** Use a specific army */
/** The army that performs the action */
var(Properties) private H7AdventureArmy mArmy<DisplayName="Army"|EditCondition=!mUseInteractingArmy>;
/** Use the army that triggered this action */
var(Properties) protected bool mUseInteractingArmy<DisplayName="Use Interacting Army"|EditCondition=mEditmUseInteractingArmy>;

var private transient bool mEditmUseInteractingArmy;

var array<Object> mInteractingArmyObjects;

event H7AdventureArmy GetTargetArmy() 
{
	local H7AdventureArmy interactingArmy;

	if((mArmy == none || mUseInteractingArmy) && Targets.Length > 0)
	{
		interactingArmy = H7AdventureArmy(Targets[0]);
		if(interactingArmy != none)
		{
			return interactingArmy;
		}
	}

	return mArmy;
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
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

