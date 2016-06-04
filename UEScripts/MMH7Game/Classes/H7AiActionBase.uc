//=============================================================================
// H7AiActionBase
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionBase extends Object
	dependson(H7StructsAndEnumsNative);

var EAdvActionID mABID;

/// override function(s)

function RunScores( H7AiCombatSensors sensors, H7Unit currentUnit, out array<AiActionScore> scores )
{

}

function RunScoresAdv( H7AiAdventureSensors sensors, H7Unit currentUnit, out array<AiActionScore> scores, optional H7AdventureConfiguration cfg )
{

}

function RunScoresTown( H7AiAdventureSensors sensors, H7AreaOfControlSiteLord currentControlSite, out array<AiActionScore> scores, optional H7AdventureConfiguration cfg )
{

}

function EAdvActionID GetAdvActionID()
{
	return mABID;
}

function bool PerformAction( H7Unit unit, AiActionScore score )
{
	return false;
}

function bool PerformActionTown( H7AreaOfControlSiteLord site, AiActionScore score )
{
	return false;
}

function String DebugName()
{
	return "Action";
}
