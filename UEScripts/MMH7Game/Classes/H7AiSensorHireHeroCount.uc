//=============================================================================
// H7AiSensorHireHeroCount
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorHireHeroCount extends H7AiSensorBase;

/// overrides ...

function float GetValue1( H7AiSensorParam param0  )
{
	local H7VisitableSite           site;
	local H7Town                    town;
	local array<RecruitHeroData>    heroData;
	local int                       k;
	local float                     availHeroes;

	if( param0.GetPType() == SP_VISSITE )
	{
		site=param0.GetVisSite();
		if(site==None || !site.IsA('H7Town'))
		{
			// bad parameter
			return 0.0f;
		}
		town=H7Town(site);
		
		// check for building to hire heroes
		if( town.GetBuildingLevelByType( class'H7TownHall' ) <= 0 )
		{
			return 0.0f;
		}

		availHeroes=0.0f;
		heroData = class'H7AdventureController'.static.GetInstance().GetHallOfHeroesManager().GetHeroesPool( town.GetPlayer(), town );
		for(k=0;k<heroData.Length;k++)
		{
			if(heroData[k].IsAvailable==true)
			{
				availHeroes+=1.0f;
			}
		}

		return availHeroes;
	}
	// wrong parameter types
	return 0.0f;
}
