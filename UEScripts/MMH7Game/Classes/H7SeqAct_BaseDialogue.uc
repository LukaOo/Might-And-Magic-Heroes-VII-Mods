/* =============================================================================
 * H7SeqAct_BaseDialogue
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================*/

class H7SeqAct_BaseDialogue extends H7SeqAct_Narration
	abstract
	native;

enum EDialogueSpeakerPosition
{
	DSP_LEFT<DisplayName=Left>,
	DSP_RIGHT<DisplayName=Right>,
};

struct native H7DialogueLine
{
	var bool mIsDialogue; // this is a editor only reference copy that is live linked to BaseIsDialogue, TODO ask Christian if remove it
	var private editconst transient bool mIsSpeakerEnabled;
	var private editconst transient bool mIsPositionEnabled;

	/** The speaking Person */
	var() ESpeaker SpeakerType<DisplayName="SpeakerType">;
	/** The speaking specific H7EditorHero */
	var() archetype H7EditorHero speaker<DisplayName="Speaker"|EditCondition=mIsSpeakerEnabled>;
	/** Position of the character portrait */
	var() EDialogueSpeakerPosition Position<DisplayName="Position"|EditCondition=mIsPositionEnabled>;
	/** What the character has to say */
	var() localized string Content<DisplayName="Content"|MultilineWithMaxRows=7>;
	/** The listening specific H7EditorHero */
	var() archetype H7EditorHero listener<DisplayName="Optional Listener overwrite">;
	
	/** The AkEvent linked to the soundfile of the narration dialog in Wwise. The Stop Event ensures the dialog doesnt overlaps. It's stops when switch to the next line or when its closed */
	var() AkEvent mStartVoiceOver<DisplayName="Start Voice Over AkEvent Audio File">;
	var() AkEvent mStopVoiceOver<DisplayName="Stop Voice Over AkEvent Audio File">;

	structdefaultproperties
	{
		mIsDialogue = true;
		mIsSpeakerEnabled = true; // OPTIONAL has to be initialized depending on current base dialog type
		mIsPositionEnabled = true; // OPTIONAL has to be initialized depending on current base dialog type
	}
};

var private EDialogueType mBaseDialogueType;
var private bool mBaseIsDialogue;
var private H7EditorHero mBaseNarrator;
var private array<H7DialogueLine> mBaseLines;

var protected bool mDialogueFinished;
var protected int mCurrentLineIndex;
var protected H7GFxDialog mDialogWindow;
var protected H7GFxCouncilDialog mCouncilDialogWindow;
var protected H7GFxNarrationDialog mNarrationDialogWindow;
var protected string mPreviousCaption;
var protected string mNextCaption;
var protected string mCloseCaption;
var protected bool mAutoForward;
var protected bool mPlayInitialDialogue;
var protected bool mReadyToSwap;
var protected bool mLocalAutoPlaySetting;

event SetAutoForward( bool val ){ mAutoForward = val; }

function Initialize()
{
	mLocalAutoPlaySetting = class'H7OptionsManager'.static.GetInstance().GetSettingBool("AUTO_PLAY_DIALOGS");
}

function bool GetLocalAutoPlaySetting(){ return mLocalAutoPlaySetting; }
function SetLocalAutoPlaySetting(bool val)
{ 
	mLocalAutoPlaySetting = val;
	
	if(mBaseDialogueType == DT_DIALOG)
	{
		class'H7DialogCntl'.static.GetInstance().GetDialog().UpdateAutoPlayState();
	}
	else if(mBaseDialogueType == DT_COUNCIL_DIALOG)
	{
		class'H7DialogCntl'.static.GetInstance().GetCouncilDialog().UpdateAutoPlayState();
	}
}

function ShowDialogue(array<H7DialogueLine> lines, EDialogueType dialogueType, H7EditorHero narrator)
{
	;

	mBaseLines = lines;
	mBaseDialogueType = dialogueType;
	mBaseNarrator = narrator;
	mReadyToSwap = true;

	mDialogueFinished = false;

	if(mBaseLines.Length > 0)
	{
		mPreviousCaption = class'H7Loca'.static.LocalizeSave("HDG_PREVIOUS_LINE","H7SeqAct_ShowDialogue");
		mNextCaption = class'H7Loca'.static.LocalizeSave("HDG_NEXT_LINE","H7SeqAct_ShowDialogue");
		mCloseCaption = class'H7Loca'.static.LocalizeSave("HDG_CLOSE","H7SeqAct_ShowDialogue");
		
		mDialogWindow = class'H7PlayerController'.static.GetPlayerController().GetHud().GetDialogCntl().GetDialog();
		mCouncilDialogWindow = class'H7PlayerController'.static.GetPlayerController().GetHud().GetDialogCntl().GetCouncilDialog();
		mNarrationDialogWindow = class'H7PlayerController'.static.GetPlayerController().GetHud().GetDialogCntl().GetNarrationDialog();

		class'H7PlayerController'.static.GetPlayerController().GetHud().GetDialogCntl().SetNode(self);
		mPlayInitialDialogue = true;
	}
	else
	{
		OnClose();
	}
}

event Actor GetSoundActor() { return class'H7SoundController'.static.GetInstance().GetSoundManager(); }

// resolves the settings of a line into a H7EditorHero
event H7EditorHero GetSpeakerHero(optional int lineIndex = INDEX_NONE)
{
	local H7DialogueLine line;
	local H7EditorHero speaker;
	
	if(lineIndex == INDEX_NONE) line = GetCurrentLineStruct();
	else line = mBaseLines[lineIndex];

	// resolve speaker
	if(line.SpeakerType == SPEAKER_CUSTOM)
	{
		if(line.Speaker != none)
			speaker = line.Speaker;
		else if(mBaseNarrator != none)
			speaker = mBaseNarrator;
		else class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(self @ "line" @ mCurrentLineIndex @ "has neither speaker nor narrator",MD_QA_LOG);;
	}
	else
	{
		// lookup councilor mapping needed in case councilor speaks in narration or dialog
		speaker = class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mCouncilMapping.GetEntry(line.SpeakerType).councilorHero;
	}

	return speaker;
}

function H7EditorHero GetListenerHero(optional int lineIndex = INDEX_NONE,optional bool searchSpeaker = true)
{
	local H7EditorHero listenerHero;
	
	if(lineIndex == INDEX_NONE) lineIndex = mCurrentLineIndex;
	
	listenerHero = mBaseLines[lineIndex].listener; // usually none (== keep previous speaker), but sometimes a specific setted overwrite
	
	if(searchSpeaker && listenerHero == none && lineIndex == 0 && !IsMonolog()) // except first panel
	{
		// OPTIONAL search all until first other listener or speaker is found
		if(lineIndex+1 < mBaseLines.Length) // listener is speaker of next line
		{
			listenerHero = GetSpeakerHero(lineIndex+1);
		}
		else
		{
			;
		}
	}
	return listenerHero;
}

function bool IsMonolog()
{
	local H7EditorHero monologer;
	local H7EditorHero speaker,alistener;
	local H7DialogueLine line;
	local int i;

	foreach mBaseLines(line,i)
	{
		speaker = GetSpeakerHero(i);
		if(speaker != none)
		{
			if(monologer == none)
			{
				monologer = speaker;
			}
			else
			{
				if(monologer != speaker)
				{
					return false;
				}
			}
		}
		alistener = GetListenerHero(i,false);
		if(alistener != none)
		{
			if(alistener != speaker)
			{
				return false;
			}
		}
	}

	return true;
}

function array<H7EditorHero> GetAllSpeakersAndListeners()
{
	local array<H7EditorHero> allSpeakers;
	local H7EditorHero speaker,alistener;
	local H7DialogueLine line;
	local int i;

	foreach mBaseLines(line,i)
	{
		speaker = GetSpeakerHero(i);
		if(allSpeakers.Find(speaker) == INDEX_NONE)
		{
			allSpeakers.AddItem(speaker);
		}
		alistener = GetListenerHero(i);
		if(alistener != none && allSpeakers.Find(alistener) == INDEX_NONE)
		{
			allSpeakers.AddItem(alistener);
		}
	}

	return allSpeakers;
}

function ShowCurrentDialogueLine()
{
	local H7DialogueLine line;
	local bool hasNext,hasPrev;
	local H7EditorHero leftHero,rightHero,speaker,listenerHero;
	local H7SoundController soundController;

	soundController = class'H7SoundController'.static.GetInstance();
	
	line = GetCurrentLineStruct();

	if(mCurrentLineIndex < mBaseLines.Length -1) hasNext = true;
	if(mCurrentLineIndex > 0) hasPrev = true;
	
	// resolve speaker settings to actual hero
	speaker = GetSpeakerHero();
	listenerHero = GetListenerHero();

	if(soundController.GetVoiceOverSetting() && soundController.GetMasterSettings() && line.mStartVoiceOver != none && !mDialogueFinished)
	{
        if(mBaseDialogueType == DT_NARRATION || mLocalAutoPlaySetting)
        {
			PlayCallbackAKEvent(line.mStartVoiceOver);
		}
		else
		{
			class'H7SoundController'.static.PlayGlobalAkEvent(line.mStartVoiceOver,true);
		}
	}

	// just to be sure, deactivate tooltip:
	class'H7AdventureHudCntl'.static.GetInstance().GetActorTooltip().ShutDown();

	switch(mBaseDialogueType)
	{
		case DT_NARRATION:
		case DT_SUBTITLE:
			class'H7PlayerController'.static.GetPlayerController().GetHud().SetHUDMode(HM_CINEMATIC_SUBTITLE);
			mNarrationDialogWindow.Update(GetCurrentLineText(),speaker,hasPrev,hasNext,true);
			break;
		case DT_DIALOG:
			leftHero = line.Position == DSP_LEFT?speaker:listenerHero;
			rightHero = line.Position == DSP_RIGHT?speaker:listenerHero;
			mDialogWindow.Update(leftHero,rightHero,GetCurrentLineText(),line.Position == DSP_LEFT,hasPrev,hasNext,GetAllSpeakersAndListeners(),IsMonolog());
			break;
		case DT_COUNCIL_DIALOG: 
			class'H7AdventureController'.static.GetInstance().SwitchToCouncilMap();
			class'H7PlayerController'.static.GetPlayerController().GetHud().SetHUDMode(HM_MAPVIEW);
			leftHero = line.Position == DSP_LEFT?speaker:listenerHero;
			rightHero = line.Position == DSP_RIGHT?speaker:listenerHero;
			mCouncilDialogWindow.Update(leftHero,rightHero,GetCurrentLineText(),line.Position == DSP_LEFT,hasPrev,hasNext,GetAllSpeakersAndListeners(),IsMonolog());
			break;
		default:
			;
	}

}

function H7DialogueLine GetCurrentLineStruct()
{
	return mBaseLines[mCurrentLineIndex];
}

function string GetCurrentLineText()
{
	local string displayText, contentText;

	contentText = GetLocalizedContent(mCurrentLineIndex);
	displayText = contentText;

	return displayText;
}

function string GetLocalizedContent(int lineIndex)
{
	return "";	//	Implemented in derived classes
}

function StopVoiceOver()
{
	if(mBaseLines[mCurrentLineIndex].mStopVoiceOver != none)
	{
		//Voice Over Stop Event on Close
		class'H7SoundController'.static.PlayGlobalAkEvent(mBaseLines[mCurrentLineIndex].mStopVoiceOver);
		mAutoForward = false;
	}
}

function StartVoiceOver()
{
	local H7SoundController soundController;
	local H7DialogueLine line;

	soundController = class'H7SoundController'.static.GetInstance();
	line = mBaseLines[mCurrentLineIndex];

	if(soundController.GetVoiceOverSetting() && soundController.GetMasterSettings())
	{
		if( line.mStartVoiceOver != none )
		{
			ShowCurrentDialogueLine();
		}
	}
}

function OnClose()
{
	if(class'H7ReplicationInfo'.static.GetInstance() != none)
	{
		class'H7ReplicationInfo'.static.GetInstance().SetCutsceneMode(false);
	}

	mDialogueFinished = true;
	mAutoForward = false;
	StopVoiceOver();
	mCurrentLineIndex = 0;	// Reset line index in case this node is triggered again
}

event DoAutoForward()
{
	//`log_dui("DoAutoForward" @ mAutoForward @ mReadyToSwap);

	if(mPlayInitialDialogue && !class'H7PlayerController'.static.GetPlayerController().IsFullScreenMovieRunning())
	{
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("POP_UP_OPEN_SOUND");
		ShowCurrentDialogueLine();
		mPlayInitialDialogue = false;
	}
	else if (mBaseDialogueType != DT_NARRATION)
	{
		if(mAutoForward && mReadyToSwap && mLocalAutoPlaySetting)
		{
			class'H7AdventureController'.static.GetInstance().SetTimer(0.5f,false,nameof(AutoOnNextLine),self);
			mAutoForward = false;
			mReadyToSwap = false;
			class'H7AdventureController'.static.GetInstance().SetTimer(1,false,nameof(BecomeReadyToSwap),self);
		}
	}
	else
	{
		if(mAutoForward && mReadyToSwap)
		{
			class'H7AdventureController'.static.GetInstance().SetTimer(0.5f,false,nameof(AutoOnNextLine),self);
			mAutoForward = false;
			mReadyToSwap = false;
			class'H7AdventureController'.static.GetInstance().SetTimer(1,false,nameof(BecomeReadyToSwap),self);
		}
	}
}

function BecomeReadyToSwap()
{
	mReadyToSwap = true;
}
event AutoOnNextLine()
{
	if(mCurrentLineIndex < mBaseLines.Length - 1 && !mDialogueFinished)
	{
		mCurrentLineIndex++;
		ShowCurrentDialogueLine();
	}
}

event OnNextLine()
{
	if(mBaseDialogueType == DT_NARRATION){ return; }

	if(mCurrentLineIndex < mBaseLines.Length - 1 && !mLocalAutoPlaySetting)
	{
		if(mBaseLines[mCurrentLineIndex].mStopVoiceOver != none)
		{
			//Stops the current voice over on the switch to next
			class'H7SoundController'.static.PlayGlobalAkEvent(mBaseLines[mCurrentLineIndex].mStopVoiceOver);
		}
		mCurrentLineIndex++;
		ShowCurrentDialogueLine();
	}
}

function OnPreviousLine()
{
	if(mBaseDialogueType == DT_NARRATION){ return; }

	if(mCurrentLineIndex > 0)
	{
		if(mBaseLines[mCurrentLineIndex].mStopVoiceOver != none && !mLocalAutoPlaySetting)
		{
			//Stops the current voice over on the switch to previous
			class'H7SoundController'.static.PlayGlobalAkEvent(mBaseLines[mCurrentLineIndex].mStopVoiceOver);
		}
		mCurrentLineIndex--;
		ShowCurrentDialogueLine();
	}
}

native function PlayCallbackAKEvent(AkEvent event);

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

