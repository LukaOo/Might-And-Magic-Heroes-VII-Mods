/*============================================================================
* H7SeqEvent_EnterLeaveShip
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/

class H7SeqEvent_EnterLeaveShip extends H7SeqEvent_HeroEvent
	native;

/** Only a specific ship triggers the event, otherwise any ship will trigger it */
var(Properties) protected bool mOneShip<DisplayName="One specific ship">;
/** The specific ship to trigger the event */
var(Properties) protected H7Ship mShip<DisplayName="Ship"|EditCondition=mOneShip>;
/** Required interaction, board or disembark */
var(Properties) protected EShipInteraction mInteraction<DisplayName="Interaction">;

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	local H7HeroEventParam heroEventParam;
	heroEventParam = H7HeroEventParam(evtParam);
	return super.CheckH7SeqEventActivate(evtParam) && 
		(heroEventParam.mShipInteraction == mInteraction) && (!mOneShip || heroEventParam.mEventSite == mShip);
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

