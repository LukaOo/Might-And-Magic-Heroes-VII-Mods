//=============================================================================
// H7AiUtilityHeAbilityGustOfWind
//=============================================================================
// Effect 1: Instant. Pushes the target creature away in any straight line. 
// Diagonal directions will only move the stack the amount in brackets.
//    Unskilled: 1 (0)
//    Novice: 2 (1)
//    Expert: 3 (2)
//    Master: 4 (2)
// The direction can be defined by the player similar to the direction of a 
// melee attack. Reference for targeting: Creature Actions
// If the path is blocked, the stack is pushed as far as possible. (until stopped 
// by an obstacle, another stack or the border of the grid)
// The relocated creature keeps its current facing.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityGustOfWind extends H7AiUtilityCombiner;

/// overrides ...
function UpdateInput()
{
//	`LOG_AI("Utility.HeAbilityGustOfWind");

	mInValues.Remove(0,mInValues.Length);
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

