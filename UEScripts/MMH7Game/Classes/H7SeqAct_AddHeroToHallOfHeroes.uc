class H7SeqAct_AddHeroToHallOfHeroes extends SequenceAction;

var() archetype H7EditorHero mHeroToAdd<Displayname="Hero archetype">;

event Activated()
{
	local H7Town town;
	local H7AdventureHud hud;
	if (mHeroToAdd != none)
	{
		class'H7AdventureController'.static.GetInstance().GetHallOfHeroesManager().SimulateAddNewHero(mHeroToAdd, class'H7AdventureController'.static.GetInstance().GetLocalPlayer());

		town = class'H7TownHudCntl'.static.GetInstance().GetTown();
		hud = class'H7AdventureHud'.static.GetAdventureHud();
		if (town != none && hud != none)
		{
			hud.GetTownHudCntl().GetMiddleHUD().SetupQuickBar( town );
			if(hud.GetHallOfHerosCntl().GetHallOfHerosPopup().IsVisible()) // only refresh when already open
			{
				hud.GetTownHudCntl().OpenTownPopup(POPUP_HALLOFHEROS);
			}
		}
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

