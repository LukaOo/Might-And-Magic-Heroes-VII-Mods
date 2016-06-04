//=============================================================================
// H7AiUtilityHeAbilityTimeStasis
//=============================================================================
// Buff/Debuff Target stack loses its turn and is treated as if not present 
// until the beginning of the next combat round: It cannot be targeted by any 
// attack, spell or ability and it isn't affected by area effects either. Buff 
// and debuff duration effects do not trigger while this buff is active.The 
// stack does not receive any damage. Auras of the stack do not function.
// Time Stasis can be dispelled by dispel magic, purge and cleansing light, 
// these spells are the only ones that can be cast on the stack.
// If one of theses spells ist cast on the target only time stasis is removed, 
// no other effect present on the creature gets removed.
// The time stasis buff ends at the beginning of the next combat round.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityTimeStasis extends H7AiUtilityCombiner;

var protected H7AiUtilitySpellTargetCheck   mUSpellTargetCheck;
var protected H7AiUtilityCreatureStrength   mUCreatureStrength;

/// overrides ...
function UpdateInput()
{
	local array<float> uSpellCheck;
	local array<float> uCreatureStrength;

	if(mUSpellTargetCheck==None) { mUSpellTargetCheck = new class'H7AiUtilitySpellTargetCheck'; }
	if(mUCreatureStrength==None) { mUCreatureStrength = new class'H7AiUtilityCreatureStrength'; }

	mInValues.Remove(0,mInValues.Length);

	mUSpellTargetCheck.UpdateInput();
	mUSpellTargetCheck.UpdateOutput();
	uSpellCheck = mUSpellTargetCheck.GetOutValues();
	if(uSpellCheck.Length>0 && uSpellCheck[0]>0.0f)
	{
		mUCreatureStrength.UpdateInput();
		mUCreatureStrength.UpdateOutput();
		uCreatureStrength = mUCreatureStrength.GetOutValues();
		if(uCreatureStrength.Length>0 && uCreatureStrength[0]>0.0f)
		{   
			mInValues.AddItem(uSpellCheck[0]*uCreatureStrength[0]);
		}
	}
}


function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

