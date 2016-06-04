//=============================================================================
// H7AiActionAttackCreatureStack
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionAttackCreatureStack extends H7AiActionBase;

var protected H7AiUtilityHasAnyAdjacentEnemy    mInUHasAnyAdjacentEnemy;
var protected H7AiUtilityHasAdjacentEnemy       mInUHasAdjacentEnemy;
var protected H7AiUtilityRangeCasualityCount    mInUCasualityCount;
var protected H7AiUtilityRangeCreatureDamage    mInUCreatureDamage;

function String DebugName()
{
	return "Attack";
}

function Setup()
{
	mInUHasAnyAdjacentEnemy = new class'H7AiUtilityHasAnyAdjacentEnemy';
	mInUHasAdjacentEnemy = new class'H7AiUtilityHasAdjacentEnemy';
	mInUCasualityCount = new class'H7AiUtilityRangeCasualityCount';
	mInUCreatureDamage = new class'H7AiUtilityRangeCreatureDamage';
}

/// override function(s)

function RunScores( H7AiCombatSensors sensors, H7Unit currentUnit, out array<AiActionScore> scores )
{
	local int               k;
	local AiActionScore     score;
	local H7AiSensorInputConst    sic;
	local array<float>      adjacentEnemy;
	local array<float>      casualityCount;
	local array<float>      creatureDamage;
	local H7BaseAbility meleeAttackAbilityTemplate;
	local H7BaseAbility meleeAttackAbility;
	local H7CreatureStack   cstack;
	local float             CC, CD, AE;

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

	if( cstack.GetAttackCount()<=0 )
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		return;
	}

	// if no enemy is in melee range zero-out all close quarter attacks
	sic.SetTargetCreatureStack(None);
	mInUHasAnyAdjacentEnemy.UpdateInput();
	mInUHasAnyAdjacentEnemy.UpdateOutput();
	adjacentEnemy = mInUHasAnyAdjacentEnemy.GetOutValues();
	if( adjacentEnemy.Length>=1 && adjacentEnemy[0]<=0.0f )
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		return;
	}

	// for all enemy creatures ...
	for(k=0;k<sic.GetOppCreatureStackNum();k++)
	{
		score.dbgString = "Action.Attack; " $ meleeAttackAbility @ meleeAttackAbility.GetName() $ "; Target " $ sic.GetOppCreatureStack(k).GetName() $ "; ";

		sic.SetTargetCreatureStack(sic.GetOppCreatureStack(k));

		mInUHasAdjacentEnemy.UpdateInput();
		mInUHasAdjacentEnemy.UpdateOutput();
		adjacentEnemy = mInUHasAdjacentEnemy.GetOutValues();
		if( adjacentEnemy.Length >= 1 ) AE=adjacentEnemy[0]; else AE=0.0f;

		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

		mInUCasualityCount.UpdateInput();
		mInUCasualityCount.UpdateOutput();
		casualityCount = mInUCasualityCount.GetOutValues();
		if( casualityCount.Length >= 1 ) CC=casualityCount[0]; else CC=0.0f;

		mInUCreatureDamage.UpdateInput();
		mInUCreatureDamage.UpdateOutput();
		creatureDamage = mInUCreatureDamage.GetOutValues();
		if( creatureDamage.Length >= 1 ) CD=creatureDamage[0]; else CD=0.0f;

		if(sic.GetOppCreatureStack(k).CanRangeAttack()==true)
		{
			score.score = AE * CD * 1.25f;
			score.dbgString = score.dbgString $ "AE(" $ AE $ ") CC(" $ CC $ ") CD(" $ CD $ "); RF(1.25); ";
		}
		else
		{
			score.score = AE * CD;
			score.dbgString = score.dbgString $ "AE(" $ AE $ ") CC(" $ CC $ ") CD(" $ CD $ "); RF(1.0); ";
		}

		if( score.score > 0.0f )
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
		if(cell!=None)
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
