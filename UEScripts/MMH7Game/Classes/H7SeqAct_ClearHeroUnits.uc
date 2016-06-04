/*=========================================================================
 Clear all units from an hero/army
 Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
===========================================================================*/

class H7SeqAct_ClearHeroUnits extends H7SeqAct_ManipulateHero
	native;

function Activated()
{
	local H7AdventureArmy army;
	army = GetTargetArmy();

	if(army == none)
	{
		return;
	}
	
	army.RemoveAllCreatureStacks();	// and they are gone
	army.ClearCreatureStackProperties();
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

