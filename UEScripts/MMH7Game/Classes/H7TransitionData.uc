//=============================================================================
// H7TransitionData
//
// Map Setup Data that is send from menu to the map to set itself up
// and now also to describe the state of the game
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7TransitionData extends Object 
	config(Game)
	native
;

/** :::::::: Persistant variables that stay forever while the game runs (OPTIONAL should technically get a new class) :::::::: */

var protected H7GameData                    mGameData;          // GameData currently used by the game
var protected H7PlayerProfile               mPlayerProfile;     // player currently playing the game
var protected H7ContentScanner              mContentScanner;

/** :::::::: Temporary variables only used for transitions :::::::: */

// special case for transition from main/load menu to server main menu map
var protected H7ContentScannerCombatMapData mMPLobbyCombatMapDataToCreate;
var protected H7ContentScannerAdventureMapData mMPLobbyMapDataToCreate;
var protected H7ListingSavegameDataScene    mMPLobbySaveDataToUse;

// special case for transition into Council Room Hub Map
var protected transient string              mPendingHubMatinee; // name of the matinee that should be played, if councilmap loading is completed
var protected transient ECouncilState       mPendingHubState; // state of councilhub that should be entered when CH is loaded

var protected string                        mPreviousMapName; // name of the matinee that should be played, if councilmap loading is completed

// special case for lobby exits
var protected bool							mClientWasKicked;
var protected bool							mClientCancelledLobbySession;
var protected bool							mServerCancelledLobbySession;
var protected bool							mClientSavegameNeededLobbySession;
var protected bool							mClientLostConnectionToServer;
var protected bool							mServerLostConnectionToClients;

//To identify a maptransition for the soundcontroller
var protected bool                          mIsInMapTransition;
var protected bool                          mIsReplayCombat;
var protected bool                          mIsMainMenu;

var protected bool                          mIsLoadingSave;
var protected bool                          mIsLoadedGame;
var protected H7SavegameTask_Loading        mLoadingTask;

// lobby settings
var protected bool                          mUseMe;
var protected bool                          mUseMeForCampaign;
var protected array<PlayerLobbySelectedSettings> mPlayersSettings;
var protected H7LobbyDataMapSettings        mMapSettings;
var protected H7LobbyDataGameSettings       mGameSettings;

var protected H7CampaignDefinition          mCampaignDefinition;

static native function H7TransitionData GetInstance();

public delegate OnReadyForMatinee();

/**  :::::::  SET :::::::::  */
function SetPlayersSettings(array <PlayerLobbySelectedSettings> mapPlayersInfo )   { mPlayersSettings = mapPlayersInfo; }
function SetMapSettings(H7LobbyDataMapSettings mapSettings)                 { mMapSettings = mapSettings; }
function SetGameSettings(H7LobbyDataGameSettings gameSettings)              { mGameSettings = gameSettings; }
function SetForceQuickCombat( int value )                                   { mGameSettings.mForceQuickCombat = EForceQuickCombat(value); }
function SetTeamSetup( int value )                                          { mMapSettings.mTeamSetup = ETeamSetup(value); }
function SetUseMe(bool value)                                               { mUseMe = value; }
function SetTeamTrade( bool value )                                         { mGameSettings.mTeamsCanTrade = value; }
function SetUseMapDefaults(bool useMapDefaults)                             { mMapSettings.mUseDefaults = useMapDefaults; }
function SetPendingMatinee( string matineeName )                            { mPendingHubMatinee = matineeName; }
function SetPlayerProfile( H7PlayerProfile profile )                        { mPlayerProfile = profile; }
function SetMPLobbySaveDataToUse(H7ListingSavegameDataScene saveData)       { mMPLobbySaveDataToUse = saveData; }
function SetMPLobbyMapDataToCreate(H7ContentScannerAdventureMapData mapData)                { mMPLobbyMapDataToCreate = mapData; }
function SetMPLobbyCombatMapDataToCreate(H7ContentScannerCombatMapData mapData)    { mMPLobbyCombatMapDataToCreate = mapData; }
function SetMPClientWasKicked(bool clientWasKicked)							{ mClientWasKicked = clientWasKicked; }
function SetMPClientCancelledLobbySession(bool clientCancelledLobbySession) { mClientCancelledLobbySession = clientCancelledLobbySession; }
function SetMPServerCancelledLobbySession(bool serverCancelledLobbySession) { mServerCancelledLobbySession = serverCancelledLobbySession; }
function SetIsInMapTransition(bool value)                                   { mIsInMapTransition = value; }
function SetMPClientSavegameNeededLobbySession(bool clientSavegameNeededLobbySession) { mClientSavegameNeededLobbySession = clientSavegameNeededLobbySession; }
function SetMPClientLostConnectionToServer(bool clientLostConnectionToServer) { mClientLostConnectionToServer = clientLostConnectionToServer; }
function SetMPServerLostConnectionToClients(bool serverLostConnectionToClients) { mServerLostConnectionToClients = serverLostConnectionToClients; }
function SetLoadingSave( bool b )                                           { mIsLoadingSave = b; }
function SetLoadedGame( bool b )                                            { mIsLoadedGame = b; }
function SetCurrentLoadTask( H7SavegameTask_Loading task )                  { mLoadingTask = task; }
function SetIsReplayCombat(bool val)                                        { mIsReplayCombat = val; }
function SetPreviousMapName(string val)                                     { if( !mIsReplayCombat ) { mPreviousMapName = val; } }
function SetIsMainMenu(bool val)                                            { mIsMainMenu = val; }
function SetCampaignDefinition( H7CampaignDefinition newCampaign)           { mCampaignDefinition = newCampaign; }
function SetPendingCouncilState(ECouncilState newState)                     { mPendingHubState = newState; }
function SetContentScanner(H7ContentScanner scanner)                        { mContentScanner = scanner; }

/**  :::::::  GET :::::::::  */
//function EForceQuickCombat					GetForceQuickCombat()               { return mGameSettings.mForceQuickCombat; }
//function bool									GetTeamTrade()                      { return mGameSettings.mTeamsCanTrade; }
//function bool									GetRandomSkilling()                 { return mGameSettings.mUseRandomSkillSystem; }
function array<PlayerLobbySelectedSettings>		GetPlayersSettings()				{ return mPlayersSettings; }
function ETeamSetup								GetTeamSetup()                      { return mMapSettings.mTeamSetup; }
function bool									UseMe()                             { return mUseMe; }
function bool                                   UseForCampaign()                    { return mUseMeForCampaign; }
function H7GameData								GetGameData()                       { return mGameData; }
function bool									UseMapDefaults()                    { return mMapSettings.mUseDefaults; }
function string									GetPendingMatinee()                 { return mPendingHubMatinee; }
function H7PlayerProfile						GetPlayerProfile()                  { return mPlayerProfile; }
function H7ListingSavegameDataScene             GetMPLobbySaveDataToUse()           { return mMPLobbySaveDataToUse; }
function H7ContentScannerAdventureMapData		GetMPLobbyMapDataToCreate()         { return mMPLobbyMapDataToCreate; }
function H7ContentScannerCombatMapData     		GetMPLobbyCombatMapDataToCreate()   { return mMPLobbyCombatMapDataToCreate; }
function H7LobbyDataMapSettings                 GetMapSettings()                    { return mMapSettings; }
function H7LobbyDataGameSettings                GetGameSettings()                   { return mGameSettings; }
function bool									GetMPClientWasKicked()				{ return mClientWasKicked; }
function bool									GetMPClientCancelledLobbySession()	{ return mClientCancelledLobbySession; }
function bool									GetMPServerCancelledLobbySession()	{ return mServerCancelledLobbySession; }
function bool									GetMPServerLostConnectionToClients() { return mServerLostConnectionToClients; }
function bool									GetIsInMapTransition()	            { return mIsInMapTransition; }
function bool									GetMPClientSavegameNeededLobbySession()	{ return mClientSavegameNeededLobbySession; }
function bool									GetMPClientLostConnectionToServer()	{ return mClientLostConnectionToServer; }
function bool                                   IsLoadingSave()                     { return mIsLoadingSave; }
function bool                                   IsLoadedGame()                      { return mIsLoadedGame; }
function H7SavegameTask_Loading                 GetCurrentLoadTask()                { return mLoadingTask; }
function bool                                   GetIsReplayCombat()                 { return mIsReplayCombat; }
function string                                 GetPreviousMapName()                { return mPreviousMapName; }
function bool                                   GetIsMainMenu()                     { return mIsMainMenu; }
function ECouncilState                          GetPendingCouncilState()            { return mPendingHubState; }
function H7ContentScanner                       GetContentScanner()                 { return mContentScanner; }
function string                                 GetTutorialMapFileName()            { return "SCE_Tutorial"; }

// only works during map time!
function SetupPlayers()
{
	local PlayerLobbySelectedSettings playerSetting;
	local array<H7EditorHero> randomHeroes;
	local int i;

	if (mMapSettings.mUseRandomStartPosition)
	{
		SetRandomStartPositions();
		//ShufflePlayerPositions();
	}
	else
	{
		AdjustDuplicateStartPositions();
	}

	i = 0;
	class'H7GameData'.static.GetInstance().GetRandomHeroes(randomHeroes);
	ForEach mPlayersSettings(playerSetting, i)
	{
		// check if the player chose a random hero
		if( mPlayersSettings[i].mStartHero == class'H7GameData'.static.GetInstance().GetRandomHero() )
		{
			mPlayersSettings[i].mStartHero = randomHeroes[ class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( randomHeroes.Length ) ];
			mPlayersSettings[i].mStartHeroRef = mPlayersSettings[i].mStartHero.GetArchetypeID();
			mPlayersSettings[i].mFaction = mPlayersSettings[i].mStartHero.GetFaction();
			mPlayersSettings[i].mFactionRef = mPlayersSettings[i].mFaction.GetArchetypeID();
		}

		if(randomHeroes.Find(mPlayersSettings[i].mStartHero) != INDEX_NONE)
		{
			SetRandomHeroForPlayer(i);
		}
	}

}

function SetPlayerArmySettings(int playerIndex, H7Faction faction, H7EditorHero hero, H7EditorArmy army)
{
	mPlayersSettings[playerIndex].mFaction = faction;
	if( !class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() )
	{
		mPlayersSettings[playerIndex].mFactionRef = Pathname(faction);
	}
	mPlayersSettings[playerIndex].mStartHero = hero;
	if( !class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() )
	{
		mPlayersSettings[playerIndex].mStartHeroRef = Pathname(hero);
	}
	mPlayersSettings[playerIndex].mArmy = army;
}

// Checks if during map start there was an CampaignDef declared -> if so, consume it and return true
function bool IsStartingCampaign(optional out H7CampaignDefinition campRef)
{
	if(mCampaignDefinition != none)
	{
		campRef = mCampaignDefinition;
		// Consume kept mCampaignDefinition
		mCampaignDefinition = none;

		return true;
	}

	campRef = none;
	return false;
}


private function SetRandomHeroForPlayer(int playerIndex)
{
	local PlayerLobbySelectedSettings playerSetting;
	local array<H7EditorHero> allHeroes;
	local array<H7EditorHero> factionHeroes;
	local H7EditorHero hero;

	class'H7GameData'.static.GetInstance().GetHeroes(allHeroes, true);

	ForEach allHeroes(hero)
	{	
		if(hero.GetFaction() == mPlayersSettings[playerIndex].mStartHero.GetFaction() && 
		   class'H7ReplicationInfo'.static.GetInstance().GetMapHeaderPlayerInfoByLobbyPlayerIndex(playerIndex).ForbiddenHeroes.Find(hero.GetArchetypeID()) == INDEX_NONE)
			factionHeroes.AddItem(hero);
	}

	// remove heroes of other players
	ForEach mPlayersSettings(playerSetting)
	{
		if(factionHeroes.Find(playerSetting.mStartHero) != INDEX_NONE)
		{
			factionHeroes.RemoveItem(playerSetting.mStartHero);
		}
	}

	mPlayersSettings[playerIndex].mStartHero = factionHeroes[class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(factionHeroes.Length)];
	if( !class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() )
	{
		mPlayersSettings[playerIndex].mStartHeroRef = Pathname(mPlayersSettings[playerIndex].mStartHero);
	}
}

private function SetRandomStartPositions()
{
	local array<EStartPosition> availableStartPositions;
	local EStartPosition chosenPosition;
	local int i, startingPosCount;

	availableStartPositions = class'H7AdventureController'.static.GetInstance().GetMapInfo().GetAvailableStartPositions();
	startingPosCount = availableStartPositions.Length;

	for( i = 0; i < startingPosCount; ++i )
	{
		if(availableStartPositions.Length > 0)
		{
			chosenPosition = availableStartPositions[class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(availableStartPositions.Length)];
			mPlayersSettings[i].mPosition = chosenPosition;
			availableStartPositions.RemoveItem(chosenPosition);
		}
		else
		{
			;
		}
	}
}

private function AdjustDuplicateStartPositions()
{
	local int i, j, startingPosCount;
	local array<EStartPosition> availableStartPositions;

	availableStartPositions = class'H7AdventureController'.static.GetInstance().GetMapInfo().GetAvailableStartPositions();
	startingPosCount = availableStartPositions.Length;

	// remove the positions taken by actual real player from available positions
	for( i = 0; i < startingPosCount; ++i )
	{
		if( mPlayersSettings[i].mSlotState != EPlayerSlotState_Closed )
		{
			for(j=0; j < availableStartPositions.Length; j++)
			{
				if(availableStartPositions[j] == mPlayersSettings[i].mPosition)
				{
					availableStartPositions.Remove(j, 1);
					break;
				}
			}
		}
	}

	// distribute the remaining positions to closed slots
	for( i = 0; i < startingPosCount; ++i )
	{
		if( mPlayersSettings[i].mSlotState == EPlayerSlotState_Closed )
		{
			mPlayersSettings[i].mPosition = availableStartPositions[0];
			availableStartPositions.Remove(0, 1);
		}
	}
}

// during lobby time, the players will be
// row1 player1 position2
// row2 player2 position3
// row3 player3 position1
// ..
// during game time, the players will be
// player1 will get settings of row3
// player2 will get settings of row1
// player3 will get settings of row2
function PlayerLobbySelectedSettings GetPlayerSettingsDuringGameTime(EPlayerNumber number)         
{ 
	local PlayerLobbySelectedSettings empty;
	local PlayerLobbySelectedSettings playerSettings;

	foreach mPlayersSettings(playerSettings)
	{
		if(int(playerSettings.mPosition) == int(number)) 
		{
			return playerSettings;
		}
	}
	;
	return empty;
}

// returns the number of human players existing in the mPlayersSettings
function int GetHumanPlayersCounter()
{
	local int i, humansCounter;
	
	humansCounter = 0;
	for( i=0; i < mPlayersSettings.Length; ++i )
	{
		if( mPlayersSettings[i].mSlotState == EPlayerSlotState_Occupied )
		{
			++humansCounter;
		}
	}
	return humansCounter;
}

event H7Faction GetPlayerFactionDuringGameTime(EPlayerNumber number)
{
	local PlayerLobbySelectedSettings prop;
	prop = GetPlayerSettingsDuringGameTime(number);

	if(prop.mFaction == none && prop.mFactionRef != "")
	{
		return class'H7GameData'.static.GetInstance().GetFactionByArchetypeID( prop.mFactionRef );
	}
	return prop.mFaction;
}

event H7EditorHero GetPlayerStartHeroDuringGameTime(EPlayerNumber number)
{
	local PlayerLobbySelectedSettings prop;
	prop = GetPlayerSettingsDuringGameTime(number);

	if(prop.mStartHero == none && prop.mStartHeroRef != "")
	{
		return H7EditorHero( DynamicLoadObject( prop.mStartHeroRef , class'H7EditorHero') );
	}

	return prop.mStartHero;
}

event EVictoryCondition GetSelectedVictoryCondition()
{
	return mMapSettings.mVictoryCondition;
}

// OPTIONAL there could be a better class for this
function SetReadyForMatineeListener(delegate<OnReadyForMatinee> callBackFunction)
{
	OnReadyForMatinee = callBackFunction;
}
function TriggerReadyForMatineeListener()
{
	if(OnReadyForMatinee != none)
	{
		OnReadyForMatinee();
		OnReadyForMatinee = none;
	}
}

function ResetLobbyData()
{
	local H7LobbyDataMapSettings emptyDataMap;
	local H7LobbyDataGameSettings emptyGameSettings;

	// lobby settings
	mUseMe = false;
	mUseMeForCampaign = false;
	mPlayersSettings.Length = 0;
	mMapSettings = emptyDataMap;
	mGameSettings = emptyGameSettings;

	// special case for lobby exits
	mClientWasKicked = false;
	mClientCancelledLobbySession = false;
	mServerCancelledLobbySession = false;
	mClientSavegameNeededLobbySession = false;
	mClientLostConnectionToServer = false;
	mServerLostConnectionToClients = false;

	mIsLoadingSave = false;
	mIsLoadedGame = false;
	class'H7ReplicationInfo'.static.PrintLogMessage("ResetLobbyData", 0);;
}


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
