//=============================================================================
// H7AiSensorCreatureCanBeAttacked
//=============================================================================
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorCreatureCanBeAttacked extends H7AiSensorBase;

var int mTurn;
var H7CreatureStack mCreature;
var float mValue;

function bool CheckCache( int currentTurn, H7CreatureStack creature )
{
	if(mTurn==currentTurn && mCreature==creature) return true;
	mTurn=currentTurn;
	mCreature=creature;
	return false;
}

/// overrides ...

function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	local H7Unit unit;
	local H7CreatureStack creature;
	local H7CreatureStack hostileCreature;
	local array<H7CreatureStack> oppCStacks;
	local H7CombatArmy oppArmy;
	local int dist, k;
	local array<H7CombatMapCell> lineCells;

	if(param1.GetPType()==SP_COMBATARMY)
	{
		oppArmy=param1.GetCombatArmy();
	}
	if(oppArmy==None) return 0.0f;

	if(param0.GetPType()==SP_UNIT)
	{
		unit = param0.GetUnit();
		if(unit==None) return 0.0f;
		if(unit.GetEntityType()!=UNIT_CREATURESTACK) return 0.0f;
		creature = H7CreatureStack(unit);
		if(creature==None) return 0.0f;

		if( CheckCache(class'H7CombatController'.static.GetInstance().GetCurrentTurn(),creature)==true ) return mValue;

		oppArmy.GetSurvivingCreatureStacks(oppCStacks);
		foreach oppCStacks(hostileCreature)
		{
			class'H7Math'.static.GetLineCellsBresenham( lineCells, creature.GetCell().GetGridPosition(), hostileCreature.GetCell().GetGridPosition() );
			dist=lineCells.Length;
			for(k=0;k<dist;k++)
			{
				if( lineCells[k].IsBlocked(hostileCreature)==true )
				{
					dist=10000;
					break;
				}
			}
			//dist=class'H7Math'.static.GetLineCellsLengthBresenham( creature.GetCell().GetGridPosition(), hostileCreature.GetCell().GetGridPosition() );
			if(dist<=hostileCreature.GetMovementPoints()) 
			{
				mValue=1.0f;
				return 1.0f;
			}
		}
	}
	mValue=0.0f;
	return 0.0f;
}
