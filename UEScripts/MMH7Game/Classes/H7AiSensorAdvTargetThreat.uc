//=============================================================================
// H7AiSensorAdvTargetThreat
//=============================================================================
// ...
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorAdvTargetThreat extends H7AiSensorBase
	native;

native function float CalculateThreat( H7AdventureArmy forArmy,H7AdventureMapCell cell );



/// overrides ...

function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	local H7AdventureArmy       army;
	local H7AdventureMapCell    cell;
	
	if(param0.GetPType()==SP_ADVENTUREARMY)
	{
		army=param0.GetAdventureArmy();
		if(army==None) return 0.0f;
	}
	else
	{
		return 0.0f;
	}

	if( param1.GetPType()==SP_AMAPCELL )
	{
		cell=param1.GetAMapCell();
		if(cell==None) return 0.0f;
		return CalculateThreat(army,cell);
	}

	// wrong parameter type ...
	return 0.0f;
}
