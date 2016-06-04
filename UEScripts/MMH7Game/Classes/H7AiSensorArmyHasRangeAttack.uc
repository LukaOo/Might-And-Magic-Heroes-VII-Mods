//=============================================================================
// H7AiSensorArmyHasRangeAttack
//=============================================================================
// Checks simply if army has range attack creatures
//
// implements: GetValue1(CombatArmy)
//             => 1.0f all ranged
//             => 0.5f mixed
//             => 0.0f no ranged
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorArmyHasRangeAttack extends H7AiSensorBase;

/// overrides ...

function float GetValue1( H7AiSensorParam param )
{
	local H7CombatArmy              army;
	local array<H7CreatureStack>    creatures;
	local H7CreatureStack           creature;
	local int                       ranged_count;
	local int                       alive_count;

	if( param.GetPType() == SP_COMBATARMY )
	{
		army = param.GetCombatArmy();
		if( army == None )
		{
			// bad param
			return 0.0f;
		}

		alive_count = 0;
		ranged_count = 0;

		creatures = army.GetCreatureStacks();
		foreach creatures(creature)
		{
			if( creature.IsDead() == false ) 
			{
				alive_count++;
				// could be more sophisticated if we check if a range creature is currently 'suppressed' by enemy creatures so it can't use its range attack
				if( creature.GetCreature().IsRanged() )
				{
					ranged_count++;
				}
			}
		}
		if( ranged_count == alive_count )
		{
			return 1.0f;
		}
		else if( ranged_count != 0 )
		{
			return 0.5f;
		}
		return 0.0f;
	}
	// wrong parameter type
	return 0.0f;
}
