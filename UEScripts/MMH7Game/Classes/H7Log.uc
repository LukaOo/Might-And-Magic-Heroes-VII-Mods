//=============================================================================
// H7Log
//
// 
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7Log extends Object implements(H7IGUIListenable);

var array<H7Message> mLog;
var array<H7Message> mLogFlashBuffer;

function AddMessage(H7Message message)
{
	//`log_dui("AddLog" @ text);

	mLog.AddItem(message);
	mLogFlashBuffer.AddItem(message);

	DataChanged(); // -> goes to H7GfxLog.ListenUpdate()
}

// only writes _new_ entries into data
function GUIWriteInto(GFxObject data,optional H7ListenFocus focus,optional H7GFxUIContainer flashFactory) 
{
	local int i,maxMessagesPerFrame,messagesToWrite;
	local H7Message newMessage;
	local GFxObject entry;

	maxMessagesPerFrame = 10;
	messagesToWrite = min(maxMessagesPerFrame,mLogFlashBuffer.Length);

	//`log_dui("mLogFlashBuffer" @ mLogFlashBuffer.Length @ "writing...");

	for(i=0;i<messagesToWrite;i++)
	{
		newMessage = mLogFlashBuffer[i];
		entry = flashFactory.GetNewObject();

		newMessage.GUIWriteInto(entry);

		data.SetElementObject(i,entry);
	}
	
	mLogFlashBuffer.Remove(0,messagesToWrite);

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

