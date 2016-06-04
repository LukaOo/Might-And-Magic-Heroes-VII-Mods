//=============================================================================
// H7AiUtilityHeAbilityFortune
//=============================================================================
// Buff. Positive. Target creature stack gets a buff that lasts for the 
// creature's next 3 turns.
// Buff effect: The creature's luck is increased by:
//    Unskilled: 1 * Magic +10
//    Novice: 1.3 * Magic + 15
//    Expert: 1.7 * Magic + 25
//    Master: 2.5 * Magic + 40
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityFortune extends H7AiUtilityCombiner;

var protected H7AiUtilitySpellTargetCheck   mUSpellTargetCheck;
var protected H7AiUtilityCreatureStrength   mUCreatureStrength;
var protected H7AiUtilityCreatureStat       mUCreatureStat;

/// overrides ...
function UpdateInput()
{
	local array<float> uSpellCheck;
	local array<float> uCreatureStrength;
	local array<float> uCreatureStat;

	if(mUSpellTargetCheck==None) { mUSpellTargetCheck = new class'H7AiUtilitySpellTargetCheck'; }
	if(mUCreatureStrength==None) { mUCreatureStrength = new class'H7AiUtilityCreatureStrength'; }
	if(mUCreatureStat==None) { mUCreatureStat = new class'H7AiUtilityCreatureStat'; }

	mInValues.Remove(0,mInValues.Length);

	mUCreatureStat.mStat=TS_STAT_DESTINY;
	mUCreatureStat.UpdateInput();
	mUCreatureStat.UpdateOutput();
	uCreatureStat = mUCreatureStat.GetOutValues();
	if(uCreatureStat.Length>0 && uCreatureStat[0]>=40.0f)
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

