// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.

class H7SeqEvent_Battlesite extends H7SeqEvent_HeroEvent
	abstract
	native;

// The battle site. Triggers for any battle site if set to none
var(Properties) H7BattleSite mBattleSite<DisplayName="Battle Site">;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	local H7HeroEventParam param;

	if ( super.CheckH7SeqEventActivate(evtParam) )
	{
		param = H7HeroEventParam(evtParam);
		if (param != none)
		{
			return (mBattleSite == none || param.mBattleSite == self.mBattleSite);
		}
	}
	return false;
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

