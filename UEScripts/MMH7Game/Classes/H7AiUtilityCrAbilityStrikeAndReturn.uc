//=============================================================================
// H7AiUtilityCrAbilityStrikeAndReturn
//=============================================================================
// (ACTIVE RANGED)
// The creature can fly to the target, attack, get the retaliation and 
// follow-up effects and fly back to its previous position, if this position 
// is still accessible.
// The second move back to the previous position does not cost movement points.
// All aura effects end effects on tiles are triggered for both movements.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityCrAbilityStrikeAndReturn extends H7AiUtilityCombiner;

var protected H7AiUtilityCrAbilityCasualityCount    mInUCasualityCount;
var protected H7AiUtilityCrAbilityCreatureDamage    mInUCreatureDamage;
var protected H7AiUtilityHasAnyAdjacentEnemy        mInUHasAdjEnemy;
var protected H7AiUtilityCanMoveAttack              mUMoveAttack;

/// overrides ...
function UpdateInput()
{
	local array<float> hasAdjEnemy;
	local array<float> casualityCount;
	local array<float> creatureDamage;
	local array<float> moveAttack;
	local float coUtil;

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	if( mInUCasualityCount == None ) { mInUCasualityCount = new class 'H7AiUtilityCrAbilityCasualityCount'; }
	if( mInUCreatureDamage == None ) { mInUCreatureDamage = new class 'H7AiUtilityCrAbilityCreatureDamage'; }
	if( mInUHasAdjEnemy == None ) { mInUHasAdjEnemy = new class 'H7AiUtilityHasAnyAdjacentEnemy'; }
	if( mUMoveAttack ==  None ) { mUMoveAttack = new class 'H7AiUtilityCanMoveAttack'; }

	mInValues.Remove(0,mInValues.Length);

	// we only use the ability if the current position, which we will get back to after the strike, is not suppressed by enemies
	mInUHasAdjEnemy.UpdateInput();
	mInUHasAdjEnemy.UpdateOutput();
	hasAdjEnemy = mInUHasAdjEnemy.GetOutValues();

	if( hasAdjEnemy.Length>=1 && hasAdjEnemy[0]<=0.0f )
	{
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
				// we will boost the value a little to prioritize the ability over standard 'move-and-attack' commands, which deal the same amount of damage, but will
				// get the flimsy creature (harpy) in a less favorable position
				coUtil=casualityCount[0]*creatureDamage[0]*1.1f;
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				if(coUtil>0.0f)
				{
					mInValues.AddItem(coUtil);
				}
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

