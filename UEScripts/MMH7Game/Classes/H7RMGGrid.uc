//=============================================================================
// H7RMGGrid
//=============================================================================
//
//
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7RMGGrid extends Object
	native(RMG);

var private Vector mWorldPosition;

var private Landscape mLandscape;
var private array<H7RMGGridColumns> mGrid;
var private H7AdventureMapGridController mEditorGrid;

var private array<H7RMGPath> mRoadPaths;
var private array<H7RMGPath> mInvisibleRoadPaths;
var private array<H7RMGPathCells> mRoadPathCells;

native function H7RMGCell GetCellByIntPoint( IntPoint p );
native function H7RMGCell GetCellByPoint( int x, int y );

native function int GetWidth() const;
native function int GetHeight() const;

native function InitRMGGrid( Landscape landscape, out H7RMGProperties props );

native function AddZoneInfluence( H7RMGZoneTemplate temp, int radius );

native function GetGridPart( out array<H7RMGGridColumns> part, INT fromX, INT toX, INT fromY, INT toY);
native function GetGridParts( out array<H7RMGGridPart> parts, INT amount, INT buffer );

native function InitEditorGrid( H7EditorAdventureGridManager gridManager, bool skipGameplayObj );

native function InitAoCs();

native function DestroyGrid();

native function ShuffleCells( out array<H7RMGCell> arr );

function int ShuffleComparer( H7RMGCell a, H7RMGCell b )
{
	return class'H7RMGRandom'.static.GetIntRange(-1000,1000);
}

event ShuffleArray( out array<H7RMGCell> arr )
{
	arr.Sort(ShuffleComparer);
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
