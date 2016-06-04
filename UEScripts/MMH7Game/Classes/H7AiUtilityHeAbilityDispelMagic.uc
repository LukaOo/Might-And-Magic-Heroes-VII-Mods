//=============================================================================
// H7AiUtilityHeAbilityDispelMagic
//=============================================================================
// Effect. Instant. Removes all buffs and debuffs from the target stack.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityDispelMagic extends H7AiUtilityCombiner;

/// overrides ...
function UpdateInput()
{
//	`LOG_AI("Utility.HeAbilityDispelMagic");

	mInValues.Remove(0,mInValues.Length);
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

