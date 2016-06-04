//=============================================================================
// H7AiUtilityHeAbilityStoneSkin
//=============================================================================
// Buff. Positive. Target friendly creature stack gets a buff which lasts for 
// the creature's next 3 turns.
// Buff effect: The creature's defense is increased:
//    Unskilled: 1 * Magic + 3
//    Novice: 1.3 * Magic + 4
//    Expert: 1.7 * Magic + 6
//    Master: 2.5 * Magic + 8
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityStoneSkin extends H7AiUtilityCombiner;

var protected H7AiUtilitySpellTargetCheck   mUSpellTargetCheck;
var protected H7AiUtilityCreatureStrength   mUCreatureStrength;
var protected H7AiUtilityCreatureIsRanged   mUCreatureIsRanged;
var protected H7AiUtilityCreatureAdjacentToEnemy mUCreatureAdjEnemy;
var protected H7AiUtilityCreatureCanBeAttacked mUCreatureCanBeAttacked;

/// overrides ...
function UpdateInput()
{
	local array<float> uSpellCheck;
	local array<float> uCreatureStrength;
	local array<float> uCreatureIsRanged;
	local array<float> uCreatureAdjEnemy;
	local array<float> uCreatureCanBeAttacked;

	if(mUSpellTargetCheck==None) { mUSpellTargetCheck = new class'H7AiUtilitySpellTargetCheck'; }
	if(mUCreatureStrength==None) { mUCreatureStrength = new class'H7AiUtilityCreatureStrength'; }
	if(mUCreatureIsRanged==None) { mUCreatureIsRanged = new class'H7AiUtilityCreatureIsRanged'; }
	if(mUCreatureAdjEnemy==None) { mUCreatureAdjEnemy = new class'H7AiUtilityCreatureAdjacentToEnemy'; }
	if(mUCreatureCanBeAttacked==None) { mUCreatureCanBeAttacked = new class'H7AiUtilityCreatureCanBeAttacked'; }

	mInValues.Remove(0,mInValues.Length);

	mUCreatureIsRanged.UpdateInput();
	mUCreatureIsRanged.UpdateOutput();
	uCreatureIsRanged = mUCreatureIsRanged.GetOutValues();

	mUCreatureAdjEnemy.UpdateInput();
	mUCreatureAdjEnemy.UpdateOutput();
	uCreatureAdjEnemy = mUCreatureAdjEnemy.GetOutValues();

	// not on target that is ranged but not adjacent to an enemy creature
	if(uCreatureIsRanged.Length>0 && uCreatureIsRanged[0]>=1.0f &&
	   uCreatureAdjEnemy.Length>0 && uCreatureAdjEnemy[0]<=0.0f)
	{
		return;
	}

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

