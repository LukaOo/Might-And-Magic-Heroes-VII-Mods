//=============================================================================
// H7AiUtilityCongregate
//=============================================================================
// ...
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityCongregate extends H7AiUtilityCombiner;

var protected H7AiUtilityMovementEffort         mUMovementEffort;
var protected H7AiUtilityReinforcementGain      mUReinforcementGain;

var String dbgString;

var float   mMovementEffortBias;
var float   mReinforcementBias;

/// overrides ...

function UpdateInput()
{

	local array<float> movementEffort;
	local array<float> reinforcementGain;
	local float util;

//	`LOG_AI("Utility.Congregate");

	if( mUMovementEffort == None ) { mUMovementEffort = new class 'H7AiUtilityMovementEffort'; }
	if( mUReinforcementGain == None ) { mUReinforcementGain = new class 'H7AiUtilityReinforcementGain'; }

	mInValues.Remove(0,mInValues.Length);

	mUMovementEffort.mFBias=mMovementEffortBias;

	mUMovementEffort.UpdateInput();
	mUMovementEffort.UpdateOutput();
	movementEffort = mUMovementEffort.GetOutValues();

	mUReinforcementGain.mFBias=mReinforcementBias;

	mUReinforcementGain.UpdateInput();
	mUReinforcementGain.UpdateOutput();
	reinforcementGain = mUReinforcementGain.GetOutValues();
	if( reinforcementGain[0] > 0.0f )
	{
		reinforcementGain[0] = 1.0f;
	}
	else
	{
		reinforcementGain[0] = 0.0f;
	}

	// 
	if( movementEffort.Length>0 && reinforcementGain.Length>0 )
	{
		util = movementEffort[0] * reinforcementGain[0];
		mInValues.AddItem( util );

		dbgString = "CongregateScore(" $ util $ ";ME(" $ movementEffort[0] $ "," $ mMovementEffortBias $ ");RG(" $ reinforcementGain[0] $ "," $ mReinforcementBias $ ")) ";
//		`LOG_AI("  >>> SCORE >>> #" @ util @ "(ME" @ movementEffort[0] @ ",RG" @ reinforcementGain[0] @ ")" );
	}
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

