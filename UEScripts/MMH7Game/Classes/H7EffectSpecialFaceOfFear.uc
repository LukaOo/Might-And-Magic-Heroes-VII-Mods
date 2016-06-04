//=============================================================================
// H7EffectSpecialFaceOfFear
//
// 
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7EffectSpecialFaceOfFear extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);


var private int mFleeingDistance<DisplayName=Fleeing distance|ClampMin=0|ClampMax=100>;
var private int mFleeingDistanceDiagonal<DisplayName=Fleeing distance diagonal|ClampMin=0|ClampMax=100>;
var private bool mShowDebugPosition<DisplayName=Show Debug Position>;

var private H7CreatureStack             mAttackingStack;
var private array<H7IEffectTargetable>  mTargets;
var private bool                        mIsSimulated;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7ICaster caster;
	local H7IEffectTargetable target;

	if( !class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		;
		mAttackingStack = none;
		mTargets.Length = 0;
		return;
	}

	effect.GetTargets( mTargets );
	caster = effect.GetSource().GetCasterOriginal();

	mAttackingStack = H7CreatureStack( caster );
	if( mAttackingStack == none )
	{
		caster = effect.GetSource().GetOwner();
		mAttackingStack = H7CreatureStack( caster );
	}

	if( mAttackingStack == none )
	{
		target = effect.GetSource().GetTarget();
		mAttackingStack = H7CreatureStack( target );
		mTargets.Length = 0;
		if( mAttackingStack == none )
		{
			mAttackingStack = none;
			mTargets.Length = 0;
			;
			return;
		}
	}

	if( mTargets.Length == 0 ) return;

	mIsSimulated = isSimulated;

	HandleFearEffect();

	mAttackingStack = none;
	mTargets.Length = 0;
}

function private HandleFearEffect()
{
	local array<H7CombatMapCell> fleeingCells;
	local H7CreatureStack currentStack;
	local int i;
	
	for( i = 0; i < mTargets.Length; ++i )
	{
		currentStack = H7CreatureStack( mTargets[i] );

		if( currentStack == none )
		{
			;
			continue;
		}
		
		fleeingCells = GetFleeingCells( currentStack );

		if( fleeingCells.Length == 0 ) continue;

		if( mIsSimulated )
		{
			ShowCellHighlight( fleeingCells );
		}
		else
		{
			MoveToCells( currentStack, fleeingCells );
		}
	}
}

function private array<H7CombatMapCell> GetFleeingCells( H7CreatureStack stack )
{
	local array<H7CombatMapCell> cells;
	local H7CombatMapCell attackerCell, defenderCell;

	GetClosestCells( mAttackingStack, stack, attackerCell, defenderCell );

	cells.AddItem( GetMirroredCell( attackerCell, defenderCell, stack ) );

	return cells;
}

function H7CombatMapCell GetMirroredCell( H7CombatMapCell cellToMirror, H7CombatMapCell mirrorCenter, H7CreatureStack stack )
{
	local IntPoint dif, masterPoint;
	local int distance, currentDistance;
	local H7CombatMapCell cell, targetCell;

	dif.X = mirrorCenter.GetGridPosition().X - cellToMirror.GetGridPosition().X;
	dif.Y = mirrorCenter.GetGridPosition().Y - cellToMirror.GetGridPosition().Y;

	masterPoint = stack.GetCell().GetMaster().GetGridPosition();

	distance = Abs(dif.X) == Abs(dif.Y) ? mFleeingDistanceDiagonal : mFleeingDistance;

	targetCell = stack.GetCell().GetMaster();
	for( currentDistance = 1; currentDistance <= distance; ++currentDistance )
	{
		dif.X = mirrorCenter.GetGridPosition().X - cellToMirror.GetGridPosition().X;
		dif.Y = mirrorCenter.GetGridPosition().Y - cellToMirror.GetGridPosition().Y;

		dif.X *= currentDistance;
		dif.Y *= currentDistance;
		
		masterPoint = stack.GetCell().GetMaster().GetGridPosition();
		masterPoint.X += dif.X;
		masterPoint.Y += dif.Y;

		cell = class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid().GetCellByIntPoint( masterPoint );
		
		if( !CanReachCell( stack, cell ) )
		{
			return targetCell;
		}

		targetCell = cell;
	}

	return targetCell;
}

function private bool CanReachCell( H7CreatureStack stack, H7CombatMapCell cell )
{
	if( cell == none ) return false;

	return stack.GetPathfinder().CanMoveToCell( cell );
}

function private GetClosestCells( H7CreatureStack attacker, H7CreatureStack defender, out H7CombatMapCell attackerCell, out H7CombatMapCell defenderCell )
{
	local float distance, currentDistance;
	local array<H7CombatMapCell> attackerCells, defenderCells;
	local int i;

	attackerCells = GetAttackerPosition();
	defenderCells = defender.GetCell().GetMergedCells();

	defenderCell = defenderCells[0];
	attackerCell = attackerCells[0];

	distance = class'H7Math'.static.GetDistanceIntPoints( defenderCell.GetGridPosition(), attackerCell.GetGridPosition() );
	for( i = 0; i < attackerCells.Length; ++i )
	{
		currentDistance = class'H7Math'.static.GetDistanceIntPoints( attackerCells[i].GetGridPosition(), defenderCell.GetGridPosition() );
		if( currentDistance < distance )
		{
			distance = currentDistance;
			attackerCell = attackerCells[i];
		}
	}
	
	for( i = 0; i < defenderCells.Length; ++i )
	{
		currentDistance = class'H7Math'.static.GetDistanceIntPoints( defenderCells[i].GetGridPosition(), attackerCell.GetGridPosition() );
		if( currentDistance < distance )
		{
			distance = currentDistance;
			defenderCell = defenderCells[i];
		}
	}
}

function private MoveToCells( H7CreatureStack stack, array<H7CombatMapCell> cells )
{
	local array<H7CombatMapCell> path;
	local array<H7Command> commands;
	local Rotator targetRotation;

	if( cells.Length != 0 )
	{   
		if( cells[0] == stack.GetCell() )
		{
			// rotate away from the attacker
			targetRotation = Rotator( stack.GetCell().GetCenterByCreatureDim( stack.GetUnitBaseSizeInt() ) - mAttackingStack.GetCell().GetCenterByCreatureDim( mAttackingStack.GetUnitBaseSizeInt() ));
			stack.SetRotation( targetRotation );
			stack.GetCreature().SetRotation( targetRotation );
		}
		else
		{
			stack.GetPathfinder().GetPath( cells[0].GetGridPosition(), path );
		
			commands = class'H7ReplicationInfo'.static.GetInstance().GetCommandQueue().GetCmdsForCaster( stack );
			if( commands.Length == 0 )
			{
				class'H7ReplicationInfo'.static.GetInstance().GetCommandQueue().Enqueue( class'H7Command'.static.CreateCommand( stack, UC_MOVE, ACTION_MOVE,,,path,false,,, true ) );
			}
		}
	}
}

function private ShowCellHighlight( array<H7CombatMapCell> cells )
{
	local int i;

	for( i = 0; i < cells.Length; ++i )
	{
		if( cells[i] == none ) continue;

		//TODO: Implement when design wants it

		if( mShowDebugPosition )
		{
			mAttackingStack.FlushPersistentDebugLines();
			mAttackingStack.DrawDebugSphere( cells[i].GetCenterPos(), 60.0f, 10, 0, 127.5f, 127.5f, true );
		}
	}
}

function private array<H7CombatMapCell> GetAttackerPosition()
{
	local array<H7CombatMapCell> cells;

	if( mIsSimulated )
	{
		class'H7CombatMapGridController'.static.GetInstance().GetMovementPreviewCells( cells );

		if( cells.Length > 0 )
		{
			return cells;
		}
	}

	cells = mAttackingStack.GetCell().GetMergedCells();

	return cells;
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_FACE_FEAR","H7TooltipReplacement");
}

