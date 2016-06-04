/*============================================================================
* H7SeqEvent_PlayerGetsVisibilityOfBuilding
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/
class H7SeqEvent_PlayerGetsVisibilityOfBuilding extends H7SeqEvent_PlayerGetsVisibilityOf
	implements(H7IRandomPropertyOwner)
	native
	savegame;

/** Only a specific building triggers the event, otherwise any building will trigger it */
var(Properties) protected bool mOneBuilding<DisplayName="One specific building">;
/** Required building to fire the trigger */
var(Properties) protected savegame H7VisitableSite mTargetBuilding<DisplayName="Required building"|EditCondition=mOneBuilding>;

/** Only a building controlled by a specific player triggers the event, otherwise any player will trigger it */
var(Properties) protected bool mBuildingOnePlayer<DisplayName="Building controlled by one player">;
/** The specific player controlling the army to trigger the event */
var(Properties) protected EPlayerNumber mBuildingPlayerNumber<DisplayName="Player controlling the building"|EditCondition=mBuildingOnePlayer>;
/** Only a building controlled by one of the specified players trigger the event */
var(Properties) protected bool mBuildingOnePlayers<DisplayName="Building controlled by player(s)">;
/** The specific player(s) controlling the army to trigger the event */
var(Properties) protected H7AffectedPlayers mBuildingAffectedPlayers<DisplayName="Player(s) controlling the building">;

function bool DiscoveredSomethingOfInterest(array<H7AdventureMapCell> cells)
{
	local H7VisitableSite uncoveredSite;
	local H7AdventureMapCell uncoveredCell;
	local H7AreaOfControlSite controlSite;
	local H7Ship shipSite;
	local bool buildingMatch, ownerMatch;
	local EPlayerNumber playerToCheck;

	foreach cells( uncoveredCell )
	{
		uncoveredSite = uncoveredCell.GetVisitableSite();

		if(uncoveredSite == none)
		{
			continue;
		}
	
		controlSite = H7AreaOfControlSite(uncoveredSite);
		shipSite = H7Ship(uncoveredSite);

		playerToCheck = PN_NEUTRAL_PLAYER;
		if(controlSite != none)
		{
			playerToCheck = controlSite.GetPlayerNumber();
		}
		else if(shipSite != none)
		{
			playerToCheck = shipSite.GetPlayerNumber();
		}

		buildingMatch = !mOneBuilding || (mTargetBuilding != none && uncoveredSite == mTargetBuilding);
		ownerMatch = ((!mBuildingOnePlayer || (playerToCheck == mBuildingPlayerNumber)) &&
						(!mBuildingOnePlayers || IsChecked(self.mBuildingAffectedPlayers, playerToCheck)));
		if( buildingMatch && ownerMatch ) { return true; }
	}

	return false;
}

function UpdateRandomProperties(Object randomObject, Object hatchedObject)
{
	if(hatchedObject.IsA('H7VisitableSite'))
	{
		if(mTargetBuilding == randomObject)
		{
			mTargetBuilding = H7VisitableSite(hatchedObject);
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

