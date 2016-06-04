//=============================================================================
// H7AiSensorGameProgress
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorGameProgress extends H7AiSensorBase;

/// overrides ...

function float GetValue0( )
{
	return max(0.0f,1.0f-(0.05f*class'H7AdventureController'.static.GetInstance().GetTurns()));
}
