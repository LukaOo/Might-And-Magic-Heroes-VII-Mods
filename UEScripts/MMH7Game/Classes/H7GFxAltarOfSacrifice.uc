//=============================================================================
// H7GFxAlterOfSacrifice
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxAltarOfSacrifice extends H7GFxTownPopup;

function Update(H7Creature unit)
{
	local GFxObject unitObj;

	unitObj = CreateUnitObjectAdvanced(unit);

	SetObject("mUnitToGain", unitObj);
	
	SetString("mGoldIconPath", class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetResourceSet().GetCurrencyResourceType().GetIconPath());
	ActionScriptVoid("Update");
}

function UpdateWithUnitToSacrifice(H7BaseCreatureStack draggedStack, int gainAmount, int cost)
{
	local GFxObject unitObj, data;
	
	data = CreateObject("Object");

	unitObj = CreateUnitObjectAdvanced(draggedStack.GetStackType());
	unitObj.SetInt("StackSize", draggedStack.GetStackSize());
	data.SetObject("UnitToSacrifice", unitObj);
	data.SetInt("AmountToGain", gainAmount);
	data.SetInt("Cost", cost);
	data.SetBool("CanSpend", cost <= class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetResourceSet().GetCurrency() ? true : false);

	SetObject("mSacrificeData", data);
	ActionScriptVoid("UpdateWithUnitToSacrifice");
}

function SetCreatureAmountToGain(int stackSize)
{
	SetInt("mCreatureAmountToGain", stackSize);
	ActionScriptVoid("SetCreatureAmountToGain");
}
