// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.

class H7SeqAct_FailQuestObjective extends SequenceAction
	implements(H7IAliasable, H7IActionable)
	native;

// The Quest Objective to fail
var(Properties) protected H7SeqAct_QuestObjective mObjective<DisplayName="Quest Objective">;

function Activated()
{
	if(mObjective != none && mObjective.IsActive())
	{
		mObjective.ForceActivateInput(3);
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

