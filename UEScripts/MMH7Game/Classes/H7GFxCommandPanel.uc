//=============================================================================
// H7GFxCommandPanel
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7GFxCommandPanel extends H7GFxUIContainer;

var protected bool mTownMode;
var protected bool mRelevantPopupIsOpen;
var protected bool mEndSimTurn;

var private int guiDay, guiMonth, guiYear;

function bool GetTownMode() { return mTownMode; }
function bool GetEndSimTurn() {return mEndSimTurn; }

function UpdateLoca()
{
	ActionScriptVoid("UpdateLoca");
}

function SetTownMode(bool val)
{
	mTownMode = val;
	ActionScriptVoid("SetTownMode");
}

function SetEndSimTurn(bool val)
{
	mEndSimTurn = val;
	ActionScriptVoid("SetEndSimTurn");
}

function SetCampaignMode(bool val)
{
	ActionScriptVoid("SetCampaignMode");
}

function bool IsCommandPanelRelevantPopupOpen()
{
	return mRelevantPopupIsOpen;
}

// set center button icon and highlight of the other buttons
// popup closed or popup opened
function UpdateSelectState(H7FlashMoviePopupCntl popup,bool opened)
{
	if(!opened)
	{
		SetCurrentOpenPopup(0);
		SetRelevantPopupOpen(false);
		if(class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().IsInAnyScreen())
		{
			ShowExitIcon(true);
		}
		else
		{
			ShowExitIcon(false);
		}
		return;
	}
	else
		ShowExitIcon(true);

	if(popup.IsA('H7SkillwheelCntl'))
	{
		SetCurrentOpenPopup(2);
		SetRelevantPopupOpen(true);
		ShowExitIcon(true);
	}
	else if(popup.IsA('H7HeroWindowCntl'))
	{
		SetCurrentOpenPopup(1);
		SetRelevantPopupOpen(true);
		ShowExitIcon(true);
	}
	else if(popup.IsA('H7SpellbookCntl'))
	{
		SetCurrentOpenPopup(3);
		SetRelevantPopupOpen(true);
		ShowExitIcon(true);
	}
	else if(popup.IsA('H7QuestLogCntl'))
	{
		SetCurrentOpenPopup(4);
		SetRelevantPopupOpen(true);
		ShowExitIcon(true);
	}
	else if(popup.IsA('H7PauseMenuCntl') || popup.IsA('H7OptionsMenuCntl'))
	{
		SetCurrentOpenPopup(5);
		SetRelevantPopupOpen(true);
		ShowExitIcon(true);
	}
}

function EnableHeroButtons(bool val)
{
	ActionScriptVoid("EnableHeroButtons");
}

function SetCurrentOpenPopup(int commandPanelPopupIndex)
{
	ActionScriptVoid("SetCurrentOpenPopup");
}

function ShowExitIcon(bool val) // if false show turn end icon
{
	ActionScriptVoid("ShowExitIcon");
}

function SetMyTurn(bool val)
{
	ActionScriptVoid("SetMyTurn");
}

function SetRelevantPopupOpen(bool val)
{
	mRelevantPopupIsOpen = val;
}

function UpdateDate(int day, int week, int month, int year, string weekName, string weekDescription)
{
	ActionScriptVoid("UpdateDate");
}
