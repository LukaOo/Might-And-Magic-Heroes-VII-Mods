/*============================================================================
* H7SeqEvent_ReachLevel
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/

class H7SeqEvent_ReachLevel extends H7SeqEvent_HeroEvent
	native;

/** The required hero level */
var(Properties) protected int mHeroLevel<DisplayName="Reach level"|ClampMin=2|ClampMax=999>;

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	local H7HeroEventParam param;
	if (super.CheckH7SeqEventActivate(evtParam))
	{
		param = H7HeroEventParam(evtParam);
		if (param.mEventHeroLevel >= mHeroLevel && param.mEventOldHeroLevel < mHeroLevel)
		{
			return true;
		}
	}
	return false;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 3;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

