//=============================================================================
// H7AiUtilityHeAbilityEarthquake
//=============================================================================
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityEarthquake extends H7AiUtilityCombiner;

var protected H7AiUtilitySpellAreaDamage  mUSpellDamage;

function H7CombatMapCell GetOptimalEarthquakeTargetCell(H7CombatHero hero)
{
	local H7CombatMapGridController gridController;
	if(hero==None) return None;
	gridController = class'H7CombatMapGridController'.static.GetInstance();
	return gridController.GetCombatGrid().GetCellByPos(3,3);
}

/// overrides ...
function UpdateInput()
{
	local array<float>              uDamage;

//	`LOG_AI("Utility.HeAbilityEarthquake");

	if(mUSpellDamage==None) { mUSpellDamage = new class'H7AiUtilitySpellAreaDamage'; }

	mInValues.Remove(0,mInValues.Length);

	mUSpellDamage.mFBias=0.5f;
	mUSpellDamage.UpdateInput();
	mUSpellDamage.UpdateOutput();
	uDamage = mUSpellDamage.GetOutValues();

	if(uDamage.Length>0 && uDamage[0]>0.0f)
	{
		mInValues.AddItem(uDamage[0]);
	}
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

