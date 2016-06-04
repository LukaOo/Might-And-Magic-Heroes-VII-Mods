//=============================================================================
// H7AiSensorCreatureIsRanged
//=============================================================================
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorCreatureIsRanged extends H7AiSensorBase;

/// overrides ...

function float GetValue1( H7AiSensorParam param )
{
	local H7Unit unit;
	local H7CreatureStack creature;
	if(param.GetPType()==SP_UNIT)
	{
		unit = param.GetUnit();
		if(unit==None) return 0.0f;
		if(unit.GetEntityType()!=UNIT_CREATURESTACK) return 0.0f;
		creature = H7CreatureStack(unit);
		if(creature.IsRanged()==true) return 1.0f;
	}
	return 0.0f;
}
