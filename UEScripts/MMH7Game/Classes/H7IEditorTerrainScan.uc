//=============================================================================
// H7IEditorTerrainScan
//=============================================================================
// This interface is used to handle the terrain change below the object
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
interface H7IEditorTerrainScan
	native(Ed);

native function OnTerrainChange(LandscapeLayerInfoObject newLayer, LandscapeProxy newLandscape);
