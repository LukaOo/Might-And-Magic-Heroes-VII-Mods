//=============================================================================
// H7AdventurePlayerController
//=============================================================================
//
// Extends from H7CombatPlayerController, because the combats now can be played
// while the adventure map is still loaded
//
//=============================================================================
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AdventurePlayerController extends H7CombatPlayerController
	config(Game)
	dependson(H7SavegameController)
	native;
   
var protected H7AdventureObject mSpawnAdventureObjTemplate;

var protected float MAX_FLOAT;
var protected float mLastLeftClickTime;
var protected Actor mLastClickedActor;
var protected bool mTransitioningToCombat;

var protected int mHeroIdCancelTradePopUp;

// true if the player is gonna be in a normal combat
var protected bool mIsNormalCombatAboutToBegin;

var protected H7AdventureArmy mRetreatingArmy;
var protected bool mWasMovieRunning;

var protected int mAutoSaveFrameDelay;
var protected int mAutoSaveCurrentDelay;
/**
 * gets the PlayerController to see what buttons are pressed atm
 */
static function H7AdventurePlayerController GetAdventurePlayerController()
{
	local H7AdventurePlayerController MyPlayerController;
	local WorldInfo MyWorld;

	MyWorld = class'WorldInfo'.static.GetWorldInfo();
	if (MyWorld != None)
	{
		MyPlayerController = H7AdventurePlayerController(MyWorld.GetALocalPlayerController());
	}
	return MyPlayerController;
}

function bool IsMovieSkippedLastFrame() { return mMovieSkippedLastFrame > 0; }

// if this player is gonna start a normal combat
function bool IsNormalCombatAboutToBegin() { return mIsNormalCombatAboutToBegin; }
function SetNormalCombatAboutToBegin( bool newValue ) { mIsNormalCombatAboutToBegin = newValue; }

// if this player has a retreating army (SimTurns)
function H7AdventureArmy GetRetreatingArmy() { return mRetreatingArmy; }
function SetRetreatingArmy( H7AdventureArmy newRetreatingArmy ) { mRetreatingArmy = newRetreatingArmy; }

function SetTransitioningToCombat( bool val ) { mTransitioningToCombat = val; }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Clicks - Down/Up/Release - Left/Right/Double
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Get any actor under mouse
function bool GetActorUnderMouse(optional out ImpactInfo finalHitInfo)
{
	local Actor	 hitActor;
	local Vector2D mousePosition;
	local Vector2D screenSize;
	local TraceHitInfo hitInfo;

	local Vector worldOrigin;
	local Vector worldDirection;

	mousePosition = GetLocalPlayer().ViewportClient.GetMousePosition();
	GetLocalPlayer().ViewportClient.GetViewportSize(screenSize);

	mousePosition.X /= screenSize.X;
	mousePosition.Y /= screenSize.Y;

	GetLocalPlayer().DeProject(mousePosition, worldOrigin, worldDirection);

	hitActor = Trace(finalHitInfo.HitLocation, finalHitInfo.HitNormal, worldDirection * MAX_FLOAT, worldOrigin, true,,hitInfo);

	if(hitActor == none) 
		return false;
	
	finalHitInfo.HitActor = hitActor;
	finalHitInfo.HitInfo = hitInfo;

	return true;
}

function FlagSelected(H7CouncilFlagActor hitActor, H7CouncilMapManager managerRef)
{
	if(hitActor.bHidden == true || managerRef == none)
	{
		return;
	}

	managerRef.SelectFlag(hitActor);
}

/** Check if hero should be interrupted and interrupt hero if necessary
 * 
**/
function CheckInterruptHeroMovement()
{
	local H7AdventureController adventureController;

	adventureController = class'H7AdventureController'.static.GetInstance();

	//`log("MOUSEOVERHUD"@!IsMouseOverHUD()@"HUD+COMMAND:"@(IsMouseOverHUD() && adventureController.GetCommandQueue().IsCommandRunning())
	//	@"POPUP"@!IsPopupOpen()@"CAMACTION"@!IsCameraActionRunning()@"KISMET"@IsKismetAllowsInput()@"CARAVANTURN"@!IsCaravanTurn()
	//	@"COMMANDREQ"@!IsCommandRequested()@"AI"@!adventureController.GetCurrentPlayer().IsControlledByAI()@"ARMYNONE"@(adventureController.GetSelectedArmy() != none));

	if( ( !IsMouseOverHUD() || IsMouseOverHUD() && adventureController.GetCommandQueue().IsCommandRunning() )
		&& !IsPopupOpen() && !IsCameraActionRunning() && IsKismetAllowsInput() && !IsCaravanTurn() && !IsCommandRequested()
		&& !adventureController.GetCurrentPlayer().IsControlledByAI() && adventureController.GetSelectedArmy() != none )
	{
		adventureController.GetCommandQueue().Enqueue( class'H7Command'.static.CreateCommand( adventureController.GetSelectedArmy().GetHero(), UC_ABILITY, ACTION_INTERRUPT,, adventureController.GetSelectedArmy().GetHero(),,,,,true ) );
	}
}

exec function LeftMouseDown() // leftclickdown
{
	local H7AdventureController adventureController;
	local Vector hitPosition;
	local Actor clickedActor;
	local ImpactInfo finalHitInfo;

	clickedActor = class'H7AdventureGridManager'.static.GetInstance().GetMouseHitActorAndLocation( hitPosition ); 
	adventureController = class'H7AdventureController'.static.GetInstance();

	if(adventureController.IsCouncilMapActive())
	{
		// Mouse is not over HUD and input is allowed
		if( !IsMouseOverHUD() && IsKismetAllowsInput() && IsUnrealAllowsInput())
		{
			if(GetActorUnderMouse(finalHitInfo))
			{
				if(H7AdventureMapInfo(WorldInfo.Game) != none)
				{
					if(H7CouncilFlagActor(finalHitInfo.HitActor) != none)
					{
						FlagSelected(H7CouncilFlagActor(finalHitInfo.HitActor), adventureController.GetCouncilMapManager() );
					}
				}		
			}
		}
		return;
	}

	if(WorldInfo.TimeSeconds -  mLastLeftClickTime < 0.45)
	{
		mLastClickedActor = none;
	}

	mLastLeftClickTime = WorldInfo.TimeSeconds;
	mLastClickedActor = clickedActor;

	CheckInterruptHeroMovement();

	GetHud().SetLeftClickThisFrame(true);
	GetHud().SetLeftMouseDown(true);
	
	if( !IsInputAllowed() || class'H7AdventureGridManager'.static.GetInstance() == none ) { return; }
	
	if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() )
	{
		// handling army left click and town left click
		
		//if( adventureController.GetSelectedArmy() == none ) return;

		if( IsInputAllowed() )
		{
			DoCurrentArmyActionByCursor();
			/*
			if( !adventureController.GetSelectedArmy().IsLocked() )
			{
				
			}
			else
			{
				if( adventureController.GetSelectedArmy().IsInShelter() )
				{
					class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().YesNoPopup( `Localize("H7PopUp", "PU_LEAVE_SHELTER", "MMH7Game" ), `Localize("H7PopUp", "PU_YES", "MMH7Game" ), `Localize("H7PopUp", "PU_NO", "MMH7Game" ), DoLeaveShelter, none );
				}
				else
				{
					class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().YesNoPopup( `Localize("H7PopUp", "PU_ABORT_ACTION", "MMH7Game" ), `Localize("H7PopUp", "PU_YES", "MMH7Game" ), `Localize("H7PopUp", "PU_NO", "MMH7Game" ), HandleAbortManipulation, none );
				}
			}
			*/
		}
	}
	else // COMBAT
	{
		super.LeftMouseDown();
	}
}

function DoCurrentArmyActionByCursor()
{
	class'H7AdventureGridManager'.static.GetInstance().DoCurrentArmyActionByCursor();
}

exec function DoubleClick()
{
	if( IsInputAllowed() )
	{
		if(H7AdventureObject(mLastClickedActor) != none)
		{
			H7AdventureObject(mLastClickedActor).OnDoubleClick();
		}
	}
}

exec function ReleaseLeftMouse()
{
	if(class'H7AdventureController'.static.GetInstance().IsCouncilMapActive())
	{
		

		return;
	}

	if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() )
	{
		GetHud().SetLeftClickThisFrame(false);
		GetHud().SetLeftMouseDown(false);
	}
	else // COMBAT
	{
		super.ReleaseLeftMouse();
	}
}

exec function RightMouseDown()
{
	local Actor lastHitActor;
	
	if(class'H7AdventureController'.static.GetInstance().IsCouncilMapActive())
	{
		return;
	}

	if( GetAdventureHud().GetAdventureHudCntl().GetActorTooltip().IsVisible() )
	{
		MouseRotationAllowed = false;
	}
	else
	{
		MouseRotationAllowed = true;
	}

	if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() )
	{
		GetHud().SetRightClickThisFrame(true);
		GetHud().SetRightMouseDown(true);
		GetAdventureHud().GetAdventureHudCntl().GetActorTooltip().StartRightClickTooltip();

		if( IsInputAllowed() )
		{
			// cancel spell
			if(class'H7AdventureController'.static.GetInstance().GetSelectedArmy() != none && class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero().HasPreparedAbility())
			{
				class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero().ResetPreparedAbility();
				class'H7PlayerController'.static.GetPlayerController().UnLoadCursorObject();
				class'H7PlayerController'.static.GetPlayerController().GetHud().GetSpellbookCntl().GetQuickBar().UnSelectSpell();
			}
			// right click object
			else
			{
				lastHitActor = class'H7AdventureGridManager'.static.GetInstance().GetLastHitActor();
				if(H7AdventureObject(lastHitActor) != none)
				{
					H7AdventureObject(lastHitActor).OnRightClick();
				}
			}
		}
	}
	else // COMBAT
	{
		super.RightMouseDown();
	}
}

exec function ReleaseRightMouse()
{
	if(class'H7AdventureController'.static.GetInstance().IsCouncilMapActive())
	{
		

		return;
	}

	if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() )
	{
		CheckInterruptHeroMovement();
		GetHud().SetRightClickThisFrame(true);
		GetHud().SetRightMouseDown(false);
		GetAdventureHud().GetAdventureHudCntl().GetActorTooltip().StopRightClickTooltip();

		if( IsInputAllowed() )
		{
			class'H7AdventureGridManager'.static.GetInstance().SetTeleportPhase( false );
		}
	}
	else // COMBAT
	{
		super.ReleaseRightMouse();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Main Command Panel - Popups & Functions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

exec function SwapArmies()
{
 	if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() && GetAdventureHud().GetTownHudCntl().GetMiddleHUD().IsVisible() )
	{
		if(!GetAdventureHud().GetTownHudCntl().CanSwap()) return;
		
		GetAdventureHud().GetTownHudCntl().RequestHeroTransfer(ARMY_NUMBER_VISIT,ARMY_NUMBER_GARRISON);
	}
}

exec function TownNext()
{
	TownBrowse(1);
}

exec function TownPrev()
{
	TownBrowse(-1);
}

function TownBrowse(int dir)
{
	local array<H7Town> towns;
	local H7Town currentTown;
	local int currentTownIndex,newTownIndex;
	// check if input has focus
	if(GetHud().IsFocusOnInput()) return;
	if(CurrentContextBlocksKeybind(class'H7GameUtility'.static.GetFunctionName(0))) return;

	if(class'H7TownHudCntl'.static.GetInstance().IsInTownScreen())
	{
		towns = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetTowns();
		currentTown = class'H7TownHudCntl'.static.GetInstance().GetTown();
		currentTownIndex = towns.Find(currentTown);
		newTownIndex = currentTownIndex + dir;
		if(newTownIndex < 0)
		{
			newTownIndex = towns.Length + newTownIndex;
		}
		else if(newTownIndex >= towns.Length)
		{
			newTownIndex -= towns.Length;
		}
		class'H7TownHudCntl'.static.GetInstance().SelectTown(towns[newTownIndex].GetID());
	}
}

exec function ContinueHeroMove()
{
	if(CurrentContextBlocksKeybind(class'H7GameUtility'.static.GetFunctionName(0))) return;

	// while transitioning to combat map, don't allow  hero movement (else the popup will open again and cause all kinds of trouble)
	if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() && !mTransitioningToCombat )
	{
		GetAdventureHud().GetAdventureHudCntl().ToggleHeroMovement();
	}
}

exec function OpenQuestLog()
{
	if(CurrentContextBlocksKeybind(class'H7GameUtility'.static.GetFunctionName(0))) return;

	if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() )
	{
		CheckInterruptHeroMovement();
		GetAdventureHud().GetAdventureHudCntl().ToggleQuestLog();
	}
}

exec function OpenSpellBook()
{
	if(CurrentContextBlocksKeybind(class'H7GameUtility'.static.GetFunctionName(0))) return;

	// is the current map an adventure map? if yes, open the spellbook here
	// if not, let H7CombatPlayerController handle it
	if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() )
	{
		CheckInterruptHeroMovement();
		GetAdventureHud().GetAdventureHudCntl().ToggleSpellBook();
	}
	else
	{
		// just in case the controller stays the same...
		super.OpenSpellBook();
	}
}

exec function ToggleTable()
{
	if(CurrentContextBlocksKeybind(class'H7GameUtility'.static.GetFunctionName(0))) return;

	if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() 
		&& class'H7AdventureController'.static.GetInstance().GetMapInfo().GetMapType() == CAMPAIGN )
	{
		CheckInterruptHeroMovement();
		GetAdventureHud().GetAdventureHudCntl().ToggleTable();
	}
}

exec function OpenHeroWindow()
{
	if(CurrentContextBlocksKeybind(class'H7GameUtility'.static.GetFunctionName(0))) return;

	if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() )
	{
		CheckInterruptHeroMovement();
		GetAdventureHud().GetAdventureHudCntl().ToggleHeroWindow();
	}
}

exec function OpenSkillwheel()
{
	if(CurrentContextBlocksKeybind(class'H7GameUtility'.static.GetFunctionName(0))) return;

	if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() )
	{
		CheckInterruptHeroMovement();
		GetAdventureHud().GetAdventureHudCntl().ToggleSkillWheel();
	}
}

exec function EndPlayerTurn()
{
	if(CurrentContextBlocksKeybind(class'H7GameUtility'.static.GetFunctionName(0))) return;

	if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() && IsKeyInputAllowed() && IsInputAllowed(true) )
	{
		if( class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().IsInAnyScreen() ) 
		{
			class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().Leave();
			return;
		}

		GetAdventureHud().GetAdventureHudCntl().ToggleEndTurn();
	}
}

exec function MergeArmyUp()
{
	if(CurrentContextBlocksKeybind(class'H7GameUtility'.static.GetFunctionName(0))) return;
	
	if(class'H7TownHudCntl'.static.GetInstance().GetMiddleHUD().IsVisible())
	{
		class'H7TownHudCntl'.static.GetInstance().RequestArmyMerge(ARMY_NUMBER_VISIT,ARMY_NUMBER_GARRISON);
	}
}

exec function MergeArmyDown()
{
	if(CurrentContextBlocksKeybind(class'H7GameUtility'.static.GetFunctionName(0))) return;

	if(class'H7TownHudCntl'.static.GetInstance().GetMiddleHUD().IsVisible())
	{
		class'H7TownHudCntl'.static.GetInstance().RequestArmyMerge(ARMY_NUMBER_GARRISON,ARMY_NUMBER_VISIT);
	}
}

exec function CoverFogTest()
{
	local array<IntPoint> visiblePoints;
	
	class'H7Math'.static.GetMidPointCirclePoints( visiblePoints, class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetCell().GetCellPosition(), 7 );
	class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetCell().GetGridOwner().GetFOWController().HandleExploredTiles( class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetPlayerNumber(), visiblePoints,,true);
	class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetCell().GetGridOwner().GetFOWController().ExploreFog( true );
}

exec function TestGUIHighlight()
{
	class'H7AdventureHudCntl'.static.GetInstance().GetFlashController().HighlightElement("aCommandPanel","mBtnSpellbook");
}

exec function DumpCurrentState()
{
	local H7AdventureController adventureController;
	local int i;

	class'H7ReplicationInfo'.static.PrintLogMessage("*************** CURRENT GAME STATE DUMP ***************", 0);;
	adventureController = class'H7AdventureController'.static.GetInstance();

	for(i=1; i<adventureController.GetPlayers().Length; i++)
	{
		adventureController.DumpCurrentState(adventureController.GetPlayerByIndex(i));
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Main Menu global Shortcuts
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

exec function OpenLoadWindow()
{
	if(CurrentContextBlocksKeybind(class'H7GameUtility'.static.GetFunctionName(0))) return;

	if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap()
		&& class'H7PlayerController'.static.GetPlayerController().IsServer() 
		&& class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().IsControlledByLocalPlayer())
	{
		if(GetAdventureHud().GetCurrentContext() != GetHud().GetLoadSaveWindowCntl())
		{
			GetAdventureHud().CloseCurrentPopup();
		}

		CheckInterruptHeroMovement();
		GetHud().GetPauseMenuCntl().OpenLoadMenu();
	}
}

exec function OpenSaveWindow()
{
	if(CurrentContextBlocksKeybind(class'H7GameUtility'.static.GetFunctionName(0))) return;

	if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() 
		&& class'H7PlayerController'.static.GetPlayerController().IsServer() 
		&& class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().IsControlledByLocalPlayer() )
	{
		if(GetAdventureHud().GetCurrentContext() != GetHud().GetLoadSaveWindowCntl())
		{
			GetAdventureHud().CloseCurrentPopup();
		}

		CheckInterruptHeroMovement();
		GetHud().GetPauseMenuCntl().OpenSaveMenu();
	}
}

exec function OpenOptions()
{
	if(CurrentContextBlocksKeybind(class'H7GameUtility'.static.GetFunctionName(0))) return;
	
	CheckInterruptHeroMovement();
	TogglePopup( GetHud().GetOptionsMenuCntl() );
}

exec function QuickSave()
{
	if(CurrentContextBlocksKeybind(class'H7GameUtility'.static.GetFunctionName(0))) return;
	if(!class'H7PauseMenuCntl'.static.GetInstance().CanSave()) return;

	if(!class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().IsControlledByLocalPlayer())
	{
		return;
	}

	if(!class'H7PlayerController'.static.GetPlayerController().IsServer())
	{
		return;
	}
	
	if( GetHUD().GetCurrentContext() != none && GetHUD().GetCurrentContext().IsA('H7OptionsMenuCntl'))
	{
		return;
	}

	//`LOG_MP("SkillTrack: Performing QuickSave with TimeStamp "@class'H7PlayerController'.static.GetPlayerController().GetHud().GetTimeStamp()@"...");
	ScriptTrace();

	GetHUD().GetPopupCntl().GetRequestPopup().NoChoicePopup("PU_SAVING");
	GetHUD().GetLoadSaveWindowCntl().TakeScreenShot();

	GetHud().SetFrameTimer(10,QuickSaveContinue);
}
function QuickSaveContinue()
{
	local int quickSaveSlot;

	GetHUD().GetLoadSaveWindowCntl().StopTakeScreenshot();

	quickSaveSlot = class'H7SavegameController'.const.SLOT_QUICKSAVE;
	
	//GetHud().GetLoadSaveWindowCntl().SaveCurrentScreenshotTo(string(quickSaveSlot));
	// ACTUAL SAVE | OVERWRITE
	SaveGame(quickSaveSlot,SAVETYPE_QUICK);
}

// We delay autosave to give start of turn events some time to fire (some of them require few ticks)
function QueueAutoSaveGame()
{
	if(!class'H7ReplicationInfo'.static.GetInstance().IsAutoSaveEnabled()) return;
	if(class'H7ReplicationInfo'.static.GetInstance().mIsTutorial) return;

	mAutoSaveCurrentDelay = 0;
}

function AutoSaveGame()
{
	if(!class'H7ReplicationInfo'.static.GetInstance().IsAutoSaveEnabled()) return;
	if(class'H7ReplicationInfo'.static.GetInstance().mIsTutorial) return;

	//`LOG_MP("SkillTrack: Performing AutoSave with TimeStamp "@class'H7PlayerController'.static.GetPlayerController().GetHud().GetTimeStamp()@"...");
	//ScriptTrace();

	SaveGameComplete( -1, SAVETYPE_AUTO );

	// only the singleplayer or the server can make screenshots
	if( !WorldInfo.GRI.IsMultiplayerGame() || class'H7PlayerController'.static.GetPlayerController().IsServer() )
	{
		GetHUD().GetLoadSaveWindowCntl().TakeScreenShot();
		GetHud().SetFrameTimer(10,AutoSaveGameContinue);
	}
}

function AutoSaveGameContinue()
{
	GetHUD().GetLoadSaveWindowCntl().StopTakeScreenshot();
	//GetHud().GetLoadSaveWindowCntl().SaveCurrentScreenshotTo(mAutosaveFileName); // TODO slot index
}

event PlayerTick(float DeltaTime)
{
	local bool cinematicIsRunning;

	if(class'H7AdventureController'.static.GetInstance() != None && class'H7AdventureController'.static.GetInstance().IsCouncilMapActive())
	{
		return;
	}

	if(mAutoSaveCurrentDelay > -1 )
	{
		if(mAutoSaveCurrentDelay >= mAutoSaveFrameDelay)
		{
			AutoSaveGame();
			mAutoSaveCurrentDelay = -1;
		}
		else
		{
			++mAutoSaveCurrentDelay;
		}
	}
	

	super.PlayerTick(DeltaTime);
	// this is just a giant pile of frame hacks YOLO

	// skip keyinput
	if(mMovieSkippedLastFrame>0) mMovieSkippedLastFrame--;

	// movie on/off

	cinematicIsRunning = IsCinematicRunning();

	if(cinematicIsRunning && mIsInCinematicView ) // the frame where the movie started
	{
		mIsInCinematicView = true;
		SetCinematicVisibilities( true );
		SetCursor(CURSOR_INVISIBLE);
	}
	if( !mIsFlythroughRunning && !cinematicIsRunning && mIsInCinematicView ) // the frame where the movie stopped (skip + normal end)
	{
		mIsInCinematicView = false;
		SetCinematicVisibilities( false );
		SetCursor(CURSOR_NORMAL);
	}
	//The Soundcontroller needs to be adjusted, if there is Cinematic played. Not if a Skripted Event was triggered. So it ignores mIsInCinematicView
	if( cinematicIsRunning && !mWasMovieRunning  && class'H7SoundController'.static.GetInstance() != none )
	{
		class'H7SoundController'.static.GetInstance().InCinematicMode(true);
		class'H7SoundController'.static.GetInstance().UpdateMusicGameStateSwitch("CINEMATIC");
		mWasMovieRunning = true;
	}
	if( !cinematicIsRunning && mWasMovieRunning  && class'H7SoundController'.static.GetInstance() != none )
	{
		class'H7SoundController'.static.GetInstance().InCinematicMode(false);
		class'H7SoundController'.static.GetInstance().UpdateMusicGameStateSwitch("ADVENTURE_MAP");
		mWasMovieRunning = false;
	}
}

exec function QuickLoad()
{
	if(CurrentContextBlocksKeybind(class'H7GameUtility'.static.GetFunctionName(0))) return;
	
	if(!class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().IsControlledByLocalPlayer())
	{
		return;
	}

	if(!IsServer())
	{
		return;
	}

	if(class'H7ReplicationInfo'.static.GetInstance().IsMultiplayerGame())
	{
		return;
	}

	mWantsQuickLoad = true;
	ScanForAllSaveGames();
}

function DeferredQuickLoadPopup()
{
	if(QuickSaveExists())
	{
		class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().YesNoPopup(
			"PU_QUICKLOAD","OK","CANCEL",QuickLoadConfirm,none,true
		);
	}
	else
	{
		class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().OKPopup(
			"PU_NO_QUICKSAVE","OK",none
		);
	}
}

function QuickLoadConfirm()
{
	local int quickSaveSlot;
	quickSaveSlot = class'H7SavegameController'.const.SLOT_QUICKSAVE;
	GetHUD().GetPopupCntl().GetRequestPopup().NoChoicePopup("PU_LOADING");
	// ACTUAL LOAD
	class'H7PlayerController'.static.GetPlayerController().LoadGameState(
		quickSaveSlot,
		GetSaveGameHeaderManagerForSaveGame(quickSaveSlot).GetMapFileName()
	);
}

function bool QuickSaveExists()
{
	return class'H7PlayerController'.static.GetPlayerController().SaveGameExists(class'H7SavegameController'.const.SLOT_QUICKSAVE);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Hero&Town Select
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

function SelectHero(int index)
{
	local int heroId;

	if(CurrentContextBlocksKeybind(class'H7GameUtility'.static.GetFunctionName(0))) return;

	heroId = H7AdventureHud(GetHud()).GetAdventureHudCntl().GetHeroHUD().HudPositionToHeroId(index);
	if(heroId >= 0)
	{
		CheckInterruptHeroMovement();
		H7AdventureHud(GetHud()).GetAdventureHudCntl().HeroClick(heroId);
	}
}

exec function SelectHero1()     { SelectHero(0); }
exec function SelectHero2()     { SelectHero(1); }
exec function SelectHero3()     { SelectHero(2); }
exec function SelectHero4()     { SelectHero(3); }
exec function SelectHero5()     { SelectHero(4); }
exec function SelectHero6()     { SelectHero(5); }
exec function SelectHero7()     { SelectHero(6); }
exec function SelectHero8()     { SelectHero(7); }
exec function SelectHero9()     { SelectHero(8); }
exec function SelectHero10()    { SelectHero(9); }

function SelectTown(int index)
{
	local H7Town town;

	if(CurrentContextBlocksKeybind(class'H7GameUtility'.static.GetFunctionName(0))) return;

	if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() ) 
	{
		town = GetAdventureHud().GetAdventureHudCntl().GetTownByIndex(index);
		if( GetAdventureHud().GetTownHudCntl().IsInTownScreen() )
		{
			// switch townscreen
			GetAdventureHud().GetTownHudCntl().SelectTown( town.GetID() );
		}
		else
		{
			// center camera (old design)
			// class'H7Camera'.static.GetInstance().SetFocusActor(town);
			// goto townscreen (new design)
			CheckInterruptHeroMovement();
			GetAdventureHud().GetTownHudCntl().SelectTown( town.GetID() );
		}
	}
}

exec function SelectTown1()     { SelectTown(0); }
exec function SelectTown2()     { SelectTown(1); }
exec function SelectTown3()     { SelectTown(2); }
exec function SelectTown4()     { SelectTown(3); }
exec function SelectTown5()     { SelectTown(4); }
exec function SelectTown6()     { SelectTown(5); }
exec function SelectTown7()     { SelectTown(6); }
exec function SelectTown8()     { SelectTown(7); }
exec function SelectTown9()     { SelectTown(8); }
exec function SelectTown10()    { SelectTown(9); }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Town Keybindings
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

function OpenTownPopup(ETownPopup popup)
{
	// check if input has focus
	if(GetHud().IsFocusOnInput()) return;
	if(CurrentContextBlocksKeybind(class'H7GameUtility'.static.GetFunctionName(0))) return;

	if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() && GetAdventureHud().GetTownHudCntl().IsInTownScreen() )
	{
		CheckInterruptHeroMovement();
		GetAdventureHud().GetTownHudCntl().ToggleVisitTownBuilding(popup);
	}
}
exec function OpenMainBuilding()        { OpenTownPopup(POPUP_BUILD); }
exec function OpenHallOfHeroes()        { OpenTownPopup(POPUP_HALLOFHEROS); }
exec function OpenWarfare()             { OpenTownPopup(POPUP_WARFARE); }
exec function OpenMarketPlace()         { OpenTownPopup(POPUP_MARKETPLACE); }
exec function OpenMagicGuild()          { OpenTownPopup(POPUP_MAGICGUILD); }
exec function OpenRecruitmentWindow()   { OpenTownPopup(POPUP_RECRUIT); }
exec function OpenGuildOfThieves()      { OpenTownPopup(POPUP_THIEVES); }
exec function OpenTownDefense()         { OpenTownPopup(POPUP_TOWNGUARD); }
exec function OpenCaravan()             { OpenTownPopup(POPUP_CARAVAN); }
exec function OpenCustom1()             { OpenTownPopup(POPUP_CUSTOM1); }
exec function OpenCustom2()             { OpenTownPopup(POPUP_CUSTOM2); }

// OPTIONAL make real popup keybind
exec function BuyAllRecruits()
{
	//SUPER DUPER MEGA ULTRA DEBUG HACK!!!
	//`log_gui("CombatPopUp HACK");
    //class'H7PlayerController'.static.GetPlayerController().GetHUD().GetCombatPopUpCntl().StartAdvance();
	//class'H7PlayerController'.static.GetPlayerController().GetHUD().GetCombatPopUpCntl().GetCombatPopUp().SetVisibleSave(true);
	//return;
	
	;

	if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() && GetAdventureHud().GetTownRecruitmentCntl().GetRecruitmentPopup().IsVisible() )
	{
		GetAdventureHud().GetTownRecruitmentCntl().RecruitAll();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Other Keys
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

exec function ContinueContextOrChat() // Enter
{
	if(CurrentContextBlocksKeybind(class'H7GameUtility'.static.GetFunctionName(0))) return;

	if(IsCinematicRunning())
	{
		SkipMovie();
		return;
	}

	super.ContinueContextOrChat();
}

exec function ContinueContext() // Space
{
	if(CurrentContextBlocksKeybind(class'H7GameUtility'.static.GetFunctionName(0))) return;

	if(IsCinematicRunning())
	{
		SkipMovie();
		return;
	}
}

// ignores popup.keyblocking
exec function ToggleMenu() // it's really: Cancel current window/action, Escape
{
	local bool popupsWereClosed;

	;

	if(GetHud().GetFocusMovie() == class'H7OptionsMenuCntl'.static.GetInstance())
	{
		// it could be that flash is in key-assignment mode, but that call arrives later via AnyKeyPressed, we can not kill the window here
		if(class'H7OptionsMenuCntl'.static.GetInstance().GetOptionsMenu().IsInAssignMode() == 1)
		{
			return;
		}
	}

	if(H7AdventureHud(GetHUD()).GetThievesGuildCntl().GetPopup().IsVisible() && H7AdventureHud(GetHUD()).GetThievesGuildCntl().IsHeroInfoOpen())
	{
		H7AdventureHud(GetHUD()).GetThievesGuildCntl().CloseHeroInfo();
		return;
	}

	if(GetHUD().GetPauseMenuCntl().IsOpen() && GetHUD().GetPauseMenuCntl().CustomDifficultyPopUpOpen())
	{
		GetHUD().GetPauseMenuCntl().CloseCustomDifficultyPopUp();
		return;
	}

	if(GetHUD().GetHeropedia().GetPopup().IsVisible())
	{
		GetHUD().GetHeropedia().Closed();
		return;
	}

	if(class'H7AdventureController'.static.GetInstance().IsCouncilMapActive())
	{
		class'H7AdventureController'.static.GetInstance().SwitchToAdventureMap();
		return;
	}

	if(GetHUD().GetPauseMenuCntl().GetMapResultPopUp().IsVisible())
		return;

	if(IsCinematicRunning())
	{
		SkipMovie();
		return;
	}

	if(class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetQuestController().GetEndMatinee() != none
		&& class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetQuestController().GetEndMatinee().bIsPlaying )
	{
		class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetQuestController().GetEndMatinee().SetPosition(999999999);
		return;
	}

	if(!class'H7PlayerController'.static.GetPlayerController().IsKismetAllowsInput()) return;

	if(class'H7CameraActionController'.static.GetInstance() != none && class'H7CameraActionController'.static.GetInstance().CanCancelCurrentCameraAction())
	{
		class'H7CameraActionController'.static.GetInstance().CancelCurrentCameraAction();
		return;
	}
	// TODO check if the white-glow-combat-zoom is running, block esc in this case

	CheckInterruptHeroMovement();

	if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() )
	{
		// cancel Adventuremap spell
		if(class'H7AdventureController'.static.GetInstance().GetSelectedArmy() != none && class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero().HasPreparedAbility())
		{
			class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero().ResetPreparedAbility();
			class'H7PlayerController'.static.GetPlayerController().UnLoadCursorObject();
			class'H7PlayerController'.static.GetPlayerController().GetHud().GetSpellbookCntl().GetQuickBar().UnSelectSpell();
			return;
		}

		// if there is something being dragged
		if( GetAdventureHud().UnLoadCursorObject() == 1 )
		{
			if( GetHUD().GetCurrentContext() != none )
				GetHUD().GetCurrentContext().GetPopup().ResetDragAndDrop();
			else
				H7AdventureHud( GetHUD() ).GetTownHudCntl().GetMiddleHUD().ResetDragAndDrop();
			return;
		}

		if( GetHud().IsFocusOnInput() )
		{
			GetHud().LoseFocusOnInput();
			return;
		}

		popupsWereClosed = class'H7PlayerController'.static.GetPlayerController().GetHud().CloseCurrentPopup(true,false); // popup was canceled
		if(popupsWereClosed)
		{
			// was it recruitment in fort&dwelling?
			if(GetAdventureHud().GetTownHudCntl().IsInFortScreen() || GetAdventureHud().GetTownHudCntl().IsInDwellingScreen())
			{
				// close it as well:
				GetAdventureHud().GetTownHudCntl().Leave();
			}
		}
		else
		{
			// can we close a townscreen?
			if(GetAdventureHud().GetTownHudCntl().IsInAnyScreen())
			{
				GetAdventureHud().GetTownHudCntl().Leave();
			}
			else
			{
				class'H7PlayerController'.static.GetPlayerController().GetHud().GetPauseMenuCntl().OpenPopup();
			}
		}
	}
	else
	{
		// just in case the controller stays the same...
		super.ToggleMenu();
	}
	ConsoleCommand("CANCELMATINEE");
}

exec function ToggleMiniMapOptions()
{
	if(CurrentContextBlocksKeybind(class'H7GameUtility'.static.GetFunctionName(0))) return;

	if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() )
	{
		GetAdventureHud().GetAdventureHudCntl().GetMinimap().ToggleMinimapOptions();
	}
}

exec function ShowRealmOverview()
{
	if(CurrentContextBlocksKeybind(class'H7GameUtility'.static.GetFunctionName(0))) return;

	if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() )
	{
		// TODO implement as soon as realm overview GUI exists
	}
}


exec function HighlightAdventureObjects()
{
	local array<H7AdventureObject> advObjs;
	local array<H7AdventureArmy> advArmies;
	local H7AdventureObject advObj;
	local H7AdventureArmy advArmy;
	//local H7AdventureHero hero;
	local H7FCTController fctController;
	local H7AdventureGridManager gridManager;
	local H7AdventureController advController;
	local H7AdventureMapCell cell;

	if(class'H7PlayerController'.static.GetPlayerController().IsPaused()) return;

	advController = class'H7AdventureController'.static.GetInstance();
	//hero = advController.GetSelectedArmy().GetHero();
	fctController = class'H7FCTController'.static.GetInstance();
	gridManager = class'H7AdventureGridManager'.static.GetInstance();

	class'H7ReplicationInfo'.static.GetInstance().GetPostprocessManager().ApplyGameTypeEffect(true, true);

	if( fctController.HasActiveHighlights() ) return;

	advObjs = advController.GetAdvObjectList();
	foreach advObjs( advObj )
	{		
		cell = gridManager.GetCellByWorldLocation( advObj.Location );
		if( cell == none || !cell.GetGridOwner().GetFOWController().CheckExploredTile( advController.GetLocalPlayer().GetPlayerNumber(), cell.GetGridPosition() ) /*|| advObj.GetMeshComp().LastRenderTime < class'WorldInfo'.static.GetWorldInfo().TimeSeconds*/ )
		{
			continue;
		}
		if( H7AreaOfControlSite( advObj ) != none )
		{
			OutlineAdventureObject( advObj, H7AreaOfControlSite( advObj ).GetPlayer().GetColor() );
		}
		/*else if( H7PermanentBonusSite( advObj ) != none && H7PermanentBonusSite( advObj ).HasVisited( hero ) )
		{
			OutlineAdventureObject( advObj );
		}
		else if( H7BuffSite( advObj ) != none && H7BuffSite( advObj ).HasAllBuffsFromHere( hero ) )
		{
			OutlineAdventureObject( advObj );
		}*/
		else if( H7NeutralSite( advObj ) != none )
		{
			OutlineAdventureObject( advObj, MakeColor(105,120,138,255) );
		}
		else if( H7Obelisk( advObj ) != none )
		{
			OutlineAdventureObject( advObj, MakeColor(105,120,138,255) );
		}
		else if( H7ResourcePile( advObj ) != none || H7ItemPile( advObj ) != none)
		{
			// resources get an outline in this view
			OutlineAdventureObject( advObj, MakeColor(138,138,105,255) );
			advObj.GetMeshComp().SetOutlined(true);
		}
	}
	advController.GetArmiesCurrentlyOnMap(advArmies);
	foreach advArmies( advArmy )
	{
		cell = advArmy.GetCell();
		if( cell == none || !cell.GetGridOwner().GetFOWController().CheckExploredTile( advController.GetCurrentPlayer().GetPlayerNumber(), cell.GetGridPosition() ) /*|| advArmy.SkeletalMeshComponent.LastRenderTime < class'WorldInfo'.static.GetWorldInfo().TimeSeconds*/ )
		{
			continue;
		}

		advArmy.SkeletalMeshComponent.SetOutlined(true);
		advArmy.mHorseMesh.SetOutlined(true);
		
	}
	fctController.SetHighlighting( true );
}

function OutlineAdventureObject(H7AdventureObject advObject, optional Color outlineColor = MakeColor(128,128,128,255), optional bool showOutline=true)
{
	//if(!advObject.GetMeshComp().bOutlined)
	//{
	//	`warn("H7AdventurePlayerController: Want to outline"@advObject@advObject.GetName()@"but it can't be outlined!");
	//	return;
	//}

	advObject.GetMeshComp().SetOutlined( showOutline );

	if(showOutline)
	{
		advObject.GetMeshComp().SetOutlineColor( outlineColor );
	}
}

exec function DehighlightAdventureObjects()
{
	class'H7ReplicationInfo'.static.GetInstance().GetPostprocessManager().ApplyGameTypeEffect(false, true);

	class'H7AdventureController'.static.GetInstance().DehighlightAdventureObjects();
}







/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Cheats
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

// keys

exec function TeleportHero()
{
	if(!class'H7OptionsManager'.static.GetInstance().GetSettingBool("SHOW_DEBUG_CHEATS")) return;

	class'H7AdventureGridManager'.static.GetInstance().SetTeleportPhase(true);
}

exec function PlusSkillpoint()
{
	local H7AdventureHero hero;

	if(!class'H7OptionsManager'.static.GetInstance().GetSettingBool("SHOW_DEBUG_CHEATS")) return;

	hero = class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero();
	hero.SetSkillPoints(hero.GetSkillPoints()+1);
}

exec function PlusLevel()
{
	local int xp;
	local H7AdventureHero hero;

	if(!class'H7OptionsManager'.static.GetInstance().GetSettingBool("SHOW_DEBUG_CHEATS")) return;

	hero = class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero();
	xp = hero.GetNextLevelXp();
	
	AddXP(xp);
}

exec function PlusResources()
{
	if(!class'H7OptionsManager'.static.GetInstance().GetSettingBool("SHOW_DEBUG_CHEATS")) return;

	AddResourcesToLocalPlayer(100);
}

exec function BuildAll()
{
	if(!class'H7OptionsManager'.static.GetInstance().GetSettingBool("SHOW_DEBUG_CHEATS")) return;

	BuildAllBuildings();
}

exec function ToggleFog()
{
	local H7AdventureMapGridController gridController;
	local H7AdventureGridManager gridManager;

	if(!class'H7OptionsManager'.static.GetInstance().GetSettingBool("SHOW_DEBUG_CHEATS")) return;

	gridManager = class'H7AdventureGridManager'.static.GetInstance();

	if( gridManager == none ) { return; }
	gridManager.ToggleFogOfWarUsed();

	foreach gridManager.mGridList ( gridController )
	{
		gridController.GetFOWController().ExploreFog();
		gridController.GetFOWController().UpdateDrawing();
	}

	gridManager.GetCurrentGrid().GetFOWController().ExploreFog();

	if(class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() ) class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().ResetFog();
}

exec function DoubleArmy()
{
	local H7InstantCommandDoubleArmy command;

	if(!class'H7OptionsManager'.static.GetInstance().GetSettingBool("SHOW_DEBUG_CHEATS")) return;

	;

	command = new class'H7InstantCommandDoubleArmy';
	command.Init(class'H7AdventureController'.static.GetInstance().GetSelectedArmy());
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);
}

// console

exec function SetFog(bool val)
{
	if(GetFog() != val)
		ToggleFog();
}

function bool GetFog()
{
	return class'H7AdventureGridManager'.static.GetInstance().IsFogOfWarUsed();
}

exec function RevealFog()
{
	local H7AdventureMapGridController gridController;
	local H7AdventureGridManager gridManager;

	gridManager = class'H7AdventureGridManager'.static.GetInstance();

	foreach gridManager.mGridList ( gridController )
	{
		gridController.GetFOWController().RevealFog();
	}

	gridManager.GetCurrentGrid().GetFOWController().ExploreFog();

	if(class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() ) class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().ResetFog();
}

exec function SetWinAllCheat( bool val )
{
	local H7AdventureGridManager gridManager;

	gridManager = class'H7AdventureGridManager'.static.GetInstance();

	gridManager.SetWinAllCheat( val );
}

exec function SetTogglePlaneWithoutExploration( bool val )
{
	local H7AdventureGridManager gridManager;

	gridManager = class'H7AdventureGridManager'.static.GetInstance();

	gridManager.SetTogglePlaneWithoutExploration( val );
}

// OPTIONAL should probably be refactored to H7AdventureArmy.TeleportTo(H7AdventureMapCell)
function bool TeleportTo( H7AdventureMapCell targetCell, H7AdventureArmy currentArmy )
{
	local H7AdventureHero currentHero;
	local H7AdventureGridManager gridManager;
	local array<float> pathCosts;
	local int numOfWalkableCells;
	local array<H7AdventureMapCell> path;

	gridManager = class'H7AdventureGridManager'.static.GetInstance();
	if (currentArmy == None)
	{
		return false;
	}
	currentHero = currentArmy.GetHero();
	
	if( targetCell != none && !currentHero.IsMoving() )
	{
		if( !targetCell.IsBlocked() )
		{
			currentArmy.SetCell( targetCell );
			if (targetCell.GetVisitableSite() != None && H7Teleporter(targetCell.GetVisitableSite()) != None)
			{
				currentHero.SetRotation(Rotator( targetCell.GetLocation() - H7Teleporter(targetCell.GetVisitableSite()).GetTargetTeleporter().Location ) );
			}

			// set new path and show preview
			path = currentHero.GetCurrentPath();
			if( path.Length > 0 )
			{
				currentHero.SetCurrentPath( gridManager.GetPathfinder().GetPath( targetCell, path[path.Length-1], currentHero.GetPlayer(), currentHero.GetAdventureArmy().HasShip() ) );
				pathCosts = gridManager.GetPathfinder().GetPathCosts( currentHero.GetCurrentPath(), currentArmy.GetCell(), currentHero.GetCurrentMovementPoints(), numOfWalkableCells );
				if( !currentHero.GetPlayer().IsControlledByAI() )
				{
					gridManager.GetPathPreviewer().ShowPreview( currentHero.GetCurrentPath(), numOfWalkableCells, currentHero.GetCurrentMovementPoints(), currentHero.GetMovementPoints(), pathCosts );
				}
			}
			class'H7Camera'.static.GetInstance().SetFocusActor( currentHero, currentArmy.GetPlayerNumber(), true );
			return true;
		}
		else
		{
			;
			return false;
		}
	}

	return false;
}

exec function AddXP(int xp)
{
	local H7InstantCommandHeroAddXp command;
	command = new class'H7InstantCommandHeroAddXp';
	command.Init( class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero(), xp );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);
}

function H7AdventureArmy SpawnArmy( H7AdventureMapCell targetCell, int playerNumber, rotator spawnRotation, Actor template , optional bool isStartHero = false)
{
	local H7AdventureArmy tempAEditorArmy;
	local H7AdventureController advController;
	local H7EditorHero heroTemplate;

	advController = class'H7AdventureController'.static.GetInstance();

	

	if( targetCell != none)
	{
		if( !targetCell.IsBlocked() && template != none )
		{
			if (template.IsA('H7AdventureArmy'))
			{
				tempAEditorArmy = advController.Spawn( class'H7AdventureArmy',,,, spawnRotation, template );
			}
			else if(template.IsA('H7EditorHero'))
			{
				tempAEditorArmy = advController.Spawn( class'H7AdventureArmy',,,, spawnRotation );

				heroTemplate = H7EditorHero(template);
				tempAEditorArmy.SetHeroTemplate(heroTemplate);
				tempAEditorArmy.SetCreatureStackProperties(heroTemplate.GetHoHDefaultArmy());
			}
			else
			{
				return tempAEditorArmy;
			}
			
			tempAEditorArmy.SetStarterHero(isStartHero);
			tempAEditorArmy.Init( advController.GetPlayerByNumber( EPlayerNumber( playerNumber ) ), targetCell );
			tempAEditorArmy.SetCell(targetCell);
			advController.AddArmy( tempAEditorArmy );
			advController.UpdateHUD();
		}
		else
		{
			;
		}
	}
	else
	{
		;
	}

	return tempAEditorArmy;
}

exec function H7AdventureObject SpawnAdventureObject( int x, int y, optional H7AdventureObject objTemplate )
{
	local H7AdventureMapCell targetCell;
	local H7AdventureObject obj;

	targetCell = class'H7AdventureGridManager'.static.GetInstance().GetCell( x, y );

	if( targetCell != none )
	{
		if( !targetCell.IsBlocked() )//TODO check all cells
		{
			if (objTemplate == None)
			{
				objTemplate = mSpawnAdventureObjTemplate;
			}
			obj = class'H7AdventureController'.static.GetInstance().Spawn( objTemplate.Class,,,targetCell.GetLocation(),,objTemplate );
			obj.InitAdventureObject();
		}
		else
		{
			;
		}
	}
	else
	{
		;
	}

	return obj;
}

exec function UnlimitedMovement(bool isSelected)
{
	class'H7GUIGeneralProperties'.static.GetInstance().SetUnlimitedMovement(isSelected);
}

exec function UnlimitedMana(bool isSelected)
{
	class'H7GUIGeneralProperties'.static.GetInstance().SetUnlimitedMana(isSelected);
}

exec function UnlimitedBuilding(bool isSelected)
{
	class'H7GUIGeneralProperties'.static.GetInstance().SetUnlimitedBuilding(isSelected);
}

exec function AddResourcesToLocalPlayer(int addAmount)
{
	local H7Player          currentPlayer;
	local ResourceStockpile currentResource;
	local array<ResourceStockpile> allResources;
	local H7InstantCommandIncreaseResource command;
	
	currentPlayer = class'H7AdventureController'.static.GetInstance().GetLocalPlayer();
	allResources  = currentPlayer.GetResourceSet().GetAllResourcesAsArray();

	foreach allResources(currentResource)
	{
		command = new class'H7InstantCommandIncreaseResource';
		command.Init(currentPlayer, currentResource.Type.GetIDString(), addAmount);
		class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);
	}

	// last resource is currency, add 99 times more, so it has factor 100
	command = new class'H7InstantCommandIncreaseResource';
	command.Init(currentPlayer, currentResource.Type.GetIDString(), addAmount*99);
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);

	;
}

exec function BuildAllBuildings()
{
	local H7Player pl;
	local H7InstantCommandBuildAll command;

	pl = class'H7AdventureController'.static.GetInstance().GetLocalPlayer();

	;
	command = new class'H7InstantCommandBuildAll';
	command.Init(pl);
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);
}

function BuildAllBuildingsForPlayer(H7Player pl)
{
	local H7Town                    currentTown;
	local array<H7Town>             allTowns;
	local H7TownBuildingData        currentBuilding;
	local array<H7TownBuildingData> allBuildings;
	local H7TownBuildingData        townHall;

	allTowns = pl.GetTowns();

	foreach allTowns(currentTown)
	{
		allBuildings = currentTown.GetBuildingTree();
		foreach allBuildings(currentBuilding)
		{
			if(!currentBuilding.IsBuilt)
			{
				currentTown.BuildBuildingForced(currentBuilding.Building.GetName());
			}
			if( currentBuilding.Building.IsA( 'H7TownHall' ) )
			{
				townHall = currentBuilding;
			} 
		}

		// BuildBuildingForced prevents town/building auras from forced updates, so update AFTER building everything
		if(currentTown.CouldUpdateAuras())
		{
			currentTown.GetEntranceCell().GetGridOwner().GetAuraManager().UpdateAuras();
		}
		
		if( townHall.Building != none)
		{
			currentTown.SetMesh( H7TownHall( currentTown.GetBestBuilding( townHall ).Building ).GetMesh() );
		}
		else
		{
			class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("could not find townhall for" @ currentTown.GetName() @ currentTown.GetFaction().GetName(),MD_QA_LOG);;
		}
	}
}

exec function LockCamera()
{
	local H7Camera cam;
	cam = class'H7Camera'.static.GetInstance();
	cam.LockCamera(!cam.IsCameraLocked());
}


//////////////////////////////////////
// Mode Toggles
//////////////////////////////////////


function ToggleFlythrough(bool val, optional bool toggleHud = true, optional bool toggleCinematicView = true, optional bool toggleFog = true)
{
	SetFlythroughRunning(!mIsFlythroughRunning, toggleHud, toggleCinematicView, toggleFog);
}

function SetFlythroughRunning(bool val, optional bool toggleHud = true, optional bool toggleCinematic = true, optional bool toggleFog = true)
{
	super.SetFlythroughRunning(val, toggleHud, toggleCinematic, toggleFog);
	if(toggleFog)
	{
		SetFog( !val );
	}
}

function SetCinematicMode( bool bInCinematicMode, bool bHidePlayer, bool bAffectsHUD, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsButtons )
{
	local H7AdventureArmy army;

	// if now in cinematic mode
	if( bInCinematicMode )
	{
		if (bHidePlayer)
		{
			// hide all heroes
			foreach class'H7ReplicationInfo'.static.GetInstance().DynamicActors( class'H7AdventureArmy', army )
			{
				army.GetHero().SetHidden(true);
				army.GetHero().GetSelectionFX().HideFX();
				army.GetFlag().SetHidden(true);

				army.SetHidden(true);
			}
		}
	}
	else
	{
		// show all heroes
        foreach WorldInfo.DynamicActors(class'H7AdventureArmy', army)
        {
			army.GetHero().SetHidden(false);
			army.GetHero().GetSelectionFX().ShowFX();
			army.GetFlag().SetHidden(false);

			army.SetHidden(false);
        }
	}

	super.SetCinematicMode(bInCinematicMode, bHidePlayer, bAffectsHUD, bAffectsMovement, bAffectsTurning, bAffectsButtons);
}


//////////////////////////////////////
// MULTIPLAYER
//////////////////////////////////////

function SendUpdateArmyXP(H7AdventureArmy army)
{
	ServerUpdateArmyXP(army.GetHero().GetID(), army.GetHero().GetExperiencePoints());
}

reliable server function ServerUpdateArmyXP(int heroId, int exp)
{
	local H7AdventurePlayerController currentPlayerController;

	ForEach WorldInfo.AllControllers( class'H7AdventurePlayerController', currentPlayerController )
	{
		currentPlayerController.ClientUpdateArmyXP(heroId, exp);
	}
}

reliable client function ClientUpdateArmyXP(int heroId, int exp)
{
	local H7IEventManagingObject eventManageable;
	local H7AdventureHero hero;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable(heroId);
	hero = H7AdventureHero(eventManageable);

	if(exp > hero.GetExperiencePoints())
	{
		hero.AddXp(exp - hero.GetExperiencePoints());
	}
	else if(exp < hero.GetExperiencePoints())
	{
		SendUpdateArmyXP(hero.GetAdventureArmy());
	}
}

function SendAutoMergeRemainingPool(H7AdventureArmy army)
{
	ServerAutoMergeRemainingPool(army.GetHero().GetID());
}

reliable server function ServerAutoMergeRemainingPool(int heroId)
{
	local H7AdventurePlayerController currentPlayerController;

	ForEach WorldInfo.AllControllers( class'H7AdventurePlayerController', currentPlayerController )
	{
		currentPlayerController.ClientAutoMergeRemainingPool( heroId );
	}
}

reliable client function ClientAutoMergeRemainingPool(int heroId)
{
	local H7IEventManagingObject eventManageable;
	local H7AdventureArmy army;
	local array<H7BaseCreatureStack> poolStacks, armyStacks;
	local H7MergePool pool;
	local int i, j;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable(heroId);
	army = H7AdventureHero(eventManageable).GetAdventureArmy();

	pool = army.GetAMergePool();
	poolStacks = pool.PoolStacks;
	armyStacks = army.GetBaseCreatureStacks();

	;
	for(i=poolStacks.Length-1; i>=0; i--)
	{
		for(j=0; j<armyStacks.Length; j++)
		{
			if(poolStacks[i].GetStackType() == armyStacks[j].GetStackType() || armyStacks[j].GetStackType() == none)
			{
				class'H7BaseCreatureStack'.static.TransferCreatureStacksByArray( poolStacks, armyStacks, i, j);
				break;
			}
		}
	}

	army.SetBaseCreatureStacks(armyStacks);
	army.UpdateMergePool(pool.PoolKey,poolStacks);
}

function bool IsSimTurnCommandMode()
{
	return class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() && !IsSimTurnAIPlaying() && !class'H7AdventureHudCntl'.static.GetInstance().IsWaitingForReturningPlayersPopupOpen();
}

reliable client function SendPreInitStartAdventureMap()
{
	class'H7ReplicationInfo'.static.GetInstance().CreateSynchRNG();
	class'H7ReplicationInfo'.static.PrintLogMessage("SendPreInitStartAdventureMap" @ self, 0);;
}

reliable client function SendInitStartAdventureMap()
{
	class'H7ReplicationInfo'.static.GetInstance().CreateAdventureController();
	
	if(class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() || class'H7AdventureController'.static.GetInstance().IsHotSeat())
	{
		class'H7ReplicationInfo'.static.GetInstance().InitMPTurnGUI();
	}
	class'H7ReplicationInfo'.static.PrintLogMessage("SendInitStartAdventureMap" @ self, 0);;
}

reliable server function ServerPauseTurnTimer( bool paused )
{
	local H7AdventurePlayerController currentPlayerController;

	ForEach WorldInfo.AllControllers( class'H7AdventurePlayerController', currentPlayerController )
	{
		currentPlayerController.ClientPauseTurnTimer( paused );
	}
}

reliable client function ClientPauseTurnTimer( bool paused )
{
	class'H7AdventureController'.static.GetInstance().SetTurnTimerPaused(paused);
}

function SendUpdateHeroPosition( int heroId, int cellId )
{
	local H7AdventurePlayerController currentPlayerController;

	ForEach WorldInfo.AllControllers( class'H7AdventurePlayerController', currentPlayerController )
	{
		if(currentPlayerController != self)
		{
			currentPlayerController.UpdateHeroPosition( heroId, cellId );
		}
	}
}

reliable client function UpdateHeroPosition( int heroId, int cellId )
{
	local H7IEventManagingObject eventManageable;
	local H7AdventureHero hero;
	local H7AdventureMapCell cell;
	local H7AdventureArmy army;
	local int numOfWalkableCells;
	local H7AdventureGridManager gridManager;
	local array<float> pathCosts;
	local array<H7AdventureMapCell> path;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( heroId );
	hero = H7AdventureHero( eventManageable );
	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( cellId );
	cell = H7AdventureMapCell( eventManageable );
	gridManager = class'H7AdventureGridManager'.static.GetInstance();
	army = hero.GetAdventureArmy();

	if( cell != none )
	{
		if( !cell.IsBlocked() )
		{
			army.SetCell( cell );
			// set new path and show preview
			if(hero.GetPlayer().IsControlledByLocalPlayer() && class'H7AdventureController'.static.GetInstance().GetSelectedArmy() == army)
			{
				path = hero.GetCurrentPath();
				if( path.Length > 0 )
				{
					hero.SetCurrentPath( gridManager.GetPathfinder().GetPath( cell, path[path.Length-1], hero.GetPlayer(), hero.GetAdventureArmy().HasShip() ) );
					pathCosts = gridManager.GetPathfinder().GetPathCosts( hero.GetCurrentPath(), army.GetCell(), hero.GetCurrentMovementPoints(), numOfWalkableCells );
					gridManager.GetPathPreviewer().ShowPreview( hero.GetCurrentPath(), numOfWalkableCells, hero.GetCurrentMovementPoints(), hero.GetMovementPoints(), pathCosts );
				}
			}
		}
	}
}

reliable server function SendTradeFinished( int HeroId )
{
	local H7AdventureHero hero;
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( HeroId );
	hero = H7AdventureHero( eventManageable );

	class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager().RemoveOngoingTrade( hero );
	class'H7ReplicationInfo'.static.PrintLogMessage(self @  "SendTradeFinished HeroId:" @ HeroId, 0);;
}

reliable server function SendInteractionFinished( int HeroId )
{
	local H7AdventureHero hero;
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( HeroId );
	hero = H7AdventureHero( eventManageable );

	class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager().RemoveOngoingInteraction( hero );
	class'H7ReplicationInfo'.static.PrintLogMessage(self @  "SendInteractionFinished HeroId:" @ HeroId, 0);;
}

reliable server function RequestCancelEndTurn()
{
	if(GetPlayerReplicationInfo().IsTurnFinished())
	{
		GetPlayerReplicationInfo().ResetTurnFinished();
		class'H7ReplicationInfo'.static.GetInstance().DataChanged();
		ResetEndTurn();
	}
}

reliable client function ResetEndTurn()
{
	GetAdventureHud().GetAdventureHudCntl().GetCommandPanel().SetEndSimTurn(false);
}

// request to cancel a trade that another player is doing with one of the armies of this player
reliable client function SendRequestCancelTrade( int sourceHeroId )
{
	local H7AdventureHero sourceHero;
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( sourceHeroId );
	sourceHero = H7AdventureHero( eventManageable );

	mHeroIdCancelTradePopUp = sourceHeroId;
	GetHUD().GetRequestPopupCntl().GetRequestPopup().YesNoPopup( 
		Repl( class'H7Loca'.static.LocalizeSave("PU_HERO_TRADING","H7Popup") , "%hero" , sourceHero.GetName())
		, "YES", "NO", PopUpAnswerCancelTrade, PopUpAnswerNotCancelTrade );

	class'H7ReplicationInfo'.static.PrintLogMessage(self @ "SendRequestCancelTrade" @ "sourceHeroId:" @ sourceHeroId, 0);;
}

protected function PopUpAnswerCancelTrade()
{
	SendAnswerCancelTrade( true, mHeroIdCancelTradePopUp );
}

protected function PopUpAnswerNotCancelTrade()
{
	SetIsUnrealInputAllowed( true );
	SetCommandRequested( false );
	SendAnswerCancelTrade( false, mHeroIdCancelTradePopUp );
}

reliable server function SendAnswerCancelTrade( bool doCancelTrade, int heroId )
{
	class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager().CancelTrade( doCancelTrade, heroId );

	class'H7ReplicationInfo'.static.PrintLogMessage(self @ "SendAnswerCancelTrade" @ "doCancelTrade:" @ doCancelTrade @ "heroId:" @ heroId, 0);;
}

reliable client function SendCancelTrade()
{
	class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetHeroTradeWindowCntl().Closed();
	GetHUD().GetRequestPopupCntl().GetRequestPopup().OKPopup( "PU_HERO_TRADE_FINISHED", "OK", none );

	class'H7ReplicationInfo'.static.PrintLogMessage(self @ "SendCancelTrade", 0);;
}

reliable server function SendSimTurnAnswerStartCombat( ESimTurnStartCombatAnswer answer, int heroId )
{
	class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager().HandleAnswerStartCombat( answer, heroId );

	class'H7ReplicationInfo'.static.PrintLogMessage(self @ "SendSimTurnAnswerStartCombat" @ "answer:" @ answer @ "heroId:" @ heroId, 0);;
}

reliable server function SendRetreatCancelled( int heroId )
{
	class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager().HandleRetreatCancelled( heroId );
}

reliable client function SendTargetIsRetreating()
{
	class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetCombatPopUpCntl().ClosePopup();
	GetHUD().SetHUDMode( HM_WAITING_OTHER_PLAYER_RETREAT, HM_WAITING_OTHER_PLAYER_ANSWER );
}

reliable client function SendRetreatConceded( int heroId )
{
	local H7AdventureHero sourceHero;
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( heroId );
	sourceHero = H7AdventureHero( eventManageable );

	GetHUD().SetHUDMode( HM_NORMAL, HM_WAITING_OTHER_PLAYER_ANSWER );
	// select the hero that needs to retreat
	class'H7AdventureController'.static.GetInstance().SelectArmy( sourceHero.GetAdventureArmy() );
	class'H7AdventureController'.static.GetInstance().ResetCurrentRetreatTimer();
	mRetreatingArmy = sourceHero.GetAdventureArmy();
	GetHUD().GetRequestPopupCntl().GetRequestPopup().OKPopup( Repl(class'H7Loca'.static.LocalizeSave("PU_HERO_RETREAT","H7Popup"),"%hero",sourceHero.GetName()), "OK", none );
}

reliable client function SendStartCombatFinished( bool isRetreatFinished, bool isCombatCanceled, bool isNormalCombatAboutToBegin )
{
	if( isRetreatFinished )
	{
		if( GetHUD().GetHUDMode() == HM_WAITING_OTHER_PLAYER_RETREAT )
		{
			GetHUD().SetHUDMode( HM_NORMAL, HM_WAITING_OTHER_PLAYER_RETREAT );
		}

		// reset the retreating army
		if( class'H7AdventurePlayerController'.static.GetAdventurePlayerController().GetRetreatingArmy() != none )
		{
			class'H7AdventurePlayerController'.static.GetAdventurePlayerController().SetRetreatingArmy( none );
		}

		class'H7AdventureController'.static.GetInstance().ClearRetreatTimer();
	}
	else if( isCombatCanceled )
	{
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetCombatPopUpCntl().ClosePopup();
		GetHUD().SetHUDMode( HM_NORMAL, HM_WAITING_OTHER_PLAYER_ANSWER );
		GetHUD().GetRequestPopupCntl().GetRequestPopup().OKPopup( "PU_ATTACK_CANCELLED", "OK", none );
	}
	else
	{
		GetHUD().SetHUDMode( HM_NORMAL, HM_WAITING_OTHER_PLAYER_ANSWER );
	}

	if( isNormalCombatAboutToBegin )
	{
		mIsNormalCombatAboutToBegin = isNormalCombatAboutToBegin;
	}
}

function CheckOutOfSynch()
{
	local H7ReplicationInfo replInfo;
	local H7AdventureController adventureController;
	adventureController = class'H7AdventureController'.static.GetInstance();

	replInfo = class'H7ReplicationInfo'.static.GetInstance();
	ServerCheckOutOfSynch( replInfo.GetUnitActionsCounter(), replInfo.GetSynchRNG().GetCounter(), replInfo.GetIdCounter(), adventureController.GetTotalUnitsCount(), adventureController.GetTotalResCount(), class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() );
}

exec function PerformAutoAI(bool IsActive, bool AllowQuickCombat = true, bool SkipMove = false)
{
	local H7AdventureController advCntl;
	ConsoleCommand("set H7Player mIsControlledByAI " $ IsActive );
	ConsoleCommand("stat fps");
	ConsoleCommand("stat unit");
	advCntl = class'H7AdventureController'.static.GetInstance();
	advCntl.SetAIAllowQuickCombat( (!IsActive) ? false : AllowQuickCombat );
	advCntl.SetAutomatedTestingAI( IsActive );
	advCntl.SetSkipMove( (!IsActive) ? false : SkipMove );
	advCntl.GetAI().GetSensors().ResetCalc();
	if( IsActive )
	{
		advCntl.UpdateTownsAI( advCntl.GetCurrentPlayer() );
	}
}


