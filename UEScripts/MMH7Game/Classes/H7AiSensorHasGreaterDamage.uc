//=============================================================================
// H7AiSensorHasGreaterDamage
//=============================================================================
// 
// Checks if curren unit has greater damage than another unit
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorHasGreaterDamage extends H7AiSensorBase;

/// overrides ...

function float GetValue1( H7AiSensorParam param )
{
	local H7Unit baseUnit, evaluationUnit;
	local H7CreatureStack baseStack, evaluationStack;
	local H7CombatHero baseHero;
	if( param.GetPType() == SP_UNIT )
	{
		evaluationUnit = param.GetUnit();
		baseUnit = class'H7CombatController'.static.GetInstance().GetActiveUnit();
		if( evaluationUnit == None || baseUnit == None )
		{
			return 0.0f;
		}
		
		if( evaluationUnit.GetEntityType() == UNIT_CREATURESTACK && baseUnit.GetEntityType() == UNIT_CREATURESTACK )
		{
			evaluationStack = H7CreatureStack( evaluationUnit );
			baseStack = H7CreatureStack( baseUnit );
			if( baseStack.GetStackSize() * evaluationStack.GetCreature().GetMaximumDamage() > evaluationStack.GetStackSize() * evaluationStack.GetCreature().GetMaximumDamage() )
			{
				return 1.0f;
			}
			else
			{
				return 0.0f;
			}
		}
		else if( evaluationUnit.GetEntityType() == UNIT_CREATURESTACK && baseUnit.GetEntityType() == UNIT_HERO )
		{
			evaluationStack = H7CreatureStack( evaluationUnit );
			baseHero = H7CombatHero( baseUnit );
			if( baseHero.GetMaximumDamage() > evaluationStack.GetStackSize() * evaluationStack.GetCreature().GetMaximumDamage() )
			{
				return 1.0f;
			}
			else
			{
				return 0.0f;
			}
		}
		else
		{
			return 0.0f;
		}
	}
	// wrong parameter types
	return 0.0f;
}


