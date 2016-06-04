//================================================ Might & Magic - Heroes VII =
// H7UnitCoverManager
//=============================================================================
// Manager for the cover of one unit (creature stack) in combat map
// Unit needs to be direct neighbour of the obstacle (diagonal neighborhood counts as well)
// Cover area is defined by the area inside two rays coming from the center of the creature (taking cover) towards both outer edges of the obstacle.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7UnitCoverManager extends Object
	native;

var protected H7CreatureStack mOwner;

var protected array<H7CombatMapCell> mCoverCells; // enemy range units that stand on these cells will do less damage to the owner

var protected array<Vector> mCoverLines; // lines that are used to calculate the cover cells (it is the direction, we take as origin the variable mLinesOrigin)
var protected Vector mLinesOrigin;

var protected H7CombatMapCell mCellLastUpdate;

// properties Get/Set methods
// ==========================
function array<Vector> GetCoverLines() { return mCoverLines; }
function Vector GetLinesOrigin() { return mLinesOrigin; }
function H7CreatureStack GetOwner() { return mOwner; }

// methods ...
// ===========

function Init( H7CreatureStack owner )
{
	mOwner = owner;
}

// if ownerCell is not set, we will use the current cell position of the owner
function array<H7CombatMapCell> GetCoverCells( optional H7CombatMapCell ownerCell )
{ 
	local H7CombatMapCell hoverCell, cell;
	local array<H7CombatMapCell> attackPositions, reachableCells, merged, neighbours;
	local bool canReach;
	mOwner.GetPathfinder().GetReachableCells( mOwner.GetMovementPoints(), reachableCells );

	attackPositions = class'H7CombatMapGridController'.static.GetInstance().GetCurrentAttackPosition();
	if( ownerCell == none || attackPositions.Length > 0 )
	{
		if( attackPositions.Length > 0 )
		{
			hoverCell = attackPositions[0];
		}
		else
		{
			hoverCell = class'H7CombatMapGridController'.static.GetInstance().GetCurrentMouseOverCell();
		}
	}
	else
	{
		hoverCell = ownerCell;
	}
	if( hoverCell == none )
	{
		mCoverCells.Length = 0;
		mCellLastUpdate = none;
		mLinesOrigin = vect( 0, 0, 0 );
		return mCoverCells;
	}

	neighbours = hoverCell.GetNeighbours();
	if( hoverCell.mIsMouseOverMaster == 2 )
	{
		canReach = true;
		merged.AddItem( hoverCell );
		foreach neighbours( cell )
		{
			if( cell.mIsMouseOverMaster == 2 )
			{
				merged.AddItem( cell );
			}
		}
	}

	foreach merged( cell )
	{
		if( cell.mPosition.X < hoverCell.mPosition.X || cell.mPosition.Y < hoverCell.mPosition.Y )
		{
			hoverCell = cell;
		}
		if( reachableCells.Find( cell ) == INDEX_NONE )
		{
			canReach = false;
		}
	}

	if( hoverCell != none && hoverCell.GetMaster() != mCellLastUpdate )
	{
		if( reachableCells.Find( hoverCell.GetMaster() ) != INDEX_NONE && !canReach || canReach )
		{
			UpdateCoverCells( hoverCell.GetMaster() );
		}
		else
		{
			mCoverCells.Length = 0;
			mLinesOrigin = vect( 0, 0, 0 );
		}
		mCellLastUpdate = hoverCell.GetMaster();
	}
	//if( mCellLastUpdate != ownerCell )
	//{
	//	UpdateCoverCells( ownerCell );
	//	mCellLastUpdate = ownerCell;
	//}
	
	return mCoverCells; 
}

// if coveredCells is not set, we will use the current covered cells of the owner with its current position
function bool IsInCover( array<H7CombatMapCell> attackerCells, optional array<H7CombatMapCell> coveredCells, optional H7CombatMapCell defenderCell )
{
	local H7CombatMapCell currentCell;
	local int numCoverdCells;

	if( coveredCells.Length == 0 )
	{
		coveredCells = GetCoverCells();
	}

	if( defenderCell == none )
	{
		defenderCell = mOwner.GetCell();
	}

	// check if is covered by the siege walls
	if( defenderCell.IsSiegeWallCover() && !HasClearShot( attackerCells, coveredCells, defenderCell ) )
	{
		return true;
	}

	if( mOwner.HasCoverFromEffects() )
	{
		return true;
	}

	numCoverdCells = 0;
	foreach attackerCells( currentCell )
	{
		if( coveredCells.Find( currentCell ) != -1 )
		{
			++numCoverdCells;
		}
	}

	return numCoverdCells >= (float(attackerCells.Length) / 2.f);
}

function bool HasClearShot( array<H7CombatMapCell> attackerCells, optional array<H7CombatMapCell> coveredCells, optional H7CombatMapCell defenderCell )
{
	local H7CombatMapCell cell, lineCell;
	local array<H7CombatMapCell> lineCells;
	local H7IEffectTargetable target;

	cell = attackerCells[0].GetMaster();

	cell.mGridController.GetLineCellsIntersectingGrid( lineCells, cell.mPosition, defenderCell.mPosition );
	
	foreach lineCells( lineCell )
	{
		
		if( lineCell == defenderCell ) // if we get to the creature before an obstacle, no cover
		{
			return true;
		}
		target = lineCell.GetTargetable();
		if( ( H7CombatMapWall( target ) != none || H7CombatMapGate( target ) != none || H7CombatMapTower( target ) != none ) && 
			H7CombatObstacleObject( target ).GetHitpoints() > 0 ) // if there is a combat obstacle in the way
		{
			return false;
		}
	}

	return true;
}

native protected function UpdateCoverCells( H7CombatMapCell ownerCell );

// update mLinesOrigin with the center of all the cells
native protected function UpdatedLinesOrigin( array<H7CombatMapCell> cells );

protected event float GetRDiff( Rotator A, Rotator B)
{
	return RDiff( A, B );
}
