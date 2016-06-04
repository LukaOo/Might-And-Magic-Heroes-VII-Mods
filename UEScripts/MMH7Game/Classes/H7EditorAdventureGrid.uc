//=============================================================================
// H7EditorAdventureGrid
//=============================================================================
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EditorAdventureGrid extends H7EditorMapGrid
	native
	config( game )
	dependsOn( H7AdventureObject, H7VisitableSite, H7AreaOfControlSite, H7AreaOfControlSiteLord, H7AreaOfControlSiteVassal, H7AdventureMapCell, H7WalkableObject, H7MapInfo );

var config array<MapSizeDefinition> MapSizeDefinitions;

var(Properties) public bool mRecaptureMinimapOnSave;
var(Properties) public Texture2D mMinimapCapture;

var(Properties) protected editconst config int cMinimumAdventureGridWidth<DisplayName=Minimum Grid Width>;
var(Properties) protected editconst config int cMinimumAdventureGridHeight<DisplayName=Minimum Grid Height>;
var(Properties) protected editconst config int cMaximumAdventureGridWidth<DisplayName=Maximum Grid Width>;
var(Properties) protected editconst config int cMaximumAdventureGridHeight<DisplayName=Maximum Grid Height>;

var(Properties) protected editconst config int cMaximumTileGradient<DisplayName=Maximum Tile Gradient Degree>;

/** Show the grid preview ingame */
var(Properties) protected bool mShowGameGrid<DisplayName=Show Grid Preview during Game>;
var private editoronly transient bool mDebugGridActive;
var private editoronly transient MaterialInstanceConstant mDebugGridMaterialInstance;

/** Show the Area of Control preview in the editor */
var(Properties) protected editoronly bool mShowAocInEditor<DisplayName=Show AoC Preview in Editor>;
/** Show the Area of Control preview ingame */
var(Properties) protected editoronly bool mShowAocInGame<DisplayName=Show AoC Preview during Game>;
var private editoronly transient bool mAoCPreviewActive;
var private editoronly transient MaterialInstanceConstant mDebugAoCMaterialInstance;

/** Show the combat layer preview in the editor */
var(Properties) protected editoronly bool mShowCombatListInEditor<DisplayName=Show Combat List Preview in Editor>;
/** Show the combat layer preview ingame */
var(Properties) protected editoronly bool mShowCombatListInGame<DisplayName=Show Combat List Preview during Game>;
var private editoronly transient bool mCombatListPreviewActive;
var private editoronly transient MaterialInstanceConstant mDebugCombatListMaterialInstance;

/** Show the blocking preview in the editor */
var(Properties) protected editoronly bool mShowBlockingInEditor<DisplayName=Show Blocking Preview in Editor>;
/** Show the blocking preview ingame */
var(Properties) protected editoronly bool mShowBlockingInGame<DisplayName=Show Blocking Preview during Game>;
var private editoronly transient bool mBlockingPreviewActive;
var private editoronly transient MaterialInstanceConstant mDebugBlockingMaterialInstance;

/** Show the FoW Override preview in the editor */
var(Properties) protected editoronly bool mShowFoWOverrideInEditor<DisplayName=Show FoWOverride Preview in Editor>;
/** Show the FoW Override preview ingame */
var(Properties) protected editoronly bool mShowFoWOverrideInGame<DisplayName=Show FoWOverride Preview during Game>;
var private editoronly transient bool mFoWOverridePreviewActive;
var private editoronly transient MaterialInstanceConstant mDebugFoWOverrideMaterialInstance;

/** Camera Height tool in the editor */
var private editoronly transient H7EditorCameraHeightTool mCameraHeightTool;

var protected array<H7AdventureMapCell> mAdventureCells;
var protected array<H7VisitableSite> mVisitableActorList;

var protected array<H7AreaOfControlSiteLord> mAreaOfControlLords;
var protected array<H7AreaOfControlSiteVassal> mAreaOfControlVassals;
var protected array<int> mUsedAreaOfControls;

var private editoronly native transient pointer mScanGridData{struct H7LandscapeScanData_GridData};

native function UpdateDebugGrid();
native function UpdateTerrainData();

function H7AdventureMapCell GetCell(int X, int Y)
{
	return mAdventureCells[ (X + (Y * mGridSizeX)) ];
}

native function float GetHeight( vector pos );
function array<int> GetAoCArray() { return mUsedAreaOfControls; }

native function bool IsCameraPosInsideGrid(float worldPosX, float worldPosY);

native function GetCameraHeightAt(float worldPosX, float worldPosY, out float outHeight);

native function EH7MapSize CalculateMapSize();

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

