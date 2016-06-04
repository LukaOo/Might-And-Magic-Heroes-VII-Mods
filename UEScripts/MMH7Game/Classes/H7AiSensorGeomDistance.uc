//=============================================================================
// H7AiSensorGeomDistance
//=============================================================================
// Calculates the geometric distance in normalized units (cell edge length=1)
// on combat map between points either by specifing the grid cells directly or
// by providing game units (creature stacks).
//
// GridCell      <-> GridCell
// CreatureStack <-> CreatureStack
// CreatureStack <-> GridCell
// GridCell      <-> CreatureStack
//
// implements: GetValue2(a,b)
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorGeomDistance extends H7AiSensorBase;

function float GetDistanceC2C( H7CombatMapCell cellStart, H7CombatMapCell cellEnd )
{
	local Vector    vecStart, vecEnd;
	local float     distance;
	if( cellStart == None || cellEnd == None ) return class'H7CombatMapPathfinder'.const.INFINITE;
	vecStart    = cellStart.GetCenterPos();
	vecEnd      = cellEnd.GetCenterPos();
	distance = class'H7Math'.static.GetDistance(vecStart,vecEnd) / class'H7BaseCell'.const.CELL_SIZE;
	return distance;
}

function float GetDistanceU2U( H7Unit unitStart, H7Unit unitEnd )
{
	local Vector    vecStart, vecEnd;
	local float     distance;
	local H7CombatMapGrid   grid;
	if( unitStart == None || unitEnd == None ) return class'H7CombatMapPathfinder'.const.INFINITE;
	grid = class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid();
	vecStart    = grid.GetCellByIntPoint( unitStart.GetGridPosition() ).GetCenterPos();
	vecEnd      = grid.GetCellByIntPoint( unitEnd.GetGridPosition() ).GetCenterPos();
	distance = class'H7Math'.static.GetDistance(vecStart,vecEnd) / class'H7BaseCell'.const.CELL_SIZE;
	return distance;
}

function float GetDistanceU2C( H7Unit unitStart, H7CombatMapCell cellEnd )
{
	local Vector    vecStart, vecEnd;
	local float     distance;
	if( unitStart == None || cellEnd == None ) return class'H7CombatMapPathfinder'.const.INFINITE;
	vecStart    = class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid().GetCellByIntPoint( unitStart.GetGridPosition() ).GetCenterPos();
	vecEnd      = cellEnd.GetCenterPos();
	distance = class'H7Math'.static.GetDistance(vecStart,vecEnd) / class'H7BaseCell'.const.CELL_SIZE;
	return distance;
}

/// overrides ...

function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	local H7Unit unit0, unit1;
	local H7CombatMapCell   cell0, cell1;

	cell0 = param0.GetCMapCell();
	cell1 = param1.GetCMapCell();
	unit0 = param0.GetUnit();
	unit1 = param1.GetUnit();

	if( param0.GetPType() == SP_CMAPCELL && param1.GetPType() == SP_CMAPCELL )
	{
		return GetDistanceC2C(cell0,cell1);
	}
	else if( param0.GetPType() == SP_UNIT && param1.GetPType() == SP_UNIT )
	{
		if( unit0.GetEntityType() != UNIT_CREATURESTACK || unit1.GetEntityType() != UNIT_CREATURESTACK )
		{
			// wrong unit types
			return class'H7CombatMapPathfinder'.const.INFINITE;
		}
		return GetDistanceU2U(unit0,unit1);
	}
	else if( param0.GetPType() == SP_CMAPCELL && param1.GetPType() == SP_UNIT )
	{
		if( unit1.GetEntityType() != UNIT_CREATURESTACK )
		{
			// wrong unit type
			return class'H7CombatMapPathfinder'.const.INFINITE;
		}
		return GetDistanceU2C(unit1,cell0);
	}
	else if( param0.GetPType() == SP_UNIT && param1.GetPType() == SP_CMAPCELL )
	{
		if( unit0.GetEntityType() != UNIT_CREATURESTACK )
		{
			// wrong unit type
			return class'H7CombatMapPathfinder'.const.INFINITE;
		}
		return GetDistanceU2C(unit0,cell1);
	}

	// wrong parameter types
	return class'H7CombatMapPathfinder'.const.INFINITE;
}
