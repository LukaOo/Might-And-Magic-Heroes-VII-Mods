//=============================================================================
// H7MultiplayerGameManager
//=============================================================================
//
// Searches and Starts Multiplayer Games
//
// - hangs on and initialized by H7ReplicationInfo
// 
//=============================================================================
// Copyright 1998-2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7MultiplayerGameManager extends Object;

/** Whether a search is in progress */
var transient bool bIsSearching;

/** The search object to use for finding LAN games */
var transient H7LANSearch SearchSettings;

/** Whether a join is in progress */
var transient bool bIsJoining;

/** Index into SearchResults for session to join */
var transient int SelectedIndexToJoin;

/** Index into SearchResults that currently has focus */
var transient int CurrSelectedIndex;

/** Flag to let the input system know that it needs to block input because of traveling */
var transient bool bBlockInputForTravel;

var transient array<OnlineGameSearchResult> SearchResults;

var transient int mInviteSessionId;

var transient bool mInviteDelayed;

var transient array<PrivilegesContainer> mSharedPrivileges;

var transient array<H7MeshBeaconClient> mClientBeaconArray;

static function H7MultiplayerGameManager GetInstance()       {   return class'H7ReplicationInfo'.static.GetInstance().GetMultiplayerGameManager(); }

static function H7OnlineGameSettings GetOnlineGameSettings()
{
	if(class'GameEngine'.static.GetOnlineSubsystem() != none
		&& class'GameEngine'.static.GetOnlineSubsystem().GameInterface != none
		&& class'GameEngine'.static.GetOnlineSubsystem().GameInterface.GetGameSettings('H7GameSession') != none
		)
	{
		return H7OnlineGameSettings(class'GameEngine'.static.GetOnlineSubsystem().GameInterface.GetGameSettings('H7GameSession'));
	}
	else
	{
		return none;
	}
}

function InitClientBeacon( OnlineGameSearchResult DesiredHost )
{
	local H7MeshBeaconClient beaconClient;

	class'H7ReplicationInfo'.static.PrintLogMessage("InitClientBeacon", 0);;

	beaconClient = new class'H7MeshBeaconClient';
	beaconClient.InitMeshBeaconClient( DesiredHost );

	mClientBeaconArray.AddItem( beaconClient );

	class'H7PlayerController'.static.GetPlayerController().SetTimer( 3.5f, false, nameof(FilterUnreachableServers), self );
}

function FilterUnreachableServers()
{
	local int i;

	for( i=SearchResults.Length-1; i>=0; i-- )
	{
		H7OnlineGameSettings(SearchResults[i].GameSettings).PingInMs = mClientBeaconArray[i].GetPing();
		class'H7ReplicationInfo'.static.PrintLogMessage("Checking" @ i @ H7OnlineGameSettings(SearchResults[i].GameSettings).GetServerName() @ "with state" @ mClientBeaconArray[i].ClientBeaconState @ "ping:" @ mClientBeaconArray[i].GetPing(), 0);;
		if( !class'H7PlayerController'.static.GetPlayerController().mShowUnreachableServers && !mClientBeaconArray[i].IsServerReachable() )
		{
			class'H7ReplicationInfo'.static.PrintLogMessage(mClientBeaconArray[i].ClientBeaconState @ "Removing unreachable server" @ i @ H7OnlineGameSettings(SearchResults[i].GameSettings).GetServerName(), 0);;
			SearchResults.Remove( i, 1 );
		}
	}
	
	// we dont need anymore the beacons
	for( i=mClientBeaconArray.Length-1; i>=0; i-- )
	{
		mClientBeaconArray[i].DestroyBeacon();
	}
	mClientBeaconArray.Length = 0;

	class'H7JoinGameMenuCntl'.static.GetInstance().InitializeBrowserList( SearchResults );

	bIsSearching = false;
}

function Initialize()
{
	local OnlineGameInterfaceUPlay gameInterface;
	local OnlineSubsystemUPlay OnlineSub;
	;
	// set search for LAN games
	SearchSettings = new class'H7LANSearch';
	OnlineSub = OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem());
	gameInterface = OnlineGameInterfaceUPlay(OnlineSub.GameInterface);
	gameInterface.AddUPlayMessageDelegate(OnUPlayMessage);
	gameInterface.AddUPlayInviteDelegate(OnUPlayInvite);

	if(OnlineSub.InviteDelayed)
	{
		mInviteDelayed = true;
	}
}

function Shutdown()
{
	// this is never called for some reason, H7ReplicationInfo never receives the Destroyed() event
	local OnlineGameInterfaceUPlay gameInterface;
	gameInterface = OnlineGameInterfaceUPlay(class'GameEngine'.static.GetOnlineSubsystem().GameInterface);
	gameInterface.ClearUPlayMessageDelegate(OnUPlayMessage);
	gameInterface.ClearUPlayInviteDelegate(OnUPlayInvite);
}

function OnUPlayMessage(UPlayMessageType uplayMessage)
{
	switch(uplayMessage)
	{
	case UPlay_Message_UserConnectionLost:
		class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().OKPopup(class'H7Loca'.static.LocalizeSave("UPLAY_MESSAGE_USER_CONNECTION_LOST","H7UPlay"), "PU_RESTART", QuitToDesktop);
		break;
	case UPlay_Message_UserAccountSharing:
		class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().OKPopup(class'H7Loca'.static.LocalizeSave("UPLAY_MESSAGE_USER_ACCOUNT_SHARING","H7UPlay"), "PU_RESTART", QuitToDesktop);
		break;
	case UPlay_Message_ServerConnectionLost:
		class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().OKPopup(class'H7Loca'.static.LocalizeSave("UPLAY_ONLINE_SERVICES_NOT_AVAILABLE","H7UPlay"), "OK", none);
		break;
	case UPlay_Message_ServicesConnectionLost:
		class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().OKPopup(class'H7Loca'.static.LocalizeSave("UPLAY_UPLAY_SERVICES_NOT_AVAILABLE","H7UPlay"), "OK", none);
		break;
	case UPlay_Event_Exit:
		if(class'H7ReplicationInfo'.static.GetInstance() != none)
		{
			if(class'H7AdventureController'.static.GetInstance() != none &&  class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap())
			{
				class'H7AdventureController'.static.GetInstance().TrackingMapEnd("FORCE_QUIT");
				class'H7AdventureController'.static.GetInstance().TrackingGameModeEnd();
			}
			else if(class'H7CombatController'.static.GetInstance() != none && class'H7ReplicationInfo'.static.GetInstance().IsCombatMap())
			{
				class'H7CombatController'.static.GetInstance().TrackingMapEnd("FORCE_QUIT");
				class'H7CombatController'.static.GetInstance().TrackingGameModeEnd();
			}
		}
	}
}

function OnUPlayInvite(int sessionId)
{
	local OnlineSubsystem OnlineSub;
	local int ctlId;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();

	if(OnlineSubsystemUPlay(OnlineSub).GetLoginStatus(0) == LS_NotLoggedIn)
	{
		class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().OKPopup(class'H7Loca'.static.LocalizeSave("UPLAY_ONLINE_SERVICES_NOT_AVAILABLE","H7UPlay"),"OK",none);
		return;
	}

	if(class'H7SkirmishSetupWindowCntl'.static.GetInstance().GetSkirmishWindow().IsVisible() || class'H7DuelSetupWindowCntl'.static.GetInstance().GetDuelWindow().IsVisible())
	{
		OnlineSubsystemUPlay(OnlineSub).InviteDelayed = true;
		OnlineSubsystemUPlay(OnlineSub).InviteGameId = sessionId;

		if(class'H7SkirmishSetupWindowCntl'.static.GetInstance().GetSkirmishWindow().IsVisible())
		{
			class'H7SkirmishSetupWindowCntl'.static.GetInstance().ClosePopupForReal();
		}
		else if(class'H7DuelSetupWindowCntl'.static.GetInstance().GetDuelWindow().IsVisible())
		{
			class'H7DuelSetupWindowCntl'.static.GetInstance().ClosePopupForReal();
		}

		return;
	}

	if(class'H7AdventureController'.static.GetInstance() != none || class'H7AdventureController'.static.GetInstance() != none )
	{
		OnlineSubsystemUPlay(OnlineSub).InviteDelayed = true;
		OnlineSubsystemUPlay(OnlineSub).InviteGameId = sessionId;

		class'H7TransitionData'.static.GetInstance().SetIsReplayCombat(false);

		/** TRACKING  */
		if( class'H7AdventureController'.static.GetInstance() != none )
		{
			class'H7AdventureController'.static.GetInstance().TrackingMapEnd("QUIT_MAINMENU");
			class'H7AdventureController'.static.GetInstance().TrackingGameModeEnd();
		}
		else 
		{
			class'H7CombatController'.static.GetInstance().TrackingMapEnd("QUIT_MAINMENU");
			class'H7CombatController'.static.GetInstance().TrackingGameModeEnd();
		}

		class'H7ReplicationInfo'.static.GetInstance().GoToMainMenu();

		return;
	}

	mInviteSessionId = sessionId;
	SearchSettings.bIsLanQuery = false;

	if (OnlineSub != None &&
		OnlineSub.GameInterface != None)
	{
		// Mark that we are searching
		bIsSearching = true;
	
		// Do the search
		OnlineSub.GameInterface.AddFindOnlineGamesCompleteDelegate( OnFindOnlineGamesForInviteComplete);
		ctlId = class'H7MainMenuInfo'.static.GetInstance().GetLP().ControllerId;
		OnlineSub.GameInterface.FindOnlineGames( ctlId, SearchSettings);
	}
}

function OnFindOnlineGamesForInviteComplete(bool bWasSuccessful)
{
	local int SearchIdx;
	local OnlineSubsystem OnlineSub;
	local int sessionId;
	local bool didFindGame;
	
	bIsSearching = false;
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	
	// Clear last list of previous results
	SearchResults.Length = 0;

	for (SearchIdx = 0; SearchIdx < OnlineSub.GameInterface.GetGameSearch().Results.Length; SearchIdx++)
	{
		SearchResults.AddItem(OnlineSub.GameInterface.GetGameSearch().Results[SearchIdx]);
	}

	// Copy results from game search
	for (SearchIdx = 0; SearchIdx < OnlineSub.GameInterface.GetGameSearch().Results.Length; SearchIdx++)
	{
		sessionId = H7OnlineGameSettings(OnlineSub.GameInterface.GetGameSearch().Results[SearchIdx].GameSettings).GetSessionId();
		if(sessionId == mInviteSessionId)
		{
			JoinSelected(SearchIdx);
			didFindGame = true;
			break;
		}
	}

	if(!didFindGame)
	{
		class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().OKPopup(class'H7Loca'.static.LocalizeSave("UPLAY_COULD_NOT_FIND_INVITE_GAME","H7UPlay"), "OK", none);
	}

	OnlineSub.GameInterface.ClearFindOnlineGamesCompleteDelegate( OnFindOnlineGamesForInviteComplete);
}

function QuitToDesktop()
{
	/** TRACKING  */
	class'H7AdventureController'.static.GetInstance().TrackingMapEnd("QUIT");
	class'H7AdventureController'.static.GetInstance().TrackingGameModeEnd();
	class'H7SoundController'.static.GetInstance().UpdateMusicGameStateSwitch("STOP_ALL_MUSIC");
	class'H7PlayerController'.static.GetPlayerController().ConsoleCommand("quit");
}

// isDuel -> 0 == skirmish, 1 == duel
function CreateOnlineGame( bool isLAN, bool isDuel, int numPlayers, optional H7ContentScannerAdventureMapData MapData, optional H7ContentScannerCombatMapData CombatMapData, optional H7ListingSavegameDataScene basedOnSaveGame)
{
	local int i;
	local string mapInfoObjectName;
	local string theURL;
	local H7OnlineGameSettings currentGameSettings;

	class'H7ReplicationInfo'.static.PrintLogMessage("CreateOnlineGame" @ isLAN @ isDuel @ numPlayers @ MapData.Filename @ CombatMapData.Filename, 0);;
	class'H7TransitionData'.static.GetInstance().ResetLobbyData();

	class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().NoChoicePopup("PU_WAIT_CREATE_ONLINE_GAME");
	class'H7TransitionData'.static.GetInstance().SetIsInMapTransition(true);

	if( bIsSearching || bIsJoining )
	{
		class'H7ReplicationInfo'.static.PrintLogMessage("Cannot Create a game because bIsSearching " @ bIsSearching @ "bIsJoining" @ bIsJoining, 0);;
		return;
	}
	
	// be sure that we dont have an online game
	if( class'GameEngine'.static.GetOnlineSubsystem().GameInterface.GetGameSettings('H7GameSession') != none )
	{
		class'GameEngine'.static.GetOnlineSubsystem().GameInterface.DestroyOnlineGame('H7GameSession');
	}

	// Create the object and change it's settings to match the profile preference
	currentGameSettings = new class'H7OnlineGameSettings';

	currentGameSettings.bAllowJoinInProgress = false;
	currentGameSettings.bIsLanMatch = isLAN;
	currentGameSettings.NumPublicConnections = numPlayers;

	if(MapData.Filename != "")
	{
		mapInfoObjectName = MapData.AdventureMapData.mMapInfoObjectName;
		currentGameSettings.SetMapFilepath( MapData.Filename );
	}
	else
	{
		mapInfoObjectName = CombatMapData.CombatMapData.mMapInfoObjectName;
		currentGameSettings.SetMapFilepath( CombatMapData.Filename );
	}

	i = InStr(mapInfoObjectName,"_");
	mapInfoObjectName = Mid( mapInfoObjectName, i + 1 );
	currentGameSettings.SetMapInfoNumber( Int ( mapInfoObjectName ) );

	currentGameSettings.SetServerName( class'H7PlayerController'.static.GetPlayerController().PlayerReplicationInfo.PlayerName );
	currentGameSettings.SetGameType( isDuel ? 1 : 0 );
	currentGameSettings.SetIsSavedGame( basedOnSaveGame.SlotIndex != -1 );
	if(basedOnSaveGame.SlotIndex != -1)
	{
		currentGameSettings.SetGameSpeedAdventure( basedOnSaveGame.SavegameData.mGameSettings.mGameSpeedAdventure );
		currentGameSettings.SetGameSpeedAdventureAI( basedOnSaveGame.SavegameData.mGameSettings.mGameSpeedAdventureAI );
		currentGameSettings.SetGameSpeedCombat( basedOnSaveGame.SavegameData.mGameSettings.mGameSpeedCombat );
		currentGameSettings.SetDifficulty( basedOnSaveGame.SavegameData.mGameSettings.mDifficulty );
		currentGameSettings.SetForceQuickCombat( basedOnSaveGame.SavegameData.mGameSettings.mForceQuickCombat );
		currentGameSettings.SetTeamsCanTrade( basedOnSaveGame.SavegameData.mGameSettings.mTeamsCanTrade );
		currentGameSettings.SetTeamSetup( basedOnSaveGame.SavegameData.mMapSettings.mTeamSetup );
		currentGameSettings.SetTimerAdv( basedOnSaveGame.SavegameData.mGameSettings.mTimerAdv );
		currentGameSettings.SetTimerCombat( basedOnSaveGame.SavegameData.mGameSettings.mTimerCombat );
		currentGameSettings.SetTurnType( basedOnSaveGame.SavegameData.mGameSettings.mSimTurns ? 1 : 0 );
		currentGameSettings.SetUseRandomStartPosition( basedOnSaveGame.SavegameData.mMapSettings.mUseRandomStartPosition );
		currentGameSettings.SetVictoryCondition( basedOnSaveGame.SavegameData.mMapSettings.mVictoryCondition );
		currentGameSettings.SetSkillType( basedOnSaveGame.SavegameData.mGameSettings.mUseRandomSkillSystem ? 1 : 0 );
	}
	else
	{
		// setting the default values
		currentGameSettings.SetGameSpeedAdventure( 1.f );
		currentGameSettings.SetGameSpeedAdventureAI( 1.f );
		currentGameSettings.SetGameSpeedCombat( 1.f );
		currentGameSettings.SetDifficulty( DIFFICULTY_NORMAL );
		currentGameSettings.SetForceQuickCombat( FQC_NEVER );
		currentGameSettings.SetTeamsCanTrade( true );
		currentGameSettings.SetTeamSetup( TEAM_MAP_DEFAULT );
		currentGameSettings.SetTimerAdv( TIMER_ADV_NONE );
		currentGameSettings.SetTimerCombat( TIMER_COMBAT_NONE );
		currentGameSettings.SetTurnType( 0 );
		currentGameSettings.SetUseRandomStartPosition( false );
		currentGameSettings.SetVictoryCondition( E_H7_VC_DEFAULT );
		currentGameSettings.SetSkillType( 0 );
	}
		
	// Make sure we have a network connection
	if (!class'UIInteraction'.static.HasLinkConnection())
	{
		// bail
		class'H7ReplicationInfo'.static.PrintLogMessage("No network connection", 0);;
		return;
	}

	class'H7TransitionData'.static.GetInstance().SetMPLobbySaveDataToUse(basedOnSaveGame);
	class'H7ReplicationInfo'.static.PrintLogMessage("Start creating a Game", 0);;
	class'H7TransitionData'.static.GetInstance().SetMPLobbyCombatMapDataToCreate(CombatMapData);
	class'H7TransitionData'.static.GetInstance().SetMPLobbyMapDataToCreate(MapData);

	if(currentGameSettings.bIsLanMatch)
	{
		theURL = "H7Main" $ "?bIsLanMatch=" $ currentGameSettings.bIsLanMatch $"?listen";
	}
	else
	{
		OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).SetWaitingForStormData();
		theURL = "H7Main" $ "?bIsLanMatch=" $ currentGameSettings.bIsLanMatch $"?listen?stormsocket";
	}

	if(class'H7GameInfo'.static.GetH7GameInfoInstance() != none)
	{
		class'H7GameInfo'.static.GetH7GameInfoInstance().UpdateGameSettings();
		class'H7GameInfo'.static.GetH7GameInfoInstance().HostGame(theURL,true,true);
	}

	OnlineGameInterfaceUPlay(class'GameEngine'.static.GetOnlineSubsystem().GameInterface).PreparedGameSettings = currentGameSettings;

	if(isLAN)
	{
		PublishCurrentGame();
	}
}

function PublishCurrentGame()
{
	local OnlineSubsystem OnlineSub;
	local int ControllerIndex;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	OnlineSub.GameInterface.AddCreateOnlineGameCompleteDelegate(OnCreateH7GameSessionComplete);
	ControllerIndex =  class'H7PlayerController'.static.GetPlayerController().GetHUD().GetALocalPlayerController().GetUIController().GetPlayerControllerId(0);

	// Publish a new party up on Live
	if ( !OnlineSub.GameInterface.CreateOnlineGame(ControllerIndex, 'H7GameSession', OnlineGameInterfaceUPlay(OnlineSub.GameInterface).PreparedGameSettings) )
	{
		//`LOG("PublishCurrentGame:"@
		OnlineSub.GameInterface.ClearCreateOnlineGameCompleteDelegate(OnCreateH7GameSessionComplete);
		class'H7ReplicationInfo'.static.PrintLogMessage("Failed creating a Game", 0);;
	}

	OnlineGameInterfaceUPlay(OnlineSub.GameInterface).PreparedGameSettings = none;
}

function JoinSelected(int SelectedIndex)
{
	local array<H7ContentScannerAdventureMapData> adventureMaps;
	local int i;
	local bool foundMap;
	local string mapPath;

	if( bIsJoining )
	{
		return;
	}

	if ( CanJoinSelectedGame( H7OnlineGameSettings( SearchResults[SelectedIndex].GameSettings ) ) )
	{
		if (SelectedIndex >= 0 && SelectedIndex < SearchResults.Length)
		{
			adventureMaps = class'H7TransitionData'.static.GetInstance().GetContentScanner().mCollection_AdventureData;
			mapPath = H7OnlineGameSettings( SearchResults[SelectedIndex].GameSettings ).GetMapFilepath();
			
			for(i=0; i<adventureMaps.Length; i++)
			{
				if(adventureMaps[i].Filename == mapPath)
				{
					foundMap = true;
					break;
				}
			}

			if(foundMap || H7OnlineGameSettings( SearchResults[SelectedIndex].GameSettings ).GetGameType() == 1 || H7OnlineGameSettings( SearchResults[SelectedIndex].GameSettings ).IsSavedGame())
			{
				// Keep track of session selected
				SelectedIndexToJoin = SelectedIndex;
				//class'H7TransitionData'.static.GetInstance().SetMPGameToJoin(SearchResults[SelectedIndex].GameSettings);
				JoinSystemLink();
			}
			else
			{
				class'H7PlayerController'.static.GetPlayerController().GetHUD().GetRequestPopupCntl().GetRequestPopup().OKPopup( class'H7Loca'.static.LocalizeSave("TT_MISSING_MAP","H7MainMenu"),"OK", none );
			}
			
		}
	}
	else
	{
		// GUI: Server is full.
		class'H7PlayerController'.static.GetPlayerController().GetHUD().GetRequestPopupCntl().GetRequestPopup().OKPopup( class'H7Loca'.static.LocalizeSave("TT_GAME_FULL","H7MainMenu"),"OK", none );
	}
}

/**
 * Kicks non-local players, tells the gameinfo to shut the party session down, 
 * switches the invite policy, opens the LAN scene
 * */
function JoinSystemLink()
{
	class'H7TransitionData'.static.GetInstance().ResetLobbyData();

	// Mark as pending join
	bIsJoining = true;
	
	// Kill the party session
	DestroyPartyForSystemLink(OnDestroyPartyForSystemLinkJoinComplete);

	// add disconnection error in case that the client has issues while traveling to the server
	class'H7TransitionData'.static.GetInstance().SetMPClientLostConnectionToServer( true );
}

function RefreshOnlineGames()
{
	class'H7ReplicationInfo'.static.PrintLogMessage("RefreshOnlineGames", 0);;
	SearchOnlineGames( SearchSettings.bIsLanQuery, SearchSettings.AdditionalSearchCriteria == "duel" );
}

// isDuel -> true = duel, false = skirmish
function SearchOnlineGames(bool isLAN, bool isDuel) 
{
	local OnlineSubsystem OnlineSub;
	local int ctlId;

	if( bIsSearching )
	{
		class'H7ReplicationInfo'.static.PrintLogMessage("Trying to do an online games search, when one is already is process", 0);;
		return;
	}

	SearchSettings.bIsLanQuery = isLAN;
	SearchSettings.AdditionalSearchCriteria = isDuel ? "duel" : "skirmish";

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();

	if (OnlineSub != None &&
		OnlineSub.GameInterface != None)
	{
		// Mark that we are searching
		bIsSearching = true;
	
		// Do the search
		OnlineSub.GameInterface.AddFindOnlineGamesCompleteDelegate( OnFindOnlineGamesComplete);
		ctlId = class'H7MainMenuInfo'.static.GetInstance().GetLP().ControllerId;
		OnlineSub.GameInterface.FindOnlineGames( ctlId, SearchSettings);
		if( isLAN )
		{
			class'H7PlayerController'.static.GetPlayerController().SetTimer( 3.f, false, nameof(OnLANSearchComplete), self );
		}
	}
	// Reset to no selection
	SelectedIndexToJoin = -1;
	CurrSelectedIndex = 0;

	// Clear last list of previous results
	SearchResults.Length = 0;
	class'H7JoinGameMenuCntl'.static.GetInstance().InitializeBrowserList( SearchResults ); // will enable button
	
	class'H7JoinGameMenuCntl'.static.GetInstance().GetLobbyList().DisableRefreshButton(); // will disable button
}

function CancelFindOnlineGames()
{
	local OnlineSubsystem OnlineSub;
	local int i;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();

	class'H7ReplicationInfo'.static.PrintLogMessage("CancelFindOnlineGames" @ bIsSearching, 0);;

	if( bIsSearching )
	{
		bIsSearching = false;

		class'H7PlayerController'.static.GetPlayerController().ClearTimer( nameof(FilterUnreachableServers), self );

		// we dont need anymore the beacons
		for( i=mClientBeaconArray.Length-1; i>=0; i-- )
		{
			mClientBeaconArray[i].DestroyBeacon();
		}
		mClientBeaconArray.Length = 0;

		OnlineSub.GameInterface.AddCancelFindOnlineGamesCompleteDelegate(OnCancelSearchComplete);
		OnlineSub.GameInterface.CancelFindOnlineGames();
	}
}

function bool CanJoinSelectedGame( H7OnlineGameSettings mySettings )
{
	return ( mySettings.GetNumClosedSlots() + mySettings.GetNumAISlots() ) < mySettings.NumOpenPublicConnections;
}

function StartFilteringBrowserList()
{
	local int i;

	if(SearchSettings.bIsLanQuery) // we get duel and skirmishes
	{
		if(SearchSettings.AdditionalSearchCriteria == "duel") // search for duel
		{
			// delete skirmishes
			for(i=SearchResults.Length-1;i>=0;i--)
			{
				if(H7OnlineGameSettings(SearchResults[i].GameSettings).GetGameType() == 0)
				{
					SearchResults.Remove(i,1);
				}
			}
		}
		else if(SearchSettings.AdditionalSearchCriteria ==  "skirmish") // search for skirmishes
		{
			// delete duel
			for(i=SearchResults.Length-1;i>=0;i--)
			{
				if(H7OnlineGameSettings(SearchResults[i].GameSettings).GetGameType() == 1)
				{
					SearchResults.Remove(i,1);
				}
			}
		}
	}

	class'H7JoinGameMenuCntl'.static.GetInstance().InitializeBrowserList( SearchResults );

	bIsSearching = false;
}

/******************************************** Delegates *********************************************/

/** Delegate fired when party has finished destroying for system link */
delegate OnDestroyPartForSystemLinkComplete(name SessionName,bool bWasSuccessful);

/** Destroys a party to transition to system link */
function DestroyPartyForSystemLink(delegate<OnDestroyPartForSystemLinkComplete> DestroyCompleteDelegate)
{
	local OnlineSubsystem OnlineSub;
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();

	OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(DestroyCompleteDelegate);
	
	if (OnlineSub.GameInterface.DestroyOnlineGame('H7GameSession'))
	{
		class'H7PlayerController'.static.GetPlayerController().GetHUD().GetRequestPopupCntl().GetRequestPopup().OKPopup("Unable to connect to the server (DestroyPartyForSystemLink).","OK",none);
		class'H7ReplicationInfo'.static.PrintLogMessage("Destroying OnlineGame", 0);;
	}
}

/**
* Delegate fired when a destroying an online game has completed
*
* @param SessionName the name of the session this callback is for
* @param bWasSuccessful true if the async action completed without error, false if there was an error
*/
function OnDestroyPartyForSystemLinkJoinComplete(name SessionName,bool bWasSuccessful)
{
	local OnlineGameSearchResult Result;	
	local OnlineSubsystem OnlineSub;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();

	if (OnlineSub != None &&
		OnlineSub.GameInterface != None)
	{
		OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyPartyForSystemLinkJoinComplete);
		OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(OnJoinPartyComplete);
		
		// Now join the party that is advertised
		Result = SearchResults[SelectedIndexToJoin];
		OnlineSub.GameInterface.JoinOnlineGame(GetLP().ControllerId, 'H7GameSession', Result);
	}
}

function LocalPlayer GetLP()
{
	return class'H7MainMenuInfo'.static.GetInstance().GetLP();
}

/**
	* Called when the H7GameSession create finishes publishing with Live
	*
	* @param SessionName the name of the session this event is for
	* @param bWasSuccessful whether the create worked or not
	*/
function OnCreateH7GameSessionComplete(name SessionName,bool bWasSuccessful)
{
	local OnlineSubsystem OnlineSub;

	class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().Finish();

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();

	if (SessionName == 'H7GameSession')
	{
		if (OnlineSub.GameInterface != None)
		{
			OnlineSub.GameInterface.ClearCreateOnlineGameCompleteDelegate(OnCreateH7GameSessionComplete);
		}

		if (!bWasSuccessful)
		{
			class'H7ReplicationInfo'.static.PrintLogMessage("Fail to create H7GameSession game ", 0);;
			class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().OKPopup(class'H7Loca'.static.LocalizeSave("UPLAY_ONLINE_SERVICES_NOT_AVAILABLE","H7UPlay"), "OK", ErrorMessageConfirmed);
		}
	}
}

function ErrorMessageConfirmed()
{
	if( H7OnlineGameSettings(class'GameEngine'.static.GetOnlineSubsystem().GameInterface.GetGameSettings('H7GameSession')).GetGameType() == 0)
	{
		class'H7SkirmishSetupWindowCntl'.static.GetInstance().ClosePopupForReal();
	}
	else
	{
		class'H7DuelSetupWindowCntl'.static.GetInstance().ClosePopupForReal();
	}
}

function AddSharedPrivileges(PrivilegesContainer newPrivileges)
{
	RemovePrivilegesOfPlayerIndex(newPrivileges.playerIndex);

	mSharedPrivileges.AddItem(newPrivileges);
}

function array<int> GetSharedPrivileges()
{
	local array<int> privileges;
	local PrivilegesContainer container;
	local int i;

	foreach mSharedPrivileges(container)
	{
		for(i=0;i<container.privileges.Length; i++)
		{
			if(privileges.Find(container.privileges[i]) == INDEX_NONE && container.privileges[i] <= 2130 )
			{
				privileges.AddItem(container.privileges[i]);
			}
		}
	}
	
	return privileges;
}

function RemovePrivilegesOfPlayerIndex(int index)
{
	local PrivilegesContainer privContainer;

	foreach mSharedPrivileges(privContainer)
	{
		if(privContainer.playerIndex == index)
		{
			mSharedPrivileges.RemoveItem(privContainer);
			return;
		}
	}
}

/**
* Has the pary host travel to the session that was just joined
*
* @param SessionName the name of the session this event is for
* @param bWasSuccessful whether the join completed successfully or not
*/
function OnJoinPartyComplete(name SessionName,bool bWasSuccessful)
{
	local string URL;
	local OnlineSubsystem OnlineSub;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	OnlineSub.GameInterface.ClearJoinOnlineGameCompleteDelegate(OnJoinPartyComplete);
	class'H7TransitionData'.static.GetInstance().SetIsInMapTransition(true);

	if (SessionName == 'H7GameSession' && bWasSuccessful)
	{
		// We are joining so grab the connect string to use
		if (OnlineSub.GameInterface.GetResolvedConnectString('H7GameSession',URL))
		{
			class'H7ReplicationInfo'.static.PrintLogMessage("Resulting url for 'H7GameSession' is ("$URL$")", 0);;
			// Trigger a console command to connect to this url
			class'WorldInfo'.static.GetWorldInfo().ConsoleCommand("start " $ URL);
			bBlockInputForTravel = true;

			// Show popup Connecting to the server
			class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().NoChoicePopup( class'H7Loca'.static.LocalizeSave("PU_CONNECTNG_TO_SERVER","H7PopUp") );

			class'H7PlayerController'.static.GetPlayerController().SetTimer( 20.f, false, nameof(JoinToHostFailed), self ); // 20 seconds should be enought to connect to the lobby of the server
		}
	}
	else
	{
		class'H7PlayerController'.static.GetPlayerController().GetHUD().GetRequestPopupCntl().GetRequestPopup().OKPopup("PU_CONNECT_FAIL_COMPLETE","OK",none);
		class'H7ReplicationInfo'.static.PrintLogMessage("UnableToConnect Message" @ SessionName @ bWasSuccessful, 0);;
	}
	bIsJoining = false;
}

// if the this function is called means that there was an error with the Join to the server
function JoinToHostFailed()
{
	class'H7PlayerController'.static.GetPlayerController().GetHUD().GetRequestPopupCntl().GetRequestPopup().OKPopup("PU_CONNECT_FAIL_TIMEOUT","OK",none);

	class'WorldInfo'.static.GetWorldInfo().ConsoleCommand("cancel");

	if( class'GameEngine'.static.GetOnlineSubsystem().GameInterface.GetGameSettings('H7GameSession') != none )
	{
		class'GameEngine'.static.GetOnlineSubsystem().GameInterface.DestroyOnlineGame('H7GameSession');
	}
}

/**
* Delegate fired when the search for an online game has completed
*
* @param bWasSuccessful true if the async action completed without error, false if there was an error
*/
function OnFindOnlineGamesComplete(bool bWasSuccessful)
{
	local int SearchIdx;
	local OnlineSubsystem OnlineSub;
	
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	
	// Clear last list of previous results
	SearchResults.Length = 0;
	if (OnlineSub.GameInterface.GetGameSearch().Results.length == 0)
	{
		class'H7ReplicationInfo'.static.PrintLogMessage("No Servers Found", 0);;
	}
	else
	{
		// Copy results from game search
		for (SearchIdx = 0; SearchIdx < OnlineSub.GameInterface.GetGameSearch().Results.Length; SearchIdx++)
		{
			SearchResults.AddItem(OnlineSub.GameInterface.GetGameSearch().Results[SearchIdx]);
		}
	}

	if( !SearchSettings.bIsLanQuery )
	{
		// Populate list of servers
		StartFilteringBrowserList();
		OnlineSub.GameInterface.ClearFindOnlineGamesCompleteDelegate( OnFindOnlineGamesComplete);
	}
}

function OnLANSearchComplete()
{
	// Populate list of servers
	StartFilteringBrowserList();
	class'GameEngine'.static.GetOnlineSubsystem().GameInterface.ClearFindOnlineGamesCompleteDelegate( OnFindOnlineGamesComplete);
}

/**
* Delegate fired when the search for an online game has canceled
*
* @param bWasSuccessful true if the async action completed without error, false if there was an error
*/
function OnCancelSearchComplete( bool bWasSuccessful )
{
	local OnlineSubsystem OnlineSub;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	OnlineSub.GameInterface.ClearCancelFindOnlineGamesCompleteDelegate(OnCancelSearchComplete);
}

function Update()
{
	local bool gameSetupGUIVisible;

	if(class'GameEngine'.static.GetOnlineSubsystem() != none )	
	{
		if(mInviteDelayed 
			&& class'WorldInfo'.static.GetWorldInfo() != none 
			&& class'H7ReplicationInfo'.static.GetInstance() != none 
			&& class'H7MainMenuController'.static.GetInstance() != none 
			&& OnlineGameInterfaceUPlay(class'GameEngine'.static.GetOnlineSubsystem().GameInterface).GameSettings == none)
		{
			OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).InviteDelayed = false;
			mInviteDelayed = false;
			OnUPlayInvite(OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).InviteGameId);
		}

		if(OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).IsWaitingForStormData)
		{
			if(OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).IsStormDataAvailable())
			{
				OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).IsWaitingForStormData = false;
				PublishCurrentGame();
			}
			else if(OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).mRDVManager.mStormManager.mIsErrorTriggered)
			{
				if( H7OnlineGameSettings(class'GameEngine'.static.GetOnlineSubsystem().GameInterface.GetGameSettings('H7GameSession')).GetGameType() == 0)
				{
					gameSetupGUIVisible = class'H7SkirmishSetupWindowCntl'.static.GetInstance().GetSkirmishWindow().IsVisible();
				}
				else
				{
					gameSetupGUIVisible = class'H7DuelSetupWindowCntl'.static.GetInstance().GetDuelWindow().IsVisible();
				}

				if(class'H7RequestPopupCntl'.static.GetInstance() != none && gameSetupGUIVisible)
				{
					OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).IsWaitingForStormData = false;
					OnlineGameInterfaceUPlay(class'GameEngine'.static.GetOnlineSubsystem().GameInterface).TriggerServicesUnavailable(false);
					class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().OKPopup(class'H7Loca'.static.LocalizeSave("UPLAY_ONLINE_SERVICES_NOT_AVAILABLE","H7UPlay"), "OK", ErrorMessageConfirmed);
				}
			}
		}

		// make sure that force quit popup wasn't closed by something (for example loading another map) and reopen it in that case
		if(OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).GetForceQuitMessageDisplayed() && !class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().IsVisible())
		{
			OnUPlayMessage(OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).GetCurrentUPlayMessage());
		}
	}
}
