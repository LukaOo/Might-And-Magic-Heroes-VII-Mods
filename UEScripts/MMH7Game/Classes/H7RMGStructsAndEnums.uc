//=============================================================================
// H7RMGStructsAndEnums
//=============================================================================
//
//
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7RMGStructsAndEnums extends Object
	dependsOn( H7MapInfo )
	native(RMG);

enum ERMGTeleporterType
{
	ERTT_TELEPORTER,
	ERTT_UNDERGROUND_ENTRANCE,
	ERTT_UNDERGROUND_EXIT,
};

enum ELayerType
{
	ELT_PLANE,
	ELT_CLIFF,
	ELT_COAST,
	ELT_DECORATION,
	ELT_ROAD,
	ELT_CUSTOM,
};

enum EMapSize
{
	MS_TINY<DisplayName="Small">,
	MS_SMALL<DisplayName="Normal">,
	MS_MEDIUM<DisplayName="Big">,
	MS_LARGE<DisplayName="Huge">,
};

enum EMineType
{
    MINE_GOLD,
    MINE_WOOD,
    MINE_CRYSTAL,
    MINE_ORE,
    MINE_STARSILVER,
    MINE_DRAGONSTEEL,
    MINE_SHADOWSTEEL,
};

enum ECritterStrength
{
	CR_WEAK,
	CR_MEDIUM,
	CR_HARD,
	CR_INSANE,
};

enum ECritterAmount
{
	ECA_FEW,
	ECA_SOME,
	ECA_MANY,
	ECA_HORDE,
};

enum ERMGBuildingType
{
	ERBT_UNDEFINED,
	ERBT_TOWN,
	ERBT_FORT,
	ERBT_DWELLING,
	ERBT_MINE,
	ERBT_NEUTRAL_SITE,
	ERBT_PICKUP_RESOURCE,
	ERBT_PICKUP_ITEM,
	ERBT_TELEPORTER,
	ERBT_RESOURCE_CLUSTER,
};

enum EAoCLordType
{
	ALT_NONE<DisplayName=None>,
	ALT_TOWN<DisplayName=Town>,
	ALT_FORT<DisplayName=Fort>,
};

enum ERoundingType
{
	RT_FLOOR,
	RT_CEIL,
};

enum ERMGConnectorType
{
	ERMGCT_NONE,
	ERMGCT_A,
	ERMGCT_B,
};

enum ERMGZoneShare
{
	EZS_TREASURE_SHARE<DisplayName=Treasure share>,
	EZS_ARTIFACT_SHARE<DisplayName=Artifact share>,
	EZS_BATTLE_SITE_SHARE<DisplayName=Battle-Site share>,
	EZS_TEMP_BUFF_SHARE<DisplayName=Temp Buff share>,
	EZS_PERM_BONUS_SHARE<DisplayName=Permanent Bonus share>,
	EZS_ARC_LIB_SHARE<DisplayName=Arcane-Lib. share>,
	EZS_RES_BUILD_SHARE<DisplayName=Resource buildiung share>,
	EZS_MISC_BUILD_SHARE<DisplayName=Misc building share>,
};

enum ETownLevel
{
	ETL_LEVEL_1,
	ETL_LEVEL_2,
	ETL_LEVEL_3,
	ETL_LEVEL_4,
};

enum EFortLevel
{
	EFL_LEVEL_1,
	EFL_LEVEL_2,
	EFL_LEVEL_3,
};

struct native H7PerlinNoiseProperties
{
	var() int   Iterations;
	/** The height of the noise */
	var() float Amplitude;
	/** The Size of the noise (smaller value means bigger noise) */
	var() float Frequency;
	/** The density of the noise (less means more spaces) */
	var() float Persitency;
	/** Amount of sub-noise iterations */
	var() int   Octaves;
	var() float HeightMod1;
	var() float HeightMod2;
	var() float PeturbationModifer;
	var() bool  IncludeMapBorder;
	/** Amount to raise globally */ 
	var() int   GlobalRaiseLower;
	/** Treshold to Raise globally (0 - 1) - used for Blocking Noise only */
	var() float GlobalRaiseLowerThreshold;

	structdefaultproperties
	{
		Amplitude = 3.0f
		Frequency = 0.009f
		Persitency = 0.6f
		Octaves = 6

		HeightMod1 = 4.0f
		HeightMod2 = 4.0f

		PeturbationModifer = 0.2
		IncludeMapBorder = false

		Iterations = 1
	}
};

struct native H7RMGErosionProperties
{
	/** Amount of Erosion Iterations */
	var() int Iterations;
	/** Threshold to for the Erosion - Higher means more areas will be smoothed */
	var() int Treshold;
	/** How much the Erosion smooths when it operates */
	var() int Smoothness;

	structdefaultproperties
	{
		Iterations = 100
		Smoothness = 25
		Treshold = 400
	}
};

struct native H7RMGWeightmapProperties
{
	/** Slopes higher than this value get applied a Cliff layer */
	var() int MaxCliffSlope;
	/** Height modifier for putting foliage into the coast */
	var() float CoastHeightMod;
	var() H7PerlinNoiseProperties DecoNoise;
	var() bool UseErosionMapCapture;

	structdefaultproperties
	{
		MaxCliffSlope = 35
		CoastHeightMod = 0.5f
		DecoNoise = { ( Iterations = 1, Amplitude = 2.7f, Frequency = 0.02f, Persitency = 0.5f, Octaves = 2 ) }
		UseErosionMapCapture = false
	}
};

struct native H7RMGLayerInfo
{
	var() ELayerType LayerType;
	var() bool NoBlend;
	var() name LayerName;
	var() int Position<ClampMin=0>;
	var() H7LandscapeGameLayerInfoData LayerGameData;
	var   array<byte> Data;
};

struct native H7RMGLayerInfos
{
	var() array<H7RMGLayerInfo> Infos;
};

struct native H7RMGFoliageProperties
{
	var() bool DisableFoliage<DisplayName=Disable Foliage>;
	var() array<StaticMesh> FoliageMeshes;
	var() float FoliageDensity<DisplayName=Foliage Density|ClampMin=0.0|ClampMax=1.0>;
	var() int MaxClusterSize<DisplayName=Max Cluster Size|ClampMin=0>;
	var() float MinScale<DisplayName=Scale Min|ClampMin=0.0|ClampMax=5.0>;
	var() float MaxScale<DisplayName=Scale Max|ClampMin=0.0|ClampMax=5.0>;
	var() bool AllignToNormal;
	var() bool RandomYaw<DisplayName=Random Yaw>;
	var() bool BlockActors<DisplayName=Block Actors>;
	var() bool CollideActors<DisplayName=Collide Actors>;

	structdefaultproperties
	{
		FoliageDensity = 0.2
		MaxClusterSize = 100
		minScale = 0.05f
		maxScale = 0.4f
		AllignToNormal = false
		RandomYaw = true
		BlockActors = true
		CollideActors = true
		DisableFoliage = false
	}
};

struct native H7RMGProperties
{
	var() EMapSize                  MapSize;
	var() bool                      WithUnderground;
	var() int                       UndergroundPercentage<ClampMin=25|ClampMax=75>;
	var() bool                      LoadMap;
    var() int                       PlayerNumber<ClampMin=2|ClampMax=8>;
	var() int                       Seed<ClampMin=0>;

	var() float                     Richness<ClampMin=0.0|ClampMax=2.0>;
	var() float                     BuildingDensity<ClampMin=0.0|ClampMax=2.0>;
	var() int                       BaseCritterStrength<ClampMin=10|ClampMax=10000>;

	var array<H7RMGTopologySetup>   SurfaceTopologySetup;
	var array<H7RMGTopologySetup>   UndergroundTopologySetup;
	var() array<string>             SurfaceTopologySetupPath;
	var() array<string>             UndergroundTopologySetupPath;

	var() string                    DataPath;
	var H7RMGData                   Data;

	var() bool                      WithTearOfAsha;
	var() bool                      UseErosionMapCapture;

	var() bool                      UseTemplate;
	var() H7RMGConnectionPrefab     ConnectionTemplate<DisplayName="Template">;

	var() bool                      SkipGameplayObjects;

	structdefaultproperties
	{
		MapSize = MS_TINY
		Richness = 1.0
		BuildingDensity = 1.0
		BaseCritterStrength = 500
		PlayerNumber = 2
		LoadMap = true
		WithUnderground = false
		UndergroundPercentage = 34

		WithTearOfAsha = true
		UseErosionMapCapture = false
		UseTemplate = false

		SkipGameplayObjects = false
	}
};

struct native H7RMGAtmosphericSetup
{
	var() bool OverrideAtmospherics;
	var() float LightBrightness<EditCondition=OverrideAtmospherics>;
	var() Color LightColor<EditCondition=OverrideAtmospherics>;
	var() Color LightEnvironmentColor<EditCondition=OverrideAtmospherics>;
	var() float LightEnvironmentIntensity<EditCondition=OverrideAtmospherics>;
	var() float CloudShadowsDensity<EditCondition=OverrideAtmospherics>;
	var() float AtmosphericFogDensity<EditCondition=OverrideAtmospherics>;
	var() float AtmosphericFogBrightness<EditCondition=OverrideAtmospherics>;
	var() float AtmosphericFogHeightFalloff<EditCondition=OverrideAtmospherics>;
	var() LinearColor AtmosphericFogColor<EditCondition=OverrideAtmospherics>;
	var() float AtmosphericFogHeightOffset<EditCondition=OverrideAtmospherics>;

	structdefaultproperties
	{
		LightBrightness = 5.0
		LightColor = (R=255,G=219,B=182)
		LightEnvironmentColor = (R=176,G=218,B=255)
		LightEnvironmentIntensity = 1.0
		CloudShadowsDensity = 0.7
		AtmosphericFogDensity = 0.4
		AtmosphericFogBrightness = 1.5
		AtmosphericFogHeightFalloff = 1.0
		AtmosphericFogColor = (R=0.4,G=0.6,B=1.0)
		AtmosphericFogHeightOffset = 0.0
	}
};

struct native H7RMGCellPair
{
	var H7RMGCell A;
	var H7RMGCell B;
};

struct native H7RMGZoneTemplateRule
{
	var() EAoCLordType LordType<DisplayName=AoC Lord-Type>;
	var() int MaxAmount<DisplayName=Max Amount|ClampMin=0>;
};

struct native H7RMGGridColumns
{
	var array<H7RMGCell> Row;
};

struct native H7RMGGridPart
{
	var array<H7RMGGridColumns> Part;
};

struct native H7RMGCellPathfinderData
{
	var H7RMGCell   Previous;
	var float       GScore;
	var float       FScore;
};

struct native H7RMGZoneInfluence
{
	var H7RMGZoneTemplate ZoneTemplate;
	var float InfluenceValue;

	structdefaultproperties
	{
		ZoneTemplate = none
		InfluenceValue = 0.0f
	}
};

struct native H7RMGCreatureArray
{
	var() array<H7Creature> Creatures;
};

struct native H7RMGRandomCreatureArray
{
	var() array<H7RandomCreatureStack> RandomCreatures;
};

struct native H7RMGFactionData
{
	var() H7Faction     Faction;

	var H7RMGBuilding Towns[ETownLevel.ETL_LEVEL_MAX]; // unreal doesn't want me to delete this :|
	var H7RMGBuilding Forts[EFortLevel.EFL_LEVEL_MAX]; // unreal doesn't want me to delete this :|
	var H7RMGBuilding Dwellings[ECreatureTier.CTIER_MAX]; // unreal doesn't want me to delete this :|
	var() H7RMGCreatureArray Creatures[ECreatureTier.CTIER_MAX];
};

struct native H7RMGBuildingData
{
	var() H7RMGBuilding Building<DisplayName=Building>;
	var() int Amount<DisplayName=Amount>;
};

struct native H7RMGZoneTemplates
{
	var() array<H7RMGZoneTemplate> Templates;
};

struct native H7RMGShareBuildings
{
	var() bool UseRichness;
	var() bool UseBuildingDensity;
	var() bool OnlyOneOfEach;
	var() bool UniformDistribution;
	var() bool MostExpensiveFirst;
	var() ERMGZoneShare ShareType;

	var() array<H7RMGBuilding> Objects;
};

struct native H7RMGPath
{
	var array<Vector2D> Path;
};

struct native H7RMGPathCells
{
	var array<H7RMGCell> Path;
};

struct native H7RMGLandscapeProperties
{
	var() IntPoint	GridSize;
	var() IntPoint	QuadCount;
	var() int       ComponentSizeQuads;
	var() int       SubsectionSizeQuads;
	var() Vector    Scale3D;
	var() int	    AverageZoneSize<ClampMin=1|ClampMax=4000>;

	structdefaultproperties
	{
		ComponentSizeQuads = 63
		SubsectionSizeQuads = 63
		AverageZoneSize = 2500
		Scale3D = { ( X = 48, Y = 48, Z = 256 ) }
	}
};

struct native H7RMGBuildingLight
{
	var() PointLight Light;
	var() Vector Offset;
};

struct native H7RMGTemplateConnections
{
	var() H7RMGZoneTemplate ZoneTemplate<DisplayName="Zone Template">;
	var() array<int> ConnectedIndexes<DisplayName="Connected Zone Indexes">;
};

struct native H7RMGLandscapeTheme
{
	var() string Name;
	var() H7RMGTopologySetup Setup;
};
