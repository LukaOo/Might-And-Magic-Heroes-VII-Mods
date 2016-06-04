//=============================================================================
// H7AiSensorUpgradeStrength
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorUpgradeStrength extends H7AiSensorBase;

/// overrides ...
function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	local H7AdventureArmy               army;
	local H7VisitableSite               site;
	local float                         armyStrengthBefore;
	local float                         armyStrengthAfter;
	local H7Town                        town;
	local H7Dwelling                    dwelling;
	local H7TrainingGrounds             training;
	local array<H7BaseCreatureStack>    cstacks;
	local H7BaseCreatureStack           stack;
	local array<H7ResourceQuantity>     upgRes;
	local int                           numOfUpgCreatures;
	local H7ResourceSet                 resourceSetClone;

//	`LOG_AI("Sensor.UpgradeStrength");
	if( param0.GetPType() == SP_ADVENTUREARMY )
	{
		army=param0.GetAdventureArmy();
		if(army==None)
		{
			// bad parameter
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			return 0.0f;
		}
	}
	else
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		return 0.0f;
	}

	if( param1.GetPType() == SP_VISSITE )
	{
		site=param1.GetVisSite();
		if(site==None)
		{ 
			// bad parameter
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			return 0.0f;
		}
	}
	else
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		return 0.0f;
	}

	// 
	armyStrengthBefore = army.GetStrengthValue(false);
	armyStrengthAfter = 0.0f;

	resourceSetClone = new class'H7ResourceSet'( site.GetPlayer().GetResourceSet() );
	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	resourceSetClone.PrintDebugStockpileForAI();
	// we calc the potential power of all our creature stacks if would upgrade everything possible at target
	if( site.IsA('H7Town')==true )
	{
		town=H7Town(site);
		// go through all creature stacks
		cstacks=army.GetBaseCreatureStacks();
		foreach cstacks(stack)
		{
			if(stack!=None)
			{
				upgRes=town.GetUpgradeInfo(false,numOfUpgCreatures,stack);
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				if(stack.GetStackType().GetUpgradedCreature()!=None && town.HasRequiredDwelling(stack.GetStackType().GetUpgradedCreature())==true)
				{
					if( upgRes.Length > 0 && resourceSetClone.CanSpendResources(upgRes) == true && numOfUpgCreatures == stack.GetStackSize() || stack.IsLockedForUpgrade() )
					{
						if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
						armyStrengthAfter += stack.GetStackType().GetUpgradedCreature().GetCreaturePower() * stack.GetStackSize();
						if( !stack.IsLockedForUpgrade() )
						{
							resourceSetClone.SpendResources( upgRes );
						}
					}
					else
					{
						armyStrengthAfter += stack.GetStackType().GetCreaturePower() * stack.GetStackSize();
					}
				}
				else
				{
					armyStrengthAfter += stack.GetStackType().GetCreaturePower() * stack.GetStackSize();
				}
			}
		}
	}
	else if( site.IsA('H7Dwelling')==true )
	{
		dwelling=H7Dwelling(site);
		// go through all creature stacks
		cstacks=army.GetBaseCreatureStacks();
		foreach cstacks(stack)
		{
			if(stack!=None)
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				upgRes=dwelling.GetUpgradeInfo(false,numOfUpgCreatures,stack);
				if(stack.GetStackType().GetUpgradedCreature()!=None && dwelling.CreatureIsInPool(stack.GetStackType().GetUpgradedCreature())==true)
				{
					if( upgRes.Length > 0 && resourceSetClone.CanSpendResources(upgRes) == true && numOfUpgCreatures == stack.GetStackSize() || stack.IsLockedForUpgrade() )
					{
						if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
						armyStrengthAfter += stack.GetStackType().GetUpgradedCreature().GetCreaturePower() * stack.GetStackSize();
						if( !stack.IsLockedForUpgrade() )
						{
							resourceSetClone.SpendResources( upgRes );
						}
					}
					else
					{
						armyStrengthAfter += stack.GetStackType().GetCreaturePower() * stack.GetStackSize();
					}
				}
				else
				{
					armyStrengthAfter += stack.GetStackType().GetCreaturePower() * stack.GetStackSize();
				}
			}
		}
	}
	else if( site.IsA('H7TrainingGrounds')==true )
	{
		training=H7TrainingGrounds(site);
		// go through all creature stacks
		cstacks=army.GetBaseCreatureStacks();
		foreach cstacks(stack)
		{
			if(stack!=None)
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				upgRes=training.GetUpgradeInfo(false,numOfUpgCreatures,stack,,army);
				
				if(stack.GetStackType().GetUpgradedCreature()!=None)
				{
					if( upgRes.Length>0 && resourceSetClone.CanSpendResources(upgRes)==true && numOfUpgCreatures==stack.GetStackSize() || stack.IsLockedForUpgrade() )
					{
						if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
						armyStrengthAfter += stack.GetStackType().GetUpgradedCreature().GetCreaturePower() * stack.GetStackSize();
						if( !stack.IsLockedForUpgrade() )
						{
							resourceSetClone.SpendResources( upgRes );
						}
					}
					else
					{
						armyStrengthAfter += stack.GetStackType().GetCreaturePower() * stack.GetStackSize();
					}
				}
				else
				{
					armyStrengthAfter += stack.GetStackType().GetCreaturePower() * stack.GetStackSize();
				}
			}
		}
	}
	else
	{
		return 0.0f;
	}

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	resourceSetClone.PrintDebugStockpileForAI();

	if(armyStrengthAfter<=armyStrengthBefore)
	{
		return 0.0f;
	}

	return armyStrengthAfter / armyStrengthBefore - 1.0f;
}

static function GetUpgradeData( H7AreaOfControlSite site )
{

}
