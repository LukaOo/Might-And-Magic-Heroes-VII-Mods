//=============================================================================
// H7AiUtilityHeAbilityHoldPositions
//=============================================================================
// The "Hold Positions!" warcry gets the following additional effect:
// All friendly stacks +2 defense and all friendly melee units get +8 attack 
// long as this command is active. Any affected stack loses those bonuses 
// when it moves.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityHoldPositions extends H7AiUtilityCombiner;

var protected H7AiUtilitySpellTargetCheck   mUSpellTargetCheck;
var protected H7AiUtilityCreatureCount      mUCreatureCount;
var protected H7AiUtilityRangedCreatureCount    mURangedCreatureCount;

/// overrides ...
function UpdateInput()
{
	local array<float> uSpellCheck;
	local array<float> uCreatureCount;
	local array<float> uRangedCreatureCount;

//	`LOG_AI("Utility.HeAbilityHoldPositions");

	if(mUSpellTargetCheck==None) { mUSpellTargetCheck = new class'H7AiUtilitySpellTargetCheck'; }
	if(mUCreatureCount==None) { mUCreatureCount = new class'H7AiUtilityCreatureCount'; }
	if(mURangedCreatureCount==None) { mURangedCreatureCount = new class'H7AiUtilityRangedCreatureCount'; }

	mInValues.Remove(0,mInValues.Length);
	
	// all remaining creatures need to be ranged
	mURangedCreatureCount.UpdateInput();
	mURangedCreatureCount.UpdateOutput();
	uRangedCreatureCount = mURangedCreatureCount.GetOutValues();
	if(uRangedCreatureCount.Length>0 && uRangedCreatureCount[0]>=1.0f)
	{
		mUSpellTargetCheck.UpdateInput();
		mUSpellTargetCheck.UpdateOutput();
		uSpellCheck = mUSpellTargetCheck.GetOutValues();
		if(uSpellCheck.Length>0 && uSpellCheck[0]>0.0f)
		{
			mUCreatureCount.UpdateInput();
			mUCreatureCount.UpdateOutput();
			uCreatureCount = mUCreatureCount.GetOutValues();
			if(uCreatureCount.Length>0 && uCreatureCount[0]>0.0f)
			{
				mInValues.AddItem(uSpellCheck[0]*uCreatureCount[0]);
			}
		}
	}
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

