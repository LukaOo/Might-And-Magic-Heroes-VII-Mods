//=============================================================================
// H7AiSensorBase
//=============================================================================
// Just an interface class all sensors need to derive from.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorBase extends Object
	native;

/// override function(s)

function float GetValue0()
{
	return 0.0f;
}

function float GetValue1( H7AiSensorParam param0 )
{
	return 0.0f;
}

function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	return 0.0f;
}
