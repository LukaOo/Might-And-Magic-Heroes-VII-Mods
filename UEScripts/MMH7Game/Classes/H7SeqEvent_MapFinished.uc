/*============================================================================
* H7SeqEvent_MapFinished
* 
* * Fired when the adventure map/game is finished.
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/

class H7SeqEvent_MapFinished extends H7SeqEvent
	implements(H7ITriggerable)
	native;

// Condition that needs to be fulfilled for this event to trigger.
var(Properties) EAdventureMapFinishedCondition mFinishCondition<DisplayName="Trigger condition">;

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	local H7MapEventParam param;
	if ( super.CheckH7SeqEventActivate(evtParam) )
	{
		param = H7MapEventParam(evtParam);
		if (param != none)
		{
			return((mFinishCondition == E_H7_AMFC_ALWAYS) || 
				(mFinishCondition == E_H7_AMFC_WIN && param.mActivePlayerWon) || 
				(mFinishCondition == E_H7_AMFC_LOSE && !param.mActivePlayerWon));
		}
	}
	return false;
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

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

