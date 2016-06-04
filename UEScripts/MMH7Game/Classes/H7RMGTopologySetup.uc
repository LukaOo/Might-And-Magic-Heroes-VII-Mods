//=============================================================================
// H7RMGTopologySetup
//=============================================================================
//
//
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7RMGTopologySetup extends Object
	native(RMG)
	hidecategories(Object);

var() protectedwrite H7PerlinNoiseProperties	mPerlinNoise<DisplayName="Blocking Noise">;
var() protectedwrite H7PerlinNoiseProperties    mBaseNoise<DisplayName="Base Noise">;
var() protectedwrite H7RMGErosionProperties		mErosion<DisplayName="Erosion">;
var() protectedwrite H7RMGWeightmapProperties	mWeightMap<DisplayName="Weightmap Properties">;
var() protectedwrite H7RMGFoliageProperties		mFoliageProperties<DisplayName="Foliage Properties">;
var() protectedwrite H7RMGLayerInfos			mLayerInfo<DisplayName="Layer Infos">;
var() protectedwrite MaterialInstanceConstant	mLandscapeMaterial<DisplayName="Landscape Material">;
var() protectedwrite MaterialInstanceConstant   mWaterMaterial<DisplayName="Water Material">;
var() protectedwrite array<H7RMGLayerInfo>      mWaterLayerInfos<DisplayName="Water Layer Infos">;
var() protectedwrite H7RMGAtmosphericSetup		mAtmosphereProperties<DisplayName="Atmosphere Properties">;
var() protectedwrite int                        mGridBorderExtensionRadius<DisplayName="Grid Border Extension">;
var() protectedwrite int                        mUnblockedRadiusForBuildings<DisplayName="Unblocked radius for buildings">;
var() protectedwrite int                        mUnblockedRadiusForRoads<DisplayName="Unblocked radius for roads">;
var() protectedwrite H7RMGBuildingLight         mBuildingLights<DisplayName="Building Lights">;


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
