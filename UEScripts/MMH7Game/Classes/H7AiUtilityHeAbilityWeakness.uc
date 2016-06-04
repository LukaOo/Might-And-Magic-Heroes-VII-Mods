//=============================================================================
// H7AiUtilityHeAbilityWeakness
//=============================================================================
// Debuff. Negative. Target enemy creature stack gets a debuff which lasts for 
// the creature's next 3 turns.
// Debuff effect: The creature's attack value is decreased by:
//    Unskilled: 1 * Magic + 3
//    Novice: 1.3 * Magic + 4
//    Expert: 1.7 * Magic + 6
//    Master: 2.5 * Magic + 8
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityWeakness extends H7AiUtilityCombiner;

var protected H7AiUtilitySpellTargetCheck   mUSpellTargetCheck;
var protected H7AiUtilityCreatureStrength   mUCreatureStrength;
var protected H7AiUtilityCreatureIsRanged   mUCreatureIsRanged;

/// overrides ...
function UpdateInput()
{
	local array<float> uSpellCheck;
	local array<float> uCreatureStrength;
	local array<float> uCreatureIsRanged;

	if(mUSpellTargetCheck==None) { mUSpellTargetCheck = new class'H7AiUtilitySpellTargetCheck'; }
	if(mUCreatureStrength==None) { mUCreatureStrength = new class'H7AiUtilityCreatureStrength'; }
	if(mUCreatureIsRanged==None) { mUCreatureIsRanged = new class'H7AiUtilityCreatureIsRanged'; }

	mInValues.Remove(0,mInValues.Length);

	mUCreatureIsRanged.UpdateInput();
	mUCreatureIsRanged.UpdateOutput();
	uCreatureIsRanged = mUCreatureIsRanged.GetOutValues();
	if(uCreatureIsRanged.Length>0 && uCreatureIsRanged[0]>=1.0f) // needs to be melee
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

