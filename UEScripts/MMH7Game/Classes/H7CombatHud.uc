//=============================================================================
// H7CombatHud
//
// Handles the Combat-HUD. 
// 
// The hud consist of multiple flash-movies (=GFXMoviePlayer) on top of each other
//
// High level class which is accessed by other modules to inform the HUD about 
// changes in the game that need to be visualized in the HUD.
//
// Low level stuff like position calculations, access to flash stuff, etc. is
// delegated to H7CombatHudController or other low level controllers.
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CombatHud extends H7Hud;

// List of Flash Movies in this HUD:
var protected H7CombatHudCntl mCombatHudCntl;
var protected H7CombatUnitInfoCntl mUnitInfoWindowCntl;		  
var protected H7SpectatorHUDCntl mSpectatorHUDCntl;
var protected H7CombatMapTestCntl mTestMovie;	

var protected H7CreatureStackPlateController mCreatureStackPlateController;
var protected H7FCTController mCombatMapFCTController;
var protected H7CombatMapStatusBarController mCombatMapStatusBarController;

// variables used by DelayedUpdateFromCombatMap
var protected int mDelayedXPWinner;
var protected int mDelayedXPLoser;
var protected H7CombatArmy mDelayedarmy;
var protected bool mDelayedfled;
var protected bool mDelayedsurrendered;
var protected int mDelayedpaidGold;
var protected bool mIsPlayerVictory;

var protected bool mIsInitialised;

static function H7CombatHud GetInstance() { return class'H7PlayerController'.static.GetPlayerController().GetCombatMapHud(); }
static function H7CombatHud GetCombatHud() {  return class'H7PlayerController'.static.GetPlayerController().GetCombatMapHud(); }

function H7CombatHudCntl				GetCombatHudCntl()			{	return mCombatHudCntl;	}
function H7SpectatorHUDCntl             GetSpectatorHUDCntl()       {   return mSpectatorHUDCntl; }
function H7CombatUnitInfoCntl		    GetUnitInfoCntl()		    {	return mUnitInfoWindowCntl;		}
function H7MouseCntl	                GetMouseCntl()        	    { 	return mMouseCntl;	    }

simulated function Init()
{
	if(mIsInitialised)
	{
		return;
	}

	mIsInitialised = true;

	PreInit();
	
	InitCombatHud();
	
	mDelayInit = false;

	PostInit();
}

simulated function InitCombatHud(optional bool fromAdventure=false)
{
	//Create a STGFxHUD for HudMovie
	mCombatHudCntl = new class'H7CombatHudCntl';
	mUnitInfoWindowCntl = new class'H7CombatUnitInfoCntl';
	mSpectatorHUDCntl = new class'H7SpectatorHUDCntl';
	
	// logs
	if(!fromAdventure) mMovies.AddItem(mLogSystemCntl);

	// ---- hud ------
	mMovies.AddItem(mCombatHudCntl);

	// popups (fake, is inside hud.fla)
	mMovies.AddItem(mUnitInfoWindowCntl);

	// bg
	if(!fromAdventure) mMovies.AddItem(mBackgroundImageCntl);

	// popups
	if(!fromAdventure) mMovies.AddItem(mSpellbookCntl);

	// spectatorHUD
	mMovies.AddItem(mSpectatorHUDCntl);

}

function ChildCompleted()
{
}

function Hide()
{
	mCombatHudCntl.HideCreatureAbilityButtons();// mCreatureAbilityButtonPanelCntl.Hide();
	mCreatureStackPlateController.Hide();
}

// because we are going back to adventuremap
// or load a background
// or end the game
// or start in adventure map
function SetCombatHudVisible(bool visible,optional bool leaveLogAlone=false) 
{
	mCombatHudCntl.SetCombatHudCntlVisible(visible);
	mCombatHudCntl.GetInitiativeList().Reset();
	
	if(visible)
	{
		mCombatHudCntl.StartAdvance();
	}
	else
	{
		SetFrameTimer(2,mCombatHudCntl.StopAdvance);
	}
	
	if(!leaveLogAlone)
	{
		mLogSystemCntl.SetVisible(visible);
	}

	if(!visible) // hide it when hud is off, but don't show it when hud is on
	{
		mUnitInfoWindowCntl.GetUnitInfoAttacker().SetVisibleSave(false);
		mUnitInfoWindowCntl.GetUnitInfoDefender().SetVisibleSave(false);
	}

	if(!visible && mCreatureStackPlateController != none)
	{
		mCreatureStackPlateController.DeleteAllStackPlates();
	}

	if(!visible && class'H7CombatMapStatusBarController'.static.GetInstance() != none)
	{
		class'H7CombatMapStatusBarController'.static.GetInstance().DeleteAllBars();
	}
}

//Called every tick the HUD should be updated, only function where Canvas exists
event PostRender()
{
	Super.PostRender();

	if(mCombatMapFCTController != none)
	{
		mCombatMapFCTController.Render(Canvas);
	}
	else
	{
		mCombatMapFCTController = class'H7FCTController'.static.GetInstance();
	}

	if(mCombatMapStatusBarController != none)
	{
		mCombatMapStatusBarController.Update(Canvas);
	}
	else
	{
		mCombatMapStatusBarController = class'H7CombatMapStatusBarController'.static.GetInstance();
	}

	if(mCreatureStackPlateController != none)
	{
		mCreatureStackPlateController.Update(Canvas);
	}
	else
	{
		mCreatureStackPlateController = class'H7CreatureStackPlateController'.static.GetInstance();
	}

	if( class'H7CombatController'.static.GetInstance() != none && class'H7CombatController'.static.GetInstance().GetCoverManager() != none )
	{
		class'H7CombatController'.static.GetInstance().GetCoverManager().RenderFX( Canvas );
	}

	


}

function ResolutionChanged(Vector2D newRes)
{
	local Vector2d newResFlash;
	
	super.ResolutionChanged(newRes);

	;
	
	newResFlash = mCombatHudCntl.UnrealPixels2FlashPixels(newRes);

	;

	mCombatHudCntl.GetInitiativeList().Realign(newResFlash.x,newResFlash.y);
	mCombatHudCntl.GetCreatureAbilityButtonPanel().Realign(newResFlash.x,newResFlash.y);
	mCombatHudCntl.GetCombatMenu().Realign(newResFlash.x,newResFlash.y);
	mCombatHudCntl.GetHeroPanel().Realign(newResFlash.x,newResFlash.y);
	mCombatHudCntl.GetTacticsBanner().Realign(newResFlash.x,newResFlash.y);
	mCombatHudCntl.GetDeploymentBar().Realign(newResFlash.x,newResFlash.y);
	
	mLogSystemCntl.GetBorderBlack().Realign(newResFlash.x,newResFlash.y);

}

// prepared screen is showing after victory cam with ShowPreparedScreen
function PrepareVictoryOrDefeatScreen( H7CombatArmy army, bool isVictory, int XPWinner, int XPLoser, optional bool isVictoryFlee = false, optional int victorySurrenderGold = -1 )
{ 
	GetUnitInfoCntl().CloseAll();
	Hide();

	mDelayedXPWinner = XPWinner;
	mDelayedXPLoser = XPLoser;
	mDelayedarmy = army;
	mDelayedfled = false;
	mDelayedsurrendered = false;
	mDelayedpaidGold = 0;
	mIsPlayerVictory = isVictory;

	//ShowPreparedScreen();
}

// prepared screen is showing after victory cam with ShowPreparedScreen
function PrepareFleeOrSurrenderScreen( H7CombatArmy army, bool isFlee, int XPWinner, int XPLoser, optional int paidGold )
{ 
	GetUnitInfoCntl().CloseAll();
	Hide();

	mDelayedXPWinner = XPWinner;
	mDelayedXPLoser = XPLoser;
	mDelayedarmy = army;
	mDelayedfled = isFlee;
	mDelayedsurrendered = !isFlee;
	mDelayedpaidGold = paidGold;
	mIsPlayerVictory = false;
	//ShowPreparedScreen();
}

function ShowPreparedScreen()
{
	if( mIsPlayerVictory )
	{
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("VICTORY_WINDOW_SHOWN");
	}

	if( !mIsPlayerVictory )
	{
		if( mDelayedfled || mDelayedsurrendered )
		{
			class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("FLEE_SURRENDER_WINDOW_SHOWN");
		}
		else
		{
			class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("DEFEAT_WINDOW_SHOWN");
		}
	}

	// DO NOT REMOVE THIS !!!! ITS FOR AUTOMATED TESTING!!!
	;	
	class'H7PlayerController'.static.GetPlayerController().GetHud().GetCombatPopUpCntl().UpdateFromCombatMap(mDelayedXPWinner, mDelayedXPLoser, mDelayedarmy, mDelayedfled, mDelayedsurrendered, mDelayedpaidGold);
}



































































