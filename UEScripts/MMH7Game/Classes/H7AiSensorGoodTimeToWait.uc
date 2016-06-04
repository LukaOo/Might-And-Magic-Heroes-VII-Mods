//=============================================================================
// H7AiSensorGoodTimeToWait
//=============================================================================
// 
// Checks if it's a good time to wait
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorGoodTimeToWait extends H7AiSensorBase;

/// overrides ...

function float GetValue1( H7AiSensorParam param )
{
	local H7Unit baseUnit;
	local H7CreatureStack baseStack, evaluationStack;
	local array<H7Unit> iniQueue;
	local array<H7CreatureStack> enemyStacks;
	local array<H7CombatMapCell> cells, neighbours, reachableCells;
	local H7CombatMapCell cell, neighbour;
	local bool canReach, anyMeleeCreatureCanReach;
	
	if( param.GetPType() == SP_UNIT )
	{
		baseUnit = class'H7CombatController'.static.GetInstance().GetActiveUnit();
		baseStack = H7CreatureStack( baseUnit );

		if( baseStack == None )
		{
			return 0.0f;
		}

		if( baseStack.IsWaitTurn() || baseStack.IsMoralTurn() )
		{
			return 0.0f;
		}

		iniQueue = class'H7CombatController'.static.GetInstance().GetInitiativeQueue().GetInitiativeQueue();

		if( iniQueue.Length == 1 )
		{
			return 0.0f;
		}

		if( baseUnit.IsAttacker() )
		{
			enemyStacks = class'H7CombatController'.static.GetInstance().GetArmyDefender().GetCreatureStacks();
		}
		else
		{
			enemyStacks = class'H7CombatController'.static.GetInstance().GetArmyAttacker().GetCreatureStacks();
		}

		foreach enemyStacks( evaluationStack )
		{
			if( evaluationStack.IsDead() ) { continue; }

			if( evaluationStack.IsRanged() &&
				baseStack.GetInitiative() >= evaluationStack.GetInitiative() &&
				evaluationStack.GetAttackRange() == CATTACKRANGE_HALF &&
				!baseStack.IsRanged() &&
				!evaluationStack.GetCell().mGridController.GetCombatGrid().UnitsInHalfRange( baseStack, evaluationStack ) )
			{
				cells = evaluationStack.GetCell().GetMergedCells();
				baseStack.GetPathfinder().GetReachableCells( baseStack.GetMovementPoints(), reachableCells );
				foreach cells( cell )
				{
					neighbours = cell.GetNeighbours();
					foreach neighbours( neighbour )
					{
						canReach = reachableCells.Find( neighbour ) != INDEX_NONE;

						if( canReach )
						{
							break;
						}
					}

					if( canReach )
					{
						break;
					}
				}

				if( !canReach )
				{
					return 1.0f;
				}
			}

			if( baseStack.IsRanged() && anyMeleeCreatureCanReach )
			{
				return 0.0f;
			}
			
			if( !evaluationStack.IsRanged() &&
				baseStack.GetInitiative() < evaluationStack.GetInitiative() &&
				baseStack.GetAttackRange() == CATTACKRANGE_HALF &&
				baseStack.IsRanged() &&
				class'H7CombatController'.static.GetInstance().GetInitiativeQueue().IsARemainingUnit( evaluationStack ) &&
				!baseStack.GetCell().mGridController.GetCombatGrid().UnitsInHalfRange( evaluationStack, baseStack ) )
			{

				cells = baseStack.GetCell().GetMergedCells();
				evaluationStack.GetPathfinder().GetReachableCells( evaluationStack.GetMovementPoints(), reachableCells );
				foreach cells( cell )
				{
					neighbours = cell.GetNeighbours();
					foreach neighbours( neighbour )
					{
						canReach = reachableCells.Find( neighbour ) != INDEX_NONE;

						if( canReach )
						{
							anyMeleeCreatureCanReach = true;
							break;
						}
					}

					if( canReach )
					{
						break;
					}
				}

				if( !canReach )
				{
					return 1.0f;
				}
			}

			if( baseStack.IsRanged() && !baseStack.CanRangeAttack() )
			{
				return 1.0f;
			}
		}

		return 0.0f;
	}
	// wrong parameter types
	return 0.0f;
}


