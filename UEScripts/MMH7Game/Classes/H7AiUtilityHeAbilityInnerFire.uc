//=============================================================================
// H7AiUtilityHeAbilityInnerFire
//=============================================================================
// Buff. Positive. Target creature stack gets a buff that lasts for the 
// creature's next 3 turns.
// Buff effect 1: The creature's attack value is increased:
//    Unskilled: 1 * Magic + 3
//    Novice: 1.3 * Magic + 4
//    Expert: 1.7 * Magic + 6
//    Master: 2.5 * Magic + 8
// Buff effect 2: The creature's initiative is increased:
//    Unskilled: 1
//    Novice: 2
//    Expert: 5
//    Master: 10
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityInnerFire extends H7AiUtilityCombiner;

var protected H7AiUtilitySpellTargetCheck   mUSpellTargetCheck;
var protected H7AiUtilityCreatureStrength   mUCreatureStrength;
var protected H7AiUtilityCreatureCanAttack  mUCreatureCanAttack;

/// overrides ...
function UpdateInput()
{
	local array<float> uSpellCheck;
	local array<float> uCreatureStrength;
	local array<float> uCreatureCanAttack;

	if(mUSpellTargetCheck==None) { mUSpellTargetCheck = new class'H7AiUtilitySpellTargetCheck'; }
	if(mUCreatureStrength==None) { mUCreatureStrength = new class'H7AiUtilityCreatureStrength'; }
	if(mUCreatureCanAttack==None) { mUCreatureCanAttack = new class'H7AiUtilityCreatureCanAttack'; }

	mInValues.Remove(0,mInValues.Length);

	mUCreatureCanAttack.UpdateInput();
	mUCreatureCanAttack.UpdateOutput();
	uCreatureCanAttack = mUCreatureCanAttack.GetOutValues();
	if(uCreatureCanAttack.Length>0 && uCreatureCanAttack[0]<=0.0f) // target can attack an enemy creature in its next turn
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

