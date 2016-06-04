//=============================================================================
// H7AiUtilityHeAbilityStormArrows
//=============================================================================
// Buff. Positive. Target friendly creature stack capable of ranged attacks 
// receives a buff which lasts for the creature's next 3 turns.
// Buff Effect 1: The creature's attack value is increased by:
//    Unskilled: 1 * Magic + 6
//    Novice: 1 * Magic + 9
//    Expert: 1 * Magic + 14
//    Master: 1 * Magic + 23
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityStormArrows extends H7AiUtilityCombiner;

var protected H7AiUtilitySpellTargetCheck   mUSpellTargetCheck;
var protected H7AiUtilityCanRangeAttack     mUCanRangeAttack;

/// overrides ...
function UpdateInput()
{
	local array<float> uSpellCheck;
	local array<float> uCanRangeAttack;

//	`LOG_AI("Utility.HeAbilityStormArrows");

	if(mUSpellTargetCheck==None) { mUSpellTargetCheck = new class'H7AiUtilitySpellTargetCheck'; }
	if(mUCanRangeAttack==None) { mUCanRangeAttack = new class'H7AiUtilityCanRangeAttack'; }

	mInValues.Remove(0,mInValues.Length);

	mUCanRangeAttack.UpdateInput();
	mUCanRangeAttack.UpdateOutput();
	uCanRangeAttack = mUCanRangeAttack.GetOutValues();
	if(uCanRangeAttack.Length>0 && uCanRangeAttack[0]>0.0f)
	{
		mUSpellTargetCheck.UpdateInput();
		mUSpellTargetCheck.UpdateOutput();
		uSpellCheck = mUSpellTargetCheck.GetOutValues();
		if(uSpellCheck.Length>0 && uSpellCheck[0]>0.0f)
		{
			mInValues.AddItem(uSpellCheck[0]);
		}
	}
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

