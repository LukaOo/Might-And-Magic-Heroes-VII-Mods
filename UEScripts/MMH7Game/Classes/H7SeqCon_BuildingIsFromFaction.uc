// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.

class H7SeqCon_BuildingIsFromFaction extends H7SeqCon_TimePassed
	implements(H7IConditionable)
	native;

/* The Building to be checked. */
var(Properties) protected H7AreaOfControlSite mBuilding<DisplayName="Building">;
/* The Faction to be checked. */
var(Properties) protected archetype H7Faction mFaction<DisplayName="Faction">;

function protected bool IsConditionFulfilled()
{
	if(mBuilding == none  || mFaction == none)
	{
		return false;
	}
	else
	{
		return mBuilding.GetFaction() == mFaction;
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

