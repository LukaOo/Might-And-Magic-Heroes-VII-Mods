/*============================================================================
* H7SeqEvent_CollectArmy
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/

class H7SeqEvent_CollectSpecificArmy extends H7SeqEvent_HeroEvent
	native
	savegame;

// Army that should be collected. Will always fire when collecting armies if set to None.
var(Properties) protected H7AdventureArmy mArmyToCollect<DisplayName="Army to collect">;

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	local H7HeroEventParam param;
	if(super.CheckH7SeqEventActivate(evtParam))
	{
		param = H7HeroEventParam(evtParam);
		if (param != none)
		{
			return (mArmyToCollect == none || mArmyToCollect == param.mEventTargetArmy);
		}
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

