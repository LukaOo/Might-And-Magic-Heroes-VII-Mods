// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
class H7SeqAct_DoEndGameAction extends SequenceAction;

event Activated()
{
	local H7QuestController currentQuestController;
	currentQuestController = class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetQuestController();
	currentQuestController.SetSkipEndGameAction(false);
	currentQuestController.DoEndGameAction(currentQuestController.GetPendingEndGameAction());
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

