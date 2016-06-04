//=============================================================================
// H7AiUtilityHeAbilityFogShroud
//=============================================================================
// Buff: target friendly stack gets a buff that last for 2 turns.
// Buff effect 1: The creature can't be the target of ranged attacks.
// Buff effect 2: The creature can't use its ranged attack or activated abilities:
//    Default Range Attack
//    Soldering Hands
//    Soul Reaver
//    Mighty Pounce
//    Feral Charge
//    Resurrection
//    Piercing Shot
//    Nova
//    Splash
//    Leaf Daggers
//    Diving Attack
//    Living Shelter
//    Soul Reaver
//    Opportunity attack
//    Maneuver
//    Fiery Eye
//    Thorns
// Buff effect 3: If the creature receives any damage the buff is removed.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityFogShroud extends H7AiUtilityCombiner;

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

//	`LOG_AI("Utility.HeAbilityFogShroud");

	mInValues.Remove(0,mInValues.Length);

	if(mUSpellTargetCheck==None) { mUSpellTargetCheck = new class'H7AiUtilitySpellTargetCheck'; }
	if(mUCreatureStrength==None) { mUCreatureStrength = new class'H7AiUtilityCreatureStrength'; }
	if(mUCreatureIsRanged==None) { mUCreatureIsRanged = new class'H7AiUtilityCreatureIsRanged'; }
	if(mUCreatureAdjAlly==None) { mUCreatureAdjAlly = new class'H7AiUtilityCreatureAdjacentToAlly'; }

	mInValues.Remove(0,mInValues.Length);

	mUCreatureIsRanged.UpdateInput();
	mUCreatureIsRanged.UpdateOutput();
	uCreatureIsRanged = mUCreatureIsRanged.GetOutValues();
	if(uCreatureIsRanged.Length>0 && uCreatureIsRanged[0]<=0.0f) // needs to be ranged
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

