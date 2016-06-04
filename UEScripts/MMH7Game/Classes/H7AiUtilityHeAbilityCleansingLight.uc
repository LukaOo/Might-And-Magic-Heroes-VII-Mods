//=============================================================================
// H7AiUtilityHeAbilityCleansingLight
//=============================================================================
//Instant: removes a number of random negative magic effects from the target stack
//    Unskilled: 1
//    novice: 1
//    expert: 2
//    master: 3
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityCleansingLight extends H7AiUtilityCombiner;

/// overrides ...
function UpdateInput()
{
//	`LOG_AI("Utility.HeAbilityCleansingLight");

	mInValues.Remove(0,mInValues.Length);
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

