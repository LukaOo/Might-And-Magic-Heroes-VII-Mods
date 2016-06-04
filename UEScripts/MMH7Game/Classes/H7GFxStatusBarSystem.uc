//=============================================================================
// H7StatusBarSystem
// - Adventure: Bridges
// - Combat: Mana & Health
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxStatusBarSystem extends GFxObject;

var private bool mIsCurrentlyVisible;
var protected GFxObject mMultiUpdateList;

function bool IsCurrentlyVisibleHealtBars() { return mIsCurrentlyVisible; }


function int CreateProgressBar(int x,int y, int percent, int width)
{
	local int i;
	i = ActionScriptInt("CreateProgressBar");
	return i;
}

function int CreateHealthBar(int x,int y, int percent, int width )
{
	local int i;
	i = ActionScriptInt("CreateHealthBar");
	return i;
}

function int CreateManaBar(int x,int y, int percent, int width)
{
	local int i;
	
	i = ActionScriptInt("CreateManaBar");
	return i;
}

function UpdateBar(int id,int x,int y, int percent, bool visible)
{
	//`log_gui("updating bar with visibility"@id@visible);
	ActionScriptVoid("UpdateBar");
}

function RemoveBar(int id)
{
	ActionScriptVoid("RemoveBar");
}

function SetSystemVisible(bool val)
{
	if(val == mIsCurrentlyVisible)
	{
		return;
	}

	mIsCurrentlyVisible = val;

	SetBool("BarsVisible",val); // will be used by plates to adapt their position to the bar

	// don't update since these changes will become visible in 1 frame, before beeing corrected by PostRender
	// just wait until PostRender considers the new mIsCurrentlyVisible
	//ActionScriptVoid("SetVisible");
}

// Multi Update

function StartMultiUpdate()
{
	if(mMultiUpdateList == none)
	{
		mMultiUpdateList = CreateObject("Object");
		SetObject( "mData" , mMultiUpdateList);
	}
}

function AddUpdate(int id,int x,int y, int percent, bool visible)
{
	local GFxObject TempObj;

	TempObj = mMultiUpdateList.GetObject(string(id));

	if(TempObj == none)
	{
		TempObj = CreateObject("Object");
		mMultiUpdateList.SetObject(string(id), TempObj);
	}

	TempObj.SetInt( "id", id );
	TempObj.SetInt( "x", x );
	TempObj.SetInt( "y", y );
	TempObj.SetInt( "percent", percent );
	TempObj.SetBool( "visible", visible );

	//`log_dui("MultiUpdate.AddUpdate" @ id @ x @ y @ stackSize @ visible @ plateOrientation);
}

function MultiUpdate()
{
	//`log_dui("Multi Update");
	
	ActionScriptVoid("MultiUpdate");
}

function Clear()
{
	//`log_dui("Delete all Plate");
	mMultiUpdateList = none;

	ActionScriptVoid("Clear");
}

// Default properties block
