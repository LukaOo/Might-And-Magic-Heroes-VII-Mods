//=============================================================================
// H7RMGBuilding
//=============================================================================
//
//
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7RMGBuilding extends Object
	hidecategories( Object )
	native(RMG);

var(BuildingData) protectedwrite ERMGBuildingType           mBuildingType<DisplayName=Building type>;
var(BuildingData) protectedwrite dynload H7VisitableSite    mBuildingArchetype<DisplayName=Object Archetype>;
var(BuildingData) protectedwrite IntPoint                   mDimension<DisplayName=Building dimensions>;
var(BuildingData) protectedwrite H7Faction		            mFaction<DisplayName=Faction>;
var(BuildingData) protectedwrite bool                       mIsGuarded<DisplayName=Is guarded by critter army>;
var(BuildingData) protectedwrite float                      mGuardModifier<DisplayName=Guard Modifier|ClampMin=0|ClampMax=10>;

var(PlacementData) protectedwrite bool mHasRoadConnection<DisplayName=Has road connection>;
var(PlacementData) protectedwrite int mMinDistanceToBorder<DisplayName=Min Distance to AoC border|ClampMin=0>;
var(PlacementData) protectedwrite int mMinDistanceToSiteLord<DisplayName=Min Distance to AoC-Lord|ClampMin=0>;
var(PlacementData) protectedwrite int mMaxDistanceToSiteLord<DisplayName=Max Distance to AoC-Lord|ClampMin=0>;
var(PlacementData) protectedwrite int mMinDistanceToEqualType<DisplayName=Min Distance to equal Building-Type|ClampMin=0>;
var(PlacementData) protectedwrite int mMinDistanceToDifferentType<DisplayName=Min Distance to different Building-Type|ClampMin=0>;
var(PlacementData) protectedwrite int mMinDistanceToMapBorder<DisplayName=Min Distance to Map-Border|ClampMin=0>;

var(PlacementData,TemplateData) protectedwrite float            mPlacementModifier<DisplayName=Placement modifier|ClampMin=0.0|ClampMax=10.0>;
var(PlacementData,TemplateData) protectedwrite int              mShareWeight<ClampMin=10|ClampMax=10000|DisplayName=Share weight>;
var(PlacementData,TemplateData) protectedwrite ERoundingType    mRoundingType <DisplayName=Rounding type>;
var(PlacementData,TemplateData) protectedwrite bool             mUseAsChance<DisplayName=Use As Chance>;
var(PlacementData,TemplateData) protectedwrite bool				mAtLeastOne<DisplayName=Place at least one>;
var(PlacementData,TemplateData) protectedwrite bool				mNotMoreThanOne<DisplayName=Place not more than one>;
var(PlacementData,TemplateData) protectedwrite bool				mNotMoreThanOnePerZone<DisplayName=Place not more than one per zone>;
var(PlacementData,TemplateData) protectedwrite bool				mModifiedByRichness<DisplayName=Modified by richness settings>;
var(PlacementData,TemplateData) protectedwrite bool				mUniformDistribution<DisplayName=Uniform Distribution>;
var(PlacementData,TemplateData) protectedwrite bool             mCanBePlacedInStartZone<DisplayName=Can be placed in Start-Zone>;
var(PlacementData,TemplateData) protectedwrite bool             mCountByType<DisplayName=Count by type>;
var(PlacementData,TemplateData) protectedwrite bool             mOnlyWithTearOfAsha;
var(PlacementData,TemplateData) protectedwrite bool             mIgnoredByClusters<DisplayName=Ignored by Resource Clusters>;
var(PlacementData,TemplateData) protectedwrite bool             mOnePerCluster<DisplayName=Use only one per Resource Cluster>;

var(PlacementData,TemplateData) protectedwrite array<H7RMGZoneTemplateRule> mZoneLordRules<DisplayName=Additional Rules>;

var protectedwrite H7RMGCell mCell;
var private EPlayerNumber mPlayerNum;
var protectedwrite IntPoint mTranslation;

var array<H7VisitableSite> mSpawnedSites;

event H7VisitableSite GetBuildingArchetype()
{
	if( mBuildingArchetype == none )
	{
		DynLoadObjectProperty('mBuildingArchetype');
	}

	return mBuildingArchetype;
}

native function bool CanPlaceHere( H7RMGCell targetCell, H7RMGGrid grid, H7RMGZoneTemplate zoneTemplate );


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
