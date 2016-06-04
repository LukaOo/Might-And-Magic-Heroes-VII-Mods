//=============================================================================
// H7AdventureHudCntl
//
// controls the adventuremap_hud.swf
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AdventureHudCntl extends H7FlashMovieCntl;

// -- MAIN HUD --

// hud elements
var protected H7GFxHeroHUD mHeroHUD;
var protected H7GFxCommandPanel mCommandPanel;
var protected H7GFxTopBar mTopBar;
var protected H7GFxMinimap mMinimap;
var protected H7GFxActorTooltip mActorTooltip;
var protected H7GFxTownList mTownList;
var protected H7GFxPlayerBuffs mPlayerBuffs;
var protected H7GFxSimTurnInfo mMPTurnInfo;
var protected H7GFxSideBar mNoteBar;

// commandpanel
var protected GFxCLIKWidget SpellbookButton;
var protected GFxCLIKWidget QuestlogButton;
var protected GFxCLIKWidget MoveButton;
var protected GFxCLIKWidget HeroButton;
var protected GFxCLIKWidget SkillButton;
var protected GFxCLIKWidget EndTurnButton;
var protected GFxCLIKWidget SettingsButton;
var protected GFxClikWidget TableButton;
// debug commandpanel
var protected GFxObject mSpeedControls;
var protected GFxCLIKWidget CheatWindowButton;
var protected GFxCLIKWidget BtnPlay;
var protected GFxCLIKWidget BtnFastForward;
var protected GFxCLIKWidget BtnFastForward2;

var protected int mHoveredHeroID;
var protected bool mHeroIconClicked;
var protected bool mIsWaitingForReturningPlayersPopupOpen;

function    H7GFxHeroHUD        GetHeroHUD()        {   return mHeroHUD; } 
function    H7GFxCommandPanel   GetCommandPanel()   {   return mCommandPanel; }
function    H7GFxTopBar         GetTopBar()         {   return mTopBar; }
function    H7GFxMinimap        GetMinimap()        {   return mMinimap; }
function    H7GFxActorTooltip   GetActorTooltip()   {   return mActorTooltip; }
function    H7GFxTownList       GetTownList()       {   return mTownList; }
function	H7GFxPlayerBuffs    GetPlayerBuffs()    {   return mPlayerBuffs; }
function	H7GFxSimTurnInfo    GetMPTurnInfo()     {   return mMPTurnInfo; }
function    H7GFxSideBar        GetNoteBar()        {   return mNoteBar; }

static function H7AdventureHudCntl GetInstance()
{
	if (class'H7PlayerController'.static.GetPlayerController().GetAdventureHud() != None)
		return class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl();

	return None;
}

// Called when the UI is opened to start the movie
function bool Initialize() 
{
	;
	// Start playing the movie
    Super.Start();
	// Initialize all objects in the movie
    AdvanceDebug(0); 

	// get objects inside flash movie
	mHeroHUD = H7GFxHeroHUD(mRootMC.GetObject("aHeroHUD", class'H7GFxHeroHUD'));
	mCommandPanel = H7GFxCommandPanel(mRootMC.GetObject("aCommandPanel", class'H7GFxCommandPanel'));
	mTopBar = H7GFxTopBar(mRootMC.GetObject("aTopBar", class'H7GFxTopBar'));
	mMinimap = H7GFxMinimap(mRootMC.GetObject("aMinimap", class'H7GFxMinimap'));
	mActorTooltip = H7GFxActorTooltip(mRootMC.GetObject("aActorTooltip", class'H7GFxActorTooltip'));
	mTownList = H7GFxTownList(mRootMC.GetObject("aTownList", class'H7GFxTownList'));
	mPlayerBuffs = H7GFxPlayerBuffs(mRootMC.GetObject("aPlayerBuffs", class'H7GFxPlayerBuffs'));
	mMPTurnInfo = H7GFxSimTurnInfo(mRootMC.GetObject("aMPTurnInfo", class'H7GFxSimTurnInfo'));
	mNoteBar = H7GFxSideBar(mRootMC.GetObject("aNoteBar", class'H7GFxSideBar'));

	mMPTurnInfo.SetVisibleSave(false);
	
	QuestLogButton = GFxCLIKWidget(mCommandPanel.GetObject("mBtnQuestlog", class'GFxCLIKWidget'));
	QuestLogButton.AddEventListener('CLIK_click', QuestLogButtonClick);
	
	SpellbookButton = GFxCLIKWidget(mCommandPanel.GetObject("mBtnSpellbook", class'GFxCLIKWidget'));
	SpellbookButton.AddEventListener('CLIK_click', SpellbookButtonClick);
	
	MoveButton = GFxCLIKWidget(mCommandPanel.GetObject("mBtnMove", class'GFxCLIKWidget'));
	MoveButton.AddEventListener('CLIK_click', MoveButtonClick);
	
	HeroButton = GFxCLIKWidget(mCommandPanel.GetObject("mBtnHero", class'GFxCLIKWidget'));
	HeroButton.AddEventListener('CLIK_click', HeroButtonClick);
	
	SkillButton = GFxCLIKWidget(mCommandPanel.GetObject("mBtnSkills", class'GFxCLIKWidget'));
	SkillButton.AddEventListener('CLIK_click', SkillButtonClick);
	
	EndTurnButton = GFxCLIKWidget(mCommandPanel.GetObject("mBtnEndTurn", class'GFxCLIKWidget'));
	EndTurnButton.AddEventListener('CLIK_click', EndTurnButtonClick);

	SettingsButton = GFxCLIKWidget(mCommandPanel.GetObject("mBtnSettings", class'GFxCLIKWidget'));
	SettingsButton.AddEventListener('CLIK_click', SettingsButtonClick);

	TableButton = GFxCLIKWidget(mCommandPanel.GetObject("mBtnTable", class'GFxCLIKWidget'));
	TableButton.AddEventListener('CLIK_click', TableButtonClick);

	// debug

	CheatWindowButton = GFxCLIKWidget(mCommandPanel.GetObject("mBtnCheatWindow", class'GFxCLIKWidget'));
	CheatWindowButton.AddEventListener('CLIK_click', CheatWindowButtonClick);
	CheatWindowButton.SetVisible(class'H7OptionsManager'.static.GetInstance().GetSettingBool("SHOW_DEBUG_CHEATS"));

	mSpeedControls = mCommandPanel.GetObject("mSpeedControls");
	mSpeedControls.SetVisible(class'H7OptionsManager'.static.GetInstance().GetSettingBool("SHOW_DEBUG_CONTROLS"));
	
	BtnPlay = GFxCLIKWidget(mSpeedControls.GetObject("mBtnPlay", class'GFxCLIKWidget'));
	BtnPlay.AddEventListener('CLIK_click', BtnPlayClick);
	
	BtnFastForward = GFxCLIKWidget(mSpeedControls.GetObject("mBtnFastForward", class'GFxCLIKWidget'));
	BtnFastForward.AddEventListener('CLIK_click', BtnFastForwardClick);

	BtnFastForward2 = GFxCLIKWidget(mSpeedControls.GetObject("mBtnFastForward2", class'GFxCLIKWidget'));
	BtnFastForward2.AddEventListener('CLIK_click', BtnFastForward2Click);

	Super.Initialize();

	CheckCampaign();

    return true;
}

// check if context is a Council Campaign
// official campaignRef + mapType=CAMPAIGN          -> council
// semi-official campaignRef + mapType=CAMPAIGN     -> no council
// modding campaignRef + mapType=SCEN || SCIRMISH   -> no council	
function CheckCampaign()
{
	if(class'H7AdventureController'.static.GetInstance() != none)
	{
		GetCommandPanel().SetCampaignMode( class'H7AdventureController'.static.GetInstance().GetCampaign().IsCouncilCampaign() );
	}
	else
	{
		GetHUD().SetFrameTimer(1,CheckCampaign);
	}
}

function SetVisible(bool visible)
{
	mHeroHUD.SetVisibleSave(visible);
	mCommandPanel.SetVisibleSave(visible);
	mTopBar.SetVisibleSave(visible);
	mMinimap.SetVisibleSave(visible);
	mActorTooltip.SetVisibleSave(visible);
	mTownList.SetVisibleSave(visible);
	if(mMPTurnInfo.IsActive())
	{
		mMPTurnInfo.SetVisibleSave(visible);
	}
	mNoteBar.SetVisibleSave(visible);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TOWNS
///////////////////////////////////////////////////////////////////////////////////////////////////

function H7Town GetTownByIndex(int index)
{
	local array<H7Town> towns;

	// find town actor
	towns = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetTowns();
	return towns[index];
}

function H7Town GetTownByID(int id)
{
	local array<H7Town> towns;
	local H7Town town;

	// find town actor
	towns = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetTowns();
	foreach towns(town)
	{
		if(town.GetID() == id)
		{
			return town;
		}
	}
	;
	return none;
}

// from flash
function SelectTownAndOpenTownHall(int id)
{
	local H7Town visitingTown;
	
	;
	visitingTown = H7AdventureHud(GetHUD()).GetTownHudCntl().GetTown();
	if(visitingTown == none || visitingTown.GetID() != id)
	{
		if(H7AdventureHud(GetHUD()).GetTownHudCntl().IsInAnyScreen()) 
			H7AdventureHud(GetHUD()).GetTownHudCntl().LeaveTownScreen(true);
			
		GetTownByID(id).OpenTownScreenForMe();
	}
	class'H7TownHudCntl'.static.GetInstance().ToggleVisitTownBuilding(POPUP_BUILD);
}

// toggles out of town when already in town
// from flash list click
// !!! warning uses cursor click state
function SelectTown(int id, optional bool idIsIndex=false)
{
	local array<H7Town> towns;
	local H7Town town;
	local int idx;

	// find town actor

	towns = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetTowns();
	foreach towns(town, idx)
	{
		if((!idIsIndex && town.GetID() == id) || (idIsIndex && idx == id))
		{
			if(H7AdventureHud(GetHUD()).GetTownHudCntl().GetTown() == town)
			{
				//Do nothing! before it was the line below which caused 3162
				//H7AdventureHud(GetHUD()).GetTownHudCntl().LeaveTownScreen();
			}
			else if(H7AdventureHud(GetHUD()).GetTownHudCntl().IsInAnyScreen())
			{
				H7AdventureHud(GetHUD()).GetTownHudCntl().SwitchTownScreen(town);
			}
			else
			{
				class'H7Camera'.static.GetInstance().SetFocusActor(town);
			}
			return;
		}
	}
}

function OnTownSlotDoubleClick(int id)
{
	local array<H7Town> towns;
	local H7Town town;

	// find town actor

	towns = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetTowns();
	foreach towns(town)
	{
		if(town.GetID() == id)
		{
			if(H7AdventureHud(GetHUD()).GetTownHudCntl().GetTown() == town)
			{
				// already there, could toggle it off, but was not wanted
				//H7AdventureHud(GetHUD()).GetTownHudCntl().LeaveTownScreen();
			}
			else
			{
				H7AdventureHud(GetHUD()).GetTownHudCntl().SwitchTownScreen(town);
			}
			return;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// MISC
///////////////////////////////////////////////////////////////////////////////////////////////////

function DisableHeroHUDMiniMapTownList()
{
	mHeroHUD.DisableMe();
	mMinimap.DisableMe();
	mTownList.DisableMe();
}

function EnableHeroHUDMiniMapTownList()
{
	mHeroHUD.EnableMe();
	mMinimap.EnableMe();
	mTownList.EnableMe();
}

// CARAVAN
// on hover
function ShowCaravanPath(int id)
{
	mMinimap.HoverCaravan(id);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// MINIMAP
///////////////////////////////////////////////////////////////////////////////////////////////////

function bool GetMinimapOption(string categoryID,optional bool defaultVisible)
{
	return class'H7GUIGeneralProperties'.static.GetInstance().GetMinimapOption(categoryID,defaultVisible);
}

function SetMinimapOption(string categoryID,bool value)
{
	class'H7GUIGeneralProperties'.static.GetInstance().SetMinimapOption(categoryID,value);
}

function MinimapIconOver(int id) // mouseoverminimapicon mouseovericon
{
	local float x,y;
	local Actor hoveredActor;
	
	;

	hoveredActor = mMinimap.GetActor(id);

	if(hoveredActor != none)
	{
		;
		mMinimap.GetPosition(x,y);
		x =int( x);
		y =int( y);
		GetActorTooltip().ActivateActorTooltipAtCustomPosition(hoveredActor,x,y,x+mMinimap.GetWidth(),y+mMinimap.GetWidth(),GetHUD().GetRightMouseDown());
	}
	else
	{
		;
	}
}

function MinimapQuestIconOver(String questID, int locationID)
{
	local float x,y;
	local H7SeqAct_Quest_NewNode quest;
	
	;

	quest = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetQuestController().GetQuestByID(questID);

	if(quest == none)
	{
		;
		return;
	}

	mMinimap.GetPosition(x,y);
	x = int(x);
	y = int(y);
	GetActorTooltip().ActivateTooltipableAtCustomPosition(quest,x,y,x+mMinimap.GetWidth(),y+mMinimap.GetWidth(),GetHUD().GetRightMouseDown());
}

function MinimapIconOut()
{
	GetActorTooltip().ShutDown();
}

// unreal -> unreal
// Minimap-Camera should center on grid position x,y
// converts grid x,y into -x/2,+x/2 -y/2,+y/2
function MinimapCameraShiftGrid(int gridX,int gridY)
{
	//`log_gui( "MinimapCameraShiftGrid" @ gridX @ gridY );
	MinimapCameraShift(gridX-class'H7AdventureGridManager'.static.GetInstance().GetCurrentGrid().GetGridSizeX()/2,gridY-class'H7AdventureGridManager'.static.GetInstance().GetCurrentGrid().GetGridSizeY()/2);
}

// flash -> unreal (mainly)
// unreal -> unreal (through MinimapCameraShiftGrid)
// 0,0 = center
// -x,-x = top left
// x,-x = top right
function MinimapCameraShift(int gridXCenterOffset,int gridYCenterOffset)
{
	local H7Camera      currentCamera;
	local Vector        camVect;

	//`log_gui("MinimapCameraShift" @ gridXCenterOffset @ gridYCenterOffset);

	if( GetHUD().IsRightClickThisFrame() ) 
	{
		mMinimap.ActionScriptVoid("mouseReleased"); // no camera shift on rightclick
		return;
	}
	currentCamera = H7Camera(class'H7PlayerController'.static.GetPlayerController().PlayerCamera);

	camVect = currentCamera.GetTargetVRP();

	camVect.X = class'H7AdventureGridManager'.static.GetInstance().GetCurrentGrid().GetCenter().X + gridXCenterOffset*class'H7EditorCombatGrid'.const.CELL_SIZE;
	camVect.Y = class'H7AdventureGridManager'.static.GetInstance().GetCurrentGrid().GetCenter().Y + gridYCenterOffset*class'H7EditorCombatGrid'.const.CELL_SIZE;

	currentCamera.SetTargetVRP(camVect);
}

function ResetIconVisibility()
{
	mMinimap.UpdateVisibility();
}

function MinimapInteractionSound()
{
	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("CLICK_CHECKBOX");
}

function TogglePlane()
{
	class'H7AdventureGridManager'.static.GetInstance().SetNextCurrentGrid();
}

function ToggleRealmWindow()
{
	if(class'H7TreasureHuntCntl'.static.GetInstance().GetTreasureHuntPopup().IsVisible())
	{
		class'H7TreasureHuntCntl'.static.GetInstance().ClosePopup();
	}
	else
	{
		class'H7TreasureHuntCntl'.static.GetInstance().OpenPopupWithFade();
	}
}

function bool HasTreasure()
{
	if(class'H7AdventureController'.static.GetInstance() == none) 
	{
		;
		GetHUD().SetFrameTimer(1,CheckForAdventureController);
		return false;
	}
	return class'H7AdventureController'.static.GetInstance().GetTearOfAshaCoordinates().X != -1;
}

function CheckForAdventureController()
{
	if(class'H7AdventureController'.static.GetInstance() == none) 
	{
		//`log_eui("H7AdventureController still not there");
		GetHUD().SetFrameTimer(1,CheckForAdventureController);
	}
	else
	{
		if(class'H7AdventureController'.static.GetInstance().GetTearOfAshaCoordinates().X != -1)
		{
			mMinimap.ActivateTreasure();
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// HERO HUD
///////////////////////////////////////////////////////////////////////////////////////////////////

function HeroOver(int id,int x,int y,int x2,int y2) // overhero
{
	local H7AdventureArmy army;
	
	// If the player controller does not know yet, that mouse is over hud, we need to tell it, so that it does not trigger after this function and ruins our UnitOver cursor
	//if(!mPlayerController.IsMouseOverHUD())
	//{
	//	mPlayerController.HUDMouseOver();
	//}
	
	army = class'H7AdventureController'.static.GetInstance().GetArmyByHeroID( id );
	army.SetHoverHighlight(true);

	mHoveredHeroID = id;
}

function HeroOverPortrait(int id,int x,int y,int x2,int y2)
{
	local H7AdventureArmy army;

	army = class'H7AdventureController'.static.GetInstance().GetArmyByHeroID( id );

	GetActorTooltip().ActivateActorTooltipAtCustomPosition(army.GetHero(),x,y - 80,x2,y2 - 80,GetHUD().GetRightMouseDown());
}

function HeroOutPortrait()
{
	GetActorTooltip().ShutDown();
}

function int GetHoveredHero()
{
	return mHoveredHeroID;
}

function ShowHeroHud(bool show)
{
	mHeroHUD.SetVisibleSave(show);
}

function HeroOut(int id)
{
	local H7AdventureArmy army;
	
	army = class'H7AdventureController'.static.GetInstance().GetArmyByHeroID( id );
	army.SetHoverHighlight(false);
}

function HeroClick(int id,optional bool openPopupIfSelected)
{
	local WorldInfo WI;
	
	if(!GetHUD().IsRightClickThisFrame())
	{
		;
		
		if(class'H7AdventureController'.static.GetInstance().GetArmyByHeroID(id).IsGarrisoned())
		{
			class'H7AdventureController'.static.GetInstance().GetArmyByHeroID(id).UnGarrison();
		}

		// already selected?
		if(openPopupIfSelected && class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero().GetID() == id )
		{
			GetHeroHUD().SelectHeroByHero( class'H7AdventureController'.static.GetInstance().GetArmyByHeroID(id).GetHero() );
			H7AdventureHud(GetHUD()).GetHeroWindowCntl().Update(id);
			return;
		}

		// always select army when heroWindow and skillwheel are NOT visible
		class'H7AdventureController'.static.GetInstance().SelectArmyByHeroID(id);

		if(H7AdventureHud(GetHUD()).GetHeroWindowCntl().GetHeroWindow().IsVisible())
		{
			//heroWindow is visible
			H7AdventureHud(GetHUD()).GetHeroWindowCntl().HeroClick(id);
			// show heroHud animation
			GetHeroHUD().SelectHeroByHero( class'H7AdventureController'.static.GetInstance().GetArmyByHeroID(id).GetHero() );
		}
		else if( H7AdventureHud(GetHUD()).GetSkillwheelCntl().GetPopup().IsVisible())
		{
			//skillwheel is visible
			H7AdventureHud(GetHUD()).GetSkillwheelCntl().HeroClick(id);
			// show heroHud animation
			GetHeroHUD().SelectHeroByHero( class'H7AdventureController'.static.GetInstance().GetArmyByHeroID(id).GetHero() );
		}
		else if( H7AdventureHud(GetHUD()).GetSpellbookCntl().GetPopup().IsVisible())
		{
			H7AdventureHud(GetHUD()).GetSpellbookCntl().HeroClick(id);
		}

		if(!mHeroIconClicked)
		{
			class'H7AdventureController'.static.GetInstance().SetTimer( 1.f, false, nameof(SoundHeroClicked), self );
			
			class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("CLICK_HERO_PORTRAIT");
			mHeroIconClicked = true;
		}
	}
	else
	{
		;
		WI = class'Engine'.static.GetCurrentWorldInfo();

		// use right click during editor as doubleclick fake, because doubleclick does not work in editor
		if(WI.IsPlayInEditor()) HeroDoubleClick(id);
	}
}

function RightMouseDownOnHeroHudSlot(int id, int x1, int y1, int x2, int y2)
{
	local H7AdventureArmy army;
	army = class'H7AdventureController'.static.GetInstance().GetArmyByHeroID(id);
	mActorTooltip.ActivateActorTooltipAtCustomPosition(army, x1, y1 - 80, x2, y2 - 80, true);
}

function SoundHeroClicked()
{
	mHeroIconClicked = false;
}

function HeroDoubleClick(int id)
{
	GetHeroHUD().SelectHeroByHero( class'H7AdventureController'.static.GetInstance().GetArmyByHeroID(id).GetHero() );
	H7AdventureHud(GetHUD()).GetHeroWindowCntl().Update(id);

	/*
	if( H7AdventureHud(GetHUD()).GetHeroWindowBaseCntl().GetBaseWindow() != none && H7AdventureHud(GetHUD()).GetHeroWindowBaseCntl().GetBaseWindow().IsVisible() )
	{
		H7AdventureHud(GetHUD()).GetHeroWindowBaseCntl().UpdateContent(id);
		//show heroHud animation
		GetHeroHUD().SelectHeroByHero( class'H7AdventureController'.static.GetInstance().GetArmyByHeroID(id).GetHero() );
		return;
	}
	class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetHeroWindowBaseCntl().Update(id);
	*/
}

/*function UpdateCommandPanel(int test)
{
	mCommandPanel.ActionScriptVoid("Update");
}*/

///////////////////////////////////////////////////////////////////////////////////////////////////
// COMMAND PANEL
///////////////////////////////////////////////////////////////////////////////////////////////////

// command panel clicks
function SpellbookButtonClick(EventData data)   
{	
	if(GetHUD().GetHUDMode() != HM_NORMAL || class'H7AdventureController'.static.GetInstance().GetSelectedArmy() == none)
	{ 
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("INVALID_SELECT");
		return; 
	} 
	
	ToggleSpellBook();      
}
function QuestLogButtonClick(EventData data)    {   ToggleQuestLog();       } // can be used while waiting for other players

function HeroButtonClick(EventData data)        
{	
	if(GetHUD().GetHUDMode() != HM_NORMAL || class'H7AdventureController'.static.GetInstance().GetSelectedArmy() == none)
	{ 
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("INVALID_SELECT");
		return; 
	}
	
	ToggleHeroWindow();     
}

function SkillButtonClick(EventData data)       
{	
	if(GetHUD().GetHUDMode() != HM_NORMAL || class'H7AdventureController'.static.GetInstance().GetSelectedArmy() == none)
	{
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("INVALID_SELECT");
		return; 
	}
	
	ToggleSkillWheel();     
}

function MoveButtonClick(EventData data)        
{	
	if(GetHUD().GetHUDMode() != HM_NORMAL || class'H7AdventureController'.static.GetInstance().GetSelectedArmy() == none)
	{ 
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("INVALID_SELECT");
		return; 
	}

	ToggleHeroMovement();   
}

function SettingsButtonClick(EventData data)
{
	if(GetHUD().GetHUDMode() == HM_CINEMATIC_SUBTITLE)
	{
		return;
	}
	class'H7PlayerController'.static.GetPlayerController().GetHud().GetPauseMenuCntl().OpenPopup();
}

function TableButtonClick(EventData data)       
{   
	if(GetHUD().GetHUDMode() != HM_NORMAL)
	{ 
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("INVALID_SELECT");
		return; 
	}

	ToggleTable(); 
}
function CheatWindowButtonClick (EventData data){	if(GetHUD().GetHUDMode() != HM_NORMAL) return; class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetCheatWindowCntl().SetData("AdventureMap");}
function EndTurnButtonClick(EventData data) // turnend or popup close
{
	local H7PlayerController dasPlayerController;

	dasPlayerController = class'H7PlayerController'.static.GetPlayerController();

	// 1) A Command Panel Popup is open
	if(GetCommandPanel().IsCommandPanelRelevantPopupOpen())
	{
		if(GetHUD().GetCurrentContext() == none) ;
		else GetHUD().GetCurrentContext().ClosePopup();
		return;
	}
	// 2) A Town Popup is open, or any other popup for that matter?
	else if(GetHUD().GetCurrentContext() != none)
	{
		//dasPlayerController.GetAdventureHud().GetTownHudCntl().
		GetHUD().CloseCurrentPopup();
		return;
	}
	// 3) A Town Screen is open
	else if(dasPlayerController.GetAdventureHud().GetTownHudCntl().IsInAnyScreen())
	{
		dasPlayerController.GetAdventureHud().GetTownHudCntl().Leave();
		return;
	}
	// 4) Command is running
	else if( class'H7ReplicationInfo'.static.GetInstance().GetCommandQueue().IsCommandRunning() )
	{
		return;
	}

	if(GetHUD().GetHUDMode() != HM_NORMAL)
	{
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("INVALID_SELECT");
		return;
	}

	ToggleEndTurn();
}

function String GetTooltipForBtnEndTurn()
{
	local H7PlayerController dasPlayerController;

	dasPlayerController = class'H7PlayerController'.static.GetPlayerController();

	// 1) A Command Panel Popup is open
	if(GetCommandPanel() != none && GetCommandPanel().IsCommandPanelRelevantPopupOpen())
	{
		return class'H7Loca'.static.LocalizeSave("CLOSE","H7General");
	}
	// 2) A Town Popup is open, or any other popup for that matter?
	else if(GetHUD().GetCurrentContext() != none)
	{
		return class'H7Loca'.static.LocalizeSave("CLOSE","H7General");
	}
	// 3) A Town Screen is open
	else if(dasPlayerController.GetAdventureHud().GetTownHudCntl().IsInAnyScreen())
	{
		return class'H7Loca'.static.LocalizeSave("LEAVE","H7General");
	}

	return FlashLocalize("AENDTURN", "AEndTurn");
}

// functionality
// used by click and hotkey

function ToggleTable()
{
	if(GetHUD().GetCurrentContext().IsA('H7DialogCntl')) // in table
	{
		GetHUD().GetDialogCntl().ClosePopup(); // leave table
		return;
	}

	if(!class'H7AdventureController'.static.GetInstance().GetCampaign().IsCouncilCampaign())
	{
		return;
	}

	if(class'H7TownHudCntl'.static.GetInstance().IsInAnyScreen())
	{
		class'H7TownHudCntl'.static.GetInstance().Leave();
	}

	class'H7AdventureController'.static.GetInstance().SwitchToCouncilMap();

	//GetHUD().SetHUDMode(HM_MAPVIEW);
	//GetHUD().GetDialogCntl().InitMapGUI();
}

function ToggleQuestLog()
{
	if(GetHUD().GetCurrentContext().IsA('H7QuestLogCntl'))
	{
		GetHUD().CloseCurrentPopup();
		return;
	}

	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("HUD_QUESTLOG_CLICK_WIDGET");
	
	class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetQuestLogCntl().OpenPopup();
}

function ToggleSpellBook()
{
	if(GetHUD().GetCurrentContext().IsA('H7SpellbookCntl'))
	{
		GetHUD().CloseCurrentPopup();
		return;
	}

	if(mCommandPanel.GetTownMode())
	{ 
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("INVALID_SELECT");
		return;
	}

	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("HUD_SPELLBOOK_CLICK_WIDGET");

	GetHUD().GetSpellbookCntl().SetData(class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero());
}

function ToggleHeroWindow()
{
	local int id;

	if(GetHUD().GetCurrentContext().IsA('H7HeroWindowCntl'))
	{
		GetHUD().CloseCurrentPopup();
		return;
	}

	if(mCommandPanel.GetTownMode())
	{ 
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("INVALID_SELECT");
		return;
	}

	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("HUD_HERO_CLICK_WIDGET");

	id = class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero().GetID();
	class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetHeroWindowCntl().Update(id);
}

function ToggleSkillWheel()
{
	local H7EditorHero hero;

	if(GetHUD().GetCurrentContext() != none && GetHUD().GetCurrentContext().IsA('H7SkillWheelCntl'))
	{
		GetHUD().CloseCurrentPopup();
		return;
	}
	
	if(mCommandPanel.GetTownMode())
	{ 
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("INVALID_SELECT");
		return;
	}

	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("HUD_SKILLWHEEL_CLICK_WIDGET");

	hero = class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero();
	class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetSkillwheelCntl().Update(hero);
}


function ToggleHeroMovement()
{
	local H7AdventureMapCell targetCell;
	local H7AdventureController advCntl;

	advCntl = class'H7AdventureController'.static.GetInstance();
	if(!class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().IsInTownScreen())
	{
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("HUD_MOVE_CLICK_WIDGET");

		if( !advCntl.GetSelectedArmy().GetHero().IsMoving() )
		{
			targetCell = advCntl.GetSelectedArmy().GetHero().GetLastCellMovement();
			if( targetCell.GetTeleporter() != none && 
				advCntl.GetSelectedArmy().GetCell() == targetCell.GetTeleporter().GetTargetCell() &&  
				advCntl.GetSelectedArmy().GetCell().GetTeleporter() != none && 
				advCntl.GetSelectedArmy().GetCell().GetTeleporter().GetEntranceCell() == advCntl.GetSelectedArmy().GetCell() )
			{
				targetCell = advCntl.GetSelectedArmy().GetCell().GetTeleporter().GetEntranceCell();
			}
			if(targetCell != none)
			{
				if( targetCell == advCntl.GetSelectedArmy().GetCell() )
				{
					class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR,advCntl.GetSelectedArmy().GetHero().Location, advCntl.GetSelectedArmy().GetHero().GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_ALREADY_ARRIVED","H7FCT"));
				}
				else
				{
					class'H7AdventureGridManager'.static.GetInstance().DoCurrentArmyActionByCell(targetCell);
				}
			}
			else
			{
				class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR,advCntl.GetSelectedArmy().GetHero().Location, advCntl.GetSelectedArmy().GetHero().GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_NO_PATH_SET","H7FCT"));
			}
		}
		else
		{
			advCntl.GetCommandQueue().Enqueue( 
				class'H7Command'.static.CreateCommand( 
					advCntl.GetSelectedArmy().GetHero(), UC_ABILITY, ACTION_INTERRUPT,, advCntl.GetSelectedArmy().GetHero(),,,,,true 
				)
			);
		}
	}
	else
	{
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("INVALID_SELECT");
	}
}


function ToggleEndTurn()
{
	// the turn cannot end if we just started a combat
	if(class'H7AdventureController'.static.GetInstance().GetStateName() != 'AdventureMap' ) return;

	// End Turn or Cancel End Turn
	if(GetCommandPanel().GetEndSimTurn())
	{
		class'H7AdventureController'.static.GetInstance().RequestCancelEndTurn();
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("END_TURN_BUTTON");
	}
	else
	{
		class'H7AdventureController'.static.GetInstance().EndMyTurn();
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("END_TURN_BUTTON");
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//  game speed debug
///////////////////////////////////////////////////////////////////////////////////////////////////

function BtnPlayClick (EventData data)
{
	class'H7PlayerController'.static.GetPlayerController().ConsoleCommand("slomo 1");
}

function BtnFastForwardClick (EventData data)
{
	class'H7PlayerController'.static.GetPlayerController().ConsoleCommand("slomo 10");
}

function BtnFastForward2Click (EventData data)
{
	class'H7PlayerController'.static.GetPlayerController().ConsoleCommand("slomo 20");
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// player waiting
///////////////////////////////////////////////////////////////////////////////////////////////////

function SetWaitingForPlayers(bool waiting)
{
	if( waiting )
	{
		GetHUD().SetHUDMode(HM_WAITING_FOR_OTHERS_CONNECT);
		//GetHUD().GetRequestPopupCntl().GetRequestPopup().NoChoicePopup( "Please wait while the other players are loading the map." );
	}
	else
	{
		GetHUD().SetHUDMode(HM_NORMAL,HM_WAITING_FOR_OTHERS_CONNECT);
		//GetHUD().GetRequestPopupCntl().GetRequestPopup().Finish();
	}
}

function bool IsWaitingForReturningPlayersPopupOpen()
{
	return mIsWaitingForReturningPlayersPopupOpen;
}

function SetWaitingForReturningPlayers(bool waiting)
{
	mIsWaitingForReturningPlayersPopupOpen = waiting;
	if( waiting )
	{
		GetHUD().GetRequestPopupCntl().GetRequestPopup().NoChoicePopup( class'H7Loca'.static.LocalizeSave("PU_WAIT_RETURN_COMBAT","H7PopUp") );
	}
	else
	{
		GetHUD().GetRequestPopupCntl().GetRequestPopup().Finish();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// MESSAGE SYSTEM
///////////////////////////////////////////////////////////////////////////////////////////////////

function SetNoteBarState(bool val)
{
	class'H7GUIGeneralProperties'.static.GetInstance().SetNoteBarStatus(val);
}

function ClickMessage(int id) // messageclicked
{
	local H7Message mes;
	local H7Town visitingTown;
	
	mes = class'H7MessageSystem'.static.GetInstance().GetMessage(id);

	// OPTIONAL move this code to MessageSystem so messages in other destinations have this too

	if(Actor(mes.settings.referenceObject) != none)
	{
		if(mes.settings.referenceWindowCntl != none)
		{
			if(mes.settings.referenceWindowCntl.IsA('H7SkillwheelCntl'))
			{
				if(class'H7ReplicationInfo'.static.GetInstance().IsCombatMap()) return; // no skill wheel in combat
				if(class'H7AdventureController'.static.GetInstance().GetCurrentPlayer() != class'H7AdventureController'.static.GetInstance().GetLocalPlayer()) return;
				if(class'H7TownHudCntl'.static.GetInstance().IsInAnyScreen()) return; //skillWheel in townScreen
				if(H7EditorHero(mes.settings.referenceObject).IsDead() ) return;

				class'H7AdventureController'.static.GetInstance().SelectArmyByHeroID(H7EditorHero(mes.settings.referenceObject).GetID());
				if(class'H7AdventureController'.static.GetInstance().GetRandomSkilling()) 
					class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetRandomSkillingPopUpCntl().Update(H7EditorHero(mes.settings.referenceObject));
				else
					class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetSkillwheelCntl().Update(H7EditorHero(mes.settings.referenceObject));
				mNoteBar.SelectMessage(id);
			}
			else if(mes.settings.referenceWindowCntl.IsA('H7MagicGuildPopupCntl'))
			{
				if(class'H7ReplicationInfo'.static.GetInstance().IsCombatMap()) return; // no magic guild in combat
				if(class'H7AdventureController'.static.GetInstance().GetCurrentPlayer() != class'H7AdventureController'.static.GetInstance().GetLocalPlayer()) return;

				visitingTown = H7AdventureHud(GetHUD()).GetTownHudCntl().GetTown();
				if(visitingTown == none || visitingTown.GetID() != H7Town(mes.settings.referenceObject).GetID())
				{
					if(H7AdventureHud(GetHUD()).GetTownHudCntl().IsInAnyScreen()) 
						H7AdventureHud(GetHUD()).GetTownHudCntl().LeaveTownScreen(true);
			
					H7Town(mes.settings.referenceObject).OpenTownScreenForMe();
				}
				class'H7TownHudCntl'.static.GetInstance().ToggleVisitTownBuilding(POPUP_MAGICGUILD);
			}
			else
			{
				;
				class'H7Camera'.static.GetInstance().SetFocusActor(Actor(mes.settings.referenceObject));
			}
		}
		else
		{
			class'H7Camera'.static.GetInstance().SetFocusActor(Actor(mes.settings.referenceObject));
		}
	}
	else if(H7SeqAct_Quest_NewNode(mes.settings.referenceObject) != none)
	{
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetQuestLogCntl().OpenPopupWithPreselect(
			H7SeqAct_Quest_NewNode(mes.settings.referenceObject)
		);
		//class'H7MessageSystem'.static.GetInstance().DeleteMessage( mes );
		mNoteBar.SelectMessage(id);
	}
	else
	{
		;
	}
}

