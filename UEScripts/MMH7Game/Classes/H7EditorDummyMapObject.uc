//=============================================================================
// H7EditorDummyMapObject
//=============================================================================
// Base class for testing stuff on code among the editor
//=============================================================================
// Copyright 2014 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EditorDummyMapObject extends StaticMeshActor
	implements( H7IEditorTerrainScan )
	native(Ed)
	placeable;

native function OnTerrainChange(LandscapeLayerInfoObject newLayer, LandscapeProxy newLandscape);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

