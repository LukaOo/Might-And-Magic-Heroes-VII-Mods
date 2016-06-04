// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.

class H7SeqAct_FailQuest extends SequenceAction
	implements(H7IAliasable, H7IActionable)
	native;

// The Quest to fail.
var(Properties) protected H7SeqAct_Quest_NewNode mQuest<DisplayName="Quest">;

function Activated()
{
	if(mQuest != none && mQuest.IsStarted())
	{
		mQuest.ForceActivateInput(2);
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

