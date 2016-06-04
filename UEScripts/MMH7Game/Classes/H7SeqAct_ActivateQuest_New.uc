/*=============================================================================
 * H7SeqAct_ActivateQuest_New
 * 
 * Needed for noob editor
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================*/

class H7SeqAct_ActivateQuest_New extends SequenceAction
	implements(H7IAliasable, H7IActionable)
	native;

// The Quest to activate.
var(Properties) protected H7SeqAct_Quest_NewNode mQuest<DisplayName="Quest">;

function Activated()
{
	if(mQuest != none)
	{
		mQuest.ForceActivateInput(0);
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

