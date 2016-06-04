//=============================================================================
// H7MainMenuCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7MainMenuCntl extends H7FlashMovieCntl dependson(H7SkirmishSetupWindowCntl);


var protected H7GfxMainMenu mMainMenu;
var protected H7GFxUIContainer mSPMenu;
var protected H7GFxUIContainer mMPMenu;
var protected H7GFxCouncilorTooltip mCouncilorTooltip;
var protected H7GFxCouncilorWindow mCouncilorWindow;
var protected H7GFxUIContainer mBackButton;
var protected H7GFxUIContainer mPopUpCustomDifficulty;

var protected GFxCLIKWidget mBtnOptions;
var protected GFxCLIKWidget mBtnQuit;
var protected GFxCLIKWidget mBtnFeedback;

var protected H7CouncilManager mCouncilManager;

var protected bool mTrailerStarted;
var protected int mPendingVideoNr;
var protected bool mCustomDifficultyVisible;

function H7GfxMainMenu GetMainMenu() {return mMainMenu;}
function H7GFxCouncilorTooltip GetCouncilorTooltip() {return mCouncilorTooltip;}
function H7GFxCouncilorWindow GetCouncilorWindow() {return mCouncilorWindow;}
function H7GFxUIContainer GetBackButton() {return mBackButton;}

function SetTrailerStarted( bool val ) 
{ 
	mTrailerStarted = val;
	H7MainMenuHud(GetHUD()).GetMainMenuCntl().GetMainMenu().SetVisibleSave(!val);
}

function bool Initialize() 
{
	;
	// Start playing the movie
    Super.Start();

	// Initialize all objects in the movie
    AdvanceDebug(0);
	
	mCouncilManager = class'H7CouncilManager'.static.GetInstance();

	mMainMenu = H7GfxMainMenu(mRootMC.GetObject("aMainMenu", class'H7GfxMainMenu'));
	mMainMenu.SetVisibleSave( true );

	mCouncilorTooltip = H7GFxCouncilorTooltip(mRootMC.GetObject("aCouncilorTooltip", class'H7GFxCouncilorTooltip'));
	mCouncilorTooltip.SetVisibleSave( false );

	mCouncilorWindow = H7GFxCouncilorWindow(mRootMC.GetObject("aCouncilorWindow", class'H7GFxCouncilorWindow'));
	mCouncilorWindow.SetVisibleSave( false );

	mBackButton = H7GFxUIContainer(mRootMC.GetObject("aBackButton", class'H7GFxUIContainer'));
	mBackButton.SetVisibleSave( false );

	mPopUpCustomDifficulty = H7GFxUIContainer(mRootMC.GetObject("mPopUpCustomDifficulty", class'H7GFxUIContainer'));
	mPopUpCustomDifficulty.SetVisibleSave(false);

	if(class'GameEngine'.static.GetOnlineSubsystem() != none && OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()) != none)
	{
		OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).ClearTemporaryPrivileges();
	}

	Super.Initialize();

	UpdateContinueButton();

	mMainMenu.SetVersion(class'H7GameData'.static.GetRevisionStr());

	return true;
}


function UpdateContinueButton()
{
	if(!class'H7PlayerProfile'.static.GetInstance().CanCountinueLastCampaign())
	{
		mMainMenu.BlockContinue();
	}
	else
	{
		mMainMenu.SetContinueTooltip( Repl(class'H7Loca'.static.LocalizeSave("TT_CONTINUE","H7MainMenu"),"%campaign",class'H7PlayerProfile'.static.GetInstance().GetCurrentCampaign().CampaignRef.GetName()) );
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN MENU
///////////////////////////////////////////////////////////////////////////////////////////////////

function ContinueCampaign()
{
	class'H7PlayerProfile'.static.GetInstance().ContinueLastCampaign();
}

function StartCampaigns() // Start the main solo-player story
{
	;

	if(mCouncilManager == none)
	{
		mCouncilManager = class'H7CouncilManager'.static.GetInstance();
	}

	if( mCouncilManager != none)
	{
		mCouncilManager.OnEnterCouncil();
	}
}

function Options(EventData data)
{
	GetHud().GetOptionsMenuCntl().OpenPopup();
}

function QuitGame()
{
	class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().YesNoPopup("PU_QUIT_GAME","PU_YES","PU_NO",QuitConfirm,none);
}
function QuitConfirm()
{
	class'H7SoundController'.static.GetInstance().UpdateMusicGameStateSwitch("STOP_ALL_MUSIC");
	ConsoleCommand("quit");
}
function Load()
{
	mMainMenu.SetVisibleSave(false);
	GetHUD().GetLoadSaveWindowCntl().OpenLoad(true);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// SINGLE PLAYER MENU
///////////////////////////////////////////////////////////////////////////////////////////////////

function StartSPCustom(bool hotseat)
{
	mMainMenu.SetVisibleSave(false);
	H7MainMenuHud(GetHUD()).GetMapSelectCntl().Update(false,false,hotseat);
}
function StartSPDuel(optional bool hotseat)
{
	local H7ContentScannerCombatMapData mapdata;

	if(class'H7GUIGeneralProperties'.static.GetInstance().GetDemoDuels())
	{
		mMainMenu.OpenDuelMenu(true);
		return;
	}

	mMainMenu.SetVisibleSave(false);

	mapdata.Filename = "CM_Desert_Canyon_2"; // TODO default map
	class'H7ListingCombatMap'.static.ScanCombatMapHeader(mapdata.Filename, mapdata.CombatMapData, true);
	class'H7ReplicationInfo'.static.GetInstance().InitLobbyDataForDuel(mapdata,false,hotseat);
	class'H7DuelSetupWindowCntl'.static.GetInstance().OpenPopup(hotseat);
}
function SPLoad()
{
	mMainMenu.SetVisibleSave(false);
	GetHUD().GetLoadSaveWindowCntl().OpenLoad(true);
}
function StartLostTales()
{
	local H7CampaignDefinition campaign;

	campaign = class'H7GameData'.static.GetInstance().GetCampaignByID("LostTalesCampaign1",true);

	H7MainMenuHud(GetHUD()).GetMainMenuCntl().InitCouncilorWindow(campaign,true);
	H7MainMenuHud(GetHUD()).GetMainMenuCntl().GetCouncilorWindow().SetVisibleSave(true);
	H7MainMenuHud(GetHUD()).GetMainMenuCntl().GetMainMenu().SetVisibleSave(false);
	GetBackButton().SetVisibleSave(true);
}
function StartLostTales2()
{
	local H7CampaignDefinition campaign;

	campaign = class'H7GameData'.static.GetInstance().GetCampaignByID("LostTalesCampaign2",true);

	H7MainMenuHud(GetHUD()).GetMainMenuCntl().InitCouncilorWindow(campaign,true);
	H7MainMenuHud(GetHUD()).GetMainMenuCntl().GetCouncilorWindow().SetVisibleSave(true);
	H7MainMenuHud(GetHUD()).GetMainMenuCntl().GetMainMenu().SetVisibleSave(false);
	GetBackButton().SetVisibleSave(true);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// MULTI PLAYER MENU
///////////////////////////////////////////////////////////////////////////////////////////////////

function MPLoad()
{
	mMainMenu.SetVisibleSave(false);
	GetHUD().GetLoadSaveWindowCntl().OpenLoad(true);
}

function bool CheckConnection()
{
	if(OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).IsInOfflineMode())
	{
		class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().OKPopup("TT_UPLAY_OFFLINE_MODE","OK",none);
		return false;
	}

	if(OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).GetLoginStatus(0) == LS_NotLoggedIn)
	{
		class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().OKPopup(class'H7Loca'.static.LocalizeSave("UPLAY_ONLINE_SERVICES_NOT_AVAILABLE","H7UPlay"),"OK",none);
		return false;
	}

	return true;
}

function MPCreateLAN()
{
	// goto map select
	mMainMenu.SetVisibleSave(false);
	class'H7MapSelectCntl'.static.GetInstance().Update(true,true,false);
}

function MPCreateINET()
{
	if(!CheckConnection() )
	{
		return;
	}
	
	mMainMenu.SetVisibleSave(false);
	class'H7MapSelectCntl'.static.GetInstance().Update(true,false,false);
}

function MPJoinLAN()
{
	// goto lobby select
	mMainMenu.SetVisibleSave(false);
	class'H7MultiplayerGameManager'.static.GetInstance().SearchOnlineGames(true, false);
	H7MainMenuHud( GetHUD() ).GetLobbySelectCntl().SetActive(true,true,false);
	
}
function MPJoinINET()
{
	if(!CheckConnection() )
	{
		return;
	}
	// goto lobby select
	mMainMenu.SetVisibleSave(false);
	class'H7MultiplayerGameManager'.static.GetInstance().SearchOnlineGames(false, false);
	H7MainMenuHud( GetHUD() ).GetLobbySelectCntl().SetActive(true,false,false);
}

// DUEL
function MPDuelJoinLAN()
{
	// goto lobby select
	mMainMenu.SetVisibleSave(false);
	class'H7MultiplayerGameManager'.static.GetInstance().SearchOnlineGames(true, true);
	H7MainMenuHud( GetHUD() ).GetLobbySelectCntl().SetActive(true,true,true);
}
function MPDuelJoinINET()
{
	if(!CheckConnection() )
	{
		return;
	}
	// goto lobby select
	mMainMenu.SetVisibleSave(false);
	class'H7MultiplayerGameManager'.static.GetInstance().SearchOnlineGames(false, true);
	H7MainMenuHud( GetHUD() ).GetLobbySelectCntl().SetActive(true,false,true);
}
function MPDuelCreateLAN()
{
	local H7ContentScannerCombatMapData mapdata;
	mapdata.Filename = "CM_Desert_Canyon_2"; // TODO default map
	// goto map select
	mMainMenu.SetVisibleSave(false);
	// goto different main map
	class'H7ListingCombatMap'.static.ScanCombatMapHeader(mapdata.Filename, mapdata.CombatMapData, true);
	class'H7MultiplayerGameManager'.static.GetInstance().CreateOnlineGame(true, true, 2,,mapdata);
}
function MPDuelCreateINET()
{
	local H7ContentScannerCombatMapData mapdata;

	if(!CheckConnection() )
	{
		return;
	}
	
	mapdata.Filename = "CM_Desert_Canyon_2"; // TODO default map
	// goto map select
	mMainMenu.SetVisibleSave(false);
	// goto different main map
	class'H7ListingCombatMap'.static.ScanCombatMapHeader(mapdata.Filename, mapdata.CombatMapData, true);
	class'H7MultiplayerGameManager'.static.GetInstance().CreateOnlineGame(false, true, 2,,mapdata);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Extra Menu
///////////////////////////////////////////////////////////////////////////////////////////////////

function Heropedia()
{
	class'H7HeropediaCntl'.static.GetInstance().OpenHeropedia();
}

function Uplay()
{
	;
	OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).ShowUPlayOverlay(); 
}

function StartCredits() // called by flash
{
	class'H7SoundController'.static.PlayGlobalAkEvent(class'H7SoundController'.static.GetInstance().GetCreditsMusicEvent(),true,,true);
	GetHUD().GetLogCntl().GetBorderBlack().SetVisibleSave(true);
}

function EndCredits() // called by flash
{
	class'H7SoundController'.static.PlayGlobalAkEvent(class'H7SoundController'.static.GetInstance().GetMainMusicResumeEvent(),true);
	
	// if main menu has letterbox: do nothing
	// if main menu has no letterbox: hide it
	GetHUD().GetLogCntl().GetBorderBlack().SetVisibleSave(false);
}

function Redeem()
{
	OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).ShowUPlayRedeem();
}

function PlayTrailer()
{
	if(!mTrailerStarted)
	{
		class'H7PlayerController'.static.GetPlayerController().ClientPlayMovie("H7_Game_Trailer", -1, -1,true,true,false);
		SetTrailerStarted(true);
		//half a second before mute the sound for the trailer mode, so the cinmatic can start

		class'H7ReplicationInfo'.static.GetInstance().GetSoundManager().TrailerMode();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// COUNCIL
///////////////////////////////////////////////////////////////////////////////////////////////////

function SetCustomDifficultyVisible(bool visible)
{
	mCustomDifficultyVisible = visible;
}

function bool IsCustomDifficultyVisible()
{
	return mCustomDifficultyVisible;
}

function CloseCustomDifficulty()
{
	mPopUpCustomDifficulty.SetVisibleSave(false);
	mCustomDifficultyVisible = false;
}

function array<H7DropDownEntry> GetEnumList(string enumName)
{
	return H7MainMenuHud(GetHUD()).GetSkirmishSetupWindowCntl().GetEnumList(enumName);
}

function GoBack()
{
	H7CouncilPlayerController(class'H7PlayerController'.static.GetPlayerController()).ToggleMenu();
}

function RestartCurrentCampaignMap()
{
	local H7CampaignDefinition campaign;

	campaign = GetMenuSelectedCampaign();
	
	class'H7PlayerProfile'.static.GetInstance().StartCampaignMap(campaign, , , true);

	// TODO dawid
	campaign = campaign;

}

function StartCampaign() // or continue
{
	local H7CampaignDefinition campaign;
	local AkEvent confirmCampaignEvent;
	local EDifficulty lastPlayedDifficulty;

	campaign = GetMenuSelectedCampaign();

	if(!class'H7PlayerProfile'.static.GetInstance().SelectedDifficultyEqualsLastPlayedDifficulty(campaign,lastPlayedDifficulty))
	{
		class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().YesNoPopup(
			Repl(class'H7Loca'.static.LocalizeSave("PU_DIFFICULTY_CHANGE","H7Popup"),"%diff",class'H7Loca'.static.LocalizeSave(string(lastPlayedDifficulty),"H7SkirmishSetup"))
			,"PU_RESTART_DIFF","CANCEL",RestartCurrentCampaignMap,none
		);
		return;
	}

	//StopAllVO on confirm
	class'H7SoundController'.static.PlayGlobalAkEvent(class'H7SoundController'.static.GetInstance().GetVoiceOverStopAllEvent(),true);

	if(!class'H7CouncilManager'.static.GetInstance().GetCurrentCouncillorInfo().isIvan)
	{
		//Ivan Voiceover for confirm 
		if(H7CouncilPlayerController(class'H7PlayerController'.static.GetPlayerController()) != none)
		{
			confirmCampaignEvent = H7CouncilPlayerController(class'H7PlayerController'.static.GetPlayerController()).ProgressDependantSelectionConfirmAkEvent(class'H7CouncilManager'.static.GetInstance().GetCurrentCouncillorInfo());
		}

		if(confirmCampaignEvent != none)
		{
			class'H7SoundController'.static.PlayGlobalAkEvent(confirmCampaignEvent,true,, true);
		}
	}

	// Tell player profile to decide and do something about campaign start
	class'H7PlayerProfile'.static.GetInstance().StartCampaignMap(campaign);
}

function Reset()
{
	class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().YesNoPopup(
		"PU_CONFIRM_CAMPAIGN_RESET","YES","NO",ResetConfirm,none
	);
}
function ResetConfirm()
{
	local H7CampaignDefinition campaign;
	local AkEvent confirmRestartCampaignEvent;

	//StopAllVO on ResetConfirm
	class'H7SoundController'.static.PlayGlobalAkEvent(class'H7SoundController'.static.GetInstance().GetVoiceOverStopAllEvent(),true);

	if(!class'H7CouncilManager'.static.GetInstance().GetCurrentCouncillorInfo().isIvan)
	{
		//Ivan Voiceover for confirm 
		if(H7CouncilPlayerController(class'H7PlayerController'.static.GetPlayerController()) != none)
		{
			confirmRestartCampaignEvent = H7CouncilPlayerController(class'H7PlayerController'.static.GetPlayerController()).GetRestartConfirmAkEvent(class'H7CouncilManager'.static.GetInstance().GetCurrentCouncillorInfo());
		}

		if(confirmRestartCampaignEvent != none)
		{
			class'H7SoundController'.static.PlayGlobalAkEvent(confirmRestartCampaignEvent,true,, true);
		}
	}

	campaign = GetMenuSelectedCampaign();

	class'H7PlayerProfile'.static.GetInstance().ResetCampaignProgress(campaign);

	mCouncilorWindow.Update(campaign,mCouncilorWindow.GetStandAloneMode());
	DisplayDifficulty();
}

// gets the campaign currently "selected" in various main menu contexts
function H7CampaignDefinition GetMenuSelectedCampaign()
{
	local H7CampaignDefinition campaign;

	campaign = class'H7CouncilManager'.static.GetInstance().GetCurrentCouncillorCampaign();

	if(campaign == none)
	{
		campaign = GetCouncilorWindow().GetLastDisplayedCampaign();
	}

	return campaign;
}

// Open Popup / Update
function InitCouncilorWindow(H7CampaignDefinition campaign,bool standAloneMode)
{
	local CampaignProgress campaignData;
	local H7DifficultyParameters diffParams;
	local CampaignMapProgress mapData;

	campaignData = class'H7PlayerProfile'.static.GetInstance().GetCampaignDataByDef(campaign);

	// if there is a save take difficulty from current
	// if there is no save take difficulty from previouis map
	if(campaignData.CompletedMaps.Length > 0 || campaignData.CurrentMap.CurrentMapState == MST_InProgress)
	{
		if(campaignData.CurrentMap.CurrentMapState == MST_InProgress)
		{
			class'H7PlayerProfile'.static.GetInstance().SetSelectedDifficulty(campaignData.CurrentMap.CurrentDifficulty);
		}
		else
		{  
			mapData = class'H7PlayerProfile'.static.GetInstance().GetPreviousMapInCampaign(campaign);
			class'H7PlayerProfile'.static.GetInstance().SetSelectedDifficulty(mapData.CurrentDifficulty);
		}
	}
	else
	{
		class'H7PlayerProfile'.static.GetInstance().SetSelectedDifficulty(diffParams);
	}
	
	DisplayDifficulty();

	GetCouncilorWindow().Update(campaign,standAloneMode);
}

// only for standalone mode
function CouncilorWindowClosed() // with flash button, or esc
{
	if(class'H7CouncilManager'.static.GetInstance().GetCurrentCouncillorCampaign() == none) // standalone mode
	{
		GetCouncilorWindow().Reset();
		GetMainMenu().SetVisibleSave(true);
		GetBackButton().SetVisibleSave(false);
	}
}

function SetCustomDifficulty(string enumName,int value)
{
	local H7DifficultyParameters diff;
	diff = class'H7PlayerProfile'.static.GetInstance().GetSelectedDifficulty();

	switch(enumName)
	{
		case "EDifficultyStartResources":
			diff.mStartResources = EDifficultyStartResources(value);
			break;
		case "EDifficultyCritterStartSize":
			diff.mCritterStartSize = EDifficultyCritterStartSize(value);
			break;
		case "EDifficultyCritterGrowthRate":
			diff.mCritterGrowthRate = EDifficultyCritterGrowthRate(value);
			break;
		case "EDifficultyAIEcoStrength":
			diff.mAiEcoStrength = EDifficultyAIEcoStrength(value);
			break;
	}

	class'H7PlayerProfile'.static.GetInstance().SetSelectedDifficulty(diff);
	DisplayDifficulty();
}

function SetDifficulty(int index,int value)
{
	local EDifficulty difficulty;
	local H7DifficultyParameters difParams;
	difficulty = EDifficulty(value);
	switch( difficulty )
	{
		case DIFFICULTY_EASY:
			difParams.mStartResources = DSR_ABUNDANCE;
			difParams.mCritterStartSize = DCSS_FEW;
			difParams.mCritterGrowthRate = DCGR_SLOW;
			difParams.mAiEcoStrength = DAIES_POOR;
			class'H7PlayerProfile'.static.GetInstance().SetSelectedDifficulty(difParams);
			break;
		case DIFFICULTY_NORMAL:
			difParams.mStartResources = DSR_AVERAGE;
			difParams.mCritterStartSize = DCSS_AVERAGE;
			difParams.mCritterGrowthRate = DCGR_AVERAGE;
			difParams.mAiEcoStrength = DAIES_AVERAGE;
			class'H7PlayerProfile'.static.GetInstance().SetSelectedDifficulty(difParams);
			break;
		case DIFFICULTY_HARD:
			difParams.mStartResources = DSR_LIMITED;
			difParams.mCritterStartSize = DCSS_MANY;
			difParams.mCritterGrowthRate = DCGR_FAST;
			difParams.mAiEcoStrength = DAIES_PROSPEROUS;
			class'H7PlayerProfile'.static.GetInstance().SetSelectedDifficulty(difParams);
			break;
		case DIFFICULTY_HEROIC:
			difParams.mStartResources = DSR_SHORTAGE;
			difParams.mCritterStartSize = DCSS_HORDES;
			difParams.mCritterGrowthRate = DCGR_PROLIFIC;
			difParams.mAiEcoStrength = DAIES_RICH;
			class'H7PlayerProfile'.static.GetInstance().SetSelectedDifficulty(difParams);
			break;
		case DIFFICULTY_CUSTOM:
			// flash opens popup
			break;
	}
	
	DisplayDifficulty();
}

function DisplayDifficulty()
{
	local H7DifficultyParameters diff;
	;
	diff = class'H7PlayerProfile'.static.GetInstance().GetSelectedDifficulty();
	GetCouncilorWindow().DisplayDifficultySettings(
		class'H7PlayerProfile'.static.GetInstance().GetSelectedDifficultyConverted(),
		diff.mStartResources,diff.mCritterStartSize,diff.mCritterGrowthRate,diff.mAiEcoStrength
	);
}

///////////////////////////////////////////////////////////////////////////////////////////////////

function StartDuel(int map, bool vsAI)
{
	/*local string URL;
	//local H7ListingCombatMapData mapdata;

	// E3 HACK TODO: KILL ME
	if( map == 1 )
	{
		mapdata.Filename = "CM_Necropolis_01";
		class'H7ListingCombatMap'.static.ScanCombatMapHeader(mapdata.Filename, mapdata.MapData, true);
		class'H7ReplicationInfo'.static.GetInstance().InitLobbyDataForDuel(mapdata,false,true);

		class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[0].mArmy = H7EditorArmy(DynamicLoadObject("Dirk.GC_Dungeon_1",class'H7EditorArmy'));
		
		class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[1].mArmy = H7EditorArmy(DynamicLoadObject("Dirk.GC_Necro_1",class'H7EditorArmy'));
		class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[1].mSlotState = vsAI?EPlayerSlotState_AI:EPlayerSlotState_Open;
		
		URL = "CM_Necropolis_01";
		
	}
	else if( map == 2 )
	{
		mapdata.Filename = "CM_Sylvan_Forest_02";
		class'H7ListingCombatMap'.static.ScanCombatMapHeader(mapdata.Filename, mapdata.MapData, true);
		class'H7ReplicationInfo'.static.GetInstance().InitLobbyDataForDuel(mapdata,false,true);

		class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[0].mArmy = H7EditorArmy(DynamicLoadObject("Dirk.GC_Dungeon_2",class'H7EditorArmy'));
		
		class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[1].mArmy =  H7EditorArmy(DynamicLoadObject("Dirk.GC_Sylvan_2",class'H7EditorArmy'));
		class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[1].mSlotState = vsAI?EPlayerSlotState_AI:EPlayerSlotState_Open;
		URL = "CM_Sylvan_Forest_02";
		
	}
	else if( map == 3 )
	{
		mapdata.Filename = "CM_Desert_Coast";
		class'H7ListingCombatMap'.static.ScanCombatMapHeader(mapdata.Filename, mapdata.MapData, true);
		class'H7ReplicationInfo'.static.GetInstance().InitLobbyDataForDuel(mapdata,false,true);

		class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[0].mArmy = H7EditorArmy(DynamicLoadObject("Dirk.GC_Dungeon_3",class'H7EditorArmy'));
		
		class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[1].mArmy = H7EditorArmy(DynamicLoadObject("Dirk.GC_Stronghold_3",class'H7EditorArmy'));
		class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[1].mSlotState = vsAI?EPlayerSlotState_AI:EPlayerSlotState_Open;
		
		URL = "CM_Desert_Coast";
		
	}
	else
	{
		return;
	}
	
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[0].mStartHero = class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[0].mArmy.GetHeroTemplate();
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[1].mStartHero = class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[1].mArmy.GetHeroTemplate();
		
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[0].mFaction = class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[0].mStartHero.GetFaction();
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[0].mFactionRef = class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[0].mStartHero.GetFaction().GetArchetypeID();

	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[1].mFaction = class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[1].mStartHero.GetFaction();
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[1].mFactionRef = class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[1].mStartHero.GetFaction().GetArchetypeID();

	`LOG("StartDuel" @ map @ vsAI);
	
	class'H7ReplicationInfo'.static.GetInstance().WriteLobbyDataToTransitionData(true);

	// Transition to being the party host without notifying clients and traveling absolute
	class'H7ReplicationInfo'.static.GetInstance().StartMap(URL);*/
}

///////////////////////////////////////////////////////////////////////////////////////////////////

function StartTutorialMap()
{
	class'H7ReplicationInfo'.static.GetInstance().StartMap("SCE_Tutorial");
}

function PlayTutorialVideo(int videoNr)
{
	mPendingVideoNr = videoNr;
	class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().YesNoPopup("PU_OPEN_BROWSER_WARNING","OK","CANCEL",PlayTutorialVideoConfirm,none,true);
}

function PlayTutorialVideoConfirm()
{
	class'Engine'.static.LaunchURL(localize("H7MainMenu","TUTORIAL_VID_" $ mPendingVideoNr $ "_URL","MMH7Game"));
}

///////////////////////////////////////////////////////////////////////////////////////////////////

