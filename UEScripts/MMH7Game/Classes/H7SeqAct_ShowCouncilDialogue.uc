 // Copyright 2013-2015 Limbic Entertainment All Rights Reserved.

class H7SeqAct_ShowCouncilDialogue extends H7SeqAct_Narration
	implements(H7IVoiceable)
	perobjectconfig
	native;

struct native H7CouncilDialogueLine
{
	/** What the counciler has to say */
	var() localized string Content<DisplayName="Content"|MultilineWithMaxRows=7>;
	var() AkEvent mStopVoiceOver<DisplayName="Stop Voice Over AkEvent Audio File">;
};

/** The lines of the dialogue */
var(Properties) protected array<H7CouncilDialogueLine> mLines<DisplayName="Lines">;

var protected int mCurrentLineIndex;
var protected bool mDialogueFinished;

function Activated()
{
	mDialogueFinished = false;
	mCurrentLineIndex = -1;
}

native function ShowSubtitles();

event ShowSubtitle()
{
	class'H7PlayerController'.static.GetPlayerController().GetHud().GetDialogCntl().ShowSubtitle(GetLocalizedContent());
}

event HideSubtitle()
{
	class'H7PlayerController'.static.GetPlayerController().GetHud().GetDialogCntl().HideSubtitle();
}

event FinishDialogue()
{
	HideSubtitle();
	mCurrentLineIndex = -1;
	mDialogueFinished = true;
}

event Actor GetSoundActor()
{
	return H7CouncilPlayerController(class'H7PlayerController'.static.GetPlayerController());
}

function string GetLocalizedContent()
{
	local H7CouncilDialogueLine line;
	local string locaKey, contentText;

	line = mLines[mCurrentLineIndex];

	// Format: mLines[0]_Content="How dare you! What are you doing in my country?"
	locaKey = (class'H7Loca'.static.GetArrayFieldName("mLines", mCurrentLineIndex))$CONTENT_KEY;
	contentText = class'H7Loca'.static.LocalizeCouncilObject(self, locaKey, line.Content);

	return contentText;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
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

