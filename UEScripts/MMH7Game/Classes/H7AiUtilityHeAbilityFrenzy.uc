//=============================================================================
// H7AiUtilityHeAbilityFrenzy
//=============================================================================
// Instant. Target stack attacks a random adjacent (friendly or enemy) stack 
// with a  modifier to its Attack Value.
// The target stack attacks with all its attack abilities like sweep, bash, 
// etc. No active abilities are used.
// The attacked stack retaliates this attack with the normal rules. (It only 
// retaliates if it has not retaliated already this turn, if it retaliates it 
// cannot retaliate again this turn etc.). Friendly units do NOT retaliate.
// The attacking stack does not lose its action for this turn.
//    Unskilled:(1*MAGIC - 50)
//    Novice:(2*MAGIC - 50)
//    Expert: (3*MAGIC - 50)
//    Master: (6*MAGIC - 50)
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityFrenzy extends H7AiUtilityCombiner;

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

//	`LOG_AI("Utility.HeAbilityFrenzy");

	if(mUSpellTargetCheck==None) { mUSpellTargetCheck = new class'H7AiUtilitySpellTargetCheck'; }
	if(mUCreatureStrength==None) { mUCreatureStrength = new class'H7AiUtilityCreatureStrength'; }
	if(mUCreatureIsRanged==None) { mUCreatureIsRanged = new class'H7AiUtilityCreatureIsRanged'; }
	if(mUCreatureAdjAlly==None) { mUCreatureAdjAlly = new class'H7AiUtilityCreatureAdjacentToAlly'; }

	mInValues.Remove(0,mInValues.Length);

	mUCreatureIsRanged.UpdateInput();
	mUCreatureIsRanged.UpdateOutput();
	uCreatureIsRanged = mUCreatureIsRanged.GetOutValues();
	if(uCreatureIsRanged.Length>0 && uCreatureIsRanged[0]>=1.0f) // needs to be melee
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

