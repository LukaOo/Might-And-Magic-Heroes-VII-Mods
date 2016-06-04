//=============================================================================
// H7FlashMoviePopupCntl
//
// Here goes what is common to all flash-movies that represent a popup (window or popup, normal or blocking)
// OPTIONAL search for all Closed() -> refactor
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7FlashMoviePopupCntl extends H7FlashMovieCntl
	dependson(H7KeybindManager);

var protected EKeybindCategory mKeybindCategory;
var protected array<H7Keybind> mWindowSpecificKeybinds; // they don't use the unreal system

var protected bool mBlockUnreal; // 3d world
var protected bool mBlockFlash; // but only flash lower than itself
var protected bool mFullscreen;
var protected bool mHideSidebar;
var protected bool mBlockStandardKeys;
var protected bool mOpenedThisFrame;

var protected array<String> mAllowedStandardCommands; // if mBlockStandardKeys==true, it sill allows these hotkeys (mainly the one to toggle this popup + others; see Spellbook)

function bool IsBlockingUnreal()            { return mBlockUnreal; }
function bool IsBlockingStandardKeys()      { return mBlockStandardKeys; }
function bool IsHidingSidebar()             { return mHideSidebar; }
function bool IsFullscreen()                { return mFullscreen; }
function bool IsAllowingCommandFunction(String cmd) { return mAllowedStandardCommands.Find(cmd) != INDEX_NONE; }
function bool WasOpenedThisFrame()          { return mOpenedThisFrame; }
function ResetOpenedThisFrame()             { mOpenedThisFrame = false; }
function bool IsBlockingFlash(optional bool treatExceptionAsNonBlocking)             
{
	if(treatExceptionAsNonBlocking) // needed to cycle through from commandpanel popup to commandpanel popup
	{
		if(self.IsA('H7SpellbookCntl') || self.IsA('H7QuestLogCntl')) return false;
	}
	return mBlockFlash;
}

function bool Initialize()
{
	super.Initialize();

	InitWindowKeyBinds();

	GetHUD().SetFrameTimer(1,StopAdvance);

	return true;
}

// TODO refactor switch to be popup1.open popup1.close popup2.open (atm is: popup1.open popup2.open popup1.close)
function bool OpenPopup() // Request, can be denied and go into queue
{
	local H7GFxUIContainer popup;
	if(CanOpenPopup())
	{
		popup = GetPopup();
		popup.SetVisibleSave(true);
		StartAdvance();
		GetHUD().PopupWasOpened(self);
		GetHUD().SetFocusMovie(self);
		GetPopup().PlayOpenAnimationNextFrame();
		if(IsFullscreen())
		{
			GetHUD().GetSpellbookCntl().GetQuickBar().SetVisibleSave(false);
			GetHUD().GetLogCntl().GetLog().SetVisibleSave(false);
			GetHUD().GetLogCntl().GetBorderBlack().SetVisibleSave(true);
			GetHUD().GetLogCntl().GetQALog().SetVisibleSave(false);
			if(!H7Adventurehud(GetHUD()).GetTownHudCntl().IsInAnyScreen())
			{
				H7Adventurehud(GetHUD()).GetAdventureHudCntl().GetTownList().SetVisibleSave(false);
			}
			
			//multiplayer gui
			if(class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() || (class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().IsHotSeat()))
			{
				class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetMPTurnInfo().SwitchToFullScreen();
			}
		}
		//multiplayer gui
		if((class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() || (class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().IsHotSeat()))
			&& (self.IsA('H7QuestLogCntl') || self.IsA('H7HeroTradeWindowCntl')))
		{
			class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetMPTurnInfo().SwitchToFullScreen();
		}
		mOpenedThisFrame = true;
		GetHUD().SetFrameTimer(1,ResetOpenedThisFrame);
		return true;
	}
	else
	{
		if(H7IQueueable(self) == none)
		{
			//`gamelog(self @ "can not open and not queue",MD_QA_LOG);
			;
		}
		return false;
	}
}

function bool CanOpenPopup()
{
	return class'H7PlayerController'.static.GetPlayerController().GetHud().CanOpenPopup(self);
}

function PutPopupIntoQueue(H7PopupParameters params,EPlayerNumber recipient, optional EMessageCreationContext creationContext = MCC_UNKNOWN)
{
	local H7Message message;

	message = new class'H7Message';
	message.settings.popupParams = params;
	message.settings.referenceWindowCntl = self;
	message.destination = MD_POPUP;
	message.mPlayerNumber = recipient;
	message.creationContext = creationContext;

	class'H7MessageSystem'.static.GetInstance().SendMessage(message);
}

// called when a queued popup can finally open
function QueueFinished(H7Message message)
{
	// popup has to read it's opening-state-data from a message and open itself with it
	if(H7IQueueable(self) != none)
	{
		H7IQueueable(self).OpenPopupFromQueue(message.settings.popupParams);
	}
	else
	{
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(self @ "can not open via message",MD_QA_LOG);;
		;
	}
}

function ClosePopup()
{
	//`log_dui("trying to stop" @ self @ "in 10 frame bc close");
	GetHUD().SetFrameTimer(10,StopAdvance); // in theory we need 1 frame update the visibility, but that has 10% chance of not firing MouseOut events, so we go with 2 frames, now 10 just to be sure #YOLO
	GetPopup().SetVisibleSave(false);
	StartAdvance();
 	GetPopup().Reset();
	GetHud().PopupWasClosed();
	if(self.IsA('H7RequestPopupCntl') && GetHUD().GetCurrentContext() != none)
	{
		GetHUD().SetFocusMovie(GetHUD().GetCurrentContext());
	}
	else
	{
		GetHUD().SetFocusMovie(none);
	}
	if(IsFullscreen())
	{
		if(class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() && !class'H7TownHudCntl'.static.GetInstance().IsInAnyScreen())
		{
			GetHUD().GetLogCntl().GetBorderBlack().SetVisibleSave(false);
			GetHUD().GetLogCntl().GetLog().SetVisibleSave(true);
			if(GetHUD().GetSpellbookCntl().GetQuickBar() != none) GetHUD().GetSpellbookCntl().GetQuickBar().SetVisibleSave(true);
		}
		else if(class'H7ReplicationInfo'.static.GetInstance().IsCouncilMap())
		{
			GetHUD().GetLogCntl().GetBorderBlack().SetVisibleSave(false);
		}
		GetHUD().GetLogCntl().GetQALog().SetVisibleSave(true);
		if(class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() && GetHUD().GetHUDMode() == HM_NORMAL)
		{
			H7Adventurehud(GetHUD()).GetAdventureHudCntl().GetTownList().SetVisibleSave(true);
		}

		//multiplayer gui
		if((class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() || (class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().IsHotSeat()))
		   && !self.IsA('H7FlashMovieTownPopupCntl'))
		{
			class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetMPTurnInfo().SwitchToHUD();
		}
	}

	//multiplayer gui
	if((class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() || (class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().IsHotSeat()))
		&& (self.IsA('H7QuestLogCntl') || self.IsA('H7HeroTradeWindowCntl')))
	{
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetMPTurnInfo().SwitchToHUD();
	}

	mWasCanceled = false;
}

function Closed() // with flash close button
{
	ClosePopup();
}

function H7GFxUIContainer GetPopup() // TODO GFxPopup
{
	;
	return none;
}

////////////////////////////////////////////////////////////////////////////////////////////
// keybindings
////////////////////////////////////////////////////////////////////////////////////////////

// called in main Initialize, extended by children
function InitWindowKeyBinds()
{
	local H7Keybind keybindWithCategory;
	
	foreach mWindowSpecificKeybinds(keybindWithCategory)
	{
		class'H7KeybindManager'.static.GetInstance().AddPopupKeybindToManager(keybindWithCategory);
	}

	// order the newly added keybinds
	class'H7KeybindManager'.static.GetInstance().OrderList();

	// TODO could be laggy if every popup refreshes
	class'H7OptionsManager'.static.GetInstance().CreateOptionsFromKeybinds();
}

// OPTIONAL add alt,ctrl,shift support for defaults
// TODO secondaryKey seems not to work, investigate why
function CreatePopupKeybind(Name key,String command,delegate<H7KeybindManager.KeybindFunctionDelegate> keybindFunction = none,optional Name secondaryKey)
{
	local H7Keybind defaultPopupKeybind,finalPopupKeybind;
	
	defaultPopupKeybind.keybind.Name = key;
	defaultPopupKeybind.keybind.Command = command;
	defaultPopupKeybind.keybindFunction = keybindFunction;
	defaultPopupKeybind.secondaryKeybind.Name = secondaryKey;
	defaultPopupKeybind.secondaryKeybind.Command = command;
	defaultPopupKeybind.category = mKeybindCategory;

	finalPopupKeybind = WriteUserKeysInto(defaultPopupKeybind);

	mWindowSpecificKeybinds.AddItem(finalPopupKeybind);
}

// code starts with the default keybind and then writes current user settings into it
function H7Keybind WriteUserKeysInto(H7Keybind defaultPopupKeybind)
{
	local H7PopupKeybindings userPopupKeybinds; // ini file
	local H7Keybind finalPopupKeybind;
	local KeyCommand userPopupKeybind;
	local int i;
	local bool found;
	
	userPopupKeybinds = class'H7KeybindManager'.static.GetInstance().GetPopupKeybindingUserSettings();
	foreach userPopupKeybinds.mPopupKeybindings(userPopupKeybind,i)
	{
		if(userPopupKeybind.command == defaultPopupKeybind.keybind.Command)
		{
			// fix for corrupted entries ' ' saved on release; user wanted to delete them, so we properly set them to ''
			if(userPopupKeybind.keyPrimary.Name == ' ') userPopupKeybind.keyPrimary.Name = '';
			if(userPopupKeybind.keySecondary.Name == ' ') userPopupKeybind.keySecondary.Name = '';

			finalPopupKeybind = defaultPopupKeybind;
			finalPopupKeybind.keybind = userPopupKeybind.keyPrimary;
			finalPopupKeybind.secondaryKeybind = userPopupKeybind.keySecondary;
			found = true;
		}
	}

	if(!found) // new default popup that is not yet in the user's ini file or the user deleted it
	{
		finalPopupKeybind = defaultPopupKeybind;
		userPopupKeybind.command = defaultPopupKeybind.keybind.Command;
		userPopupKeybind.keyPrimary = defaultPopupKeybind.keybind;
		userPopupKeybind.keySecondary = defaultPopupKeybind.secondaryKeybind;
		userPopupKeybinds.mPopupKeybindings.AddItem(userPopupKeybind);
	}

	userPopupKeybinds.SaveConfig();

	return finalPopupKeybind;
}


function bool KeybindUsedByPopup(Keybind key)
{
	local array<H7Keybind> keybinds;
	local H7Keybind keybindEntry;

	keybinds = class'H7KeybindManager'.static.GetInstance().GetKeybindListByCategory(mKeybindCategory);

	//`log_dui(self @ "KeybindUsedByPopup? of " @ mKeybindCategory @ "=" @ keybinds.Length);

	//if(keybinds.Length == 0) `log_dui("no popup keybindings found");

	foreach keybinds(keybindEntry)
	{
		if( (keybindEntry.keybind.Name == key.Name && keybindEntry.keybind.Shift == key.Shift && keybindEntry.keybind.Control == key.Control && keybindEntry.keybind.Alt == key.Alt)
			|| 
			(keybindEntry.secondaryKeybind.Name == key.Name && keybindEntry.secondaryKeybind.Shift == key.Shift && keybindEntry.secondaryKeybind.Control == key.Control && keybindEntry.secondaryKeybind.Alt == key.Alt)
		)
		{
			if(keybindEntry.keybindFunction != none)
			{
				;
				class'H7KeybindManager'.static.GetInstance().CallKeybindFunction(keybindEntry);
			}
			else
			{
				;
				// call exec function manually, even though keybind might not be in real live unreal ini list
				ConsoleCommand(keybindEntry.keybind.Command); // OPTIONAL if alias, call alias exec function, popup keybinds don't link to alias for now
			}
			return true;
		}
	}

	return false;
}

