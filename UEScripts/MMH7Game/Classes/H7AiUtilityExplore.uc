//=============================================================================
// H7AiUtilityExplore
//=============================================================================
// ...
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityExplore extends H7AiUtilityCombiner;

var protected H7AiUtilityAttackTargetScore          mUAttackTarget;

var float   mMovementEffortBias;
var float   mFightingEffortBias;

/// overrides ...

function UpdateInput()
{

	local array<float>      utAttackTarget;
	local float util;

//	`LOG_AI("Utility.Explore");

	if( mUAttackTarget == None ) { mUAttackTarget = new class 'H7AiUtilityAttackTargetScore'; }

	mUAttackTarget.mMovementEffortBias=mMovementEffortBias;
	mUAttackTarget.mFightingEffortBias=mFightingEffortBias;

	mInValues.Remove(0,mInValues.Length);

	mUAttackTarget.UpdateInput();
	mUAttackTarget.UpdateOutput();
	utAttackTarget = mUAttackTarget.GetOutValues();

	// 
	if( utAttackTarget.Length>0 )
	{
		util = utAttackTarget[0];
		mInValues.AddItem( util );
	}
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

