//=============================================================================
// H7GFxQuestLog
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxQuestLog extends H7GFxUIContainer dependson(H7SeqAct_Quest_NewNode);

function Update(optional H7SeqAct_Quest_NewNode preSelectQuest)
{
	local GFxObject mData,mQuestList,questData;
	local H7SeqAct_Quest_NewNode quest;
	local int i;
	local array<H7SeqAct_Quest_NewNode> quests;

	quests = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetQuestController().GetActiveQuestNodes();
	;

	mData = CreateObject("Object");
	mQuestList = CreateArray();

	// fill mData
	i = 0;
	foreach quests(quest)
	{
		questData = CreateObject("Object");

		quest.GUIWriteInto(questData,LF_EVERYTHING,self);

		mQuestList.SetElementObject(i,questData);
		i++;
	}
	mData.SetObject("Quests",mQuestList);

	if(preSelectQuest != none)
	{
		mData.SetString("PreSelectQuest",preSelectQuest.GetID());
	}

	mData.SetObject("Color",CreateColorObject(class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetColor()));
	mData.SetString("HeaderIcon","img://" $ PathName(class'H7GUIGeneralProperties'.static.GetInstance().mButtonIcons.mQuestHeader));	
	mData.SetString("FilterAllIcon","img://" $ PathName(class'H7GUIGeneralProperties'.static.GetInstance().mButtonIcons.mQuestFilterAll));
	mData.SetString("FilterPrimaryIcon","img://" $ PathName(class'H7GUIGeneralProperties'.static.GetInstance().mButtonIcons.mQuestFilterPrimary));
	mData.SetString("FilterSecondaryIcon","img://" $ PathName(class'H7GUIGeneralProperties'.static.GetInstance().mButtonIcons.mQuestFilterSecondary));

	SetObject("mData",mData);
	
	GetMinimapDummyBounds();
	ActionScriptVoid("Update");
}

function GetMinimapDummyBounds() // -> goes to SetMinimapDummyBounds
{	
	ActionScriptVoid("GetMinimapDummyBounds");
}
