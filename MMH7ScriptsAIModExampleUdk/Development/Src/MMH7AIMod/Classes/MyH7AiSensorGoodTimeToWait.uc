//=============================================================================
// H7AiSensorGoodTimeToWait
//=============================================================================
// 
// Checks if it's a good time to wait
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class MyH7AiSensorGoodTimeToWait extends H7AiSensorBase;

/// overrides ...

function float GetValue1( H7AiSensorParam param )
{
	if( param.GetPType() == SP_UNIT )
	{
		return IsGoodTimeToWait( class'H7CombatController'.static.GetInstance().GetActiveUnit() ) ? 1.0f : 0.0f;
	}
	// wrong parameter types
	return 0.0f;
}


static function bool IsGoodTimeToWait( H7Unit baseUnit )
{
	return true;
}
