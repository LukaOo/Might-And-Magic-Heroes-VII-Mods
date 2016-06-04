// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.

class H7SeqCon_EventIs extends H7SeqCon_TimePassed
	implements(H7IConditionable)
	native;

// The event whose status should be checked.
var(Properties) protected H7SeqCon_Event mEvent<DisplayName="Event">;
// The event status to check for.
var(Properties) protected EEventStatus mStatus<DisplayName="Status">;

function protected bool IsConditionFulfilled()
{
	if(mEvent == none)
	{
		return false;
	}
	else
	{
		return (mEvent.GetStatus() == mStatus);
	}
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

