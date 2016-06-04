//=============================================================================
// H7AiUtilityHeAbilityTeleport
//=============================================================================
// Effect. Instant. Relocate target friendly stack to any unoccupied space 
// within a certain distance on the combat map.
//    Unskilled: 3
//    novice: 5
//    expert: 7
//    Master: unlimited (100)
// The stack keeps the facing it had before casting the spell.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityTeleport extends H7AiUtilityCombiner;

/// overrides ...
function UpdateInput()
{
//	`LOG_AI("Utility.HeAbilityTeleport");

	mInValues.Remove(0,mInValues.Length);
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

