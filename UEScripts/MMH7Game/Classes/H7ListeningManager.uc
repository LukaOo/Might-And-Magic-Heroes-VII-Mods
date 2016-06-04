//=============================================================================
// H7ListeningManager
//
// this class is used to connect a gameEntity (Actor,Object,Hero,Town,Unit,...) to a GUIEntity
//
// - the gameEntity needs to implement H7IGUIListenable and call DataChanged every time it changes data
// - the GUIEntity needs to be a gui-element (GFxUIContainer) or a data-element (GFxObject (in flash: H7DataObject (casting does not work)))
// - both need to be connected by calling H7ListeningManager.AddListener(gameEntity,GUIEntity)
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7ListeningManager extends Object;

struct H7ListeningEntry
{
	var GFxObject mListener;
	var H7GUIConnector mListener2;
	var H7IGUIListenable mListenee;
	var H7ListenFocus mFocus;
};

var protected array<H7ListeningEntry> mListener;
var protected array<H7IGUIListenable> mDataChangedThisFrame;
var protected int mFramesWaited;
var protected int mResumeAtListener;

static function H7ListeningManager GetInstance()
{
	local H7ListeningManager manager;

	manager = class'H7PlayerController'.static.GetPlayerController().GetHud().GetListeningManager();

	return manager;
}

function RemoveListener(GFxObject newListener)
{
	local H7ListeningEntry entry;
	local int key;

	foreach mListener(entry,key)
	{
		if(entry.mListener == newListener)
		{
			mListener.RemoveItem(entry);
			return;
		}
	}
}

// listener can only listen to one gameObject
// if newListener already is listening to something else, it is redirected
function AddListener(H7IGUIListenable ob,GFxObject newListener,optional H7ListenFocus focus)
{
	local H7ListeningEntry entry;
	local int key;

	//`log_dui("AddListener" @ ob @ newListener);

	foreach mListener(entry,key)
	{
		if(entry.mListener == newListener)
		{
			mListener[key].mListenee = ob;
			return;
		}
	}
	
	entry.mListener = newListener;
	entry.mListenee = ob;
	mListener.AddItem(entry);

	
}

// just saves the changed gameEntity until Update();
function DataChanged(H7IGUIListenable gameEntity)
{
	if(mDataChangedThisFrame.Find(gameEntity) == -1)
	{
		mDataChangedThisFrame.AddItem(gameEntity);
	}
}

function int GetMSTimeStamp()
{
	local int year,month,day7,day,hour,min,sec,msec;
	local int milisec;

	GetSystemTime(year,month,day7,day,hour,min,sec,msec);

	milisec = msec+1000*(sec+60*(min+60*(hour)));

	//MathTest();

	return milisec;
}

function bool CanUseFrameTime()
{
	local float timeSinceFrameStart;

	
	if(mFramesWaited > 10) // don't care about time, if I already waited this long, force update!
	{
		;
		mFramesWaited = 0;
		return true;
	}

	if(mDataChangedThisFrame.Length > 0)
	{
		timeSinceFrameStart = class'H7ReplicationInfo'.static.GetInstance().GetTimeSinceFrameStart();
		
		if(timeSinceFrameStart > 10)
		{
			;
			mFramesWaited++;
			return false;
		}
		else
		{
			;
		}
	}
	return true;
}

// called every frame
function Update()
{
	local H7ListeningEntry entry;
	local H7IGUIListenable changedGameEntity;
	local int startTime,endTime,checkTime,i,j;
	local bool didSomething,somebodyListened;
	local int processedChanges,processedListeners;
	local GFxObject dataObject;

	if(!CanUseFrameTime())
	{
		return;
	}

	if(mDataChangedThisFrame.Length > 0)
	{
		//`log_lui("ListeningManager.Update");
		//foreach mDataChangedThisFrame(changedGameEntity,i)
		//{
		//	`log_lui(changedGameEntity);
		//}
		//foreach mListener(entry,j)
		//{
		//	`log_lui(entry.mListenee @ entry.mListener);
		//}
	}

	startTime = GetMSTimeStamp();
	processedChanges = 0;

	if(mResumeAtListener > 0)
	{
		;
	}
	
	foreach mDataChangedThisFrame(changedGameEntity,i)
	{
		somebodyListened = false;
		processedListeners = 0;
		foreach mListener(entry,j)
		{
			// check if time left, might have to be moved one loop up, because we can not realiably resume in the sub loop, in case listeners are added between frames :-(
			checkTime = GetMSTimeStamp();
			if(checkTime - startTime > 10)
			{
				;
				;
				;
				mDataChangedThisFrame.Remove(0,processedChanges);
				mResumeAtListener = processedListeners; // ie, 1 completed (index0 completed), resume at index=1
				return;
			}

			if(entry.mListenee == changedGameEntity)
			{
				if(processedListeners >= mResumeAtListener)
				{
					//`log_dui(changedGameEntity @ "changed has listners, has time");
					didSomething = true;
					somebodyListened = true;
					// listener could be a data-element or a gui-element
					if(H7GFxUIContainer(entry.mListener) != none) // gui-element (H7GFxUIContainer)
					{
						H7GFxUIContainer(entry.mListener).ListenUpdate(changedGameEntity);
					
						checkTime = GetMSTimeStamp();
						;
					}
					else // data-element (GFxObject)
					{
						dataObject = entry.mListener;
						changedGameEntity.GUIWriteInto(dataObject,entry.mFocus);
						dataObject.ActionScriptVoid("ListenUpdate");

						checkTime = GetMSTimeStamp();
						;
					}
				}
				else
				{
					//`log_dui("--skipped update of " @ changedGameEntity @ entry.mListener);
				}
			}

			processedListeners++; // i.e. checked listeners
		}

		if(!somebodyListened)
		{
			if(H7SideBar(changedGameEntity) != none || H7Log(changedGameEntity) != none)
			{
				;
			}
		}
		processedListeners = 0;
		mResumeAtListener = 0; // every element goes through all listeners
		processedChanges++;
	}

	mResumeAtListener = 0;
	mDataChangedThisFrame.Remove(0,mDataChangedThisFrame.Length);

	if(didSomething)
	{
		endTime = GetMSTimeStamp();

		;
		endTime=endTime; // to avoid compile warning when log_lui macro is disabled
	}
}
