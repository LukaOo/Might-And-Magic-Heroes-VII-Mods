/*=============================================================================
 * H7SeqAct_StartShowDialogue
 * 
 * Needed for noob editor
 * Action to show a dialog using the data of a H7SeqAct_ShowDialogue node.
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 *=============================================================================*/

class H7SeqAct_StartShowDialogue extends H7SeqAct_BaseDialogue
	implements(H7IAliasable, H7IActionable)
	native;

/** The dialogue to show */
var(Properties) protected H7SeqAct_ShowDialogue mDialogToShow<DisplayName="Dialogue to show">;

function Activated()
{
	local array<H7DialogueLine> lines;
	local H7EditorHero narrator;
	local EDialogueType dialogueType;
	local H7ScriptingController scriptControl;

	if(mDialogToShow != none)
	{
		if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
		{
			scriptControl = class'H7ScriptingController'.static.GetInstance();
			if(scriptControl != none)
			{
				scriptControl.PauseCombat();
			}
		}

		lines = mDialogToShow.GetLines();
		narrator = mDialogToShow.GetNarrator();
		dialogueType = mDialogToShow.GetDialogueType();
		
		ShowDialogue(lines, dialogueType, narrator);
	}
}

function OnClose()
{
	local H7ScriptingController scriptControl;

	Super.OnClose();

	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		scriptControl = class'H7ScriptingController'.static.GetInstance();
		if(scriptControl != none)
		{
			scriptControl.ResumeCombat();
		}
	}
}

function string GetLocalizedContent(int lineIndex)
{
	return (mDialogToShow == none) ? "Invalid dialogue object" : mDialogToShow.GetLocalizedContent(lineIndex);
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

