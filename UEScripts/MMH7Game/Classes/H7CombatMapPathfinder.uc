//=============================================================================
// H7CombatMapPathfinder
//=============================================================================
//
// This pathfinder uses the Dijkstra's algorithm
// http://en.wikipedia.org/wiki/Dijkstra's_algorithm
// 
// To be used first need to do the SetUp and then can be called the GetPath functions
//
// To show the debug, write in the console: showdebug pathfinder
//
//=============================================================================
// Copyright 1998-2013 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7CombatMapPathfinder extends Object
	dependson(H7StructsAndEnumsNative)
	native;

const INFINITE = 1000000.0f;

var protected H7CreatureStack mCreatureStack;

var array<H7PathfinerGridColumns> mCellDataArray;

var int mLastSetupDone;

// methods ...
// ===========

function InitPathfinderForStack( H7CreatureStack creatureStack )
{
	local H7PathfinerGridColumns column;
	local int i, numCols, numRows;

	mCreatureStack = creatureStack;
	mLastSetupDone = -1;

	// init the cell data array
	numCols = class'H7CombatMapGridController'.static.GetInstance().GetGridSizeX();
	numRows = class'H7CombatMapGridController'.static.GetInstance().GetGridSizeY();
	column.Row.Add( numRows );
	for( i=0; i<numCols; ++i )
	{
		mCellDataArray.AddItem( column );
	}
}

native protected function float GetCellDistance( H7CombatMapCell cell );

native protected function SetCellDistance( H7CombatMapCell cell, float newDistance );

native protected function H7CombatMapCell GetCellPrevious( H7CombatMapCell cell );

native protected function SetCellPrevious( H7CombatMapCell cell, H7CombatMapCell newPrevious );

// setup the pathfinder to be used by the creatureStack
native protected function Setup();

// return the path to the target cell
native function bool GetPath( IntPoint targetPos, out array<H7CombatMapCell> path );

// return the path to the target cell
native function bool GetPathByCell( H7CombatMapCell targetCell, out array<H7CombatMapCell> path );

// returns the path to the closest cell of targetCells
native function bool GetShortestPath( array<H7CombatMapCell> targetCells, out array<H7CombatMapCell> path );

native protected function InitCells( out array<H7CombatMapCell> queue );

native protected function UpdateCells();

// returns the distance between 2 cells
native protected function float GetDistance( H7CombatMapCell originCell, H7CombatMapCell destcell );

native function float GetPathLength( array<H7CombatMapCell> path );

// returns false if the creature cannot move to the targetCell because at least one cell of the cells that she will occupy is blocked
native function bool CanMoveToCell( H7CombatMapCell targetCell );

// update the position of the targetCell in the ordered queue
native protected function Reorder( out array<H7CombatMapCell> queue, H7CombatMapCell targetCell );

function RenderDebugPathfinderInfo( Canvas myCanvas )
{
	local H7CombatMapGrid combatMapGrid;
	local Color lTextColor, lBgColor;
	local Font lTextFont;
	local Vector lTextLocation, startLinePoint, endLinePoint;
	local float lTextLength, lTextHeight;
	local string displayText;
	local int i,j;

	DoSetupIfNeeded();

	combatMapGrid = class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid();

	lTextColor = MakeColor( 0, 0, 0, 255 );
	lBgColor = MakeColor( 255, 255, 255, 255 );

	lTextFont = Font'enginefonts.TinyFont';
	myCanvas.Font = lTextFont;
	myCanvas.DrawColor = lTextColor;

	for( i=0; i<mCellDataArray.Length; ++i ) 
	{
		for( j=0; j<mCellDataArray[i].Row.Length; ++j )
		{	
			// render the cell distance
			displayText = "(" @ mCellDataArray[i].Row[j].mPathfinderDistance @ ")";
			myCanvas.StrLen( displayText, lTextLength, lTextHeight );
			lTextLocation = myCanvas.Project( combatMapGrid.GetCell( i, j ).GetCenterPos() );
			lTextLocation.X -= lTextLength / 2;
	
			myCanvas.SetPos( lTextLocation.X, lTextLocation.Y );
			myCanvas.DrawColor = lBgColor;
			myCanvas.DrawRect(lTextLength, lTextHeight);
	
			myCanvas.SetPos( lTextLocation.X, lTextLocation.Y );
			myCanvas.DrawColor = lTextColor;
			myCanvas.DrawText( displayText );

			// render the line connections
			if( mCellDataArray[i].Row[j].mPathfinderPrevious != none )
			{
				startLinePoint = myCanvas.Project( combatMapGrid.GetCell( i, j ).GetCenterPos() );
				endLinePoint = myCanvas.Project( mCellDataArray[i].Row[j].mPathfinderPrevious.GetCenterPos() );
				myCanvas.Draw2DLine( startLinePoint.X, startLinePoint.Y, endLinePoint.X, endLinePoint.Y, lTextColor );
			}
		}
	}
}

native function int GetReachableCells( int movementPoints, out array<H7CombatMapCell> reachableCells );

native protected function DoSetupIfNeeded();

native function ForceUpdate();
