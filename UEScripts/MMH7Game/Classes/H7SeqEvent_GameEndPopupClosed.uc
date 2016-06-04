/*============================================================================
* H7SeqEvent_GameEnded
* 
* Fired when the end of game Popup is closed.
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/

class H7SeqEvent_GameEndPopupClosed extends H7SeqEvent;

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

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

