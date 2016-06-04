//=============================================================================
// H7AiSensorHasAdjacentEnemy
//=============================================================================
//
// implements: GetValue2(CreatureStack,CreatureStack)
//             =>  1.0f enemy is close
//             =>  0.0f enemy is not close
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorHasAdjacentEnemy extends H7AiSensorBase;

/// overrides ...

function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	local H7Unit unit, targetUnit;
	local H7CombatMapGridController   grid_ctrl;
	local H7CombatController ctrl;
	local H7CombatArmy otherArmy;
	local array<H7CreatureStack> otherCreatures;
	local H7CreatureStack creature;

	unit = param0.GetUnit();
	targetUnit = param1.GetUnit();
	grid_ctrl = class'H7CombatMapGridController'.static.GetInstance();
	ctrl = class'H7CombatController'.static.GetInstance();

	if( param0.GetPType() == SP_UNIT )
	{
		if( param1.GetPType() != SP_UNIT || targetUnit==None )
		{
			if( unit.GetEntityType() == UNIT_CREATURESTACK )
			{
				// we only have the creature stack in question so we query and test for all opponent creature stacks to check if anyone of these is adjacent
				otherArmy = ctrl.GetOpponentArmy( unit.GetCombatArmy() );
				otherArmy.GetSurvivingCreatureStacks( otherCreatures );
				foreach otherCreatures( creature )
				{
					if( grid_ctrl.IsTargetInMeleeRange(unit,creature) == true )
					{
//						`LOG_AI("... suppression check" @ creature @ creature.GetName() @ "yes" );
						return 1.0f;
					}
//					`LOG_AI("... suppression check" @ creature @ creature.GetName() @ "no" );
				}
				return 0.0f;
			}
			else
			{
				// wrong unit type
				return 0.0f;
			}
		}
		else
		{
			if( targetUnit.GetEntityType() == UNIT_CREATURESTACK )
			{
				if( grid_ctrl.IsTargetInMeleeRange(unit,targetUnit) == true )
				{
					return 1.0f;
				}
				return 0.0f;
			}
			else
			{
				// wrong unit type
				return 0.0f;
			}
		}
	}
	// wrong parameter types
	return 0.0f;
}


