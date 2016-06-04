class H7HeropediaCntl extends H7FlashMoviePopupCntl
	dependson(H7StructsAndEnumsNative);

var protected H7GFxHeropedia mHeropedia;
var protected array<H7EditorHero> heroes;
var protected array<H7Creature> mActualCreatureArray;
var protected array<H7GeneralLoreEntry> mGeneralLore;
var protected array<H7EditorWarUnit> mWarUnits;

var protected H7FlashMoviePopupCntl mPreviousContext;

static function H7HeropediaCntl GetInstance() { return class'H7PlayerController'.static.GetPlayerController().GetHUD().GetHeropedia(); }

function    H7GFxUIContainer    GetPopup(){ return mHeropedia; }

function bool Initialize()
{
	local array<H7FactionCreatureData> lists;
	local H7FactionCreatureData list;
	local int i, j;
	local array<H7EditorHero> skirmishHeroes;

	;
	Super.Start();

	AdvanceDebug(0);

	mHeropedia = H7GFxHeropedia(mRootMC.GetObject("aHeropedia", class'H7GFxHeropedia'));
	mFullscreen = true;
	mBlockFlash = true;
	mBlockUnreal = true;

	//mCloseButton = GFxCLIKWidget(mHeroWindow.GetObject("mCloseButton", class'GFxCLIKWidget'));

	mHeropedia.SetVisibleSave(false);
	
	class'H7GameData'.static.GetInstance().GetHeroes(heroes, true);
	class'H7GameData'.static.GetInstance().GetHeropediaHeroes(heroes);
	if(!class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap())
		class'H7GameData'.static.GetInstance().GetExclusiveHeroesSkirmish(skirmishHeroes, true);
	
	for(i = 0; i < skirmishHeroes.Length; i++)
	{
		heroes.AddItem(skirmishHeroes[i]);
	}

	i = 0;
	class'H7GameData'.static.GetInstance().GetCreatureLists(lists);
	ForEach lists(list)
	{
		for(j = 0; j < E_H7_CL_MAX; j++)
		{
			for(i = 0; i < list.CreatureList.Creatures[j].Creatures.Length; i++)
			{
				mActualCreatureArray.AddItem( list.CreatureList.Creatures[j].Creatures[i] );
			}
		}
	}

	mGeneralLore = class'H7GameData'.static.GetInstance().GetGeneralLore();
	mWarUnits = class'H7GameData'.static.GetInstance().GetWarfareUnits();

	Super.Initialize();

	mHeropedia.SetListItemsHeroes(heroes);
	mHeropedia.SetListItemsCreatures(mActualCreatureArray);
	mHeropedia.SetListItemsLore(mGeneralLore);
	mHeropedia.SetListItemsWarUnits(mWarUnits);

	AddMapSpecificHeroes();
	AddMapSpecificCreatures();
	
	return true;
}

function AddMapSpecificHeroes()
{
	local H7EditorHero customHero;
	
	local array<H7EditorHero> customHeroes, customHeroesToAddToHeropedia;

	customHeroes = H7MapInfo(class'WorldInfo'.static.GetWorldInfo().GetVanillaMapInfo()).GetCustomHeroes();

	foreach customHeroes(customHero)
	{
		if(customHero.GetSourceArchetype() != none && heroes.Find(customHero.GetSourceArchetype()) != -1)
			continue;

		if( heroes.Find(customHero) == -1)
		{
			;
			heroes.AddItem(customHero);
			customHeroesToAddToHeropedia.AddItem(customHero);
		}
	}	

	mHeropedia.AddMapSpecificHeroes(customHeroesToAddToHeropedia);

	;

}

function AddMapSpecificCreatures()
{
	local H7Creature customCreature;
	
	local array<H7Creature> customCreatures, customCreaturesToAddToHeropedia;

	customCreatures = H7MapInfo(class'WorldInfo'.static.GetWorldInfo().GetVanillaMapInfo()).GetCustomCreatures();

	foreach customCreatures(customCreature)
	{
		if(mActualCreatureArray.Find(customCreature) != -1)
			continue;
		
		if( mActualCreatureArray.Find(customCreature) == -1)
		{
			;
			mActualCreatureArray.AddItem(customCreature);
			customCreaturesToAddToHeropedia.AddItem(customCreature);
		}
	}
	
	mHeropedia.AddMapSpecificCreatures(customCreaturesToAddToHeropedia);

	;

}

function UpdateTest()
{
	local H7Hud hud;

;
	hud = GetHUD();
	if(hud.IsA('H7AdventureHud'))
	{
		H7AdventureHud(GetHUD()).GetAdventureHudCntl().GetTopBar().SetVisibleSave(false);
		mPreviousContext = GetHUD().GetCurrentContext();
	}
	if(hud.IsA('H7MainMenuHud'))
	{
	   if( class'H7CouncilManager'.static.GetInstance().GetCouncilState() != CS_MainMenu )
		return;
	}
	mHeropedia.UpdateHeroTest();
	OpenPopup();
}

function OpenHeropedia()
{
	OpenWithHero(heroes[0].GetArchetypeID());
}

function OpenWithHero(string archetypeID)
{
	local H7Hud hud;

	;
	hud = GetHUD();
	if(hud.IsA('H7AdventureHud'))
	{
		H7AdventureHud(GetHUD()).GetAdventureHudCntl().GetTopBar().SetVisibleSave(false);
		mPreviousContext = GetHUD().GetCurrentContext();
	}
	if(hud.IsA('H7MainMenuHud'))
	{
	   if( class'H7CouncilManager'.static.GetInstance() != none &&
	   	   class'H7CouncilManager'.static.GetInstance().GetCouncilState() != CS_MainMenu ) // TODOD this does not work anymore with council changes
		return;
	}
	GetHeroData(archetypeID);
	OpenPopup();
}

function OpenWithCreature(string stringID)
{
	local H7Hud hud;

;
	hud = GetHUD();
	if(hud.IsA('H7AdventureHud'))
	{
		H7AdventureHud(GetHUD()).GetAdventureHudCntl().GetTopBar().SetVisibleSave(false);
		mPreviousContext = GetHUD().GetCurrentContext();
	}
	if(hud.IsA('H7MainMenuHud'))
	{
	  if( class'H7CouncilManager'.static.GetInstance() != none &&
	   	  class'H7CouncilManager'.static.GetInstance().GetCouncilState() != CS_MainMenu )
		return;
	}
	GetCreatureData(stringID);
	OpenPopup();
}

function bool OpenPopup()
{
	mHeropedia.SetVisibleSave(true);

	SetPriority(75); // needs to be over lobby (50)

	StartAdvance();
		
	GetHUD().SetFocusMovie(self);
	GetPopup().PlayOpenAnimationNextFrame();

	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("CLICK_SPELL_BOOK_BUTTON");

	if(IsFullscreen())
	{
		GetHUD().GetSpellbookCntl().GetQuickBar().SetVisibleSave(false);
		GetHUD().GetLogCntl().GetLog().SetVisibleSave(false);
		GetHUD().GetLogCntl().GetBorderBlack().SetVisibleSave(true);
		GetHUD().GetLogCntl().GetQALog().SetVisibleSave(false);
		if(!H7Adventurehud(GetHUD()).GetTownHudCntl().IsInAnyScreen())
		{
			H7Adventurehud(GetHUD()).GetAdventureHudCntl().GetTownList().SetVisibleSave(false);
		}
			
		//multiplayer gui
		if(class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() || class'H7AdventureController'.static.GetInstance().IsHotSeat())
		{
			class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetMPTurnInfo().SwitchToFullScreen();
		}
	}

	if(class'H7ReplicationInfo'.static.GetInstance().IsCombatMap())
	{
		H7CombatHud( GetHUD() ).GetCombatHudCntl().SetCombatHudCntlVisible(false);
	}

	// hide player buffs
	class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetPlayerBuffs().SetVisibleSave(false);
	
	GetHud().BlockFlashBelow(self);
	GetHud().BlockUnreal();
	class'H7PlayerController'.static.GetPlayerController().GetHud().GetGUIOverlaySystemCntl().GetSideBar().SetVisibleSave(false);
	class'H7AdventureHudCntl'.static.GetInstance().GetNoteBar().SetVisibleSave(false);

	if(class'H7AdventureHudCntl'.static.GetInstance() != none)
	{
		class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().SetPopupMode(true);
	}

	return true;
}

function GetHeroData(string archetypeID)
{
	local int i;
	;
	for(i = 0; i < heroes.Length; i++)
	{
		if(heroes[i].GetArchetypeID() == archetypeID)
		{
			class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("SPELLBOOK_TURN_PAGE_DOWN");
			mHeropedia.OpenHeroPage(heroes[i]);
			return;
		}
	}

	;
}

function GetCreatureData(string idString)
{
	local H7Creature creature;
	local H7EditorWarUnit warUnit;

	ForEach mActualCreatureArray(creature)
	{
		if(creature.GetIDString() == idString)
		{
			class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("SPELLBOOK_TURN_PAGE_UP");
			mHeropedia.OpenCreaturePage(creature);
			return;
		}
	}

	ForEach mWarUnits(warUnit)
	{
		if(warUnit.GetIDString() == idString)
		{
			class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("SPELLBOOK_TURN_PAGE_DOWN");
			mHeropedia.OpenWarUnitPage(warUnit);
			return;
		}
	}
	;
}

function bool IsHeroDataAvailable(string archetypeID)
{
	local int i;
	for(i = 0; i < heroes.Length; i++)
	{
		if(heroes[i].GetArchetypeID() == archetypeID)
		{
			return true;
		}
	}
	return false;
}

function Closed()
{
	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("CLICK_SPELL_BOOK_CLOSE_BUTTON");
	ClosePopup();
}

function ClosePopup()
{
	local H7Hud hud;
	local H7FlashMoviePopUpCntl currentContext;

	;

	SetPriority(0); // needs to be under lobby (50) and under mouse (1)

	hud = GetHUD();
	
	mHeropedia.SetVisibleSave(false);
	
	if(class'H7ReplicationInfo'.static.GetInstance().IsCombatMap())
	{
		if(class'H7CombatController'.static.GetInstance().IsInTacticsPhase())
		{
			H7CombatHud( GetHUD() ).GetCombatHudCntl().GetDeploymentBar().SetVisibleSave(true);
			//H7CombatHud( GetHUD() ).GetCombatHudCntl().GetDeploymentOffGridMenu().SetVisibleSave(true);
			H7CombatHud( GetHUD() ).GetCombatHudCntl().GetCombatMenu().SetVisibleSave(true);
		}
		else
		{
			H7CombatHud( GetHUD() ).GetCombatHudCntl().SetCombatHudCntlVisible(true);
		}
	}

	//class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("CLOSE_HERO_SCREEN");
	 
	GetHUD().SetFrameTimer(10,StopAdvance); // in theory we need 1 frame update the visibility, but that has 10% chance of not firing MouseOut events, so we go with 2 frames, now 10 just to be sure #YOLO
	GetPopup().SetVisibleSave(false);
	StartAdvance();
 	GetPopup().Reset();
	
	GetHUD().UnblockAllFlashMovies();
	GetHUD().UnblockUnreal();

	if(GetHUD().GetCurrentContext() == none)
	{
		GetHUD().SetFocusMovie(none);
		class'H7PlayerController'.static.GetPlayerController().SetIsPopupOpen(false);
		GetHUD().UnblockAllFlashMovies();
		class'H7PlayerController'.static.GetPlayerController().GetHud().GetGUIOverlaySystemCntl().GetSideBar().SetVisibleSave(true);
		currentContext = none;
	}
 	else
 	{
		currentContext = GetHUD().GetCurrentContext();
		
		if(currentContext.GetContainer() != none)
			currentContext = currentContext.GetContainer();
		
		GetHUD().BlockFlashBelow(currentContext);
		GetHUD().SetFocusMovie(currentContext);
 		class'H7PlayerController'.static.GetPlayerController().SetIsPopupOpen(true);
 	}
	
	if(class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() && (currentContext == none || !currentContext.IsFullscreen()))
	{
		H7AdventureHud(GetHUD()).GetAdventureHudCntl().GetTopBar().SetVisibleSave(true);
	}
		
	if(hud.IsA('H7MainMenuHud'))
	{
	   
	}

	if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() )
	{
		// tell command panel to update highlight
		//class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetCommandPanel().UpdateSelectState(mCurrentContext,false);
		
		if(GetHud().GetHUDMode() == HM_NORMAL)
		{
			if(GetHUD().GetCurrentContext() == none)
				class'H7AdventureHudCntl'.static.GetInstance().GetNoteBar().SetVisibleSave(true);
		
			// show player buffs
			class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetPlayerBuffs().SetVisibleSave(true);
		}
	}

	//if in combat AND we are not in councilHUB -> hide black bars
	if(class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() && !class'H7ReplicationInfo'.static.GetInstance().IsCouncilMap())
	{
		GetHUD().GetLogCntl().GetBorderBlack().SetVisibleSave(false);
	}
	else if(class'H7ReplicationInfo'.static.GetInstance().IsCouncilMap())
	{
		if(!H7MainMenuHud(GetHUD()).GetSkirmishSetupWindowCntl().GetSkirmishWindow().IsVisible()
			&& !H7MainMenuHud(GetHUD()).GetDuelSetupWindowCntl().GetDuelWindow().IsVisible())
		{
			// hero pedia opened from main menu -> no letter box
			GetHUD().GetLogCntl().GetBorderBlack().SetVisibleSave(false);
		}
	}


	// enable minimap options
	if(class'H7AdventureHudCntl'.static.GetInstance() != none)
	{
		class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().SetPopupMode(false);
	}

	if(!class'H7TownHudCntl'.static.GetInstance().IsInAnyScreen())
	{
		GetHUD().GetLogCntl().GetLog().SetVisibleSave(true);
		GetHUD().GetSpellbookCntl().GetQuickBar().SetVisibleSave(true);
	}
	GetHUD().GetLogCntl().GetQALog().SetVisibleSave(true);
	if(class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() && GetHUD().GetHUDMode() == HM_NORMAL)
	{
		H7Adventurehud(GetHUD()).GetAdventureHudCntl().GetTownList().SetVisibleSave(true);
	}

	//multiplayer gui
	if(class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() || class'H7AdventureController'.static.GetInstance().IsHotSeat()
		&& !GetHUD().GetCurrentContext().IsA('H7FlashMovieTownPopupCntl'))
	{
		if(currentContext != none && currentContext.IsFullscreen())
			class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetMPTurnInfo().SwitchToFullScreen();
		else if(currentContext != none)
			class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetMPTurnInfo().SwitchToHUD();
		else
			class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetMPTurnInfo().SwitchToFullScreen();
	}
}

