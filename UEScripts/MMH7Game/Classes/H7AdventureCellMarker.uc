//=============================================================================
// H7AdventureCellMarker
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7AdventureCellMarker extends H7UnrealObjectCellMarker
	dependson(H7EditorAdventureGridManager,H7EditorCellOverlayComponent)
	implements (H7IQuestTarget)
	placeable
	native;

enum CellMarker_Shape
{
	CMS_BOX,
	CMS_CYLINDER,
	CMS_SINGLECELL,
	CMS_USERPICK
};

var(CellMarker) CellMarker_Shape mShape;

var(CellMarker) bool mSkipBlocked;

var(CellMarker_Editor) editoronly float mEditorVisibilityHeight;
var(CellMarker_Editor) editoronly color mEditorTriggerColor;

var editoronly protected array<H7AdventureMapCell> mUserPickedCells;

var protected array<H7AdventureMapCell> mMarkedCells; //assigned automatically

var protected savegame int mID;

native function bool Contains(H7AdventureMapCell cell);

// H7IQuestTarget
function int GetQuestTargetID() { return mID; }
function bool IsHidden() { return false; }
function bool IsMovable() { return false; }
function ClearQuestFlag() {}
function AddQuestFlag() {}
function H7AdventureMapCell GetCurrentPosition()
{
	return class'H7AdventureGridManager'.static.GetInstance().GetClosestGridToPosition(Location).GetCellByWorldLocation(Location);
}

simulated event InitMarker()
{
	mID = class'H7ReplicationInfo'.static.GetInstance().GetNewID();
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

