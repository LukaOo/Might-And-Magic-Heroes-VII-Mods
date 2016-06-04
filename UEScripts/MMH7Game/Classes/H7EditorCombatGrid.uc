//=============================================================================
// H7EditorCombatGrid
//
// TODO: Find out how to share properties (cell size, min x dimension) with 
// other gameplay classes (H7CombatMapCell)
//
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7EditorCombatGrid extends H7EditorMapGrid
	native
	config(game)
	dependsOn(H7CombatMapCell, H7CombatObstacleObject , H7StructsAndEnumsNative);

const WARFARE_UNIT_GRID_BUFFER_SIZE = 4;

/** The X size in amount of tiles */
var protected int mAdjustedGridSizeX;

var protected H7CombatMapGridDecalComponent mGridDecal;

// these are now the editor grid overwrite combat map settings to disallow flee/surrender on this specific map
var(Properties) protected bool mCanFlee<DisplayName="Allow Flee">;
var(Properties) protected bool mCanSurrender<DisplayName="Allow Surrender">;

/** The distance the attacking hero has to the combat grid */
var(Developer) protected IntPoint mAttackerHeroOffset<DisplayName="Attacking Hero Offset">;
/** The distance the attacking war units have to the combat grid */
var(Developer) protected int mAttackerWarUnitOffset[3]<DisplayName="Attacking War Unit Offsets">;
/** The distance the defending hero has to the combat grid */
var(Developer) protected IntPoint mDefenderHeroOffset<DisplayName="Defending Hero Offset">;
/** The distance the defending war units have to the combat grid */
var(Developer) protected int mDefenderWarUnitOffset[3]<DisplayName="Defending War Unit Offsets">;

var(Properties) protected archetype array<H7CombatObstacleObject> mRandomObstacleList<DisplayName="Random Obstacles">;

// list of obstacles in the combat map (Siege obstacles will be replaced by the faction specific siege obstacle at the start of the combat)
var(Developer) protected editconst array<H7Obstacle> mObstacles<DisplayName="Obstacles">;

// list of decorations in the combat map (decoration used in a siege combat map)
var(Developer) protected editconst array<H7SiegeMapDecoration> mDecorations<DisplayName=Decorations>;

// must be the same as MinimumSize in H7CombatMapGridControllerProperties
var(Developer) protected editconst config int cMinimumCombatGridWidth<DisplayName="Minimum Grid Width">;
var(Developer) protected editconst config int cMinimumCombatGridHeight<DisplayName="Minimum Grid Height">;

// must be the same as MaximumSize in H7CombatMapGridControllerProperties
var(Developer) protected editconst config int cMaximumCombatGridWidth<DisplayName="Maximum Grid Width">;
var(Developer) protected editconst config int cMaximumCombatGridHeight<DisplayName="Maximum Grid Height">;

//the grid decal color in game
var(Developer) bool mUseCustomDecalColor<DisplayName="Use Custom Grid Color">;
var(Developer) LinearColor mCustomDecalColor<DisplayName="Grid Color"|Editcondition=mUseCustomDecalColor>;

/** Whether combat is on a ship or not. This will trigger an event that activates Sea Warfare and other ability effects. */
var(Properties) bool mIsShip<DisplayName="Is Ship Map (important for Duel Maps)">;

/** Special combat music for this Combatmap */
var(Combat_Map_Audio)  protected AkEvent mSpecialMapMusic         <DisplayName="Special music for this Combat Map">;
/**Special ambience for Combatmaps. Use Basic Ambiences only. Otherwise it will overlap */
var(Combat_Map_Audio)  protected AkEvent mSpecialCombatMapAmbient <DisplayName="BASIC Ambience (Combat Maps only)">;

var protected array<H7CombatMapCell> mCombatCells;
var protected array<H7CombatMapCell> mObstaclePlacementCells;

var protected StaticMeshComponent mAttackerPreviewMesh;
var protected StaticMeshComponent mDefenderPreviewMesh;
var protected StaticMeshComponent mAttackerWarUnitPreviewMesh[3];
var protected StaticMeshComponent mDefenderWarUnitPreviewMesh[3];

function H7CombatMapGridDecalComponent GetDecal() { return mGridDecal; }

function int GetGridSizeX() { return mAdjustedGridSizeX; }
function int GetGridSizeY() { return mGridSizeY; }

function IntPoint GetAttackerHeroOffset() { return mAttackerHeroOffset; }
function IntPoint GetDefenderHeroOffset() { return mDefenderHeroOffset; }

function AkEvent GetMapSpecialMusic() { return mSpecialMapMusic; }
function AkEvent GetMapSpecialAmbient() { return mSpecialCombatMapAmbient; }

function Vector GetCenter()
{
	local Vector center;
	center.X = Location.X + 0.5f * CELL_SIZE * mAdjustedGridSizeX;
	center.Y = Location.Y + 0.5f * CELL_SIZE * mGridSizeY;
	center.Z = Location.Z;
	return center;
}

function Vector GetDeploymentZoneCenter(float val)
{
	local Vector center;
	//to decide if the deployment area is attacker or defender
	center.X = Location.X + (1 - val) * CELL_SIZE * mAdjustedGridSizeX;
	center.Y = Location.Y + 0.5f * CELL_SIZE * mGridSizeY;
	center.Z = Location.Z;
	return center;
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

