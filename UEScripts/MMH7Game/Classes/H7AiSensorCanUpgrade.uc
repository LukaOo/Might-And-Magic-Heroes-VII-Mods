//=============================================================================
// H7AiSensorCanUpgrade
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorCanUpgrade extends H7AiSensorBase;

/// overrides ...

function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1  )
{
	local H7VisitableSite           site;
	local H7AreaOfControlSiteLord   town;
	local H7AdventureArmy           garrisonArmy, visitingArmy;
	local H7BaseCreatureStack       crStack;
	local array<H7ResourceQuantity> upgRes;
	local bool                      isInGarrison, isInVisiting;
	local array<H7BaseCreatureStack>    armyStacks;
	local int                       k;
	local int                       numOfUpgCreatures;

//	`LOG_AI("Sensor.CanUpgrade");

	town=None;
	crStack=None;
	isInGarrison=false;
	isInVisiting=false;
	numOfUpgCreatures=0;

	if( param0.GetPType() == SP_VISSITE )
	{
		site=param0.GetVisSite();
		if(site==None || (!site.IsA('H7Town') && !site.IsA('H7Fort')))
		{
			return 0.0f;
		}
		town=H7AreaOfControlSiteLord(site);
		if(town==None)
		{
			return 0.0f;
		}
	}
	else
	{
		return 0.0f;
	}

	if( param1.GetPType() == SP_BASECREATURESTACK )
	{
		crStack=param1.GetBaseCreatureStack();
		if(crStack==None)
		{
			return 0.0f;
		}
		
		// checkout where the stack belongs to
		garrisonArmy=town.GetGarrisonArmy();
		if(garrisonArmy!=None)
		{
			armyStacks=garrisonArmy.GetBaseCreatureStacks();
			for(k=0;k<armyStacks.Length;k++)
			{
				if(armyStacks[k]==crStack)
				{
					isInGarrison=true;
					break;
				}
			}
		}
		visitingArmy=town.GetVisitingArmy();
		if(visitingArmy!=None)
		{
			armyStacks=visitingArmy.GetBaseCreatureStacks();
			for(k=0;k<armyStacks.Length;k++)
			{
				if(armyStacks[k]==crStack)
				{
					isInVisiting=true;
					break;
				}
			}
		}
	}

	if(town!=None && crStack!=None && (isInGarrison==true || isInVisiting==true))
	{
		upgRes=town.GetUpgradeInfo(isInVisiting,numOfUpgCreatures,crStack);
		if( upgRes.Length > 0 )
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			if( town.GetPlayer().GetResourceSet().CanSpendResources(upgRes) == true )
			{
				return float(numOfUpgCreatures) / float(crStack.GetStackSize());
			}
		}
	}

	// wrong parameter types
	return 0.0f;
}
