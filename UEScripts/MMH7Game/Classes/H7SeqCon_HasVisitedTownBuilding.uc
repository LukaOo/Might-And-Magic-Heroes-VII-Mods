/*=============================================================================
 * H7SeqCon_HasVisitedTownBuilding
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================*/

class H7SeqCon_HasVisitedTownBuilding extends H7SeqCon_Player
	implements(H7IConditionable)
	native;

/** Required Town Building to fire the trigger */
var(Properties) protected archetype H7TownBuilding mTargetBuilding<DisplayName="Required Town Building">;
/** Required Town to fire the trigger */
var(Properties) protected archetype H7Town mTargetTown<DisplayName="Required Town">;

function protected bool IsConditionFulfilledForPlayer(H7Player player)
{
	local array<H7TownBuildingVisitData> visitData;
	local H7TownBuildingVisitData currentVisitData;

	visitData = class'H7ScriptingController'.static.GetInstance().GetVisitedBuildings();

	foreach visitData(currentVisitData)
	{
		if(currentVisitData.PlayerID == player.GetPlayerNumber())
		{
			if((mTargetBuilding == none || currentVisitData.Building == mTargetBuilding) &&
				(mTargetTown == none || currentVisitData.Town == mTargetTown))
			{
				return true;
			}
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

