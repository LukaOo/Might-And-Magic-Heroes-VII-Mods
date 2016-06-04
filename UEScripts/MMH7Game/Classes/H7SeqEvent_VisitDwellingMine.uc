/*============================================================================
* H7SeqEvent_VisitDwellingMine
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/

class H7SeqEvent_VisitDwellingMine extends H7SeqEvent_HeroEvent
	implements(H7IRandomPropertyOwner)
	native
	savegame;

/** Only a specific dwelling or mine triggers the event, otherwise any dwelling or mine will trigger it */
var(Properties) protected bool mOneMine<DisplayName="One specific dwelling or mine">;
/** The specific dwelling or mine to trigger the event */
var(Properties) protected savegame H7AreaOfControlSiteVassal mMine<DisplayName="Dwelling or mine"|EditCondition=mOneMine>;

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	return super.CheckH7SeqEventActivate(evtParam) && (!mOneMine || H7HeroEventParam(evtParam).mEventSite == mMine);
}

function UpdateRandomProperties(Object randomObject, Object hatchedObject)
{
	if(hatchedObject.IsA('H7AreaOfControlSiteVassal'))
	{
		if(mMine == randomObject)
		{
			mMine = H7AreaOfControlSiteVassal(hatchedObject);
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

