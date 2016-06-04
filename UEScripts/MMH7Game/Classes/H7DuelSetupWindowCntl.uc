//=============================================================================
// H7DuelSetupWindowCntl
//
// This really is the lobby screen for singleplayer/hotseat/lan/internet games
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7DuelSetupWindowCntl extends H7FlashMovieCntl implements (H7ContentScannerListener)
	dependson(H7StructsAndEnums,H7SkirmishSetupWindowCntl,H7TransitionData)
	native;

var protected H7GFxDuelSetupWindow mDuelSetup;
var protected H7GFxHeroSelection mHeroSelection;
var protected GFxCLIKWidget mBtnBack;
var protected H7GFxLog mChatWindow;
var protected H7Log mChatLog;

var protected bool mIsLoadedGame;
var protected bool mIsHotseat;
var protected bool mHeroSelectionVisible;

var protected H7ListingCombatMap mCombatMapScanner;
var protected array<H7ContentScannerCombatMapData> mMapHeaders;
var protected H7Texture2DStreamLoad mMapThumbnail;

var protected EAIDifficulty mPendingKickAI;

public delegate OnKickDoneDelegate();

static function H7DuelSetupWindowCntl GetInstance() { return class'H7PlayerController'.static.GetPlayerController().GetMainMenuHud().GetDuelSetupWindowCntl(); }

function H7GFxDuelSetupWindow GetDuelWindow() { return mDuelSetup; }

function bool IsMultiplayer() { return class'H7ReplicationInfo'.static.GetInstance().IsMultiplayerGame(); }
function bool IsLAN() { return class'H7ReplicationInfo'.static.GetInstance().IsLAN(); }
function bool IsMaster() { return class'H7PlayerController'.static.GetPlayerController().IsServer(); }
function bool IsHeroSelectionVisible() {return mHeroSelectionVisible;}

function bool Initialize()
{
	;

	Super.Start();

	AdvanceDebug(0);

	mDuelSetup = H7GFxDuelSetupWindow(mRootMC.GetObject("aDuelSetup", class'H7GFxDuelSetupWindow'));
	mDuelSetup.SetVisibleSave(false);

	mHeroSelection = H7GFxHeroSelection(mDuelSetup.GetObject("mHeroSelection", class'H7GFxHeroSelection'));
	mHeroSelection.SetVisibleSave(false);

	mBtnBack = GFxCLIKWidget(mDuelSetup.getObject("mBtnBack", class'GFxCLIKWidget'));
	mBtnBack.AddEventListener('CLIK_click', btnBackClick);

	mChatWindow = H7GFxLog(mDuelSetup.getObject("mChat", class'H7GFxLog'));

	mChatLog = new class'H7Log';
	mChatWindow.Init(mChatLog);

	mMapThumbnail = new class'H7Texture2DStreamLoad';
	mDuelSetup.SetupThumbnailPathTexture(mMapThumbnail);

	Super.Initialize();
	return true;
}

function bool IsHotseat()
{
	return mIsHotseat;
}

function OpenPopup(optional bool hotseat)
{
	local H7ContentScannerCombatMapData combatData;
	
	;

	mIsHotseat = hotseat;

	// 1) set up the screen with all possibilities
	mDuelSetup.SetVisibleSave(true);
	mDuelSetup.Update(); // generates all possibilities

	// 2) change all fields to the current actual settings:
	DisplayMapSettings(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mMapSettings);
	DisplayGameSettings(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mGameSettings);
	DisplayAllPlayerSettings();

	// deactivatation of fields is done by flash after data changes

	mHeroSelection.SetAllHeroes(true);

	GetHUD().SetFocusMovie(self);

	SetPriority(50); // needed for chat input
	H7MainMenuHud(GetHUD()).GetMainMenuCntl().GetMainMenu().SetVisibleSave(false);

	foreach class'H7TransitionData'.static.GetInstance().GetContentScanner().mCollection_CombatData(combatData)
		processMap(combatData);
		
	if(class'H7TransitionData'.static.GetInstance().GetContentScanner().mListeners.Find(self) == INDEX_NONE)
	{
		class'H7TransitionData'.static.GetInstance().GetContentScanner().mListeners.AddItem(self);
	}

	class'H7TransitionData'.static.GetInstance().GetContentScanner().TriggerListing(false, true, false);

	GetHUD().GetLogCntl().GetBorderBlack().SetVisibleSave(true);
}

/////////////////LISTENERS////////////////
event OnScanned_AdventureMap(const out H7ContentScannerAdventureMapData AdvData)
{

}

event OnScanned_CombatMap(const out H7ContentScannerCombatMapData CombatData)
{
	processMap(CombatData);
}

event OnScanned_Campaign(const out H7ContentScannerCampaignData CampaignData)
{

}

function ProcessMaps()
{
	/*local array<H7ContentScannerCombatMapData> polledMaps;
	local H7ContentScannerCombatMapData map;
	local int isDone;
	
	mCombatMapScanner.Poll(polledMaps, isDone);

	`log_gui("MapLister reported"@isDone@"polled maps"@polledMaps.Length);
	
	mDuelSetup.AddMaps(polledMaps);

	foreach polledMaps(map)
	{
		mMapHeaders.AddItem(map); // TODO reset
	}

	if(isDone == 1 || !mDuelSetup.IsVisible())
	{
		mCombatMapScanner.Stop();
		mCombatMapScanner = none;
		mDuelSetup.ListingMapDone(); // OPTIONAL what to do in flash?
	}
	else
		GetHUD().SetFrameTimer(1, ProcessMaps);*/
}

function processMap(H7ContentScannerCombatMapData combatData)
{
	mDuelSetup.AddMap(combatData);

	mMapHeaders.AddItem(combatData); // TODO reset
}

function H7ContentScannerCombatMapData GetMapHeader(string mapFileName)
{
	local H7ContentScannerCombatMapData map;
	
	if(class'H7Loca'.static.GetMapFileNameByPath(class'H7ReplicationInfo'.static.GetInstance().mMapHeaderCombat.Filename) == mapFileName)
	{
		return class'H7ReplicationInfo'.static.GetInstance().mMapHeaderCombat; // keep existing one
	}

	foreach mMapHeaders(map)
	{
		if(class'H7Loca'.static.GetMapFileNameByPath(map.Filename) == mapFileName)
		{
			return map;
		}
	}
	return map; // return empty one	
}

// load map header and display all data
function DisplayMapSettings( out H7LobbyDataMapSettings mapSettings)
{
	local string mapLocaName;
	local H7ContentScannerCombatMapData mapData;

	;

	class'H7ReplicationInfo'.static.GetInstance().mMapHeaderCombat = GetMapHeader(mapSettings.mMapFileName);
	if(class'H7ReplicationInfo'.static.GetInstance().mMapHeaderCombat.Filename == "")
	{
		// error
		;
		return;
	}

	mapData = class'H7ReplicationInfo'.static.GetInstance().mMapHeaderCombat;

	;

	if(mapData.CombatMapData.mIsThumbnailDataAvailable)
	{
		LoadThumbnail(mapData);
	}
	else
	{
		;
	}

	mapLocaName = class'H7Loca'.static.LocalizeMapInfoObjectByName( 
		class'H7ReplicationInfo'.static.GetInstance().mMapHeaderCombat.CombatMapData.mMapInfoObjectName ,
		mapSettings.mMapFileName,
		"mName",
		class'H7ReplicationInfo'.static.GetInstance().mMapHeaderCombat.CombatMapData.mMapName,
		true
	);

	mapLocaName = mapLocaName @ "(" $ mapData.CombatMapData.mMapSizeX @ "x" @ mapData.CombatMapData.mMapSizeY $ ")";

	mDuelSetup.DisplayMapSettings(mapSettings.mMapFileName,mapLocaName);
	CheckStartConditions();
}
function LoadThumbnail(H7ContentScannerCombatMapData mapData)
{
	local int isThumbnailTextureReinitialized;
	
	;
	;
	mMapThumbnail.SwitchStreamingTo(mapData.Filename, mapData.CombatMapData.mThumbnailData, isThumbnailTextureReinitialized);
	;
	if(isThumbnailTextureReinitialized == 1)
	{
		;
		mDuelSetup.SetupThumbnailPathTexture(mMapThumbnail);
	}

	GetHUD().SetFrameTimer(1, UpdateThumbnail);
}
function UpdateThumbnail() // whips the loader so it continues it's work
{
	if(mDuelSetup.IsVisible())
	{
		mMapThumbnail.PerformUpdate();
		GetHUD().SetFrameTimer(1, UpdateThumbnail);
	}
}
function DisplayGameSettings(out H7LobbyDataGameSettings gameSettings)
{
	mDuelSetup.DisplayGameSettings(gameSettings);
	CheckStartConditions();
}
function DisplayAllPlayerSettings()
{
	local int i;
	for(i=0;i<2;i++)
	{
		DisplayPlayerSettings(i,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i]);
	}
}
function DisplayPlayerSettings(int playerIndex, PlayerLobbySelectedSettings playerData)
{
	mDuelSetup.DisplayPlayerSettings(playerIndex,playerData);
	CheckStartConditions();
}
function CheckStartConditions()
{
	local string blockReason;
	local bool canStart;

	if(IsMaster())
	{
		canStart = CanStartDuel(blockReason);
		mDuelSetup.DisplayStartCondition(canStart,blockReason);
	}
}
function bool CanStartDuel(out string blockReason)
{
	if(IsMultiplayer())
	{
		if(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[1].mSlotState == EPlayerSlotState_Open)
		{
			blockReason = "LOBBY_DUEL_NO_CLIENT";
			return false;
		}
		if(!class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[1].mIsReady)
		{
			blockReason = "LOBBY_DUEL_NOT_READY";
			return false;
		}
	}
	return true;
}



// flash induced actions
/////////////////////
// only host
function StartGame()
{
	local string theURL,mapName;
	local H7ContentScannerCombatMapData emptyCombat;
	local H7ListingSavegameDataScene empty2;

	mCombatMapScanner.Stop();

	mapName = class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mMapSettings.mMapFileName;
	;

	theURL = mapName;

	class'H7ReplicationInfo'.static.GetInstance().WriteLobbyDataToTransitionData( true );

	if( IsMultiplayer() )
	{
		// tell clients it's starting
		class'H7PlayerController'.static.GetPlayerController().SendLobbyStartGame( 2 );

		/** TRACKING **/
		TrackGameStart(); 

		if(class'H7ReplicationInfo'.static.GetInstance().IsLAN())
		{
			theURL = theURL $ "?bIsLanMatch=" $ true $ "?listen";
		}
		else
		{
			theURL = theURL $ "?bIsLanMatch=" $ false $ "?listen?stormsocket";
		}

		class'H7ReplicationInfo'.static.GetInstance().UpdateOnlineGameStarted();

		// clear the lobby mapdata
		class'H7TransitionData'.static.GetInstance().SetMPLobbyCombatMapDataToCreate(emptyCombat);
		class'H7TransitionData'.static.GetInstance().SetMPLobbySaveDataToUse(empty2);

		class'H7MainMenuInfo'.static.GetInstance().HostGame(theURL,true,false);
	}
	else
	{
		/** TRACKING **/
		TrackGameStart(); 
		
		class'H7ReplicationInfo'.static.GetInstance().StartMap(theURL);
	}
	class'H7PlayerController'.static.GetPlayerController().SetInLoadingScreen( true );
}

function TrackGameStart()
{
	OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).PushEvent("UTT_GAMEMODE_START", GetGameType(), new class'JsonObject'()  );
}

function string GetGameType()
{
	if( IsLAN() )
	{
		return "DUEL.LAN";
	}

	if( !IsMultiplayer() )
	{
		if( class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[0].mSlotState == EPlayerSlotState_Occupied &&
		    class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[1].mSlotState == EPlayerSlotState_Open) 
		{
			return "DUEL.HOTSEAT";
		}
		else
		{
			return "DUEL.SINGLEPLAYER";
		}
	}
	else 
	{
		return "DUEL.MULTIPLAYER";
	}
	
	return "DUEL";
}


function SetMap(string mapFileName)
{
	local H7OnlineGameSettings gameSettings;
	local H7ContentScannerCombatMapData mapHeader;
	local int mapInfoNumber;

	;

	mapHeader = GetMapHeader(mapFileName);
	mapInfoNumber = Int( Mid( mapHeader.CombatMapData.mMapInfoObjectName, InStr(mapHeader.CombatMapData.mMapInfoObjectName,"_") + 1 ) );

	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mMapSettings.mMapFileName = mapFileName;

	gameSettings = class'H7MultiplayerGameManager'.static.GetOnlineGameSettings();
	if(gameSettings != none)
	{
		gameSettings.SetMapFilepath(mapFileName);
		gameSettings.SetMapInfoNumber(mapInfoNumber);
		if( !gameSettings.bIsLanMatch )
		{
			class'GameEngine'.static.GetOnlineSubsystem().GameInterface.UpdateOnlineGame( 'H7GameSession', gameSettings, true );
		}
	}

	DisplayMapSettings(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mMapSettings);
}

function SetSpeedCombat(float val)
{
	local H7OnlineGameSettings onlineSettings;

	val = float(int(val*100))/100.f;

	onlineSettings = class'H7MultiplayerGameManager'.static.GetOnlineGameSettings();
	if( onlineSettings != none )
	{
		onlineSettings.SetGameSpeedCombat( val );

		if( !onlineSettings.bIsLanMatch )
		{
			class'GameEngine'.static.GetOnlineSubsystem().GameInterface.UpdateOnlineGame( 'H7GameSession', onlineSettings, true );
		}
	}

	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mGameSettings.mGameSpeedCombat = val;
}

function SetCombatTimer(int value)
{
	local H7OnlineGameSettings onlineSettings;

	onlineSettings = class'H7MultiplayerGameManager'.static.GetOnlineGameSettings();
	if( onlineSettings != none )
	{
		onlineSettings.SetTimerCombat( ETimerCombat(value) );

		if( !onlineSettings.bIsLanMatch )
		{
			class'GameEngine'.static.GetOnlineSubsystem().GameInterface.UpdateOnlineGame( 'H7GameSession', onlineSettings, true );
		}
	}

	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mGameSettings.mTimerCombat = ETimerCombat(value);
}

// attacker START_POSITION_1
// defender START_POSITION_2
function SetPlayerPosition(int playerIndex,int positionEnum)
{
	local H7OnlineGameSettings onlineSettings;
	local int otherIndex;
	local EStartPosition otherPosition;
	;
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mPosition = EStartPosition(positionEnum);
	DisplayPlayerSettings(playerIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex]);

	otherIndex = playerIndex == 0 ? 1 : 0;
	otherPosition = EStartPosition(positionEnum) == START_POSITION_1 ? START_POSITION_2 : START_POSITION_1;
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[otherIndex].mPosition = otherPosition;
	DisplayPlayerSettings(otherIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[otherIndex]);

	onlineSettings = class'H7MultiplayerGameManager'.static.GetOnlineGameSettings();
	if( onlineSettings != none )
	{
		// defender = 0
		// attacker = 1
		onlineSettings.SetSkillType( class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[otherIndex].mPosition == START_POSITION_1 ? 1 : 0 );

		if( !onlineSettings.bIsLanMatch )
		{
			class'GameEngine'.static.GetOnlineSubsystem().GameInterface.UpdateOnlineGame( 'H7GameSession', onlineSettings, true );
		}
	}
}
// slotType 0=closed, 1=open/player, 2,3,4=ai
function SetPlayerSlot(int playerIndex,int slotType)
{
	;
	if(class'H7PlayerController'.static.GetPlayerController().IsServer() && playerIndex == 1)
	{
		if(slotType == 1) // if needed && class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mSlotState == EPlayerSlotState_Closed) 
		{
			class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mSlotState = EPlayerSlotState_Open;
			class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mIsReady = false;
		}
		else // set it to AI
		{
			if( class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mSlotState == EPlayerSlotState_Occupied )
			{
				mPendingKickAI = EAIDifficulty(slotType-2);
				KickPlayerPopup( playerIndex , KickAIDone );
			}
			else // "open" changed to "AI"
			{
				class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mAIDifficulty = EAIDifficulty(slotType-2);
				class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mSlotState = EPlayerSlotState_AI;
			}
		}
		class'H7ReplicationInfo'.static.GetInstance().LobbyUpdateOnlineGameSettingsSlots();
		DisplayPlayerSettings(playerIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex]);
	}
}
function KickPlayer(int playerIndex) // flash button pressed
{
	if(playerIndex == 0)
	{
		;
		return;
	}
	if( class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mSlotState == EPlayerSlotState_Occupied )
	{
		class'H7ReplicationInfo'.static.PrintLogMessage("KickPlayer" @ playerIndex @ class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mName, 0);;
		KickPlayerPopup( playerIndex , KickDone);
	}
}
function KickPlayerPopup(int playerIndex, delegate<OnKickDoneDelegate> callback)
{
	OnKickDoneDelegate = callback;
	class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().YesNoPopup(
		Repl(class'H7Loca'.static.LocalizeSave("KICK_CONFIRM","H7SkirmishSetup"),"%name",class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mName)
		,"YES","CANCEL",KickConfirm,none,true
	);
}
function KickConfirm()
{
	class'H7GameInfo'.static.GetH7GameInfoInstance().Kick( class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[1].mName );
	OnKickDoneDelegate();
}
function KickAIDone()
{
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[1].mSlotState = EPlayerSlotState_AI;
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[1].mAIDifficulty = mPendingKickAI;
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[1].mIsReady = true;
	class'H7ReplicationInfo'.static.GetInstance().LobbyUpdateOnlineGameSettingsSlots();
	UpdateAfterPlayerLeaving( 1 );
}
function KickDone()
{
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[1].mSlotState = EPlayerSlotState_Open;
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[1].mIsReady = false;
	class'H7ReplicationInfo'.static.GetInstance().LobbyUpdateOnlineGameSettingsSlots();
	UpdateAfterPlayerLeaving( 1 );
}
function UpdateAfterPlayerLeaving( int playerIndex )
{
	SetNewList("mDropClientSlot",GetEnumList("ESlot",playerIndex),playerIndex);
	DisplayPlayerSettings(playerIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex]);
}
function SetNewList(string dropDownName,array<H7DropDownEntry> list,optional int playerIndex=INDEX_NONE,optional bool blockSendingToUnreal)
{
	mDuelSetup.SetNewList(dropDownName,list,playerIndex,blockSendingToUnreal);
}

function SetHeroSelectionVisible(bool visible)
{
	mHeroSelectionVisible = visible;
}
/////////////////////
// host + client
function SetPlayerArmy(int playerIndex, int armyIndex)
{
	local array<H7EditorArmy> availableArmies;

	if( class'H7PlayerController'.static.GetPlayerController().IsServer() )
	{
		availableArmies = class'H7GameData'.static.GetInstance().GetDuelArmies(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mFaction);
		armyIndex = Clamp(armyIndex,0,availableArmies.Length-1);
		class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mArmy = availableArmies[armyIndex];
		DisplayPlayerSettings(playerIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex]);
		mDuelSetup.DisplayArmy(playerIndex,armyIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mArmy);
	}
	else
	{
		class'H7PlayerController'.static.GetPlayerController().ServerLobbySetPlayerArmy( playerIndex, armyIndex );
	}
}

function SetPlayerColor(int playerIndex, int selectedColorEnum)
{
	local EPlayerColor selectecdColor;
	local int i;

	if( class'H7PlayerController'.static.GetPlayerController().IsServer() )
	{
		// who has this color?
		selectecdColor = EPlayerColor(selectedColorEnum);
		for(i=0;i<8;i++)
		{
			if(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mColor == selectecdColor)
			{
				class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mColor = class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mColor;
				DisplayPlayerSettings(i,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i]);
			}
		}
		class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mColor = selectecdColor;
		DisplayPlayerSettings(playerIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex]);
	}
	else
	{
		class'H7PlayerController'.static.GetPlayerController().ServerLobbySetPlayerColor( playerIndex, selectedColorEnum );
	}
}

function SetPlayerReady(int playerIndex, bool isReady)
{
	;
	if( class'H7PlayerController'.static.GetPlayerController().IsServer() )
	{
		class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mIsReady = isReady;
		DisplayPlayerSettings(playerIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex]);
	}
	else
	{
		class'H7PlayerController'.static.GetPlayerController().SendPlayerReady( playerIndex, isReady );
	}
}
function SetPlayerHero(int playerIndex, string heroArchetypeID)
{
	;
	if( class'H7PlayerController'.static.GetPlayerController().IsServer() )
	{
		class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mStartHero = class'H7GameData'.static.GetInstance().GetHeroByArchetypeID( heroArchetypeID );
		if( !class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() )
		{
			class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mStartHeroRef = Pathname(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mStartHero);
		}
		SetPlayerFaction(playerIndex,class'H7GameData'.static.GetInstance().GetHeroByArchetypeID( heroArchetypeID ).GetFaction().GetArchetypeID());
		DisplayPlayerSettings(playerIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex]);
	}
	else
	{
		class'H7PlayerController'.static.GetPlayerController().ServerLobbySetPlayerHero( playerIndex, heroArchetypeID );
	}
}
function SetPlayerFaction(int playerIndex, string factionArchetypeID)
{
	local int armyIndex;

	;
	if( class'H7PlayerController'.static.GetPlayerController().IsServer() )
	{
		class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mFaction = class'H7GameData'.static.GetInstance().GetFactionByArchetypeID( factionArchetypeID );
		class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mFactionRef = factionArchetypeID;

		armyIndex = class'H7GameData'.static.GetInstance().GetDuelArmyIndex(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mArmy,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mFaction);
		if(armyIndex == INDEX_NONE)
		{
			class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mArmy = class'H7GameData'.static.GetInstance().GetDuelArmy(0,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mFaction);
		}

		DisplayPlayerSettings(playerIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex]);
	}
	else
	{
		class'H7PlayerController'.static.GetPlayerController().ServerLobbySetPlayerFaction( playerIndex, factionArchetypeID );
	}
}
function btnBackClick(EventData data)
{
	ClosePopup();
}
function ClosePopup()
{
	if(class'H7ReplicationInfo'.static.GetInstance().IsMultiplayerGame())
	{
		if(class'H7PlayerController'.static.GetPlayerController().IsServer())
		{
			class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().YesNoPopup("PU_LOBBY_DESTROY_CONFIRM","YES","NO",ClosePopupForReal,none,true);
		}
		else
		{
			class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().YesNoPopup("PU_LOBBY_QUIT_CONFIRM","YES","NO",ClosePopupForReal,none,true);
		}
	}
	else
	{
		ClosePopupForReal();
	}
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

function CloseHeroSelection()
{
	mHeroSelection.SetVisibleSave(false);
	mHeroSelectionVisible = false;
}

function ClosePopupForReal()
{
	local H7ContentScannerCombatMapData empty; 

	mCombatMapScanner.Stop();
	
	class'H7TransitionData'.static.GetInstance().GetContentScanner().mListeners.RemoveItem(self);

	mHeroSelectionVisible = false;

	if(class'H7ReplicationInfo'.static.GetInstance().IsMultiplayerGame())
	{
		// multiplayer host or multiplayer client -> back to main menu (map reload)
		if( class'H7PlayerController'.static.GetPlayerController().IsServer() )
		{
			class'H7TransitionData'.static.GetInstance().SetMPLobbyCombatMapDataToCreate(empty);
			class'GameEngine'.static.GetOnlineSubsystem().GameInterface.DestroyOnlineGame('H7GameSession');

			// TODO MP tell all clients the lobby was destroyed by setting their tansitiondata:
			//class'H7TransitionData'.static.GetInstance().SetMPServerCancelledLobbySession(true);
		}
		class'H7TransitionData'.static.GetInstance().SetMPClientCancelledLobbySession( true );
		class'H7ReplicationInfo'.static.GetInstance().GoToMainMenu();
	}
	else
	{
		// singleplayer -> back to main menu
		mDuelSetup.Reset();
		mHeroSelection.Reset();
		mDuelSetup.SetVisibleSave(false);

		GetHUD().GetLogCntl().GetBorderBlack().SetVisibleSave(false);

		class'H7MainMenuHud'.static.GetInstance().GetMainMenuCntl().GetMainMenu().SetVisibleSave(true);
	}
	
	
}

//////////////////////////////////////////////////////////////////////////////////////////////7
// HELPER TO GET POSSIBLE SETTINGS
//////////////////////////////////////////////////////////////////////////////////////////////7

// unreal has to generate list of possible entries for 1 specific drop down field
function array<H7DropDownEntry> GetEnumList(string enumName,optional int playerIndex)
{
	local array<H7DropDownEntry> list;
	;

 	switch(enumName)
	{
		case "ETimerCombat":
			return GetEnumListByObject(TIMER_COMBAT_MAX,Enum'ETimerCombat');
		break;
		// player row
		case "ESlot":
			if(playerIndex == 1)
			{
				AddEntry(list,"CLOSED",0,false);
				if(class'H7ReplicationInfo'.static.GetInstance().IsMultiplayerGame())
				{
					// if there is a human here, show his name
					if(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mSlotState == EPlayerSlotState_Occupied) 
					{
						AddEntry(list,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mName,1);
					}
					else // you can not open slots in loaded games (but already existing slots can be)
					{
						AddEntry(list,"OPEN",1);
					}
				}
				else 
				{
					if(IsHotseat()) // hotseat human
						AddEntry(list,"HUMAN",1);
					else
						AddEntry(list,"HUMAN",1,false);
				}

				if(!class'H7ReplicationInfo'.static.GetInstance().IsMultiplayerGame())
				{
					//AddEntry(list,"AI_DIFFICULTY_EASY",2);
					AddEntry(list,"AI_DIFFICULTY_NORMAL_DUEL",3);
					//AddEntry(list,"AI_DIFFICULTY_HARD",4);
				}
			}
		break;
		case "EPlayerColor":
			return GetColorEnumList();
			//return GetEnumListByObject(PCOLOR_MAX,Enum'EPlayerColor');
		case "EStartPosition":
			if(playerIndex == 0)
			{
				AddEntry(list,FlashLocalize("DUEL_POSITION_1"),1);
				AddEntry(list,FlashLocalize("DUEL_POSITION_2"),2);
			}
		case "EFaction":
			//return GetFactionEnumList(playerIndex);
	}

	return list;
}

function AddEntry(out array<H7DropDownEntry> list,string caption,int data,optional bool enabled=true,optional string strData="",optional string icon)
{
	local H7DropDownEntry entry;
	entry.Caption = caption;
	entry.Data = data;
	entry.Enabled = enabled;
	entry.StrData = strData;
	entry.Icon = icon;
	entry.Color = "-1";
	list.AddItem(entry);
}

function array<H7DropDownEntry> GetColorEnumList()
{
	local H7DropDownEntry entry;
	local array<H7DropDownEntry> list;
	local array<EPlayerColor> skirmishColors;
	local int i;
	//local Name enumName;

	skirmishColors = class'H7GameUtility'.static.GetSkirmishColors();

	for(i=0;i<skirmishColors.Length;i++)
	{
		//enumName = GetEnum(Enum'EPlayerColor', i);
		entry.Caption = "";//String(enumName);
		entry.Data = skirmishColors[i];
		entry.Icon = "img://H7TextureGUI.GUI_Unit_Background";
		entry.Color = UnrealColorToFlashColor(class'H7GameUtility'.static.GetColor(skirmishColors[i]));
		list.AddItem(entry);
	}
	return list;
}

function array<H7DropDownEntry> GetEnumListByObject(int enumMax,Object enumObject) 
{
	local H7DropDownEntry entry;
	local array<H7DropDownEntry> list;
	local int i;
	local Name enumName;

	for(i=0;i<enumMax;i++)
	{
		enumName = GetEnum(enumObject, i);
		entry.Caption = String(enumName);
		entry.Data = i;
		list.AddItem(entry);
	}
	return list;
}


function array<String> GetHeroesEnumList(int playerIndex, optional bool showHeroSelectionPopUp = false, optional H7Faction faction = none)
{
	local array<String> list;
	local int i;
	local H7EditorHero hero;
	local array<H7EditorHero> heroPool;
	local array<H7EditorHero> privilegeHeroes;
	local array<H7EditorHero> randomHeroesPool;

	// get hero pool
	class'H7GameData'.static.GetInstance().GetDuelHeroes(heroPool);
	class'H7GameData'.static.GetInstance().GetPrivilegHeroesDuel(privilegeHeroes);
	class'H7GameData'.static.GetInstance().GetRandomHeroes(randomHeroesPool);

	//merge lists
	ForEach randomHeroesPool(hero)
		heroPool.AddItem(hero);

	heroPool.AddItem(class'H7GameData'.static.GetInstance().GetRandomHero());

	ForEach privilegeHeroes(hero)
			heroPool.AddItem(hero);

	for(i = 0; i < heroPool.Length; i++)
	{
		hero = heroPool[i];
			
		//if a faction was passed as argument, then check if the hero matches the faction...
		if(faction != none)
		{
			if(faction == hero.GetFaction())
			{
				list.AddItem(hero.GetArchetypeID());
				;
			}
		}
		else // ...else if no faction was passed then just add the hero
		{
			list.AddItem(hero.GetArchetypeID());
			;
		}	
	}
	
	if(showHeroSelectionPopUp)
	{
		;
		mHeroSelection.Update(list, 
			                  playerIndex, 
			                  class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mStartHero.GetArchetypeID(), 
			                  class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mColor
			                  );
	}
	return list;
}

function GetHeroInfo(string heroArchetypeID)
{
	local array<H7EditorHero> heroes;
	local H7EditorHero hero;

	class'H7GameData'.static.GetInstance().GetDuelHeroes(heroes, true);
;
	foreach heroes(hero)
	{
		if(hero.GetArchetypeID() == heroArchetypeID)
		{
			mHeroSelection.UpdateHeroInfoDuel(hero);
			return;
		}
	}
;
}

//////////////////////////////////////////////////////////////////////////////////////////////7
// CHAT
//////////////////////////////////////////////////////////////////////////////////////////////7

// flash calls this
function SendChatLine(string line)
{
	;
	class'H7PlayerController'.static.GetPlayerController().SendLobbyChat( line );
}

// call this to add a message to the chat-gui
function AddChatLine(string line,string playerName)
{
	//local H7MessageSettings settings;
	local H7Message message;
	;
	
	message = new class'H7Message';
	if(playerName != "")
	{
		message.text = playerName $ ":" @ line;
	}
	else
	{
		message.text = "<font color='#ffff00'>" $ line $ "<font>";
	}

	mChatLog.AddMessage(message);
	//mChatLog.AddMessage();
}


