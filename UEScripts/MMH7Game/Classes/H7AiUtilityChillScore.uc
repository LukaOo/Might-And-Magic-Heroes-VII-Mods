//=============================================================================
// H7AiUtilityChillScore
//=============================================================================
// TODO: Improve town distance value handling
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityChillScore extends H7AiUtilityCombiner;

var protected H7AiUtilityMovementEffortCell     mInUMovementEffortTown;
var protected H7AiUtilityRecall                 mInURecall;

var bool usedRecall;

/// overrides ...

function UpdateInput()
{

	local array<float>  movementEffortTown;
	local array<float>  recall;
	local float util;

//	`LOG_AI("Utility.ChillScore");

	usedRecall=false;

	if( mInUMovementEffortTown == None ) { mInUMovementEffortTown = new class 'H7AiUtilityMovementEffortCell'; }
	if( mInURecall == None ) { mInURecall = new class 'H7AiUtilityRecall'; }

	mInValues.Remove(0,mInValues.Length);

	mInUMovementEffortTown.mFBias=0.5f;

	mInUMovementEffortTown.UpdateInput();
	mInUMovementEffortTown.UpdateOutput();
	movementEffortTown = mInUMovementEffortTown.GetOutValues();
	
	mInURecall.UpdateInput();
	mInURecall.UpdateOutput();
	recall = mInURecall.GetOutValues();

	// 
	if( movementEffortTown.Length>0 && recall.Length>0 )
	{
		// if we can recall to the town we set distance to town to zero (movementEffortTown=1)
		if( recall[0] > 0.0f )
		{
			movementEffortTown[0]=0.1f;
			usedRecall=true;
		}
		if( movementEffortTown[0] >= 0.1f )
		{
			util = ((1.1f-movementEffortTown[0]) / 5.0f);
		}
		else
		{
			util = 0.0f;
		}
		mInValues.AddItem( util );

//		`LOG_AI("  >>> SCORE >>> #" @ util @ "(,MET" @ movementEffortTown[0] @ ",RC" @ recall[0] @ ")" );
	}
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

