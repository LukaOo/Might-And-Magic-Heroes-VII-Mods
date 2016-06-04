//=============================================================================
// H7AiSensorTownArmyCount
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorTownArmyCount extends H7AiSensorBase;

/// overrides ...

function float GetValue1( H7AiSensorParam param0  )
{
	local H7VisitableSite           site;
	local H7AreaOfControlSiteLord   town;
	local H7AdventureArmy           garrisonArmy, visitingArmy;
	local float                     armyCount;

	if( param0.GetPType() == SP_VISSITE )
	{
		site=param0.GetVisSite();
		if(site==None || (!site.IsA('H7Town') && !site.IsA('H7Fort')))
		{
			// bad parameter
			return 0.0f;
		}
		town=H7AreaOfControlSiteLord(site);

		armyCount = 0.0f;

		garrisonArmy=town.GetGarrisonArmy();
		visitingArmy=town.GetVisitingArmy();

		if(garrisonArmy!=None)
		{
			if(garrisonArmy.GetCreatureAmountTotal()==0 && (garrisonArmy.GetHero()==None || garrisonArmy.GetHero().IsHero()==false) )
			{
				armyCount += 0.5f;
			}
		}
		if(visitingArmy!=None)
		{
			if(visitingArmy.GetCreatureAmountTotal()==0 && (visitingArmy.GetHero()==None || visitingArmy.GetHero().IsHero()==false) )
			{
				armyCount += 0.5f;
			}
		}
		return armyCount;
	}
	// wrong parameter types
	return 0.0f;
}
