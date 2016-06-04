//=============================================================================
// H7AiActionMoveAttackCreatureStack
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionMoveAttackCreatureStack extends H7AiActionBase;

var protected H7AiUtilityHasAdjacentEnemy       mInUHasAdjacentEnemy;
var protected H7AiUtilityCanMoveAttack          mInUCanMoveAttack;
var protected H7AiUtilityRangeCasualityCount    mInUCasualityCount;
var protected H7AiUtilityRangeCreatureDamage    mInUCreatureDamage;

function String DebugName()
{
	return "Move and Attack";
}

function Setup()
{
	mInUHasAdjacentEnemy = new class'H7AiUtilityHasAdjacentEnemy';
	mInUCanMoveAttack = new class'H7AiUtilityCanMoveAttack';
	mInUCasualityCount = new class'H7AiUtilityRangeCasualityCount';
	mInUCreatureDamage = new class'H7AiUtilityRangeCreatureDamage';
}

/// override function(s)

function RunScores( H7AiCombatSensors sensors, H7Unit currentUnit, out array<AiActionScore> scores )
{
	local int               k;
	local AiActionScore     score;
	local H7AiSensorInputConst    sic;
	local array<float>      moveAttack;
	local array<float>      adjacentEnemy;
	local array<float>      casualityCount;
	local array<float>      creatureDamage;
	local H7BaseAbility meleeAttackAbilityTemplate;
	local H7BaseAbility meleeAttackAbility;
	local float             CC, CD;
	local H7CreatureStack   cstack;
	local array<H7CombatMapCell> dummyArray;
	local array<H7CreatureStack> suppressedStacks;
	local float suppressionLoss;

	dummyArray = dummyArray;

	sic = sensors.GetSensorIConsts();

	score.action = Self;
	score.score = 0.0f;
	
	// prepare the default melee attack for attacking unit
	meleeAttackAbilityTemplate = currentUnit.GetMeleeAttackAbility();
	if(meleeAttackAbilityTemplate==None) return;
	meleeAttackAbility = currentUnit.GetAbilityManager().GetAbility( meleeAttackAbilityTemplate );
	if(meleeAttackAbility==None) return;
	currentUnit.GetAbilityManager().PrepareAbility( meleeAttackAbility );

	cstack=H7CreatureStack(currentUnit);
	if(cstack==None) return; // ?!

	// double check creature is real
	if(cstack.IsDead()==true || cstack.IsVisible()==false || cstack.IsOffGrid()==true)
	{
		return;
	}

	if( cstack.GetAttackCount()<=0 || cstack.GetMoveCount()<=0 )
	{
		return;
	}

	// if we are range units we do that to (even we may would deal more damage that way)
	if(cstack.CanRangeAttack()==true)
	{
		return;
	}

	// for all enemy creatures ...
	for(k=0;k<sic.GetOppCreatureStackNum();k++)
	{
		score.dbgString = "Action.MoveAttack; " $ meleeAttackAbility @ meleeAttackAbility.GetName() $ "; Target " $ sic.GetOppCreatureStack(k).GetName() $ "; ";

		sic.SetTargetCreatureStack(sic.GetOppCreatureStack(k));

		// if enemy is in melee range to target creature we cancel out the moveto-attack
		mInUHasAdjacentEnemy.UpdateInput();
		mInUHasAdjacentEnemy.UpdateOutput();
		adjacentEnemy = mInUHasAdjacentEnemy.GetOutValues();

		// check if this creature actually can move attack (reach target)
		mInUCanMoveAttack.UpdateInput();
		mInUCanMoveAttack.UpdateOutput();
		moveAttack = mInUCanMoveAttack.GetOutValues();

		if( adjacentEnemy.Length>=1 && adjacentEnemy[0]<=0.0f && // not in melee with target
			moveAttack.Length>=1 && moveAttack[0]>0.0f ) // can move attack target
		{
			mInUCasualityCount.UpdateInput();
			mInUCasualityCount.UpdateOutput();
			casualityCount = mInUCasualityCount.GetOutValues();
			if( casualityCount.Length>=1 ) CC=casualityCount[0]; else CC=0.0f;

			mInUCreatureDamage.UpdateInput();
			mInUCreatureDamage.UpdateOutput();
			creatureDamage = mInUCreatureDamage.GetOutValues();
			if( creatureDamage.Length>=1 ) CD=creatureDamage[0]; else CD=0.0f;

			suppressedStacks = cstack.GetSuppressedStacks();

			
			suppressionLoss = 0.5f ** suppressedStacks.Length;
			if(sic.GetOppCreatureStack(k).IsRanged()==true)
			{
				score.score = CD * 1.15f;
				score.dbgString = score.dbgString $ " CC(" $ CC $ ") CD(" $ CD $ "); RF(1.15); ";
				if( suppressedStacks.Length > 0 )
				{
					score.score = score.score * suppressionLoss;
					score.dbgString = score.dbgString $ " LS("$suppressionLoss$"); "; // lose suppress
				}
				else if( sic.GetOppCreatureStack(k).CanRangeAttack() )
				{
					score.score = score.score * 1.5f; 
					score.dbgString = score.dbgString $ " DS(1.5); "; // do suppress
				}
			}
			else
			{
				score.score = CD;
				score.dbgString = score.dbgString $ " CC(" $ CC $ ") CD(" $ CD $ "); RF(1.0); ";
				if( suppressedStacks.Length > 0 )
				{
					score.score = score.score * suppressionLoss;
					score.dbgString = score.dbgString $ " LS("$suppressionLoss$"); "; // lose suppress
				}
			}

			if( score.score!=0.0f )
			{
				score.score += 0.1f;
				score.params = new () class'H7AiActionParam';
				score.params.Clear();
				score.params.SetUnit(APID_1,currentUnit);
				score.params.SetUnit(APID_2,sic.GetOppCreatureStack(k));
				scores.AddItem(score);
			}
		}
	}
}

function EDirection GetBestDirectionToAttack( H7Unit unit, H7CreatureStack target, optional out H7CombatMapCell hitCell )
{
	local H7CombatMapGrid grid;
	local array<H7CombatMapCell> cells;
	local H7CombatMapCell cell;
	local float opportunity;
	local float bestOpportunity;
	local H7CombatMapCell bestCell, targetCell;
	
//	local int ux, uy;

	grid = class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid();
	grid.GetAllAttackPositionsAgainst(target,unit,cells);

	targetCell=target.GetCell();
	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	bestOpportunity=0.0f;
	bestCell=None;
	foreach cells(cell)
	{
		if(cell!=None && H7CreatureStack(unit).GetPathfinder().CanMoveToCell(cell)==true )
		{
			opportunity=cell.GetOpportunity();
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			if(opportunity>bestOpportunity)
			{
				bestOpportunity=opportunity;
				bestCell=cell;
			}
		}
	}

	//ux=target.GetUnitBaseSizeInt()-1;
	//uy=target.GetUnitBaseSizeInt()-1;

	if(bestCell!=None)
	{
		hitCell=bestCell;
		if( bestCell.GetCellPosition().X >= (targetCell.GetCellPosition().X + target.GetUnitBaseSizeInt()) )
		{
			if( bestCell.GetCellPosition().Y >= (targetCell.GetCellPosition().Y + target.GetUnitBaseSizeInt()) )
			{
//				hitCell=grid.GetCellByPos( targetCell.GetCellPosition().X + ux,  targetCell.GetCellPosition().Y + uy );
				return NORTH_WEST;
			}
			else if( bestCell.GetCellPosition().Y >= targetCell.GetCellPosition().Y && 
			         bestCell.GetCellPosition().Y < (targetCell.GetCellPosition().Y + target.GetUnitBaseSizeInt()) )
			{
//				hitCell=grid.GetCellByPos( targetCell.GetCellPosition().X + ux,  targetCell.GetCellPosition().Y );
				return WEST;
			}
			else
			{
//				hitCell=grid.GetCellByPos( targetCell.GetCellPosition().X + ux,  targetCell.GetCellPosition().Y );
				return SOUTH_WEST;
			}
		}
		else if( bestCell.GetCellPosition().X >= targetCell.GetCellPosition().X && 
			     bestCell.GetCellPosition().X < (targetCell.GetCellPosition().X + target.GetUnitBaseSizeInt()) )
		{
			if( bestCell.GetCellPosition().Y >= (targetCell.GetCellPosition().Y + target.GetUnitBaseSizeInt()) )
			{
//				hitCell=grid.GetCellByPos( targetCell.GetCellPosition().X,  targetCell.GetCellPosition().Y + uy );
				return NORTH;
			}
			else if( bestCell.GetCellPosition().Y >= targetCell.GetCellPosition().Y && 
			         bestCell.GetCellPosition().Y < (targetCell.GetCellPosition().Y + target.GetUnitBaseSizeInt()) )
			{
//				hitCell=grid.GetCellByPos( targetCell.GetCellPosition().X,  targetCell.GetCellPosition().Y );
				return WEST; // we stay inside :D
			}
			else
			{
//				hitCell=grid.GetCellByPos( targetCell.GetCellPosition().X,  targetCell.GetCellPosition().Y );
				return SOUTH;
			}
		}
		else
		{
			if( bestCell.GetCellPosition().Y >= (targetCell.GetCellPosition().Y + target.GetUnitBaseSizeInt()) )
			{
//				hitCell=grid.GetCellByPos( targetCell.GetCellPosition().X,  targetCell.GetCellPosition().Y + uy );
				return NORTH_EAST;
			}
			else if( bestCell.GetCellPosition().Y >= targetCell.GetCellPosition().Y && 
			         bestCell.GetCellPosition().Y < (targetCell.GetCellPosition().Y + target.GetUnitBaseSizeInt()) )
			{
//				hitCell=grid.GetCellByPos( targetCell.GetCellPosition().X,  targetCell.GetCellPosition().Y );
				return EAST;
			}
			else
			{
//				hitCell=grid.GetCellByPos( targetCell.GetCellPosition().X,  targetCell.GetCellPosition().Y );
				return SOUTH_EAST;
			}
		}
	}

	hitCell=None;

	return WEST;
}



function bool PerformAction( H7Unit unit, AiActionScore score )
{
	local H7CombatController ctrl;
	local H7CombatMapGridController grid_ctrl;
	local H7BaseAbility meleeAttackAbilityTemplate;
	local H7BaseAbility meleeAttackAbility;
	local H7Unit targetUnit;
	local EDirection dir;
	local H7CombatMapCell hitCell;

	ctrl = class'H7CombatController'.static.GetInstance();
	grid_ctrl = class'H7CombatMapGridController'.static.GetInstance();

	if( unit != None && ctrl != None )
	{
		targetUnit = score.params.GetUnit(APID_2);

		// prepare the default melee attack for attacking unit
		meleeAttackAbilityTemplate = unit.GetMeleeAttackAbility();
		if(meleeAttackAbilityTemplate==None) return false;
		meleeAttackAbility = unit.GetAbilityManager().GetAbility( meleeAttackAbilityTemplate );
		if(meleeAttackAbility==None) return false;
		unit.GetAbilityManager().PrepareAbility( meleeAttackAbility );

		if( unit.GetPreparedAbility().CanCastOnTargetActor( targetUnit ) )
		{
			dir=GetBestDirectionToAttack(unit,H7CreatureStack(targetUnit),hitCell);
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			if(hitCell!=None)
				return grid_ctrl.DoAttackAI( H7CreatureStack(targetUnit).GetCell(), hitCell, dir );
			else
				return grid_ctrl.DoAbility( H7CreatureStack(targetUnit).GetCell(), dir );
		}
	}
	return false;
}
