//=============================================================================
// H7AiSensorRangedCreatureCount
//=============================================================================
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorRangedCreatureCount extends H7AiSensorBase;

/// overrides ...

function float GetValue1( H7AiSensorParam param )
{
	local H7Unit unit;
	local H7CombatHero hero;
	local H7CombatArmy army;
	local array<H7CreatureStack> cstacks;
	local H7CreatureStack cstack;
	local float count,rangedCount;
	count=0.0f;
	rangedCount=0.0f;
	if(param.GetPType()==SP_UNIT)
	{
		unit = param.GetUnit();
		if(unit==None) return 0.0f;
		hero = H7CombatHero(unit);
		if(hero==None) return 0.0f;
		army=hero.GetCombatArmy();
		if(army==None) return 0.0f;
		cstacks=army.GetCreatureStacks();
		foreach cstacks(cstack)
		{
			if(cstack.IsDead()==false && cstack.IsVisible()==true && cstack.IsOffGrid()==false)
			{
				count+=1.0f;
				if(cstack.IsRanged()==true)
				{
					rangedCount+=1.0f;
				}
			}
		}
	}
	if(count<=0.0f) return 0.0f;
	if(rangedCount>=1.0f) return rangedCount/count;
	return 0.0f;
}
