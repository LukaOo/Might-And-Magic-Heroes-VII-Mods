//=============================================================================
// H7ControllerManager
//=============================================================================
//
// Contains the reference of the controllers that are singletons
// 
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7ControllerManager extends Actor 
	native;

// Base
var protected H7BaseGameController			mBaseGameController;

// Council
var protected H7CouncilManager              mCouncilManager;

// Adventure
var protected H7AdventureController			mAdventureController;
var protected H7CameraActionController      mCameraActionController;
var protected H7AdventureGridManager        mAdventureGridManager;
var protected H7ScriptingController			mScriptingController;

// Combat
var protected H7CombatController		mCombatController;
var protected H7CombatMapGridController	mCombatGridController;

// GUI
var protected H7MainMenuController              mMainMenuController;
var protected H7CombatMapStatusBarController	mCombatBarController;
var protected H7CreatureStackPlateController	mCreaturePlateController;
var protected H7FCTController					mFCTController;
var protected H7GUISoundPlayer					mGUISoundPlayer;
var protected H7SoundController     			mSoundController;

// properties Get/Set methods
// ==========================
function SetBaseGameController( H7BaseGameController newController ) { if( mBaseGameController == none ) { mBaseGameController = newController; } }
function H7BaseGameController GetBaseGameController() { return mBaseGameController; }

function SetAdventureController( H7AdventureController newController ) { mAdventureController = newController; }
function H7AdventureController GetAdventureController() { return mAdventureController; }

function SetCameraActionController( H7CameraActionController newController ) { mCameraActionController = newController; }
function H7CameraActionController GetCameraActionController() { return mCameraActionController; }

function SetCombatController( H7CombatController newController ) { mCombatController = newController; }
function H7CombatController GetCombatController() { return mCombatController; }

function SetCombatGridController( H7CombatMapGridController newController ) { mCombatGridController = newController; }
function H7CombatMapGridController GetCombatGridController() { return mCombatGridController; }

function SetMainMenuController( H7MainMenuController newController ) { mMainMenuController = newController; }
function H7MainMenuController GetMainMenuController() { return mMainMenuController; }

function SetCombatBarController( H7CombatMapStatusBarController newController ) { mCombatBarController = newController; }
function H7CombatMapStatusBarController GetCombatBarController() { return mCombatBarController; }

function SetCreaturePlateController( H7CreatureStackPlateController newController ) { mCreaturePlateController = newController; }
function H7CreatureStackPlateController GetCreaturePlateController() { return mCreaturePlateController; }

function SetFCTController( H7FCTController newController ) { mFCTController = newController; }
function H7FCTController GetFCTController() { return mFCTController; }

function SetGUISoundPlayer( H7GUISoundPlayer newController ) { mGUISoundPlayer = newController; }
function H7GUISoundPlayer GetGUISoundPlayer() { return mGUISoundPlayer; }

function SetSoundController( H7SoundController newController ) { mSoundController = newController; }
function H7SoundController GetSoundController() { return mSoundController; }

function SetAdventureGridManager( H7AdventureGridManager newController ) { mAdventureGridManager = newController; }
function H7AdventureGridManager GetAdventureGridManager() { return mAdventureGridManager; }

function SetScriptingController( H7ScriptingController newController ) { mScriptingController = newController; }
function H7ScriptingController GetScriptingController() { return mScriptingController; }

function SetCouncilManager( H7CouncilManager newController ) { mCouncilManager = newController; }
function H7CouncilManager GetCouncilManager() { return mCouncilManager; }


simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	SetTimer(1.f,false,'InitializeDelayed');
}

function InitializeDelayed()
{
	if(mSoundController.GetSoundManager() != none)
	{
		if(!class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame())
		{
			mSoundController.Initialize();
		}
		else
		{
			mSoundController.Initialize(true);
		}
	}
	else
	{
		SetTimer(1.f,false,'InitializeDelayed');
	}
}

