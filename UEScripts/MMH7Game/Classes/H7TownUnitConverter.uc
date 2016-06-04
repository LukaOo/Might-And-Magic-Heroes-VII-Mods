/*=============================================================================
* H7TownUnitConverter
* =============================================================================
*  Class for the performing unit conversion in towns
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7TownUnitConverter extends H7TownBuilding;

var(Conversion) protected H7Creature			mCreature<DisplayName=Converted Creature>;
var(Conversion) protected H7Creature            mUpgradedCreature<DisplayName=Converted Upgraded Creature>; 
var(Conversion) protected float					mConversionRate<DisplayName=Conversion Rate>;
var(Conversion) protected float                 mCostMultiplier<DisplayName=Cost Mulitplier>;
var(Conversion) protected H7TownBuilding        mBuildingNeededForUpgradedConversion<DisplayName=Building for upgraded conversion>;
var(Conversion) protected array<H7BaseAbility>  mAbilityRestrictions<DisplayName=Will not convert creatures who have any of these abilities>;
var(Conversion) protected array<H7Creature>     mOmittedCreatures<DisplayName=Will not convert any of these specific creatures>;

function H7Creature GetBaseCreature() {return mCreature;}
function H7Creature GetUpgradedCreature() {return mUpgradedCreature;}
function H7TownBuilding GetUpgradedDwelling() {return mBuildingNeededForUpgradedConversion;}

function int GetConvertedCreatureAmount(H7BaseCreatureStack stack)
{
	if( GetTown().IsBuildingBuilt(mBuildingNeededForUpgradedConversion) )
		return stack.GetStackSize() * stack.GetStackType().GetHitPointsBase() * mConversionRate / mUpgradedCreature.GetHitPointsBase() ;
	else
		return stack.GetStackSize() * stack.GetStackType().GetHitPointsBase() * mConversionRate / mCreature.GetHitPointsBase();
}

function int GetConvertingCost(H7BaseCreatureStack stack)
{
	local array<H7ResourceQuantity> costs;
	local int i;

	if( GetTown().IsBuildingBuilt(mBuildingNeededForUpgradedConversion) )
		costs = mUpgradedCreature.GetUnitCost();
	else
		costs = mCreature.GetUnitCost();

	for(i = 0; i < costs.Length; i++)
	{
		if(costs[i].Type == class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetResourceSet().GetCurrencyResourceType())
		{
				return costs[i].Quantity * GetConvertedCreatureAmount(stack) * mCostMultiplier;
		}
	}

	return 0;
}

function ConvertCreature( H7BaseCreatureStack stack )
{	
	if( GetTown().IsBuildingBuilt(mBuildingNeededForUpgradedConversion) )
	{	
		stack.SetStackSize( stack.GetStackSize() * stack.GetStackType().GetHitPointsBase() * mConversionRate / mUpgradedCreature.GetHitPointsBase() );
		stack.SetStackType( mUpgradedCreature );
	}
	else
	{
		stack.SetStackSize( stack.GetStackSize() * stack.GetStackType().GetHitPointsBase() * mConversionRate / mCreature.GetHitPointsBase() );
		stack.SetStackType( mCreature );
	}
}

function bool CanConvert( H7Creature creature )
{
	local H7BaseAbility ability, creatureAbility;
	local array<H7BaseAbility> abilities;
	local H7Creature omittedCreature;

	abilities = creature.GetAbilities();

	foreach mAbilityRestrictions( ability )
	{
		foreach abilities( creatureAbility )
		{
			if( ability.IsEqual( creatureAbility ) )
			{
				return false;
			}
		}
	}
	foreach mOmittedCreatures( omittedCreature )
	{
		if( omittedCreature == creature )
		{
			return false;
		}
	}
	return true;
}


