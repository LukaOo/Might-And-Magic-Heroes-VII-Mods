//=============================================================================
// H7AiUtilityCrAbilityBreathOfLight
//=============================================================================
// (MELEE ATTACK)
// The dragon's attack is a ray of pure light that does not lose power with 
// space. The affected area  is two tiles wide without length limitation, based 
// on the facing of the creature
// The affected area is similar to the piercing shot, just two tiles wide.
// Only enemy creatures are attacked.
// Only the targeted creature can retaliate.
// On a critical strike, The targets of the breath will also get the "blinded" 
// condition for the next turn.
// Blinded: The creature can't act and retaliate until the end of its next turn.
// Automatically triggered actions, which are not triggered because of Blinded 
// are listed here "Creature can't act".
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityCrAbilityBreathOfLight extends H7AiUtilityCombiner;

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

