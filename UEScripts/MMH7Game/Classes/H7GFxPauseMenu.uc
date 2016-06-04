//=============================================================================
// H7GFxPauseMenu
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxPauseMenu extends H7GFxUIContainer;

function UpdateLoca()
{
	ActionscriptVoid("UpdateLoca");
}

function UpdateButtonStatesNew(bool canResume,bool canLoad,bool canSave,bool canOption,bool canRestart,bool canQuit)
{
	ActionscriptVoid("UpdateButtonStatesNew");
}

function UpdateButtonCaptions(string restartCaption)
{
	ActionscriptVoid("UpdateButtonCaptions");
}

function SetVisibleSave(bool val)
{
	super.SetVisibleSave(val);
}
