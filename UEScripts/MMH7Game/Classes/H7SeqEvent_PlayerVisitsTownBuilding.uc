/*============================================================================
* H7SeqEvent_PlayerVisitsTownBuilding
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/
class H7SeqEvent_PlayerVisitsTownBuilding extends H7SeqEvent_PlayerEvent
	native;

/** Only a specific Town Building triggers the event, otherwise any building will trigger it */
var(Properties) protected bool mOneBuilding<DisplayName="One specific Town Building">;
/** Required Town Building to fire the trigger */
var(Properties) protected archetype H7TownBuilding mTargetBuilding<DisplayName="Required Town Building"|EditCondition=mOneBuilding>;

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	local H7PlayerEventParam param;

	if (super.CheckH7SeqEventActivate(evtParam))
	{
		param = H7PlayerEventParam(evtParam);
		if (param != none)
		{
			return (!mOneBuilding || param.mTownbuilding == self.mTargetBuilding);
		}
	}
	return false;
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

