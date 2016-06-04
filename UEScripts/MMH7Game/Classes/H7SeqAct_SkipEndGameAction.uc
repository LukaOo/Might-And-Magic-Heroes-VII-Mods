// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
class H7SeqAct_SkipEndGameAction extends SequenceAction;

event Activated()
{
	class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetQuestController().SetSkipEndGameAction(true);
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

