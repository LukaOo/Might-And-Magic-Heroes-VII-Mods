//=============================================================================
// Removing heroes/armies
//
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqAct_RemoveHero extends H7SeqAct_ManipulateHeroes
	native;

function Activated()
{
	local array<H7AdventureArmy> armies;
	local H7AdventureArmy army;
	local H7CampaignTransitionManager campTransManager;
	local H7AdventureController advController;

	if(class'H7PlayerProfile'.static.GetInstance() != none)
	{
		campTransManager = class'H7PlayerProfile'.static.GetInstance().GetCampTransManager();
	}

	advController = class'H7AdventureController'.static.GetInstance();

	armies = GetTargetArmies();

	foreach armies(army)
	{
		if(advController != none)
		{
			if(campTransManager != none )
			{
				if( army.GetHero().GetSaveProgress() )
				{
					campTransManager.StoreHero( army.GetHero() );
				}
			}

			advController.RemoveArmy(army);
		}
		
	}
	if(armies.Length > 0)
	{
		advController.UpdateHUD();
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

