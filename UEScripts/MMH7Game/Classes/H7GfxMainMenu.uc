//=============================================================================
// H7GfxMainMenu
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GfxMainMenu extends H7GFxUIContainer;

function SetVisibleSave(bool val)
{
	super.SetVisibleSave(val);

	if(!val)
	{
		GetHud().DeleteAllHighlights();
	}

	//class'H7PlayerController'.static.GetPlayerController().GetHUD().GetLogCntl().GetBorderBlack().SetVisibleSave(val);
}

/*
function Update( )
{
	ActionscriptVoid("Update");
}
*/

function SetVersion(string version)
{
	ActionScriptVoid("SetVersion");
}

function FadeIn( )
{
	ActionscriptVoid("FadeIn");
}

function FadeOut( )
{
	ActionscriptVoid("FadeOut");
}

/*
function DisableWindow()
{
	//Update();
	SetVisibleSave( false );
}
*/

function int GoBack()
{
	return ActionScriptInt("GoBack");
}
/*
function EnableWindow( ) 
{
	//Update();
	SetVisibleSave( true );
}
*/

function BlockContinue()
{
	ActionscriptVoid("BlockContinue");
}

function SetContinueTooltip(string tooltip)
{
	ActionscriptVoid("SetContinueTooltip");
}

function OpenDuelMenu(bool vsAI)
{
	ActionscriptVoid("OpenDuelMenu");
}
