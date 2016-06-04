//=============================================================================
// H7GFxSideBar
//
// - adventure and combat log
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7GFxSideBar extends H7GFxUIContainer
	dependson(H7StructsAndEnumsNative);

var protected GFxObject mData;

function Init(H7SideBar sidebar)
{
	ListenTo( sidebar );

	mData = CreateArray();
}

function ListenUpdate(H7IGUIListenable gameEntity)
{
	mData = CreateArray();
	
	//`log_dui("SideBar.ListenUpdate");
	H7SideBar(gameEntity).GUIWriteInto(mData,LF_EVERYTHING,self);
	
	//`log_dui("Update");
	SetObject("mData",mData);
	
	//SetVisibleSave(true); // this would cause appearing messages in hud modes where they should be hidden

	Update();
}

function int CanAddMessage()
{
	return ActionScriptInt("CanAddMessage");
}

function BlinkMessage(int id)
{
	ActionScriptVoid("BlinkMessage");
}

function SelectMessage(int id) // also unselects all others (-1 to unselect all)
{
	ActionScriptVoid("SelectMessage");
}

function DeleteMessage(int id)
{
	ActionScriptVoid("DeleteMessage");
}

function SetState(bool val)
{
	ActionScriptVoid("SetState");
}

function Update()
{
	ActionScriptVoid("Update");
}

function SetVisibleSave(bool val)
{
	super.SetVisibleSave(val);
}
