//=============================================================================
// H7AiSensorCanMoveAttack
//=============================================================================
// Checks if a unit can melee attack another
//
// implements: GetValue2(CreatureStack,CreatureStack)
//             => 1.0f yes
//             => 0.0f no
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorCanMoveAttack extends H7AiSensorBase;

/// overrides ...

function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	local H7Unit unit,targetUnit;
	local H7CreatureStack creature,targetCreature;
	local array<H7CombatMapCell> validPositions;
	local H7CombatMapGrid   grid;

	grid = class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid();

	if(param0.GetPType()==SP_UNIT)
	{
		unit = param0.GetUnit();
		if(unit==None) return 0.0f;
		creature =  H7CreatureStack(unit);
		if(creature==None) return 0.0f;
		if(creature.IsDead()==true || creature.IsVisible()==false || creature.IsOffGrid()==true)
		{
			return 0.0f;
		}
	}
	if(param1.GetPType() == SP_UNIT)
	{
		targetUnit = param1.GetUnit();
		if(targetUnit==None) return 0.0f;
		targetCreature = H7CreatureStack(targetUnit);
		if(targetCreature==None) return 0.0f;
		if(targetCreature.IsDead()==true || targetCreature.IsVisible()==false || targetCreature.IsOffGrid()==true)
		{
			return 0.0f;
		}

		grid.GetAllAttackPositionsAgainst(targetCreature,creature,validPositions);
		if(validPositions.Length>=1)
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			return 1.0f;
		}
	}
	return 0.0f;
}
