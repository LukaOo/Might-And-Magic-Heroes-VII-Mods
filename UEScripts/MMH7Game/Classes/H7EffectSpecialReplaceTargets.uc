//=============================================================================
// H7EffectSpecialReplaceTargets
//
// 
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7EffectSpecialReplaceTargets extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);


var( Cyclone ) IntPoint mArea<DisplayName=Replacement area size>;

var private array<H7IEffectTargetable> mTargets;
var private array<H7CombatMapCell> mTargetArea;
var private H7CombatMapGrid mGrid;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local int i;
	local H7CombatResult result;
	local array<H7IEffectTargetable> targets;

	if( effect == none || !class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() ) 
	{
		mTargetArea.Length = 0;
		mTargets.Length = 0;
		mGrid = none;
		return;
	}

	mTargets = container.TargetableTargets;
	
	effect.GetValidTargets( mTargets, targets, true );
	mTargets = targets;

	if( mTargets.Length == 0 ) 
	{
		effect.GetTargets( mTargets );
	}

	if( mTargets.Length == 0 ) 
	{
		mTargetArea.Length = 0;
		mTargets.Length = 0;
		mGrid = none;
		return; // nothing to do here
	}
	
	result = container.Result;

	if( result != none )
	{
		for( i = 0; i < mTargets.Length; ++i )
		{
			result.AddDefender( mTargets[i] );
		}

		for( i = 0; i < result.GetDefenderCount(); ++i )
		{
			result.AddEffectToTooltip( effect, i );
		}
	}

	if( mGrid == none )
	{
		mGrid = class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid();
	}

	InitTargetArea( container.Targetable );

	if( isSimulated ) 
	{
		mTargetArea.Length = 0;
		mTargets.Length = 0;
		mGrid = none;
		return;
	}

	HandleRepositioning();
	mTargetArea.Length = 0;
	mTargets.Length = 0;
	mGrid = none;
}

function private HandleRepositioning()
{
	local array<H7CombatMapCell> cells;
	local array<H7CreatureStack> stacks;
	local int i, r;

	for( i = 0; i < mTargets.Length; ++i )
	{
		if( H7CreatureStack( mTargets[i] ) != none )
		{
			stacks.AddItem( H7CreatureStack( mTargets[i] ) );
		}
	}
	
	stacks.Sort( SortFunction );

	for( i = 0; i < stacks.Length; ++i )
	{
		cells = GetPossibleTargetCells( stacks[i] );

		r = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( cells.Length );

		if( cells.Length > 0 )
		{
			RepositionCreatureStack( stacks[i], cells[r] );
		}
	}
}

function private int SortFunction( H7CreatureStack stack1, H7CreatureStack stack2 )
{
	return stack1.GetUnitBaseSizeInt() - stack2.GetUnitBaseSizeInt();
}

function private InitTargetArea( H7IEffectTargetable target )
{
	local H7CombatMapCell targetCell;

	if( target == none ) return;

	targetCell = mGrid.GetCellByIntPoint( target.GetGridPosition() );

	mGrid.GetCellsFromDimensions( targetCell, mArea, mTargetArea );
}

function private array<H7CombatMapCell> GetPossibleTargetCells( H7CreatureStack stack )
{
	local int i;
	local array<H7CombatMapCell> cells;

	for( i = 0; i < mTargetArea.Length; ++i )
	{
		if( CanPlaceHere( stack, mTargetArea[i] ) )
		{
			cells.AddItem( mTargetArea[i] );
		}
	}

	return cells;
}

function private bool CanPlaceHere( H7CreatureStack stack, H7CombatMapCell targetCell )
{
	local array<H7CombatMapCell> targetCells;
	local int i;

	targetCell.GetCellsHitByCellSize( stack.GetUnitBaseSize(), targetCells );

	if( !targetCell.CanPlaceCreatureStack( stack ) )
	{
		return false;
	}

	for( i = 0; i < targetCells.Length; ++i )
	{
		if( mTargetArea.Find( targetCells[i] ) == INDEX_NONE )
		{
			return false;
		}
	}

	return true;
}

function private RepositionCreatureStack( H7CreatureStack stack, H7CombatMapCell cell )
{
	stack.RemoveCreatureFromCell();
	stack.SetLocation( cell.GetCenterByCreatureDim( stack.GetUnitBaseSizeInt() ) );
	stack.GetCreature().SetLocation( cell.GetCenterByCreatureDim( stack.GetUnitBaseSizeInt() ) );
	stack.SetGridPosition( cell.GetGridPosition() );

	cell.PlaceCreature( stack, false );

	SetRandomRotation( stack );
}

function private SetRandomRotation( H7CreatureStack stack )
{
	local Rotator rota;

	rota = stack.GetCreature().Rotation;

	rota.Yaw = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(360) * DegToUnrRot; 

	stack.SetRotation( rota );
	stack.GetCreature().SetRotation( rota );
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_CYCLONE_SPECIAL","H7TooltipReplacement");
}

