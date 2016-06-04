//=============================================================================
// H7GFxQuestComplete
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxQuestComplete extends H7GFxUIContainer;

function Update(H7SeqAct_Quest_NewNode quest)
{
	local GFxObject mData;
	
	mData = CreateObject("Object");
	
	quest.GUIWriteInto(mData,LF_EVERYTHING,self);

	mData.SetObject("Color",CreateColorObject(class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetColor()));
	mData.SetString("Icon",GetFlashPath(class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mButtonIcons.mQuestCompleted));

	SetObject("mData",mData);

	ActionScriptVoid("Update");
}
