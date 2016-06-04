//=============================================================================
// H7TreasureHuntCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7TreasureHuntCntl extends H7FlashMoviePopupCntl;

var protected H7GFxTreasureHunt mTreasureHuntWindow;

var protected H7HeroEventParam mParams;
var protected Actor mInstigator;
var protected bool mFadeWhenOpening;

function        H7GFxTreasureHunt   GetTreasureHuntPopup()  { return mTreasureHuntWindow; }
function        H7GFxUIContainer    GetPopup()              { return mTreasureHuntWindow; }
static function H7TreasureHuntCntl  GetInstance()           { return class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTreasureHuntCntl(); }

function bool Initialize() 
{
	;
	// Start playing the movie
    Super.Start();
	// Initialize all objects in the movie
    AdvanceDebug(0);

	mTreasureHuntWindow = H7GFxTreasureHunt(mRootMC.GetObject("aTreasureHuntWindow", class'H7GFxTreasureHunt'));
	mTreasureHuntWindow.SetVisibleSave(false);
	
	Super.Initialize();
	return true;
}

function OpenPopupWithFade()
{
	mFadeWhenOpening = true;
	OpenPopup();
}

function bool OpenPopup()
{
	/*if(!mTreasureHuntWindow.IsMapReady())
	{
		mTreasureHuntWindow.CreateMap();
		GetHUD().SetTimer(0.1,false,'OpenPopup',self);
		return false;
	}*/

	mTreasureHuntWindow.Update(mFadeWhenOpening);

	SetRealmButton(true);
	H7AdventureHud(GetHUD()).GetAdventureHudCntl().GetTopBar().SetVisibleSave(false);
	H7AdventureHud(GetHUD()).GetAdventureHudCntl().GetTownList().SetVisibleSave(false);
	H7AdventureHud(GetHUD()).GetAdventureHudCntl().GetCommandPanel().ShowExitIcon(true);

	return super.OpenPopup();
}

function ClosePopup()
{
	mFadeWhenOpening = false;
	mTreasureHuntWindow.StopVideo();

	SetRealmButton(false);
	H7AdventureHud(GetHUD()).GetAdventureHudCntl().GetTopBar().SetVisibleSave(true);
	if( GetHUD().GetHUDMode() == HM_NORMAL )
	{
		H7AdventureHud(GetHUD()).GetAdventureHudCntl().GetTownList().SetVisibleSave(true);
	}
	H7AdventureHud(GetHUD()).GetAdventureHudCntl().GetCommandPanel().ShowExitIcon(false);

	super.ClosePopup();

	class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetFaction().DelPuzzle1();
	class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetFaction().DelPuzzle2();
	class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetFaction().DelPuzzle3();
	class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetFaction().DelPuzzle4();
	class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetFaction().DelPuzzle5();
	class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetFaction().DelPuzzle6();
	class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetFaction().DelPuzzle7();
	class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetFaction().DelPuzzle8();
	
	class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter(); // cause story conditions to recheck, because they were blocked by this popup
	TriggerQueuedEvent();
}

// sets the select highlight of the button to true/false
function SetRealmButton(bool val)
{
	local GFxObject minimapExt;
	minimapExt = class'H7AdventureHud'.static.GetAdventureHud().GetAdventureHudCntl().GetMinimap().GetObject("mMinimapExtension");
	minimapExt.ActionScriptVoid("SetRealmButton");
}

function TriggerWhenClosed(H7HeroEventParam params,Actor instigator)
{
	mParams = params;
	mInstigator = instigator;
}

function TriggerQueuedEvent()
{
	if(mInstigator != none)
	{
		class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_VisitNeutralBuilding', mParams, mInstigator);
	}
	mInstigator = none;
}

