//=============================================================================
// H7AiUtilityReinforceScore
//=============================================================================
// ...
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityReinforceScore extends H7AiUtilityCombiner;

var H7AiUtilityMovementEffortRe    mInUMovementEffort;
var H7AiUtilityReinforcementGainReverse   mInUReinforcementGain;

var String dbgString;

var float mMovementEffortBias;
var float mReinforcementBias;

/// overrides ...

function UpdateInput()
{
	local array<float> movementEffort;
	local array<float> reinforcementGain;
	local float util;

//	`LOG_AI("Utility.ReinforceScore");

	if( mInUMovementEffort == None ) { mInUMovementEffort = new class 'H7AiUtilityMovementEffortRe'; }
    if( mInUReinforcementGain == None ) { mInUReinforcementGain = new class 'H7AiUtilityReinforcementGainReverse'; }

	mInValues.Remove(0,mInValues.Length);

	mInUMovementEffort.mFBias=mMovementEffortBias;

	mInUMovementEffort.UpdateInput();
	mInUMovementEffort.UpdateOutput();
	movementEffort = mInUMovementEffort.GetOutValues();

	mInUReinforcementGain.mFBias=mReinforcementBias;

	mInUReinforcementGain.UpdateInput();
	mInUReinforcementGain.UpdateOutput();
	reinforcementGain = mInUReinforcementGain.GetOutValues();
	if( reinforcementGain[0] > 0.0f )
	{
		reinforcementGain[0] = 1.0f;
	}
	else
	{
		reinforcementGain[0] = 0.0f;
	}

	// make sure the arrays contain the same number of out-values
	if( movementEffort.Length != 0 && movementEffort[0] > 0.0f )
	{
		util = movementEffort[0]*reinforcementGain[0];
		mInValues.AddItem( util );

		dbgString = "ReinforceScore(" $ util $ ";ME(" $ movementEffort[0] $ ");RG(" $ reinforcementGain[0] $ ")) ";

//			`LOG_AI("  >>> SCORE >>> #" @ k @ ":" @ util @ "(G" @ movementEffort[k] @ ",I" @ reinforcementGain[k] @ ")" );
	}

}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

