//=============================================================================
// H7AiSensorMeleeCreatureDamage
//=============================================================================
// Amount of average damage a creature of the source enemy stack (first param)
// deals to target stack (second param).
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorMeleeCreatureDamage extends H7AiSensorBase;

function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	local H7Unit attackingUnit, defendingUnit;
	local H7CreatureStack defendingCS, attackingCS;
	local H7CombatResult result;
	local H7BaseAbility meleeAttackAbilityTemplate;
	local H7BaseAbility meleeAttackAbility;
	local int damageTotal, hpTotal, topHealth;
	local int k;
	local H7IEffectTargetable target;
	local H7CreatureStack defenderStack;
	local int resultSize, diff;

	attackingUnit = param0.GetUnit();
	defendingUnit = param1.GetUnit();

	if( param0.GetPType() == SP_UNIT && param1.GetPType() == SP_UNIT )
	{
		if( attackingUnit.GetEntityType() != UNIT_CREATURESTACK || defendingUnit.GetEntityType() != UNIT_CREATURESTACK )
		{
			// wrong unit types
			return 0.0f;
		}
		
		// check if defending stack is dead so we stop further beating on it ;)
		defendingCS = H7CreatureStack(defendingUnit);
		if( defendingCS == None || defendingCS.IsDead() ) return 0.0f;
		attackingCS = H7CreatureStack(attackingUnit);
		if( attackingCS == None || attackingUnit.IsDead() ) return 0.0f;

		// prepare the default melee attack for attacking unit
		meleeAttackAbilityTemplate = attackingUnit.GetMeleeAttackAbility();
		meleeAttackAbility = attackingUnit.GetAbilityManager().GetAbility( meleeAttackAbilityTemplate );

		// simulate fight
		attackingUnit.GetAbilityManager().PrepareAbility( meleeAttackAbility );
		result = attackingUnit.GetPreparedAbility().Activate( defendingCS, true );

		damageTotal=0;
		hpTotal = defendingCS.GetCombatArmy().GetArmyDamagePool();

		// combine damage values for all targeted creature stacks
		//for(k=0;k<result.GetDefenderCount();k++)
		//{
		//	if(result.GetDefender(k).IsA('H7CreatureStack') && result.GetDamage(k)>0.0f)
		//	{
		//		damageTotal += result.GetDamage(k);
		//		hpTotal += result.GetDefender(k).GetStackSize() * result.GetDefender(k).GetHitPoints();
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
					damageTotal += defenderStack.GetDamagePotential( diff );
					damageTotal += defenderStack.GetDamagePotential( 1 ) * ( 1.0f - float( topHealth ) / float( defenderStack.GetHitPoints() ) ); //fractions count, too
				}
				else
				{
					damageTotal += defenderStack.GetDamagePotential( 1 ) * ( 1.0f - float( defenderStack.GetTopCreatureHealth() - topHealth ) / float( defenderStack.GetHitPoints() ) ); //fractions count, too
				}
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			}
		}

		
		


		if(hpTotal==0) return 0.0f;

		return float(damageTotal) / float(hpTotal);
	}

	return 0.0f;
}
