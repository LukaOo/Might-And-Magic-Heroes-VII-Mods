//=============================================================================
// H7AiUtilityTargetScore
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityTargetScore extends H7AiUtilityCombiner;

var H7AiUtilityMovementEffortRe     mInUMovementEffort;
var H7AiUtilityTargetInterest       mInUTargetInterest;

var String dbgString;

/// overrides ...

function UpdateInput()
{
	local array<float> movementEffort;
	local array<float> targetInterest;
	local float util;

//	`LOG_AI("Utility.TargetScore");

	if( mInUMovementEffort == None ) { mInUMovementEffort = new class 'H7AiUtilityMovementEffortRe'; }
    if( mInUTargetInterest == None ) { mInUTargetInterest = new class 'H7AiUtilityTargetInterest'; }

	mInValues.Remove(0,mInValues.Length);

	mInUMovementEffort.mFBias=0.5f;

	mInUMovementEffort.UpdateInput();
	mInUMovementEffort.UpdateOutput();
	movementEffort = mInUMovementEffort.GetOutValues();

	mInUTargetInterest.UpdateInput();
	mInUTargetInterest.UpdateOutput();
	targetInterest = mInUTargetInterest.GetOutValues();

	// make sure the arrays contain the same number of out-values
	if( movementEffort.Length != 0 && movementEffort.Length == targetInterest.Length )
	{
		util = movementEffort[0]*targetInterest[0];
		mInValues.AddItem(util);

		dbgString = "TargetScore(" $ util $ ";ME(" $ movementEffort[0] $ ");TI(" $ targetInterest[0] $ ")) ";

//		`LOG_AI("  >>> SCORE >>> " @ util @ "(G" @ movementEffort[0] @ ",I" @ targetInterest[0] @ ")" );
	}
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

