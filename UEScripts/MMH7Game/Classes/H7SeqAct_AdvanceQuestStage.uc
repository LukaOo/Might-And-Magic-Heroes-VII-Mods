// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.

class H7SeqAct_AdvanceQuestStage extends SequenceAction
	implements(H7IAliasable, H7IActionable)
	native;

// The Quest whose Objective Stage is advanced.
var(Properties) protected H7SeqAct_Quest_NewNode mQuest<DisplayName="Quest">;

function Activated()
{
	if(mQuest != none)
	{
		mQuest.ForceActivateInput(1);
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

