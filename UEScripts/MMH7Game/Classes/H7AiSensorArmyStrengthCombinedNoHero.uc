//=============================================================================
// H7AiSensorArmyStrengthCombinedNoHero (DEPRECATED)
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorArmyStrengthCombinedNoHero extends H7AiSensorBase;

/// overrides ...

function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	local H7AdventureArmy army;
	local float armyStrength0,armyStrength1;

//	`LOG_AI("Sensor.ArmyStrengthCombinedNoHero");

	if( param0.GetPType() == SP_ADVENTUREARMY )
	{
		army = param0.GetAdventureArmy();
		if( army == None ) return 0.0f;
		armyStrength0 = army.GetStrengthValue( false);
	}
	else
	{
		// wrong parameter types
		return 0.0f;
	}

//	`LOG_AI("  Source" @ army @ "Strength" @ armyStrength0 );

	if( param1.GetPType() == SP_ADVENTUREARMY )
	{
		army = param1.GetAdventureArmy();
		if( army == None ) return 0.0f;
		armyStrength1 = army.GetStrengthValue( false);
		if( army.GetAiOnIgnore() == true ) return 0.0f;
	}
	else
	{
		// wrong parameter types
		return 0.0f;
	}

//	`LOG_AI("  Target" @ army @ "Strength" @ armyStrength1);

	if( armyStrength1 > 0.0f )
	{
		return armyStrength0 / armyStrength1;
	}
	return 1000.0f;
}
