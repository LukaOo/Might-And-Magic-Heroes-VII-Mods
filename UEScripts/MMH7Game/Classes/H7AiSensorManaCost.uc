//=============================================================================
// H7AiSensorManaCost
//=============================================================================
// Returns the percentage of mana a spell would consume if casted.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorManaCost extends H7AiSensorBase;

/// overrides ...
function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	local H7Unit unit;
	local H7HeroAbility ability;

	if( param0.GetPType() == SP_UNIT && param1.GetPType() == SP_HEROABILITY )
	{
		unit = param0.GetUnit();
		if( unit == None )	return 0.0f;
		if( unit.GetEntityType() != UNIT_HERO  ) return 0.0f;
		ability = param1.GetHeroAbility();
		if( ability == None ) return 0.0f;
		
		if( ability.GetManaCost() <= 0 ) return 0.0f;
		if( H7CombatHero(unit).GetCurrentMana() <= 0 ) return 1.0f;

		return float(ability.GetManaCost()) / float(H7CombatHero(unit).GetCurrentMana());
	}
	// wrong parameter type
	return 0.0f;
}
