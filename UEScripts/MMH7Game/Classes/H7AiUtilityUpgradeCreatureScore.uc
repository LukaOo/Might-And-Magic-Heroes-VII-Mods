//=============================================================================
// H7AiUtilityUpgradeCreatureScore
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityUpgradeCreatureScore extends H7AiUtilityCombiner;

var H7AiUtilityCanUpgrade       mUCanUpgrade;

var String dbgString;

/// overrides ...

function UpdateInput()
{
	local array<float> canUpgrade;
	local float util;

//	`LOG_AI("Utility.UpgradeCreatureScore");

	if( mUCanUpgrade == None ) { mUCanUpgrade = new class 'H7AiUtilityCanUpgrade'; }

	mInValues.Remove(0,mInValues.Length);

	mUCanUpgrade.UpdateInput();
	mUCanUpgrade.UpdateOutput();
	canUpgrade = mUCanUpgrade.GetOutValues();

	// make sure the arrays contain the same number of out-values
	if( canUpgrade.Length != 0 )
	{
		util = canUpgrade[0];
		mInValues.AddItem( util );

		dbgString = "UpgradeCreatureScore(" $ util $ ";CU(" $ canUpgrade[0] $ ")) ";
	}
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

