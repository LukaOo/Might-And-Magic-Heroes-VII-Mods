//=============================================================================
// H7AiActionWaitCreature
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionWaitCreature extends H7AiActionBase;

var protected H7AiUtilityGoodTimeToWait mUtility1;

function String DebugName()
{
	return "Wait";
}


function Setup()
{
	mUtility1 = new class'H7AiUtilityGoodTimeToWait';
}


/// override function(s)

function RunScores( H7AiCombatSensors sensors, H7Unit currentUnit, out array<AiActionScore> scores )
{
	local AiActionScore     score;
	//local H7AiSensorInputConst    sic;
	local array<float>      utOut;
	local float             W;

	//sic = sensors.GetSensorIConsts();

	score.action = Self;
	score.score = 0.0f;

	if(!currentUnit.GetAbilityManager().GetAbility( currentUnit.GetWaitAbility() ).CanCast())
	{
		return;
	}
	
	score.params = new () class'H7AiActionParam';
	score.params.Clear();

	mUtility1.UpdateInput();
	mUtility1.UpdateOutput();
	utOut = mUtility1.GetOutValues();
	// this util has only one result ...
	if( utOut.Length >= 1 )
	{
		W = utOut[0];
	}
	utOut.Remove( 0, utOut.Length );

	score.score = W; //(1-W)*0.5;
	if( score.score == 1.0f )
	{
		scores.AddItem( score );
	}
}

function bool PerformAction( H7Unit unit, AiActionScore score )
{
	if(unit!=None)
	{
		unit.Wait();
		return true;
	}
	return false;
}
