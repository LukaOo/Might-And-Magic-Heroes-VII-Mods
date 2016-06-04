//=============================================================================
// H7AiSensorHealingPercentage
//=============================================================================
// Number of creatures the recieving allied stack (second param) will gain 
// through an ability healing attempt from the first unit (first param).
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorHealingPercentage extends H7AiSensorBase;

function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	local H7Unit attackingUnit, defendingUnit;
	local H7CreatureStack defendingCS, attackingCS;
	local H7CombatResult result;
	local int topCHealth, resultSize;
	local int orgHealth, curHealth;
	local float ocHealthRatio, ocHealthRatioAfter;

	attackingUnit = param0.GetUnit();
	defendingUnit = param1.GetUnit();

	if( param0.GetPType() == SP_UNIT && param1.GetPType() == SP_UNIT )
	{
		if( attackingUnit.GetEntityType() != UNIT_CREATURESTACK || defendingUnit.GetEntityType() != UNIT_CREATURESTACK ) {
			// wrong unit types
			return 0.0f;
		}
		
		// check if defending stack is dead so we stop further beating on it ;)
		defendingCS = H7CreatureStack(defendingUnit);
		if( defendingCS == None || defendingCS.IsDead() ) return 0.0f;
		attackingCS = H7CreatureStack(attackingUnit);
		if( attackingCS == None || attackingCS.IsDead() ) return 0.0f;

		// simulate fight
		// !!! the ability of the attacker needs to be prepared in advance ...
		result = attackingUnit.GetPreparedAbility().Activate( defendingCS, true );
		if( result.GetDamage() == 0.0f ) return 0.0f;

		defendingCS.GetDamageResult( result.GetDamage(), result.DidMiss(), topCHealth, resultSize );

		if( result.IsHeal(0) == true )
		{
			orgHealth = defendingCS.GetInitialStackSize() * defendingCS.GetHitPoints();
			curHealth = (defendingCS.GetStackSize() - 1)  * defendingCS.GetHitPoints() + defendingCS.GetTopCreatureHealth();

			ocHealthRatio      = float(curHealth) / float(orgHealth);
			curHealth += result.GetDamage();
			if( curHealth > orgHealth ) 
			{
				curHealth = orgHealth;
			}
			ocHealthRatioAfter = float(curHealth) / float(orgHealth);
		
			// we return the gained percentage directly
			return ocHealthRatioAfter-ocHealthRatio;
		}
	}

	return 0.0f;
}
