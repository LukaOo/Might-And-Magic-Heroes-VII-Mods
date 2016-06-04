//=============================================================================
// H7AiUtilityTownDistance
//=============================================================================
// ...
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityTownBuilding extends H7AiUtilitySensor;

var protected array<H7TownBuilding>                 mInBuildings;

/// overrides ...

function UpdateInput()
{
	local H7AiAdventureSensors sensors;
	local H7TownBuilding build;

//	`LOG_AI("Utility.TownBuilding");

	mInBuildings.Remove(0,mInBuildings.Length);
	mInValues.Remove(0,mInValues.Length);
	sensors = class'H7AdventureController'.static.GetInstance().GetAI().GetSensors();
	sensors.CallBegin( mInSensorConst0, mInSensorConst1 );
	while( sensors.CallNext() == true )
	{
		build=sensors.GetParam0().GetBuilding();
		if(build!=None)
		{
			mInBuildings.AddItem(build);
			mInValues.AddItem(sensors.CallSensor(mInSensorAdv));
		}		
	}

}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

function array<H7TownBuilding> GetOutBuildings() { return mInBuildings; }

