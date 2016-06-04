/*=============================================================================
 * H7SeqAct_FinishHeroTurn
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================*/

class H7SeqAct_FinishHeroTurn extends SequenceAction
	implements(H7IAliasable, H7IActionable)
	native;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

event Activated()
{
	class'H7AdventureController'.static.GetInstance().FinishHeroTurn();
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

