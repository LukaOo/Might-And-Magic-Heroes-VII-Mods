/*=============================================================================
 * H7SeqAct_SetDiplomacy
 * ============================================================================
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================
 */
class H7SeqAct_SetDiplomacy extends SequenceAction
	implements(H7IAliasable, H7IActionable)
	native;

/** The army that should get its diplomacy disposition changed */
var(Properties) protected H7AdventureArmy mArmy<DisplayName="Target army">;
/** The new diplomacy disposition */
var(Properties) protected EDispositionType mDiplomaticDisposition<DisplayName=Negotiation Behaviour>;

event Activated()
{
	if(mArmy != none)
	{
		mArmy.SetDiplomaticDisposition(mDiplomaticDisposition);
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

