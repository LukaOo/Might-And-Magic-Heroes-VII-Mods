//=============================================================================
// H7AiUtilityCrAbilityMagicAbsorption
//=============================================================================
// (PASSIVE)
// Spell damage received by the stack is added to the next attack or retaliation.
// The damage is added as a flat prime damage bonus as an additonal strike on 
// attack. That damage is not modified by normal attack modifiers 
// (attack, defense, flanking, luck, cover, etc.)
//
// The damage bonus is applied only once for the next attack.
//
// If this ability is triggered more than once the damage bonus should stack 
// up to the cap.
//
// The damage bonus is capped at "creature max damage" * "current stack size".
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityCrAbilityMagicAbsorption extends H7AiUtilityCombiner;

/// overrides ...
function UpdateInput()
{
	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	mInValues.Remove(0,mInValues.Length);
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

