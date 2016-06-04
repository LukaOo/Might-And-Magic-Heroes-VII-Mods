//=============================================================================
// H7AiUtilityGarrisonScore
//=============================================================================
// score garrison when
// * town is threatened
// * not farther than 3 turns or have instant recall to that town
// * hero can be put in garrison
// ** not occupied by a hero and can be merged with existing troops
// ** occupied with a weaker hero and visiting army slot is empty
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityGarrisonScore extends H7AiUtilityCombiner;

var H7AiUtilityMovementEffortRe    mUMovementEffortSite;
var H7AiUtilityTownThreat          mUTownThreat;
var H7AiUtilityTownDefense         mUTownDefense;

var String dbgString;

var float   mMovementEffortBias;

/// overrides ...

function UpdateInput()
{

	local array<float> movementEffort;
	local array<float> townDefense;
	local array<float> townThreat;
	local float util;

//	`LOG_AI("Utility.GarrisonScore");

	if( mUMovementEffortSite == None ) { mUMovementEffortSite = new class 'H7AiUtilityMovementEffortRe'; }
	if( mUTownThreat == None ) { mUTownThreat = new class 'H7AiUtilityTownThreat'; }
	if( mUTownDefense == None ) { mUTownDefense = new class 'H7AiUtilityTownDefense'; }

	mInValues.Remove(0,mInValues.Length);

	mUTownThreat.UpdateInput();
	mUTownThreat.UpdateOutput();
	townThreat = mUTownThreat.GetOutValues();

	if(townThreat.Length>0 && townThreat[0]>0.0f)
	{
		mUMovementEffortSite.mFBias=mMovementEffortBias;
		mUMovementEffortSite.UpdateInput();
		mUMovementEffortSite.UpdateOutput();
		movementEffort = mUMovementEffortSite.GetOutValues();

		mUTownDefense.UpdateInput();
		mUTownDefense.UpdateOutput();
		townDefense = mUTownDefense.GetOutValues();

		if(movementEffort.Length>0 && movementEffort[0]>0.0f && townDefense.Length>0 && townDefense[0]>0.0f)
		{
			util = movementEffort[0] * townThreat[0] * townDefense[0];
			mInValues.AddItem(util);

			dbgString = "GarrisonScore(" $ util $ "; ME(" $ movementEffort[0] $ "); TT(" $ townThreat[0] $ "); TD(" $ townDefense[0] $ ")) ";
		}   
	}
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

