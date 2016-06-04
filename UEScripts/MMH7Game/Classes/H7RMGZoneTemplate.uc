//=============================================================================
// H7RMGZoneTemplate
//=============================================================================
//
//
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7RMGZoneTemplate extends Object
	hidecategories( Object )
	dependson( H7RMGStructsAndEnums, H7RMGBuilding )
	native(RMG);

const SMALL_ZONE_VAL = 0.401f;

var(General) protectedwrite string          mName               <DisplayName=Name>;               
var(General) protectedwrite float			mSize				<DisplayName=Zone Size|ClampMin=0.0|ClampMax=1.0>;
var(General) protectedwrite float           mDistanceNormMod    <DisplayName=Distance Modifier|ClampMin=1|ClampMax=100>;
var(General) protectedwrite H7Faction		mFaction			<DisplayName=Faction>;
var(General) protectedwrite int			    mCritterStrength	<DisplayName=Critter Strength|ClampMin=0|ClampMax=300>;
var(General) protectedwrite EAoCLordType	mLordType			<DisplayName=AoC Lord-Type>;
var(General) protectedwrite bool			mIsStartingZone		<DisplayName=Starting Zone>;
var(General) protectedwrite float           mProbability		<DisplayName=Probability|ClampMin=0.0|ClampMax=1.0>;
var(General) protectedwrite int             mMaxConnections		<DisplayName=Max allowed connections|ClampMin=0>;
var(General) protectedwrite bool            mCanConSmall		<DisplayName=Can connect to small zones>;
var(General) protectedwrite int             mSharePerDistance   <DisplayName=Share increase per distance|ClampMin=0|ClampMax=100>;

var(ShareValues) protectedwrite int mShareValues[ERMGZoneShare.EZS_MAX]<DisplayName=Share values|ClampMin=0|ClampMax=300>;

var int mDwellings[ECreatureTier.CTIER_MAX] <DisplayName=Dwellings>; // unreal doesn't let me delete this ... if removed -> crash on garbage collection

var(Buildings) array<H7RMGBuildingData> mPredefinedBuildings<DisplayName=Predefined Buildings>;
var            array<H7RMGBuildingData> mAdditionalBuildings<DisplayName=Additional Buildings>;

var protectedwrite array<H7RMGZoneTemplate> mConnectedZones;
var protectedwrite array<H7RMGZoneTemplate> mGraphConnections;
var protectedwrite array<H7RMGZoneTemplate> mCreatedConnections;
var protectedwrite ERMGConnectorType mConnectorType;

var protectedwrite int mDistanceToStart;
var protectedwrite int mTmpDistance;

var protectedwrite Vector2D mPosition;

var protectedwrite float mTmpVDistance;

var protectedwrite int mIndex;
var protectedwrite int mTheme;

var protectedwrite array<H7RMGCell> mAreaCells;
var protectedwrite array<H7RMGCell> mAreaBorderCells;

var protectedwrite array<H7RMGBuilding> mPlacedBuildings;
var protectedwrite array<H7VisitableSite> mSpawnedBuildings;
var protectedwrite array<H7AdventureArmy> mSpawnedArmies;
var protectedwrite array<H7RandomCreatureStack> mSpawnedCreatures;

var protectedwrite H7PlayerStart mPlayerStart;

var protectedwrite array<H7RMGCellPair> mEntranceCells;
var protectedwrite array<H7RMGCell> mEntrances;

var protectedwrite int mGridIndex;

var private EPlayerNumber mPlayerNum;

function int SortComparer( H7RMGBuildingData data1, H7RMGBuildingData data2 )
{
	return ( ( data1.Building.mDimension.X + data1.Building.mDimension.Y ) - ( data2.Building.mDimension.X + data2.Building.mDimension.Y ) );
}

event SortBuildings()
{
	local int i, townIndex;
	local int tmpAmount;
	local H7RMGBuilding tmpBuilding;

	mPredefinedBuildings.Sort( SortComparer );
	mAdditionalBuildings.Sort( SortComparer );

	for( i = 0; i < mAdditionalBuildings.Length; ++i )
	{
		if( mAdditionalBuildings[i].Building.mBuildingType == ERBT_TOWN || mAdditionalBuildings[i].Building.mBuildingType == ERBT_FORT )
		{
			if( i != 0 )
			{
				townIndex = i;
				break;
			}
		}
	}
	if( townIndex > 0 )
	{
		tmpAmount = mAdditionalBuildings[0].Amount;
		tmpBuilding = mAdditionalBuildings[0].Building;

		mAdditionalBuildings[0].Amount = mAdditionalBuildings[townIndex].Amount;
		mAdditionalBuildings[0].Building = mAdditionalBuildings[townIndex].Building;

		mAdditionalBuildings[townIndex].Amount = tmpAmount;
		mAdditionalBuildings[townIndex].Building = tmpBuilding;
	}
}

function int ShuffleComparer( H7RMGBuilding a, H7RMGBuilding b )
{
	return class'H7RMGRandom'.static.GetIntRange(-1000,1000);
}

event ShuffleArray( out array<H7RMGBuilding> arr )
{
	arr.Sort(ShuffleComparer);
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
// (cpptext)
// (cpptext)
// (cpptext)
