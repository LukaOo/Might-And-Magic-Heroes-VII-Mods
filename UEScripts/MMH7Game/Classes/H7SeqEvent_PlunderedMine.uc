/*============================================================================
* H7SeqEvent_PlunderedMine
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/

class H7SeqEvent_PlunderedMine extends H7SeqEvent_HeroEvent
	native;

/** Check for a specific mine. Otherwise, any plundered mine is checked. */
var(Properties) H7Mine mMine<DisplayName="Specific mine">;
/** The player that should be in control of the mine that is plundered. */
var(Properties) protected EPlayerNumber mMineOwner<DisplayName="Mine owner">;

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	local H7HeroEventParam heroParam;

	if(super.CheckH7SeqEventActivate(evtParam))
	{
		heroParam = H7HeroEventParam(evtParam);
		if(heroParam != none)
		{
			return ((mMine == none) || mMine == heroParam.mEventSite) &&
					((mMineOwner == PN_PLAYER_NONE) || heroParam.mEventSite.GetPlayer().GetPlayerNumber() == mMineOwner);
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

