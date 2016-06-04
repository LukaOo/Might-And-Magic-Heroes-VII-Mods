//=============================================================================
// H7AiUtilityReplenishScore
//=============================================================================
// ...
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityReplenishScore extends H7AiUtilityCombiner;

var H7AiUtilityMovementEffortRe             mInUMovementEffort;
var H7AiUtilityUpgradeGain                  mInUUpgradeGain;

var String dbgString;

var float   mMovementEffortBias;

/// overrides ...

function UpdateInput()
{
	local array<float> movementEffort;
	local array<float> upgradeGain;
	local float util;

//	`LOG_AI("Utility.ReplenishScore");

	if( mInUMovementEffort == None ) { mInUMovementEffort = new class 'H7AiUtilityMovementEffortRe'; }
    if( mInUUpgradeGain == None ) { mInUUpgradeGain = new class 'H7AiUtilityUpgradeGain'; }

	mInValues.Remove(0,mInValues.Length);

	mInUMovementEffort.mFBias=mMovementEffortBias;

	mInUMovementEffort.UpdateInput();
	mInUMovementEffort.UpdateOutput();
	movementEffort = mInUMovementEffort.GetOutValues();

	mInUUpgradeGain.UpdateInput();
	mInUUpgradeGain.UpdateOutput();
	upgradeGain = mInUUpgradeGain.GetOutValues();
	if( upgradeGain[0] > 0.0f )
	{
		upgradeGain[0] = 1.0f;
	}
	else
	{
		upgradeGain[0] = 0.0f;
	}

	// make sure the arrays contain the same number of out-values
	if( movementEffort.Length != 0 && movementEffort[0] > 0.0f )
	{
		util = movementEffort[0]*upgradeGain[0];
		mInValues.AddItem( util );
		dbgString = "ReplenishScore(" $ util $ ";ME(" $ movementEffort[0] $ ");UG(" $ upgradeGain[0] $ ")) ";
	}

}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

