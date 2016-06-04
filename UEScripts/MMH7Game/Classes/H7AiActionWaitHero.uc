//=============================================================================
// H7AiActionWaitHero
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionWaitHero extends H7AiActionBase;

var protected H7AiUtilityHasGreaterDamage mUtility1;

function String DebugName()
{
	return "Wait";
}

function Setup()
{
	mUtility1 = new class'H7AiUtilityHasGreaterDamage';
}

/// override function(s)

function RunScores( H7AiCombatSensors sensors, H7Unit currentUnit, out array<AiActionScore> scores )
{
	local int               k;
	local AiActionScore     score;
	local array<AiActionScore>      tmpScores;
	local H7AiSensorInputConst    sic;
	local array<float>      utOut;
	local float             W;

	sic = sensors.GetSensorIConsts();

	score.action = Self;
	score.score = 0.0f;
	
	// for all friendly? creature stacks ...
	for( k = 0; k < sic.GetCreatureStackNum(); k++ )
	{
		score.params = new () class'H7AiActionParam';
		score.params.Clear();
		score.params.SetUnit( APID_1, sic.GetCreatureStack( k ) );

		sic.SetTargetCreatureStack(sic.GetCreatureStack(k));

		mUtility1.UpdateInput();
		mUtility1.UpdateOutput();
		utOut = mUtility1.GetOutValues();
		// this util has only one result ...
		if( utOut.Length >= 1 )
		{
			W = utOut[0];
		}
		utOut.Remove( 0, utOut.Length );

		score.score = (1-W)*0.5;
		tmpScores.AddItem( score );
	}
	foreach tmpScores( score )
	{
		if( score.score == 1.0f )
		{
			scores.AddItem( score );
			break;
		}
	}
}

function bool PerformAction( H7Unit unit, AiActionScore score )
{
	if( unit != None )
	{
		unit.Wait();
		return true;
	}
	return false;
}
