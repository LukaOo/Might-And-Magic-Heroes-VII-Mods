//=============================================================================
// H7AiUtilityCrAbilityResurrection
//=============================================================================
// (ACTIVE)
// Casts the resurrection spell, once per battle. This spell resurrects and 
// heals creatures of the target stack for 50 health points per creature in the 
// stack casting this ability (current stack size). First heal the top creature 
// until it's full or the health points are consumed. Then resurrect creatures 
// with the remaining health points. The new top creature might not end up with 
// full health. The stack size cannot exceed the original stack size at start 
// of combat.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityCrAbilityResurrection extends H7AiUtilityCombiner;

var protected H7AiUtilityCrAbilityTargetCheck   mInUTargetCheck;
var protected H7AiUtilityHealingPercentage      mInUHealingPercentage;

/// overrides ...
function UpdateInput()
{
	local array<float> targetCheck;
	local array<float> healingPercentage;
	local float coUtil;

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	if( mInUTargetCheck == None ) { mInUTargetCheck = new class 'H7AiUtilityCrAbilityTargetCheck'; }
	if( mInUHealingPercentage == None ) { mInUHealingPercentage = new class 'H7AiUtilityHealingPercentage'; }

	mInValues.Remove(0,mInValues.Length);

	mInUTargetCheck.UpdateInput();
	mInUTargetCheck.UpdateOutput();
	targetCheck = mInUTargetCheck.GetOutValues();

	mInUHealingPercentage.UpdateInput();
	mInUHealingPercentage.UpdateOutput();
	healingPercentage = mInUHealingPercentage.GetOutValues();

	if(targetCheck.Length>=1 && healingPercentage.Length>=1)
	{
		coUtil=targetCheck[0]*healingPercentage[0];
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		if(coUtil>0.0f)
		{
			mInValues.AddItem(coUtil);
		}
	}
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

