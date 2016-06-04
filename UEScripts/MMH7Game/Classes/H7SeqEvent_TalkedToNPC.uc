/*============================================================================
* H7SeqEvent_TalkedToNPC
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/

class H7SeqEvent_TalkedToNPC extends H7SeqEvent_HeroEvent
	native;

/** The NPC army that is talked to */
var(Properties) H7AdventureArmy mNPCArmy<DisplayName="NPC army">;

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	if ( super.CheckH7SeqEventActivate(evtParam) )
	{
		if(mNPCArmy == none || !mNPCArmy.IsNPC() || !mNPCArmy.IsTalking())
		{
			return false;
		}
		return (H7HeroEventParam(evtParam).mEventTargetArmy == mNPCArmy);
	}
	return false;
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

