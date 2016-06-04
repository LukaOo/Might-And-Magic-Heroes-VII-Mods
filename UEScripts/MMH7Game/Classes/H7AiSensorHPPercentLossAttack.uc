//=============================================================================
// H7AiSensorHPPercentLossAttack
//=============================================================================
// Checks how much HP of the target stack a hero can damage
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorHPPercentLossAttack extends H7AiSensorBase;

/// overrides ...

function float GetValue1( H7AiSensorParam param  )
{
	local H7Unit defendingUnit;
	local H7CreatureStack defendingCreature;
	local H7CombatResult result;
	local float killScale;
	local float maxHitPoints;

	if( param.GetPType()==SP_UNIT )
	{
		defendingUnit = param.GetUnit();
		
		if(defendingUnit==None) // no target
		{
			result=class'H7CombatController'.static.GetInstance().GetActiveUnit().GetPreparedAbility().Activate(None,true);
			class'H7CombatController'.static.GetInstance().DestroyAllStackGhosts();


			return 0.0f;
		}
		
		// targeted
		if( !defendingUnit.IsDead() && defendingUnit.GetEntityType() == UNIT_CREATURESTACK && class'H7CombatController'.static.GetInstance().GetActiveUnit().GetPreparedAbility().CanCastOnTargetActor( defendingUnit ) )
		{
			defendingCreature = H7CreatureStack( defendingUnit );

			result = class'H7CombatController'.static.GetInstance().GetActiveUnit().GetPreparedAbility().Activate( defendingCreature, true );
			class'H7CombatController'.static.GetInstance().DestroyAllStackGhosts();
			maxHitPoints = (float(defendingCreature.GetStackSize()-1) * defendingCreature.GetHitpoints()) + float(defendingCreature.GetTopCreatureHealth());
			killScale = 1.0f - ((maxHitPoints - (result.GetDamageHigh()-result.GetDamageLow())* 0.5f) / maxHitPoints);
//			`LOG_AI("if"@defendingUnit.GetName()@"is attacked by"@class'H7CombatController'.static.GetInstance().GetActiveUnit().GetName()$","@(killScale*100)$"% of the stack will die");
			// 1 means whole stack dies, 0 means none die
			if( killScale <= 0.0f )         return 0.0f;
			else if( killScale >= 1.0f )    return 1.0f;
			else                            return killScale;
		}
		else
		{
			// invalid target
			return 0.0f;
		}
	}
	// wrong parameter type
	return 0.0f;
}
