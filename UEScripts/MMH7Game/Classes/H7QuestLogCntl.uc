//=============================================================================
// H7RequestPopupCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7QuestLogCntl extends H7FlashMoviePopupCntl;

var protected H7GFxQuestLog mQuestLog;

function        H7GFxQuestLog    GetQuestLog()  { return mQuestLog; }
function        H7GFxUIContainer GetPopup()     { return mQuestLog; }
static function H7QuestLogCntl   GetInstance()  { return class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetQuestLogCntl(); }

function bool Initialize() 
{
	// Start playing the movie
    Super.Start();
	// Initialize all objects in the movie
    AdvanceDebug(0);
	
	mQuestLog = H7GFxQuestLog(mRootMC.GetObject("aQuestLog", class'H7GFxQuestLog'));
	mQuestLog.SetVisibleSave(false);

	Super.Initialize();
	return true;
}

function bool OpenPopup()
{
	if(CanOpenPopup())
	{
		mQuestLog.Update();
		GetHUD().GetSpellbookCntl().GetQuickBar().SetVisibleSave(false);
		// special case when opening questlog in hallofheroesskillwheel
		if(H7AdventureHud(GetHUD()).GetSkillwheelCntl().GetPopup().IsVisible() && H7AdventureHud(GetHUD()).GetSkillwheelCntl().GetHallOfHeroesMode())
		{
			H7AdventureHud(GetHUD()).GetSkillwheelCntl().ClosePopup();
			H7AdventureHud(GetHUD()).GetHallOfHerosCntl().KillPopUp();
		}
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetTownList().SetVisibleSave(false); // because minimap moves
	}

	return super.OpenPopup();
}

// when clicking on the sidebar
function bool OpenPopupWithPreselect(H7SeqAct_Quest_NewNode quest)
{
	if(CanOpenPopup())
	{
		mQuestLog.Update(quest);
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetTownList().SetVisibleSave(false); // because minimap moves
	}
	return super.OpenPopup();
}
// cause by GetMinimapDummyBounds()
function SetMinimapDummyBounds(float dummyX,float dummyY,float dummyWidth,float dummyHeight)
{
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().SetQuestLogMode(true, dummyX, dummyY, dummyWidth, dummyHeight);
}

function TrackOnMinimap( string questID, bool tracked )
{
	;

	class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetQuestController().GetQuestByID(questID).SetTracked(tracked);

	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().EditQuestTrackStatus(questId, tracked);
}

function ClosePopup()
{
	GetHUD().GetSpellbookCntl().GetQuickBar().SetVisibleSave(true);
	class'H7AdventureHudCntl'.static.GetInstance().GetNoteBar().SelectMessage(-1);
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().SetQuestLogMode(false, 0.0f, 0.0f, 0.0f, 0.0f);

	if(class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() && GetHUD().GetHUDMode() == HM_NORMAL)
	{
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetTownList().SetVisibleSave(true);
	}
	//class'H7MessageSystem'.static.GetInstance().DeleteMessagesByAction(MA_OPEN_QUESTLOG);
	super.ClosePopup();
}

function QuestSelected(String questID)
{
	local array<H7SeqAct_Quest_NewNode> quests;
	local H7SeqAct_Quest_NewNode quest;
	local H7Message message;
	
	;

	quests = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetQuestController().GetActiveQuestNodes();
	foreach quests(quest)
	{
		if(quest.GetID() == questID)
		{
			;
			message = class'H7MessageSystem'.static.GetInstance().GetMessageByReference(quest);
			if(message != none)
			{
				class'H7GUIOverlaySystemCntl'.static.GetInstance().GetSideBar().SelectMessage(message.ID);
			}
		}
	}
}

function Closed()
{
	ClosePopup();
}


