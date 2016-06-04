//=============================================================================
// H7AiSensorTownThreat
//=============================================================================
// ...
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorTownThreat extends H7AiSensorBase;

/// overrides ...

function float GetValue1( H7AiSensorParam param0 )
{
	local H7VisitableSite   site;
	local H7Town            town;
	
	if( param0.GetPType()==SP_VISSITE )
	{
		site=param0.GetVisSite();
		if(site==None) return 0.0f;
		if(site.IsA('H7Town')==true) return H7Town(site).GetAiThreatLevel();
		if(site.IsA('H7Fort')==true) return H7Fort(site).GetAiThreatLevel();
		return 0.0f;
	}
	else if( param0.GetPType()==SP_TOWN )
	{
		town=param0.GetTown();
		if(town==None) return 0.0f;
		return town.GetAiThreatLevel();
	}
	// wrong parameter type ...
	return 0.0f;
}
