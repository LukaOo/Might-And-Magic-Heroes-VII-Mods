//=============================================================================
// H7AiUtilityFleeScore
//=============================================================================
// ...
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityFleeScore extends H7AiUtilityCombiner;

var protected H7AiUtilityMovementReach      mUMovementReachEnemy;
var protected H7AiUtilityFightingEffort     mUFightingEffort;
var protected H7AiUtilityMovementEffortRe   mUMovementEffortTown;
var protected H7AiUtilityMovementEffortAllied   mUMovementEffortAllied;
var protected H7AiUtilityRecall             mURecall;
var protected H7AiUtilityTownThreat         mUTownThreat;
var protected H7AiUtilityTargetCutoffRange  mUTargetCutoffRange;
var protected H7AiUtilitySiteAvailable      mUSiteAvailable;

var String dbgString;

var bool usedRecall;
var bool checkForSite;
var float mMovementEffortBias;
var float mFightingEffortBias;

/// overrides ...

function UpdateInput()
{
	local array<float>  movementReachEnemy;
	local array<float>  movementEffortTarget;
	local array<float>  fightingEffort;
	local array<float>  recall;
	local array<float>  townThreat;
	local array<float>  cutoffRange;
	local array<float>  siteAvailable;

	local float util;

//	`LOG_AI("Utility.FleeScore");

	if( mUMovementReachEnemy == None ) { mUMovementReachEnemy = new class 'H7AiUtilityMovementReach'; }
	if( mUFightingEffort == None ) { mUFightingEffort = new class 'H7AiUtilityFightingEffort'; }
	if( mUMovementEffortTown == None ) { mUMovementEffortTown = new class 'H7AiUtilityMovementEffortRe'; }
	if( mUMovementEffortAllied == None ) { mUMovementEffortAllied = new class 'H7AiUtilityMovementEffortAllied'; }
	if( mURecall == None ) { mURecall = new class 'H7AiUtilityRecall'; }
	if( mUTownThreat == None ) { mUTownThreat = new class 'H7AiUtilityTownThreat'; }
	if( mUTargetCutoffRange == None ) { mUTargetCutoffRange = new class 'H7AiUtilityTargetCutoffRange'; }
	if( mUSiteAvailable == None ) { mUSiteAvailable = new class 'H7AiUtilitySiteAvailable'; }

	mInValues.Remove(0,mInValues.Length);

	mUMovementReachEnemy.mFBias=mMovementEffortBias;
	mUMovementReachEnemy.UpdateInput();
	mUMovementReachEnemy.UpdateOutput();
	movementReachEnemy = mUMovementReachEnemy.GetOutValues();
	if(movementReachEnemy.Length==0 || (movementReachEnemy.Length>0 && movementReachEnemy[0]<=0.0f))
	{
		// we are done. enemy is not within our reach
		return;
	}

	mUFightingEffort.mFBias=mFightingEffortBias;
	mUFightingEffort.UpdateInput();
	mUFightingEffort.UpdateOutput();
	fightingEffort = mUFightingEffort.GetOutValues();
	if(fightingEffort.Length==0 || (fightingEffort.Length>0 && fightingEffort[0]>0.0f))
	{
		// we won't need to run from a weaker enemy
		return;
	}

	if(checkForSite==true)
	{
		mUTargetCutoffRange.UpdateInput();
		mUTargetCutoffRange.UpdateOutput();
		cutoffRange = mUTargetCutoffRange.GetOutValues();
		if(cutoffRange.Length>0 && cutoffRange[0]<=0.0f)
		{
			// we are already close to our safe-haven
			return;
		}

		mURecall.UpdateInput();
		mURecall.UpdateOutput();
		recall = mURecall.GetOutValues();
		// we can just recall there?
		if(recall.Length>0 && recall[0]>0.0f)
		{
			movementEffortTarget.AddItem(1.0f);
			usedRecall=true;
		}
		else
		{
			mUSiteAvailable.UpdateInput();
			mUSiteAvailable.UpdateOutput();
			siteAvailable = mUSiteAvailable.GetOutValues();
			if(siteAvailable.Length>0 && siteAvailable[0]<=0.0f)
			{
				// we can't go there. Mainly for 'Shelter'-targets that are occupied
				return;
			}
			// we can't, so we have to walk
			mUMovementEffortTown.mFBias=mMovementEffortBias;
			mUMovementEffortTown.UpdateInput();
			mUMovementEffortTown.UpdateOutput();
			movementEffortTarget = mUMovementEffortTown.GetOutValues();
			usedRecall=false;
		}

		mUTownThreat.UpdateInput();
		mUTownThreat.UpdateOutput();
		townThreat = mUTownThreat.GetOutValues();
	}
	else // if not we run for allied hero
	{
		mUMovementEffortAllied.mFBias=mMovementEffortBias;
		mUMovementEffortAllied.UpdateInput();
		mUMovementEffortAllied.UpdateOutput();
		movementEffortTarget = mUMovementEffortAllied.GetOutValues();
		usedRecall=false;
		townThreat.AddItem(0.0f);
	}


	if( movementEffortTarget.Length>0 && movementEffortTarget[0]>0.0f && townThreat.Length>0 )
	{
		util = movementReachEnemy[0] * (1.0f - fightingEffort[0]) * movementEffortTarget[0] * (1.0f - townThreat[0]);
		mInValues.AddItem(util);
		dbgString = "FleeScore(" $ util $ ";ME(" $ movementEffortTarget[0] $ "," $ mMovementEffortBias $ ");FE(" $ (1.0f-fightingEffort[0]) $ "," $ mFightingEffortBias $ ");MR(" $ movementReachEnemy[0] $ "," $ mMovementEffortBias $ ");TT(" $ (1.0f-townThreat[0]) $ ")) ";
	}
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

