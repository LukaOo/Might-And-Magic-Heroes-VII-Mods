//=============================================================================
// H7RMGMain
//=============================================================================
//
//
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7RMGMain extends Object
	native(RMG);

var private H7EditorAdventureGridManager    mGridManager;
var private H7RMGProperties			        mProperties;
var private array<H7RMGGrid>				mGridList;
var private H7RMGRandom						mRandom;
var private H7RMGPathfinder					mPathfinder;
var private H7RMGLandscapeBuilder           mLandscapeBuilder;
var private H7RMGAreaTemplateBuilder        mAreaTemplateBuilder;
var private H7RMGTemplateSpawner            mTemplateSpawner;

event Init( out H7RMGProperties properties )
{
	local int i;

	mRandom = new(self) class'H7RMGRandom'();
	mLandscapeBuilder = new(self) class'H7RMGLandscapeBuilder'();
	mAreaTemplateBuilder = new(self) class'H7RMGAreaTemplateBuilder'();
	mTemplateSpawner = new(self) class'H7RMGTemplateSpawner'();

	for( i = 0; i < properties.SurfaceTopologySetupPath.Length; ++i )
	{
		properties.SurfaceTopologySetup[i] = H7RMGTopologySetup( DynamicLoadObject( properties.SurfaceTopologySetupPath[i], class'H7RMGTopologySetup' ) );
	}
	
	for( i = 0; i < properties.UndergroundTopologySetupPath.Length; ++i )
	{
		properties.UndergroundTopologySetup[i] = H7RMGTopologySetup( DynamicLoadObject( properties.UndergroundTopologySetupPath[i], class'H7RMGTopologySetup' ) );
	}
	
	mProperties = properties;
	InitNative( properties );
	;
}

function private native InitNative( out H7RMGProperties properties );

function private native SpawnLandscapes();

function static native bool LoadMap(EMapSize mapSize);

function GenerateMap()
{
	GenerateMapNative();
}

function native GenerateMapNative();

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
