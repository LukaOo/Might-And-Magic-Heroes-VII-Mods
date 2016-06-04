//=============================================================================
// H7GFxWindowWeeklyEffect
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxWindowWeeklyEffect extends H7GFxUIContainer;

function Update(String weeklyEffectTitle, String weeklyEffectDescription)
{
	ActionscriptVoid("Update");
	SetVisibleSave(true);
}

function bool GetShowInFuture()
{
	local int i;
	i = ActionScriptInt("GetShowInFuture");
	;
	return (i == 1)?true:false;
}
