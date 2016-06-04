//=============================================================================
// H7AiSensorPoolGarrison
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorPoolGarrison extends H7AiSensorBase;

/// overrides ...

function float GetValue1( H7AiSensorParam param0  )
{
	local H7VisitableSite           site;
	local H7AreaOfControlSiteLord   town;
	local H7AdventureArmy           garrisonArmy;
	local float                     size;
	local array<H7RecruitmentInfo>  recruitInfo;
	local H7RecruitmentInfo         ri;
	local float                     garrisonValue, recruitValue;

	return 1.0f;

	if( param0.GetPType() == SP_VISSITE )
	{
		site=param0.GetVisSite();
		if(site==None || (!site.IsA('H7Town') && !site.IsA('H7Fort')))
		{
			// bad parameter
			return 0.0f;
		}
		town=H7AreaOfControlSiteLord(site);

		// calculate garrison army strength
		garrisonArmy=town.GetGarrisonArmy();
		garrisonValue=garrisonArmy.GetStrengthValue(false);

		// calculate potential recruitment army strength
		recruitInfo=town.GetRecruitAllData();
		recruitValue=0.0f;
		foreach recruitInfo( ri )
		{
			size=ri.Count;
			switch( ri.Creature.GetTier() )
			{
				case CTIER_CORE:
					if(  ri.Creature.IsUpgradeVersion() == true ) 
						recruitValue = recruitValue + size * 1.5f; 
					else 
						recruitValue = recruitValue + size;
					break;
				case CTIER_ELITE:
					if( ri.creature.IsUpgradeVersion() == true ) 
						recruitValue = recruitValue + size * 6.0f; 
					else 
						recruitValue = recruitValue + size * 4.0f;
					break;
				case CTIER_CHAMPION:
					if( ri.creature.IsUpgradeVersion() == true ) 
						recruitValue = recruitValue + size * 24.0f; 
					else 
						recruitValue = recruitValue + size * 16.0f;
					break;
			}
		}
		return max(1.0f,recruitValue) / max(1.0f,garrisonValue);
	}
	// wrong parameter types
	return 0.0f;
}
