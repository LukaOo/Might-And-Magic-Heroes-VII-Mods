//=============================================================================
// H7AiSensorCreatureStrength
//=============================================================================
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorCreatureStrength extends H7AiSensorBase;

/// overrides ...

function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	local H7Unit unit;
	local H7CombatArmy army;
	local array<H7CreatureStack> cstacks;
	local H7CreatureStack cstack;
	local float armyPower, creaturePower;
	armyPower=0.0f;

	if(param1.GetPType()==SP_UNIT)
	{
		unit = param1.GetUnit();
		if(unit==None) return 0.0f;
		cstack = H7CreatureStack(unit);
		if(cstack==None) return 0.0f;
		if(cstack.IsDead()==false && cstack.IsVisible()==true && cstack.IsOffGrid()==false)
		{
			creaturePower=cstack.GetCreature().GetCreaturePower() * float(cstack.GetStackSize());
		}
	}
	else return 0.0f;
	if(param0.GetPType()==SP_COMBATARMY)
	{
		army = param0.GetCombatArmy();
		if(army==None) return 0.0f;
		cstacks=army.GetCreatureStacks();
		foreach cstacks(cstack)
		{
			if(cstack.IsDead()==false && cstack.IsVisible()==true && cstack.IsOffGrid()==false)
			{
				armyPower += cstack.GetCreature().GetCreaturePower() * float(cstack.GetStackSize());
			}
		}
	}
	else return 0.0f;
	
	if(armyPower>0.0f) 
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		return creaturePower/armyPower;
	}

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	return 0.0f;
}
