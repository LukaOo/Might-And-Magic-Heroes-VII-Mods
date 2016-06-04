//=============================================================================
// H7AiUtilityHeAbilityTimeControl
//=============================================================================
// On friendly creature stacks:
// Buff. Positive. Target friendly creature stack gets a buff which lasts for 
// the creature's next 3 turns. 
// Buff effect: The creature's initiative is increased as long as the buff is 
// applied.
//            Unskilled: 5
//            Novice: 7
//            Expert: 10
//            Master: 15
// On hostile creature stacks:
// Buff. Negative. Target hostile creature stack gets a debuff which lasts for 
// the creature's next 3 turns. 
// Debuff effect: The creature's initiative is decreased as long as the buff 
// is applied.
//            Unskilled: 5
//            Novice: 7
//            Expert: 10
//            Master: 15
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityTimeControl extends H7AiUtilityCombiner;

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

