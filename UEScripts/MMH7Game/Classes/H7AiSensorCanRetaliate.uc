//=============================================================================
// H7AiSensorCanRetaliate
//=============================================================================
// Checks simply if a unit can currently retaliate. 
//
// implements: GetValue1(CreatureStack)
//             => 1.0f yes
//             => 0.0f no
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorCanRetaliate extends H7AiSensorBase;

/// overrides ...

function float GetValue1( H7AiSensorParam param )
{
	local H7Unit unit;
	local H7CreatureStack creature;

	if( param.GetPType() == SP_UNIT )
	{
		unit = param.GetUnit();
		if( unit == None )	{
			// bad param
			return 0.0f;
		}
		if( unit.GetEntityType() != UNIT_CREATURESTACK  )
		{
			// wrong unit type
			return 0.0f;
		}
		creature =  H7CreatureStack(unit);
		if( creature.CanRetaliate() == false ) // CanRetaliate() checks internaly for IsDead() to
		{
			return 0.0f;
		}
		else
		{
			return 1.0f;
		}
	}
	// wrong parameter type
	return 0.0f;
}
