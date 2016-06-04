//=============================================================================
// H7AiActionMoveCreatureStack
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionMoveCreatureStack extends H7AiActionBase;

var protected H7AiUtilityStackReachesTileIn1Turn    mInUTurnValue;
var protected H7AiUtilityStackMoveDistance          mInUMoveDistance;
var protected H7AiUtilityThreatLevel                mInUThreatLevel;
var protected H7AiUtilityOpportunity                mInUOpportunity;
var protected H7AiUtilityHasAnyAdjacentEnemy        mInUAdjacentEnemy;
var protected H7AiUtilityEnemyDistance              mInUEnemyDistance;

function String DebugName()
{
	return "Move";
}

function Setup()
{
	mInUTurnValue = new class'H7AiUtilityStackReachesTileIn1Turn';
	mInUThreatLevel = new class'H7AiUtilityThreatLevel';
	mInUOpportunity = new class'H7AiUtilityOpportunity';
	mInUAdjacentEnemy = new class'H7AiUtilityHasAnyAdjacentEnemy';
	mInUEnemyDistance = new class'H7AiUtilityEnemyDistance';
	mInUMoveDistance = new class'H7AiUtilityStackMoveDistance';
}

/// override function(s)

function RunScores( H7AiCombatSensors sensors, H7Unit currentUnit, out array<AiActionScore> scores )
{
	local int                       k, d;
	local AiActionScore             score;
	local H7AiSensorInputConst      sic;
	local array<float>              uAdjEnemy;
	local array<float>              uThreat;
	local array<float>              uTurnValue;
	local array<float>              uOpportunity;
	local array<float>              uEnemyDistance;
	local bool                      bFlee, bCharge;
	local float                     tmpScore;
	local H7CreatureStack   cstack;

	sic = sensors.GetSensorIConsts();

	score.action = Self;
	score.score = 0.0f;
	
	bFlee=false;
	bCharge=false;

	cstack=H7CreatureStack(currentUnit);
	if(cstack==None) return;

	if( cstack.GetMoveCount()<=0 )
	{
		return;
	}

	sic.SetTargetCreatureStack(None);
	mInUAdjacentEnemy.UpdateInput();
	mInUAdjacentEnemy.UpdateOutput();
	uAdjEnemy = mInUAdjacentEnemy.GetOutValues();

	if( uAdjEnemy.Length>=1 && uAdjEnemy[0]==0.0f && cstack.CanRangeAttack()==false )
	{
		bFlee=false;
		bCharge=true;
	}

	if( uAdjEnemy.Length>=1 && uAdjEnemy[0]>=1.0f && cstack.CanRangeAttack()==true )
	{
		bFlee=true;
		bCharge=false;
	}

	if( bCharge==false && bFlee==false )
	{
		if( cstack.GetAbilityManager().GetAbility( cstack.GetDefendAbility() ).CanCast() == false )
		{
			bFlee=true;
			//score.params = new () class'H7AiActionParam';
			//score.params.Clear();
			//score.params.SetUnit(APID_1,currentUnit);
			//score.params.SetCMapCell(APID_2, class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid().GetCellByIntPoint(currentUnit.GetGridPosition()) );
			//score.score=0.02f;
			//scores.AddItem(score);
		}
		else
		{
			return;
		}
	}

	// for all gridcells ...
	for(k=0;k<sic.GetCellNum();k++)
	{
		if(sic.GetCell(k).IsBlocked(H7CreatureStack(currentUnit))==false && sic.GetCell(k).IsPassable()==true )
		{
			score.dbgString = "Action.Move; Target " $ sic.GetCell(k) $ "; Flee(" $ bFlee $ ") Charge(" $ bCharge $ "); ";

			sic.SetTargetCell(sic.GetCell(k));

			score.score = 0.0f;

			// if we can't reach the cell position in the first place than we skip the rest of the evaluation
			mInUTurnValue.UpdateInput();
			mInUTurnValue.UpdateOutput();
			uTurnValue = mInUTurnValue.GetOutValues();
			if( uTurnValue.Length>=1 && uTurnValue[0]>0.0f )
			{

			//mInUMoveDistance.UpdateInput();
			//mInUMoveDistance.UpdateOutput();
			//uTurnValue = mInUMoveDistance.GetOutValues();

			//if( uTurnValue.Length>=1 && uTurnValue[0]<1.0f )
			//{
				mInUThreatLevel.UpdateInput();
				mInUThreatLevel.UpdateOutput();
				uThreat = mInUThreatLevel.GetOutValues();

				mInUOpportunity.UpdateInput();
				mInUOpportunity.UpdateOutput();
				uOpportunity = mInUOpportunity.GetOutValues();

				if( uThreat.Length>=1 && uOpportunity.Length>=1 )
				{
					score.dbgString = score.dbgString $ "TL(" $ uThreat[0] $ ") OP(" $ uOpportunity[0] $ ") ";

					if( uThreat[0] > 0.0f && bCharge==true )
					{
						// hostile
						score.score=0.0f;
						mInUEnemyDistance.UpdateInput();
						mInUEnemyDistance.UpdateOutput();
						uEnemyDistance = mInUEnemyDistance.GetOutValues();
						for( d=0; d<uEnemyDistance.Length; d++ )
						{
							tmpScore = (uThreat[0] + uOpportunity[0]) * 0.04f + 0.01f + (1.0f - uEnemyDistance[d]) * 0.04f + 0.01f;
							if( tmpScore > score.score )
							{
								score.score=tmpScore;
							}
						}
						uEnemyDistance.Remove(0,uEnemyDistance.Length);

	//					`LOG_AI("===> H ChargeTo Position Scoring" @ score.score @ "X" @ sic.GetCell(k).GetCellPosition().X @ "Y" @ sic.GetCell(k).GetCellPosition().Y );
					}
					else if( uThreat[0] <= 0.0f && bFlee==true )
					{
						// friendly
						score.score=0.0f;
						mInUEnemyDistance.UpdateInput();
						mInUEnemyDistance.UpdateOutput();
						uEnemyDistance = mInUEnemyDistance.GetOutValues();
						for( d=0; d<uEnemyDistance.Length; d++ )
						{
							tmpScore = uThreat[0] * -0.04f + 0.01f + uEnemyDistance[d] * 0.04f + 0.01f;
							if( tmpScore > score.score )
							{
								score.score=tmpScore;
							}
						}
						uEnemyDistance.Remove(0,uEnemyDistance.Length);
	//					`LOG_AI("===> F ChargeTo Position Scoring" @ score.score @ "X" @ sic.GetCell(k).GetCellPosition().X @ "Y" @ sic.GetCell(k).GetCellPosition().Y );
					}
					else if( uThreat[0] <= 0.0f && bCharge==true )
					{
						// neutral
						score.score = 0.0;
						mInUEnemyDistance.UpdateInput();
						mInUEnemyDistance.UpdateOutput();
						uEnemyDistance = mInUEnemyDistance.GetOutValues();
						for( d=0; d<uEnemyDistance.Length; d++ )
						{
							tmpScore = uThreat[0] * -0.04f + 0.01f + (1.0f - uEnemyDistance[d]) * 0.04f + 0.01f;
							if( tmpScore > score.score )
							{
								score.score=tmpScore;
							}
						}
						uEnemyDistance.Remove(0,uEnemyDistance.Length);
	//					`LOG_AI("===> N ChargeTo Position Scoring" @ score.score @ "X" @ sic.GetCell(k).GetCellPosition().X @ "Y" @ sic.GetCell(k).GetCellPosition().Y );
					}
					else if( uThreat[0] > 0.0f && bFlee==true )
					{
						// friendly
						score.score=0.0f;
						mInUEnemyDistance.UpdateInput();
						mInUEnemyDistance.UpdateOutput();
						uEnemyDistance = mInUEnemyDistance.GetOutValues();
						for( d=0; d<uEnemyDistance.Length; d++ )
						{
							tmpScore = uThreat[0] * 0.04f + 0.01f + uEnemyDistance[d] * 0.04f + 0.01f;
							if( tmpScore > score.score )
							{
								score.score=tmpScore;
							}
						}
						uEnemyDistance.Remove(0,uEnemyDistance.Length);
	//					`LOG_AI("===> F ChargeTo Position Scoring" @ score.score @ "X" @ sic.GetCell(k).GetCellPosition().X @ "Y" @ sic.GetCell(k).GetCellPosition().Y );
					}
				}

				if(score.score>0.0f && StackCanMoveTo(cstack,sic.GetCell(k))==true)
				{
					score.params = new () class'H7AiActionParam';
					score.params.Clear();
					score.params.SetUnit(APID_1,currentUnit);
					score.params.SetCMapCell(APID_2,sic.GetCell(k));
					scores.AddItem(score);
				}
			}
		}
	}
}

function bool StackCanMoveTo( H7CreatureStack cstack, H7CombatMapCell cell )
{
	local H7CombatMapGridController grid_ctrl;
	local H7CombatMapGrid grid;
	local array<H7CombatMapCell> targetCells;
	local array<H7CombatMapCell> path;
	local bool foundPath;

	grid_ctrl = class'H7CombatMapGridController'.static.GetInstance();
	grid = grid_ctrl.GetCombatGrid();

	targetCells.AddItem(cell);
	foundPath =	cstack.GetPathfinder().GetPath(targetCells[0].GetGridPosition(),path);
	if(foundPath==true)
	{
		if(grid.CanMoveTo(targetCells,cstack)==true)
		{
			return true;
		}
	}
	return false;
}

function bool PerformAction( H7Unit unit, AiActionScore score )
{
	local H7CombatController ctrl;
	local H7CombatMapGridController grid_ctrl;
	local H7CombatMapGrid grid;
	local array<H7CombatMapCell> path;
	local array<H7CombatMapCell> targetCells;
	local bool foundPath;
	local int pid;
	local H7BaseAbility meleeAttackAbilityTemplate;
	local H7BaseAbility meleeAttackAbility;

	ctrl = class'H7CombatController'.static.GetInstance();
	grid_ctrl = class'H7CombatMapGridController'.static.GetInstance();
	grid = grid_ctrl.GetCombatGrid();

	if( unit != None && ctrl != None )
	{
		targetCells.AddItem( score.params.GetCMapCell(APID_2) );
		foundPath =	H7CreatureStack(unit).GetPathfinder().GetPath( targetCells[0].GetGridPosition(), path );
		if(foundPath==true)
		{
			if( grid.CanMoveTo( targetCells, H7CreatureStack(unit) ) )
			{
				// cut path to moveable range
				for(pid=path.Length-1;pid>0;pid--)
				{
					if(path[pid]!=None && path[pid].IsForeshadow()==true)
					{
						if(pid<(path.Length-1))
						{
							targetCells.Remove(0,targetCells.Length);
							targetCells.AddItem(path[pid]);
							path.Remove(pid+1,path.Length-(pid+1));
						}
						break;
					}
				}

				// prepare the default melee attack because all the movements are needed to have the default melee attack ability set.
				meleeAttackAbilityTemplate = unit.GetMeleeAttackAbility();
				if(meleeAttackAbilityTemplate==None) return false;
				meleeAttackAbility = unit.GetAbilityManager().GetAbility( meleeAttackAbilityTemplate );
				if(meleeAttackAbility==None) return false;
				unit.GetAbilityManager().PrepareAbility( meleeAttackAbility );

				grid_ctrl.StartUnitMovement( targetCells[0], targetCells, path );
				return true;
			}
		}
	}
	return false;
}
