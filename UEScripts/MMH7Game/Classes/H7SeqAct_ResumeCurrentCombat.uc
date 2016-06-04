/*=============================================================================
 * H7SeqAct_ResumeCurrentCombat
 * 
 * Blocks the tick of the currently active Combat Controller
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ===========================================================================*/

class H7SeqAct_ResumeCurrentCombat extends SequenceAction
	implements(H7IAliasable, H7IActionable)
	native;

function Activated()
{
	local H7ScriptingController scriptControl;

	scriptControl = class'H7ScriptingController'.static.GetInstance();
	if(scriptControl != none)
	{
		scriptControl.ResumeCombat();
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

