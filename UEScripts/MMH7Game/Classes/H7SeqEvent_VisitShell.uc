/*============================================================================
* H7SeqEvent_VisitShell
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/

class H7SeqEvent_VisitShell extends H7SeqEvent_HeroEvent
	native;

/** Only a specific shell triggers the event, otherwise any shell will trigger it */
var(Properties) protected bool mOneShell<DisplayName="One specific shell">;
/** The specific visitable shell to trigger the event */
var(Properties) protected H7VisitingShell mShell<DisplayName="Shell"|EditCondition=mOneShell>;

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	return super.CheckH7SeqEventActivate(evtParam) && (!mOneShell || H7HeroEventParam(evtParam).mEventSite == mShell);
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

