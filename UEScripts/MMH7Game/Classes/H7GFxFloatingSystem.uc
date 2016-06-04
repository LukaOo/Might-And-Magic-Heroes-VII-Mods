//=============================================================================
// H7GfxFloatingSystem
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxFloatingSystem extends H7GFxUIContainer;

function int CreateFloatingCombatText(EFCTType type, string iconPath, String message,int x,int y, int r, int g, int b)
{
	local int i;
	i = ActionScriptInt("CreateFloatingCombatText");
	return i;
}

function UpdateFloat(int id,int x,int y,int alpha)
{
	ActionScriptVoid("UpdateFloat");
}

function KillFloat(int id)
{
	ActionScriptVoid("KillFloat");
}

function H7GFxFCTField GetFloatText(int id)
{
	local H7GFxFCTField f;
	f = H7GFxFCTField(ActionScriptObject("GetFloat"));
	return f;
}

function SetVisibleSave(bool val)
{
	super.SetVisibleSave(val);
}
