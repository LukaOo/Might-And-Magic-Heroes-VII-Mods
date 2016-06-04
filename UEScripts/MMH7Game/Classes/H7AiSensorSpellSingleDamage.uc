//=============================================================================
// H7AiSensorSpellSingleDamage
//=============================================================================
// Checks how much HP of the target stack a hero can damage
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorSpellSingleDamage extends H7AiSensorBase;

function float GetValue1( H7AiSensorParam param  )
{
	local H7Unit defendingUnit;
	local H7CreatureStack defendingCreature;
	local H7CombatResult result;
	local int k;
	local H7IEffectTargetable target;
	local H7CreatureStack defenderStack;
	local int resultSize, diff, topHealth;
	local float damageTotal, hpTotal;

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	if( param.GetPType()==SP_UNIT )
	{
		defendingUnit = param.GetUnit();
		if(defendingUnit==None) return 0.0f;
		defendingCreature = H7CreatureStack(defendingUnit);
		if(defendingCreature==None) return 0.0f;
		
		hpTotal = defendingCreature.GetCombatArmy().GetArmyDamagePool();

		

		if( !defendingCreature.IsDead() && class'H7CombatController'.static.GetInstance().GetActiveUnit().GetPreparedAbility().CanCastOnTargetActor(defendingCreature)==true )
		{
			result = class'H7CombatController'.static.GetInstance().GetActiveUnit().GetPreparedAbility().Activate(defendingCreature,true,EDirection_MAX);

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

			class'H7CombatController'.static.GetInstance().DestroyAllStackGhosts();

			if(hpTotal==0) return 0.0f;

			return damageTotal / hpTotal;
		}
	}
	return 0.0f;
}
