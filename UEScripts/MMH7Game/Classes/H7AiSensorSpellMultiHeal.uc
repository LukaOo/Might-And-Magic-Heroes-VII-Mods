//=============================================================================
// H7AiSensorSpellMultiHeal
//=============================================================================
// Checks how much HP of the target stack(s) a hero can damage
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorSpellMultiHeal extends H7AiSensorBase;

function float GetValue1( H7AiSensorParam param )
{
	local H7Unit defendingUnit;
	local H7CreatureStack defendingCreature;
	local H7IEffectTargetable target;
	local H7CombatMapCell cell;
	local H7CombatResult result;
	local float totalScale, numTargets;
	local int   n;
	local float healScale, deltaHeal;
	local float csHitPoints, csMaxHitPoints;

	totalScale=0.0f;
	numTargets=0.0f;

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

			// we iterate over all results
			for(n=0;n<result.GetDefenderCount();n++)
			{
				target=result.GetDefender(n);
				if(target.IsA('H7CreatureStack') && result.GetDamage(n)>0 )
				{
					defendingCreature=H7CreatureStack(target);
					csHitPoints = defendingCreature.GetHitpointsTotal();
					csMaxHitPoints = defendingCreature.GetMaxHitpointsTotal();
			
					deltaHeal = (result.GetDamageHigh(n)-result.GetDamageLow(n))* 0.5f;
					if( (csHitPoints+deltaHeal) > csMaxHitPoints ) deltaHeal=csMaxHitPoints-csHitPoints;
					healScale = deltaHeal / csMaxHitPoints;
						 if( healScale < 0.0f ) return 0.0f;
					else if( healScale > 1.0f ) return 1.0f;

					totalScale+=healScale;
					numTargets+=1.0f;
				}
			}
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			if(numTargets>0.0f) return totalScale / numTargets;
		}
	}
	else if( param.GetPType()==SP_CMAPCELL )
	{
		cell=param.GetCMapCell();
		if(cell==None) return 0.0f;

		// the target cell is just our primary target. The spell can effect more (area spells, etc.)
		if( class'H7CombatController'.static.GetInstance().GetActiveUnit().GetPreparedAbility().CanCastOnTargetActor(cell)==true )
		{
			result = class'H7CombatController'.static.GetInstance().GetActiveUnit().GetPreparedAbility().Activate(cell,true,EDirection_MAX);
			class'H7CombatController'.static.GetInstance().DestroyAllStackGhosts();
			// we iterate over all results
			for(n=0;n<result.GetDefenderCount();n++)
			{
				target=result.GetDefender(n);
				if(target.IsA('H7CreatureStack') && result.GetDamage(n)>0 )
				{
					defendingCreature=H7CreatureStack(target);
					csHitPoints = defendingCreature.GetHitpointsTotal();
					csMaxHitPoints = defendingCreature.GetMaxHitpointsTotal();
			
					deltaHeal = (result.GetDamageHigh(n)-result.GetDamageLow(n))* 0.5f;
					if( (csHitPoints+deltaHeal) > csMaxHitPoints ) deltaHeal=csMaxHitPoints-csHitPoints;
					healScale = deltaHeal / csMaxHitPoints;
						 if( healScale < 0.0f ) return 0.0f;
					else if( healScale > 1.0f ) return 1.0f;

					totalScale+=healScale;
					numTargets+=1.0f;
				}
			}
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			if(numTargets>0.0f) return totalScale / numTargets;
		}
	}

	return 0.0f;
}
