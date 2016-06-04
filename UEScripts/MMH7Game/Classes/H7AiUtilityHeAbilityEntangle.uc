//=============================================================================
// H7AiUtilityHeAbilityEntangle
//=============================================================================
// Buff. Negative. Target hostile creature gets a debuff that lasts for the next 3 turns.
// Buff Effect 1: The movement points of the creature is reduced, but not below 1.
//    Unskilled: 2
//    Novice : 3
//    Expert: 4
//    Master: 6
// Buff effect 2: Movement based abilities cannot be activated:
//    Diving Attack
//    Mighty Pounce
//    Feral Charge
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityEntangle extends H7AiUtilityCombiner;

var protected H7AiUtilitySpellTargetCheck   mUSpellTargetCheck;
var protected H7AiUtilityCreatureStrength   mUCreatureStrength;
var protected H7AiUtilityCreatureIsRanged   mUCreatureIsRanged;
var protected H7AiUtilityCreatureAdjacentToAlly mUCreatureAdjAlly;

/// overrides ...
function UpdateInput()
{
	local array<float> uSpellCheck;
	local array<float> uCreatureStrength;
	local array<float> uCreatureIsRanged;
	local array<float> uCreatureAdjAlly;

//	`LOG_AI("Utility.HeAbilityEntangle");

	if(mUSpellTargetCheck==None) { mUSpellTargetCheck = new class'H7AiUtilitySpellTargetCheck'; }
	if(mUCreatureStrength==None) { mUCreatureStrength = new class'H7AiUtilityCreatureStrength'; }
	if(mUCreatureIsRanged==None) { mUCreatureIsRanged = new class'H7AiUtilityCreatureIsRanged'; }
	if(mUCreatureAdjAlly==None) { mUCreatureAdjAlly = new class'H7AiUtilityCreatureAdjacentToAlly'; }

	mInValues.Remove(0,mInValues.Length);

	mUCreatureIsRanged.UpdateInput();
	mUCreatureIsRanged.UpdateOutput();
	uCreatureIsRanged = mUCreatureIsRanged.GetOutValues();
	if(uCreatureIsRanged.Length>0 && uCreatureIsRanged[0]>=1.0f) // target is melee
	{
		return;
	}

	mUCreatureAdjAlly.UpdateInput();
	mUCreatureAdjAlly.UpdateOutput();
	uCreatureAdjAlly = mUCreatureAdjAlly.GetOutValues();
	if(uCreatureAdjAlly.Length>0 && uCreatureAdjAlly[0]>=1.0f) // target is not adjacent to a friendly creature
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

