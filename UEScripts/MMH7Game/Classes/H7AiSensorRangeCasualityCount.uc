//=============================================================================
// H7AiSensorRangeCasualityCount
//=============================================================================
// Number of creatures the recieving enemy stack (second param) will lose 
// through a melee attack from the first unit (first param).
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorRangeCasualityCount extends H7AiSensorBase;

function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	local H7Unit attackingUnit, defendingUnit;
	local H7CreatureStack defendingCS, attackingCS;
	local H7CombatResult result;
	local int topCHealth, resultSize, bodyCount;
	local int k;

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

		// simulate fight (ability needs to be prepared in advance)
		//attackingUnit.GetAbilityManager().PrepareAbility( rangeAttackAbility );
		result = attackingUnit.GetPreparedAbility().Activate( defendingCS, true );

		bodyCount=0;

		// combine casualities for all targeted creature stacks
		for(k=0;k<result.GetDefenderCount();k++)
		{
			if( result.GetDefender(k).IsA('H7CreatureStack') && result.GetDamage(k) > 0.0f )
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

				defendingCS.GetDamageResult( result.GetDamage(k), result.DidMiss(k), topCHealth, resultSize );
				bodyCount += result.GetDefender(k).GetStackSize() - resultSize;
				// if one defender was a friendly creature we immediately return 0
				if(result.GetDefender(k).GetPlayer() == attackingUnit.GetPlayer()) 
				{
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
					return 0.0f;
				}
			}
		}

		return (1.0f + float(bodyCount));
	}

	return 0.0f;
}
