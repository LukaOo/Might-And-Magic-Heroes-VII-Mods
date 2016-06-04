/*=============================================================================
* H7TownGuardGrowthEnhancer
* =============================================================================
*  Class for describing buildings that modify TownGuard income.
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7TownGuardGrowthEnhancer extends H7TownBuilding
	native;

var(Modifier, Build) array<H7GuardCreatureData>     mOnBuildCreatureBonus;
var(Modifier) array<H7TownGuardModifier>            mCapacityModifier<DisplayName=Town Guard Capacity Modifier>;
var(Modifier) array<H7TownGuardModifier>            mIncomeModifier<DisplayName=Town Guard Income Modifier>;

function InitGrowthEnhancer( out array<H7DwellingCreatureData> localGuardData )
{
	local H7GuardCreatureData data;
	local int i, reserve;

	foreach mOnBuildCreatureBonus( data )
	{
		for( i = 0; i < localGuardData.Length; ++i )
		{
			if( localGuardData[i].Creature == none ) continue;

			if( localGuardData[i].Creature.GetTier() == data.mCreatureTier )
			{
				reserve = localGuardData[i].Reserve;

				reserve += data.mAmount;

				// If Creature is a Champion and there is no capacity defined by fortification, take capacity from self
				if(localGuardData[i].Creature.GetTier() == CTIER_CHAMPION && data.mCreatureTier == CTIER_CHAMPION && localGuardData[i].Capacity == 0)
				{
					localGuardData[i].Reserve = data.mAmount;
				}
				else
				{
					if( reserve <= localGuardData[i].Capacity )
					{
						localGuardData[i].Reserve = reserve;
					}
					else
					{
						localGuardData[i].Reserve = localGuardData[i].Capacity;
					}
				}
				
			}
		}
	}
}

function int GetModifiedCapacityFor( H7DwellingCreatureData data, bool hasChampionDwelling, out int IsOperationSet )
{
	local H7TownGuardModifier modifier;
	local int value;
	
	value = data.Capacity;
	foreach mCapacityModifier( modifier )
	{
		if( modifier.mTier == data.Creature.GetTier() )
		{
			value = class'H7EffectContainer'.static.DoOperation( modifier.mOperation, data.Capacity, modifier.mValue );
			if( modifier.mOperation == OP_TYPE_SET )
			{
				IsOperationSet = 1;
				return value;
			}
		}
	}

	return value;
}

function int GetModifiedIncomeFor( H7DwellingCreatureData data, bool hasChampionDwelling, out int IsOperationSet )
{
	local H7TownGuardModifier modifier;
	local int value;
	
	value = data.Income;
	foreach mIncomeModifier( modifier )
	{
		if( modifier.mTier == data.Creature.GetTier() )
		{
			value = class'H7EffectContainer'.static.DoOperation( modifier.mOperation, data.Income, modifier.mValue );
			if( modifier.mOperation == OP_TYPE_SET )
			{
				IsOperationSet = 1;
				return value;
			}
		}
	}

	return value;
}

function bool IsChampionGuardTower()
{
	local H7TownGuardModifier modifier;

	ForEach mCapacityModifier(modifier)
	{
		if(modifier.mTier == CTIER_CHAMPION)
			return true;
	}
	return false;
}
