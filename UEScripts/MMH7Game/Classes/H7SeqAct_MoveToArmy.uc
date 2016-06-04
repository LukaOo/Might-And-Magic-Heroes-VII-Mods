/*=============================================================================
 * H7SeqAct_MoveToArmy
 * 
 * Move action that targets an army.
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ===========================================================================*/

class H7SeqAct_MoveToArmy extends H7SeqAct_MoveTo
	native;

/** The army to move to */
var(Properties) protected H7AdventureArmy mMoveTarget<DisplayName="Move Target Army"|EditCondition=!mUseInteractingMoveTarget>;
/** Use the army that triggered this action */
var(Properties) protected bool mUseInteractingMoveTarget<DisplayName="Use Interacting Army as Move Target Army"|EditCondition=!mUseInteractingArmy>;

function bool IsMovingNearTarget() { return true; }

function H7AdventureMapCell GetTargetCell()
{
	local H7AdventureArmy interactingArmy;

	if((mMoveTarget == none || mUseInteractingMoveTarget) && Targets.Length > 0)
	{
		interactingArmy = H7AdventureArmy(Targets[0]);
		if(interactingArmy != none)
		{
			return interactingArmy.GetCell();
		}
	}

	return mMoveTarget.GetCell();
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

