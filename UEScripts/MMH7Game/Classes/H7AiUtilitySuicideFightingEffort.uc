//=============================================================================
// H7AiUtilitySuicideFightingEffort
//=============================================================================
// ...
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilitySuicideFightingEffort extends H7AiUtilitySensor;

/// overrides ...

function UpdateInput()
{
	local H7AiAdventureSensors sensors;

//	`LOG_AI("Utility.SuicideFightingEffort");

	mInValues.Remove(0,mInValues.Length);
	sensors = class'H7AdventureController'.static.GetInstance().GetAI().GetSensors();
	sensors.CallBegin( mInSensorConst0, mInSensorConst1 );
	while( sensors.CallNext() == true )
	{
		mInValues.AddItem( sensors.CallSensor(mInSensorAdv) );
	}

}

function UpdateOutput()
{
	local int k;

	ApplyFunction();

	for(k=0;k<mOutValues.Length;k++)
	{
		mOutValues[k]=FuncBias(mOutValues[k]);
	}

	ApplyOutputWeigth();
}

/// functions

