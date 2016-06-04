//=============================================================================
// H7AiSensorCreatureAdjacentToEnemy
//=============================================================================
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorCreatureAdjacentToEnemy extends H7AiSensorBase;

/// overrides ...

function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	local H7Unit unit;
	local H7CreatureStack creature;
	local array<H7CreatureStack> neighbors;
	local H7CombatHero hero;

	if(param0.GetPType()==SP_UNIT)
	{
		unit = param0.GetUnit();
		if(unit==None) return 0.0f;
		if(unit.GetEntityType()!=UNIT_CREATURESTACK) return 0.0f;
		creature = H7CreatureStack(unit);
	}
	if(param1.GetPType()==SP_UNIT)
	{
		unit = param1.GetUnit();
		if(unit==None) return 0.0f;
		if(unit.GetEntityType()!=UNIT_HERO) return 0.0f;
		hero = H7CombatHero(unit);
	}
		
	if(creature==None || hero==None) return 0.0f;

	neighbors=creature.GetNeighbourHostileStacks(hero);
	if(neighbors.Length>0) return 1.0f;

	return 0.0f;
}
