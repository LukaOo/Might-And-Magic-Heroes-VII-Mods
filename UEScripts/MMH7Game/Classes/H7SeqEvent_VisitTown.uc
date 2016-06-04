/*============================================================================
* H7SeqEvent_VisitTown
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/

class H7SeqEvent_VisitTown extends H7SeqEvent_HeroEvent
	implements(H7IRandomPropertyOwner)
	native
	savegame;

/** Only a specific town or fort triggers the event, otherwise any town or fort will trigger it */
var(Properties) protected bool mOneTown<DisplayName="One specific town or fort">;
/** The specific town or fort to trigger the event */
var(Properties) protected savegame H7AreaOfControlSiteLord mTown<DisplayName="Town or fort"|EditCondition=mOneTown>;

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	return super.CheckH7SeqEventActivate(evtParam) && (!mOneTown || H7HeroEventParam(evtParam).mEventSite == mTown);
}

function UpdateRandomProperties(Object randomObject, Object hatchedObject)
{
	if(hatchedObject.IsA('H7AreaOfControlSiteLord'))
	{
		if(mTown == randomObject)
		{
			mTown = H7AreaOfControlSiteLord(hatchedObject);
		}
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

