//=============================================================================
// Changing aggressiveness level for hero
//
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqAct_ChangeHeroAggressiveness extends H7SeqAct_ManipulateHeroes
	native;

var(Properties) protected EHeroAiAggressiveness mNewAggressiveness<DisplayName="New Aggressiveness Level">;

function Activated()
{
	local array<H7AdventureArmy> armies;
	local H7AdventureArmy army;

	armies = GetTargetArmies();
	foreach armies(army)
	{
		army.GetHero().SetAiAggressivness(mNewAggressiveness);
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

