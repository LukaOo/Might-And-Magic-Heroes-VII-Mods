//=============================================================================
// H7SeqCon_HeroDefeated
//
// 
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqCon_HeroDefeated extends H7SeqCon_Player
	implements(H7IHeroReplaceable, H7IConditionable)
	native;

/** Hero that should be defeated */
var (Properties) H7EditorHero mHero<DisplayName="Hero to defeat">;

var protected H7AdventureArmy mHeroArmy;
var private savegame H7AdventureArmy mArmyToCheck;

function protected bool IsConditionFulfilledForPlayer(H7Player player)
{
	local array<H7AdventureArmy> armies;
	local H7AdventureArmy army;

	//init mHeroToCheck
	if (mArmyToCheck == none)
	{
		if (mHeroArmy == none)
		{
			armies = class'H7AdventureController'.static.GetInstance().GetArmies();
			foreach armies(army)
			{
				if (army.GetHeroTemplateSource() == mHero)
				{
					mArmyToCheck = army;
					break;
				}
			}
		}
		else
		{
			mArmyToCheck = mHeroArmy;
		}
	}
	return mArmyToCheck.IsDead();
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 4;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

