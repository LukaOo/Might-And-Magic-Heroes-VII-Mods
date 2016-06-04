//=============================================================================
// H7SeqAct_CellLayerDataChange
//
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqAct_CellLayerDataChange extends SequenceAction
	implements(H7IAliasable, H7IActionable)
	native;

/** The new Terrain Configuration (Movement cost, music, combat maps) that should be applied on the target cells */
var(Properties) protected archetype H7AdventureLayerCellProperty mCellLayerData<DisplayName="New Terrain Configuration">;
var(Properties) protected H7AdventureCellMarker mCellMarker<DisplayName="Target Cell Marker">;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
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

