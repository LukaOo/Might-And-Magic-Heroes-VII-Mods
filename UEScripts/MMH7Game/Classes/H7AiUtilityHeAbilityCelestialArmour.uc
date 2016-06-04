//=============================================================================
// H7AiUtilityHeAbilityCelestialArmour
//=============================================================================
// Buff. Positive. Target creature stack gets a buff that lasts for the 
// creature's next 3 turns.
// Buff effect: The buff absorbs damage from any source up to a cap.
// All damage modifiers are applied before the absorption.
// When the capacity of the buff has been reached, the buff is removed prematurely.
// If more damage than the remaining capacity of the buff is dealt, the amount 
// exceeding the remaining capacity is dealt to the stack normally.
//    Unskilled: 10 * Magic + 30
//    Novice: 12 * Magic + 36
//    Expert: 15 * Magic + 45
//    Master: 20 * Magic + 60
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityCelestialArmour extends H7AiUtilityCombiner;

var protected H7AiUtilitySpellTargetCheck   mUSpellTargetCheck;
var protected H7AiUtilityCreatureStrength   mUCreatureStrength;
var protected H7AiUtilityCreatureCanBeAttacked mUCreatureCanBeAttacked;

/// overrides ...
function UpdateInput()
{
	local array<float> uSpellCheck;
	local array<float> uCreatureStrength;
	local array<float> uCreatureCanBeAttacked;

//	`LOG_AI("Utility.HeAbilityCelestialArmour");

	if(mUSpellTargetCheck==None) { mUSpellTargetCheck = new class'H7AiUtilitySpellTargetCheck'; }
	if(mUCreatureStrength==None) { mUCreatureStrength = new class'H7AiUtilityCreatureStrength'; }
	if(mUCreatureCanBeAttacked==None) { mUCreatureCanBeAttacked = new class'H7AiUtilityCreatureCanBeAttacked'; }

	mInValues.Remove(0,mInValues.Length);

	mUCreatureCanBeAttacked.UpdateInput();
	mUCreatureCanBeAttacked.UpdateOutput();
	uCreatureCanBeAttacked = mUCreatureCanBeAttacked.GetOutValues();
	if(uCreatureCanBeAttacked.Length>0 && uCreatureCanBeAttacked[0]<=0.0f) // target can be attacked by an enemy creature in its next turn (= is in range)
	{
		return;
	}

	mUSpellTargetCheck.UpdateInput();
	mUSpellTargetCheck.UpdateOutput();
	uSpellCheck = mUSpellTargetCheck.GetOutValues();
	if(uSpellCheck.Length>0 && uSpellCheck[0]>0.0f)
	{
		mUCreatureStrength.UpdateInput();
		mUCreatureStrength.UpdateOutput();
		uCreatureStrength = mUCreatureStrength.GetOutValues();
		if(uCreatureStrength.Length>0 && uCreatureStrength[0]>0.0f)
		{   
			mInValues.AddItem(uSpellCheck[0]*uCreatureStrength[0]);
		}
	}

}


function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

