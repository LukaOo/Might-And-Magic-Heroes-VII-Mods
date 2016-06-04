//=============================================================================
// H7PlayerController
//=============================================================================
// Base class for Combat-, Adventure- and Town-PlayerController(s)
//
// ! Moved exec functions LeftMouseDown(), ReleaseLeftMouse() and 
//   ReleaseRightMouse() to the CombatPlayerController and 
//   AdventurePlayerController class
//
//	To enable server migration (set to true bAllowHostMigration in BaseGame.ini and AllowPeerConnection in BaseEngine.ini), 
//	Also WorldInfo.ToggleHostMigration(true); needs to be called in code, for example in the PostBeginPlay() of this class
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7PlayerController extends SaveGameStatePlayerController
	dependson(H7Command, H7StructsAndEnumsNative)
	config(Game)
	native;

const MAX_PRIVILEGES_COUNT = 20;

// config
var config bool mRetroFilter;
var config string mActiveProfile;
var config bool mAlwaysQuickCombat;
var config bool mIsAutoSkilling;

// panning parameters and inputs
var protected input byte        IsPanningUp, IsPanningDown, IsPanningLeft, IsPanningRight;
var protected bool              IsPanningMouse;
var protected config bool       IsInverted;
var config bool                 mBorderPan;
var config float                PanningMouseSensitivity;
var config float                GeneralPanningSensitivity;
var config float                MouseRotatingSensitivity;
var config float                KeyboardRotatingSensitivity;
var config float                KeyboardPanningSensitivity;
var protected Vector2D          StartPanPosition;
// the value which defines the outer border where border mouse screen panning starts
var protected config int                  MousePanningCache;
// mouse wheel states
var protected bool              MouseWheelForward, MouseWheelBackward;
var protected float             MouseWheelHoldTimer;
//
var protected Rotator           mCursorDirection;
// mouse cursor is hovering over menu items 
var protected bool              mHUDMouseOver;
var protected int               mHUDMouseOverCounter;
var protected bool              mSkipNextCursorChange;
// mouse cursor is hovering outside menu items but popup is open
var protected bool              mPopupIsOpen;
var protected bool              mCameraActionIsRunning;
// input on/off toggle
var protected bool              mAllowInput;
var protected bool              mAllowInputFromKismet;
var protected bool              mMouseWheelCapturedByFlash;
var protected bool              mCursorWasInit;
var protected bool              mIsCaravanTurn;
var protected bool              mIsCommandRequested;
var protected bool              mIsInLoadingScreen;

var protected bool              mShiftDown;

var protected bool              MouseRotationAllowed;
var protected float             MouseX;
var protected float             MouseY;

var protected float             mCacheGameSpeed;

var protected Vector2D          mLastMousePosition;
var bool                        mIsMouseMoving;

var protected H7MessageSystem       mMessageSystem;
var protected H7OptionsManager      mOptionManager;
var protected H7KeybindManager      mKeybindManager;
var protected H7PatchingController  mPatchingController;
var protected H7TownAssetLoader     mTownAssetLoader;

var protected Vector			mCurrMoveDir;

var protected bool				mIsInCinematicView;
var protected bool				mHideCursor;
var protected bool				mIsFlythroughRunning;

var protected bool              mIsPlayInEditor;

var protected IntPoint          mBeforeSaveResolution;
var protected EWindowMode       mBeforeSaveWindowMode;

var protected bool              mBufferedCommandResolution;
var protected IntPoint          mBufferedCommandResolution_Params;
var protected bool              mBufferedCommandWindowMode;
var protected EWindowMode       mBufferedCommandWindowMode_Params;

var protected bool				mWasCinematicRunning;
var protected float             mCinematicTime;
var protected bool              mCinematicWasSkipped;
// flash receives the key 1 frame later then unreal. 
// mMovieSkippedLastFrame becomes 2, when movie skipped, ticks down to 1, blocks flash input at 1, ticks down to 0, is dormant until next time
var protected int               mMovieSkippedLastFrame;

var protected bool              mDidToggle;
var protected bool              mGameStarted;

var protected transient int     mResolutionRevertSeconds;

var config bool mShowUnreachableServers;

function H7PlayerReplicationInfo GetPlayerReplicationInfo() { return H7PlayerReplicationInfo(PlayerReplicationInfo); }
function H7PatchingController GetPatchingController() 
{ 
	if(mPatchingController == none) 
	{
		mPatchingController = new class'H7PatchingController';
	}
	return mPatchingController;
}
function H7TownAssetLoader GetTownAssetLoader() 
{ 
	if(mTownAssetLoader == none) 
	{
		mTownAssetLoader = new class'H7TownAssetLoader';
	}
	return mTownAssetLoader;
}
function H7MessageSystem GetMessageSystem() { return mMessageSystem; }

function bool IsFlythroughRunning()     { return mIsFlythroughRunning;}
function bool IsInCinematicView()       { return mIsInCinematicView;  }
function bool IsMouseMoving()           { return mIsMouseMoving; }

function bool IsInLoadingScreen() { return mIsInLoadingScreen; }
function SetInLoadingScreen(bool val) { mIsInLoadingScreen = val; } 

function bool GetAlwaysQuickCombat() { return mAlwaysQuickCombat; }
function SetAlwaysQuickCombat(bool val) { mAlwaysQuickCombat = val; } 

function bool GetAutoSkilling() { return mIsAutoSkilling; }
function SetAutoSkilling(bool val) { mIsAutoSkilling = val; }

function bool GetIsMousePanning(){ return IsPanningMouse; }

function bool GetMousePanInvertion(){ return IsInverted; }
function SetMousePanInvertion( bool value ){ IsInverted = value; }

function bool GetBorderPan(){ return mBorderPan; }
function SetBorderPan( bool value ){ mBorderPan = value; }

function float GetGeneralPanningSensitivity() { return GeneralPanningSensitivity; }
function SetGeneralPanningSensitivity( float value ) { GeneralPanningSensitivity = value; }

function float GetKeyboardPanningSensitivity() { return KeyboardPanningSensitivity; }
function SetKeyboardPanningSensitivity( float value ) { KeyboardPanningSensitivity = value; }

function float GetMouseRotatingSensitivity() { return MouseRotatingSensitivity; }
function SetMouseRotatingSensitivity( float value ) { MouseRotatingSensitivity = value; }

function float GetKeyboardRotatingSensitivity() { return KeyboardRotatingSensitivity; }
function SetKeyboardRotatingSensitivity( float value ) { KeyboardRotatingSensitivity = value; }

function bool IsShiftDown() {return mShiftDown;}

native function FlushKeys();

/**
 * gets the PlayerController to see what buttons are pressed atm
 */
static function H7PlayerController GetPlayerController()
{
	local H7PlayerController MyPlayerController;
	local WorldInfo MyWorld;

	MyWorld = class'WorldInfo'.static.GetWorldInfo();
	if (MyWorld != None)
	{
		MyPlayerController = H7PlayerController(MyWorld.GetALocalPlayerController());
	}
	return MyPlayerController;
}

static function LocalPlayer GetLocalPlayer()
{
	return LocalPlayer( GetPlayerController().Player );
}

simulated event PostBeginPlay()
{
	local H7ContentScanner scanner;

	super.PostBeginPlay();

	RetroFilter(true, mRetroFilter);

	mMessageSystem = new class'H7MessageSystem';
	mMessageSystem.Init();
	mIsPlayInEditor = class'Engine'.static.GetCurrentWorldInfo().IsPlayInEditor();
	
	;
	class'H7PlayerProfile'.static.InitPlayerProfile(mActiveProfile);
	
	if(class'H7TransitionData'.static.GetInstance().GetContentScanner() != none)
		return;
	
	scanner = new class'H7ContentScanner';
	scanner.Initialize();
	class'H7TransitionData'.static.GetInstance().SetContentScanner(scanner);
}

function InitLoadingScreen(optional MaterialInterface newBackground, optional bool isCombat)
{
	local LocalPlayer theLocalPlayer;
	local H7GameViewportClient gameViewport;

	theLocalPlayer = GetLocalPlayer();

	//Prepare map switch and stop ambient sfx
	class'H7TransitionData'.static.GetInstance().SetIsInMapTransition(true);
	class'H7PlayerController'.static.GetPlayerController().SetInLoadingScreen( true );
	
	if(class'H7AdventureController'.static.GetInstance() != none)
	{
		class'H7ReplicationInfo'.static.GetInstance().GetSoundManager().LoadingScreenEnabledDelayed(true);
	}
	else
	{
		class'H7SoundController'.static.GetInstance().LoadingScreenEnabled(true);
	}

	if (theLocalPlayer != None)
	{
		gameViewport = H7GameViewportClient(theLocalPlayer.ViewportClient);
		if (gameViewport != None)
		{
			gameViewport.InitLoadscreen(newBackground, isCombat);
		}
	}
}

function TogglePopup(H7FlashMoviePopupCntl popup)
{
	if(GetHud().GetCurrentContext() == popup)
	{
		popup.ClosePopup();
	}
	else
	{
		popup.OpenPopup();
	}
}

exec function RightMouseDown()
{
	GetHud().SetRightClickThisFrame(true);
	GetHud().SetRightMouseDown(true);
}

exec function HideCursor( bool val )
{
	mHideCursor = val;
}

exec function ReleaseRightMouse()
{
	
		GetHud().SetRightClickThisFrame(true);
		GetHud().SetRightMouseDown(false);
		
}

function SetBigHead(bool newBigHead)
{
	local H7HeroAnimControl theAnimCtrl;
	local array<SkelControlSingleBone> theSkelNodes;
	local SkelControlSingleBone theSkelNode;
	local float skelStrength;

	if (newBigHead == true)
	{
		skelStrength = 1.0f;
	}

	foreach WorldInfo.DynamicActors(class'H7HeroAnimControl', theAnimCtrl)
	{
		theSkelNodes = theAnimCtrl.GetBigHeadNodes();
		foreach theSkelNodes(theSkelNode)
		{
			theSkelNode.SetSkelControlActive(newBigHead);
			theSkelNode.SetSkelControlStrength(skelStrength, 0.0f);
		}
	}
}

function SetPixellated(bool newPixellated)
{
	class'H7ReplicationInfo'.static.GetInstance().GetPostprocessManager().InitPixellated();
	class'H7ReplicationInfo'.static.GetInstance().GetPostprocessManager().SetPixellated(newPixellated);
	ResetCamera();
	class'H7Camera'.static.GetInstance().Reset();
}

native function FindAllInterpActors(out array<InterpActor> searchResult);

// BackMenu for main menu, overwritten in combat/adventure huds
exec function ToggleMenu() // it's really: Cancel current window/action, Escape
{
	mDidToggle = true;

	//Heropedia
	if(GetHUD().GetHeropedia().GetPopup().IsVisible())
	{
		GetHUD().GetHeropedia().Closed();
		return;
	}

	// skirmish
	if(H7MainMenuHud(GetHud()).GetSkirmishSetupWindowCntl().GetSkirmishWindow().IsVisible())
	{
		if(H7MainMenuHud(GetHud()).GetSkirmishSetupWindowCntl().IsHeroSelectionVisible())
		{
			H7MainMenuHud(GetHud()).GetSkirmishSetupWindowCntl().CloseHeroSelection();
			return;
		}
		if(H7MainMenuHud(GetHud()).GetSkirmishSetupWindowCntl().IsCustomDifficultyVisible())
		{
			H7MainMenuHud(GetHud()).GetSkirmishSetupWindowCntl().CloseCustomDifficulty();
			return;
		}
		H7MainMenuHud(GetHud()).GetSkirmishSetupWindowCntl().ClosePopup();
		return;
	}

	// duel
	if(H7MainMenuHud(GetHud()).GetDuelSetupWindowCntl().GetDuelWindow().IsVisible())
	{
		if(H7MainMenuHud(GetHud()).GetDuelSetupWindowCntl().IsHeroSelectionVisible())
		{
			H7MainMenuHud(GetHud()).GetDuelSetupWindowCntl().CloseHeroSelection();
			return;
		}
		H7MainMenuHud(GetHud()).GetDuelSetupWindowCntl().ClosePopup();
		return;
	}

	mDidToggle = false;
	return;
}

// ESC does not use this check, all others should
// every keybindCommandFunction should check if the current context blocks it
function bool CurrentContextBlocksKeybind(string commandFunctionName) // blockkeybind blockhotkey
{
	local H7FlashMoviePopupCntl currentPopup;
	local String tmp;

	if(self.isA('H7AdventurePlayerController'))
	{
		// not your turn in multiplayer
		if( WorldInfo.GRI.IsMultiplayerGame() && !class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().IsControlledByLocalPlayer() )
		{
			if(commandFunctionName != "OpenOptions" && commandFunctionName != "ContinueContextOrChat")
			{
				return true;
			}
		}
		if( class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetPlayerType() == PLAYER_AI )
		{
			if(commandFunctionName != "OpenOptions" && commandFunctionName != "ContinueContextOrChat")
			{
				return true;
			}
		}

		if(H7AdventurePlayerController(self).IsFullScreenMovieRunning()) // movie counts as blocking context for all calling keybinds
		{
			return true;
		}
		if(!H7AdventurePlayerController(self).IsKismetAllowsInput()) // kismet counts as blocking context for all calling keybinds
		{
			return true;
		}
		if(IsCameraActionRunning())
		{
			return true;
		}
	}

	if(GetHud().IsFocusOnInput()) return true; // having the selection focus inside a text input field blocks all calling keybinds

	// the player cannot use shortcuts when he has to retreat with an army
	if( class'H7AdventurePlayerController'.static.GetAdventurePlayerController().GetRetreatingArmy() != none )
	{
		return true;
	}

	currentPopup = GetHud().GetCurrentContext();	
	if(currentPopup != none) tmp = "blocksKeys=" @ currentPopup.IsBlockingStandardKeys() @ "allows current CommandFunction=" @ currentPopup.IsAllowingCommandFunction(commandFunctionName);
	tmp=tmp; // to avoid the compile warning

	if(GetHUD().GetPauseMenuCntl().GetMapResultPopUp().IsVisible())
		return true;

	;
	
	if(currentPopup != none && currentPopup.IsBlockingStandardKeys()) 
	{
		if(currentPopup.IsAllowingCommandFunction(commandFunctionName))
		{
			return false; // if popup is blocking but allows specific commands => allow specific commmand
		}
		else return true;
	}
	else return false; // if popup is not blocking => allow all
}

function SkipMovie()
{
	if(IsCinematicRunning())
	{
		ClientStopMovie(0.0f,false,true,true);
		mCinematicWasSkipped = true;
		mMovieSkippedLastFrame = 2; // HACK to block parallel flash key event that will arrive later in the next frame
	}
}

// This is used to tell player profile what cinematics were played
function HandleCinematics( float DeltaTime )
{
	if (IsCinematicRunning())
	{
		if (!mWasCinematicRunning) // Movie playing for the first time
		{
			mWasCinematicRunning = true;
			mCinematicTime = 0.0f;
		}

		mCinematicTime += DeltaTime;
	}
	else
	{
		if (mWasCinematicRunning)
		{
			HandleCinematicEnd(DeltaTime);
		}
	}
}

function HandleCinematicEnd(float DeltaTime)
{
	local string cinematicName;

	mCinematicTime += DeltaTime;

	cinematicName = GetLastPlayedCinematicName();

	class'H7PlayerProfile'.static.GetInstance().AddPlayedCinematic(cinematicName, mCinematicWasSkipped, mCinematicTime);

	// Reset
	mWasCinematicRunning = false;
	mCinematicWasSkipped = false;
	mCinematicTime = 0.0f;
}

event PlayerTick( float DeltaTime )
{
	local LocalPlayer dasLocalPlayer;
	dasLocalPlayer = LocalPlayer(Player);

	super.PlayerTick(DeltaTime);

	class'H7PlayerProfile'.static.GetInstance().TickSave(DeltaTime);
	
	class'H7TransitionData'.static.GetInstance().GetContentScanner().ComputeTick();

	HandleCinematics(DeltaTime);
	
	// Tick timers of player profile
	// When not to tick -> GamePaused, Game Loading, Game in Cinematics,
	if( class'H7PlayerProfile'.static.GetInstance() != none && !IsPaused() && !IsFullScreenMovieRunning() && !IsInCinematicView())
	{
		// Am I on AM or CM
		if(H7AdventurePlayerController(self) != none || H7CombatPlayerController(self) != none)
		{
			class'H7PlayerProfile'.static.GetInstance().TickGameplayTime(DeltaTime);
			
			// If I am AMPC
			if( class'H7AdventureController'.static.GetInstance() != none 
				&& class'H7AdventureController'.static.GetInstance().GetCampaign() != none)
			{
				// Tick campaign map
				class'H7PlayerProfile'.static.GetInstance().TickCampaignTime(DeltaTime, class'H7AdventureController'.static.GetInstance().GetCampaign());
				class'H7AdventureController'.static.GetInstance().TickSessionGameplayTime(DeltaTime);
			}
			else if(H7AdventurePlayerController(self) == none && H7CombatPlayerController(self) != none)
			{
				// Tick Duel
				class'H7PlayerProfile'.static.GetInstance().TickDuelMapTime(DeltaTime);
			}
			else
			{
				// Tick normal map (skirmish, scenario)
				class'H7PlayerProfile'.static.GetInstance().TickMapTime(DeltaTime);
				if(class'H7AdventureController'.static.GetInstance() != none)
				{
					class'H7AdventureController'.static.GetInstance().TickSessionGameplayTime(DeltaTime);
				}
			}
		}
		

	}

	if (VSize2D(mCurrMoveDir) > 0.0f)
	{
		MoveArmy();
		mCurrMoveDir = vect( 0, 0, 0 );
	}

	if(!mCursorWasInit)
	{
		SetCursor(CURSOR_NORMAL);
	}

	if(class'H7GUIGeneralProperties'.static.GetInstance().GetRightMouseRotatingEnabled())
	{
		if( mLastMousePosition != dasLocalPlayer.ViewportClient.GetMousePosition() )
		{
			MouseX = mLastMousePosition.X - dasLocalPlayer.ViewportClient.GetMousePosition().X;
			MouseY = mLastMousePosition.Y - dasLocalPlayer.ViewportClient.GetMousePosition().Y;
			mLastMousePosition = dasLocalPlayer.ViewportClient.GetMousePosition();
			mIsMouseMoving = true;
		}
		else
		{
			MouseX = 0;
			MouseY = 0;
			mIsMouseMoving = false;
		}
	}

}

function SetBufferedCommand_Resolution(int x,int y)
{
	mBufferedCommandResolution = true;
	mBufferedCommandResolution_Params.X = x;
	mBufferedCommandResolution_Params.Y = y;
}

function SetBufferedCommand_WindowMode(EWindowMode windowMode)
{
	mBufferedCommandWindowMode = true;
	mBufferedCommandWindowMode_Params = windowMode;
}

function ApplyBufferedCommands(optional bool offerRevert=true)
{
	local string message;
	local string command;
	local int windowMode;
	local Vector2D desiredResolution,beforeResolution,afterResoltion;

	if(mBufferedCommandResolution || mBufferedCommandWindowMode)
	{
		if(mBufferedCommandResolution)
		{
			desiredResolution.X = mBufferedCommandResolution_Params.X;
			desiredResolution.Y = mBufferedCommandResolution_Params.Y;
		}
		else
		{
			desiredResolution = GetScreenResolution();
		}
		command = "SETRES" @ int(desiredResolution.X) $ "x" $ int(desiredResolution.Y);

		if(mBufferedCommandWindowMode)
		{
			if(mBufferedCommandWindowMode_Params == WM_WINDOW)
			{
				command = command @ "w";
			}
			else if(mBufferedCommandWindowMode_Params == WM_FULLSCREEN)
			{
				command = command @ "f";
			}
			else if(mBufferedCommandWindowMode_Params == WM_BORDERLESS_WINDOW)
			{
				command = command @ "b";
			}
		}

		;

		beforeResolution = GetScreenResolution();
		windowMode = GetWindowMode();
		mBeforeSaveWindowMode = EWindowMode(windowMode);
		mBeforeSaveResolution.X = beforeResolution.X;
		mBeforeSaveResolution.Y = beforeResolution.Y;

		ConsoleCommand(command);
		afterResoltion = GetScreenResolution();

		if(afterResoltion == desiredResolution)
		{
			// all ok
			mBufferedCommandResolution = false;
			mBufferedCommandWindowMode = false;

			if(offerRevert)
			{
				// timer to revert
				mResolutionRevertSeconds = 15;
				class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().YesNoPopup(
					Repl(class'H7Loca'.static.LocalizeSave("PU_RESOLUTION_KEEP","H7Popup"),"%time",mResolutionRevertSeconds)
					,"OK","PU_REVERT",none,RevertResolution);
				GetHud().SetSelfMadeTimer(1,TickResolution);
				class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().SetTimer(15,RevertResolution);
			}
		}
		else
		{
			// failed to set resolution (and or windowmode?)
			message = class'H7Loca'.static.LocalizeSave("MSG_FAILED_SET_RESOLUTION","H7Message");
			message = Repl(message, "%resX", int(afterResoltion.X));
			message = Repl(message, "%resY", int(afterResoltion.Y));
			class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage( message ,MD_SIDE_BAR);
			
			mBufferedCommandResolution = false;
			mBufferedCommandWindowMode = false;
			
			beforeResolution = beforeResolution;
			// set back to old resolution: // BETA HACK to avoid weird aspect ratios
			//SetBufferedCommand_Resolution(beforeResolution.X,beforeResolution.Y);
		}
	}
}

function TickResolution()
{
	local string newText;
	if(class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().IsVisible())
	{
		mResolutionRevertSeconds--;
		newText = Repl(class'H7Loca'.static.LocalizeSave("PU_RESOLUTION_KEEP","H7Popup"),"%time",mResolutionRevertSeconds);
		class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().SetQuestionText(newText);
		GetHud().SetSelfMadeTimer(1,TickResolution);
	}
}

function RevertResolution()
{
	;
	SetBufferedCommand_Resolution(mBeforeSaveResolution.X,mBeforeSaveResolution.Y);
	SetBufferedCommand_WindowMode(mBeforeSaveWindowMode);
	ApplyBufferedCommands(false);
}

simulated event Destroyed()
{
	super.Destroyed();

	mMessageSystem = none;
	mOptionManager = none;
	mKeybindManager = none;
}

function H7OptionsManager GetOptionManager()
{
	//GetKeybindManager();
	if(mOptionManager == none)
	{
		mOptionManager = new class'H7OptionsManager';
		mOptionManager.CreateSetup();
	}
	return mOptionManager;
}

function H7KeybindManager GetKeybindManager() 
{ 
	if(mKeybindManager == none)
	{
		mKeybindManager = new class'H7KeybindManager';
		mKeybindManager.CreateSetup();
	}
	return mKeybindManager; 
}

/** Apply Adventure or Combat relevant Gfx settings */
function ApplyGameModeGfxSettings(bool bCombat)
{
	if (bCombat)
	{
		ConsoleCommand("scale set PerObjectShadowTransition 10");
		ConsoleCommand("scale set ShadowTexelsPerPixel 3.25");
	}
	else
	{
		ConsoleCommand("scale set PerObjectShadowTransition 10");
		ConsoleCommand("scale set ShadowTexelsPerPixel 1.273240");
	}
}

// 1.0000  -> 1
// -1.5    -> -1.5
// 14.7349 -> 14.73
// 7.4992  -> ?7.40
// 0.33333 -> 0.33
// 0.5     -> 0.5
exec function TestRounding()
{
	local string hack; // TODO remove hack
	
	;
	;
	;
	;
	;
	;
	;
	;
	;
	;
	;
	
	hack = "-26%";
	if(left(hack,1) == "-")
	{
		;
	}
	else
	{
		;
	}

}

exec function RestartCombatHud()
{
	GetHud().RestartMovie(GetCombatMapHud().GetCombatHudCntl());
}

exec function RetroFilter(optional bool bSetVal, optional bool bActivate)
{
	if (bSetVal)
		mRetroFilter = bActivate;
	else
		mRetroFilter = !mRetroFilter;

	if (mRetroFilter)
		ConsoleCommand("Scale set ScreenPercentage 35");
	else
		ConsoleCommand("Scale set ScreenPercentage 100");

	SaveConfig();
}

exec function ToggleGrid()
{
	if(CurrentContextBlocksKeybind(class'H7GameUtility'.static.GetFunctionName(0))) return;

	class'H7GUIGeneralProperties'.static.GetInstance().mCombatGridVisible = !class'H7GUIGeneralProperties'.static.GetInstance().mCombatGridVisible;
	class'H7GUIGeneralProperties'.static.GetInstance().SaveConfig();

	class'H7CombatMapGridController'.static.GetInstance().GetDecal().SetHidden(
		!class'H7GUIGeneralProperties'.static.GetInstance().mCombatGridVisible	
	);
}

exec function SetChristmasMode( bool value )
{
	if( value )
	{
		if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
		{
			class'H7CombatMapGridController'.static.GetInstance().GetDecal().SetHidden( true );
			if( class'H7PlayerController'.static.GetPlayerController().GetHud().bShowHUD )
			{
				class'H7PlayerController'.static.GetPlayerController().GetHud().ToggleHUD();
			}
			mIsInCinematicView = true;
		}
	}
	else
	{
		if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
		{
			class'H7CombatMapGridController'.static.GetInstance().GetDecal().SetHidden( false );
			if( !class'H7PlayerController'.static.GetPlayerController().GetHud().bShowHUD )
			{
				class'H7PlayerController'.static.GetPlayerController().GetHud().ToggleHUD();
			}
			mIsInCinematicView = false;
		}
	}
}

exec function FreeCam(optional bool bReset)
{
	//local name moveKey;
	//local string moveBind;

	if (class'H7Camera'.static.GetInstance().CameraStyle != 'FreeCam_Default' && !bReset)
	{
		class'H7Camera'.static.GetInstance().CameraStyle = 'FreeCam_Default';
		SetRotation(class'H7Camera'.static.GetInstance().GetCurrentRotation());
		SetLocation(class'H7Camera'.static.GetInstance().Location);
		//moveKey = 'ADollyForward';
		//GetPlayerInput().MoveForwardSpeed *= -1.0f;
		//moveBind = GetPlayerInput().GetBind(moveKey);
		//`log("moveBind "$moveBind$" "$moveKey);
		ConsoleCommand("ghost");
	}
	else
	{
		ConsoleCommand("walk");
		GetPlayerInput().MoveForwardSpeed *= -1.0f;
		class'H7Camera'.static.GetInstance().CameraStyle = 'FirstPerson';
	}
}

exec function EgoCam()
{
	if (class'H7Camera'.static.GetInstance().CameraStyle == 'FirstPerson') // not actually first person, but default H7 cam
	{
		class'H7Camera'.static.GetInstance().CameraStyle = 'Fixed';
		Pawn.SetPhysics(PHYS_Interpolating);
		Pawn.SetCollision(false, false, true);
		Pawn.SetHardAttach(true);
		Pawn.SetRotation(class'H7AdventureController'.static.GetInstance().GetSelectedArmy().Rotation);
		Pawn.SetBase(class'H7AdventureController'.static.GetInstance().GetSelectedArmy());
		Pawn.SetRelativeLocation(Vect(0,0,190));
	}
	else
	{
		Pawn.SetBase(None);
		Pawn.SetPhysics(PHYS_Interpolating);
		class'H7Camera'.static.GetInstance().CameraStyle = 'FirstPerson';
	}
}

reliable client event ClientMessage( coerce string S, optional Name Type, optional float MsgLifeTime )
{
	local KismetDrawTextInfo KismetMsg;

	KismetMsg.MessageText = S;
	KismetMsg.MessageEndTime = WorldInfo.TimeSeconds + 3.0f;
	if( class'H7PlayerController'.static.GetPlayerController().GetHud() != none )
	{
		class'H7PlayerController'.static.GetPlayerController().GetHud().KismetTextInfo.AddItem(KismetMsg);
	}

	super.ClientMessage(S, Type, MsgLifeTime);
}

function UpdateRotation( float DeltaTime )
{
	local Rotator	DeltaRot, ViewRotation;

	ViewRotation = Rotation;

	// Calculate Delta to be applied on ViewRotation
	DeltaRot.Yaw	= PlayerInput.aTurn;
	DeltaRot.Pitch	= PlayerInput.aLookUp;

	ProcessViewRotation( DeltaTime, ViewRotation, DeltaRot );
	SetRotation(ViewRotation);

	ViewShake( deltaTime );
}

function Rotator GetCursorDirection() { return mCursorDirection; }

event bool IsLookInputIgnored()
{
	return super.IsLookInputIgnored() || IsPopupOpen() || !IsKeyInputAllowed() || IsInLoadingScreen(); 
}


function float GetPanningVertical()
{
	local LocalPlayer LocalPlayer;
	local float y, x;
	LocalPlayer = LocalPlayer(Player);

	if (IsLookInputIgnored())
	{
		return 0;
	}

	y = LocalPlayer.ViewportClient.GetMousePosition().Y;
	x = LocalPlayer.ViewportClient.GetMousePosition().X;

	if(isPanningUp == 1 && isPanningDown == 1)
	{
		return 0;
	}
	else if(isPanningUp == 1)
	{ 
		return 1 * KeyboardPanningSensitivity;
	}
	else if(isPanningDown == 1)
	{ 
		return -1 * KeyboardPanningSensitivity;
	}
	else if(!mIsPlayInEditor && GetBorderPan())
	{
		if(x > GetScreenResolution().X || x < 0 || y > GetScreenResolution().Y || y < 0)
		{
			return 0; // don't pan if the mouse is outside of screen
		}
		if(y >= GetScreenResolution().Y - MousePanningCache)
		{
			return -1 * GeneralPanningSensitivity;
		}
		else if(y <= MousePanningCache)
		{
			return 1 * GeneralPanningSensitivity;
		}
	}
	return 0;
}

function float GetPanningHorizontal()
{
	local LocalPlayer LocalPlayer;
	local float y, x;
	LocalPlayer = LocalPlayer(Player);

	if (IsLookInputIgnored())
	{
		return 0;
	}

	y = LocalPlayer.ViewportClient.GetMousePosition().Y;
	x = LocalPlayer.ViewportClient.GetMousePosition().X;
	
	if(isPanningRight == 1 && isPanningLeft == 1)
	{ 
		return 0;
	}
	else if(isPanningRight == 1)
	{
		return 1 * KeyboardPanningSensitivity;
	}
	else if(isPanningLeft == 1)
	{
		return - 1 * KeyboardPanningSensitivity;
	}
    else if(!mIsPlayInEditor && GetBorderPan())
	{
		if (x > GetScreenResolution().X || x < 0 || y > GetScreenResolution().Y || y < 0)
		{ 
			return 0; // don't pan if the mouse is outside of screen
		}
		if (x >= GetScreenResolution().X - MousePanningCache)
		{ 
			return 1 * GeneralPanningSensitivity;
		}
		else if (x <= MousePanningCache )
		{
			return -1 * GeneralPanningSensitivity;
		}
	}
	return 0;
}

function Vector PanningCameraMovement()
{
	local Vector diff;

	if (IsLookInputIgnored())
	{
		diff.X = 0.f;
		diff.Y = 0.f;
		diff.Z = 0.f;

		return diff;
	}

	if(IsPanningMouse && IsInverted)
	{   
		diff.X =  -1 * (GetMousePanDiff().Y * ((GeneralPanningSensitivity* 2.f )* PanningMouseSensitivity)); //Vertical
		diff.Y = GetMousePanDiff().X * ( GeneralPanningSensitivity * PanningMouseSensitivity);
		diff.Z = 0.f;
	}
	else
	{
		diff.X = (GetMousePanDiff().Y * ((GeneralPanningSensitivity* 2.f ) * PanningMouseSensitivity)); //Vertical
		diff.Y = -1 * (GetMousePanDiff().X * ( GeneralPanningSensitivity * PanningMouseSensitivity));
		diff.Z = 0.f;
	}

	return diff;
}

function float GetDolly()
{
	return PlayerInput.RawJoyUp;
}

function float GetRotation()
{
	if( GetHUD().IsRightMouseDown() && MouseRotationAllowed )
	{
		return MouseX / 10 * MouseRotatingSensitivity;
	}
	return PlayerInput.RawJoyRight * KeyboardRotatingSensitivity;
}

function Vector2D GetMousePanDiff()
{
	local Vector2D MousePanDiff;
	local LocalPlayer LocalPlayer;
	local Vector2D MousePosition;
	
	if(IsPanningMouse)
	{
		LocalPlayer = LocalPlayer(Player);
		if (LocalPlayer != None && LocalPlayer.ViewportClient != None)
		{
			MousePosition = LocalPlayer.ViewportClient.GetMousePosition();
		}
		MousePanDiff = StartPanPosition - MousePosition;
	}
	return MousePanDiff;
}

function Vector2D GetScreenResolution()
{
	local Vector2D ViewportResolution;
	local LocalPlayer LocalPlayer;

	LocalPlayer = LocalPlayer(Player);
	if (LocalPlayer != None && LocalPlayer.ViewportClient != None)
	{
		LocalPlayer.ViewportClient.GetViewportSize(ViewportResolution);
	}
	return ViewportResolution;
}

function array<String> GetWindowModeList()
{
	local array<String> list;
	local int i;
	local Name enumName;
	for(i=0;i<WM_MAX;i++)
	{
		enumName = GetEnum(Enum'EWindowMode', i);
		list.AddItem(string(enumName));
	}
	return list;
}

function int GetWindowMode()
{
	local LocalPlayer LocalPlayer;

	LocalPlayer = LocalPlayer(Player);
	if (LocalPlayer != None && LocalPlayer.ViewportClient != None)
	{
		if(LocalPlayer.ViewportClient.IsFullScreenViewport())
		{
			return WM_FULLSCREEN;
		}
		else if(LocalPlayer.ViewportClient.IsBorderlessViewport())
		{
			return WM_BORDERLESS_WINDOW;
		}
		else
		{
			return WM_WINDOW;
		}
	}
	return -1;
}

function SetWindowMode(int windowModeInt)
{
	local EWindowMode windowMode;

	windowMode = EWindowMode(windowModeInt);
	SetBufferedCommand_WindowMode(windowMode);
}

function bool GetVSync()
{
	local LocalPlayer LocalPlayer;

	LocalPlayer = LocalPlayer(Player);
	if (LocalPlayer != None && LocalPlayer.ViewportClient != None)
	{
		return H7GameViewportClient(LocalPlayer.ViewportClient).IsVSync();
	}
	return false;
}

function SetVSync(bool val)
{
	local LocalPlayer LocalPlayer;

	LocalPlayer = LocalPlayer(Player);
	if (LocalPlayer != None && LocalPlayer.ViewportClient != None)
	{
		H7GameViewportClient(LocalPlayer.ViewportClient).SetVSync(val);
	}
}

function bool IsMouseLockedToWindow()
{
	local LocalPlayer LocalPlayer;
	LocalPlayer = LocalPlayer(Player);
	if (LocalPlayer != None && LocalPlayer.ViewportClient != None)
	{
		return H7GameViewportClient(LocalPlayer.ViewportClient).IsClientMouseLockedToWindow();
	}
	return false;
}

function SetMouseLockedToWindow(bool IsLocked)
{
	local LocalPlayer LocalPlayer;
	LocalPlayer = LocalPlayer(Player);
	if (LocalPlayer != None && LocalPlayer.ViewportClient != None)
	{
		H7GameViewportClient(LocalPlayer.ViewportClient).SetClientMouseLockedToWindow(IsLocked);
	}
}

function bool GetDynamicShadows()
{
	return class'Engine'.static.GetEngine().GetSystemSettingBool("DynamicShadows");
}

function SetDynamicShadows(bool val)
{
	local string command;
	command = "scale set DynamicShadows" @ (val?"true":"false");
	class'Engine'.static.GetEngine().GameViewport.ViewportConsole.ConsoleCommand(command);
}

function bool GetBloom()
{
	return class'Engine'.static.GetEngine().GetSystemSettingBool("Bloom");
}

function SetBloom(bool val)
{
	local string command;
	command = "scale set Bloom" @ (val?"true":"false");
	GetPlayerController().ConsoleCommand(command);
}

function bool GetDistortion()
{
	return class'Engine'.static.GetEngine().GetSystemSettingBool("Distortion");
}

function SetDistortion(bool val)
{
	local string command;
	command = "scale set Distortion" @ (val?"true":"false");
	GetPlayerController().ConsoleCommand(command);
}

native function int GetShaderQuality();
native function SetShaderQuality(int val);

function array<String> GetShaderQualityList()
{
	local array<String> list;
	
	list.AddItem("LOW");
	list.AddItem("HIGH");

	return list;
}

function int GetSkelMeshQuality()
{
	local int MeshQual;

	MeshQual = class'Engine'.static.GetEngine().GetSystemSettingInt("SkeletalMeshLODBias");

	return 2 - MeshQual;
}

function SetSkelMeshQuality(int val)
{
	GetPlayerController().ConsoleCommand("scale set SkeletalMeshLODBias" @ 2 - val);
}

function array<String> GetSkelMeshQualityList()
{
	local array<String> list;
	
	list.AddItem("LOW");
	list.AddItem("MEDIUM");
	list.AddItem("HIGH");

	return list;
}

function int GetStaticMeshQuality()
{
	local float MeshQual;

	MeshQual = class'Engine'.static.GetEngine().GetSystemSettingFloat("StaticMeshLODDistanceMultiplier");

	return (MeshQual - 1) * 2;
}

native function SetStaticMeshQuality(int val);

function array<String> GetStaticMeshQualityList()
{
	local array<String> list;
	
	list.AddItem("LOW");
	list.AddItem("MEDIUM");
	list.AddItem("HIGH");

	return list;
}

function int GetParticleQuality()
{
	local float DetailMode;

	DetailMode = class'Engine'.static.GetEngine().GetSystemSettingInt("DetailMode");

	return DetailMode;
}

function SetParticleQuality(int val)
{
	GetPlayerController().ConsoleCommand("scale set ParticleLODBias" @ 2 - val);
	GetPlayerController().ConsoleCommand("scale set DetailMode" @ val);
}

function array<String> GetParticleQualityList()
{
	local array<String> list;
	
	list.AddItem("LOW");
	list.AddItem("MEDIUM");
	list.AddItem("HIGH");

	return list;
}

function int GetLandscapeQuality()
{
	local float DetailMode;
	DetailMode = class'Engine'.static.GetEngine().GetSystemSettingInt("LandscapeGlobalLODBias");
	return 1 - DetailMode;
}

native function SetLandscapeQuality(int val);

function array<String> GetLandscapeQualityList()
{
	local array<String> list;
	list.AddItem("LOW");
	list.AddItem("HIGH");
	return list;
}

function float GetMouseWheel(float DeltaTime)
{
	if (IsLookInputIgnored())
	{
		return 0.0f;
	}

	if(mMouseWheelCapturedByFlash) return 0.0;

	if(MouseWheelForward) 
	{
		MouseWheelForward = false;
		MouseWheelHoldTimer += 0.1f;
		return 1.f;
	}
	else if(MouseWheelBackward) 
	{
		MouseWheelBackward = false;
		MouseWheelHoldTimer -= 0.1f;
		return -1.f;
	}

	if( MouseWheelHoldTimer > 0.0f )
	{
		MouseWheelHoldTimer-=DeltaTime;
		if(MouseWheelHoldTimer<0.0f) MouseWheelHoldTimer=0.0f; 
		return 1.0f;
	}
	else if( MouseWheelHoldTimer < 0.0f )
	{
		MouseWheelHoldTimer+=DeltaTime;
		if(MouseWheelHoldTimer>0.0f) MouseWheelHoldTimer=0.0f; 
		return -1.0f;
	}

	return 0.0f; 
}

private exec function SetMouseWheelBackward()
{
	if (IsLookInputIgnored())
	{
		return;
	}

	MouseWheelBackward = true;

	// this was a temp HACK, does not consider constraints
	//if (class'H7Camera'.static.GetInstance().FreeCamDistance < 2000.0f)
	//{
	//	class'H7Camera'.static.GetInstance().FreeCamDistance += 100.0f;
	//}
}

private exec function SetMouseWheelForward()
{
	if (IsLookInputIgnored())
	{
		return;
	}

	MouseWheelForward = true;

	// this was a temp HACK, does not consider constraints
	//if (class'H7Camera'.static.GetInstance().FreeCamDistance > 500.0f)
	//{
	//	class'H7Camera'.static.GetInstance().FreeCamDistance -= 100.0f;
	//}
}
private exec function ResetCamera()
{
	local int camIdx;
	camIdx = class'H7Camera'.static.GetInstance().GetActiveCameraMode();
	class'H7Camera'.static.GetInstance().ForceReInitialisation(camIdx);
}

private exec function StartPanMouse()
{
	if (IsLookInputIgnored())
	{
		return;
	}
	
	StartPanPosition = GetMousePosition();
	IsPanningMouse = true;
}

function Vector2D GetMousePosition()
{
	local LocalPlayer LocalPlayer;
	local Vector2D MousePosition;
	
	LocalPlayer = LocalPlayer(Player);
	if (LocalPlayer != None && LocalPlayer.ViewportClient != None)
	{
		MousePosition = LocalPlayer.ViewportClient.GetMousePosition();
	}
	
	return MousePosition;
}

private exec function StopPanMouse()
{
	GetHud().SetRightClickThisFrame(true);
	GetHud().SetRightMouseDown(false);
	IsPanningMouse = false;
	//LocalPlayer(Player).ViewportClient.SetMouse(StartPanPosition.X,StartPanPosition.Y);
}

exec function ToggleEventLog()
{
	if(CurrentContextBlocksKeybind(class'H7GameUtility'.static.GetFunctionName(0))) return;
	
	class'H7GUIGeneralProperties'.static.GetInstance().SetLogStatus(!class'H7GUIGeneralProperties'.static.GetInstance().GetLogStatus());
}

exec function MoveSouthWest()   { MoveArmyByNumpadInput(Vect(-1,1,0)); }
exec function MoveSouth()       { MoveArmyByNumpadInput(Vect(0,1,0)); }
exec function MoveSouthEast()   { MoveArmyByNumpadInput(Vect(1,1,0)); }
exec function MoveWest()        { MoveArmyByNumpadInput(Vect(-1,0,0)); }
exec function MoveEast()        { MoveArmyByNumpadInput(Vect(1,0,0)); }
exec function MoveNorthWest()   { MoveArmyByNumpadInput(Vect(-1,-1,0)); }
exec function MoveNorth()       { MoveArmyByNumpadInput(Vect(0,-1,0)); }
exec function MoveNorthEast()   { MoveArmyByNumpadInput(Vect(1,-1,0)); }
exec function MoveStop()        { MoveArmyByNumpadInput(Vect(0,0,0)); }

protected function MoveArmyByNumpadInput(Vector direction)
{
	if(!IsInputAllowed()) return; 
	if(CurrentContextBlocksKeybind(class'H7GameUtility'.static.GetFunctionName(0))) return;
	
	mCurrMoveDir = direction;
}

protected function MoveArmy()
{
	local H7AdventureArmy currArmy;
	local H7AdventureHero currHero;
	local H7AdventureMapCell currCell, targetCell;
	local H7AdventureGridManager gridManager;
	local array<H7AdventureMapCell> path;
	local Vector finalMoveDir;
	local Rotator OffsetRot;
	local int walkableCells;
	local array<float> pathCosts;

	if (class'H7ReplicationInfo'.static.GetInstance().IsCombatMap())
		return;

	currArmy = class'H7AdventureController'.static.GetInstance().GetSelectedArmy();
	if (currArmy == None)
		return;

	currHero = currArmy.GetHero();
	if (currHero == None)
		return;

	gridManager = class'H7AdventureGridManager'.static.GetInstance();
	if (gridManager == None)
		return;

	if (VSize2D(mCurrMoveDir) > 0.0f && currHero.GetCurrentMovementPoints() > 1)
	{
		OffsetRot.Yaw = 65536/4;
		OffsetRot += class'H7Camera'.static.GetInstance().Rotation;
		finalMoveDir = TransformVectorByRotation(OffsetRot, mCurrMoveDir);
		finalMoveDir = currArmy.Location + finalMoveDir * 192.0f;
		targetCell = gridManager.GetCellByWorldLocation(finalMoveDir);
		if( !targetCell.IsBlocked() )
		{
			path.AddItem(targetCell);
			currHero.SetCurrentPath(path);
			pathCosts = class'H7AdventureGridManager'.static.GetInstance().GetPathfinder().GetPathCosts( path, currHero.GetCell(), currHero.GetCurrentMovementPoints(), walkableCells );
			if( !currArmy.GetPlayer().IsControlledByAI() )
			{
				class'H7AdventureGridManager'.static.GetInstance().GetPathPreviewer().ShowPreview( path, walkableCells, currHero.GetCurrentMovementPoints(), currHero.GetMovementPoints(), pathCosts );
			}
			if( walkableCells > 0 )
			{
				if( targetCell.GetVisitableSite() != none && 
					( targetCell.GetVisitableSite().GetEntranceCell() == targetCell || 
					!targetCell.GetVisitableSite().IsUnblockingEntrance() && targetCell.IsNeighbour( targetCell.GetVisitableSite().GetEntranceCell() ) ) )
				{
					class'H7AdventureGridManager'.static.GetInstance().DoVisit( targetCell.GetVisitableSite(), true, false );
				}
				else
				{
					class'H7AdventureGridManager'.static.GetInstance().DoMoveToCell( targetCell, true, false );
				}
			}
		}
		else
		{
			if (targetCell.GetHostileArmy(currArmy.GetPlayer()) != None)
			{
				currCell = gridManager.GetCellByWorldLocation(currArmy.Location);
				path.AddItem(currCell);
				currHero.SetCurrentPath(path);
				pathCosts = class'H7AdventureGridManager'.static.GetInstance().GetPathfinder().GetPathCosts( path, currHero.GetCell(), currHero.GetCurrentMovementPoints(), walkableCells );
				if( !currArmy.GetPlayer().IsControlledByAI() )
				{
					class'H7AdventureGridManager'.static.GetInstance().GetPathPreviewer().ShowPreview( path, walkableCells, currHero.GetCurrentMovementPoints(), currHero.GetMovementPoints(), pathCosts );
				}
				if (targetCell.GetHostileArmy(currArmy.GetPlayer()) != currArmy)
				{
					class'H7AdventureGridManager'.static.GetInstance().DoMeetArmy( targetCell.GetLocation(), true );
				}
			}
			else if (targetCell.GetVisitableSite() != None)
			{
				path.AddItem(targetCell);
				currHero.SetCurrentPath(path);
				pathCosts = class'H7AdventureGridManager'.static.GetInstance().GetPathfinder().GetPathCosts( path, currHero.GetCell(), currHero.GetCurrentMovementPoints(), walkableCells );
				if( !currArmy.GetPlayer().IsControlledByAI() )
				{
					class'H7AdventureGridManager'.static.GetInstance().GetPathPreviewer().ShowPreview( path, walkableCells, currHero.GetCurrentMovementPoints(), currHero.GetMovementPoints(), pathCosts );
				}
				if( targetCell.GetVisitableSite() != none && 
					( targetCell.GetVisitableSite().GetEntranceCell() == targetCell || 
					!targetCell.GetVisitableSite().IsUnblockingEntrance() && targetCell.IsNeighbour( targetCell.GetVisitableSite().GetEntranceCell() ) ) )
				{
					class'H7AdventureGridManager'.static.GetInstance().DoVisit( targetCell.GetVisitableSite(), true, false );
				}
				else
				{
					class'H7AdventureGridManager'.static.GetInstance().DoMoveToCell( targetCell, true, false );
				}
			}
			// TO DO? or maybe visitable is enough for teleporters and ships
		}
	}
}

////////////////////////////////////////////////
// QUICKBAR ////////////////////////////////////
////////////////////////////////////////////////

private exec function PrepareQuickBarAction(int slotIndex)
{
	if(CurrentContextBlocksKeybind(class'H7GameUtility'.static.GetFunctionName(0))) return;
	if(GetHud().IsFocusOnInput()) return;

	if(H7AdventureHud(GetHud()) != none)
	{
		;
		GetHud().GetSpellbookCntl().GetQuickBar().PushDown(slotIndex);
	}
}

private exec function DoQuickBarAction(int slotIndex)
{
	local H7EditorHero hero;
	local array<H7HeroAbility> quickbar;

	if(CurrentContextBlocksKeybind(class'H7GameUtility'.static.GetFunctionName(0))) return;
	if(GetHud().IsFocusOnInput()) return;

	if(class'H7ReplicationInfo'.static.GetInstance().IsCombatMap())
	{
		hero = class'H7CombatController'.static.GetInstance().GetActiveUnit().GetCombatArmy().GetHero();
		if(hero == none) return;
		quickbar = hero.GetQuickBarSpells(true);
	}
	else
	{
		if( GetAdventureHud().GetTownHudCntl().IsInTownScreen() ) return;

		hero = class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero();
		quickbar = hero.GetQuickBarSpells(false);
	}
	
	if(quickbar.Length > slotIndex && quickbar[slotIndex] != none)
	{
		;
		GetHud().GetSpellbookCntl().SpellClicked(quickbar[slotIndex].GetID(),true);
		GetHud().GetSpellbookCntl().GetQuickBar().PushDown(slotIndex,false);
	}
}

////////////////////////////////////////////////
// KEYBINDING-MANAGMENT ////////////////////////
////////////////////////////////////////////////

// Puts the key for the given command into the localized string as colored html
// - localizedString = "Speichern"
// - alias = "ASaveGame"
// return: "<font color='#ffcc00'>S</font>peichern"
function String GetHTMLWithKeyBind(String localizedString,String alias)
{
	local KeyBind key;
	local String localizedKeyCaption;
	local int pos;

	//key = GetBindByCommand(command); // don't use unreal list, use H7 list, because some are not in unreal list, also there are multiple key in diff categories, so find right one
	key = class'H7KeybindManager'.static.GetInstance().GetPreferedKeybindByCommand(alias);

	//`log_dui("GetHTMLWithKeyBind command:" @ command @ "key:" @ key.Name);
	
	if(key.Name == 'None') // no key assigned to this command, return as is
	{
		return localizedString;
	}

	localizedKeyCaption = GetLocalizedKeyCaption(key.Name);
	if(len(localizedKeyCaption) == 1)
	{
		localizedKeyCaption = Caps(localizedKeyCaption);
	}
	
	localizedKeyCaption = 
		(key.Shift?(class'H7Loca'.static.LocalizeSave("KEY_SHIFT","H7Keys") $ "+"):"") 
		$ (key.Control?(class'H7Loca'.static.LocalizeSave("KEY_CONTROL","H7Keys") $ "+"):"") 
		$ (key.Alt?(class'H7Loca'.static.LocalizeSave("KEY_ALT","H7Keys") $ "+"):"") 
		$ localizedKeyCaption;

	//pos = InStr(localizedString,localizedKeyCaption,false,true); // nobody wanted the inStr replacement like Warcraft3 :-(
	pos = -1;
	if(pos == -1)
	{
		localizedString = localizedString @ "[" $ "<font color='#ffcc00'>" $ localizedKeyCaption $ "</font>" $ "]";
	}
	else
	{
		//localizedString = Left(localizedString,pos) $ "<font color='#ffcc00'>" $ localizedKeyCaption $ "</font>" $ Right(localizedString,Len(localizedString)-(pos+1));
	}
	//`log_dui("GetHTMLWithKeyBind" @ localizedString);
	return localizedString;
}

function String GetLocalizedKeyCaption(name unrealKeyName)
{
	return class'H7Loca'.static.LocalizeSave("KEY_" $ Caps(unrealKeyName),"H7Keys");
}

function PlayerInput GetPlayerInput()
{
	return PlayerInput;
}

// TODO which key to return if more than 1 key is bound to the same command? (i.e. primary, secondary)
// TODO does not work with piped commands
function KeyBind GetBindByCommand(string command,optional bool recursiveCall)
{
	local int		BindIndex;
	local KeyBind   empty;

	for(BindIndex = PlayerInput.Bindings.Length-1;BindIndex >= 0;BindIndex--)
	{
		if(PlayerInput.Bindings[BindIndex].Command == command)
		{
			if(Left(PlayerInput.Bindings[BindIndex].Name,1) == "A" && !recursiveCall) // in case it links to an alias, do again search with that alias to get key
			{
				// command -> alias -> key
				return GetBindByCommand(String(PlayerInput.Bindings[BindIndex].Name),true);
			}
			// command -> key
			return PlayerInput.Bindings[BindIndex];
		}
	}

	return empty;
}

function KeyBind GetBindOrAliasByCommand(string command,optional bool recursiveCall)
{
	local int		BindIndex;
	local KeyBind   empty;

	for(BindIndex = PlayerInput.Bindings.Length-1;BindIndex >= 0;BindIndex--)
	{
		if(PlayerInput.Bindings[BindIndex].Command == command)
		{
			return PlayerInput.Bindings[BindIndex];
		}
	}

	return empty;
}

function KeyBind GetBindByKey(name key)
{
	local int		BindIndex;
	local KeyBind   empty;

	empty.Name = 'None';

	for(BindIndex = PlayerInput.Bindings.Length-1;BindIndex >= 0;BindIndex--)
	{
		if(PlayerInput.Bindings[BindIndex].Name == key)
		{
			return PlayerInput.Bindings[BindIndex];
		}
	}

	return empty;
}

exec function bool DeleteKeyBindByKey(name key)
{
	local int		BindIndex;

	for(BindIndex = PlayerInput.Bindings.Length-1;BindIndex >= 0;BindIndex--)
	{
		if(PlayerInput.Bindings[BindIndex].Name == key)
		{
			PlayerInput.Bindings.RemoveItem(PlayerInput.Bindings[BindIndex]);
			return true;
		}
	}
	return false;
}

exec function SetTempBind(name BindName, string Command)
{
	local KeyBind	NewBind;
	local int		BindIndex;

	if ( Left(Command,1) == "\"" && Right(Command,1) == "\"" )
	{
		Command = Mid(Command, 1, Len(Command) - 2);
	}

	for(BindIndex = PlayerInput.Bindings.Length-1;BindIndex >= 0;BindIndex--)
	{
		if(PlayerInput.Bindings[BindIndex].Name == BindName)
		{
			PlayerInput.Bindings[BindIndex].Command = Command;
			return;
		}
	}

	NewBind.Name = BindName;
	NewBind.Command = Command;
	PlayerInput.Bindings[PlayerInput.Bindings.Length] = NewBind;
}

////////////////////////////////////////////////
// HUD MANAGMENT ///////////////////////////////
////////////////////////////////////////////////

function H7Hud GetHud()
{
	if(mySecondaryHUD != None)
	{
		return H7Hud(mySecondaryHUD);
	}
	if (MyHUD != None)
		return H7Hud(MyHUD);

	return None;
}

function H7Hud GetMainHUD()
{
	return H7Hud(myHUD);
}

function H7Hud GetSecondaryHUD()
{
	return H7Hud(mySecondaryHUD);
}

function SetMainHUD(H7Hud newHUD)
{
	myHUD = newHUD;
}

function SetSecondaryHUD(H7Hud newHUD)
{
	mySecondaryHUD = newHUD;
}

function H7CombatHud GetCombatMapHud()
{
	return H7CombatHud(GetHud());
}

function H7AdventureHud GetAdventureHud()
{
	return H7AdventureHud(GetHud());
}

function H7MainMenuHud GetMainMenuHud()
{
	return H7MainMenuHud(GetHud());
}

////////////////////////////////////////////////
// CURSOR MANAGMENT ////////////////////////////
////////////////////////////////////////////////

function UnLoadCursorObject()
{
	H7Hud(MyHUD).UnLoadCursorObject();
}

// mainly called for attaching objects to the cursor
function SetCursorTexture( Texture2D cursorTexture , optional Texture2D objectTexture, optional int objectOffsetX, optional int objectOffsetY, optional int sizeX, optional int sizeY)
{
	local Rotator rot;
	H7Hud(MyHUD).SetSoftwareCursor( cursorTexture, mCursorDirection ,  , , objectTexture , rot , objectOffsetX , objectOffsetY , sizeX , sizeY);
}

// sets software and hardware cursor
function SetCursor( ECursorType cursorType, optional Rotator cursorRotation)
{
	local H7Hud lHud;
	local H7GameViewportClient h7GVC;
	local int cursorNum;

	if( ( mIsInCinematicView || mHideCursor ) && cursorType != CURSOR_INVISIBLE ) 
	{
		;
		SetCursor( CURSOR_INVISIBLE );
		return;
	}

	lHud = H7Hud(MyHUD);

	cursorRotation.yaw -= 16384;	//	Some rotation correction for melee north,  everything else ignores rotation

	if(lHud != none)
	{
		switch(cursorType)
		{
			case CURSOR_ABILITY: lHud.SetSoftwareCursor(Texture2D'H7Cursors.Ability',cursorRotation); break;
			case CURSOR_ABILITY_DENY: lHud.SetSoftwareCursor(Texture2D'H7Cursors.AbilityDeny',cursorRotation); break;
			case CURSOR_ACTION: lHud.SetSoftwareCursor(Texture2D'H7Cursors.Action',cursorRotation); break;
			case CURSOR_ACTION_BLOCKED: lHud.SetSoftwareCursor(Texture2D'H7Cursors.ActionBlocked',cursorRotation); break;
			case CURSOR_BUSY: lHud.SetSoftwareCursor(Texture2D'H7Cursors.Busy',cursorRotation); break;
			case CURSOR_DETAILS: lHud.SetSoftwareCursor(Texture2D'H7Cursors.Details',cursorRotation); break;
			case CURSOR_EXCHANGE: lHud.SetSoftwareCursor(Texture2D'H7Cursors.Exchange',cursorRotation); break;
			case CURSOR_EXCHANGE_BLOCKED: lHud.SetSoftwareCursor(Texture2D'H7Cursors.ExchangeBlocked',cursorRotation); break;
			case CURSOR_IBEAM: lHud.SetSoftwareCursor(Texture2D'H7Cursors.Normal',cursorRotation); break;
			case CURSOR_MAGIC: lHud.SetSoftwareCursor(Texture2D'H7Cursors.Magic',cursorRotation); break;
			case CURSOR_MAGIC_DENY: lHud.SetSoftwareCursor(Texture2D'H7Cursors.MagicDeny',cursorRotation); break;
			case CURSOR_MEETING: lHud.SetSoftwareCursor(Texture2D'H7Cursors.Meeting',cursorRotation); break;
			case CURSOR_MELEE_N: lHud.SetSoftwareCursor(Texture2D'H7Cursors.MeleeNorth',cursorRotation,0.5,1.0); break;
			case CURSOR_MELEE_NW: lHud.SetSoftwareCursor(Texture2D'H7Cursors.MeleeNorthWest',cursorRotation); break;
			case CURSOR_MELEE_NE: lHud.SetSoftwareCursor(Texture2D'H7Cursors.MeleeNorthEast',cursorRotation); break;
			case CURSOR_MELEE_S: lHud.SetSoftwareCursor(Texture2D'H7Cursors.MeleeSouth',cursorRotation); break;
			case CURSOR_MELEE_SW: lHud.SetSoftwareCursor(Texture2D'H7Cursors.MeleeSouthWest',cursorRotation); break;
			case CURSOR_MELEE_SE: lHud.SetSoftwareCursor(Texture2D'H7Cursors.MeleeSouthEast',cursorRotation); break;
			case CURSOR_MELEE_W: lHud.SetSoftwareCursor(Texture2D'H7Cursors.MeleeWest',cursorRotation); break;
			case CURSOR_MELEE_E: lHud.SetSoftwareCursor(Texture2D'H7Cursors.MeleeEast',cursorRotation); break;
			case CURSOR_MOVE: lHud.SetSoftwareCursor(Texture2D'H7Cursors.Move',cursorRotation,0.5,0.5); break;
			case CURSOR_MOVE_BLOCKED: lHud.SetSoftwareCursor(Texture2D'H7Cursors.MoveBlocked',cursorRotation,0.5,0.5); break;
			case CURSOR_MOVE_FLY: lHud.SetSoftwareCursor(Texture2D'H7Cursors.MoveFly',cursorRotation); break;
			case CURSOR_MOVE_TELEPORT: lHud.SetSoftwareCursor(Texture2D'H7Cursors.MoveTeleport',cursorRotation); break;
			case CURSOR_MOVE_WALK: lHud.SetSoftwareCursor(Texture2D'H7Cursors.MoveWalk',cursorRotation); break;
			case CURSOR_NORMAL: lHud.SetSoftwareCursor(Texture2D'H7Cursors.Normal',cursorRotation); break;
			case CURSOR_POINTER: lHud.SetSoftwareCursor(Texture2D'H7Cursors.Pointer',cursorRotation); break;
			case CURSOR_SHIP_ANCHOR: lHud.SetSoftwareCursor(Texture2D'H7Cursors.ShipAnchor',cursorRotation,0.5,0.5); break;
			case CURSOR_SHIP_ANCHOR_BLOCKED: lHud.SetSoftwareCursor(Texture2D'H7Cursors.ShipAnchorBlocked',cursorRotation,0.5,0.5); break;
			case CURSOR_SHIP_MOVE: lHud.SetSoftwareCursor(Texture2D'H7Cursors.ShipMove',cursorRotation,0.5,0.5); break;
			case CURSOR_SHIP_MOVE_BLOCKED: lHud.SetSoftwareCursor(Texture2D'H7Cursors.ShipMoveBlocked',cursorRotation,0.5,0.5); break;
			case CURSOR_SHOT: lHud.SetSoftwareCursor(Texture2D'H7Cursors.Shot',cursorRotation); break;
			case CURSOR_SHOT_UNSIGHTED: lHud.SetSoftwareCursor(Texture2D'H7Cursors.ShotUnsighted',cursorRotation); break;
			case CURSOR_TALK: lHud.SetSoftwareCursor(Texture2D'H7Cursors.Talk',cursorRotation); break;
			case CURSOR_TELEPORT: lHud.SetSoftwareCursor(Texture2D'H7Cursors.Teleport',cursorRotation); break;
			case CURSOR_TELEPORT_BLOCKED: lHud.SetSoftwareCursor(Texture2D'H7Cursors.TeleportBlocked',cursorRotation); break;
			case CURSOR_TOWN: lHud.SetSoftwareCursor(Texture2D'H7Cursors.Town',cursorRotation); break;
			case CURSOR_TRADE: lHud.SetSoftwareCursor(Texture2D'H7Cursors.Trade',cursorRotation); break;
			case CURSOR_UNAVAILABLE: lHud.SetSoftwareCursor(Texture2D'H7Cursors.Unavailable',cursorRotation); break;
			case CURSOR_VISIT: lHud.SetSoftwareCursor(Texture2D'H7Cursors.Visit',cursorRotation); break;
			case CURSOR_EMPTY: lHud.SetSoftwareCursor(Texture2D'H7Cursors.Normal',cursorRotation); break;
			case CURSOR_INVISIBLE: break;
		default: ;
		}
	}

	mCursorDirection = cursorRotation;

	// update the hardware mouse cursor graphic
	h7GVC = LocalPlayer(Player) != None ? H7GameViewportClient(LocalPlayer(Player).ViewportClient) : None;
	if (h7GVC != None)
	{
		mCursorWasInit = true;
		if(lHud != none && lHud.IsOverwritingHardwareCursor()) 
		{
			// did not work to hide hardware cursor, so we display invisible one
			cursorNum = CURSOR_INVISIBLE;
		}
		else
		{
			cursorNum = cursorType;
		}
		
		// show always
		h7GVC.SetCursor(cursorNum);
		h7GVC.ForceUpdateMouseCursor(true);
		
	}
	else
	{
		;
	}

}


/////////////////////////////////////
// Unreal Cursor Reaction Handling //
/////////////////////////////////////
// Unreal needs a combination of 7 true and false to react with the mouse cursor
// The master function is: IsInputAllowed() and checks all 7
// - if flash wants to block unreal-input it sets mHUDMouseOver=true 
// - or mPopupIsOpen=true
// - if unreal wants to block unreal-input it sets mAllowInput=false
// - if kismet wants to block unreal-input it sets mAllowInputFromKismet=false
// - if ???  wants to block unreal-input it sets mCameraActionIsRunning=true
// - if caravan wants to block unreal-input it sets mIsCaravanTurn=true
// - if multiplayer wants to block unreal-input it sets mIsCommandRequested=true

// GLOBAL input allow function, checks all cases that block input
function bool IsInputAllowed(bool allowInputWhenMouseOverHud=false) // on the 3d world
{
	return IsUnrealAllowsInput() && (allowInputWhenMouseOverHud || !IsMouseOverHUD()) && !IsPopupOpen() && !IsCameraActionRunning() && IsKismetAllowsInput() && !IsCaravanTurn() && !IsCommandRequested();
}

// FIRST BOOL 
// - called from flash (via H7FlashMovieCntl)
function HUDMouseOver() // hudover overhud mouseoverhud
{
	mHUDMouseOverCounter++;
	
	mHUDMouseOver = true;

	//`log_gui("HUDMouseOver: mHUDMouseOverCounter" @ mHUDMouseOverCounter);

	if(!mSkipNextCursorChange)
	{
		// show hud cursor
		if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() && class'H7CombatController'.static.GetInstance() != none )
		{
			class'H7CombatController'.static.GetInstance().GetCursor().ShowNormalHUDCursor();
		}
		else
		{
			SetCursor( CURSOR_ACTION );
		}
	}

	mSkipNextCursorChange = false;
}
// because scaleform triggers subelements before parentelements
function HUDSubElementMouseOverBeforeHudMouseOver()
{
	mSkipNextCursorChange = true;
}
// called from flash (via H7FlashMovieCntl)
function HUDMouseOut()
{
	mHUDMouseOverCounter--;

	//`log_gui("HUDMouseOut: mHUDMouseOverCounter" @ mHUDMouseOverCounter);

	if(mHUDMouseOverCounter < 0) 
	{
		;
		mHUDMouseOverCounter = 0;
	}

	if(mHUDMouseOverCounter < 1)
	{
		mHUDMouseOver = false;
		// show unreal 3d world reacting cursor
		// --> this is done every frame, so will change cursor in next frame automatically
	}

	mSkipNextCursorChange = false;
}
function bool IsMouseOverHUD() // isoverhud ishudover 
{
	return mHUDMouseOver;
}
function ResetHUDOverCounter()
{
	mHUDMouseOverCounter = 0;
	mHUDMouseOver = false;
	mMouseWheelCapturedByFlash = false;
}

// SECOND BOOL 
// -
function SetIsPopupOpen(bool val)
{
	mPopupIsOpen = val;
	if(!val) 
	{
		// in case these were set while popup was open
		MouseWheelForward = false;
		MouseWheelBackward = false;
	}

	if(class'H7FCTController'.static.GetInstance() != none)
	{
		if( val )
		{
			class'H7FCTController'.static.GetInstance().SetTickIsDisabled( true );
		}
		else
		{
			class'H7FCTController'.static.GetInstance().SetTickIsDisabled( false );
		}
	}
}

function bool IsPopupOpen()
{
	return mPopupIsOpen;
}

function SetCameraActionRunning(bool val)
{
	mCameraActionIsRunning = val;
	if(!val) 
	{
		// in case these were set while popup was open
		MouseWheelForward = false;
		MouseWheelBackward = false;
	}
}

function bool IsCameraActionRunning()
{
	return mCameraActionIsRunning;
}

function bool IsCaravanTurn()
{
	return mIsCaravanTurn;
}

function SetCaravanTurn(bool caravanTurn)
{
	mIsCaravanTurn = caravanTurn;
}

function bool IsCommandRequested()
{
	return mIsCommandRequested;
}

// disables any input while an command is requested to the server
function SetCommandRequested(bool commandRequested)
{
	mIsCommandRequested = commandRequested;
	if(!commandRequested && mHUDMouseOver)
	{
		SetCursor( CURSOR_ACTION );
	}
}


// THIRD BOOL
// - called with false when unreal actions start (flying,moving,fighting,...) and when flash actions start (popup was open) 
// - called with true when unreal actions end (flying,moving,fighting,...) and when flash actions end (popup was closed)
// overwritted
function SetIsUnrealInputAllowed(bool isAllowed)
{
	if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() && WorldInfo.GRI.IsMultiplayerGame() 
		&& !class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().IsControlledByLocalPlayer() )
	{
		mAllowInput = false;
	}
	else 
	{
		mAllowInput = isAllowed;
	}
}
// some callers want to know if input is not allowed only because unreal blocked it, used as a kind of "UnrealActionIsRunning or Started"
function bool IsUnrealAllowsInput()
{
	return mAllowInput;
}

function SetInputAllowedFromKismet(bool isAllowed)
{
	mAllowInputFromKismet = isAllowed;
}

function bool IsKismetAllowsInput()
{
	return mAllowInputFromKismet;
}

function bool IsKeyInputAllowed()
{
	local H7FlashMovieCntl currentFla;

	if(GetHud() == none) return true;

	currentFla = GetHud().GetCurrentContext();

	if(currentFla == none) return true;

	if(currentFla.IsA('H7FlashMoviePopupCntl') && H7FlashMoviePopupCntl(currentFla).IsBlockingUnreal()) return false;
	// OPTIONAL others...?

	return true;
}

exec event BugIt( optional string ScreenShotDescription )
{
	// fix for Bugit getting the location of the GameStatePawn (so move the pawn to the camera)
	if (PlayerCamera != None && Pawn != None)
	{
		Pawn.SetLocation(PlayerCamera.Location);
	}

	super.BugIt(ScreenShotDescription);
}

// special wheel blocking
function CaptureMouseWheel(bool val)
{
	mMouseWheelCapturedByFlash = val;
	if(!val) 
	{
		// in case these were set while wheel was captured
		MouseWheelForward = false;
		MouseWheelBackward = false;
	}
}
function bool IsMouseWheelCapturedByFlash()
{
	return mMouseWheelCapturedByFlash;
}

exec function SetShiftTrue()
{
	mShiftDown = true;
}

exec function SetShiftFalse()
{
	mShiftDown = false;
}

//////////////////////////////////////
// MULTIPLAYER
//////////////////////////////////////

function bool IsServer()
{
	return Role == Role_Authority;
}

/** Delegate called when session destroy is complete */
delegate OnDestroySessionComplete(name SessionName,bool bWasSuccessful);

/**
 * Delete a session. Only used for cleanup of sessions during loading.  This means that no timers/ticking is allowed.
 *
 * @param SessionName name of the session to delete 'Game' or 'Party'
 * @param DestroyCompleteDelegate delegate to call on completion.  Always called even if no session is found
 */
function DeleteSession(name SessionName, delegate<OnDestroySessionComplete> DestroyCompleteDelegate)
{
	local OnlineGameSettings GameSettings;

	if (OnlineSub != None && 
		OnlineSub.GameInterface != None)
	{
		GameSettings = OnlineSub.GameInterface.GetGameSettings(SessionName);
		if (GameSettings != None)
		{
			OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(DestroyCompleteDelegate);
			OnlineSub.GameInterface.DestroyOnlineGame(SessionName);
			return;
		}
	}
	DestroyCompleteDelegate(SessionName, true);
}

reliable server function ServerLobbySetPlayerArmy( int playerIndex, int armyIndex )
{
	if(mGameStarted)
	{
		return;
	}

	H7MainMenuHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetDuelSetupWindowCntl().SetPlayerArmy(playerIndex, armyIndex);
	H7MainMenuHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetDuelSetupWindowCntl().GetDuelWindow().DisplayArmy(playerIndex,armyIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mArmy);
	class'H7ReplicationInfo'.static.PrintLogMessage(self @ "ServerLobbySetPlayerArmy " @ playerIndex @ armyIndex, 0);;
}

reliable server function ServerLobbySetPlayerColor( int playerIndex, int selectedColorEnum )
{
	if(mGameStarted)
	{
		return;
	}

	if( class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mIsDuel )
	{
		H7MainMenuHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetDuelSetupWindowCntl().SetPlayerColor(playerIndex, selectedColorEnum);
		H7MainMenuHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetDuelSetupWindowCntl().DisplayPlayerSettings(playerIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex]);
	}
	else
	{
		H7MainMenuHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetSkirmishSetupWindowCntl().SetPlayerColor(playerIndex, selectedColorEnum);
		H7MainMenuHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetSkirmishSetupWindowCntl().DisplayPlayerSettings(playerIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex]);
	}
	class'H7ReplicationInfo'.static.PrintLogMessage(self @ "ServerLobbySetPlayerColor " @ playerIndex @ selectedColorEnum, 0);;
}

reliable server function ServerLobbySetPlayerPosition( int playerIndex, int position )
{
	if(mGameStarted)
	{
		return;
	}

	if( class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mIsDuel )
	{
		H7MainMenuHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetDuelSetupWindowCntl().SetPlayerPosition(playerIndex, position);
		H7MainMenuHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetDuelSetupWindowCntl().DisplayPlayerSettings(playerIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex]);
	}
	else
	{
		H7MainMenuHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetSkirmishSetupWindowCntl().SetPlayerPosition(playerIndex, position);
		H7MainMenuHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetSkirmishSetupWindowCntl().DisplayPlayerSettings(playerIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex]);
	}
	class'H7ReplicationInfo'.static.PrintLogMessage(self @ "ServerLobbySetPlayerPosition " @ playerIndex @ position, 0);;
}

reliable server function ServerLobbySetPlayerTeam( int playerIndex, int teamEnum )
{
	if(mGameStarted)
	{
		return;
	}

	H7MainMenuHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetSkirmishSetupWindowCntl().SetPlayerTeam(playerIndex, teamEnum);
	H7MainMenuHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetSkirmishSetupWindowCntl().DisplayPlayerSettings(playerIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex]);
	
	class'H7ReplicationInfo'.static.PrintLogMessage(self @ "ServerLobbySetPlayerTeam " @ playerIndex @ teamEnum, 0);;
}

reliable server function ServerLobbySetPlayerFaction(int playerIndex, string factionArchetypeID)
{
	if(mGameStarted)
	{
		return;
	}

	if(class'H7ReplicationInfo'.static.GetInstance().IsDuel())
	{
		class'H7DuelSetupWindowCntl'.static.GetInstance().SetPlayerFaction(playerIndex, factionArchetypeID);
		class'H7DuelSetupWindowCntl'.static.GetInstance().DisplayPlayerSettings(playerIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex]);
	}
	else
	{
		H7MainMenuHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetSkirmishSetupWindowCntl().SetPlayerFaction(playerIndex, factionArchetypeID);
		H7MainMenuHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetSkirmishSetupWindowCntl().DisplayPlayerSettings(playerIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex]);
	}
	class'H7ReplicationInfo'.static.PrintLogMessage(self @ "ServerLobbySetPlayerFaction " @ playerIndex @ factionArchetypeID, 0);;
}

reliable server function ServerLobbySetPlayerHero(int playerIndex, string heroArchetypeID)
{
	if(mGameStarted)
	{
		return;
	}

	if(class'H7ReplicationInfo'.static.GetInstance().IsDuel())
	{
		class'H7DuelSetupWindowCntl'.static.GetInstance().SetPlayerHero(playerIndex, heroArchetypeID);
		class'H7DuelSetupWindowCntl'.static.GetInstance().DisplayPlayerSettings(playerIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex]);
	}
	else
	{
		H7MainMenuHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetSkirmishSetupWindowCntl().SetPlayerHero(playerIndex, heroArchetypeID);
		H7MainMenuHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetSkirmishSetupWindowCntl().DisplayPlayerSettings(playerIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex]);
	}

	class'H7ReplicationInfo'.static.PrintLogMessage(self @ "ServerLobbySetPlayerHero " @ playerIndex @ heroArchetypeID, 0);;
}

reliable server function ServerLobbySetPlayerStartBonus(int playerIndex, int bonusIndex)
{
	if(mGameStarted)
	{
		return;
	}

	H7MainMenuHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetSkirmishSetupWindowCntl().SetPlayerStartBonus(playerIndex, bonusIndex);
	H7MainMenuHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetSkirmishSetupWindowCntl().DisplayPlayerSettings(playerIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex]);
	
	class'H7ReplicationInfo'.static.PrintLogMessage(self @ "ServerLobbySetPlayerStartBonus " @ playerIndex @ bonusIndex, 0);;
}

function SendPlayerReady(int playerIndex, bool isReady)
{
	local int convertedPrivileges[MAX_PRIVILEGES_COUNT];
	local array<int> privileges;
	local int i;

	if(isReady)
	{
		class'H7PlayerProfile'.static.GetInstance().GetUserPrivileges(privileges, true);

		if(privileges.Length > MAX_PRIVILEGES_COUNT)
		{
			privileges.Length = MAX_PRIVILEGES_COUNT;
			;
		}

		for(i=0; i<privileges.Length; i++)
		{
			convertedPrivileges[i] = privileges[i];
		}
	}

	ServerLobbySetPlayerReady(playerIndex, isReady, convertedPrivileges);
}

reliable server function ServerLobbySetPlayerReady(int playerIndex, bool isReady, int privileges[MAX_PRIVILEGES_COUNT] )
{
	local PrivilegesContainer privContainer;
	local int i;

	// too late to change the ready state, the game already started!
	if( class'H7MultiplayerGameManager'.static.GetOnlineGameSettings().IsGameStarted() || mGameStarted )
	{
		return;
	}

	if(isReady)
	{
		SendLobbySystemChat( class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mName, "CHAT_READY" );
		
		for(i=0; i<MAX_PRIVILEGES_COUNT; i++)
		{
			if(privileges[i] > 0)
			{
				privContainer.privileges.AddItem(privileges[i]);
			}
		}
		privContainer.playerIndex = playerIndex;
		class'H7MultiplayerGameManager'.static.GetInstance().AddSharedPrivileges(privContainer);
	}
	else
	{
		SendLobbySystemChat( class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mName, "CHAT_NOT_READY" );
	}

	if(class'H7ReplicationInfo'.static.GetInstance().IsDuel())
	{
		class'H7DuelSetupWindowCntl'.static.GetInstance().SetPlayerReady(playerIndex, isReady);
		class'H7DuelSetupWindowCntl'.static.GetInstance().DisplayPlayerSettings(playerIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex]);
	}
	else
	{
		H7MainMenuHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetSkirmishSetupWindowCntl().SetPlayerReady(playerIndex, isReady);
		H7MainMenuHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetSkirmishSetupWindowCntl().DisplayPlayerSettings(playerIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex]);
	}
	class'H7ReplicationInfo'.static.PrintLogMessage(self @ "ServerLobbySetPlayerReady " @ playerIndex @ isReady, 0);;
}

function SendLobbyChat( string chatText , optional EChatChannel channel = CHAT_ALL )
{
	ServerLobbyChat( PlayerReplicationInfo.PlayerName, chatText , channel );
}

function SendLobbySystemChat( string playerName, string locaKey, optional EChatChannel channel = CHAT_ALL )
{
	local H7PlayerController currentPlayerController;

	ForEach WorldInfo.AllControllers( class'H7PlayerController', currentPlayerController )
	{
		currentPlayerController.ClientLobbySystemChat( playerName, locaKey );
	}

	class'H7ReplicationInfo'.static.PrintLogMessage(self @ "SendLobbySystemChat " @ playerName @ locaKey, 0);;
}

reliable client function ClientLobbySystemChat( string playerName, string locaKey )
{
	local string chatText;

	chatText = Repl(class'H7Loca'.static.LocalizeSave(locaKey,"H7MainMenu"),"%player", playerName);

	if(class'H7MainMenuHud'.static.GetInstance() != none)
	{
		if(class'H7ReplicationInfo'.static.GetInstance().IsDuel())
		{
			class'H7MainMenuHud'.static.GetInstance().GetDuelSetupWindowCntl().AddChatLine( chatText, "" );
		}
		else
		{
			class'H7MainMenuHud'.static.GetInstance().GetSkirmishSetupWindowCntl().AddChatLine( chatText, "" );
		}
	}
	else if(class'H7LogSystemCntl'.static.GetInstance() != none)
	{
		class'H7LogSystemCntl'.static.GetInstance().AddChatLine( chatText, "", CHAT_ALL ); // system to all
	}
	class'H7ReplicationInfo'.static.PrintLogMessage(self @ "ClientLobbySystemChat " @ playerName @ locaKey, 0);;
}

reliable server function ServerLobbyChat( string playerName, string chatText, EChatChannel channel )
{
	local H7PlayerController currentPlayerController;
	local H7PlayerController sendingPlayerController;
	local H7PlayerReplicationInfo sendingPlayerReplicationInfo,targetPlayerReplicationInfo;
	local EPlayerNumber sendingPlayerNumber,targetPlayerNumber;
	local H7Player sendingPlayer,targetPlayer;

	// unfortunatly the player is identified by 5 different data types

	foreach WorldInfo.AllControllers( class'H7PlayerController', currentPlayerController )
	{
		if(currentPlayerController.GetPlayerReplicationInfo().PlayerName == playerName)
		{
			sendingPlayerController = currentPlayerController;
			sendingPlayerReplicationInfo = sendingPlayerController.GetPlayerReplicationInfo();
			sendingPlayerNumber = sendingPlayerReplicationInfo.GetPlayerNumber();
			sendingPlayer = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber(sendingPlayerNumber);
		}
	}
	
	ForEach WorldInfo.AllControllers( class'H7PlayerController', currentPlayerController )
	{
		targetPlayerReplicationInfo = currentPlayerController.GetPlayerReplicationInfo();
		targetPlayerNumber = targetPlayerReplicationInfo.GetPlayerNumber();
		targetPlayer = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber(targetPlayerNumber);
		if(channel == CHAT_ALL 
			|| (channel == CHAT_TEAM && class'H7TeamManager'.static.GetInstance().IsAllied(sendingPlayer,targetPlayer))
			|| (channel - CHAT_WHISPER == targetPlayerNumber)
			|| targetPlayer == sendingPlayer // I see my own messages / server sends my own messages to me and I display it as "To xxx"
		)
		currentPlayerController.ClientLobbyChat( playerName, chatText , channel );
	}

	class'H7ReplicationInfo'.static.PrintLogMessage(self @ "ServerLobbyChat " @ playerName @ chatText, 0);;
}

// client receives chat message from server / or the one he send was approved and send 'back'
reliable client function ClientLobbyChat( string playerName, string chatText, EChatChannel channel)
{
	if(class'H7MainMenuHud'.static.GetInstance() != none)
	{
		if(class'H7ReplicationInfo'.static.GetInstance().IsDuel())
		{
			class'H7MainMenuHud'.static.GetInstance().GetDuelSetupWindowCntl().AddChatLine( chatText, playerName );
		}
		else
		{
			class'H7MainMenuHud'.static.GetInstance().GetSkirmishSetupWindowCntl().AddChatLine( chatText, playerName );
		}
	}
	else if(class'H7LogSystemCntl'.static.GetInstance() != none)
	{
		class'H7LogSystemCntl'.static.GetInstance().AddChatLine( chatText, playerName , channel );
	}
	class'H7ReplicationInfo'.static.PrintLogMessage(self @ "ClientLobbyChat " @ playerName @ chatText, 0);;
}

reliable client event ClientWasKicked()
{
	super.ClientWasKicked();

	class'H7TransitionData'.static.GetInstance().SetMPClientWasKicked( true );
	class'H7ReplicationInfo'.static.PrintLogMessage("KICKED BY THE SERVER", 0);;
}

function SendLobbyStartGame( int mapMaxPlayers )
{
	local int i;
	local int positions[8];
	local H7PlayerController currentPlayerController;
	local array<int> availableStartPositions;
	local array<int> sharedPrivileges;
	local int convertedPrivileges[MAX_PRIVILEGES_COUNT];

	for(i=0;i<mapMaxPlayers;i++)
	{
		availableStartPositions.AddItem(i);
	}

	for(i=0;i<8;i++)
	{
		if( i < mapMaxPlayers )
		{
			positions[i] = availableStartPositions[ Rand( availableStartPositions.Length ) ];
			availableStartPositions.RemoveItem(positions[i]);
		}
		else
		{
			positions[i] = -1;
		}
	}

	sharedPrivileges = class'H7MultiplayerGameManager'.static.GetInstance().GetSharedPrivileges();

	if(sharedPrivileges.Length > MAX_PRIVILEGES_COUNT)
	{
		sharedPrivileges.Length = MAX_PRIVILEGES_COUNT;
		;
	}

	for(i=0; i<sharedPrivileges.Length; i++)
	{
		convertedPrivileges[i] = sharedPrivileges[i];
	}

	ForEach WorldInfo.AllControllers( class'H7PlayerController', currentPlayerController )
	{
		currentPlayerController.ClientLobbyStartGame( positions, convertedPrivileges );
	}
}

reliable client function ClientLobbyStartGame( int positions[8], int sharedPrivileges[MAX_PRIVILEGES_COUNT] )
{
	local int i;
	local int currentPosition;
	local array<int> privileges;

	mGameStarted = true;

	// calculate the random positions
	if( class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mMapSettings.mUseRandomStartPosition )
	{
		class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mMapSettings.mUseRandomStartPosition = false;
					
		for(i=0;i<8;i++)
		{
			if( class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mSlotState == EPlayerSlotState_Occupied 
				|| class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mSlotState == EPlayerSlotState_AI )
			{
				class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mPosition = EStartPosition(positions[currentPosition]+1);
				++currentPosition;
			}
		}
	}

	// close all open slots
	for(i=0;i<8;i++)
	{
		if(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mSlotState == EPlayerSlotState_Open)
		{
			class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mSlotState = EPlayerSlotState_Closed;
		}
	}

	for(i=0; i<MAX_PRIVILEGES_COUNT; i++)
	{
		if(sharedPrivileges[i] > 0)
		{
			privileges.AddItem(sharedPrivileges[i]);
		}
	}

	OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).SetTemporaryPrivileges(privileges);
	// block everything, the players should not be able to leave the lobby or change any property
	class'H7ReplicationInfo'.static.GetInstance().WriteLobbyDataToTransitionData( true );
	class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().NoChoicePopup("PU_GAME_HAS_STARTED");
}

//////////////////////////////////////
// END MULTIPLAYER
//////////////////////////////////////

function ToggleFlythrough(bool val, optional bool toggleHud = true, optional bool toggleCinematicView = true, optional bool toggleFog = false)
{
	SetFlythroughRunning(!mIsFlythroughRunning, toggleHud, toggleCinematicView);
}

function SetFlythroughRunning(bool val, optional bool toggleHud = true, optional bool toggleCinematic = true, optional bool toggleFog = false)
{
	// ignore it for the spectator mode in combat map
	if( class'H7CombatController'.static.GetInstance() != none && class'H7CombatController'.static.GetInstance().IsLocalPlayerSpectator() && 
		class'H7AdventureController'.static.GetInstance() != none && !class'H7AdventureController'.static.GetInstance().IsSpectatorMode() )
	{
		return;
	}
	//`log_cam("(>o.o)>   Com SetFly:"@val@"   Toggle H7Cinematic        bToggleHud:"@toggleHud@"bToggleFog:"@toggleFog@"bToggleCinematicView:"@toggleCinematic);
	mIsFlythroughRunning = val;

	if(toggleHud)
	{
		if(mIsFlythroughRunning       && !GetHud().HideH7HUD)	{ ; GetHud().ToggleHUD(); }
		else if(!mIsFlythroughRunning &&  GetHud().HideH7HUD)	{ ; GetHud().ToggleHUD(); }
		else ;
	}


	if(toggleCinematic)
	{
		if(mIsFlythroughRunning      && !mIsInCinematicView)   
		{ 
			;
			ToggleCinematicView( true );
		}
		else if(!mIsFlythroughRunning &&  mIsInCinematicView)   
		{ 
			; 
			ToggleCinematicView( false ); 
			if(class'H7ReplicationInfo'.static.GetInstance().IsCombatMap())
			{
				class'H7CombatController'.static.GetInstance().RefreshAllUnits();
			}
		}
		else ;
	}

	// toggleFog is done in H7AdventurePlayerController
}

/**
 * Use to hide everything that should not appear during a cinematic.
 * Currently hides:
 * Flags
 * TODO: Fix calls with parameter
 * */
exec function ToggleCinematicView( bool newCinematicView ) // TODO: Force Johannes to change it to SetCinematicView
{
	;
	
	mIsInCinematicView = newCinematicView;

	// VISUALS
	SetCinematicVisibilities(newCinematicView);

	// CONTROLS
	SetCinematicControls(newCinematicView);

	;

}

function SetCinematicControls(bool newCinematicView)
{
	// input
	if( newCinematicView )
	{
		class'H7PlayerController'.static.GetPlayerController().SetIsUnrealInputAllowed(false);
	}
	else
	{
		if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() )
		{
			class'H7AdventureController'.static.GetInstance().CalculateInputAllowed();
		}
		else
		{
			class'H7CombatController'.static.GetInstance().CalculateInputAllowed();
		}
	}

	// hardware mouse
	if(!newCinematicView)
	{
		class'H7PlayerController'.static.GetPlayerController().SetCursor(CURSOR_NORMAL);
	}
	else
	{
		class'H7PlayerController'.static.GetPlayerController().SetCursor(CURSOR_INVISIBLE);
	}
}

exec function SetFlagVisibility( bool hidden )
{
	local H7Flag flag;

	foreach WorldInfo.DynamicActors( class'H7Flag', flag )
	{
		flag.ForceFlagHide( hidden );
		if( !hidden && !flag.Owner.bHidden )
		{
			flag.SetHidden( false );
		}
	}
}

function SetCinematicVisibilities(bool newCinematicView)
{
	local H7Flag flag;

	// Outline
	class'H7PostProcessManager'.static.SetOutlineActive(!newCinematicView);

	// flags & hero aura-glow
	if( !newCinematicView )
	{
		foreach WorldInfo.DynamicActors( class'H7Flag', flag )
		{
			if( !flag.Owner.bHidden )
			{
				flag.SetHidden( false );
			}
		}

		if( class'H7AdventureController'.static.GetInstance() != none )
		{
			class'H7AdventureController'.static.GetInstance().ShowAllHeroFX();
		}
	}
	else
	{
		foreach WorldInfo.DynamicActors( class'H7Flag', flag )
		{
			flag.SetHidden( true );
		}

		if( class'H7AdventureController'.static.GetInstance() != none )
		{
			class'H7AdventureController'.static.GetInstance().HideAllHeroFX();
		}
	}
	//SetCinematicMode(newCinematicView, false, false, false, false, false);

	// path preview
	if( class'H7AdventureController'.static.GetInstance() != none)
	{
		class'H7AdventureController'.static.GetInstance().GetGridController().GetPathPreviewer().HidePreview();
	} 
	else if( class'H7CombatController'.static.GetInstance() != none )
	{
		class'H7CombatController'.static.GetInstance().GetGridController().GetPathPreviewer().HidePreview();
		//class'H7CombatController'.static.GetInstance().GetGridController().GetDecal().SetHidden( true );
	}

	// blackbars
	// ...are a different unreal function and kismet node

}

function ResetCutsceneFlags()
{
	mIsInCinematicView = false;
	SetCinematicVisibilities( false );
	mIsFlythroughRunning = false;
}

exec function FOV(float F)
{
	super.FOV(F);

	class'H7Camera'.static.GetInstance().SetOverridenFOV(true);
}

// overwrite of engine function
function bool SetPause( bool bPause, optional delegate<CanUnpause> CanUnpauseDelegate=CanUnpause)
{
	// should not be possible to pause the game in multiplayer
	if( WorldInfo.GRI.IsMultiplayerGame() )
	{
		return false;
	}

	return super.SetPause( bPause, CanUnpauseDelegate );
}

exec function SimTurnsClearCombat()
{
	if( class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager() != none )
	{
		class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager().ResetOngoingStartCombat();
	}
}

exec function PrintProfile()
{
	class'H7PlayerProfile'.static.GetInstance().Cheat_PrintProfileData();
}

exec function DumpTweens()
{
	;
	class'H7CombatHudCntl'.static.GetInstance().GetFlashController().DumpTweens();
}

exec function CleanMovie()
{
	;
	class'H7CombatHudCntl'.static.GetInstance().GetFlashController().CleanMovie();
}

exec function UnlockAllRewards()
{

	class'H7PlayerProfile'.static.GetInstance().GetAchievementManager().Cheat_UnlockAllRewards();

}

exec function Nouplay()
{
	GetHud().GetGUIOverlaySystemCntl().GetUplayNote().SetData("Now Uplay","Now you don't",-9999);
}

exec native function H7UpdateLandscapeComponents(); // Call only this function as a deffered command
exec native function H7UpdateAllComponents(); // Call only this function as a deffered command

exec function ResetAllSteamworksStatsAndAchievements()
{
	OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).ResetAllUSteamAchievements();
}

// Escar Estaban
exec function DebugChangeFPS(float newFPS)
{
	if(class'H7GUIGeneralProperties'.static.GetInstance().GetDebugCheats())
	{
		class'Engine'.static.GetEngine().MaxSmoothedFrameRate = newFPS;
	}
}

function ResetOptions()
{
	// aa in postprocessmanager
	// graphics card -> no
	// resolution -> no
	// window mode -> no
	SetVSync(true);
	// ambient in gui
	// texture in gui
	SetDynamicShadows(true);
	SetBloom(true);
	SetDistortion(true);
	SetShaderQuality(1);
	// pp in ppman
	SetSkelMeshQuality(2);
	SetStaticMeshQuality(2);
	SetParticleQuality(2);
	SetLandscapeQuality(1);
	// lang gui
	// lang gui
	// sub gui

	PanningMouseSensitivity=1.5;
	GeneralPanningSensitivity = 8.0;
	KeyboardPanningSensitivity = 3.0;
	IsInverted=true;
	mBorderPan=true;
	MousePanningCache=10;
	mActiveProfile="Ivan_1";

	// special 
	// SetBufferedCommand_WindowMode(WM_FULLSCREEN);
}

// Default properties block
