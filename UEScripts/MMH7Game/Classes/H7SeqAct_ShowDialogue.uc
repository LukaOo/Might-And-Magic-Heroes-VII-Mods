/*=============================================================================
 * H7SeqAct_ShowDialogue
 * 
 * rules:
 * dialog can be:
 * - narration
 * - dialog
 * - councildialog
 * lines can be:
 * - by editorhero
 * - by councilor
 * - by narrator
 * 
 *                  by editorhero       by councilor       by narrator
 * narration        ok                  ok                  ok
 * dialog           ok                  ok but weird        ok
 * councildialog    not ok              ok                  not ok
 * 
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================*/

class H7SeqAct_ShowDialogue extends H7SeqAct_BaseDialogue
	implements(H7IAliasable, H7IHeroReplaceable, H7IVoiceable)
	perobjectconfig
	native;

var private editconst transient bool mIsNarratorEnabled;

/** Used in the list on the left and when selected in the event editor */
var(Properties) protected string mTitle<DisplayName="Title">;
/** Dialog Type (narration=one guy speaking during gameplay;dialog=2 face popup;council=7 faces popup)*/
var(Properties) protected EDialogueType mDialogueType<DisplayName="Dialogue Type">;
/** More than one character is speaking */
var(Properties_Deprecated) protected bool mIsDialogue<DisplayName="Dialogue (Deprecated)">;
/** Narrating character */
var(Properties) protected archetype H7EditorHero mNarrator<DisplayName="Narrator"|EditCondition=mIsNarratorEnabled>;
/** The lines of the dialogue */
var(Properties) protected array<H7DialogueLine> mLines<DisplayName="Lines">;

function array<H7DialogueLine> GetLines() { return mLines; }
function H7EditorHero GetNarrator() { return mNarrator; }
function bool IsDialogue() { return mIsDialogue; }
function EDialogueType GetDialogueType() { return mDialogueType; }

function Activated()
{
	if(class'H7ReplicationInfo'.static.GetInstance() != none)
	{
		class'H7ReplicationInfo'.static.GetInstance().SetCutsceneMode(true);
	}

	ShowDialogue(mLines, mDialogueType, mNarrator);
}

function string GetLocalizedContent(int lineIndex)
{
	local H7DialogueLine line;
	local string locaKey, contentText;

	line = mLines[lineIndex];

	// Format: mLines[0]_Content="How dare you! What are you doing in my country?"
	locaKey = (class'H7Loca'.static.GetArrayFieldName("mLines", lineIndex))$CONTENT_KEY;
	contentText = class'H7Loca'.static.LocalizeKismetObject(self, locaKey, line.Content);

	return contentText;
}

event VersionUpdated(int OldVersion, int NewVersion)
{
	;
	
	if(OldVersion < 7)
	{
		if(mIsDialogue) mDialogueType = DT_DIALOG;
		else mDialogueType = DT_NARRATION;
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 3;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

