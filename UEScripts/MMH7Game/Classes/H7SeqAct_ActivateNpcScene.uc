/*=============================================================================
 * H7SeqAct_ActivateNpcScene
 * 
 * Needed for noob editor
 *  
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================*/

class H7SeqAct_ActivateNpcScene extends SequenceAction
	implements(H7IAliasable, H7IActionable)
	native;

var(Properties) protected H7SeqAct_StartNpcScene mScene<DisplayName="NPC Scene">;

function Activated()
{
	if(mScene != none)
	{
		mScene.ForceActivateInput(0);
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
// (cpptext)
// (cpptext)
// (cpptext)

