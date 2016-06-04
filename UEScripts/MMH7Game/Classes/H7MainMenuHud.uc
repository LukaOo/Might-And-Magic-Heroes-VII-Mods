//=============================================================================
// H7MainMenuHud
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7MainMenuHud extends H7Hud;

var protected H7MainMenuCntl mMainMenuCntl;
var protected H7MapSelectCntl mMapSelectCntl;
var protected H7JoinGameMenuCntl mLobbySelectCntl;
var protected H7SkirmishSetupWindowCntl mSkirmishSetupCntl;
var protected H7DuelSetupWindowCntl mDuelSetupCntl;

function H7MainMenuCntl GetMainMenuCntl() { return mMainMenuCntl; }
function H7MapSelectCntl GetMapSelectCntl() { return mMapSelectCntl; }
function H7JoinGameMenuCntl GetLobbySelectCntl() { return mLobbySelectCntl; }
function H7SkirmishSetupWindowCntl GetSkirmishSetupWindowCntl() { return mSkirmishSetupCntl; }
function H7DuelSetupWindowCntl GetDuelSetupWindowCntl() { return mDuelSetupCntl; }

static function H7MainMenuHud GetInstance() { return H7MainMenuHud(class'H7PlayerController'.static.GetPlayerController().GetHud()); }

function PostBeginPlay()
{
	;
	super.PostBeginPlay();

	class'H7ReplicationInfo'.static.GetInstance().CreateMainMenuController();

	// both MainMenuHud and ReplicationInfo need to exist before we stop the loading movie
	if(class'H7ReplicationInfo'.static.GetInstance() != none)
	{
		class'Engine'.static.StopMovie(true); // stop the movie loading screen
	}
	// on adventure and combat: the tick of the grid calls Init(), we have no grid in the main menu black map, so we have to call Init ourselves
	SetFrameTimer(1,Init);
}

//Called after game loaded - initialise things
simulated function Init()
{
	;
	super.PreInit();

	mMovies.AddItem(mBackgroundImageCntl);

	mMovies.AddItem(mLogSystemCntl);

	mMainMenuCntl = new class'H7MainMenuCntl';
	mMovies.AddItem(mMainMenuCntl);

	mMapSelectCntl = new class'H7MapSelectCntl';
	mMovies.AddItem(mMapSelectCntl);

	mSkirmishSetupCntl = new class'H7SkirmishSetupWindowCntl';
	mMovies.AddItem(mSkirmishSetupCntl);

	mDuelSetupCntl = new class'H7DuelSetupWindowCntl';
	mMovies.AddItem(mDuelSetupCntl);

	mLobbySelectCntl = new class'H7JoinGameMenuCntl';
	mMovies.AddItem(mLobbySelectCntl);

	super.PostInit();

	if(class'H7PlayerController'.static.GetPlayerController() != none)
	{
		class'H7PlayerController'.static.GetPlayerController().SetCursor(CURSOR_NORMAL);
	}
}

function ChildCompleted()
{
	local H7ContentScannerAdventureMapData mapData;
	local H7ContentScannerCombatMapData mapDataCombat;
	local H7ListingSavegameDataScene saveData;
	local OnlineGameSettings settings;

	;

	;

	if(class'H7ReplicationInfo'.static.GetInstance().GetCurrentMapName() == "h7main")
	{
		LoadBG();
	}

	mLogSystemCntl.GetQALog().SetVisibleSave(false);
	mLogSystemCntl.GetLog().SetVisibleSave(false);

	class'H7LogSystemCntl'.static.GetInstance().GetBorderBlack().SetVisibleSave(false); // no letterbox in council anymore

	class'H7ReplicationInfo'.static.GetInstance().InitLobbyDataForCampaign();
	
	mapData = class'H7TransitionData'.static.GetInstance().GetMPLobbyMapDataToCreate();
	mapDataCombat = class'H7TransitionData'.static.GetInstance().GetMPLobbyCombatMapDataToCreate();
	saveData = class'H7TransitionData'.static.GetInstance().GetMPLobbySaveDataToUse();

	if(class'GameEngine'.static.GetOnlineSubsystem() != none && class'GameEngine'.static.GetOnlineSubsystem().GameInterface != none)
	{
		settings = class'GameEngine'.static.GetOnlineSubsystem().GameInterface.GetGameSettings('H7GameSession');
	}
		
	// main menu was (re)started with the intention to open or join a lobby?
	if(mapDataCombat.Filename != "")
	{
		// DUEL		
		class'H7ReplicationInfo'.static.PrintLogMessage("Creating Duel Lobby GUI for Host", 0);;
		class'H7ReplicationInfo'.static.GetInstance().InitLobbyDataForDuel(mapDataCombat,true);
		class'H7DuelSetupWindowCntl'.static.GetInstance().OpenPopup();
	}
	else if(mapData.Filename != "")
	{
		// SKIRMISH
		class'H7ReplicationInfo'.static.PrintLogMessage("Creating Skirmish Lobby GUI for Host", 0);;
		if(saveData.SlotIndex != -1)
		{
			// create multiplayer lobby based on savegame & map (load game)
			class'H7ReplicationInfo'.static.GetInstance().InitLobbyDataBySaveData(mapData,saveData);
		}
		else
		{
			// create multiplayer lobby as host based on map (new game)
			class'H7ReplicationInfo'.static.GetInstance().InitLobbyData(mapData,false,true);
		}
		H7MainMenuHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetSkirmishSetupWindowCntl().OpenPopup(
			class'H7ReplicationInfo'.static.GetInstance().mLobbyData,true,true,saveData.SlotIndex != -1,false
		);
	}
	else if( settings != none )
	{
		if( class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mIsInitialized )
		{
			class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().NoChoicePopup("PU_WAITING_FOR_LOBBY_DATA");
			class'H7ReplicationInfo'.static.PrintLogMessage("No PlayerReplicationInfo", 0);;
			SetTimer(0.1,true,nameof(CreateLobbyGUIWhenEverythingReady));
		}
		else
		{
			// could be kick and have no lobbydata
			// could be waiting and have no lobbydata
			if(class'H7ReplicationInfo'.static.GetInstance().IsMultiplayerGame())
			{
				// waiting
				class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().NoChoicePopup("PU_WAITING_FOR_LOBBY_DATA");
				SetTimer(0.1,true,nameof(CreateLobbyGUIWhenEverythingReady));
			}
			else
			{
				if( class'H7TransitionData'.static.GetInstance().GetMPClientWasKicked() )
				{
					class'H7TransitionData'.static.GetInstance().SetMPClientWasKicked( false );
					// Show pop up: You were kicked by the server.
					class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().OKPopup("PU_GOT_KICKED","OK",none);
				}
				else if( class'H7TransitionData'.static.GetInstance().GetMPClientCancelledLobbySession() )
				{
					class'H7TransitionData'.static.GetInstance().SetMPClientCancelledLobbySession( false );
					// client pressed the back button, dont show any message
				}
				else if( class'H7TransitionData'.static.GetInstance().GetMPServerCancelledLobbySession() )
				{
					class'H7TransitionData'.static.GetInstance().SetMPServerCancelledLobbySession( false );
					class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().OKPopup("PU_SERVER_CLOSED_LOBBY","OK",none);
				}
				else if( class'H7TransitionData'.static.GetInstance().GetMPClientLostConnectionToServer() )
				{
					class'H7TransitionData'.static.GetInstance().SetMPClientLostConnectionToServer( false );
					// GUI: show pop up: lost connection to the server
					class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().OKPopup("PU_LOST_CONNECTION","OK",none);
				}

				class'GameEngine'.static.GetOnlineSubsystem().GameInterface.DestroyOnlineGame('H7GameSession');
			}
		}
	}
	else if( class'H7TransitionData'.static.GetInstance().GetMPClientSavegameNeededLobbySession() )
	{
		class'H7TransitionData'.static.GetInstance().SetMPClientSavegameNeededLobbySession( false );
		class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().OKPopup( "PU_NO_SAVEGAME","OK",none);
	}
	else
	{
		class'H7ReplicationInfo'.static.PrintLogMessage(" Main Menu Hud doing nothing special (normal game start)", 0);; 
		// and actually coming back from last campaign mission and playing matinee is here too
		// but highlight is smart enough not to show up, when the elements themselves are invisible
		if(!class'H7GUIGeneralProperties'.static.GetInstance().mClickedTutorial)
		{
			HighlightGUIElement("aMainMenu","mBtnTutorial");
		}
		else if(!class'H7GUIGeneralProperties'.static.GetInstance().mClickedLostTales)
		{
			HighlightGUIElement("aMainMenu","mBtnSingleplayer");
			HighlightGUIElement("aMainMenu","mBtnLostTales");
		}
		else if(!class'H7GUIGeneralProperties'.static.GetInstance().mClickedLostTales2)
		{
			HighlightGUIElement("aMainMenu","mBtnSingleplayer");
			HighlightGUIElement("aMainMenu","mBtnLostTales2");
		}
	}

	if( class'H7TransitionData'.static.GetInstance().GetMPServerLostConnectionToClients() )
	{
		class'H7TransitionData'.static.GetInstance().SetMPServerLostConnectionToClients( false );
		// GUI: show pop up: lost connection to the server
		class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().OKPopup("PU_LOST_CONNECTION_CLIENTS","OK",none);
	}
}

// for clients
function CreateLobbyGUIWhenEverythingReady() // wait
{
	if( class'H7PlayerController'.static.GetPlayerController().PlayerReplicationInfo != none
		&& class'WorldInfo'.static.GetWorldInfo().GRI != none
		&& class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mIsInitialized
		&& (class'H7ReplicationInfo'.static.GetInstance().mMapHeader.Filename != "" 
		|| class'H7ReplicationInfo'.static.GetInstance().mMapHeaderCombat.Filename != ""))
	{
		class'H7ReplicationInfo'.static.PrintLogMessage("Creating Lobby GUI for Client", 0);;
		class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().Finish();
		class'H7ReplicationInfo'.static.GetInstance().SetFirstClientLobbyReplication(false);
		if(class'H7ReplicationInfo'.static.GetInstance().IsDuel())
		{
			class'H7MainMenuHud'.static.GetInstance().GetDuelSetupWindowCntl().OpenPopup();
		}
		else
		{
			class'H7MainMenuHud'.static.GetInstance().GetSkirmishSetupWindowCntl().OpenPopup(
				class'H7ReplicationInfo'.static.GetInstance().mLobbyData,false,true,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mSaveGameFileName != "",false
			);
		}
		ClearTimer(nameof(CreateLobbyGUIWhenEverythingReady));
	}
}

function ResolutionChanged(Vector2D newRes)
{
	local Vector2d newResFlash;
	
	super.ResolutionChanged(newRes);

	newResFlash = mMainMenuCntl.UnrealPixels2FlashPixels(newRes);
	mMainMenuCntl.GetMainMenu().Realign(newResFlash.x,newResFlash.y);
	mMainMenuCntl.GetBackButton().Realign(newResFlash.x,newResFlash.y);
	mMainMenuCntl.GetCouncilorTooltip().Realign(newResFlash.x,newResFlash.y);
	mMainMenuCntl.GetCouncilorWindow().Realign(newResFlash.x,newResFlash.y);
}

event PostRender()
{
	super.PostRender();
}

function LoadBG()
{
	;
	GetBackgroundImageCntl().LoadBackground( GetBackgroundImageCntl().mBackgroundImageProperties.MainMenuImage );
}
