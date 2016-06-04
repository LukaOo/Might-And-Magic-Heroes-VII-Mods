//=============================================================================
// H7GFxDialog
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxDialog extends H7GFxUIContainer;

function Update(H7EditorHero leftSpeaker, H7EditorHero rightSpeaker, String text, bool leftIsSpeaking, bool hasPrev, bool hasNext,array<H7EditorHero> allspeakers,bool isMonolog,optional string headline,optional string buttonCaption)
{
	local GFxObject mData,speakerData,speakerArray;
	local H7EditorHero speaker;
	local int i;

	;

	mData = CreateDataObject();
	
	mData.SetString("Text",text);
	mData.SetString("Headline",headline);
	mData.SetString("ButtonCaption",buttonCaption);
	mData.SetBool("LeftIsSpeaking",leftIsSpeaking);
	
	mData.SetBool("HasPrev",hasPrev);
	mData.SetBool("HasNext",hasNext);
	
	if(leftSpeaker != none)
	{
		mData.SetString("LeftID",String(leftSpeaker));
	}
	else if(isMonolog)
	{
		mData.SetString("LeftID","EMPTY");
	}

	if(rightSpeaker != none)
	{
		mData.SetString("RightID",String(rightSpeaker));
	}
	else if(isMonolog)
	{
		mData.SetString("RightID","EMPTY");
		speakerData = CreateObject("Object");
		speakerData.SetString("Color",GetHud().GetDialogCntl().UnrealColorToFlashColor(leftSpeaker.GetColor()));
		SetFactionDeco(speakerData,leftSpeaker,false); // we use the leftSpeaker as base to generate EmptyData from it
		mData.SetObject("EmptyData",speakerData);
	}
	speakerArray = CreateArray();
	
	foreach allspeakers(speaker,i)
	{
		speakerData = CreateObject("Object");
		speakerData.SetString("ID",String(speaker));
		speakerData.SetString("Icon",speaker.GetFlashIconPath());
		speakerData.SetString("Name",speaker.GetName());
		SetFactionDeco(speakerData,speaker,leftSpeaker == speaker);
		speakerData.SetString("Color",GetHud().GetDialogCntl().UnrealColorToFlashColor(speaker.GetColor()));
		speakerArray.SetElementObject(i,speakerData);
	}

	mData.SetObject("AllSpeakers",speakerArray);

	SetObject("mData",mData);

	ActionscriptVoid("Update");

	ShowGUI();
}

function ShowGUI()
{
	GetHud().GetDialogCntl().OpenPopupSpecific(self);
}

function SetFactionDeco(GFxObject speakerData,H7EditorHero speaker,bool isLeft)
{
	speakerData.SetString("FactionGlass",speaker.GetFaction().GetStainedGlassBase());
	speakerData.SetString("FactionGlow",speaker.GetFaction().GetStainedGlassHighlight());
	speakerData.SetString("FactionGrid",speaker.GetFaction().GetStainedGlassGrid());
}

function UpdateAutoPlayState()
{
	ActionscriptVoid("UpdateAutoPlayState");
}
