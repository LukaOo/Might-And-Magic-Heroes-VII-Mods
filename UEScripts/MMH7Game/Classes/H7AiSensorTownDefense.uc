//=============================================================================
// H7AiSensorTownDefense
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorTownDefense extends H7AiSensorBase;

/// overrides ...

function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	local H7Town    town;
	local H7AdventureArmy incomingArmy;

	local float     garrisonArmyStrength, incomingArmyStrength, townArmyStrength;
	local bool      garrisonPresent, visitingPresent;

	if(param0.GetPType()==SP_VISSITE)
	{
		town=H7Town(param0.GetVisSite());
		if(town==None) return 0.0f;
	}
	else if(param0.GetPType()==SP_TOWN)
	{
		town=param0.GetTown();
		if(town==None) return 0.0f;
	}
	else
	{
		return 0.0f;
	}

	if(param1.GetPType()==SP_ADVENTUREARMY)
	{
		incomingArmy=param1.GetAdventureArmy();
		if(incomingArmy==None) return 0.0f;
	}
	else
	{
		return 0.0f;
	}

	incomingArmyStrength=incomingArmy.GetStrengthValue(true);
	if(incomingArmyStrength<=0.0f) // would not be of any help
	{
		return 0.0f;
	}

	garrisonArmyStrength=0.0f;
	garrisonPresent=false;
	if(town.GetGarrisonArmy()!=None)
	{
		garrisonArmyStrength=town.GetGarrisonArmy().GetStrengthValue(true, town.GetLocalGuardAsBaseCreatureStacks());
		if(town.GetGarrisonArmy().HasUnits()==true)
		{
			garrisonPresent=true;
		}
		//if( town.GetGarrisonArmy().GetHero()!=None && town.GetGarrisonArmy().GetHero().IsHero()==true )
		//{
		//	heroPresent=true;
		//}
	}
	visitingPresent=false;
	if(town.GetVisitingArmy()!=None)
	{
		visitingPresent=true;
		if(town.GetVisitingArmy()==incomingArmy)
		{
			// we are already there :)
			return 1000.0f;
		}
	}

	if(garrisonPresent==false && visitingPresent==false)
	{
		// trivial. town needs any help
		return 1000.0f;
	}
	if(garrisonPresent==false && visitingPresent==true)
	{
		// someone else at town, no need to help
		return 0.0f;
	}
	if(garrisonPresent==true && visitingPresent==true)
	{
		// more than enough at town, no need to help
		return 0.0f;
	}
	// gar==true && vis==false
	townArmyStrength=incomingArmyStrength / garrisonArmyStrength; // the ratio of both armies. the more we add to it the higher its value

	return townArmyStrength;
}
