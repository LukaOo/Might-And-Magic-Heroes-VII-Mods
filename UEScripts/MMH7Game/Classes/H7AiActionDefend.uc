//=============================================================================
// H7AiActionDefend
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionDefend extends H7AiActionBase;

function String DebugName()
{
	return "Defend";
}


function Setup()
{
}

/// override function(s)

function RunScores( H7AiCombatSensors sensors, H7Unit currentUnit, out array<AiActionScore> scores )
{
	local AiActionScore score;

	score.action = Self;
	score.params = new () class'H7AiActionParam';
	score.params.Clear();
	score.score = 0.001f;
	scores.AddItem(score);
}

function bool PerformAction( H7Unit unit, AiActionScore score )
{
	if( unit != None )
	{
		unit.Defend();
		return true;
	}
	return false;
}
