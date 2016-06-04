//=============================================================================
// H7AiSensorPlayerArmiesCompare
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorPlayerArmiesCompare extends H7AiSensorBase;

/// overrides ...

function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	local array<H7AdventureArmy> armies;
	local H7AdventureArmy army;
	local float troopStrength;
	local float armyStrength0,armyStrength1;
	local H7Player pl;

//	`LOG_AI("Sensor.PlayerArmiesCompare");

	if( param0.GetPType() == SP_PLAYER )
	{
		pl=param0.GetPlayer();
		if(pl==None) return 0.0f;   // bad parameter ...

		armyStrength0=0.0f;

		armies=pl.GetArmies();
		foreach armies( army )
		{
			if(army!=None && army.GetHero()!=None && army.GetHero().IsHero()==true )
			{
				troopStrength=army.GetStrengthValue(false);
				if( armyStrength0 < troopStrength ) armyStrength0=troopStrength;
			}
		}
	}
	else
	{
		// wrong parameter types
		return 0.0f;
	}

	if( param1.GetPType() == SP_PLAYER )
	{
		pl=param1.GetPlayer();
		if(pl==None) return 0.0f;   // bad parameter ...

		armyStrength1=0.0f;

		armies=pl.GetArmies();
		foreach armies( army )
		{
			if(army!=None && army.GetHero()!=None && army.GetHero().IsHero()==true )
			{
				troopStrength=army.GetStrengthValue(false);
				if( armyStrength1 < troopStrength ) armyStrength1=troopStrength;
			}
		}
	}
	else
	{
		// wrong parameter types
		return 0.0f;
	}

//	`LOG_AI("  Target" @ army @ "Strength" @ armyStrength1);

	return min( 1.0f, (max(1.0f,armyStrength0) / max(1.0f,armyStrength1)) );
}
