//=============================================================================
// H7GFxWarfareUnitRow
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxWarfareUnitRow extends H7GFxUIContainer;

function Update(H7AdventureArmy army)
{
	SetObject("mData", CreateWarefareUnitsObject(army));
	ActionscriptVoid("Update");
}

function AddLockIconToUnitSlots()
{
	ActionScriptVoid("AddLockIconToUnitSlots");
}
