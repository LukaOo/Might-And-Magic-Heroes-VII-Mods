//=============================================================================
// H7CombatMapGrid
//=============================================================================
//
// ...
// 
//=============================================================================
//
// handles the Grid array structure
//
//=============================================================================
// Copyright 1998-2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CombatMapGrid extends Object
	dependson(H7CombatMapInfo, H7StructsAndEnumsNative)
	native;


var protected array<GridColumns> mGridArray;
var protected H7CombatMapGridDebug mDebug;
var protected array<H7CombatMapCell> mAttackPositionCache;
var protected int mAttackPositionCacheDefenderID,mAttackPositionCacheAttackerID;

// this is now the value from the overwrite that is set in specific combat maps in the editor
var protected bool mGridAllowsFlee;
var protected bool mGridAllowsSurrender;

simulated function SetGridAllowsFlee(bool canFlee) { mGridAllowsFlee = canFlee; }
simulated function SetGridAllowsSurrender(bool canSurrender) { mGridAllowsSurrender = canSurrender; }
simulated function bool GridAllowsFlee() { return mGridAllowsFlee; }
simulated function bool GridAllowsSurrender() { return mGridAllowsSurrender; }

simulated function array<GridColumns>  GetGridArray() { return mGridArray; }

simulated function H7CombatMapGridDebug GetCombatGridDebug() { return mDebug; }

simulated function SetupDebug(H7CombatMapGridController gridController)
{
	mDebug = new class'H7CombatMapGridDebug';
	mDebug.Setup(gridController);
}

native simulated function int GetXSize();

native simulated function int GetYSize();

native simulated function H7CombatMapCell GetCell( int x, int y );

// doesnt do any limit check
simulated function H7CombatMapCell GetCellFast(int x, int y)
{
	return mGridArray[y].Row[x];
}

simulated function AddCol()
{
	local GridColumns GC;
	mGridArray.AddItem(GC);
}

simulated function AddRowCell(int col, H7CombatMapCell cell)
{
	mGridArray[col].Row.AddItem(cell);
}

native simulated function int GetAllReachableCells( H7CreatureStack creatureStack, out array<H7CombatMapCell> resultArray, optional int movePoints = -1 );

native simulated function H7CombatMapCell GetNeighbourCellInDirection( H7CombatMapCell cell, EDirection direction );

simulated function int GetAllPlaceableCells( int tacticsPlaceableColumns, bool ignoreUnits, Out array<H7CombatMapCell> result ) 
{
	local int x,y;
	local int xStart, xEnd;

	result.Remove( 0, result.Length ); // clear array

	if( tacticsPlaceableColumns >= 0 ) // positive = attacker = left?
	{
		xStart=class'H7EditorCombatGrid'.const.WARFARE_UNIT_GRID_BUFFER_SIZE / 2; 
		xEnd=class'H7EditorCombatGrid'.const.WARFARE_UNIT_GRID_BUFFER_SIZE / 2+tacticsPlaceableColumns;
	}
	else // negativ = defender = right?
	{
		xStart=GetXSize()+tacticsPlaceableColumns-class'H7EditorCombatGrid'.const.WARFARE_UNIT_GRID_BUFFER_SIZE / 2; 
		xEnd=GetXSize()-class'H7EditorCombatGrid'.const.WARFARE_UNIT_GRID_BUFFER_SIZE / 2;
	}

	for( x=xStart; x<xEnd; x++ )
	{
		for( y=0; y<GetYSize(); y++ )
		{
			if( ( ignoreUnits || !GetCell(x,y).HasCreatureStack() ) && !GetCell(x,y).HasObstacle() )
			{
				result.AddItem( GetCell(x,y) );
			}
		}
	}

	return result.Length;
}

// puts on surroundingCells all the cells that are around the targetCell taking into account the depth
native simulated function GetCellSurrounding( out array<H7CombatMapCell> surroundingCells, H7CombatMapCell targetCell, int depth, optional ECellSize cellSize = CELLSIZE_1x1);

// returns in hitCells a group of cells around the targetCell that has the form of the creatureSize
// the current function is taking the optimized solution, the one where the center position of the hitcells is closer to the parameter pos
function GetHitCells( ECellSize creatureSize, H7CombatMapCell targetCell, Vector pos, bool onlyForeshadowCells, out array<H7CombatMapCell> hitCells )
{
	local array<H7CombatMapCell> checkCells, possibleHitCells;
	local H7CombatMapCell cell, originalTargetCell;
	local float distance, currentSolutionDistance;

	hitCells.Length = 0; // clear array

	originalTargetCell = targetCell;

	currentSolutionDistance = 10000000.0f; // infinite

	GetCellSurrounding( checkCells, targetCell, creatureSize );
	foreach checkCells( cell )
	{
		cell.GetCellsHitByCellSize( creatureSize, possibleHitCells );
		if( possibleHitCells.Find( originalTargetCell ) != -1 && AreAllCells( possibleHitCells, true, onlyForeshadowCells ) )
		{
			distance = VSize(possibleHitCells[0].GetCenterByCreatureDim( creatureSize+1 ) - pos);
			if( distance < currentSolutionDistance )
			{
				currentSolutionDistance = distance;
				hitCells = possibleHitCells;
			}
		}
	}
}

/**
 * Gets cells in a the shape specified as offsets from the targetCell
 * 
 * @param targetCell    The central cell
 * @param shape         The offsets from the central point from which to draw the shape
 * 
 * */
native function GetCellsFromShape( H7CombatMapCell targetCell, array<IntPoint> shape, out array<H7CombatMapCell> cells, optional ECellSize originSize = CELLSIZE_1x1 );

/**
 * Gets cells in a rectangle from the grid based on a center point and the
 * rectangle dimensions (X&Y) in IntPoint form
 * 
 * @param targetCell    The central cell
 * @param dim           The dimensions of the rectangle
 * 
 * */
native function GetCellsFromDimensions( H7CombatMapCell targetCell, IntPoint dim, out array<H7CombatMapCell> cells, optional ECellSize originSize = CELLSIZE_1x1, optional bool filled = true );

native function GetCellsOnEllipse( H7CombatMapCell targetCell, IntPoint dim, out array<H7CombatMapCell> cells );

simulated protected function bool AreAllCells( array<H7CombatMapCell> cells , bool areNotNone, bool areForeshadowed )
{
	local int i;

	for( i = 0; i < cells.Length; ++i )
	{
		if( ( areNotNone && cells[i] == none ) || ( areForeshadowed && !cells[i].IsForeshadow() ) )
		{
			return false;
		}
	}
	return true;
}

simulated function ClearForeshadow()
{
	local int x,y;

	for(y=0;y<GetYSize();y++)
	{
		for(x=0;x<GetXSize();x++)
		{
			mGridArray[y].Row[x].SetForeshadow(false,false);
			mGridArray[y].Row[x].SetForeshadowAlt(false);
		}
	}
}

simulated function bool AreInMeleeRange( H7Unit stack0, H7IEffectTargetable target )
{
	// check neighboring grid cells of stack0 if any is overlapping with stack1 base cells
	local array<H7CombatMapCell>	s0Base;
	local IntPoint					s0GP;
	local H7CombatMapCell			s0Cell;
	local array<H7CombatMapCell>	s1Base;
	local IntPoint					s1GP;
	local H7CombatMapCell			s1Cell;
	 
	if( stack0 == None || target == None ) 
	{
		return false;
	}

	s0GP = stack0.GetGridPosition();
	s0Cell = GetCell(s0GP.X,s0GP.Y);
	s0Base = s0Cell.GetMergedCells();

	s1GP = target.GetGridPosition();
	s1Cell = GetCell(s1GP.X,s1GP.Y);
	s1Base = s1Cell.GetMergedCells();

	foreach s0Base( s0Cell )
	{
		s0GP = s0Cell.GetCellPosition();
		foreach s1Base( s1Cell )
		{
			s1GP = s1Cell.GetCellPosition();
			if( (s0GP.X-1) == s1GP.X && (s0GP.Y-1) == s1GP.Y ) return true;
			if( (s0GP.X  ) == s1GP.X && (s0GP.Y-1) == s1GP.Y ) return true;
			if( (s0GP.X+1) == s1GP.X && (s0GP.Y-1) == s1GP.Y ) return true;
			if( (s0GP.X-1) == s1GP.X && (s0GP.Y  ) == s1GP.Y ) return true;
			if( (s0GP.X+1) == s1GP.X && (s0GP.Y  ) == s1GP.Y ) return true;
			if( (s0GP.X-1) == s1GP.X && (s0GP.Y+1) == s1GP.Y ) return true;
			if( (s0GP.X  ) == s1GP.X && (s0GP.Y+1) == s1GP.Y ) return true;
			if( (s0GP.X+1) == s1GP.X && (s0GP.Y+1) == s1GP.Y ) return true;
		}
	}

	return false;
}

simulated function bool IsUnitIsInMoveRange( H7Unit active, H7Unit target )
{
	local IntPoint	s0GP;
	local IntPoint	s1GP;
	local int		distance;

	s0GP = active.GetGridPosition();
	s1GP = target.GetGridPosition();

	distance = class'H7Math'.static.GetDistanceIntPoints( s0GP, s1GP ); 
	
	distance -= 1;	//	Attacking the enemy does not cost movement points
	
	if( distance <= active.GetMovementPoints()) 
	{
		return true;
	}

	return false;

}

simulated function bool UnitsInHalfRange( H7Unit stack0, H7Unit stack1 )
{
	local IntPoint	s0GP;
	local IntPoint	s1GP;
	local int		gridHalfRange;
	local int		distance;
	local Vector    distanceVector;
	local int       playableXSize;

	if( stack0 == None || stack1 == None ) 
	{
		return false;
	}

	s0GP = stack0.GetGridPosition();
	s1GP = stack1.GetGridPosition();

	distanceVector.X = ( s0GP.X - s1GP.X );
	distanceVector.Y = ( s0GP.Y - s1GP.Y );
	distance = VSize( distanceVector );
	
	playableXSize = GetXSize() - class'H7EditorCombatGrid'.const.WARFARE_UNIT_GRID_BUFFER_SIZE;
	// we take largest grid dimension
	if( playableXSize >= GetYSize() ) 
	{
		gridHalfRange = playableXSize / 2 + playableXSize % 1;
	}
	else
	{
		gridHalfRange = playableXSize / 2 + playableXSize % 1;
	}

	if( distance <= gridHalfRange )
	{
		return true;
	}		

	return false;
}

/**
 * Called every frame if melee attack
 * Gets the attack position (cells) from which a melee attack will be executed
 * 
 * */
simulated function GetAttackPosition( H7CombatMapCell hitCell, Vector hitLocation, H7CreatureStack attacker, out array<H7CombatMapCell> attackCells )
{
	local Rotator cursorRot;
	local H7Unit unit;
	local array<H7CombatMapCell> validPositions, dummyArray;
	local H7CombatMapCell attackPositionToPreview;
	local Vector defenderCenter;
	local int cellSizeInt;
	local H7CombatObstacleObject obstacle;
	local H7IEffectTargetable target;

	dummyArray.Length = 0;
	attackCells.Length = 0; // clear array

	unit = hitCell.GetUnit();
	if(hitCell.HasObstacle())
	{
		obstacle = hitCell.GetObstacle();
	}
	target = hitCell.GetTargetable();

	if( target != None && attacker != none &&
		( unit != none || obstacle != none ) && attacker != None && attacker.GetPreparedAbility() != none && attacker.GetPreparedAbility().CanCastOnTargetActor( target ) ) 
	{
		// melee or ranged attack (if a range attack unit has an enemy unit adjacent, then its considered a melee unit)
		if( ( !attacker.IsRanged() || attacker.IsRanged() && attacker.UsesAmmo() && attacker.GetAmmo() <= 0 ) ||
			HasAdjacentCreature( attacker, none, true, dummyArray ) 
			|| attacker.IsRanged() && !attacker.GetPreparedAbility().IsRanged()) // We are ranged but we cannot use ranged (debuffs etc.)
		{
			GetAllAttackPositionsAgainst( target, attacker, validPositions ); 
			if(validPositions.Length > 0)
			{
				if( unit != none )
				{
					cellSizeInt = unit.GetUnitBaseSizeInt();
				}
				else if( obstacle != none )
				{
					if( obstacle.GetObstacleBaseSizeX() == 1 )
					{
						cellSizeInt = CELLSIZE_1x1+1;
					}
					else
					{
						cellSizeInt = CELLSIZE_2x2+1;
					}
				}
				defenderCenter = GetCellByIntPoint( target.GetGridPosition() ).GetCenterByCreatureDim( cellSizeInt );
				cursorRot = rotator(defenderCenter - hitLocation);
				attackPositionToPreview = GetNearestAttackPosition(validPositions,cursorRot.Yaw,target.GetGridPosition(), attacker);
				GetCellsIfPlacedHere( attackPositionToPreview, attacker, attackCells );
			}
		}
	}
}
/** stack = generates all neighbor cells and checks them
 *  - if one has a unit
 *  - if one has a specific unit
 *  - if one in part of a future attack position
 */
native simulated function bool HasAdjacentCreature( H7Unit unit, H7Unit specificUnit, bool checkAllegiance, array<H7CombatMapCell> futureSpecificPosition );

simulated function H7CombatMapCell GetNearestAttackPosition(array<H7CombatMapCell> attackPositions,int cursorRotation, Intpoint defendPosition, H7CreatureStack attacker)
{
	local H7CombatMapCell attackPosition, bestAttackPosition;
	local int attackRotationDiff,minRotationDiff,attackRotation;
	minRotationDiff = MaxInt;

	foreach attackPositions(attackPosition)
	{
		attackRotation = GetAttackPositionRotation(attackPosition, GetCellByIntPoint(defendPosition), attacker);
		
		attackRotationDiff = class'H7Math'.static.GetRotationDiff(cursorRotation,attackRotation);
		if(attackRotationDiff < minRotationDiff)
		{
			bestAttackPosition = attackPosition;
			minRotationDiff = attackRotationDiff;
		}
	}
	return bestAttackPosition;
}

simulated function int GetAttackPositionRotation(H7CombatMapCell attackPosition,H7CombatMapCell defendPosition, H7CreatureStack attacker)
{
	local vector a,d;
	local Rotator r;
	local int cellSize;

	a = attackPosition.GetCenterByCreatureDim( attacker.GetUnitBaseSizeInt() );
	
	if( defendPosition.GetUnit() != none )
	{
		d = defendPosition.GetCenterByCreatureDim( defendPosition.GetUnit().GetUnitBaseSizeInt() );
	}
	else if( defendPosition.HasObstacle() )
	{
		if( defendPosition.GetObstacle().GetObstacleBaseSizeX() == 1 )
		{
			cellSize = CELLSIZE_1x1+1;
		}
		else
		{
			cellSize = CELLSIZE_2x2+1;
		}
		d = defendPosition.GetCenterByCreatureDim( cellSize );
	}

	r = rotator(d-a); // to - from
	
	return r.Yaw;
}


// optimized of GetCellsIfPlacedHere and GetAllAttackPositionsAgainst
// - this function looks at all cells that are green atm (can be reached by the current stack) 
// - and checks if selectedStack (assumption is, that this is identical with the current stack) can be placed on the given cell
simulated native function bool CurrentStackCanMoveHere( H7CombatMapCell cell, H7CreatureStack selectedStack );

simulated native function float CurrentStackMoveDistance( H7CombatMapCell cell, H7CreatureStack selectedStack );

// works with upper-left mode
simulated function GetCellsIfPlacedHere( H7CombatMapCell cell, H7CreatureStack attacker, out array<H7CombatMapCell> attackingStackCells )
{
	local H7CombatMapCell currentCell;
	local int attackerSize,i,j;
	
	attackingStackCells.Remove( 0, attackingStackCells.Length ); // clear array

	attackerSize = attacker.GetUnitBaseSizeInt();
	for(i=0; i < attackerSize; i++)
	{
		for(j=0; j < attackerSize; j++)
		{	
			if(cell.GetCellPosition().X+i < GetXSize() && cell.GetCellPosition().Y+j < GetYSize())
			{
				attackingStackCells.AddItem(GetCell(cell.GetCellPosition().X+i,cell.GetCellPosition().Y+j));
			}
			else
			{
				attackingStackCells.Remove(0, attackingStackCells.Length);
			}
		}
	}

	foreach attackingStackCells(currentCell)
	{
		if(currentCell.IsBlocked(attacker))
		{
			attackingStackCells.Remove(0, attackingStackCells.Length);
			break;
		}
	}
}

simulated function bool CanMoveTo( array<H7CombatMapCell> hitCells, H7CreatureStack attacker )
{
	local H7CombatMapCell cell;
	local bool isUnitInTheWay;

	if(hitCells.Length == 0 )
	{
		return false;
	}

	foreach hitCells( cell )
	{
		if( !isUnitInTheWay )
		{
			isUnitInTheWay = (cell.HasUnit() && !cell.GetUnit().IsDead() && cell.GetUnit() != attacker || cell.HasObstacle() && cell.GetObstacle().GetHitpoints() > 0 && cell.GetObstacle().GetObstacleType() != OT_MOAT && !cell.IsGatePassage() );
			if( isUnitInTheWay )
			{
				break;
			}
		}
	}

	return !isUnitInTheWay;
}

// returns the cell where the selected creature has to move (depending on the mouseover-highlighted cell array)
simulated function H7CombatMapCell GetTargetMoveCell( array<H7CombatMapCell> hitCells )
{
	local H7CombatMapCell cell, targetCell;

	if( hitCells.Length == 0 )
	{
		return none;
	}

	targetCell = hitCells[0];
	foreach hitCells( cell )
	{
		if( targetCell.GetCellPosition().X > cell.GetCellPosition().X || targetCell.GetCellPosition().Y > cell.GetCellPosition().Y )
		{
			targetCell = cell;
		}
	}
	
	return targetCell;
}

simulated function ResetAttackPositionCache()
{
	mAttackPositionCache.Remove(0,mAttackPositionCache.Length);
	mAttackPositionCacheAttackerID = 0;
	mAttackPositionCacheDefenderID = 0;
}

simulated function GetAllAttackPositionsAgainst( H7IEffectTargetable defender, H7Unit attacker, out array<H7CombatMapCell> validPositions )
{
	local int attackerDim,defenderDim,x,y;
	local H7CombatMapCell attackPositionCell;
	local array<H7CombatMapCell> mergedCells;
	local IntPoint attackPosition;

	validPositions.Remove(0,validPositions.Length);

	// defender == attacker -> don't attack yourself, silly Cavalier
	if( defender == none || attacker == none || defender == attacker ) return;

	// cache check
	// !!! the check was to trigger happy and caused issues with AI internal out of order unit selection and artifical movement point modifications to create 'what if' scenarious
	//if( defender.GetID() == mAttackPositionCacheDefenderID && attacker.GetID() == mAttackPositionCacheAttackerID )
	//{
	//	foreach mAttackPositionCache(attackPositionCell)
	//	{
	//		validPositions.AddItem(attackPositionCell);
	//	}
	//	return;
	//}

	// normal calculation
	validPositions.Remove( 0, validPositions.Length ); // clear array

	if( H7Unit( defender ) != none )
	{
		defenderDim = H7Unit( defender ).GetUnitBaseSizeInt();
	}
	else if( H7CombatObstacleObject( defender ) != none )
	{
		if( H7CombatObstacleObject( defender ).GetObstacleBaseSizeX() == 1 )
		{
			defenderDim = CELLSIZE_1x1+1;
		}
		else
		{
			defenderDim = CELLSIZE_2x2+1;
		}
		
	}
	attackerDim = attacker.GetUnitBaseSizeInt();

	// -a -> +d
	for(x=-attackerDim;x<=defenderDim;x++)
	{
		for(y=-attackerDim;y<=defenderDim;y++)
		{
			// skip it, if it is not an outer position on the "ring"
			if(x==-attackerDim || x==defenderDim || y==-attackerDim || y==defenderDim)
			{
				// ok
			}
			else
			{
				continue; // skip
			}
			
			
			attackPosition.X = x+defender.GetGridPosition().X;
			attackPosition.Y = y+defender.GetGridPosition().Y;

			attackPositionCell = GetCellByIntPoint(attackPosition);

			if(attackPositionCell != none)
			{
				if( H7CreatureStack( attacker ) != none )
				{
					mergedCells = H7CreatureStack( attacker ).GetCell().GetMergedCells();
				}
				if( H7CreatureStack( attacker ) != none && 
					( CurrentStackCanMoveHere( attackPositionCell, H7CreatureStack( attacker ) ) || 
					mergedCells.Find( attackPositionCell ) != INDEX_NONE && attackPositionCell.mGridController.CanPlaceCreature( attackPositionCell.GetGridPosition(), H7CreatureStack( attacker ) ) ) )
				{
					validPositions.AddItem(attackPositionCell);
				}
				else if( H7WarUnit( attacker ) != none )
				{
					validPositions.AddItem(attackPositionCell);
				}
			}
		}
	}

	// cache
	mAttackPositionCache.Remove(0,mAttackPositionCache.Length);
	mAttackPositionCache = validPositions;
	mAttackPositionCacheDefenderID = defender.GetID();
	mAttackPositionCacheAttackerID = attacker.GetID();




}

native simulated function H7CombatMapCell GetCellByIntPoint( Intpoint p );

native simulated function H7CombatMapCell GetCellByPos( int x, int y );

native simulated function H7CombatMapCell FindNearestCellInRange( Intpoint p, EDirection direction, int distance);

// returns a list of the cells that are neighbours of targetCells, the cells that are in targetCells will be not included
native simulated function array<H7CombatMapCell> GetNeighbourCells( array<H7CombatMapCell> targetCells );

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
