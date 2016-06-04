//=============================================================================
// H7EffectSpecialImplosion
//
// 
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7EffectSpecialImplosion extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);

var( Pull ) private int mPullDistance<DisplayName=Pull distance|ClampMin=0>;
var( Pull ) protected bool mFaceMainTarget<DisplayName=Should pulled creatures face the main target?>;

var private bool                        mIsSimulated;
var private bool                        mIsAiCaster;
var private array<H7CreatureStack>      mTargets;
var private H7CreatureStack             mMainTarget;
var private H7CombatMapGridController   mCombatMapGridController;
var private array<H7CombatMapCell>      mHighlightCells, mOccupiedCells;

function Initialize( H7Effect effect ) 
{
	mCombatMapGridController = class'H7CombatMapGridController'.static.GetInstance();
	mIsAiCaster = effect.GetSource().GetCaster().GetPlayer().IsControlledByAI();
}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local IntPoint dim;
	local array<H7CombatMapCell> cells, allCells;
	local H7CombatMapCell cell, mainCell;
	local array<H7CombatMapCell> mainCells;
	local array<float> distances;
	local array<H7IEffectTargetable> targets;
	
	mTargets.Length = 0;
	if( mCombatMapGridController == none ) 
	{
		mCombatMapGridController = class'H7CombatMapGridController'.static.GetInstance();
	}

	mIsSimulated = isSimulated;

	effect.GetTargets( targets );

	dim.X = mPullDistance * 2 + 1;
	dim.Y = mPullDistance * 2 + 1;
	if( targets.Length == 0 )
	{
		mTargets.Length = 0;
		mMainTarget = none;
		mCombatMapGridController = none;
		mHighlightCells.Length = 0;
		mOccupiedCells.Length = 0;
		return;
	}
	mMainTarget = H7CreatureStack( targets[0] );
	
	if( mMainTarget != none )
	{
		mainCells = mMainTarget.GetCell().GetMergedCells();
	}
	else
	{
		mTargets.Length = 0;
		mMainTarget = none;
		mCombatMapGridController = none;
		mHighlightCells.Length = 0;
		mOccupiedCells.Length = 0;
		return;
	}
	foreach mainCells( mainCell )
	{
		mCombatMapGridController.GetCombatGrid().GetCellsFromDimensions( mainCell, dim, cells );
		foreach cells( cell )
		{
			if( allCells.Find( cell ) == INDEX_NONE && class'H7Math'.static.GetDiagonalShortcutDistanceIntPoints( mainCell.mPosition, cell.mPosition ) <= mPullDistance )
			{
				allCells.AddItem( cell );
			}
		}
	}
	
	foreach allCells( cell )
	{
		if( cell.HasCreatureStack() && cell.GetCreatureStack() != mMainTarget )
		{
			if( mTargets.Find( cell.GetCreatureStack() ) == INDEX_NONE )
			{
				mTargets.AddItem( cell.GetCreatureStack() );
			}
		}
	}

	distances.Add( mTargets.Length );

	GetDistances( distances );

	// sort based on distance (sorting structs sucks so bubblesort this)
	SortTargets( distances );

	if( mTargets.Length == 0 ) { return; }

	HandlePullEffect();

	mTargets.Length = 0;
	mMainTarget = none;
	mCombatMapGridController = none;
	mHighlightCells.Length = 0;
	mOccupiedCells.Length = 0;
}

native private function SortTargets( out array<float> distances );

native private function GetDistances( out array<float> distances );

function private HandlePullEffect()
{
	local int i, tol,hasObstacle;
	local H7CombatMapCell cell, closestCell, stackCell;
	local H7CreatureStack stack;
	local Vector creaturePosition, targetPosition;
	local Rotator rot;
	local array<H7CombatMapCell> lineCells, cells, stackCells;
	local bool canPlace, validPos, moveLeft;
	local IntPoint newPos;

	mOccupiedCells.Length = 0;

	// targets are sorted by distance
	for( i = 0; i < mTargets.Length; ++i )
	{
		stack = mTargets[i];
		if( stack == none ) { continue; }

		
		creaturePosition = mMainTarget.GetCell().GetCenterPosBySize( mMainTarget.GetUnitBaseSize() );

		targetPosition = stack.GetCell().GetCenterPosBySize( stack.GetUnitBaseSize() );
		rot = Rotator( targetPosition - creaturePosition );

		cells = stack.GetCell().GetMergedCells();
		closestCell = cells[0];
		foreach cells( cell )
		{
			if( class'H7Math'.static.GetDiagonalShortcutDistanceIntPoints( cell.mPosition, mMainTarget.GetCell().mPosition ) < class'H7Math'.static.GetDiagonalShortcutDistanceIntPoints( closestCell.mPosition, mMainTarget.GetCell().mPosition ) )
			{
				closestCell = cell;
			}
		}
		lineCells.Length = 0;
		newPos = mMainTarget.GetCell().mPosition;
		class'H7Math'.static.GetLineCellsBresenham( lineCells, closestCell.mPosition, newPos );
		lineCells.InsertItem( 0, closestCell );
		
		// verify the validity of moving 2x2 creatures 
		if( lineCells.Length > 2 )
		{
			moveLeft = stack.GetGridPosition().X > class'H7CombatMapGridController'.static.GetInstance().GetGridSizeX() / 2;
			
			// dont place it on it self
			if( stack.GetCreature().GetBaseSize() == CELLSIZE_1x1 || ( stack.GetCreature().GetBaseSize()  == CELLSIZE_2x2 && lineCells[0] == stack.GetCell() ) )
				lineCells.Remove(0,1);

				
			validPos = FindValidCell( stack, lineCells, cell, hasObstacle );
			tol = 1;

			// Caro Code, try a differend line to new position
			while( !validPos )
			{
				
				if( hasObstacle ==1 )
					break; // give up

				if( moveLeft ) newPos.X = newPos.X - tol;
				else newPos.X = newPos.X + tol;

				class'H7Math'.static.GetLineCellsBresenham( lineCells, closestCell.mPosition, newPos );
				validPos = FindValidCell( stack, lineCells, cell, hasObstacle );

				if( validPos ) { break; }
				if( tol > 4 ) { cell = stack.GetCell(); break; } // give up

				++tol;
			}
		}
		else
		{
			continue;
		}

		// prioritise things we can place first. remember, we are operating on a sorted array, based on distance
		canPlace = true;
		if( mOccupiedCells.Find( cell ) == INDEX_NONE )
		{
			if( !validPos && hasObstacle ==1 ) 
				canPlace = false;

			cell.GetCellsHitByCellSize( stack.GetUnitBaseSize(), stackCells, true );
			foreach stackCells( stackCell )
			{
				if( stackCell.HasCreatureStack() && stackCell.GetCreatureStack() != stack )
				{
					canPlace = false;
					break;
				}
			}
			if( canPlace )
			{
				if( mIsSimulated )
				{
					if( mIsAiCaster ) continue;

					if( mFaceMainTarget )
					{
						rot.Yaw = rot.Yaw + DegToUnrRot * 180;
						rot = Normalize( rot );
					}
					ShowCellPreview( cell, stack, rot );
				}
				else
				{
					RepositionCreatureStack( stack, cell );
					if( mFaceMainTarget )
					{
						rot.Yaw = rot.Yaw + DegToUnrRot * 180;
						rot = Normalize( rot );
						stack.GetMovementControl().LerpStackToRotation( rot );
					}
				}
				foreach stackCells( stackCell )
				{
					mOccupiedCells.AddItem( stackCell );
				}
			}
			
			
		}
	}
	if( !mIsSimulated && !mIsAiCaster )
	{
		class'H7CombatController'.static.GetInstance().DestroyAllStackGhosts();
	}
	class'H7CombatController'.static.GetInstance().RefreshAllUnits();
	class'H7CombatMapGridController'.static.GetInstance().RecalculateReachableCells();
}

function private bool FindValidCell(H7CreatureStack stack, array<H7CombatMapCell> cells, out H7CombatMapCell validCell, out int hasObstacle )
{
	local array<H7CombatMapCell> hitCells;
	local int i, j;
	local bool check;

	for( i = 0; i < cells.Length; ++i )
	{
		hitCells.Length = 0;
		
		cells[i].GetCellsHitByCellSize( stack.GetCreature().GetBaseSize(), hitCells );

		for( j = 0; j < hitCells.Length; ++j )
		{
			if( !hitCells[j].CanPlaceCreatureStack( stack ) || 
				hitCells[j].GetGridPosition().X < 2 && hitCells[j].GetGridPosition().X >= class'H7CombatMapGridController'.static.GetInstance().GetGridSizeX() ||
				hitCells[j].GetGridPosition().Y < 0 && hitCells[j].GetGridPosition().Y >= class'H7CombatMapGridController'.static.GetInstance().GetGridSizeY() 
				)
			{
				if( hitCells[j].HasObstacle() )
				{
					hasObstacle = 1;
				}

				check = false;
				break;
			}
			else 
			{
				check = true;
			}
		}

		if( check ) 
		{
			hasObstacle = 0;
			validCell = cells[i];
			return true;
		}
				
	}

	return false;
}


function private RepositionCreatureStack( H7CreatureStack stack, H7CombatMapCell cell )
{
	local array<H7CombatMapCell> fakePath;

	if( stack == none ) return;

	// fake path for Entangle buff damage effect
	stack.GetPathfinder().GetPathByCell(cell, fakePath);
	stack.SetLastWalkedPath(fakePath);

	stack.RemoveCreatureFromCell();

	stack.GetMovementControl().LerpStackToLocation( cell.GetCenterByCreatureDim( stack.GetUnitBaseSizeInt() ) );

	stack.SetGridPosition( cell.GetGridPosition() );

	cell.PlaceCreature( stack, false );
}

function private ShowCellPreview( H7CombatMapCell cell, H7CreatureStack stack, optional Rotator rot )
{
	local int i;
	local array<H7CombatMapCell> highlightCells;
	
	cell.GetCellsHitByCellSize( stack.GetUnitBaseSize(), highlightCells, true );

	stack.CreateGhost( cell, rot, true );
	
	for( i = 0; i < highlightCells.Length; ++i )
	{
		highlightCells[i].SetSelectionType( MOUSE_OVER );
	}
	
	mCombatMapGridController.SetDecalDirty( true );
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_IMPLOSION_PULL_SPECIAL","H7TooltipReplacement");
}

