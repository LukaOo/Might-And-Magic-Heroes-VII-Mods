//=============================================================================
// H7SeqCon_ReachLvl
//
// 
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqCon_ReachLvl extends H7SeqCon_Player
	implements(H7IConditionable)
	native;

/** Level to reach with at least one hero */
var(Properties) protected int mLvl<DisplayName="Level to reach"|ClampMin=2|ClampMax=30>;

function protected bool IsConditionFulfilledForPlayer(H7Player player)
{
	local array<H7AdventureArmy> armies;
	local H7AdventureArmy currentArmy;

	armies = class'H7AdventureController'.static.GetInstance().GetPlayerArmies( player );
	
	foreach armies( currentArmy )
	{
		if( currentArmy.GetHero().IsHero() )
		{
			if( currentArmy.GetHero().GetLevel() >= mLvl )
			{
				return true;
			}
		}
	}

	return false;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

