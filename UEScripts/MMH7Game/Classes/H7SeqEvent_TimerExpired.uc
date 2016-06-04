 // Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
class H7SeqEvent_TimerExpired extends H7SeqEvent
	implements(H7ITriggerable)
	native;

/** Timer that is checked. Fires for any timer if set to none. */
var(Properties) protected H7SeqAct_StartTimer mTimer<DisplayName="Timer">;

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	local H7TimerEventParam param;

	if ( super.CheckH7SeqEventActivate(evtParam) )
	{
		param = H7TimerEventParam(evtParam);
		if (param != none)
		{
			return (mTimer == none || self.mTimer == param.mStartTimer);
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
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

