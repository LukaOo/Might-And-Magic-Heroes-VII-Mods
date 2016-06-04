//=============================================================================
// H7AiUtilityCrAbilitySoulReaver
//=============================================================================
// (ACTIVE MELEE)
// After selecting this ability in combat the player can select a target enemy 
// creature in range which is then attacked by the Spectral Dragon. Per each 
// creature killed by the Spectral Dragon 1 mana point is taken from the enemy 
// hero and granted to the own, capped by his magic value.
// This ability cannot drain more mana than the enemy hero has left.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityCrAbilitySoulReaver extends H7AiUtilityCombiner;

var protected H7AiUtilityCrAbilityCasualityCount    mInUCasualityCount;
var protected H7AiUtilityCrAbilityCreatureDamage    mInUCreatureDamage;
var protected H7AiUtilityCanMoveAttack              mUMoveAttack;

/// overrides ...
function UpdateInput()
{
	local array<float> casualityCount;
	local array<float> creatureDamage;
	local array<float> moveAttack;
	local float coUtil;

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	if( mInUCasualityCount == None ) { mInUCasualityCount = new class 'H7AiUtilityCrAbilityCasualityCount'; }
	if( mInUCreatureDamage == None ) { mInUCreatureDamage = new class 'H7AiUtilityCrAbilityCreatureDamage'; }
	if( mUMoveAttack ==  None ) { mUMoveAttack = new class 'H7AiUtilityCanMoveAttack'; }

	mInValues.Remove(0,mInValues.Length);

	mUMoveAttack.UpdateInput();
	mUMoveAttack.UpdateOutput();
	moveAttack = mUMoveAttack.GetOutValues();
	if(moveAttack.Length>0 && moveAttack[0]>0.0f)
	{
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
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

