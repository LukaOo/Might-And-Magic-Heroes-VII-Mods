//=============================================================================
// H7AiSensorGridCellReachable
//=============================================================================
// Checks if a position on the combat map is reachable by a unit in one turn.
//
// implements: GetValue2(CreatureStack,GridCell)
//             => 1.0f reachable
//             => 0.0f not reachable
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorGridCellReachable extends H7AiSensorBase;

function float GetReachableCell( H7Unit unitSource, H7CombatMapCell cellToReach )
{
	local array<H7CombatMapCell> reachableCells;

	if( unitSource == None || cellToReach == None ) return 0.0f;
	if( unitSource.GetEntityType() != UNIT_CREATURESTACK ) return 0.0f;

	H7CreatureStack(unitSource).GetPathfinder().GetReachableCells( H7CreatureStack(unitSource).GetMovementPoints(), reachableCells );
	
	if( reachableCells.Find( cellToReach ) != INDEX_NONE )
	{
		return 1.0f;
	}
	return 0.0f;
}

function float GetReachableUnit( H7Unit unitSource, H7Unit unitToReach )
{
	return 0.0f;
}

/// overrides ...

function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	local H7Unit unit0, unit1;
	local H7CombatMapCell   cell;

	cell = param1.GetCMapCell();
	unit0 = param0.GetUnit();
	unit1 = param1.GetUnit();

	if( param0.GetPType() == SP_UNIT )
	{
		if( unit0.GetEntityType() != UNIT_CREATURESTACK )
		{
			// wrong unit type for param0
			return 0.0f;
		}
		if( param1.GetPType() == SP_CMAPCELL )
		{
			return GetReachableCell(unit0,cell);
		}
		else if( param1.GetPType() == SP_UNIT )
		{
			if( unit1.GetEntityType() != UNIT_CREATURESTACK )
			{
				// wrong unit type for param1
				return 0.0f;
			}
			return GetReachableUnit(unit0,unit1);
		}
	}
	// wrong parameter types
	return 0.0f;
}


