//=============================================================================
// H7AiUtilityHeAbilityChainLightning
//=============================================================================
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityChainLightning extends H7AiUtilityCombiner;

var protected H7AiUtilitySpellMultiDamage  mUSpellDamage;

/// overrides ...
function UpdateInput()
{
	local array<float>              uDamage;

//	`LOG_AI("Utility.HeAbilityChainLightning");

	if(mUSpellDamage==None) { mUSpellDamage = new class'H7AiUtilitySpellMultiDamage'; }

	mInValues.Remove(0,mInValues.Length);

	mUSpellDamage.mFBias=0.65f;
	mUSpellDamage.UpdateInput();
	mUSpellDamage.UpdateOutput();
	uDamage = mUSpellDamage.GetOutValues();
	if(uDamage.Length>0 && uDamage[0]>0.0f)
	{
		mInValues.AddItem(uDamage[0]);
	}
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

