//=============================================================================
// H7AiUtilityCrAbilitySolderingHands
//=============================================================================
// (ACTIVE)
// Cabeiri can repair constructs. The health points regenerated are equal to 1 
// for 10 cabeiri, but the result cannot exceed the target construct's maximum 
// health.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityCrAbilitySolderingHands extends H7AiUtilityCombiner;

var protected H7AiUtilityCrAbilityTargetCheck   mInUTargetCheck;
var protected H7AiUtilityHealingPercentage      mInUHealingPercentage;
var protected H7AiUtilityStackReachesTileIn1Turn    mInUTurnValue;

/// overrides ...
function UpdateInput()
{
	local array<float> targetCheck;
	local array<float> healingPercentage;
	local array<float> uTurnValue;
	local float coUtil;

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	if( mInUTargetCheck == None ) { mInUTargetCheck = new class 'H7AiUtilityCrAbilityTargetCheck'; }
	if( mInUHealingPercentage == None ) { mInUHealingPercentage = new class 'H7AiUtilityHealingPercentage'; }
	if( mInUTurnValue == None ) { mInUTurnValue = new class'H7AiUtilityStackReachesTileIn1Turn'; }

	mInValues.Remove(0,mInValues.Length);

	// if we can't reach the cell position in the first place than we skip the rest of the evaluation
	mInUTurnValue.UpdateInput();
	mInUTurnValue.UpdateOutput();
	uTurnValue = mInUTurnValue.GetOutValues();
	if( uTurnValue.Length>=1 && uTurnValue[0]>0.0f )
	{
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
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

