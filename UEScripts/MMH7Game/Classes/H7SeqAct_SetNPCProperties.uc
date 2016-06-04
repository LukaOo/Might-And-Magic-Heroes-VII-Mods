/*=============================================================================
 * H7SeqAct_SetNPCProperties
 * ============================================================================
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================
 */
class H7SeqAct_SetNPCProperties extends SequenceAction
	implements(H7IAliasable, H7IActionable)
	native;

/** The NPC army that is talked to */
var(Properties) protected H7AdventureArmy mNPCArmy<DisplayName="NPC army">;
/** If checked, the army won't act as enemy or ally */
var(Properties) protected bool mIsNPC<DisplayName=NPC>;
/** If checked, the army can be talked to */
var(Properties) protected bool mIsTalking<DisplayName=Talks>;

event Activated()
{
	if(mNPCArmy != none)
	{
		mNPCArmy.SetNPC(mIsNPC);
		mNPCArmy.SetTalking(mIsTalking);
		mNPCArmy.SpawnHeroFlag();
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

