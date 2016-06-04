/*============================================================================
* H7SeqEvent_VisitNeutralBuilding
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/

class H7SeqEvent_VisitNeutralBuilding extends H7SeqEvent_HeroEvent
	native;

/** Only a specific neutral building triggers the event, otherwise any neutral building will trigger it */
var(Properties) protected bool mOneBuilding<DisplayName="One specific neutral building">;
/** The specific dwelling or mine to trigger the event */
var(Developer) protected H7NeutralSite mSite<DisplayName="Old Neutral building - DEPRECATED USE Neutral building instead">;

/** The specific dwelling or mine to trigger the event */
var(Properties) protected H7INeutralable mTargetSite<DisplayName="Neutral building"|EditCondition=mOneBuilding>;

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	return super.CheckH7SeqEventActivate(evtParam) && (!mOneBuilding || H7HeroEventParam(evtParam).mEventSite == mTargetSite);
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

event VersionUpdated(int oldVersion, int newVersion)
{
	if(oldVersion < 8)
	{
		if(mSite != none && mTargetSite == none)
		{
			mTargetSite = mSite;
		}
	}
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

