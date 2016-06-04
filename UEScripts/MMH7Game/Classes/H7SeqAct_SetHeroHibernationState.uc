//=============================================================================
// Changing hibernation mode for hero
//
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqAct_SetHeroHibernationState extends H7SeqAct_ManipulateHeroes
	native;

var(Properties) protected bool mNewHibernationState<DisplayName="New Hibernation State">;

function Activated()
{
	local array<H7AdventureArmy> armies;
	local H7AdventureArmy army;

	armies = GetTargetArmies();
	foreach armies(army)
	{
		army.GetHero().SetAiHibernationState(mNewHibernationState);
	}
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

