//=============================================================================
// H7AiUtilityTownDistanceCombined
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityTownDistanceCombined extends H7AiUtilityCombiner;

var H7AiUtilityTownDistance     mInUTownDist;
var H7AiUtilityTownDistanceMax  mInUTownDistMax;

/// overrides ...

function UpdateInput()
{
	//local array<float> townDist;
	//local array<float> townDistMax;
	//local float tdmax;
	//local int k;

	//if( mInUTownDist == None ) { mInUTownDist = new class 'H7AiUtilityTownDistance'; }
 //   if( mInUTownDistMax == None ) { mInUTownDistMax = new class 'H7AiUtilityTownDistanceMax'; }

//	`LOG_AI("Utility.TownDistanceCombined");

	mInValues.Remove(0,mInValues.Length);

	//mInUTownDist.UpdateInput();
	//mInUTownDist.UpdateOutput();
	//townDist = mInUTownDist.GetOutValues();

	//mInUTownDistMax.UpdateInput();
	//mInUTownDistMax.UpdateOutput();
	//townDistMax = mInUTownDistMax.GetOutValues();

	//if( townDist.Length <= 0 || townDistMax.Length <= 0 ) return;

	// we need to get the highest max to scale result with it
	//tdmax=1.0f;
	//for(k=0;k<townDistMax.Length;k++)
	//{
	//	if(townDistMax[k]>tdmax) tdmax=townDistMax[k];
	//}

	// scale the current min with our max of all min :P and store result
	//mInValues.AddItem(townDist[0] / tdmax);

	mInValues.AddItem(1.0f);
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

