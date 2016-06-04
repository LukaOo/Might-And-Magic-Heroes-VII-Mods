//=============================================================================
// H7SideBar
//
// messages that slide in and out at the side
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7SideBar extends Object implements(H7IGUIListenable);

var array<H7Message> mList;
var array<H7Message> mListFlashBuffer;

function AddMessage(H7Message message)
{
	;

	mList.AddItem(message);
	mListFlashBuffer.AddItem(message);

	DataChanged(); // -> goes to H7GfxSideBar.ListenUpdate()
}

function DeleteMessage(H7Message message)
{
	;
	mList.RemoveItem(message);
	mListFlashBuffer.RemoveItem(message);
}

function int GetBufferCount()
{
	return mListFlashBuffer.Length;
}

// onlywrites new entries into data
function GUIWriteInto(GFxObject data,optional H7ListenFocus focus,optional H7GFxUIContainer flashFactory) 
{
	local int i;
	local H7Message newMessage;
	local GFxObject entry;

	//`log_dui("mLogFlashBuffer" @ mLogFlashBuffer.Length @ "writing...");

	foreach mListFlashBuffer(newMessage,i)
	{
		entry = flashFactory.GetNewObject();

		mListFlashBuffer[i].GUIWriteInto(entry);

		data.SetElementObject(i,entry);
		//`log_dui("      " @ mLogFlashBuffer[i].text);
	}
	
	mListFlashBuffer.Length = 0;

	// now goes back to H7GFxLog.ListenUpdate
}

// WriteInto this GFxObject if DataChanged
function GUIAddListener(GFxObject data,optional H7ListenFocus focus) 
{
	class'H7ListeningManager'.static.GetInstance().AddListener(self,data);
}

// Game Object needs to know what to do when its data changes (usually they just call ListeningManager)
function DataChanged(optional String cause) 
{
	class'H7ListeningManager'.static.GetInstance().DataChanged(self);
}

