/*=============================================================================
* H7TownGuardBuilding
* =============================================================================
*  Class for describing buildings that increase townguard income. (WALL in Town)
*  ! - also needs to be present in forts
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7TownGuardBuilding extends H7TownBuilding;

// 0 - None, 1 - Core, 2 - Elite, 3 - Champion
var(Properties) protected int mFortificationLevel<DisplayName=Level of Fortification>;
var(Properties) protected H7LocalGuardData mLocalGuardData<DisplayName=Local Guard Data>; 

var(UnitClassifications) protected H7Creature mCoreFootmen<DisplayName=Core Footmen>;
var(UnitClassifications) protected H7Creature mCoreShooters<DisplayName=Core Shooters>;
var(UnitClassifications) protected H7Creature mEliteNonShooters<DisplayName=Elite Non Shooters>;
var(UnitClassifications) protected H7Creature mEliteShooters<DisplayName=Elite Shooters>;
var(UnitClassifications) protected H7Creature mChampions<DisplayName=Champions>;

function int GetLevel()
{
	return mFortificationLevel;
}

function array<H7DwellingCreatureData> DowngradeTownGuard(array<H7DwellingCreatureData> oldTownGuard, optional H7TownGuardGrowthEnhancer guardEnhancer)
{
	local array<H7DwellingCreatureData> newLocalGuard;
	local int moddedCapacity;
	local int i;

	newLocalGuard = GetDefaultTownGuard();

	// copy old (modified) reserves:
	for(i=0;i<newLocalGuard.Length;++i)
	{
		if(i < oldTownGuard.Length)
		{
			newLocalGuard[i].Reserve = oldTownGuard[i].Reserve;
			moddedCapacity = mTown.GetGuardCapacityFor( oldTownGuard[i] );
			if(newLocalGuard[i].Reserve > moddedCapacity)
			{
				newLocalGuard[i].Reserve = moddedCapacity;
			}
		}
	}
	
	return newLocalGuard;
}

function array<H7DwellingCreatureData> GetCorrectedTownGuard(array<H7DwellingCreatureData> oldTownGuard , H7Faction faction)
{
	local array<H7DwellingCreatureData> newLocalGuard;
	local int i, capacity;
	
	newLocalGuard = GetDefaultTownGuard();

	// copy old (modified) reserves:
	for(i=0;i<newLocalGuard.Length;++i)
	{
		if(i < oldTownGuard.Length)
		{
			newLocalGuard[i].Reserve = oldTownGuard[i].Reserve;
			capacity = mTown.GetGuardCapacityFor( oldTownGuard[i] );
			if(newLocalGuard[i].Reserve > capacity)
			{
				newLocalGuard[i].Reserve = capacity;
			}
			//`log_gui(newLocalGuard[i].Creature @ newLocalGuard[i].Capacity @ newLocalGuard[i].Income @ newLocalGuard[i].Reserve);
		}
	}

	return newLocalGuard;
}

function H7Creature GetCreatureClass(ECreatureTier tier,optional bool ranged=false,optional bool support=false)
{
	local array<H7TownBuildingData> buildings;
	local int i;

	// tbd search for them, or save them somewhere? // TODO -> fort task
	switch(tier)
	{
		case CTIER_CORE:
			if(ranged) return mCoreShooters;
			else return mCoreFootmen;
			break;
		case CTIER_ELITE:
			if(ranged) return mEliteShooters;
			else return mEliteNonShooters;
			break;
		case CTIER_CHAMPION:
				if(mChampions != none) 
				{
					return mChampions;
				}
				else // If there is no champion in property, check if Champion building is build
				{
					buildings = GetTown().GetBuildings();
					
					for(i = 0; i < buildings.Length; ++i)
					{
						if(H7TownDwelling(buildings[i].Building) != none)
						{
							if(H7TownDwelling(buildings[i].Building).GetCreaturePool().Creature.GetTier() == CTIER_CHAMPION)
							{
								return H7TownDwelling(buildings[i].Building).GetCreaturePool().Creature;
							}
						}
					}
				break;
				
			}
			
	}
	//`warn("Faction.GetCreatureClass not found"); // unneeded warning?
	return none;
}

// Returns default TownGuard for this building
function array<H7DwellingCreatureData> GetDefaultTownGuard()
{
	local array<H7DwellingCreatureData> newLocalGuard;

	// Creatures
	newLocalGuard.Add( 5 );
	if(mFortificationLevel > 0)
	{
		newLocalGuard[0].Creature = GetCreatureClass(CTIER_CORE,false);
	}
	if(mFortificationLevel > 0)
	{
		newLocalGuard[1].Creature = GetCreatureClass(CTIER_CORE,true);
	}
	if(mFortificationLevel > 1)
	{
		newLocalGuard[2].Creature = GetCreatureClass(CTIER_ELITE,false);
	}
	if(mFortificationLevel > 1)
	{
		newLocalGuard[3].Creature = GetCreatureClass(CTIER_ELITE,true);
	}
	if(mFortificationLevel > 0)
	{
		newLocalGuard[4].Creature = GetCreatureClass(CTIER_CHAMPION,false);
	}

	if(newLocalGuard.Length >= 1) newLocalGuard[0].Income = mLocalGuardData.mProductionCore;
	if(newLocalGuard.Length >= 2) newLocalGuard[1].Income = mLocalGuardData.mProductionCore;
	if(newLocalGuard.Length >= 3) newLocalGuard[2].Income = mLocalGuardData.mProductionElite;
	if(newLocalGuard.Length >= 4) newLocalGuard[3].Income = mLocalGuardData.mProductionElite;
	if(newLocalGuard.Length >= 5) newLocalGuard[4].Income = mLocalGuardData.mProductionChampion;

	if(newLocalGuard.Length >= 1) newLocalGuard[0].Capacity = mLocalGuardData.mCapacityCoreFoot;
	if(newLocalGuard.Length >= 2) newLocalGuard[1].Capacity = mLocalGuardData.mCapacityCoreRange;
	if(newLocalGuard.Length >= 3) newLocalGuard[2].Capacity = mLocalGuardData.mCapacityEliteFoot;
	if(newLocalGuard.Length >= 4) newLocalGuard[3].Capacity = mLocalGuardData.mCapacityEliteRange;
	if(newLocalGuard.Length >= 5) newLocalGuard[4].Capacity = mLocalGuardData.mCapacityChampion;

	if(newLocalGuard.Length >= 1) newLocalGuard[0].Reserve = mLocalGuardData.mProductionCore;
	if(newLocalGuard.Length >= 2) newLocalGuard[1].Reserve = mLocalGuardData.mProductionCore;
	if(newLocalGuard.Length >= 3) newLocalGuard[2].Reserve = mLocalGuardData.mProductionElite;
	if(newLocalGuard.Length >= 4) newLocalGuard[3].Reserve = mLocalGuardData.mProductionElite;
	if(newLocalGuard.Length >= 5) newLocalGuard[4].Reserve = mLocalGuardData.mProductionChampion;

	return newLocalGuard;
}
