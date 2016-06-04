//=============================================================================
// H7AiUtilityHeAbilityLightningBurst
//=============================================================================
// Buff. Target creature stack gets a buff that lasts until damage is dealt by it.
// Buff effect 1: At the beginning of the creature's turn deal AIR damage to 
// each creature adjacent to the buffed creature
// Buff effect 2: Remove the buff if actual damage was dealt by this effect
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityLightningBurst extends H7AiUtilityCombiner;

var protected H7AiUtilitySpellTargetCheck   mUSpellTargetCheck;
var protected H7AiUtilityCreatureStrength   mUCreatureStrength;

/// overrides ...
function UpdateInput()
{
	local array<float> uSpellCheck;
	local array<float> uCreatureStrength;

	if(mUSpellTargetCheck==None) { mUSpellTargetCheck = new class'H7AiUtilitySpellTargetCheck'; }
	if(mUCreatureStrength==None) { mUCreatureStrength = new class'H7AiUtilityCreatureStrength'; }

	mInValues.Remove(0,mInValues.Length);

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

