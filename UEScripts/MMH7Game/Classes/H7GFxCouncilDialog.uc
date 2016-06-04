//=============================================================================
// H7GFxCouncilDialog
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxCouncilDialog extends H7GFxDialog;

var protected bool mBlockLayer;
var protected bool mBlockInput;
var protected bool mPrevOnMode;
var protected bool mDialogIsShowing;

function bool IsPrevOnMode()    {	return mPrevOnMode;         }
function bool IsDialogShowing() {	return mDialogIsShowing;    }

function Init()
{
	local GFxObject mData,mEntry;
	local int i;
	local Color colorCouncilor;
	local H7CampaignDefinition theCampaign;
	local H7EditorHero councilor;

	if(GetHud() == none) { return; }
	
	i = 0;
	mData = CreateArray();

	for(i=1;i<SPEAKER_MAX;i++)
	{
		councilor = GetHud().GetProperties().mCouncilMapping.GetEntry(ESpeaker(i)).councilorHero;
		theCampaign = class'H7GameData'.static.GetInstance().GetCampaignByCouncilor(councilor);
		colorCouncilor = councilor.GetColor();

		mEntry = CreateObject("Object");
		mEntry.SetString("ID", councilor.GetArchetypeID() );
		mEntry.SetString("Name", GetHud().GetProperties().mCouncilMapping.GetName(ESpeaker(i)) );
		mEntry.SetString("Icon", GetHud().GetProperties().mCouncilMapping.GetFlashIconPath(ESpeaker(i)) );
		mEntry.SetString("Color", GetHud().GetDialogCntl().UnrealColorToFlashColor(colorCouncilor) );
		mEntry.SetString("Campaign", theCampaign.GetAID() );
		mData.SetElementObject(i,mEntry);
	}
	
	SetObject("mData",mData);

	ActionscriptVoid("Init");
}

// Council Intervention Mode
function Update(H7EditorHero leftSpeaker, H7EditorHero rightSpeaker, String text, bool leftIsSpeaking, bool hasPrev, bool hasNext,array<H7EditorHero> allspeakers,bool isMonolog,optional string headline,optional string buttonCaption)
{
	mBlockLayer = true;
	mBlockInput = true;
	mDialogIsShowing = true;
	super.Update(leftSpeaker, rightSpeaker, text, leftIsSpeaking, hasPrev, hasNext, allspeakers, isMonolog, headline);
	SetPrevOnMode(false);
}

// Prev On Mode
function ShowPrevOn(H7EditorHero speaker, string headline, string text, bool hasPrev, bool hasNext,string buttonCaption)
{
	local array<H7EditorHero> speakers;
	speakers.AddItem(speaker);
	mBlockLayer = false;
	mBlockInput = false;
	mDialogIsShowing = false;
	super.Update(speaker,none,text,true,hasPrev,hasNext,speakers,true,headline,buttonCaption);
	SetPrevOnMode(true);
}

// Shutdown
function SetVisibleSave(bool val)
{
	if(!val)
	{
		mDialogIsShowing = val;
	}
	super.SetVisibleSave(val);
}

function SetPrevOnMode(bool val)
{
	mPrevOnMode = val;
	ActionScriptVoid("SetPrevOnMode");
}

function SetFactionDeco(GFxObject speakerData,H7EditorHero speaker,bool isLeft)
{
	if(isLeft)
	{
		if(speaker.GetFaction().GetCouncilLeftStainedGlassBase() == "img://None")
		{
			speakerData.SetBool("Mirror",true);
			speakerData.SetString("FactionGlass",speaker.GetFaction().GetCouncilRightStainedGlassBase());
			speakerData.SetString("FactionGlow",speaker.GetFaction().GetCouncilRightStainedGlassHighlight());
			speakerData.SetString("FactionGrid",speaker.GetFaction().GetCouncilRightStainedGlassGrid());
		}
		else
		{
			speakerData.SetString("FactionGlass",speaker.GetFaction().GetCouncilLeftStainedGlassBase());
			speakerData.SetString("FactionGlow",speaker.GetFaction().GetCouncilLeftStainedGlassHighlight());
			speakerData.SetString("FactionGrid",speaker.GetFaction().GetCouncilLeftStainedGlassGrid());
		}
	}
	else
	{
		if(speaker.GetFaction().GetCouncilRightStainedGlassBase() == "img://None")
		{
			speakerData.SetBool("Mirror",true);
			speakerData.SetString("FactionGlass",speaker.GetFaction().GetCouncilLeftStainedGlassBase());
			speakerData.SetString("FactionGlow",speaker.GetFaction().GetCouncilLeftStainedGlassHighlight());
			speakerData.SetString("FactionGrid",speaker.GetFaction().GetCouncilLeftStainedGlassGrid());
		}
		else
		{
			;
			speakerData.SetString("FactionGlass",speaker.GetFaction().GetCouncilRightStainedGlassBase());
			speakerData.SetString("FactionGlow",speaker.GetFaction().GetCouncilRightStainedGlassHighlight());
			speakerData.SetString("FactionGrid",speaker.GetFaction().GetCouncilRightStainedGlassGrid());
		}
	}
}

function DisplayDifficultySettings(int global,int res,int strength,int growth,int ai)
{
	ActionScriptVoid("DisplayDifficultySettings");
}

function ShowGUI()
{
	GetHud().GetDialogCntl().OpenPopupSpecific(self,mBlockLayer,mBlockInput);
}
