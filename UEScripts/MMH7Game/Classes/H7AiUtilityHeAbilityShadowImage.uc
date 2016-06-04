//=============================================================================
// H7AiUtilityHeAbilityShadowImage
//=============================================================================
// Instant. Summon. Summon a copy of target stack.The stack acts next 
// (after the current creature)
// In all subsequent turns the copy acts with its normal initiative 
// (after its original).
// All active and passive abilities are copied, buffs and debuffs are not.
// The summoned stack appears as close to the original stack as possible, if 
// more than one spot has the same distance, one is chosen randomly. If there 
// is no available spot, the spell ends without effect.
// When the summoned stack receives any damage it is destroyed completely.
// If the shadow image stack is destroyed neither the morale bonus for killing 
// a stack nor the malus for lost stack is triggered.
// The spell can be cast multiple times on the same target, a new summoned 
// stack is created for each cast. The spell can also be cast on another summoned stack.
// The stack size of the summoned stack is (3*MAGIC) % of the stack size the 
// spell was cast on, rounded down.
//    Unskilled: 1 * Magic
//    Novice: 2 * Magic
//    Expert: 3 * Magic
//    Master: 5 * Magic
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityShadowImage extends H7AiUtilityCombiner;

/// overrides ...
function UpdateInput()
{
//	`LOG_AI("Utility.HeAbilityShadowImage");

	mInValues.Remove(0,mInValues.Length);
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

