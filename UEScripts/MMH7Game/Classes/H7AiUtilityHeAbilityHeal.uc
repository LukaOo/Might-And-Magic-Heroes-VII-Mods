//=============================================================================
// H7AiUtilityHeAbilityHeal
//=============================================================================
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityHeal extends H7AiUtilityCombiner;

var protected H7AiUtilitySpellSingleHeal  mUSpellHeal;

/// overrides ...
function UpdateInput()
{
	local array<float>              uHeal;

//	`LOG_AI("Utility.HeAbilityHeal");

	if(mUSpellHeal==None) { mUSpellHeal = new class'H7AiUtilitySpellSingleHeal'; }

	mInValues.Remove(0,mInValues.Length);

	mUSpellHeal.mFBias=0.65f;
	mUSpellHeal.UpdateInput();
	mUSpellHeal.UpdateOutput();
	uHeal = mUSpellHeal.GetOutValues();

	if(uHeal.Length>0 && uHeal[0]>0.0f)
	{
		mInValues.AddItem(uHeal[0]);
	}
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

