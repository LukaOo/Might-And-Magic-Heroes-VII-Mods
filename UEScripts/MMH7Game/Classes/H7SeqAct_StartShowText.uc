/*=============================================================================
 * H7SeqAct_StartShowText
 * 
 * Action to show a dialog using the data of a H7SeqAct_ShowText node.
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 *=============================================================================*/

class H7SeqAct_StartShowText extends H7SeqAct_BaseText
	implements(H7IAliasable, H7IActionable)
	native;

/** The text to show */
var(Properties) protected H7SeqAct_ShowText mTextToShow<DisplayName="Text to show">;

function Activated()
{
	local H7ScriptingController scriptControl;

	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		scriptControl = class'H7ScriptingController'.static.GetInstance();
		if(scriptControl != none)
		{
			scriptControl.PauseCombat();
		}
	}

	ShowText();
}

function OnTextConfirmed()
{
	local H7ScriptingController scriptControl;

	Super.OnTextConfirmed();

	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		scriptControl = class'H7ScriptingController'.static.GetInstance();
		if(scriptControl != none)
		{
			scriptControl.ResumeCombat();
		}
	}
}

function string GetLocalizedContent()
{
	return (mTextToShow == none) ? "Invalid text object" : mTextToShow.GetLocalizedContent();
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

