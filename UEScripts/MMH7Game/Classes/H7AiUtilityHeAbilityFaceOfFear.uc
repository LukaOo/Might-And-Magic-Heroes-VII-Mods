//=============================================================================
// H7AiUtilityHeAbilityFaceOfFear
//=============================================================================
// Buff. Positive. Target friendly creature stack gets a buff which lasts for 
// the creature's next 3 turns.
// Buff effect: Enemy stacks that get attacked by this creature move away two 
// tiles in the opposite direction in a straight line of as far as possible 
// after being attacked. Diagonally the stack only moves 1 tile.
// The stack moves as far as it can until blocked by another stack, an 
// obstacle or the end of the grid.
// The attacked creature's facing turns aways from the attacking creature. 
// Even if the creature did not move a single tile.  
// The attack is not retaliated against.
// The attacked creature gets a debuff for 3 turns
// Debuff effect: Reduce morale of the creature
//    Unskilled: 1 * Magic +10
//    Novice: 1.3 * Magic + 15
//    Expert: 1.7 * Magic + 25
//    Master: 2.5 * Magic + 40
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityFaceOfFear extends H7AiUtilityCombiner;

var protected H7AiUtilitySpellTargetCheck   mUSpellTargetCheck;
var protected H7AiUtilityCreatureStrength   mUCreatureStrength;
var protected H7AiUtilityCreatureAdjacentToEnemy   mUCreatureAdjEnemy;

/// overrides ...
function UpdateInput()
{
	local array<float> uSpellCheck;
	local array<float> uCreatureStrength;
	local array<float> uCreatureAdjEnemy;

	if(mUSpellTargetCheck==None) { mUSpellTargetCheck = new class'H7AiUtilitySpellTargetCheck'; }
	if(mUCreatureStrength==None) { mUCreatureStrength = new class'H7AiUtilityCreatureStrength'; }
	if(mUCreatureAdjEnemy==None) { mUCreatureAdjEnemy = new class'H7AiUtilityCreatureAdjacentToEnemy'; }

	mInValues.Remove(0,mInValues.Length);

	mUCreatureAdjEnemy.UpdateInput();
	mUCreatureAdjEnemy.UpdateOutput();
	uCreatureAdjEnemy = mUCreatureAdjEnemy.GetOutValues();
	if(uCreatureAdjEnemy.Length>0 && uCreatureAdjEnemy[0]<=0.0f) // target is adjacent to an enemy creature
	{
		return;
	}

	mUSpellTargetCheck.UpdateInput();
	mUSpellTargetCheck.UpdateOutput();
	uSpellCheck = mUSpellTargetCheck.GetOutValues();
	if(uSpellCheck.Length>0 && uSpellCheck[0]>0.0f)
	{
		mUCreatureStrength.UpdateInput();
		mUCreatureStrength.UpdateOutput();
		uCreatureStrength = mUCreatureStrength.GetOutValues();
		if(uCreatureStrength.Length>0 && uCreatureStrength[0]>0.0f)
		{   
			mInValues.AddItem(uSpellCheck[0]*uCreatureStrength[0]);
		}
	}
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

