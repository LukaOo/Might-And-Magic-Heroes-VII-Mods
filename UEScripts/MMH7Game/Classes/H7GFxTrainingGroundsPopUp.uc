//=============================================================================
// H7GFxSimTurnInfo
//
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxTrainingGroundsPopUp extends H7GFxUIContainer;

function Update(H7TrainingGrounds grounds, H7AdventureArmy army)
{
	local GFxObject obj, upgradeData;

	obj = CreateObject("Object");
	upgradeData = CreateArray();

	obj.SetString("Name", grounds.GetName());
	obj.SetString("Desc", class'H7Loca'.static.LocalizeSave("TT_TRAINING_GROUNDS","H7AdvMapObjectToolTip"));
	obj.SetString("NoUpgrade", class'H7Loca'.static.LocalizeSave("CAN_NOT_UPGRADE_BECAUSE_NO_FREE_SLOT","H7Town"));

	createUpgradeObject(grounds, army, upgradeData);

	SetObject("mData", obj);
	SetObject("mUpgradeData", upgradeData);

	ActionScriptVoid("Update");
}

function createUpgradeObject(H7TrainingGrounds grounds, H7AdventureArmy army, out GFxObject upgradeData)
{
	local GFxObject singleUpgrade, costs, quantitiyData;
	local H7BaseCreatureStack stack;
	local array<H7BaseCreatureStack> stacks;
	local int i, k, l, creatureIndex, upgradeAbleCreatureCount;
 	local array<H7ResourceQuantity> upgradeCost, singleUpgCost;
	local H7ResourceQuantity quantity;
	local bool noUpgradedStackAndUnableToUpgradeAllCreatures;
	local H7ResourceSet set;
 	
	if(army == none) return;
	
	// Set resources
	set = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetResourceSet();

	i = 0;
	singleUpgrade = CreateArray();

	stacks = army.GetBaseCreatureStacks();

	for(creatureIndex = 0; creatureIndex<stacks.Length;creatureIndex++) 
	{
		stack = stacks[creatureIndex];
		noUpgradedStackAndUnableToUpgradeAllCreatures = true;
		singleUpgrade = CreateArray();
		
		singleUpgCost.Length = 0;
		upgradeCost = grounds.GetUpgradeInfo(false, upgradeAbleCreatureCount, stack, -1, none, singleUpgCost);

		if(upgradeCost.Length == 0)
		{
			upgradeData.SetElementObject(i, none);
			i++;
			continue;
		}
		else if(upgradeAbleCreatureCount == 0 && singleUpgCost.Length != 0)
		{
			upgradeCost = singleUpgCost;
			upgradeAbleCreatureCount = 1;
		}

		k = 0;
		singleUpgrade.SetInt("Count", upgradeAbleCreatureCount);
		singleUpgrade.SetString("Name", stack.GetStackType().GetName());
		
		// if the army has no free slot and we can NOT upgrade all creatures of the current stack
		if(!army.CheckFreeArmySlot() && upgradeAbleCreatureCount<stack.GetStackSize())
		{
			// we are looking for another stack of the upgraded type
			for(l=0; l<stacks.Length; l++)
			{
				if(stack.GetStackType().GetUpgradedCreature() == stacks[l].GetStackType()){ noUpgradedStackAndUnableToUpgradeAllCreatures = false; break;} 
			}
		
			singleUpgrade.SetBool("NoUpgradedStackAndUnableToUpgradeAllCreatures", noUpgradedStackAndUnableToUpgradeAllCreatures);
			if(noUpgradedStackAndUnableToUpgradeAllCreatures)
			{
				// the army has no free slot and doesnt contain a stack of the upgraded creature and we cant
				// upgrade all creatures at once
				//singleUpgrade.SetElementObject(k, creatureCount);
				upgradeData.SetElementObject(i, singleUpgrade);
				i++;
				continue;
			}
		}

		// resource Cost
		costs = CreateArray();
		k = 0;
		foreach upgradeCost(quantity)
		{
			quantitiyData = CreateObject("Object");
			quantitiyData.SetString("Name", quantity.Type.GetName());
			quantitiyData.SetString("Icon", quantity.Type.GetIconPath());
			quantitiyData.SetInt("Amount", quantity.Quantity);
			quantitiyData.SetBool("TooMuch", set.GetResource(quantity.Type) < quantity.Quantity ? True : false);

			costs.SetElementObject(k, quantitiyData);
			k++;
		}
		singleUpgrade.SetObject("Costs", costs);

		upgradeData.SetElementObject(i, singleUpgrade);
		i++;
	}
}
