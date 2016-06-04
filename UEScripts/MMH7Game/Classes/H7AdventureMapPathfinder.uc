//=============================================================================
// H7AdventureMapPathfinder
//=============================================================================
//
// A* algorithm implementation to find the shortest path between two 
// H7AdventureMapCell objects. http://en.wikipedia.org/wiki/A*_search_algorithm
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7AdventureMapPathfinder extends Object
	native
	dependson(H7EffectContainer);

var protected native H7AdventureGridManager			mGridManager;
var protected native array<H7AdventureMapCell>      mOpenList;
var protected float                                 mGeneralTerrainCostModifier;
var protected H7AdventureArmy                       mArmy;
var protected array<H7Ship>                         mShips;
var protected bool                                  mIgnoreFoW;
var protected array<H7AdventureLayerCellProperty>   mMoveCostsTerrain;
var protected array<float>                          mMoveCostsValue;


const INFINITE = 1000000.0f;

function native Init();
function native float DiagonalDistanceFromIntPoints( IntPoint a, IntPoint b );
function native bool CanMoveToCell( H7AdventureMapCell targetCell, H7AdventureMapCell pathEndCell, H7Player currentPlayer, H7AdventureArmy ignoreArmy, bool hasShip );
function native bool CanMoveToVisitable( H7AdventureMapCell targetCell, H7VisitableSite pathEndSite, H7Player currentPlayer, H7AdventureArmy ignoreArmy, bool hasShip );
function native bool CanMoveToArmy( H7AdventureMapCell targetCell, H7Player currentPlayer, H7AdventureArmy ignoreArmy, bool hasShip );
function native float GetMovementCost( H7AdventureMapCell originCell, H7AdventureMapCell destCell, H7AdventureMapCell pathEndCell, H7Player currentPlayer, H7AdventureArmy ignoreArmy, bool hasShip, optional bool recalculatePassability );
function native float GetMovementCostSimple( H7AdventureMapCell originCell, H7AdventureMapCell destCell, H7AdventureMapCell pathEndCell );
function native array<H7AdventureMapCell> FindPath( H7AdventureMapCell startCell, H7AdventureMapCell targetCell, H7Player currentPlayer, bool hasShip, optional bool ignoreFoW = false );
function native float FindPathLengthByWayPoints( H7AdventureMapCell startCell, H7AdventureMapCell targetCell );

function native GetNeighbours( out array<H7AdventureMapCell> neighbours, H7AdventureMapCell cell, H7AdventureMapCell targetCell, H7Player currentPlayer, H7AdventureArmy ignoreArmy, bool hasShip );
function native bool IsReachable( H7AdventureMapCell startCell, H7AdventureMapCell targetCell, H7Player currentPlayer, bool hasShip, optional bool ignoreFoW = false );
function native bool GetReachableSitesAndArmies( H7AdventureMapCell startCell, H7Player currentPlayer, bool hasShip, out array<H7VisitableSite> sites, out array<H7AdventureArmy> armies, out array<float> sitesDistance, out array<float> armiesDistance, optional bool ignoreFoW = false, optional float allowedTime = 0.0f );

function array<H7AdventureMapCell> GetPath( H7AdventureMapCell startCell, H7AdventureMapCell targetCell, H7Player currentPlayer, bool hasShip, optional bool ignoreFoW = false, optional bool checkReachability = true )
{
	local array<H7AdventureMapCell> empty;
	mArmy = startCell.GetArmy();
	mIgnoreFoW = ignoreFoW;
	empty = empty;
	if( startCell == none )
	{
		;
		ScriptTrace();
	}

	if( mArmy != none && mArmy.GetHero() != none ) 
	{
		mGeneralTerrainCostModifier = mArmy.GetHero().GetTerrainCostModifier();
	}
	else
	{
		mGeneralTerrainCostModifier = 1.0f;
	}

	if( !checkReachability || IsReachable( startCell, targetCell, currentPlayer, hasShip, ignoreFoW ) )
	{
		return FindPath( startCell, targetCell, currentPlayer, hasShip, ignoreFoW );
	}
	else
	{
		return empty;
	}
}

function H7AdventureMapCell GetClosestReachableShipCell( H7AdventureMapCell currentCell, H7AdventureMapCell targetCell, H7Player currentPlayer, bool hasShip )
{
	local H7Ship tmpShip;
	local array<H7Ship> ships;
	local H7AdventureMapCell shipCell;
	local array<H7AdventureMapCell> shipPath;
	local int i, j;
	local H7AdventureGridManager gridManager;

	gridManager = class'H7AdventureGridManager'.static.GetInstance();

	foreach mShips( tmpShip )
	{
		shipCell = gridManager.GetCellByWorldLocation( tmpShip.Location );
		;
		shipPath = FindPath( currentCell, shipCell, currentPlayer, hasShip );
		if( shipPath.Length > 0 && !shipCell.IsBlocked() )
		{
			;
			ships.AddItem( tmpShip );
		}
		else
		{
			;
		}
	}

	for( i = 0; i < ships.Length; i++ )
	{
		for( j = 0; j < ships.Length-1; j++ )
		{
			if( ManhattanDistanceFromIntPoints( gridManager.GetCellByWorldLocation( ships[j].Location ).GetCellPosition(), targetCell.GetCellPosition() ) > ManhattanDistanceFromIntPoints( gridManager.GetCellByWorldLocation( ships[j+1].Location ).GetCellPosition(), targetCell.GetCellPosition() ) )
			{
				tmpShip = ships[j];
				ships[j] = ships[j+1];
				ships[j+1] = tmpShip;
			}
		}
	}
	if( ships.Length == 0) return none;


	return gridManager.GetCellByWorldLocation( ships[0].Location );
}

function array<float> GetPathCosts( array<H7AdventureMapCell> path, H7AdventureMapCell startCell, optional float movePoints = 0, optional out int numOfWalkableCells )
{
	local array<float> costs;
	local float cost, totalCost;
	local int i, idx;
	local H7AdventureHero currentHero;
	local array<H7AdventureLayerCellProperty> terrains;
	local array<float> terrainCosts;

	if( path.Length == 0 ) { return costs; }
	totalCost = totalCost;
	numOfWalkableCells = 0;
	if( startCell == none )
	{
		startCell = path[0];
	}
	else
	{
		path.InsertItem( 0, startCell );
	}
	if( startCell.GetArmy() != none )
	{
		currentHero = startCell.GetArmy().GetHero();
	}

	for( i = 0; i < path.Length - 1; i++ )
	{
		if( path[i+1].mMovementType != MOVTYPE_IMPASSABLE && currentHero != none )
		{
			idx = terrains.Find( path[i+1].GetSourceLayerCellData() );
			if( idx == INDEX_NONE )
			{
				cost = currentHero.GetMoveCostForTerrainType( path[i+1].GetSourceLayerCellData(), path[i+1].mMovementType );
				terrains.AddItem( path[i+1].GetSourceLayerCellData() );
				terrainCosts.AddItem( cost );
			}
			else
			{
				cost = terrainCosts[ idx ];
			}
		}
		else
		{
			cost = path[i+1].GetSourceLayerCellData().MovementCost;
		}

		if( path[i+1].GetTeleporter() != none && i == path.Length-2 || path[i].GetTeleporter() != none && path[i+1].GetTeleporter() != none )
		{
			if( startCell.GetArmy() != none )
			{
				cost += currentHero.GetModifiedStatByID( STAT_PICKUP_COST );
				;
			}
		}

		if( path[i].GetCellPosition().X != path[i+1].GetCellPosition().X && path[i].GetCellPosition().Y != path[i+1].GetCellPosition().Y )
		{
			cost *= 1.41f; // diagonal cost
		}

		if( path[i+1].GetVisitableSite() != none && path[i+1].GetVisitableSite().IsA( 'H7Ship' ) || 
		path[i].mMovementType == MOVTYPE_WATER && path[i+1].mMovementType != MOVTYPE_WATER || 
		path[i].mMovementType != MOVTYPE_WATER && path[i+1].mMovementType == MOVTYPE_WATER )
		{
			cost += startCell.GetArmy().GetHero().GetMovementPoints() / 4; // boarding cost
		}
		movePoints -= cost;
		totalCost += cost;
		costs.AddItem( cost );
		;

		if( movePoints > 0.0f )
		{
			numOfWalkableCells++;
		}
	}
	return costs;
}

function array<H7AdventureMapCell> CutPathToWalkable(array<H7AdventureMapCell> path, int numOfWalkableCells)
{
	local bool endPointOccupied;

	;
	path.Remove( numOfWalkableCells, path.Length-numOfWalkableCells );
	endPointOccupied  = true;
	while(endPointOccupied)
	{
		if(path.Length == 0)
		{
			break;
		}

		if(path[path.Length - 1].IsBlocked())
		{
			path.Remove(path.Length -1, 1);
			continue;
		}

		endPointOccupied = false;
	}

	return path;
}

function float GetTotalPathCosts( array<H7AdventureMapCell> path, H7AdventureMapCell startCell, optional float movePoints = 0, optional out int numOfWalkableCells )
{
	local array<float> costs;
	local float totalCosts;
	local int i;
	costs = GetPathCosts(path, startCell, movePoints, numOfWalkableCells);

	for(i=0; i<costs.Length; i++)
	{
		totalCosts += costs[i];
	}
	return totalCosts;
}

function float ManhattanDistanceFromIntPoints( IntPoint a, IntPoint b )
{
	return Abs( a.X - b.X ) + Abs( a.Y - b.Y );
}

function LogTest(H7BaseBuff buff)
{
	;
}

