//=============================================================================
// H7SeqEvent_AdvCombatTransition
//=============================================================================
//
// Kismet Event that gets activated in an Adventuremap<->Combatmap transition
//
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7SeqEvent_AdvCombatTransition extends SequenceEvent
	implements(H7IAliasable, H7ITriggerable)
	native;

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

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

