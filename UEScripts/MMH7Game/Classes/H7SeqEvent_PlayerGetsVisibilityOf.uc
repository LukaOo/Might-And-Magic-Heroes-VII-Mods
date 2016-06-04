/*============================================================================
* H7SeqEvent_PlayerGetsVisibilityOf
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/
class H7SeqEvent_PlayerGetsVisibilityOf extends H7SeqEvent_PlayerEvent
	abstract
	native;

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	local H7PlayerEventParam param;

	if (super.CheckH7SeqEventActivate(evtParam))
	{
		param = H7PlayerEventParam(evtParam);
		if (param != none)
		{
			return DiscoveredSomethingOfInterest(param.mGridCoordinates);
		}
	}
	return false;
}

function bool DiscoveredSomethingOfInterest(array<H7AdventureMapCell> cells) { return true; }

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

