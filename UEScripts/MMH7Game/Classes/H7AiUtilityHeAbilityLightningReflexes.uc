//=============================================================================
// H7AiUtilityHeAbilityLightningReflexes
//=============================================================================
// Buff. Positive. Target friendly creature stack receives a buff which lasts for
//    Unskilled: 1
//    Novice: 1
//    Expert: 2
//    Master: 3
// turn(s) of the creature.
// Buff Effect 1: The creature receives an additional strike for melee attacks. 
// If the enemy retaliates the extra strike is executed after the retaliation.
// Buff Effect 2:
// The attack value for the additional strikes (granted by this spell) is modified.
//    Unskilled: 1 * Magic - 30
//    Novice: 1.5 * Magic - 30
//    Expert: 1.5 * Magic - 30
//    Master: 2 * Magic - 30
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityLightningReflexes extends H7AiUtilityCombiner;

var protected H7AiUtilitySpellTargetCheck   mUSpellTargetCheck;
var protected H7AiUtilityCreatureStrength   mUCreatureStrength;
var protected H7AiUtilityCreatureIsRanged   mUCreatureIsRanged;
var protected H7AiUtilityCreatureCanAttack  mUCreatureCanAttack;

/// overrides ...
function UpdateInput()
{
	local array<float> uSpellCheck;
	local array<float> uCreatureStrength;
	local array<float> uCreatureIsRanged;
	local array<float> uCreatureCanAttack;

	if(mUSpellTargetCheck==None) { mUSpellTargetCheck = new class'H7AiUtilitySpellTargetCheck'; }
	if(mUCreatureStrength==None) { mUCreatureStrength = new class'H7AiUtilityCreatureStrength'; }
	if(mUCreatureIsRanged==None) { mUCreatureIsRanged = new class'H7AiUtilityCreatureIsRanged'; }
	if(mUCreatureCanAttack==None) { mUCreatureCanAttack = new class'H7AiUtilityCreatureCanAttack'; }

	mInValues.Remove(0,mInValues.Length);

	mUCreatureIsRanged.UpdateInput();
	mUCreatureIsRanged.UpdateOutput();
	uCreatureIsRanged = mUCreatureIsRanged.GetOutValues();
	if(uCreatureIsRanged.Length>0 && uCreatureIsRanged[0]>=1.0f) // needs to be melee
	{
		return;
	}

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

