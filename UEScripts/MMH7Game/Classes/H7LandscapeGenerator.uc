class H7LandscapeGenerator extends BrushBuilder
	config(Landscape)
	native(Ed);

struct native LandscapeGeneratorMapSizePreference
{
	var EH7MapSize MapSize;
	var int Width;
	var int Height;
	var int SubsectionSizeQuads;
	var int NumSubsections;
};

struct native LandscapeGeneratorTypePreference
{
	var H7LandscapeType LandscapeType;
	var MaterialInterface Material;
	var array<name> LayerNames;
	var array<H7LandscapeGameLayerInfoData> GameData;
	var name DefaultLayer;
};

var config editoronly array<LandscapeGeneratorMapSizePreference> MapSizePreferences;
var config editoronly array<LandscapeGeneratorTypePreference> TypePreferences;
var config editoronly array<LandscapeGeneratorTypePreference> TypePreferences_Underground;
var config editoronly vector UndergroundOffset;
var config editoronly vector WaterOffset;
var config editoronly vector SkyboxOffset;
var config editoronly vector LandscapeDrawscale;
var config editoronly color UndergroundLightColor;
var config editoronly color UndergroundLightEnvironmentColor;
var config editoronly float UndergroundLightEnvironmentIntensity;
var config editoronly float UndergroundLightBrightness;
var config editoronly bool UndergroundLightCastShadows;
var config editoronly LinearColor UndergroundFogColor;
var config editoronly float UndergroundFogBrightness;
var config editoronly float UndergroundFogDensity;

var() protected bool mRebuild<DisplayName=Rebuild>;
var() protected EH7MapSize mMapSizePredefined<DisplayName="Predefined Map Size">;
var() protected H7LandscapeType mLandscapeType<DisplayName="Landscape Type">;

var() protected int mSizeWidth<DisplayName="Width">;
var() protected int mSizeHeight<DisplayName="Height">;
var() protected Vector mLocation<DisplayName="Location">;
var() editconst protected MaterialInterface	LandscapeMaterial<DisplayName="Landscape Material">;

var protected int ComponentSizeQuads; // Total number of quads in each component
var() protected int SubsectionSizeQuads<DisplayName="Subsection Size Quads">; // Number of quads for a subsection of a component. SubsectionSizeQuads+1 must be a power of two.
var() protected int NumSubsections<DisplayName="NumSubsections">; // Number of subsections in X and Y axis

var transient array<name> mLayerNames;
var transient array<H7LandscapeGameLayerInfoData> mGameData;
var transient name mDefaultLayer;
var transient bool mInited;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

event bool Build()
{
	if (!mInited)
	{
		SetDataFromConfig();
		mInited = true;
	}
	if ( mRebuild )
	{
		ActualCreateLandscape();
	}
	return true;
}

native function SetDataFromConfig();
native function Landscape ActualCreateLandscape();

