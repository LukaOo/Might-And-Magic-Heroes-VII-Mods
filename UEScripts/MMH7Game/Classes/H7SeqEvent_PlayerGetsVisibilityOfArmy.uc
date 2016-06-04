/*============================================================================
* H7SeqEvent_PlayerGetsVisibilityOfArmy
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/
class H7SeqEvent_PlayerGetsVisibilityOfArmy extends H7SeqEvent_PlayerGetsVisibilityOf
	implements(H7IHeroReplaceable, H7IRandomPropertyOwner)
	native
	savegame;

/** Only a specific army triggers the event, otherwise any army will trigger it */
var(Properties) protected bool mOneArmy<DisplayName="One specific army">;
/** The specific army to trigger the event */
var(Properties) protected H7AdventureArmy mArmy<DisplayName="Army"|EditCondition=mOneArmy>;
/** Only an army controlled by a specific player triggers the event, otherwise any player will trigger it */
var(Properties) protected bool mArmyOnePlayer<DisplayName="Army controlled by one player">;
/** The specific player controlling the army to trigger the event */
var(Properties) protected EPlayerNumber mArmyPlayerNumber<DisplayName="Player controlling the army"|EditCondition=mArmyOnePlayer>;
/** Only an army controlled by one of the specified players trigger the event */
var(Properties) protected bool mArmyOnePlayers<DisplayName="Army controlled by player(s)">;
/** The specific player(s) controlling the army to trigger the event */
var(Properties) protected H7AffectedPlayers mArmyAffectedPlayers<DisplayName="Player(s) controlling the army">;
/** Only a specific hero triggers the event, otherwise any hero will trigger it */
var(Properties) protected bool mOneHero<DisplayName="One specific hero">;
/** The specific hero to trigger the event */
var(Properties) protected archetype H7EditorHero mHero<DisplayName="Hero"|EditCondition=mOneHero>;
/** Only consider caravans */
var(Properties) protected bool mCaravansOnly<DisplayName="Only consider caravans">;
/** Required caravan origin */
var(Properties) protected savegame H7AreaOfControlSiteLord mCaravanSource<DisplayName="Caravan origin">;
/** Required caravan destination */
var(Properties) protected savegame H7AreaOfControlSiteLord mCaravanTarget<DisplayName="Caravan destination">;

var protected H7AdventureArmy mHeroArmy;

function bool DiscoveredSomethingOfInterest(array<H7AdventureMapCell> cells)
{
	local H7AdventureMapCell uncoveredCell;
	local H7AdventureArmy army;
	local H7CaravanArmy caravan;
	local bool armyMatch, heroMatch, caravanMatch;
	local H7EditorHero heroToCheck;

	foreach cells( uncoveredCell )
	{
		army = uncoveredCell.GetArmy();

		if(army != none && !army.IsGarrisoned())
		{
			caravan = H7CaravanArmy(army);
			heroToCheck = (mHeroArmy == none) ? mHero : mHeroArmy.GetHeroTemplateSource();

			armyMatch = (!mOneArmy || army == self.mArmy) && 
				((!mArmyOnePlayer || army.GetPlayerNumber() == self.mArmyPlayerNumber) && 
				(!mArmyOnePlayers || IsChecked(self.mArmyAffectedPlayers, army.GetPlayerNumber())));
			heroMatch = (!mOneHero || army.GetHero() == heroToCheck);
			caravanMatch = (!mCaravansOnly || ((caravan != none) && ((mCaravanSource == none) || (mCaravanSource == caravan.GetSourceLord())) && 
				((mCaravanTarget == none) || (mCaravanTarget == caravan.GetTargetLord()))));

			if( (armyMatch && heroMatch && caravanMatch) ) { return true; }
		}
	}

	return false;
}

function UpdateRandomProperties(Object randomObject, Object hatchedObject)
{
	if(hatchedObject.IsA('H7AreaOfControlSiteLord'))
	{
		if(mCaravanSource == randomObject)
		{
			mCaravanSource = H7AreaOfControlSiteLord(hatchedObject);
		}

		if(mCaravanTarget == randomObject)
		{
			mCaravanTarget = H7AreaOfControlSiteLord(hatchedObject);
		}
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 4;
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

