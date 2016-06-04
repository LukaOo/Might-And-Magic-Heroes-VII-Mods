//=============================================================================
// H7AiUtilityHeAbilityRegeneration
//=============================================================================
// Buff. Target friendly creature gets a buff that lasts for the next 3 turns
// Buff Effect: at the beginning of the stack's turn the stack's top creature heals health points:
//    Unskilled : 10 + 5*MAGIC
//    Novice:25 + 5*MAGIC
//    Expert: 50 + 5* MAGIC
//    Master: 75 + 5*MAGIC
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityRegeneration extends H7AiUtilityCombiner;

var protected H7AiUtilitySpellTargetCheck   mUSpellTargetCheck;
var protected H7AiUtilityCreatureStrength   mUCreatureStrength;
var protected H7AiUtilityCreatureTier       mUCreatureTier;

/// overrides ...
function UpdateInput()
{
	local array<float> uSpellCheck;
	local array<float> uCreatureStrength;
	local array<float> uCreatureTier;

	if(mUSpellTargetCheck==None) { mUSpellTargetCheck = new class'H7AiUtilitySpellTargetCheck'; }
	if(mUCreatureStrength==None) { mUCreatureStrength = new class'H7AiUtilityCreatureStrength'; }
	if(mUCreatureTier==None) { mUCreatureTier = new class'H7AiUtilityCreatureTier'; }

	mInValues.Remove(0,mInValues.Length);

	mUCreatureTier.mTier=CTIER_CORE;
	mUCreatureTier.UpdateInput();
	mUCreatureTier.UpdateOutput();
	uCreatureTier = mUCreatureTier.GetOutValues();
	if(uCreatureTier.Length>0 && uCreatureTier[0]>=1.0f) // target is not a core creature
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

