//=============================================================================
// H7OptionsMenuCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7OptionsMenuCntl extends H7FlashMoviePopupCntl dependson(H7OptionsManager);

var protected H7GFxOptionsMenu mOptionsMenu;
var protected GFxCLIKWidget mOKButton;
var protected GFxCLIKWidget mCLoseButton;

var protected array<string> mConflictList;
var protected bool mRefreshKeybindingsOnSave;
var protected EWindowMode mCurrentResolutionListWindowMode;
var protected bool mCurrentResolutionListIncludeCurrent;

static function H7OptionsMenuCntl GetInstance() { return class'H7PlayerController'.static.GetPlayerController().GetHUD().GetOptionsMenuCntl(); }

function H7GFxOptionsMenu GetOptionsMenu() {return mOptionsMenu; }
function H7GFxUIContainer GetPopup(){	return mOptionsMenu;}

function bool Initialize() 
{	
	;
	// Start playing the movie
    Super.Start();
	// Initialize all objects in the movie
    AdvanceDebug(0);

	mOptionsMenu = H7GFxOptionsMenu(mRootMC.GetObject("aOptionsMenu", class'H7GFxOptionsMenu'));
	mOptionsMenu.SetVisibleSave(false);
	
	mOKButton = GFxCLIKWidget(mOptionsMenu.GetObject("mOKButton", class'GFxCLIKWidget'));
	mOKButton.AddEventListener('CLIK_click', OKButtonClick);

	mCLoseButton = GFxCLIKWidget(mOptionsMenu.GetObject("mCloseButton", class'GFxCLIKWidget'));
	mCloseButton.AddEventListener('CLIK_click', OKButtonClick);

	Super.Initialize();
	return true;
}

function bool OpenPopup()
{
	mRefreshKeybindingsOnSave = false;
	mCurrentResolutionListWindowMode = EWindowMode(class'H7PlayerController'.static.GetPlayerController().GetWindowMode());
	mCurrentResolutionListIncludeCurrent = true;

	class'H7PlayerController'.static.GetPlayerController().SetPause(true);

	mOptionsMenu.Update();
	
	return super.OpenPopup();
}

function OKButtonClick(EventData data)
{
	ClosePopup();
}

function Closed() // by X, cancel, ok
{
	;
	ClosePopup();
}

function ClosePopup() // closed by ok, x, cancel, esc
{
	mOptionsMenu.DiscardAllChanges(); // doesn't do it if OK pressed
	class'H7PlayerController'.static.GetPlayerController().SetPause(false);
	super.ClosePopup();

	if(class'H7AdventureHudCntl'.static.GetInstance() != none)
	{
		class'H7AdventureHudCntl'.static.GetInstance().GetCommandPanel().UpdateLoca();
	}
}

function SetOptionFloat(string key,float val)
{
	;
	class'H7OptionsManager'.static.GetInstance().SetSettingFloat(key,val);
}

function SetOptionBool(String key,bool val)
{
	;
	class'H7OptionsManager'.static.GetInstance().SetSettingBool(key,val);
}

function SetOptionEnum(String key,int val)
{
	;
	class'H7OptionsManager'.static.GetInstance().SetSettingEnum(key,val);
}

function bool SetOptionKeyBind(String id,bool pshift,bool palt,bool pcontrol,String pkey,bool sshift,bool salt,bool scontrol,String skey)
{
	;
	mRefreshKeybindingsOnSave = true;
	return class'H7KeybindManager'.static.GetInstance().SetKeybind(id , pshift , palt , pcontrol , pkey , sshift , salt , scontrol , skey);
}

// deprecated?
function bool CausesConflict(String id,bool shift,bool alt,bool control,String key)
{
	;
	return class'H7KeybindManager'.static.GetInstance().CausesConflict(id,key,shift,alt,control);
}

function RequestUpdate()
{
	GetHUD().SetFrameTimer(2,mOptionsMenu.Update); // wait until after buffered resolution changes have been processed
}

function Reset()
{
	;
	mRefreshKeybindingsOnSave = false;
	class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().YesNoPopup(
		FlashLocalize("RESET_QUESTION"),FlashLocalize("RESET_YES"),FlashLocalize("RESET_NO"),ResetConfirm,none);
}

function ChangeLanguage(string ext)
{
	class'H7EngineUtility'.static.SetGameLanguageExt(ext);
}

function ResetConfirm()
{
	class'H7OptionsManager'.static.GetInstance().ResetAllOptions();

	mOptionsMenu.Update();
}

// ok or apply
function SaveAllConfigs()
{
	if(mRefreshKeybindingsOnSave)
	{
		class'H7KeybindManager'.static.GetInstance().CreateSetup();

		// and refresh list in Options:
		class'H7OptionsManager'.static.GetInstance().CreateOptionsFromKeybinds();
	}
	class'H7OptionsManager'.static.GetInstance().SaveAllConfigs();
}

// evaluate/discuss:
/*
function ResetOptionsToDefaults()
{   
	

	//Default Sound Settings // TODO use values from default ini file 
	class'H7SoundController'.static.GetInstance().ResetOptions();


	//class'H7OptionsManager'.static.GetInstance().SaveAllConfigs();
	return;

	class'H7SoundController'.static.GetInstance().SetMusicVolume(0.75);
	class'H7SoundController'.static.GetInstance().SetSoundVolume(0.75);
	class'H7SoundController'.static.GetInstance().SetAmbientSoundVolume(0.75);
	class'H7SoundController'.static.GetInstance().SetVoiceOverVolume(0.75);
	class'H7SoundController'.static.GetInstance().SetMasterVolumeSettings(0.75);
	class'H7SoundController'.static.GetInstance().SetSoundSetting(true);
	class'H7SoundController'.static.GetInstance().SetMusicSetting(true);
	class'H7SoundController'.static.GetInstance().SetAmbientSoundSettings(true);
	class'H7SoundController'.static.GetInstance().SetVoiceOverSetting(true);
	class'H7SoundController'.static.GetInstance().SetMasterSettings(true);
	//Default GameSpeed
	class'H7ReplicationInfo'.static.GetInstance().ModifyGameSpeed( float(200)/100.f );
	//Default Resolution
	class'H7PlayerController'.static.GetPlayerController().ConsoleCommand("SETRES " @ "1024x768" $ "w"); // "f"
	//Default AA
	class'H7ReplicationInfo'.static.GetInstance().GetPostprocessManager().SetAA(false);
	//Default PostProcess
	class'H7ReplicationInfo'.static.GetInstance().GetPostprocessManager().SetPostProcessQuality(1);
}
*/

///////////////////////////////////////////////////////////////////////////////////////////////////
// Conflict

function PrepareConflict()
{
	mConflictList.Length = 0;
}

function AddConflict(string optionName)
{
	mConflictList.AddItem(optionName);
}

function WarnConflict()
{
	local string message,conflictName;

	if(mConflictList.Length == 0) return;

	message = class'H7Loca'.static.LocalizeSave("PU_KEY_CONFLICT","H7Popup");
	foreach mConflictList(conflictName)
	{
		message = message $ "\n" $ class'H7Loca'.static.LocalizeSave(conflictName,"H7OptionsMenu");
	}

	class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().OKPopup(message,"OK",none);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Special systems

function RefreshResolutionList(int windowMode)
{
	mCurrentResolutionListWindowMode = EWindowMode(windowMode);
	mCurrentResolutionListIncludeCurrent = false;
	mOptionsMenu.RefreshResolutionList(windowMode);
}

function EWindowMode GetCurrentResolutionListWindowMode()
{
	return mCurrentResolutionListWindowMode;
}

function bool GetCurrentResolutionListIncludeCurrent()
{
	return mCurrentResolutionListIncludeCurrent;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// VirtualKeyToChar

function string VirtualKeyToChar(int keyCode)
{
	local string displayString;
	local bool success;

	success = class'H7EngineUtility'.static.VirtualKeyToChar(keyCode,displayString);
	
	if(success) return displayString;
	else return string(keycode);
}

