//=============================================================================
// Changing owner of heroes/armies
//
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqAct_ChangeHeroOwner extends H7SeqAct_ManipulateHeroes
	native;

/** The new player that owns the army */
var(Properties) protected EPlayerNumber mNewOwner<DisplayName="New owner">;

function Activated()
{
	local array<H7AdventureArmy> armies;
	local H7AdventureArmy army;
	local H7Player newOwner;

	newOwner = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber(mNewOwner);
	armies = GetTargetArmies();

	foreach armies(army)
	{
		army.SetPlayer(newOwner);
		army.GetHero().SetPlayer(newOwner);
		army.ChangeFlag();
	}
	if(armies.Length > 0)
	{
		class'H7AdventureController'.static.GetInstance().UpdateHUD();
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

