//=============================================================================
// H7AiSensorSpellSingleHeal
//=============================================================================
// Checks how much HP of the target stack a hero can damage
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorSpellSingleHeal extends H7AiSensorBase;

function float GetValue1( H7AiSensorParam param  )
{
	local H7Unit defendingUnit;
	local H7CreatureStack defendingCreature;
	local H7CombatResult result;
	local float healScale, deltaHeal;
	local float csHitPoints, csMaxHitPoints;

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	if( param.GetPType()==SP_UNIT )
	{
		defendingUnit = param.GetUnit();
		if(defendingUnit==None) return 0.0f;
		defendingCreature = H7CreatureStack(defendingUnit);
		if(defendingCreature==None) return 0.0f;
		
		if( !defendingCreature.IsDead() && class'H7CombatController'.static.GetInstance().GetActiveUnit().GetPreparedAbility().CanCastOnTargetActor(defendingCreature)==true )
		{
			result = class'H7CombatController'.static.GetInstance().GetActiveUnit().GetPreparedAbility().Activate(defendingCreature,true,EDirection_MAX);
			class'H7CombatController'.static.GetInstance().DestroyAllStackGhosts();

			csHitPoints = defendingCreature.GetHitpointsTotal();
			csMaxHitPoints = defendingCreature.GetMaxHitpointsTotal();
			
			deltaHeal = (result.GetDamageHigh()-result.GetDamageLow())* 0.5f;
			if( (csHitPoints+deltaHeal) > csMaxHitPoints ) deltaHeal=csMaxHitPoints-csHitPoints;
			healScale = deltaHeal / csMaxHitPoints;
			
			// 1 means all are healed (resurrected), 0 means none is healed
			     if( healScale < 0.0f ) return 0.0f;
			else if( healScale > 1.0f ) return 1.0f;
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			return healScale;
		}
	}
	return 0.0f;
}
