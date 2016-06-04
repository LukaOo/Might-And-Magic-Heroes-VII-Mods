/*=============================================================================
 * Base class for actions that target one hero/army.
 * This class handles the hero/army selection 
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 *===========================================================================*/

class H7SeqAct_ManipulateHero extends SequenceAction
	implements(H7IAliasable, H7IActionable)
	abstract
	native;

/** Use the army that triggered this action */
var(Properties) protected bool mUseInteractingArmy<DisplayName="Use interacting army">;
/** Use a specific army */
var(Properties) protected H7AdventureArmy mTargetArmy<DisplayName="Target army"|EditCondition=!mUseInteractingArmy>;

var array<Object> mInteractingHeroObjects;

function H7AdventureArmy GetTargetArmy() 
{
	local H7AdventureArmy interactingHero;

	if((mTargetArmy == none || mUseInteractingArmy) && mInteractingHeroObjects.Length > 0)
	{
		interactingHero = H7AdventureArmy(mInteractingHeroObjects[0]);
		if(interactingHero != none)
		{
			return interactingHero;
		}
	}

	return mTargetArmy;
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

