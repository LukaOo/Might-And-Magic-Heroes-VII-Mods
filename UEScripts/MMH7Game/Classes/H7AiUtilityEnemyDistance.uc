//=============================================================================
// H7AiUtilityEnemyDistance
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityEnemyDistance extends H7AiUtilitySensor;

/// overrides ...

function UpdateInput()
{
	local H7CombatMapGridController grid_ctrl;
	local H7CombatMapGrid grid;
	local H7AiCombatSensors sensors;
	local IntPoint p0,p1;

	mInValues.Remove(0,mInValues.Length);

	// set input normalisation parameters from map properties
	grid_ctrl = class'H7CombatMapGridController'.static.GetInstance();
	grid = grid_ctrl.GetCombatGrid();
	if(grid!=None)
	{
		p0.X=0; p1.X=grid.GetXSize();
		p0.Y=0; p1.Y=grid.GetYSize();
		mInMax = class'H7Math'.static.GetDistanceIntPoints(p0,p1);
		mInNorm = 1.0f / mInMax;
	}

	sensors = class'H7CombatController'.static.GetInstance().GetAI().GetSensors();
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

