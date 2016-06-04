//=============================================================================
// H7AiUtilityCreatureStat
//=============================================================================
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityCreatureStat extends H7AiUtilitySensor;

var ETargetStat mStat;

/// overrides ...

function UpdateInput()
{
	local H7AiCombatSensors sensors;
	mInValues.Remove(0,mInValues.Length);
	sensors = class'H7CombatController'.static.GetInstance().GetAI().GetSensors();
	sensors.GetSensorIConsts().SetCreatureStat(mStat);
	sensors.CallBegin( mInSensorConst0, mInSensorConst1 );
	while( sensors.CallNext() == true )
	{
		mInValues.AddItem( sensors.CallSensor(mInSensor) );
	}
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

