//=============================================================================
// H7PWindowWeeklyCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7WindowWeeklyCntl extends H7FlashMovieBlockPopupCntl;

var protected H7GFxWindowWeeklyEffect mWindowWeeklyEffect;
var protected GFxCLIKWidget mBtnOk;

function H7GFxWindowWeeklyEffect GetWindowWeeklyEffect() { return mWindowWeeklyEffect; }
function        H7GFxUIContainer   GetPopup()          {return mWindowWeeklyEffect; }

static function H7WindowWeeklyCntl GetInstance() { return class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetWindowWeeklyCntl(); }

function bool Initialize() 
{
	;
	// Start playing the movie
    Super.Start();
	// Initialize all objects in the movie
    AdvanceDebug(0);

	mWindowWeeklyEffect = H7GFxWindowWeeklyEffect(mRootMC.GetObject("aWindowWeeklyEffect", class'H7GFxWindowWeeklyEffect'));
	mWindowWeeklyEffect.SetVisibleSave(false);
	
	mBtnOk = GFxCLIKWidget(mWindowWeeklyEffect.GetObject("mBtnOk", class'GFxCLIKWidget'));
	//mBtnOk.AddEventListener('CLIK_click', OKButtonClick);

	Super.Initialize();
	return true;
}

function InitWindowKeyBinds()
{
	CreatePopupKeybind('Enter',"WeeklyConfirm",ClosePopup,'SpaceBar');
	
	super.InitWindowKeyBinds();
}

function setData(String weeklyEffectTitle, String weeklyEffectDescription)
{
	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("NEW_WEEK");

	if(!class'H7GUIGeneralProperties'.static.GetInstance().GetOptionWeeklyPopup()) return;

	mWindowWeeklyEffect.Update(weeklyEffectTitle, weeklyEffectDescription);

	OpenPopup();
}

function bool OpenPopup()
{
	return super.OpenPopup();
}

function SetShowInFuture(bool val)
{
	;
	class'H7GUIGeneralProperties'.static.GetInstance().SetOptionWeeklyPopup(val);
	class'H7GUIGeneralProperties'.static.GetInstance().SaveConfig();
}

function OKButtonClicked()
{
	ClosePopup();
}

function ClosePopup()
{
	super.ClosePopup();

	class'H7AdventureController'.static.GetInstance().TriggerStartOfTurnEvents();
}



