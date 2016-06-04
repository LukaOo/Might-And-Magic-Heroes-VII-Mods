//=============================================================================
// H7AiSensorTownDistance
//=============================================================================
// the distance is geometric and not walking distance!
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorTownDistance extends H7AiSensorBase;

/// overrides ...

function float GetValue1( H7AiSensorParam param0 )
{
	local H7VisitableSite   site;
	local H7Player          pl;
	local array<H7Town>     towns;
	local H7Town            orgTown, town;
	local float             distance, distanceMin;
	if( param0.GetPType() == SP_VISSITE )
	{
		site=param0.GetVisSite();
//`LOG_AI("*** STD(site)" @ site);
		if(site==None || (!site.IsA('H7Town') && !site.IsA('H7Fort')))
		{
			// bad parameter
			return 0.0f;
		}
		// get player that owns the building to compare against all enemy towns and forts ...
		pl = H7AreaOfControlSiteLord(site).GetPlayer();
		distanceMin = 100.0f;
		towns = class'H7AdventureController'.static.GetInstance().GetTownList();
		foreach towns( town )
		{
			if( town.GetPlayer().IsPlayerHostile( pl ) )
			{
				distance = class'H7Math'.static.GetDistance( site.Location, town.Location ) / class'H7BaseCell'.const.CELL_SIZE;
				if( distance < distanceMin ) distanceMin = distance;
			}
		}
//`LOG_AI("   " @ distanceMin  );
		return distanceMin;
	}
	else if( param0.GetPType() == SP_TOWN )
	{
		orgTown=param0.GetTown();
//`LOG_AI("*** STD(town)" @ orgTown);
		if(orgTown==None)
		{
			// bad parameter
			return 0.0f;
		}
		// get player that owns the building to compare against all enemy towns and forts ...
		pl = orgTown.GetPlayer();
		distanceMin = 100.0f;
		towns = class'H7AdventureController'.static.GetInstance().GetTownList();
		foreach towns( town )
		{
			// atm we consider any other player to be an enemy
			if( town.GetPlayer().IsPlayerHostile( pl ) )
			{
				distance = class'H7Math'.static.GetDistance( orgTown.Location, town.Location ) / class'H7BaseCell'.const.CELL_SIZE;
				if( distance < distanceMin ) distanceMin = distance;
			}
		}
//`LOG_AI("   " @ distanceMin  );
		return distanceMin;
	}

	// wrong parameter type ...
	return 0.0f;
}
