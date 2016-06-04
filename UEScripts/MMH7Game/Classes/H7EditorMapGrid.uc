//=============================================================================
// H7EditorMapGrid
//
// Base class for editor grids (Adventure, Combat, ...)
//
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EditorMapGrid extends Actor
	native
	hidecategories(Object,Attachment,Collision,Physics,Advanced,Debug,Mobile);

const CELL_SIZE = 192.0f;


/** The X size in amount of tiles */
var(Properties) protected int mGridSizeX<DisplayName=Grid Width|ClampMin=1|ClampMax=400>;
/** The Y size in amount of tiles */
var(Properties) protected int mGridSizeY<DisplayName=Grid Height|ClampMin=1|ClampMax=400>;

var protected int mID;

//	Only keep this as long as the level designers use older maps that are not centralized
var(Developer) protected bool mSynchLandscapeAndGridPosition<DisplayName=Synch Landscape position with Grid>;	

var editoronly protected transient Landscape mLandscape;
var editoronly protected transient vector mInitialLandscapePosition;
var editoronly protected StaticMeshComponent mEditorPreviewMesh;

function int GetGridSizeX() { return mGridSizeX; }
function int GetGridSizeY() { return mGridSizeY; }

native function Vector GetCenter();

function Actor GetMouseHitActorAndLocation(out Vector hitLocation){ return none; }

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

