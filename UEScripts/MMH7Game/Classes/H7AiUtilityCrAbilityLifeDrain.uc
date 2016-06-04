//=============================================================================
// H7AiUtilityCrAbilityLifeDrain
//=============================================================================
// (MELEE ATTACK)
// 20% of the damage dealt to living targets (no construct or undead) restores 
// the creature?s health and resurrects dead creatures in the stack. The 
// resurrection of fallen creatures cannot exceed the original stack size.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityCrAbilityLifeDrain extends H7AiUtilityCombiner;

var protected H7AiUtilityCrAbilityCasualityCount    mInUCasualityCount;
var protected H7AiUtilityCrAbilityCreatureDamage    mInUCreatureDamage;

/// overrides ...
function UpdateInput()
{
	local array<float> casualityCount;
	local array<float> creatureDamage;
	local float coUtil;

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	if( mInUCasualityCount == None ) { mInUCasualityCount = new class 'H7AiUtilityCrAbilityCasualityCount'; }
	if( mInUCreatureDamage == None ) { mInUCreatureDamage = new class 'H7AiUtilityCrAbilityCreatureDamage'; }

	mInValues.Remove(0,mInValues.Length);

	mInUCasualityCount.UpdateInput();
	mInUCasualityCount.UpdateOutput();
	casualityCount = mInUCasualityCount.GetOutValues();

	mInUCreatureDamage.UpdateInput();
	mInUCreatureDamage.UpdateOutput();
	creatureDamage = mInUCreatureDamage.GetOutValues();

	if(casualityCount.Length>=1 && creatureDamage.Length>=1)
	{
		coUtil=casualityCount[0]*creatureDamage[0];
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

