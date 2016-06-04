//=============================================================================
// H7ReplicationInfo
// GameReplicationInfo that is used by both adventure and combat, DO NOT SPLIT in two.
//
// IMPORTANT: the functions that need to be executed also in the client need to be simulated 
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7ReplicationInfo extends GameReplicationInfo
						config(game)
						dependson(H7ListingSavegame)
						implements(H7IGUIListenable)
						native;

const TARGETABLE_ARRAY_PAGE_SIZE = 1000;

var protected H7MultiplayerGameManager          mMultiplayerGameManager;
var protected H7ControllerManager				mControllerManager;
var protected H7GameProcessor                   mGameProcessor;
var protected H7CommandQueue                    mCommandQueue;
var protected H7InstantCommandManager           mInstantCommandManager;
var protected H7MultiplayerCommandManager		mMpCommandManager;
var protected H7SimTurnCommandManager			mSimTurnCommandManager;
var protected int								mUnitActionsCounter; // counter that is increased every time a unit do an action
var protected int								mCombatUnitTurnCounter; // counter that is increased when a unit finished its turn

var protected int                               mGameStateCounter; //counter that is increased whenever game changing event happens

var protected transient H7SoundManager          mSoundManager;

var protected H7SynchRNG						mSynchRNG;
var bool bIsReturningToMainMenu;

var array<H7IEventManagingObject>				mEventManageables;

var protected bool								mIsAdventureMap;	// true -> the current dominant mode is adventure map, false -> is combat map
var protected bool								mIsSimTurns;		// true -> the current dominant mode is adventure map Sim turns, false -> is adventure map normal mode
var protected bool								mIsLoadedGame;		// true -> the game was loaded from a save game, false -> is a new game
var protected bool								mIsAutoSaveEnabled;	// true -> the current dominant mode is adventure map Sim turns, false -> is adventure map normal mode
var bool								        mIsTutorial;   // true -> auto save is supressed even if enabled
var bool								        mSupressTactics;    // true -> tactic phase is skipped

var protected int								mIdCounter;

// this gamespeed is only applied to gameplay objects (heros, creatures, ...) and not to all the objects
var config float								cGameSpeedAdventure;
var config float								cGameSpeedAdventureAI;
var config float								cGameSpeedCombat;
// If true normal (1.0f) speed is enabled (used during cutscenes etc.)
var protected bool                              mNormalGameSpeed;

var protected array<name>						mPreviousStreamingLevels;
var protected bool								mIsReplayCombat;

var protected H7PostprocessManager				mPostprocessManager;

var protected float				                mFrameStartTime;
var protected bool                              mReadyToLoad;

// This is the targeted unit which can be teleported with a teleport spell
var protected int                               mSelectedTeleportTargetID; //TODO: MP

// Used by H7EffectAddRandomBuffFromList and H7EffectSpecialCastOnRandomTarget for Casting Stage bullshittery (HOMMVII-8409)
var protected int                               mFakeRandomTarget;
var protected int                               mFakeRandomBuff;

// Pending save game state file name
var protected string mPendingSaveGameFileName;

var protected string mTempPlayerName;

var public repnotify H7LobbyData                mLobbyData; // only for adventuremap
var protected bool                              mFirstClientLobbyReplication;
var protected bool                              mWasSaveGameCheckDoneMP;
var public H7ContentScannerAdventureMapData		mMapHeader;
var public H7ContentScannerCombatMapData  		mMapHeaderCombat;

replication
{
	if( bNetDirty )
		mIsSimTurns, mLobbyData, mPendingSaveGameFileName, mIsAutoSaveEnabled;
}

//=============================================================================
// Getters and Query functions
//=============================================================================

static simulated function H7ReplicationInfo GetInstance() { return H7ReplicationInfo( class'WorldInfo'.static.GetWorldInfo().GRI ); }

simulated function bool					IsAdventureMap()						{ return mIsAdventureMap; }
simulated function bool					IsCombatMap()							{ return !mIsAdventureMap; }
simulated function bool                 IsCouncilMap()                          { return H7MainMenuHud(class'H7PlayerController'.static.GetPlayerController().GetHud()) != none; }

simulated function H7ControllerManager	GetControllerManager()					{ return mControllerManager; }
simulated function H7GameProcessor      GetGameProcessor()                      { return mGameProcessor; }

simulated function H7SynchRNG			GetSynchRNG()							{ return mSynchRNG; }

simulated function H7ContentScannerAdventureMapData     GetMapHeader()                          { return mMapHeader; }

simulated function bool					IsLoadedGame()							{ return class'H7TransitionData'.static.GetInstance().IsLoadedGame(); }

simulated function						SetIdCounter( int newIdCounter )		{ mIdCounter = newIdCounter; }
simulated function int					GetIdCounter()							{ return mIdCounter; }

simulated function float				GetGameSpeed()							{ return mNormalGameSpeed ? 1.0f : (IsCombatMap() ? GetGameSpeedCombat() : GetGameSpeedAdventure()); }
simulated function float				GetGameSpeedAdventure()					
{ 
	local H7AdventureController advCntl;
	advCntl = mControllerManager.GetAdventureController();
	if( IsMultiplayerGame() )
	{
		if( advCntl != none )
		{
			if( advCntl.GetCurrentPlayer() != none && advCntl.GetCurrentPlayer().IsControlledByAI() )
			{
				return mNormalGameSpeed ? 1.0f : advCntl.GetGameSettings().mGameSpeedAdventureAI;
			}
			else
			{
				return mNormalGameSpeed ? 1.0f : advCntl.GetGameSettings().mGameSpeedAdventure;
			}
		}
		else
		{
			return 1.0f;
		}
	}
	else
	{
		if( advCntl != none && 
			advCntl.GetCurrentPlayer() != none &&
			advCntl.GetCurrentPlayer().IsControlledByAI() )
		{
			return mNormalGameSpeed ? 1.0f : cGameSpeedAdventureAI; 
		}
		else
		{
			return mNormalGameSpeed ? 1.0f : cGameSpeedAdventure; 
		}
	}
}
simulated function float				GetGameSpeedAdventureAI()				
{ 
	local H7AdventureController advCntl;
	advCntl = mControllerManager.GetAdventureController();
	if( IsMultiplayerGame() )
	{
		if( advCntl != none )
		{
			return mNormalGameSpeed ? 1.0f : advCntl.GetGameSettings().mGameSpeedAdventureAI;
		}
		else
		{
			return 1.0f;
		}
	}
	else
	{
		return mNormalGameSpeed ? 1.0f : cGameSpeedAdventureAI; 
	}
}
simulated function float				GetGameSpeedCombat()					
{ 
	local H7AdventureController advCntl;
	local H7CombatController combatCntl;
	advCntl = mControllerManager.GetAdventureController();
	combatCntl = mControllerManager.GetCombatController();
	if( IsMultiplayerGame() )
	{
		if( advCntl != none )
		{
			return mNormalGameSpeed ? 1.0f : advCntl.GetGameSettings().mGameSpeedCombat;
		}
		else if( advCntl == none && combatCntl != none )
		{
			return mNormalGameSpeed ? 1.0f : combatCntl.GetGameSpeed();
		}
		else
		{
			return 1.0f;
		}
	}
	else
	{
		return mNormalGameSpeed ? 1.0f : cGameSpeedCombat; 
	}
}

simulated function float				GetGameSpeedAdventureConfig()           { return cGameSpeedAdventure; }
simulated function float				GetGameSpeedAdventureAIConfig()			{ return cGameSpeedAdventureAI; }
simulated function float				GetGameSpeedCombatConfig()				{ return cGameSpeedCombat; }
simulated function bool                 IsInCutscene()                          { return mNormalGameSpeed; }

simulated function H7CommandQueue       GetCommandQueue()                       { return mCommandQueue; }

simulated function H7InstantCommandManager GetInstantCommandManager()           { return mInstantCommandManager; }

simulated function						SetSimTurns( bool isSimTurns )			{ mIsSimTurns = isSimTurns; }

simulated function SetIsReplayCombat( bool isReplayCombat ) { mIsReplayCombat = isReplayCombat; }
simulated function array<name> GetPreviousStreamingLevels() { return mPreviousStreamingLevels; }

simulated function H7MultiplayerCommandManager	GetMpCommandManager()		{ return mMpCommandManager; }
simulated function H7SimTurnCommandManager		GetSimTurnCommandManager()	{ return mSimTurnCommandManager; }
simulated function								IncUnitActionsCounter()		{ mUnitActionsCounter++; }
simulated function int							GetUnitActionsCounter()		{ return mUnitActionsCounter; }
simulated function H7PostprocessManager			GetPostprocessManager()		{ return mPostprocessManager; }

simulated function								ResetCombatUnitTurnCounter()    { mCombatUnitTurnCounter = 0; }
simulated function								IncCombatUnitTurnCounter()		{ mCombatUnitTurnCounter++; }
simulated function int							GetCombatUnitTurnCounter()		{ return mCombatUnitTurnCounter; }


simulated function H7MultiplayerGameManager     GetMultiplayerGameManager() { return mMultiplayerGameManager; }

simulated function H7SoundManager               GetSoundManager() { return mSoundManager; }

simulated function                      IncGameStateCounter() { mGameStateCounter++; }
simulated function int                  GetGameStateCounter() { return mGameStateCounter; }

simulated function                      SetTeleportTargetID( int ID )   { mSelectedTeleportTargetID = ID; }
simulated function int                  GetTeleportTargetID()           { return mSelectedTeleportTargetID; }

simulated function                      SetFakeRandomTarget( optional int i = -1 )	            { if( i < 0 ) mFakeRandomTarget = mSynchRNG.GetRandomInt(23); else mFakeRandomTarget = i; }
simulated function                      SetFakeRandomBuff( optional int i = -1 )	            { if( i < 0 ) mFakeRandomBuff = mSynchRNG.GetRandomInt(23); else mFakeRandomBuff = i; }
simulated function int                  GetFakeRandomTarget()									{ return mFakeRandomTarget; }
simulated function int                  GetFakeRandomBuff()										{ return mFakeRandomBuff; }
simulated function                      ResetFakeRandomNumbers()								{ mFakeRandomBuff = -1; mFakeRandomTarget = -1; }

native simulated function int			GetNewIDNative();
simulated function int			        GetNewID() { /*`LOG("GetNewID:"@mIdCounter); scripttrace();*/ return  ++mIdCounter;}


simulated function SetPendingSaveGameFileName( string newName ) { mPendingSaveGameFileName = newName; }

static native function PrintLogMessage( string msg, int msgType );

simulated function bool IsAutoSaveEnabled() { return mIsAutoSaveEnabled; }
function SetAutoSaveEnabled(bool b) { mIsAutoSaveEnabled = b; } // should not be simulated -> only the server can set this

//=============================================================================
// functions
//=============================================================================
simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	mEventManageables.Add( TARGETABLE_ARRAY_PAGE_SIZE );
	mCommandQueue = new class'H7CommandQueue';
	mInstantCommandManager = new class'H7InstantCommandManager';
	mControllerManager = Spawn( class'H7ControllerManager' );
	mGameProcessor = new () class'H7GameProcessor';
	mGameProcessor.Init();
	mMpCommandManager = new class'H7MultiplayerCommandManager'();
	mPostprocessManager = Spawn( class'H7PostprocessManager' );
	mMultiplayerGameManager = new class'H7MultiplayerGameManager';
	mMultiplayerGameManager.Initialize();
	mSoundManager = Spawn(class'H7SoundManager'); // actor that will hold all akcomponent given to the sound controller

	if( IsMultiplayerGame() )
	{
		InitMP();
	}

	//Init the sfx speed
	SetRTPCValueBus('Game_Speed', cGameSpeedAdventure * 100);
}

simulated function StartMap(String mapName)
{
	local H7TransitionData transitionData;
	transitionData = class'H7TransitionData'.static.GetInstance();

	transitionData.SetIsInMapTransition(true);
	transitionData.SetLoadedGame( false );
	transitionData.SetPreviousMapName( GetCurrentMapName() );



	WorldInfo.ServerTravel(mapName,true,true);
}

simulated function GoToMainMenu()
{
	local H7PlayerController LP;
	local H7ContentScannerAdventureMapData empty;

	// initialize the loadscreen
	class'H7PlayerController'.static.GetPlayerController().InitLoadingScreen(None);
	class'H7SoundController'.static.GetInstance().UpdateMusicGameStateSwitch("STOP_AMBIENT");

	LP = H7PlayerController(GetALocalPlayerController());

	// clear lobbymapdata
	class'H7TransitionData'.static.GetInstance().SetMPLobbyMapDataToCreate(empty);

	// clear online game
	if( class'GameEngine'.static.GetOnlineSubsystem().GameInterface.GetGameSettings('H7GameSession') != none )
	{
		class'GameEngine'.static.GetOnlineSubsystem().GameInterface.DestroyOnlineGame('H7GameSession');
	}
	class'H7TransitionData'.static.GetInstance().SetPreviousMapName( GetCurrentMapName() );
	LP.ClientTravel("councilhub", TRAVEL_Absolute);
}

simulated function InitMP()
{
	local H7AdventureMapInfo advMapInfo;
	local H7OnlineGameSettings gameSettings;

	// both MainMenuHud and ReplicationInfo need to exist before we stop the loading movie
	if(IsMultiplayerGame() && class'H7MainMenuHud'.static.GetInstance() != none)
	{
		class'Engine'.static.StopMovie(true); // stop the movie loading screen
	}

	// only the server can set this info
	if( Role == ROLE_Authority )
	{
		advMapInfo = H7AdventureMapInfo(class'H7GameInfo'.static.GetH7GameInfoInstance());
		if( advMapInfo != none )
		{
			SetSimTurns( advMapInfo.IsSimTurns() || class'H7TransitionData'.static.GetInstance().GetGameSettings().mSimTurns );
		}
	}

	// only the server has the mSimTurnCommandManager
	if( mIsSimTurns && Role == ROLE_Authority )
	{
		mSimTurnCommandManager = new class'H7SimTurnCommandManager'();
		class'H7ReplicationInfo'.static.PrintLogMessage("Created" @ mSimTurnCommandManager, 0);;
	}

	// client needs to load the mMapHeader from the map's file
	if( Role != ROLE_Authority )
	{
		gameSettings = H7OnlineGameSettings(class'GameEngine'.static.GetOnlineSubsystem().GameInterface.GetGameSettings('H7GameSession'));
		class'H7ReplicationInfo'.static.PrintLogMessage("Loading mapdata of" @ gameSettings.GetMapFilepath(), 0);;
		if(IsDuel())
		{
			mMapHeaderCombat.Filename = gameSettings.GetMapFilepath();
			if( !class'H7ListingCombatMap'.static.ScanCombatMapHeader( mMapHeaderCombat.Filename, mMapHeaderCombat.CombatMapData , true) )
			{
				;
			}
		}
		else
		{
			mMapHeader.Filename = gameSettings.GetMapFilepath();
			if( !class'H7ListingMap'.static.ScanMapHeader( mMapHeader.Filename, mMapHeader.AdventureMapData, true ) )
			{
				;
			}
		}
	}

	class'H7ReplicationInfo'.static.PrintLogMessage("Created H7ReplicationInfo" @ self, 0);;
}

// ============================== GUI ===================================
simulated function InitMPTurnGUI()
{
	class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetMPTurnInfo().SetInfo( self, class'H7AdventureController'.static.GetInstance().IsHotSeat() );

}
// Game Object needs to know how to write its data into GFx format
simulated function GUIWriteInto(GFxObject data,optional H7ListenFocus focus,optional H7GFxUIContainer flashFactory)
{
	
}

// WriteInto this GFxObject if DataChanged
simulated function GUIAddListener(GFxObject data,optional H7ListenFocus focus) 
{
	class'H7ListeningManager'.static.GetInstance().AddListener(self,data);
}
// Game Object needs to know what to do when its data changes (usually they just call ListeningManager)
simulated function DataChanged(optional String cause) 
{
	;
	class'H7ListeningManager'.static.GetInstance().DataChanged(self);
}
// ============================== /GUI ==================================

simulated event Destroyed()
{
	super.Destroyed();

	mMultiplayerGameManager.Shutdown();
	mCommandQueue = none;
	mInstantCommandManager = none;
	mControllerManager = none;
	mGameProcessor = none;
	mMpCommandManager = none;
	mPostprocessManager = none;
}

event bool CurrentHUDContextIsHeroTradeWindow()
{
	return class'H7PlayerController'.static.GetPlayerController().GetHud().GetCurrentContext() == H7AdventureHud( class'H7PlayerController'.static.GetPlayerController().GetHud() ).GetHeroTradeWindowCntl();
}

simulated function SetIsAdventureMap()
{
	mIsAdventureMap = true;
	H7PlayerReplicationInfo( GetALocalPlayerController().PlayerReplicationInfo ).SetIsInCombatMap( false );
	if( class'H7AdventureController'.static.GetInstance() != none )
	{
		class'H7AdventureController'.static.GetInstance().GotoState( 'AdventureMap' );
	}
}

simulated function SetIsCombatMap()
{
	mIsAdventureMap = false;
	if( class'H7AdventureController'.static.GetInstance() != none )
	{
		class'H7AdventureController'.static.GetInstance().GotoState( 'Combat' );
	}
	if( class'H7AdventureHud'.static.GetAdventureHud() != none) // cleanup again, in case illegal state was made during the cam-zoom-white-glow-thingy
	{
		class'H7AdventureHud'.static.GetAdventureHud().SetAdventureHudVisible(false);
	}
}

simulated function CreateCombatController()
{
	local H7CombatController combatControllerTemplate;

	if( class'H7GameInfo'.static.GetH7GameInfoInstance() != none && class'H7GameInfo'.static.GetH7GameInfoInstance().GetCombatController() != none ) 
	{
		combatControllerTemplate = class'H7GameInfo'.static.GetH7GameInfoInstance().GetCombatController();
	}
	else
	{
		combatControllerTemplate = H7CombatController( DynamicLoadObject( "H7CombatController'H7Config.H7CombatSetup'", class'H7CombatController') );
	}
	// create H7CombatController, set the position to the center of the grid, so it is deleted automatically when returning to the adventure map
	Spawn( class'H7CombatController' , class'H7CombatMapGridController'.static.GetInstance(), , class'H7CombatMapGridController'.static.GetInstance().GetCenter(),,combatControllerTemplate);
}

simulated function CreateAdventureController()
{
	local H7AdventureController	adventureControllerTemplate;

	class'H7ReplicationInfo'.static.PrintLogMessage("CreateAdventureController", 0);;
	
	if( !IsLoadedGame() )
	{
		adventureControllerTemplate = H7AdventureController( DynamicLoadObject( "H7AdventureController'H7Config.H7AdventureSetup'", class'H7AdventureController') );
		Spawn( class'H7AdventureController' ,,,,, adventureControllerTemplate);
		mReadyToLoad = false;
	}
	else
	{
		mReadyToLoad = true;
	}

	if( IsMultiplayerGame() )
	{
		class'H7AdventureHudCntl'.static.GetInstance().SetWaitingForPlayers( false );
	}
}

simulated function CreateMainMenuController()
{
	local H7MainMenuController mainMenuControllerTemplate;
	mainMenuControllerTemplate = H7MainMenuController( DynamicLoadObject( "H7MainMenuController'H7Config.H7MainMenuSetup'", class'H7MainMenuController') );
	Spawn( class'H7MainMenuController', , 'name',,, mainMenuControllerTemplate);
}

simulated function CreateSynchRNG()
{
	if( mSynchRNG == none )
	{
		mSynchRNG = Spawn( class'H7SynchRNG' );
		mSynchRNG.Init();
		class'H7ReplicationInfo'.static.PrintLogMessage("H7SynchRNG created" @ mSynchRNG  @ self, 0);;
	}
}

/**
	* Cleanup sessions and return to the main menu gracefully without a playercontroller
	*/
simulated function ReturnToMainMenuNoPC()
{
	local H7PlayerController LP;

	LP = H7PlayerController(GetALocalPlayerController());

	if (!bIsReturningToMainMenu)
	{
		// flag gets cleared when main menu reloads
		bIsReturningToMainMenu = true;

		// Cleanup game session 
		LP.DeleteSession('H7GameSession',OnDestroyGameComplete);
	}
}
/**
	* Delegate called when party destroy is complete
	*/
simulated function OnDestroyGameComplete(name SessionName,bool bWasSuccessful)
{
	local OnlineSubsystem OnlineSub;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();

	if (OnlineSub != None &&
		OnlineSub.GameInterface != None &&
		SessionName == 'H7GameSession')
	{
		// clear delegate for game deletion
		OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyGameComplete);
		class'H7ReplicationInfo'.static.GetInstance().GoToMainMenu();
	}
}


simulated function SetCutsceneMode(bool isCutscenePlaying)
{
	// Do it only if new mode is different from current
	if(mNormalGameSpeed != isCutscenePlaying)
	{
		if( isCutscenePlaying )
		{
			SetRTPCValueBus('Game_Speed', 100);
		}
		else
		{
			SetRTPCValueBus('Game_Speed', GetGameSpeed() * 100);
		}
		mNormalGameSpeed = isCutscenePlaying;
	}
}

simulated function ModifyGameSpeedCombat( float newGameSpeed )
{
	local H7CreatureAnimControl currentCreatureAnimControl;
	local H7HeroAnimControl currentHeroAnimControl;

	if( IsMultiplayerGame() )
	{
		return;
	}

	if( newGameSpeed == 0 )
	{
		newGameSpeed = 1.0f;
	}

	if( class'H7AdventureController'.static.GetInstance() != none )
	{
		class'H7AdventureController'.static.GetInstance().SetGameSettingsSpeedCmb( newGameSpeed );
	}
	if( mControllerManager.GetCombatController() != none )
	{
		mControllerManager.GetCombatController().SetGameSpeed( newGameSpeed );
	}

	cGameSpeedCombat = newGameSpeed;
	
	//Adjust only on combat map
	if(H7PlayerReplicationInfo( GetALocalPlayerController().PlayerReplicationInfo ).IsInCombatMap())
	{
		//Global Game Speed is changed, change the global one in WWise aswell
		SetRTPCValueBus('Game_Speed', newGameSpeed * 100);
	}

	// update the animation of the creatures and heroes
	foreach class'WorldInfo'.static.GetWorldInfo().DynamicActors( class'H7CreatureAnimControl', currentCreatureAnimControl )
	{
		currentCreatureAnimControl.ModifyRateCurrentAnimation( newGameSpeed );
	}
	foreach class'WorldInfo'.static.GetWorldInfo().DynamicActors( class'H7HeroAnimControl', currentHeroAnimControl )
	{
		currentHeroAnimControl.ModifyRateCurrentAnimation( newGameSpeed );
	}
	SaveConfig();
}

simulated function ModifyGameSpeedAdventure( float newGameSpeed )
{
	local H7CreatureAnimControl currentCreatureAnimControl;
	local H7HeroAnimControl currentHeroAnimControl;

	if( IsMultiplayerGame() )
	{
		return;
	}

	if( newGameSpeed == 0 )
	{
		newGameSpeed = 1.0f;
	}

	if( class'H7AdventureController'.static.GetInstance() != none )
	{
		class'H7AdventureController'.static.GetInstance().SetGameSettingsSpeedAdv( newGameSpeed );
	}

	cGameSpeedAdventure = newGameSpeed;

	//Adjust only on adv map
	if(!H7PlayerReplicationInfo( GetALocalPlayerController().PlayerReplicationInfo ).IsInCombatMap())
	{
		//Global Game Speed is changed, change the global one in WWise aswell
		SetRTPCValueBus('Game_Speed', newGameSpeed * 100);
	}

	// update the animation of the creatures and heroes
	foreach class'WorldInfo'.static.GetWorldInfo().DynamicActors( class'H7CreatureAnimControl', currentCreatureAnimControl )
	{
		currentCreatureAnimControl.ModifyRateCurrentAnimation( newGameSpeed );
	}
	foreach class'WorldInfo'.static.GetWorldInfo().DynamicActors( class'H7HeroAnimControl', currentHeroAnimControl )
	{
		currentHeroAnimControl.ModifyRateCurrentAnimation( newGameSpeed );
	}
	SaveConfig();
}

simulated function ModifyGameSpeedAdventureAI( float newGameSpeed )
{
	cGameSpeedAdventureAI = newGameSpeed;

	if( class'H7AdventureController'.static.GetInstance() != none )
	{
		class'H7AdventureController'.static.GetInstance().SetGameSettingsSpeedAi( newGameSpeed );
	}
	SaveConfig();
}

simulated function ModifyGameSpeedMPAdventure( float newGameSpeed )
{
	local H7CreatureAnimControl currentCreatureAnimControl;
	local H7HeroAnimControl currentHeroAnimControl;

	if( newGameSpeed == 0 )
	{
		newGameSpeed = 1.0f;
	}

	if( mControllerManager.GetAdventureController() != none )
	{
		mControllerManager.GetAdventureController().SetGameSettingsSpeedAdv( newGameSpeed );
	}
	class'H7ReplicationInfo'.static.PrintLogMessage("new speed"@newGameSpeed, 0);;

	//Global Game Speed is changed, change the global one in WWise aswell
	SetRTPCValueBus('Game_Speed', (newGameSpeed * 100));

	// update the animation of the creatures and heroes
	foreach class'WorldInfo'.static.GetWorldInfo().DynamicActors( class'H7CreatureAnimControl', currentCreatureAnimControl )
	{
		currentCreatureAnimControl.ModifyRateCurrentAnimation( newGameSpeed );
	}
	foreach class'WorldInfo'.static.GetWorldInfo().DynamicActors( class'H7HeroAnimControl', currentHeroAnimControl )
	{
		currentHeroAnimControl.ModifyRateCurrentAnimation( newGameSpeed );
	}
}

simulated function ModifyGameSpeedMPCombat( float newGameSpeed )
{
	local H7CreatureAnimControl currentCreatureAnimControl;
	local H7HeroAnimControl currentHeroAnimControl;

	if( newGameSpeed == 0 )
	{
		newGameSpeed = 1.0f;
	}

	class'H7ReplicationInfo'.static.PrintLogMessage("new speed"@newGameSpeed, 0);;

	mControllerManager.GetCombatController().SetGameSpeed( newGameSpeed );
	//Global Game Speed is changed, change the global one in WWise aswell
	SetRTPCValueBus('Game_Speed', (newGameSpeed * 100));

	// update the animation of the creatures and heroes
	foreach class'WorldInfo'.static.GetWorldInfo().DynamicActors( class'H7CreatureAnimControl', currentCreatureAnimControl )
	{
		currentCreatureAnimControl.ModifyRateCurrentAnimation( newGameSpeed );
	}
	foreach class'WorldInfo'.static.GetWorldInfo().DynamicActors( class'H7HeroAnimControl', currentHeroAnimControl )
	{
		currentHeroAnimControl.ModifyRateCurrentAnimation( newGameSpeed );
	}
}


simulated function Vector2D GetGameSpeedConstraints()
{
	local Vector2D speed;
	speed.X = 0.3;
	speed.Y = 4;
	return speed;
}

simulated function Vector2D GetGameSpeedConstraintsAI()
{
	local Vector2D speed;
	speed.X = 0.3;
	speed.Y = 8;
	return speed;
}

simulated function bool IsSimTurns( optional bool checkAdventureMap = true )
{
	if( checkAdventureMap )
	{
		return mIsAdventureMap && mIsSimTurns; 
	}
	else
	{
		return mIsSimTurns;
	}
}

//=============================================================================
// H7IEventManagingObject functions
//=============================================================================

simulated function array<H7IEventManagingObject> GetEventManageables()
{
	return mEventManageables;
}

simulated function H7IEventManagingObject GetEventManageable( int eventManageableId )
{
	if( eventManageableId >= mEventManageables.Length )
	{
		ScriptTrace();
		;
		return none;
	}

	if( mEventManageables[eventManageableId] != none )
	{
		return mEventManageables[eventManageableId];
	}

	ScriptTrace();
	;
	return none;
}

native simulated function RegisterEventManageable( H7IEventManagingObject eventManageable );

simulated function UnregisterEventManageable( H7IEventManagingObject eventManageable )
{
	if( eventManageable == none )
	{
		ScriptTrace();
		;
		return;
	}

	if( mEventManageables[eventManageable.GetID()] != eventManageable )
	{
		;
		return;
	}

	mEventManageables[eventManageable.GetID()] = none;
	class'H7ReplicationInfo'.static.PrintLogMessage("----------------->UNREGISTERING" @ eventManageable @ eventManageable.GetID(), 0);;
}

//=============================================================================
// Adventure -> Combat functions
//=============================================================================
simulated function SwitchToCombatState( string CombatMapName, bool isReplayCombat, optional bool isSiege = false )
{
	local WorldInfo myWorld;
	local array<name> mapArray;
	local LevelStreaming level;

	myWorld = class'WorldInfo'.static.GetWorldInfo();

	if( myWorld != None )
	{
		// disable the screen messages else the "ligthing needs to be rebuild" will be triggered after the load of the combat map inside the adventure map
		ConsoleCommand("DisableAllScreenMessages");

		if( isReplayCombat )
		{
			mapArray.AddItem( name(CombatMapName) );
			myWorld.PrepareMapChange( mapArray );
			CommitCombatMapChange();
		}
		else
		{
			// save the previous streaming levels that are in the adventure map
			mPreviousStreamingLevels.length = 0; // clear
			foreach myWorld.StreamingLevels( level )
			{
				mPreviousStreamingLevels.AddItem( level.PackageName );
			}

			mapArray.AddItem( name(CombatMapName) );
			myWorld.PrepareMapChange( mapArray );
			
			SetTimer( 0.1f, true, nameof(DelayedLoadCombatMap) );
		}
	}
}

simulated function DelayedLoadCombatMap()
{
	local WorldInfo myWorld;
	myWorld = class'WorldInfo'.static.GetWorldInfo();
	if( myWorld != none && myWorld.IsMapChangeReady() && class'H7CameraActionController'.static.GetInstance().GetCurrentAction() == none )
	{
		CommitCombatMapChange();
		ClearTimer( NameOf(DelayedLoadCombatMap) );
	}
}

simulated protected function CommitCombatMapChange()
{
	class'H7PlayerController'.static.GetPlayerController().GetHUD().CloseCurrentPopup();
	class'WorldInfo'.static.GetWorldInfo().MapChangePositionOffset = vect(200000.f, 0.f, 0.f);
	class'WorldInfo'.static.GetWorldInfo().CommitMapChange();
	TriggerGlobalEventClass( class'H7SeqEvent_AdvCombatTransition', self, 0 );
}

simulated event Tick(float deltaTime)
{
	local H7SavegameTask_Loading loadingTask;
	//`log_dui("info.tick");
	SetFrameStartTime();

	if( mReadyToLoad && class'H7TransitionData'.static.GetInstance().IsLoadingSave() )
	{
		loadingTask = class'H7TransitionData'.static.GetInstance().GetCurrentLoadTask();

		if( loadingTask.GetCurrentTaskState() == H7SavegameControllerTaskState_InProgress )
		{
			loadingTask.UpdateStatus();
		}

		if( loadingTask.GetCurrentTaskState() == H7SavegameControllerTaskState_ReadyToFinish )
		{
			loadingTask.FinishSceneLoadTask();
			class'H7TransitionData'.static.GetInstance().SetLoadingSave( false );
			mReadyToLoad = false;
		}
	}

	if(mMultiplayerGameManager != none)
	{
		mMultiplayerGameManager.Update();
	}
}

simulated function SetFrameStartTime()
{
	mFrameStartTime = 0;
	Clock(mFrameStartTime);
	//`log_dui("Clocked" @ mFrameStartTime);
}

simulated function float GetTimeSinceFrameStart()
{
	local float copyTime;
	copyTime = mFrameStartTime;
	UnClock(copyTime);
	//`log_dui("UnClocked" @ copyTime);
	return copyTime;
}

simulated function H7Player GetPlayerByNumber(EPlayerNumber number)
{
	if(IsCombatMap())
	{
		if(class'H7CombatController'.static.GetInstance().GetArmyAttacker().GetPlayerNumber() == number)
		{
			return class'H7CombatController'.static.GetInstance().GetArmyAttacker().GetPlayer();
		}
		else if(class'H7CombatController'.static.GetInstance().GetArmyDefender().GetPlayerNumber() == number)
		{
			return class'H7CombatController'.static.GetInstance().GetArmyDefender().GetPlayer();
		}
		else
		{
			;
			return none;
		}
	}
	else if(IsAdventureMap())
	{
		return class'H7AdventureController'.static.GetInstance().GetPlayerByNumber(number);
	}
	else
	{
		;
		return none;
	}
}

//================================================================
// Lobby
// ===============================================================

simulated function int GetMyPlayerIndex()
{
	local int i;

	for(i=0;i<8;i++)
	{
		if(mLobbyData.mPlayers[i].mName == class'H7PlayerController'.static.GetPlayerController().PlayerReplicationInfo.PlayerName)
		{
			return i;
		}
	}

	;
	return INDEX_NONE;
}

simulated function SetFirstClientLobbyReplication(bool val)
{
	mFirstClientLobbyReplication = val; 
}

simulated event ReplicatedEvent(name VarName)
{
	local int i;

	if ( VarName == 'mLobbyData' )
	{
		// I am a client and new lobby data arrived from the server
		if( class'H7MainMenuHud'.static.GetInstance() != none && class'H7MainMenuHud'.static.GetInstance().GetSkirmishSetupWindowCntl() != none && class'H7MainMenuHud'.static.GetInstance().GetDuelSetupWindowCntl() != none )
		{
			if(mFirstClientLobbyReplication)
			{
				// sets all possibilities and actual chosen settings
				class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().Finish();
				if( IsDuel() )
				{
					class'H7MainMenuHud'.static.GetInstance().GetDuelSetupWindowCntl().OpenPopup();
				}
				else
				{
					class'H7MainMenuHud'.static.GetInstance().GetSkirmishSetupWindowCntl().OpenPopup(mLobbyData,false,true,false,false); // TODO maybe load=true
				}
			}
			else
			{
				if( IsDuel() )
				{
					// only sets actual chosen settings
					class'H7MainMenuHud'.static.GetInstance().GetDuelSetupWindowCntl().DisplayMapSettings(mLobbyData.mMapSettings);
					class'H7MainMenuHud'.static.GetInstance().GetDuelSetupWindowCntl().DisplayGameSettings(mLobbyData.mGameSettings);
					for(i=0;i<2;i++)
					{
						// also sets slot-possibilities in case of kicks and disconnects
						class'H7MainMenuHud'.static.GetInstance().GetDuelSetupWindowCntl().SetNewList("mDropSlot",class'H7MainMenuHud'.static.GetInstance().GetDuelSetupWindowCntl().GetEnumList("ESlot",i),i);
						class'H7MainMenuHud'.static.GetInstance().GetDuelSetupWindowCntl().DisplayPlayerSettings(i,mLobbyData.mPlayers[i]);
					}
				}
				else
				{
					// only sets actual chosen settings
					class'H7MainMenuHud'.static.GetInstance().GetSkirmishSetupWindowCntl().DisplayMapSettings(mLobbyData.mMapSettings);
					class'H7MainMenuHud'.static.GetInstance().GetSkirmishSetupWindowCntl().DisplayGameSettings(mLobbyData.mGameSettings);
					for(i=0;i<mMapHeader.AdventureMapData.mPlayerAmount;i++)
					{
						// also sets slot-possibilities in case of kicks and disconnects
						class'H7MainMenuHud'.static.GetInstance().GetSkirmishSetupWindowCntl().SetNewList("mDropSlot",class'H7MainMenuHud'.static.GetInstance().GetSkirmishSetupWindowCntl().GetEnumList("ESlot",i),i);
						class'H7MainMenuHud'.static.GetInstance().GetSkirmishSetupWindowCntl().DisplayPlayerSettings(i,mLobbyData.mPlayers[i]);
					}
				}
			}
			mFirstClientLobbyReplication = false;
			class'H7ReplicationInfo'.static.PrintLogMessage("Updated mLobbyData IsDuel =" @ IsDuel(), 0);;
		}
		else
		{
			class'H7ReplicationInfo'.static.PrintLogMessage("New mLobbyData, but no GUI was ready ", 0);;
		}

		if( !mWasSaveGameCheckDoneMP )
		{
			if( mLobbyData.mSaveGameFileName != "")
			{
				class'H7ReplicationInfo'.static.PrintLogMessage("CHECKING SAVEGAME name:" @ mLobbyData.mSaveGameFileName @ " with checksum:" @ mLobbyData.mSaveGameCheckSum, 0);;

				class'H7PlayerController'.static.GetPlayerController().ScanForAllSaveGamesMP(true);	
			}
			mWasSaveGameCheckDoneMP = true;
		}
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

simulated function CompleteSlotCheckMP()
{
	local int slotId;

	slotId = class'H7PlayerController'.static.GetPlayerController().GetSlotIdMP( mLobbyData.mSaveGameCheckSum );

	class'H7ReplicationInfo'.static.PrintLogMessage("CHECKING SAVEGAME SLOT FOUND" @ slotId, 0);;

	if( slotId == -1 )
	{
		class'H7TransitionData'.static.GetInstance().SetMPClientSavegameNeededLobbySession( true );
		class'H7ReplicationInfo'.static.GetInstance().GoToMainMenu();
	}
	else
	{
		class'H7PlayerController'.static.GetPlayerController().LoadGameState( slotId, mLobbyData.mSaveGameFileName, true );
	}
}

// settings to use for when user does single player campaign (will be overwritten when skimirsh is set up)
// default settings when starting the game
function InitLobbyDataForCampaign()
{
	// TODO Dawid read saved preferences from player profile
	mLobbyData.mGameSettings.mDifficulty = DIFFICULTY_NORMAL;
	mLobbyData.mGameSettings.mDifficultyParameters.mStartResources = DSR_AVERAGE;
	mLobbyData.mGameSettings.mDifficultyParameters.mCritterStartSize = DCSS_AVERAGE;
	mLobbyData.mGameSettings.mDifficultyParameters.mCritterGrowthRate = DCGR_AVERAGE;
	mLobbyData.mGameSettings.mDifficultyParameters.mAiEcoStrength = DAIES_AVERAGE;
}

// hotseat false = vs AI
function InitLobbyDataForDuel(H7ContentScannerCombatMapData mapHeader,bool multiplayer,bool hotseat=false)
{
	local PlayerLobbySelectedSettings empty;
	local array<H7EditorHero>heroes;

	mMapHeaderCombat = mapHeader;

	mLobbyData.mIsInitialized = true;
	mLobbyData.mIsDuel = true;
	class'H7SoundController'.static.GetInstance().LoadingScreenEnabled(false);
	class'H7GameData'.static.GetInstance().GetDuelHeroes(heroes);
	mLobbyData.mGameSettings.mGameSpeedCombat = GetGameSpeedCombatConfig();
	// add host
	mLobbyData.mPlayers[0] = empty;
	AddPlayerToLobbyData( class'H7PlayerController'.static.GetPlayerController().PlayerReplicationInfo.PlayerName , 0);
	mLobbyData.mPlayers[0].mColor = PCOLOR_BLUE;
	mLobbyData.mPlayers[0].mPosition = START_POSITION_1; // attacker
	mLobbyData.mPlayers[0].mFaction = heroes[0].GetFaction();
	if( !IsMultiplayerGame() )
	{
		mLobbyData.mPlayers[0].mFactionRef = heroes[0].GetFaction().GetArchetypeID();
		mLobbyData.mPlayers[0].mName = class'H7Loca'.static.LocalizePlayerName(PN_PLAYER_1);
	}
	mLobbyData.mPlayers[0].mStartHero = heroes[0];
	mLobbyData.mPlayers[0].mArmy = class'H7GameData'.static.GetInstance().GetDuelArmy(0,mLobbyData.mPlayers[0].mFaction);
	
	// and empty client:
	mLobbyData.mPlayers[1] = empty;
	mLobbyData.mPlayers[1].mSlotState = EPlayerSlotState_Open;
	if(!multiplayer && !hotseat) 
	{
		mLobbyData.mPlayers[1].mSlotState = EPlayerSlotState_AI;
	}
	mLobbyData.mPlayers[1].mAIDifficulty = AI_DIFFICULTY_NORMAL;
	mLobbyData.mPlayers[1].mColor = PCOLOR_RED;
	mLobbyData.mPlayers[1].mPosition = START_POSITION_2; // defender
	mLobbyData.mPlayers[1].mFaction = heroes[1].GetFaction();
	if( !IsMultiplayerGame() )
	{
		mLobbyData.mPlayers[1].mFactionRef = heroes[1].GetFaction().GetArchetypeID();
		mLobbyData.mPlayers[1].mName = class'H7Loca'.static.LocalizePlayerName(PN_PLAYER_2);
	}
	mLobbyData.mPlayers[1].mArmy = class'H7GameData'.static.GetInstance().GetDuelArmy(0,mLobbyData.mPlayers[1].mFaction);
	mLobbyData.mPlayers[1].mStartHero = heroes[1];

	mLobbyData.mMapSettings.mMapFileName = "CM_Desert_Canyon_2";

	SetTimer( 5.f, true, nameof(LobbyUpdateDisconnectedPlayers));
}

// for host - loading multiplayer game
function InitLobbyDataBySaveData(H7ContentScannerAdventureMapData mapHeader, H7ListingSavegameDataScene saveData)
{
	local int i;

	// first base lobby based on map
	InitLobbyData(mapHeader,false,true);

	// now overwrite data based on saveData
	mLobbyData.mGameSettings = saveData.SavegameData.mGameSettings;
	mLobbyData.mMapSettings = saveData.SavegameData.mMapSettings;
	for(i=0;i<8;i++)
	{
		mLobbyData.mPlayers[i] = saveData.SavegameData.mPlayersSettings[i];

		// Clean not needed strings for mFaction and mStartHero
		if(mLobbyData.mPlayers[i].mFactionRef != "")
		{
			mLobbyData.mPlayers[i].mFaction = class'H7GameData'.static.GetInstance().GetFactionByArchetypeID( mLobbyData.mPlayers[i].mFactionRef );

			// Clear string for MP
			mLobbyData.mPlayers[i].mFactionRef = "";
		}

		if(mLobbyData.mPlayers[i].mStartHeroRef != "")
		{
			mLobbyData.mPlayers[i].mStartHero = class'H7GameData'.static.GetInstance().GetHeroByArchetypeID( mLobbyData.mPlayers[i].mStartHeroRef );

			if(mLobbyData.mPlayers[i].mStartHero == none) // If its still none, load it from package
			{
				mLobbyData.mPlayers[i].mStartHero = H7EditorHero( DynamicLoadObject( mLobbyData.mPlayers[i].mStartHeroRef , class'H7EditorHero') );
			}

			// Clear string for MP
			mLobbyData.mPlayers[i].mStartHeroRef = "";
		}
	}
	mLobbyData.mSaveGameFileName = string(saveData.SlotIndex);

	SetTimer( 5.f, true, nameof(LobbyUpdateDisconnectedPlayers));

	// BETA HACK add new host again, in case savedata overwrote his name:
	AddPlayerToLobbyData( class'H7PlayerController'.static.GetPlayerController().PlayerReplicationInfo.PlayerName , 0);
	mLobbyData.mSaveGameCheckSum = saveData.SavegameData.mSaveGameCheckSum;
}

// for host - single and multiplayer new game
// (multiplayer clients get the host's version)
function InitLobbyData(H7ContentScannerAdventureMapData mapHeader,bool forHotseat,bool forMultiplayer)
{
	local PlayerLobbySelectedSettings empty;
	local int i;
	local EPlayerSlot playerSlot;
	local array<EPlayerColor> skirmishColors;

	mMapHeader = mapheader;

	;
	
	mLobbyData.mIsInitialized = true;
	class'H7SoundController'.static.GetInstance().LoadingScreenEnabled(false);

	// clear player array
	for(i=0;i<8;i++)
	{
		mLobbyData.mPlayers[i] = empty;
	}

	skirmishColors = class'H7GameUtility'.static.GetSkirmishColors();

	for(i=0;i<8;i++)
	{
		;
		mLobbyData.mPlayers[i].mColor = skirmishColors[i];
		if(class'H7Loca'.static.IsLocaParamsEmpty(mMapHeader.AdventureMapData.mPlayerInfoProperties[i].Name))
		{
			mLobbyData.mPlayers[i].mName = class'H7Loca'.static.LocalizePlayerName(EPlayerNumber(i));
		}
		else
		{
			mLobbyData.mPlayers[i].mName = class'H7Loca'.static.LocalizeFieldParams(mMapHeader.AdventureMapData.mPlayerInfoProperties[i].Name);
		}
		mLobbyData.mPlayers[i].mPosition = EStartPosition(mMapHeader.AdventureMapData.mPlayerInfoProperties[i].Position); // CCU just saved 1-8 in here always
		mLobbyData.mPlayers[i].mTeam = ETeamNumber(mMapHeader.AdventureMapData.mPlayerInfoProperties[i].Team);

		playerSlot = EPlayerSlot(mMapHeader.AdventureMapData.mPlayerInfoProperties[i].Slot);
		if(playerSlot == EPlayerSlot_AI)
		{
			mLobbyData.mPlayers[i].mSlotState = EPlayerSlotState_AI;
			mLobbyData.mPlayers[i].mAIDifficulty = AI_DIFFICULTY_NORMAL; // TODO read mapdata when other AIs enabled
			mLobbyData.mPlayers[i].mIsReady = true;
		}
		else if(playerSlot == EPlayerSlot_Human)
		{
			mLobbyData.mPlayers[i].mSlotState = EPlayerSlotState_Open; 
		}
		else if(playerSlot == EPlayerSlot_UserDefine)
		{
			if(forHotseat || i==0 || forMultiplayer)
			{
				mLobbyData.mPlayers[i].mSlotState = EPlayerSlotState_Open;
			}
			else
			{
				mLobbyData.mPlayers[i].mSlotState = EPlayerSlotState_AI; 
				mLobbyData.mPlayers[i].mAIDifficulty = AI_DIFFICULTY_NORMAL; // TODO read mapdata when other AIs enabled
				mLobbyData.mPlayers[i].mIsReady = true;
			}
		}
		else if(playerSlot == EPlayerSlot_Closed)
		{
			mLobbyData.mPlayers[i].mSlotState = EPlayerSlotState_Closed; 
		}
	}
	
	InitLobbyHeroes( EMapType(mMapHeader.AdventureMapData.mMapType) == SCENARIO , forMultiplayer );

	// default settings
	mLobbyData.mGameSettings.mUseRandomSkillSystem = false;
	mLobbyData.mGameSettings.mGameSpeedAdventureAI = GetGameSpeedAdventureAIConfig();
	mLobbyData.mGameSettings.mGameSpeedAdventure = GetGameSpeedAdventureConfig();
	mLobbyData.mGameSettings.mGameSpeedCombat = GetGameSpeedCombatConfig();
	mLobbyData.mMapSettings.mMapFileName = class'H7ListingMap'.static.GetMapName(mapHeader.Filename);
	mLobbyData.mMapSettings.mTeamSetup = TEAM_MAP_DEFAULT;
	mLobbyData.mMapSettings.mCanUseStartBonus = false; // BETA HACK is now GOLDMASTER HACK
	mLobbyData.mMapSettings.mUseRandomStartPosition = false;

	mLobbyData.mGameSettings.mDifficulty = DIFFICULTY_NORMAL;
	mLobbyData.mGameSettings.mTeamsCanTrade = true;
	mLobbyData.mGameSettings.mForceQuickCombat = FQC_NEVER;
	mLobbyData.mGameSettings.mSpectatorMode = true; // watch battles
	
	// TODO ... ?  

	// add host:
	AddPlayerToLobbyData( class'H7PlayerController'.static.GetPlayerController().PlayerReplicationInfo.PlayerName );

	SetTimer( 5.f, true, nameof(LobbyUpdateDisconnectedPlayers));
		
	LobbyUpdateOnlineGameSettingsSlots();
}

simulated function InitLobbyHeroes( bool isScenario , bool isMultiplayer)
{
	local array<H7EditorHero> heroPool;
	local array<H7Faction> factions;
	local int i, j;

	class'H7GameData'.static.GetInstance().GetFactions(factions);
	class'H7GameData'.static.GetInstance().GetRandomHeroes(heroPool);

	// remove the heroes with a not allowed faction

	for(i=0;i<8;i++)
	{
		if( isScenario )
		{
			mLobbyData.mPlayers[i].mFaction = GetAvailableStartFaction(mMapHeader.AdventureMapData.mPlayerInfoProperties[i].StartFaction);
			if(!isMultiplayer)
			{
				mLobbyData.mPlayers[i].mFactionRef = mLobbyData.mPlayers[i].mFaction.GetArchetypeID();
			}
		}
		else
		{
			// instead we will assing a random hero with its faction
			mLobbyData.mPlayers[i].mFaction = factions[Rand(factions.Length)];
			if( !isMultiplayer && mLobbyData.mPlayers[i].mStartHero != none )
			{
				mLobbyData.mPlayers[i].mFactionRef = mLobbyData.mPlayers[i].mStartHero.GetFaction().GetArchetypeID();
			}
		}

		for(j=0; j<heroPool.Length; j++)
		{
			if(heroPool[j].GetFaction() == mLobbyData.mPlayers[i].mFaction)
			{
				mLobbyData.mPlayers[i].mStartHero = heroPool[j];

				if( !isMultiplayer && mLobbyData.mPlayers[i].mStartHero != none )
				{
					mLobbyData.mPlayers[i].mStartHeroRef = Pathname(mLobbyData.mPlayers[i].mStartHero);
				}

				break;
			}
		}
	}
}

simulated function H7Faction GetAvailableStartFaction(string startFactionName)
{
	local array<H7Faction> factions;
	local H7Faction faction;

	class'H7GameData'.static.GetInstance().GetFactions(factions);
	foreach factions(faction)
	{
		if(faction != none && string(faction.Name) == startFactionName)
		{
			return faction;
		}
	}

	return (factions.Length > 0) ? factions[0] : none;
}

native function string GetCurrentMapName();

function LobbyUpdateOnlineGameSettingsSlots( optional bool ignoreUpdateOnline = false )
{
	local H7OnlineGameSettings onlineSettings;
	local int i, aiSlots, closedSlots;

	onlineSettings = class'H7MultiplayerGameManager'.static.GetOnlineGameSettings();
	if( onlineSettings != none )
	{
		for( i=0; i<mMapHeader.AdventureMapData.mPlayerAmount; i++ )
		{
			if( mLobbyData.mPlayers[i].mSlotState == EPlayerSlotState_Closed )
			{
				++closedSlots;
			}
			else if( mLobbyData.mPlayers[i].mSlotState == EPlayerSlotState_AI )
			{
				++aiSlots;
			}
		}
		onlineSettings.SetNumAISlots( aiSlots );
		onlineSettings.SetNumClosedSlots( closedSlots );

		if( !onlineSettings.bIsLanMatch && !ignoreUpdateOnline )
		{
			class'GameEngine'.static.GetOnlineSubsystem().GameInterface.UpdateOnlineGame( 'H7GameSession', onlineSettings, true );
		}
	}
}

function UpdateOnlineGameStarted()
{
	local H7OnlineGameSettings onlineSettings;

	onlineSettings = class'H7MultiplayerGameManager'.static.GetOnlineGameSettings();
	if( onlineSettings != none )
	{
		onlineSettings.SetIsGameStarted( true );
		if(!onlineSettings.bIsLanMatch)
		{
			class'GameEngine'.static.GetOnlineSubsystem().GameInterface.UpdateOnlineGame( 'H7GameSession', onlineSettings, true );
		}
	}

	ClearTimer( nameof(LobbyUpdateDisconnectedPlayers) );
}

function LobbyUpdateDisconnectedPlayers()
{
	local int i, j;
	local bool playerFound;
	local string playerName;

	for(i=0;i<8;i++)
	{
		if( mLobbyData.mPlayers[i].mSlotState == EPlayerSlotState_Occupied )
		{
			playerFound = false;
			for(j=0;j<PRIArray.Length;j++)
			{
				if( PRIArray[j].PlayerName == mLobbyData.mPlayers[i].mName )
				{
					playerFound = true;
					break;
				}
			}
		
			// empty the position that the player was using
			if( !playerFound )
			{
				class'H7ReplicationInfo'.static.PrintLogMessage("Removing player " @ mLobbyData.mPlayers[i].mName @ " because he is not connected to the server anymore", 0);;
				class'H7MessageSystem'.static.GetInstance().AddReplForNextMessage("%player",mLobbyData.mPlayers[i].mName);

				playerName = mLobbyData.mPlayers[i].mName;

				mLobbyData.mPlayers[i].mSlotState = EPlayerSlotState_Open;
				mLobbyData.mPlayers[i].mIsReady = false;
				mLobbyData.mPlayers[i].mName = "";

				class'H7PlayerController'.static.GetPlayerController().SendLobbySystemChat( playerName, "CHAT_PLAYER_LEAVE" );

				if(IsDuel())
				{
					class'H7DuelSetupWindowCntl'.static.GetInstance().UpdateAfterPlayerLeaving( i );
				}
				else
				{
					class'H7SkirmishSetupWindowCntl'.static.GetInstance().UpdateAfterPlayerLeaving( i );
				}
			}
		}
	}
}

// when map started directly without lobby (from editor or exe-command)
simulated function InitLobbyDataByMapInfo( H7MapInfo myMapInfo )
{
	local PlayerLobbySelectedSettings empty;
	local int i, lobbyIndex, mapIndex;
	local EPlayerSlot playerSlot;
	local PlayerReplicationInfo PRI;

	;

	mLobbyData.mIsInitialized = true;

	// clear player array
	for(i=0;i<8;i++)
	{
		mLobbyData.mPlayers[i] = empty;
	}

	// MAP_UNCOLL.  MAP_COLLAPSED       LOBBY_COLLAPSED
	// 0            na/neutral player   na/neutral player
	// 1    open    1                   0
	// 2    closed
	// 3    open    2   <---------->    1
	//					     \matching always: map=lobby+1

	lobbyIndex = -1;
	for(i=0;i<8;i++) // setting it up as if there was a lobby that set players into every useable slot in collapsed form excluding closed slots
	{
		// this is mapping an uncollapsed map setting array to a collapsed lobby setting array, to be later used with a collapsed map setting array
		mapIndex = i + 1;
		playerSlot = myMapInfo.mPlayerProperties[mapIndex].mSlot; // uncollapsed map settings
		if(playerSlot == EPlayerSlot_Closed)
		{
			continue;
		}
		lobbyIndex++;
		
		;
		mLobbyData.mPlayers[lobbyIndex].mColor = myMapInfo.mPlayerProperties[mapIndex].mColor;
		if(myMapInfo.mPlayerProperties[mapIndex].mGlobalName == none || myMapInfo.mPlayerProperties[mapIndex].mUseCustomName)
		{
			mLobbyData.mPlayers[lobbyIndex].mName = myMapInfo.mPlayerProperties[mapIndex].mName;
		}
		else
		{
			mLobbyData.mPlayers[lobbyIndex].mName = myMapInfo.mPlayerProperties[mapIndex].mGlobalName.GetName();
		}
		mLobbyData.mPlayers[lobbyIndex].mPosition = EStartPosition(mapIndex);
		mLobbyData.mPlayers[lobbyIndex].mFaction = GetAvailableStartFaction(myMapInfo.mPlayerProperties[mapIndex].mEditorFaction == none ? "" : string(myMapInfo.mPlayerProperties[mapIndex].mEditorFaction.Name));
		mLobbyData.mPlayers[lobbyIndex].mTeam = myMapInfo.mPlayerProperties[mapIndex].mTeam;
		
		if(playerSlot == EPlayerSlot_AI)
		{
			mLobbyData.mPlayers[lobbyIndex].mSlotState = EPlayerSlotState_AI;
			mLobbyData.mPlayers[lobbyIndex].mIsReady = true;
		}
		else if(playerSlot == EPlayerSlot_Human || playerSlot == EPlayerSlot_UserDefine)
		{
			mLobbyData.mPlayers[lobbyIndex].mSlotState = EPlayerSlotState_Open; 
		}
		else if(playerSlot == EPlayerSlot_Closed)
		{
			mLobbyData.mPlayers[lobbyIndex].mSlotState = EPlayerSlotState_Closed; 
		}
	}
	
	// default settings
	mLobbyData.mGameSettings.mUseRandomSkillSystem = false;
	mLobbyData.mMapSettings.mMapFileName = GetCurrentMapName();//class'H7ListingMap'.static.GetMapName(mapHeader.Filepath); TODO: Fix it if needed
	mLobbyData.mMapSettings.mTeamSetup = TEAM_MAP_DEFAULT;
	mLobbyData.mMapSettings.mUseRandomStartPosition = false;
	mLobbyData.mGameSettings.mTeamsCanTrade = true;

	mLobbyData.mGameSettings.mDifficulty = DIFFICULTY_NORMAL;
	
	// TODO ... ?  

	if(IsMultiplayerGame())
	{
		foreach PRIarray( PRI )
		{
			AddPlayerToLobbyData( PRI.PlayerName );
		}
	}
	else
	{
		// add host:
		AddPlayerToLobbyData( class'H7PlayerController'.static.GetPlayerController().PlayerReplicationInfo.PlayerName );
	}
}

simulated function SavegameMPScanCompleted()
{
	AddPlayerToLobbyDataContinue(mTempPlayerName, INDEX_NONE, true);
}

simulated function AddPlayerToLobbyData(string playerName,optional int forceIndex=INDEX_NONE)
{
	local int newIndex;

	newIndex = INDEX_NONE;
	if(forceIndex != INDEX_NONE)
	{
		newIndex = forceIndex;
	}
	else
	{
		if(mLobbyData.mSaveGameFileName != "")
		{
			mTempPlayerName = playerName;
			// if this is too laggy, we will need to save the original names of all players when the lobby of a MP savegame is created, so we can access them here
			class'H7PlayerController'.static.GetPlayerController().ScanForAllSaveGamesMP();
			return;
		}
	}

	AddPlayerToLobbyDataContinue(playerName, newIndex, false);
}

simulated function AddPlayerToLobbyDataContinue(string playerName,optional int newIndex=INDEX_NONE, optional bool fromSaveScan)
{
	local int i;

	if(fromSaveScan)
	{
		// check if that playerName is in the savegame
		for(i=0;i<8;i++)
		{
			if(playerName == class'H7PlayerController'.static.GetPlayerController().GetSaveGameHeaderManagerForSaveGame(int(mLobbyData.mSaveGameFileName)).GetData().mPlayersSettings[i].mName)
			{
				newIndex = i;
				break;
			}
		}
	}

	if(newIndex == INDEX_NONE) // new player joins a savegame || player joins a new game
	{
		for(i=0;i<8;i++)
		{
			if(mLobbyData.mPlayers[i].mSlotState == EPlayerSlotState_Open)
			{
				newIndex = i;
				break;
			}
		}
	}


	if(newIndex == INDEX_NONE)
	{
		// reject player TODO MP
		class'H7ReplicationInfo'.static.PrintLogMessage("Client can not join, no open slot", 0);;
		return;
	}
	
	if(IsMultiplayerGame())
	{
		mLobbyData.mPlayers[newIndex].mName = playerName;
		mLobbyData.mPlayers[newIndex].mSlotState = EPlayerSlotState_Occupied;
	}

	if( class'H7MainMenuHud'.static.GetInstance() != none )
	{
		if(IsMultiplayerGame())
		{
			class'H7PlayerController'.static.GetPlayerController().SendLobbySystemChat( playerName, "CHAT_PLAYER_JOIN" );
		}
		if( IsDuel() )
		{
			class'H7DuelSetupWindowCntl'.static.GetInstance().DisplayPlayerSettings(newIndex,mLobbyData.mPlayers[newIndex]);
			class'H7DuelSetupWindowCntl'.static.GetInstance().SetNewList(
				"mDropClientSlot",class'H7DuelSetupWindowCntl'.static.GetInstance().GetEnumList("ESlot",newIndex),newIndex
			);
		}
		else
		{
			class'H7MainMenuHud'.static.GetInstance().GetSkirmishSetupWindowCntl().DisplayPlayerSettings(newIndex,mLobbyData.mPlayers[newIndex]);
			class'H7MainMenuHud'.static.GetInstance().GetSkirmishSetupWindowCntl().SetNewList(
				"mDropSlot",class'H7MainMenuHud'.static.GetInstance().GetSkirmishSetupWindowCntl().GetEnumList("ESlot",newIndex),newIndex
			);
		}
	}

	LobbyUpdateOnlineGameSettingsSlots();
}

// true = only uses difficulty settings on map init (campaigns)
// false = uses all lobby data on map init (skirmish)
simulated function WriteLobbyDataToTransitionData( bool useLobbyData )
{
	local int i;
	local array<PlayerLobbySelectedSettings> playerSettings;

	class'H7TransitionData'.static.GetInstance().SetMapSettings(mLobbyData.mMapSettings);
	class'H7TransitionData'.static.GetInstance().SetGameSettings(mLobbyData.mGameSettings);

	for(i=0;i<8;i++)
	{
		playerSettings.AddItem(mLobbyData.mPlayers[i]);
	}
	class'H7TransitionData'.static.GetInstance().SetPlayersSettings(playerSettings);

	class'H7TransitionData'.static.GetInstance().SetUseMe( useLobbyData );
}

simulated function WriteGameDataToTransitionData(optional bool fromResultWindow = false)
{
	local H7TransitionData transitionData;
	local H7AdventureController advCntl;

	advCntl = class'H7AdventureController'.static.GetInstance();
	transitionData = class'H7TransitionData'.static.GetInstance();
	if( advCntl == none || transitionData == none ) { ; return; }

	transitionData.SetMapSettings( advCntl.GetMapSettings() );
	if(!fromResultWindow)
	{
		transitionData.SetGameSettings( advCntl.GetGameSettings() );
	}
	transitionData.SetPlayersSettings( advCntl.GetPlayerSettings() );
	transitionData.SetUseMe( true );
}

// returns the mapheader row (H7MapHeaderPlayerInfoProperty) that belongs to that lobby player index
// playerIndex x belongs to playerIndex x's position's row
simulated function H7MapHeaderPlayerInfoProperty GetMapHeaderPlayerInfoByLobbyPlayerIndex(int playerIndex)
{ 
	return GetMapHeaderPlayerInfoByPosition(mLobbyData.mPlayers[playerIndex].mPosition);
}

// returns the mapheader row (H7MapHeaderPlayerInfoProperty) that belongs to that position
//                                 row[0] is neutral player
// START_POSITION_1 (1) belongs to row[1]
// START_POSITION_2 (2) belongs to row[0]
simulated function H7MapHeaderPlayerInfoProperty GetMapHeaderPlayerInfoByPosition(EStartPosition startPosition)
{ 
	local H7MapHeaderPlayerInfoProperty defaultPorperty;

	if(mMapHeader.AdventureMapData.mPlayerInfoProperties.Length==0)
	{
		defaultPorperty.Position=PN_NEUTRAL_PLAYER;
		defaultPorperty.Slot=EPlayerSlot_Closed;
		defaultPorperty.Team=TN_NO_TEAM;
		defaultPorperty.Color=PCOLOR_NEUTRAL;
		return defaultPorperty;
	}
	if(startPosition == START_POSITION_RANDOM)
	{
		return mMapHeader.AdventureMapData.mPlayerInfoProperties[0];
	}
	else
	{
		return mMapHeader.AdventureMapData.mPlayerInfoProperties[startPosition-1];
	}
}

simulated function bool IsDuel()
{
	local H7OnlineGameSettings onlineSettings;

	onlineSettings = class'H7MultiplayerGameManager'.static.GetOnlineGameSettings();
	if( onlineSettings != none )
	{
		return onlineSettings.GetGameType() == 1;
	}

	return mLobbyData.mIsDuel;
}

simulated function bool IsLAN()
{
	local H7OnlineGameSettings onlineSettings;

	onlineSettings = class'H7MultiplayerGameManager'.static.GetOnlineGameSettings();
	if( onlineSettings != none )
	{
		return onlineSettings.bIsLanMatch;
	}

	return false;
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
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
