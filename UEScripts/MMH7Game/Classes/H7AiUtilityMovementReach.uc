//=============================================================================
// H7AiUtilityMovementReach
//=============================================================================
// ...
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityMovementReach extends H7AiUtilitySensor;

/// overrides ...

function UpdateInput()
{
	local H7AiAdventureSensors sensors;

//	`LOG_AI("Utility.MovementReach");

	mInValues.Remove(0,mInValues.Length);
	sensors = class'H7AdventureController'.static.GetInstance().GetAI().GetSensors();
	if( sensors.GetSensorIConsts().GetTargetArmyAdv() != None )
		sensors.CallBegin( mInSensorConst0, SIC_TARGET_ARMY );
	else
		sensors.CallBegin( mInSensorConst0, SIC_TARGET_VISSITE );
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

