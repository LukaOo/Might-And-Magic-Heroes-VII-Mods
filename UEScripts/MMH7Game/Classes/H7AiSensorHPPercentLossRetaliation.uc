//=============================================================================
// H7AiSensorHPPercentLossRetaliation
//=============================================================================
// Checks how much HP the current stack loses if the target stack retaliates
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorHPPercentLossRetaliation extends H7AiSensorBase;

/// overrides ...

function float GetValue1( H7AiSensorParam param )
{
	local H7Unit defendingUnit, attackingUnit;
	local H7CreatureStack defendingCreature, attackingCreature;
	local H7CombatResult result;
	local float killScale;
	local int maxHitPoints;
	if( param.GetPType() == SP_UNIT )
	{
		defendingUnit = param.GetUnit();
		attackingUnit = class'H7CombatController'.static.GetInstance().GetActiveUnit();
		if( defendingUnit == None || attackingUnit == None )
		{
			// bad param
			return 0.0f;
		}
		attackingCreature = H7CreatureStack( attackingUnit );
		defendingCreature = H7CreatureStack( defendingUnit );
		if( !defendingUnit.IsDead() && !attackingUnit.IsDead() && defendingUnit.GetEntityType() == UNIT_CREATURESTACK && attackingUnit.GetEntityType() == UNIT_CREATURESTACK && defendingCreature.CanRetaliate() )
		{
			result = defendingUnit.GetAbilityManager().GetAbility( defendingUnit.GetMeleeAttackAbility() ).Activate( attackingUnit, true );
			maxHitPoints = attackingCreature.GetStackSize() * attackingCreature.GetHitpoints();
			killScale = ( 1.0f - ( float( maxHitPoints ) - float( result.GetDamage() ) ) / float( maxHitPoints ) );
//			`LOG_AI("if"@attackingUnit.GetName()@"attacks"@defendingUnit.GetName()$","@(killScale*100)$"% of the stack will die of retaliation");
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
