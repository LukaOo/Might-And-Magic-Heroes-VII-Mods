//=============================================================================
// H7AiSensorAbilityCasualityCount
//=============================================================================
// Number of creatures all recieving enemy stacks will lose 
// through a ability damage attack from the first unit (first param).
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorAbilityCasualityCount extends H7AiSensorBase;

function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	local H7Unit attackingUnit, defendingUnit;
	local H7CreatureStack defendingCS, attackingCS, defenderStack;
	local H7CombatResult result;
	local int topCHealth, resultSize, bodyCount;
	local int k;
	local H7IEffectTargetable target;
	
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

		// simulate fight (ability needs to be prepared before calling this sensor)
		result = attackingUnit.GetPreparedAbility().Activate( defendingCS, true );
		
		bodyCount=0;

		// combine casualities for all targeted creature stacks
		for(k=0;k<result.GetDefenderCount();k++)
		{
			// PiercingShot damages GridCells !!! so we need to check the defender types ...
			if( result.GetDefender(k).IsA('H7CreatureStack') && result.GetDamage(k) > 0.0f )
			{
//				`LOG_AI("   Defender" @ result.GetDefender(k) @ result.GetDamage(k) );
				target = result.GetDefender(k);
				defenderStack = H7CreatureStack( target );
				defenderStack.GetDamageResult( result.GetDamage(k), result.DidMiss(k), topCHealth, resultSize );
				bodyCount += result.GetDefender(k).GetStackSize() - resultSize;
				// if one defender was a friendly creature we reduce body count
				if(result.GetDefender(k).GetPlayer() == attackingUnit.GetPlayer()) 
				{
//					`LOG_AI("   Reduction because of friendly fire.");
					bodyCount -= (result.GetDefender(k).GetStackSize() - resultSize);
				}
				else
				{
					bodyCount += (result.GetDefender(k).GetStackSize() - resultSize);
				}
			}
		}

		return (1.0f + float(bodyCount));
	}

	return 0.0f;
}
