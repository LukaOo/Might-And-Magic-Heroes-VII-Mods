/*=============================================================================
 * H7SeqAct_EndCurrentTurn
 *
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ===========================================================================*/

class H7SeqAct_EndCurrentTurn extends SequenceAction
	implements(H7IAliasable, H7IActionable)
	native;

event Activated()
{
	class'H7AdventureController'.static.GetInstance().EndMyTurn();
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

