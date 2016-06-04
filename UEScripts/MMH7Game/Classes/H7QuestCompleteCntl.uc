//=============================================================================
// H7RequestPopupCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7QuestCompleteCntl extends H7FlashMovieBlockPopupCntl implements (H7IQueueable);

var protected H7GFxQuestComplete mQuestCompletePopup;
var protected H7SeqAct_Quest_NewNode mQueuedQuest;

public delegate mOnRewardAccepted();

function        H7GFxQuestComplete    GetQuestCompletePopup()  { return mQuestCompletePopup; }
function        H7GFxUIContainer GetPopup()     { return mQuestCompletePopup; }
static function H7QuestLogCntl   GetInstance()  { return class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetQuestLogCntl(); }

function bool Initialize() 
{
	// Start playing the movie
    Super.Start();
	// Initialize all objects in the movie
    AdvanceDebug(0);
	
	mQuestCompletePopup = H7GFxQuestComplete(mRootMC.GetObject("aQuestCompletePopup", class'H7GFxQuestComplete'));
	mQuestCompletePopup.SetVisibleSave(false);

	Super.Initialize();
	return true;
}

function InitWindowKeyBinds()
{
	CreatePopupKeybind('Enter',"RewardConfirm",ClosePopup,'SpaceBar');
	
	super.InitWindowKeyBinds();
}

function OpenPopupForQuest(H7SeqAct_Quest_NewNode quest)
{
	local H7PopupParameters params;
	if(CanOpenPopup() && class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetPlayerNumber() == quest.GetPlayerNumber())
	{
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("QUEST_COMPLETE");
		mQuestCompletePopup.Update(quest);
		mOnRewardAccepted = quest.OnRewardAccepted;
		mQueuedQuest = none;
	}
	else
	{
		params.param1 = quest;
		PutPopupIntoQueue(params,quest.GetPlayerNumber(), MCC_ADV_MAP);
		mQueuedQuest = quest;
	}
	super.OpenPopup();
}

function bool CanOpenPopup()
{
	if(class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().IsControlledByAI() == true || 
		(mQueuedQuest != none && class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetPlayerNumber() != mQueuedQuest.GetPlayerNumber()) ||
		GetQuestCompletePopup().IsVisible())
	{
		return false;
	}
	return Super.CanOpenPopup();
}

function OpenPopupFromQueue(H7PopupParameters params)
{
	local H7SeqAct_Quest_NewNode quest;
	quest = H7SeqAct_Quest_NewNode(params.param1);

	OpenPopupForQuest(quest);
}

function Closed()
{
	ClosePopup();
}

function ClosePopup()
{
	super.ClosePopup();
	mOnRewardAccepted();
}


