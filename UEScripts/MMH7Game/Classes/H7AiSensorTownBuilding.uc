//=============================================================================
// H7AiSensorTownBuilding
//=============================================================================
// the distance is geometric and not walking distance!
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorTownBuilding extends H7AiSensorBase;

/// overrides ...

function float GetValue1( H7AiSensorParam param0  )
{
	local H7TownBuilding    building;

	if( param0.GetPType() == SP_BUILDING )
	{
		building=param0.GetBuilding();
		// bad parameter
		if(building==None) return 0.0f;
		return building.GetBuildingBaseUtility();
	}
	// wrong parameter types
	return 0.0f;
}
