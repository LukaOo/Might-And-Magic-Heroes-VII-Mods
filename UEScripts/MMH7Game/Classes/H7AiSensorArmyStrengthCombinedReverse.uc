//=============================================================================
// H7AiSensorArmyStrengthCombinedReverse
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorArmyStrengthCombinedReverse extends H7AiSensorBase;

/// overrides ...

function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	local H7AdventureArmy army;
	local float armyStrength0,armyStrength1;

//	`LOG_AI("Sensor.ArmyStrengthCombined");

	if( param0.GetPType() == SP_ADVENTUREARMY )
	{
		army = param0.GetAdventureArmy();
		if( army == None ) return 0.0f;

		armyStrength0 = army.GetStrengthValue(true);
	}
	else
	{
		// wrong parameter types
		return 0.0f;
	}

//	`LOG_AI("  Source" @ "." @ army @ "Strength" @ armyStrength0);

	if( param1.GetPType() == SP_ADVENTUREARMY )
	{
		army = param1.GetAdventureArmy();
		if( army == None ) return 1000.0f; // with no opponent we can only win ;)

		armyStrength1 =  army.GetStrengthValue( true);
		if(armyStrength1<=0.0f) return 0.0f;
	}
	else
	{
		// wrong parameter types
		return 0.0f;
	}

//	`LOG_AI("  Target" @ "." @ army @ "Strength" @ armyStrength1);

	if( param0.GetAdventureArmy().GetPlayer() == param1.GetAdventureArmy().GetPlayer() ) 
	{
		if( !ShouldCombine( param1.GetAdventureArmy(), param0.GetAdventureArmy() ) )
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			return 0.0f;
		}
		else if( param0.GetAdventureArmy().IsGarrisoned() )
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			return 0.0f;
		}
		else
		{
			if(armyStrength0>0.0f)
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			}
			else
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			}
		}
	}

	if( armyStrength0 > 0.0f )
	{
//		`LOG_AI("  Out" @ armyStrength1 / armyStrength0);
		return armyStrength1 / armyStrength0;
	}
//	`LOG_AI("  Out (Infinite)");
	return 1000.0f; // the ratio is more like infinite but 1000 should hit the upper cealing just fine
}

protected function bool ShouldCombine( H7AdventureArmy army, H7AdventureArmy receivingArmy )
{
	local array<H7BaseCreatureStack> stacks, localStacks;
	local H7BaseCreatureStack stack;
	local int threshold;
	local float armyStrength, strongestPotential, weakestReceiving;
	local bool hasSlots;
	local bool hasSameStack;

//	`LOG_AI("SASRev::ShouldCombine() giving army" @ army @ army.GetHero() @ "receiving army" @ receivingArmy @ receivingArmy.GetHero() );
	stacks = army.GetBaseCreatureStacks();
	foreach stacks( stack )
	{
		if( strongestPotential < stack.GetCreatureStackStrength() )
		{
			strongestPotential = stack.GetCreatureStackStrength();
		}
	}
	if( strongestPotential == 0 )
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		return false;
	}
	hasSlots = receivingArmy.GetFreeSlotCount() > 0;
	stacks = receivingArmy.GetBaseCreatureStacks();
	foreach stacks( stack )
	{
		if( weakestReceiving == 0 )
		{
			weakestReceiving = stack.GetCreatureStackStrength();
		}
		else
		{
			if( weakestReceiving > stack.GetCreatureStackStrength() && !stack.IsLockedForUpgrade() )
			{
				weakestReceiving = stack.GetCreatureStackStrength();
			}
		}
		if( army.HasStackType( stack ) )
		{
			hasSameStack = true;
		}
	}

	if( strongestPotential <= weakestReceiving && !hasSlots && !hasSameStack )
	{
		return false;
	}

	if( army.IsGarrisoned() && H7Town( army.GetGarrisonedSite() ) != none )
	{
		if( H7Town( army.GetGarrisonedSite() ).mAiThreateningArmy != none )
		{
			threshold = H7Town( army.GetGarrisonedSite() ).mAiThreateningArmy.GetStrengthValue( false );
		}
		localStacks = H7Town( army.GetGarrisonedSite() ).GetLocalGuardAsBaseCreatureStacks();
		foreach localStacks( stack )
		{
			threshold -= stack.GetCreatureStackStrength();
		}
	}
	
	armyStrength = army.GetStrengthValue( false );
	stacks = army.GetBaseCreatureStacks();

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	foreach stacks( stack )
	{
//		`LOG_AI("  => stack" @ stack.GetStackType().GetName() @ "power" @ stack.GetStackType().GetCreaturePower() );
		//check if we can 
		if( stack.GetStackType()!=None && stack.GetStackSize() > 0 && (armyStrength - stack.GetStackType().GetCreaturePower()) > threshold )
		{
//			`LOG_AI("  => true (threshold" @ threshold @ "reached)");
			return true;
		}
	}

//	`LOG_AI("  => false (nothing to give)");

	return false;
}
