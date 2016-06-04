//=============================================================================
// H7AiSensorCanCastBuff
//=============================================================================
// Checks if unit has a buff spell
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorCanCastBuff extends H7AiSensorBase;

/// overrides ...

function float GetValue1( H7AiSensorParam param )
{
	local H7Unit unit;
	local H7CreatureStack creature;
	local H7CombatHero hero;
	local array<H7BaseAbility> abilities;
	local H7BaseAbility ability;
	local H7HeroAbility heroAbility;
	local H7CreatureAbility creatureAbility;

	if( param.GetPType() == SP_UNIT )
	{
		unit = param.GetUnit();
		if( unit == None )
		{
			// bad param
			return 0.0f;
		}

		// BEWARE: VERY HARCODED - TRAVERSE AT YOUR OWN RISK >_> 
		// TARGET_ALLY & TARGET_ENEMY are not good enough to distinguish between buff/debuff
		if( unit.GetEntityType() == UNIT_CREATURESTACK )
		{
			creature = H7CreatureStack(unit);
			creature.GetAbilityManager().GetAbilities( abilities );
			foreach abilities( ability )
			{
				creatureAbility = H7CreatureAbility( ability );

				if( creatureAbility.HasPositiveEffect() && creatureAbility.GetNumCharges() > 0 )
				{
					return 1.0f;
				}
			}
			return 0.0f;
		}
		else if( unit.GetEntityType() == UNIT_HERO )
		{
			hero = H7CombatHero( unit );
			hero.GetAbilityManager().GetAbilities( abilities );
			foreach abilities( ability )
			{
				heroAbility = H7HeroAbility( ability );
				if( heroAbility.HasPositiveEffect() && hero.GetCurrentMana() >= heroAbility.GetManaCost() )
				{
					return 1.0f;
				}
			}
			return 0.0f;
		}
		if( creature.IsDead() )
		{
			return 0.0f;
		}
	}
	// wrong parameter type
	return 0.0f;
}
