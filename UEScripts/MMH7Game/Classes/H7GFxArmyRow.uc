//=============================================================================
// H7GFxArmyRow
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxArmyRow extends H7GFxUIContainer;

function Update(H7AdventureArmy army,optional bool costMode,optional H7TeleportCosts mergeCost)
{	
	SetObject("mData", CreateArmyObject(army,false,,costMode,mergeCost));
	ActionscriptVoid("Update");
}

function UpdateFromStacks(array<H7BaseCreatureStack> stacks)
{
	SetObject("mData", CreateArmyObjectFromStacks(stacks));
	ActionscriptVoid("Update");
}

function TransferResult(bool success,bool isVisitorArmy,int i)
{
	;
	ActionScriptVoid("TransferResult");
}

function StackDismissed()
{
	ActionscriptVoid("StackDismissed");
}

function AddLockIconToUnitSlots(array<int> lockedPosses)
{
	ActionScriptVoid("AddLockIconToUnitSlots");
}

function HighlightUnitSlotsByCreatureName(string creatureName)
{
	ActionScriptVoid("HighlightUnitSlotsByCreatureName");
}
