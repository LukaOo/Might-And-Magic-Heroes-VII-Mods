//=============================================================================
// H7AiUtilityHeAbilityRetribution
//=============================================================================
// Buff. Target friendly creature gets a buff that lasts for 3 turns.
// Buff effect: Whenever the buffed creature takes damage from another creature 
// retribution deals light damage to the source.
// This includes melee and ranged attacks as well as direct damage active abilities.
//    Unskilled: 10 * Magic + (0 to 60)
//    Novice: 14 * Magic + (21 to 63)
//    Expert: 20 * Magic + (45 to 75)
//    Master: 40 * Magic + (108 to 132)
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityRetribution extends H7AiUtilityCombiner;

var protected H7AiUtilitySpellTargetCheck   mUSpellTargetCheck;
var protected H7AiUtilityCreatureStrength   mUCreatureStrength;
var protected H7AiUtilityCreatureCanBeAttacked mUCreatureCanBeAttacked;

/// overrides ...
function UpdateInput()
{
	local array<float> uSpellCheck;
	local array<float> uCreatureStrength;
	local array<float> uCreatureCanBeAttacked;

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

