//=============================================================================
// H7AiUtilityHeAbilityEngage
//=============================================================================
// The "Engage!" warcry gets the following additional effect:
// The attack value for melee attacks of all friendly creatures is increased by 
// 15 when they target an enemy creature that cannot retaliate this attack.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityEngage extends H7AiUtilityCombiner;

var protected H7AiUtilitySpellTargetCheck   mUSpellTargetCheck;
var protected H7AiUtilityCreatureCount      mUCreatureCount;

/// overrides ...
function UpdateInput()
{
	local array<float> uSpellCheck;
	local array<float> uCreatureCount;

//	`LOG_AI("Utility.HeAbilityEngage");

	if(mUSpellTargetCheck==None) { mUSpellTargetCheck = new class'H7AiUtilitySpellTargetCheck'; }
	if(mUCreatureCount==None) { mUCreatureCount = new class'H7AiUtilityCreatureCount'; }

	mInValues.Remove(0,mInValues.Length);

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

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

