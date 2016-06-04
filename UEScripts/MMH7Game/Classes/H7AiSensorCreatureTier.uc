//=============================================================================
// H7AiSensorCreatureTier
//=============================================================================
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorCreatureTier extends H7AiSensorBase;

/// overrides ...

function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	local H7Unit unit;
	local H7CreatureStack creature;
	local ECreatureTier tier;

	if(param1.GetPType()==SP_CREATURETIER)
	{
		tier=param1.GetCreatureTier();
	}
	else
	{
		tier=CTIER_CORE;
	}

	if(param0.GetPType()==SP_UNIT)
	{
		unit = param0.GetUnit();
		if(unit==None) return 0.0f;
		if(unit.GetEntityType()!=UNIT_CREATURESTACK) return 0.0f;
		creature = H7CreatureStack(unit);
		if(creature.GetCreature().GetTier()==tier) return 1.0f;
	}
	return 0.0f;
}
