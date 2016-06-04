//=============================================================================
// H7AiSensorCreatureStat
//=============================================================================
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorCreatureStat extends H7AiSensorBase;

/// overrides ...

function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	local H7Unit unit;
	local H7CreatureStack creature;
	local ETargetStat stat;

	if(param0.GetPType()==SP_UNIT)
	{
		unit = param0.GetUnit();
		if(unit==None) return 0.0f;
		if(unit.GetEntityType()!=UNIT_CREATURESTACK) return 0.0f;
		creature = H7CreatureStack(unit);
		if(param1.GetPType()!=SP_CREATURESTAT) return 0.0f;
		stat=param1.GetCreatureStat();
		switch(stat)
		{
			case TS_STAT_DESTINY:       return creature.GetLuck();
			case TS_STAT_LEADERSHIP:    return creature.GetMorale();
			case TS_STAT_INITIATIVE:    return creature.GetInitiative();
			case TS_STAT_ATTACK:        return creature.GetAttack();
			case TS_STAT_DEFENSE:       return creature.GetDefense();
		}
	}
	return 0.0f;
}
