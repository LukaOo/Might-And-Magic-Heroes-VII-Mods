/*============================================================================
* H7SeqEvent_SiteCaptured
* 
* captures one/any town/fort/dwelling/mine controlled by one/any player in 
* one/any area
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/

class H7SeqEvent_SiteCaptured extends H7SeqEvent_HeroEvent
	implements(H7IRandomPropertyOwner)
	native
	savegame;

/** Capture a specific town or fort */
var(Properties) protected bool mOneSite<DisplayName="One specific site">;
/** The required specific town or fort to capture */
var(Properties) protected savegame H7AreaOfControlSite mSite<DisplayName="Site"|EditCondition=mOneSite>;

//TODO property: site controlled by one / any player

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	local bool active;
	active = super.CheckH7SeqEventActivate(evtParam) && (!mOneSite || H7HeroEventParam(evtParam).mEventSite == mSite);
	if(active)
	{
		;
	}
	return active;
}

function UpdateRandomProperties(Object randomObject, Object hatchedObject)
{
	if(hatchedObject.IsA('H7AreaOfControlSite'))
	{
		if(mSite == randomObject)
		{
			mSite = H7AreaOfControlSite(hatchedObject);
		}
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

