//=============================================================================
// H7AiSensorCanRangeAttack
//=============================================================================
// Checks simply if a unit can currently perform a range attack. 
//
// implements: GetValue1(CreatureStack)
//             => 1.0f yes
//             => 0.0f no
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorCanRangeAttack extends H7AiSensorBase;

/// overrides ...

function float GetValue1( H7AiSensorParam param )
{
	local H7Unit unit;
	local H7CreatureStack creature;

	if( param.GetPType() == SP_UNIT )
	{
		unit=param.GetUnit();
		if(unit==None)return 0.0f;
		creature =  H7CreatureStack(unit);
		if(creature==None) return 0.0f;
		if(creature.IsDead()==true || creature.GetCreature().IsRanged()==false || !class'H7CombatController'.static.GetInstance().CanRangeAttack( creature ) )
		{
			return 0.0f;
		}
		return 1.0f;
	}
	// wrong parameter type
	return 0.0f;
}
