//=============================================================================
// H7GFxFlashController
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxFlashController extends GFxClikWidget;

var protected bool mIsShowingBlockLayer;

function bool IsShowingBlockLayer() { return mIsShowingBlockLayer; }

function int IsInputFocus()
{
	local int val;
	val = ActionScriptInt("IsInputFocus");
	return val;
}

function BlockEntireFlashMovie(optional bool showBlockLayer=true)
{
	mIsShowingBlockLayer = showBlockLayer;
	ActionScriptVoid("BlockEntireFlashMovie");
}

function FreeEntireFlashMovie()
{
	mIsShowingBlockLayer = false;
	ActionScriptVoid("FreeEntireFlashMovie");
}

function RightMouseDown()
{
	ActionscriptVoid("RightMouseDown");
}

function SetConstraints(int minX,int minY,int maxX,int maxY)
{
	ActionscriptVoid("SetConstraints");
}

function int TriggerKeyboardEvent(bool down,int keyCode,int flashCharCode,bool shift,bool control,bool alt)
{
	local int usedByFlash;
	usedByFlash = ActionScriptInt("TriggerKeyboardEvent");
	return usedByFlash;
}

function LoseFocusOnInput()
{
	 ActionScriptVoid("LoseFocusOnInput");
}

function DumpTweens()
{
	;
	 ActionScriptVoid("DumpTweens");
}

function CleanMovie()
{
	;
	 ActionScriptVoid("CleanMovie");
}

function HighlightElement(string containerName, string elementName, optional string text,optional int asset=2)
{
	 ActionScriptVoid("HighlightElement");
}

function DeleteAllHighlights()
{
	 ActionScriptVoid("DeleteAllHighlights");
}
