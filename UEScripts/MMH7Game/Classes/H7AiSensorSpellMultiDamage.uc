//=============================================================================
// H7AiSensorSpellMultiDamage
//=============================================================================
// Checks how much HP of the target stack(s) a hero can damage
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorSpellMultiDamage extends H7AiSensorBase;

function float GetValue1( H7AiSensorParam param )
{
	local H7Unit defendingUnit;
	local H7CreatureStack defendingCreature;
	local H7CombatResult result;
	local int k;
	local H7IEffectTargetable target;
	local H7CreatureStack defenderStack;
	local int resultSize, diff, topHealth;
	local int damageTotalFriendly, hpTotalFriendly, damageTotalEnemy, hpTotalEnemy;
	local float relationFriendly, relationEnemy;
	local H7CombatMapCell cell;

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	if( param.GetPType()==SP_UNIT )
	{
		defendingUnit = param.GetUnit();
		if(defendingUnit==None) return 0.0f;
		defendingCreature = H7CreatureStack(defendingUnit);
		if(defendingCreature==None) return 0.0f;
		
		// the defending unit is just our primary target. The spell can effect more (area spells, etc.)
		if( !defendingCreature.IsDead() && class'H7CombatController'.static.GetInstance().GetActiveUnit().GetPreparedAbility().CanCastOnTargetActor(defendingCreature)==true )
		{
			result = class'H7CombatController'.static.GetInstance().GetActiveUnit().GetPreparedAbility().Activate(defendingCreature,true,EDirection_MAX);
			class'H7CombatController'.static.GetInstance().DestroyAllStackGhosts();

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
						if( result.GetDefender(k).GetPlayer() == result.GetAttacker().GetPlayer() )
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
						if( result.GetDefender(k).GetPlayer() == result.GetAttacker().GetPlayer() )
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

			hpTotalEnemy = defendingCreature.GetCombatArmy().GetArmyDamagePool();
			hpTotalFriendly = result.GetAttacker().GetCombatArmy().GetArmyDamagePool();


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
	}
	else if( param.GetPType()==SP_CMAPCELL )
	{
		cell=param.GetCMapCell();
		if(cell==None) return 0.0f;
		// the target cell is just our primary target. The spell can effect more (area spells, etc.)
		if( class'H7CombatController'.static.GetInstance().GetActiveUnit().GetPreparedAbility().CanCastOnTargetActor(cell)==true )
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			result = class'H7CombatController'.static.GetInstance().GetActiveUnit().GetPreparedAbility().Activate(cell,true,EDirection_MAX);
			class'H7CombatController'.static.GetInstance().DestroyAllStackGhosts();
			// we iterate over all results
			for(k=0;k<result.GetDefenderCount();k++)
			{
				if(result.GetDefender(k).IsA('H7CreatureStack') && result.GetDamage(k) > 0.0f )
				{
					target = result.GetDefender(k);
					defenderStack = H7CreatureStack( target );
					hpTotalEnemy = defenderStack.GetCombatArmy().GetArmyDamagePool();
					defenderStack.GetDamageResult( result.GetDamage(k), result.DidMiss(k), topHealth, resultSize );

					diff = defenderStack.GetStackSize() - resultsize;
					if( diff > 0 )
					{
						if( result.GetDefender(k).GetPlayer() == result.GetAttacker().GetPlayer() )
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
						if( result.GetDefender(k).GetPlayer() == result.GetAttacker().GetPlayer() )
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

			
			hpTotalFriendly = result.GetAttacker().GetCombatArmy().GetArmyDamagePool();


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
		else
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		}
	}

	return 0.0f;
}
