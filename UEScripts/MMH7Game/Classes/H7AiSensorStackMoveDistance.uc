//=============================================================================
// H7AiSensorStackMoveDistance
//=============================================================================
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorStackMoveDistance extends H7AiSensorBase;

function float GetMoveDistanceCell( H7Unit unitSource, H7CombatMapCell cellToReach )
{
	local array<H7CombatMapCell> path;
	local array<H7CombatMapCell> targetCells;
	local bool foundPath;
	local float plen, mp;

	if( unitSource==None || cellToReach==None ) return 5.0f;
	if( unitSource.GetEntityType()!=UNIT_CREATURESTACK ) return 5.0f;

	targetCells.AddItem(cellToReach);

	foundPath =	H7CreatureStack(unitSource).GetPathfinder().GetPath( targetCells[0].GetGridPosition(), path );
	if(foundPath==true)
	{
		plen=path.Length;
		if(mp<1.0f) mp=1.0f;
		mp=unitSource.GetMovementPoints();
		if(mp<1.0f) mp=1.0f;
		return plen / mp;
	}
	return 5.0f;
}

function float GetMoveDistanceUnit( H7Unit unitSource, H7Unit unitToReach )
{
	local array<H7CombatMapCell> path;
	local array<H7CombatMapCell> targetCells;
	local bool foundPath;
	local float plen, mp;

	if( unitSource==None || unitToReach==None ) return 5.0f;
	if( unitSource.GetEntityType()!=UNIT_CREATURESTACK ) return 5.0f;
	if( unitToReach.GetEntityType()!=UNIT_CREATURESTACK ) return 5.0f;
	
	targetCells = H7CreatureStack(unitToReach).GetNeighbourCells();
	foundPath =	H7CreatureStack(unitSource).GetPathfinder().GetPath( targetCells[0].GetGridPosition(), path );
	if(foundPath==true)
	{
		plen=path.Length;
		if(mp<1.0f) mp=1.0f;
		mp=unitSource.GetMovementPoints();
		if(mp<1.0f) mp=1.0f;
		return plen / mp;
	}
	return 5.0f;
}

/// overrides ...

function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	local H7Unit unit0, unit1;
	local H7CombatMapCell   cell;
	cell = param1.GetCMapCell();
	unit0 = param0.GetUnit();
	unit1 = param1.GetUnit();
	if(param0.GetPType()==SP_UNIT)
	{
		if( unit0.GetEntityType()!=UNIT_CREATURESTACK ) return 0.0f;

		if( param1.GetPType()==SP_CMAPCELL ) 
		{
			return GetMoveDistanceCell(unit0,cell);
		}
		if( param1.GetPType()==SP_UNIT )
		{
			if( unit1.GetEntityType()!=UNIT_CREATURESTACK ) return 0.0f;
			return GetMoveDistanceUnit(unit0,unit1);
		}
	}
	// wrong parameter types
	return 0.0f;
}


