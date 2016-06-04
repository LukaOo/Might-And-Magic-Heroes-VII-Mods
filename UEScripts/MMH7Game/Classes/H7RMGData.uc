//=============================================================================
// H7RMGData
//=============================================================================
//
//
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7RMGData extends Object
	hidecategories( Object )
	native(RMG);

var(Data,Factions)  protectedwrite array<H7RMGFactionData>			mFactionData<DisplayName="Faction Data">;
var(Data,Factions)  protectedwrite H7RMGCreatureArray				mNeuteralCreatures[ECreatureTier.CTIER_MAX];
var(Data,Factions)  protectedwrite H7RandomCreatureStack    		mRandomCreature;
var(Data,Factions)  protectedwrite array<MaterialInstanceConstant>  mRandomCreatureMaterials;
var(Data,Factions)  protectedwrite bool								mUseRandomCreatures;
var(Data,Player)    protectedwrite MapInfoPlayerProperty			mDefaultPlayerProperties[EPlayerNumber.PN_MAX];

var(Data,Templates) protectedwrite array<H7RMGZoneTemplate> mZoneTemplates<DisplayName="Zone Templates">;
var(Data,Templates) protectedwrite array<H7RMGBuilding> mAdditionalBuildings<DisplayName="Additional Buildings">;
var(Data,Templates) protectedwrite array<H7RMGShareBuildings> mShareBuildings<DisplayName="Additional Share Buildings">;

var(Data,Templates) protectedwrite H7RMGTeleporter mTeleporters[ERMGTeleporterType.ERTT_MAX]<DisplayName="Teleporter List">;
var(Data,Templates) protectedwrite H7RMGBuilding mSiteLords[EAoCLordType.ALT_MAX]<DisplayName="SiteLords">;

var(Data,Pickups)   protectedwrite bool mEnableSparePickups;
var(Data,Pickups)   protectedwrite array<H7RMGBuilding> mSpareBuildings<DisplayName="Spare Buildings (pickups)">;
var(Data,Pickups)   protectedwrite int mPickupEveryN<DisplayName="Spare Pickups at paths, every N tiles ">;
var(Data,Pickups)   protectedwrite int mPickupChance<DisplayName="Spare Pickups, spawn with chance of N out of 100 ">;
var(Data,Pickups)   protectedwrite int mPickupRichnessMod<DisplayName="Spare Pickups, extra spawn chance * Richness ">;
var(Data,Pickups)   protectedwrite float mPickupMaxHeight<DisplayName="Spare Pickups, Max Height from road to spawn ">;
var(Data,Pickups)   protectedwrite int mPickupDist<DisplayName="Spare Pickups, Distance from road to spawn ">;

var(Data)           protectedwrite H7PlayerStart mPlayerStart;
var(General)        protectedwrite H7RMGLandscapeProperties mLandscapeProperties[EMapSize.MS_MAX];

protected function int DescendingCompare( H7RMGBuilding b1, H7RMGBuilding b2 )
{
	return b1.mShareWeight - b2.mShareWeight;
}

protected function int AscendingCompare( H7RMGBuilding b1, H7RMGBuilding b2 )
{
	return ( b1.mShareWeight - b2.mShareWeight ) * -1;
}

event protected SortBuildings( out array<H7RMGBuilding> buildings, bool ascending )
{
	if( ascending )
	{
		buildings.Sort( AscendingCompare );
	}
	else
	{
		buildings.Sort( DescendingCompare );
	}
}

protected function int CreatureCompare( H7Creature a, H7Creature b )
{
	return ( a.GetExperiencePoints() - b.GetExperiencePoints() ) * -1;
}

event protected SortCreaturesAscending( out array<H7Creature> creatures )
{
	creatures.Sort(CreatureCompare);
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
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

