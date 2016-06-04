//=============================================================================
// H7SeqAct_CellChange
//
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqAct_CellChange extends SequenceAction
	dependson( H7CellChangerActor )
	implements(H7IAliasable, H7IActionable)
	native;

/** The new movement type that it should apply on the target cells */
var(Properties) protected ECellMovementType mMovementType<DisplayName="New Movement Type">;
var(Properties) protected H7AdventureCellMarker mCellMarker<DisplayName="Target Cell Marker">;
var(Properties) protected H7CellChangerActor mCellChanger<DisplayName="Terrain Modifier Changer">;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 3;
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

