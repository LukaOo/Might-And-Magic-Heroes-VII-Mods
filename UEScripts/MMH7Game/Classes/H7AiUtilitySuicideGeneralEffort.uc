//=============================================================================
// H7AiUtilitySuicideGeneralEffort
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilitySuicideGeneralEffort extends H7AiUtilityCombiner;

var H7AiUtilityMovementEffort     mInUMovementEffortArmy;
var H7AiUtilityMovementEffortRe   mInUMovementEffortSite;
var H7AiUtilityMovementEffortCell mInUMovementEffortCell;
var H7AiUtilitySuicideFightingEffort     mInUFightingEffort;
var H7AiUtilityAdvTargetThreat    mInUTargetThreat;

var String dbgString;

var float   mMovementEffortBias;
var float   mFightingEffortBias;

/// overrides ...

function UpdateInput()
{
	local array<float> movementEffort;
	local array<float> fightingEffort;
	local array<float> targetThreat;
	local float util;
	local bool passed;

	if( mInUMovementEffortArmy == None ) { mInUMovementEffortArmy = new class 'H7AiUtilityMovementEffort'; }
	if( mInUMovementEffortSite == None ) { mInUMovementEffortSite = new class 'H7AiUtilityMovementEffortRe'; }
	if( mInUMovementEffortCell == None ) { mInUMovementEffortCell = new class 'H7AiUtilityMovementEffortCell'; }
    if( mInUFightingEffort == None ) { mInUFightingEffort = new class 'H7AiUtilitySuicideFightingEffort'; }
	if( mInUTargetThreat == None ) {  mInUTargetThreat = new class 'H7AiUtilityAdvTargetThreat'; }

//	`LOG_AI("Utility.SuicideGeneralEffort");
	passed=false;
	mInValues.Remove(0,mInValues.Length);

	if(passed==false)
	{
		mInUMovementEffortArmy.mFBias=mMovementEffortBias;
		mInUMovementEffortArmy.UpdateInput();
		mInUMovementEffortArmy.UpdateOutput();
		movementEffort = mInUMovementEffortArmy.GetOutValues();
		if( movementEffort.Length>0 && movementEffort[0]>0.0f )
		{
			mInUFightingEffort.mFBias=mFightingEffortBias;
			mInUFightingEffort.UpdateInput();
			mInUFightingEffort.UpdateOutput();
			fightingEffort = mInUFightingEffort.GetOutValues();
			passed=true;
		}
	}
	
	if(passed==false)
	{
		mInUMovementEffortSite.mFBias=mMovementEffortBias;
		mInUMovementEffortSite.UpdateInput();
		mInUMovementEffortSite.UpdateOutput();
		movementEffort = mInUMovementEffortSite.GetOutValues();
		if( movementEffort.Length>0 && movementEffort[0]>0.0f )
		{
			fightingEffort.AddItem(1.0f);
			passed=true;
		}
	}

	if(passed==false)
	{
		mInUMovementEffortCell.mFBias=mMovementEffortBias;
		mInUMovementEffortCell.UpdateInput();
		mInUMovementEffortCell.UpdateOutput();
		movementEffort = mInUMovementEffortCell.GetOutValues();
		if( movementEffort.Length>0 && movementEffort[0]>0.0f )
		{
			fightingEffort.AddItem(1.0f);
			passed=true;
		}
	}
	
	mInUTargetThreat.mFBias=0.5f;
	mInUTargetThreat.UpdateInput();
	mInUTargetThreat.UpdateOutput();
	targetThreat = mInUTargetThreat.GetOutValues();

	// make sure the arrays contain the same number of out-values
	
	if(passed==true && movementEffort.Length>0 && fightingEffort.Length>0 && targetThreat.Length>0)
	{
		util = movementEffort[0] * fightingEffort[0] * (1.0f - targetThreat[0]);
		mInValues.AddItem(util);
		dbgString = "SuicideGeneralEffort(" $ util $ ";ME(" $ movementEffort[0] $ "," $ mMovementEffortBias $ ");FE(" $ fightingEffort[0] $ "," $ mFightingEffortBias $  ");TT(" $ (1.0f-targetThreat[0]) $ ")) ";
	}
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

