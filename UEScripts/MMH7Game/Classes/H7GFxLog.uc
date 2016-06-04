//=============================================================================
// H7GFxLog
//
// - adventure and combat log
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7GFxLog extends H7GFxUIContainer
	dependson(H7StructsAndEnumsNative);

var protected GFxObject mData;

var protected bool mChatOpenedThisFrame;

function bool WasChatOpenedThisFrame() { return mChatOpenedThisFrame; }
function ResetChatOpenedThisFrame() { mChatOpenedThisFrame = false; }

function Init(H7Log log)
{
	ListenTo( log );

	mData = CreateArray();
}

function SetStatus(bool val)
{
	ActionScriptVoid("SetStatus");
}

function ClearLog()
{
	ActionScriptVoid("ClearLog");
}

function ListenUpdate(H7IGUIListenable gameEntity)
{
	mData = CreateArray();

	//`log_dui("ListenUpdate");
	H7Log(gameEntity).GUIWriteInto(mData,LF_EVERYTHING,self);
	
	//`log_dui("Update");
	SetObject("mData",mData);

	Update();
}

function SetVisibleSave(bool val)
{
	if(val && H7MainMenuHud(GetHud()) != none) return; // never show in main menu
	super.SetVisibleSave(val);
}

function ActivateChatInput()
{
	if(!class'H7OptionsManager'.static.GetInstance().GetSettingBool("CHAT_ENABLED")) return;

	mChatOpenedThisFrame = true;
	GetHud().SetFrameTimer(1,ResetChatOpenedThisFrame);

	class'H7LogSystemCntl'.static.GetInstance().RequestRealFocus();
	
	;
	ActionScriptVoid("ActivateChatInput");
}

function DeactivateChatInput()
{
	class'H7LogSystemCntl'.static.GetInstance().WaiveRealFocus();
	;
	ActionScriptVoid("DeactivateChatInput");
}

function Update()
{
	ActionScriptVoid("Update");
}
