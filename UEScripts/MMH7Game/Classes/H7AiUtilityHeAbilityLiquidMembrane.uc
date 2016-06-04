//=============================================================================
// H7AiUtilityHeAbilityLiquidMembrane
//=============================================================================
// Buff: target friendly stack gets a buff that last for 3 turns.
// Buff effect: All damage dealt to the creature is reduced before any resistance 
// or immunity effects of the creature are taken into account.
//    Unskilled:10%
//    Novice:15%
//    Expert: 25%
//    Master: 50%
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityLiquidMembrane extends H7AiUtilityCombiner;

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

