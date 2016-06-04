//=============================================================================
// H7AiSensorArmyStrength (DEPRECATED)
//=============================================================================
// TroopStrength = |Core| +|CoreUpg.|*1,5 + |Elite|*4 + |EliteUpg.|*6 + |Champion| *16 + |ChampionUpg.| *24
// -> if a hero is present: HeroModifier = 1,16 + 0,04 * HeroLevel
// -> if no hero: HeroModifier = 1
// Ae = TroopStrength * HeroModifier
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorArmyStrength extends H7AiSensorBase;

/// overrides ...

function float GetValue1( H7AiSensorParam param0  )
{
	local H7AdventureArmy army;
	local float troopStrength;

	if( param0.GetPType() == SP_ADVENTUREARMY )
	{
		army = param0.GetAdventureArmy();
		if( army == None ) return 0.0f;
		troopStrength=army.GetStrengthValue(true);
		return troopStrength;
	}
	// wrong parameter types
	return 0.0f;
}
