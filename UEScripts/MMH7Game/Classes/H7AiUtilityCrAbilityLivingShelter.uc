//=============================================================================
// H7AiUtilityCrAbilityLivingShelter
//=============================================================================
// (ACTIVE 4x4 SELF)
// The Ancient Treant can deepen his roots and become a protection of his 
// allies. Branches pop out of the ground around it and it looks like a simple 
// tree. As long as Living Shelter is active the following holds:
//
// - The Treant becomes a cover for friendly creatures. 
// - Friendly creatures can move through the Treant but not end their 
//   movement on it.
// - The area around the Treant cancels enemy creature's action, 
//   when they step into it (same as moats).
// - The Treant has +10 defense.
// - The ability button of Living Shelter is grayed out and inactive 
//   (wait and defend remain).
//
// Living Shelter ends, if the Treant gets the order to attack or move.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityCrAbilityLivingShelter extends H7AiUtilityCombiner;

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

