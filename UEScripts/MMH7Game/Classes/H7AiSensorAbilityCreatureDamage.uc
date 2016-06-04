//=============================================================================
// H7AiSensorAbilityCreatureDamage
//=============================================================================
// Amount of damage all recieving enemy stacks will take 
// through a ability damage attack from the first unit (first param).
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorAbilityCreatureDamage extends H7AiSensorBase;

function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	local H7Unit attackingUnit, defendingUnit;
	local H7CreatureStack defendingCS, attackingCS;
	local H7CombatResult result;
	local int damageTotalFriendly, hpTotalFriendly, damageTotalEnemy, hpTotalEnemy;
	local int k, topHealth;
	local H7IEffectTargetable target;
	local float relationFriendly, relationEnemy;
	local H7CreatureStack defenderStack;
	local int resultSize, diff;
	
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
		
		//damageTotal=0;
		//hpTotal=0;

		// combine damage values for all targeted creature stacks
		//for(k=0;k<result.GetDefenderCount();k++)
		//{
		//	if(result.GetDefender(k).IsA('H7CreatureStack') && result.GetDamage(k) > 0.0f )
		//	{
		//		if(result.GetDefender(k).GetPlayer() == attackingCS.GetPlayer()) 
		//		{
		//			damageTotal -= result.GetDamage(k);
		//			hpTotal -= result.GetDefender(k).GetStackSize() * result.GetDefender(k).GetHitPoints();
		//		}
		//		else
		//		{
		//			damageTotal += result.GetDamage(k);
		//			hpTotal += result.GetDefender(k).GetStackSize() * result.GetDefender(k).GetHitPoints();
		//		}
		//	}
		//}

		for(k=0;k<result.GetDefenderCount();k++)
		{
			if(result.GetDefender(k).IsA('H7CreatureStack') && result.GetDamage(k) > 0.0f )
			{
				target = result.GetDefender(k);
				defenderStack = H7CreatureStack( target );
				defenderStack.GetDamageResult( result.GetDamage(k), result.DidMiss(k), topHealth, resultSize );

				diff = defenderStack.GetStackSize() - resultsize;
				if( diff > 0 )
				{
					if( result.GetDefender(k).GetPlayer() == attackingCS.GetPlayer() )
					{
						damageTotalFriendly += defenderStack.GetDamagePotential( diff );
					}
					else
					{
						damageTotalEnemy += defenderStack.GetDamagePotential( diff );
					}
					//damageTotal += defenderStack.GetDamagePotential( 1 ) * ( 1.0f - float( topHealth ) / float( defenderStack.GetHitPoints() ) ); //fractions count, too
				}
				else
				{
					if( result.GetDefender(k).GetPlayer() == attackingCS.GetPlayer() )
					{
						damageTotalFriendly += defenderStack.GetDamagePotential( 1 ) * ( 1.0f - float( defenderStack.GetTopCreatureHealth() - topHealth ) / float( defenderStack.GetHitPoints() ) ); //fractions count, too
					}
					else
					{
						damageTotalEnemy += defenderStack.GetDamagePotential( 1 ) * ( 1.0f - float( defenderStack.GetTopCreatureHealth() - topHealth ) / float( defenderStack.GetHitPoints() ) ); //fractions count, too
					}
				}

			}
		}

		hpTotalEnemy = defendingCS.GetCombatArmy().GetArmyDamagePool();
		hpTotalFriendly = attackingCS.GetCombatArmy().GetArmyDamagePool();


		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

		if( damageTotalFriendly > damageTotalEnemy || damageTotalEnemy <= 0.0f ) 
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			return 0.0f;
		}

		//if(hpTotal<=0.0f || damageTotal<=0.0f) return 0.0f;

		relationFriendly = float(damageTotalFriendly) / float(hpTotalFriendly);
		relationEnemy = float(damageTotalEnemy) / float(hpTotalEnemy);
		
		if( relationEnemy - relationFriendly > 0 )
		{
			return relationEnemy - relationFriendly;
		}
		else
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			return 0.0f;
		}
	}

	return 0.0f;
}
