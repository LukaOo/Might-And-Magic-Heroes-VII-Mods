//=============================================================================
// H7FlashMovieCntl
//
// Here goes what is common to all flash-movies (localize,settings,sound,mouse,...)
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7FlashMovieCntl extends GFxMoviePlayer
	dependson(H7StructsAndEnumsNative)
	native;

var protected H7PlayerController mPlayerController; // short cut reference
var protected Array<String> mLocaSection;
var protected GFxObject mRootMC;
var protected H7GFxFlashController mFlashController;
var protected int mFlashWidth,mFlashHeight;
var protected bool mWasInitialized;
var protected bool mIsDragginUnit;
var protected bool mIsShowingBlocklayer;
var protected bool mWasCanceled;

var protected H7ContainerCntl mContainer;

function GFxObject GetRoot() { return mRootMC; }
function bool WasInitialized() { return mWasInitialized; }
function SetInitialized() { mWasInitialized = true; }
function SetWasCanceled(bool canceled) { mWasCanceled = canceled; }
function SetPlayerOwner(  H7PlayerController player ) { mPlayerController = player; }
function H7ContainerCntl GetContainer() { return mContainer; }
function H7GFxFlashController GetFlashController(optional bool verbose=true)
{	
	local H7GFxFlashController contr;
	if(mFlashController != none) contr = mFlashController;
	else if(mContainer != none) contr = mContainer.GetFlashController(verbose);
	if(contr == none && verbose) ;
	return contr;
}
function H7Hud GetHUD()
{
	if(mPlayerController == none) mPlayerController = class'H7PlayerController'.static.GetPlayerController();
	return mPlayerController.GetHud();
}

/////////////////////////////////////////////////////////////////////////////////////////////////// 
// Init ///////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////// 

function bool Start(optional bool StartPaused)
{
	local bool success;

	GetHUD().LogStart(self);

	success = Super.Start(StartPaused);
	return success;
}

function AdvanceDebug(float time)
{
	Advance(time);
	mRootMC = GetVariableObject("root");
}

// overwrite this children, but make sure to call Super.Initialize();
function bool Initialize() 
{
	Advance(0); // this advance is needed to execute all SetVisibleSave(false); of the initialization
	mWasInitialized = true;

	if( mRootMC != none )
	{
		mFlashController = H7GFxFlashController(mRootMC.GetObject("aMovieController", class'H7GFxFlashController'));
	}
	if(mFlashController == none) ;
	GetHUD().LogEnd(self);

	SetPriority(1);

	return true;
}

/////////////////////////////////////////////////////////////////////////////////////////////////// 
// Tick & Advance /////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////// 

function bool CanBeStopped()
{
	if(!GetHUD().bShowHUD)
	{
		return false; // don't stop movies while hidden hud, because they need to tick once more afterwards to update their visual/visibility states
	}
	if(H7FlashMoviePopupCntl(self) != none) 
	{
		if(H7FlashMoviePopupCntl(self).GetPopup() != none && H7FlashMoviePopupCntl(self).GetPopup().IsVisible()) return false; // has a visible popup
	}
	if(mContainer != none)
	{
		return false; // it's inside a container, container never stops (see below)
	}
	if(mFlashController != none)
	{
		if(mFlashController.IsShowingBlockLayer()) return false;
	}
	if(H7ContainerCntl(self) != none)
	{
		// Container can only stop when nothing in it is visible, but we can not checked that easily, so:
		return false; // Container never stops for now, stopping causes too many issues
	}
	return true;
}

function StopAdvance()
{
	if(!CanBeStopped()) return;

	if(mContainer != none) 
	{
		//`log_pui("StopAdvance" @ mContainer @ "due to" @ self);
		mContainer.StopAdvance();
	}
	else if(!GetPause()) 
	{
		//`log_pui("StopAdvance" @ self);
		StopInput();
		GetHUD().SetFrameTimer(2,StopAdvanceReally);
	}
}

function StopAdvanceReally()
{
	if(!CanBeStopped()) return;
	// totally buggy, mouse clicks are queued on any stopped popup and executed when resuming, but we block it in flash now
	SetPause(true);
}

function StopInput() // did not work
{
	bAllowInput = false;
	bIgnoreMouseInput = true;
}

function StartAdvance()
{
	if(mContainer != none) 
	{
		//`log_pui("StartAdvance" @ mContainer @ "due to" @ self);
		mContainer.StartAdvance();
	}
	else 
	{
		;
		SetPause(false);
		bAllowInput = true;
		bIgnoreMouseInput = false;
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////// 
// Input //////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////// 

function RequestBlockBelow() // this is an invisible block, for the townlist
{
	GetHUD().BlockFlashBelow(self,false); // invisible block; will unfortunately kill the visible block if there was one

	if(GetHUD().GetCurrentContext() != none && GetHUD().GetCurrentContext().IsBlockingFlash()) // re-established visible block that was there before
	{
		GetHUD().BlockFlashBelow(GetHUD().GetCurrentContext());
	}
}

function RequestUnBlockBelow() // this is an invisible block, for the townlist
{
	if(GetHUD().GetPauseMenuCntl().GetPauseMenu().IsVisible()) return; // request denied, pause menu is open

	GetHUD().UnblockAllFlashMovies();

	if(GetHUD().GetCurrentContext() != none && GetHUD().GetCurrentContext().IsBlockingFlash()) // re-established limited block below open popup
	{
		GetHUD().BlockFlashBelow(GetHUD().GetCurrentContext());
	}
}

// Fake Focus
function RequestFocus()
{
	;
	if(!GetHUD().IsAllowFocus()) { ; return; } // don't allow focus on game start
	
	GetHUD().SetFocusMovie(self);
	// if popup is in container, it will redirect GetFlashController requests to the container, but it can stay in hud.focus for all intents and purposes
}
function WaiveFocus()
{
	GetHUD().SetFocusMovie(none);
}

// Real Focus
function RequestRealFocus()
{
	;
	if(!GetHUD().IsAllowFocus()) { ; return; } // don't allow focus on game start
	
	GetHUD().SetFocusMovie(self);
	SetPriority(50);
}
function WaiveRealFocus()
{
	;
	if(GetHUD().GetFocusMovie() != self) { ; return; }

	GetHUD().SetFocusMovie(none);
	SetPriority(0);
}

function DisableMouse(optional bool showBlockLayer=true)
{
	// can not show blocklayers in H7FlashMovieBlockPopupCntl because they change there position when activated/deactivated with SetPriority()
	if(mFlashController == none || IsA('H7FlashMovieBlockPopupCntl'))
	{
		if(showBlockLayer) // I was ordered to show the block-layer, but can't, so tell the movie below me, to show it
		{
			GetHUD().BlockFlashBelow(self);
		}
	}
	else
	{
		// doing our own solution
		if(showBlockLayer) 
		{
			StartAdvance();
			//`log_dui("Showing blocklayer in" @ self);
		}
		mIsShowingBlocklayer = showBlockLayer;
		mFlashController.BlockEntireFlashMovie(showBlockLayer);
	}
}

function EnableMouse()
{
	if(mFlashController != none)
	{
		if(mIsShowingBlocklayer)
		{
			// StartAdvance(); // fail safe hack because sometimes movies showing blocklayers are stopped, not needed, for now
			//`log_dui("Hiding blocklayer in" @ self);
		}
		mFlashController.FreeEntireFlashMovie();
		mIsShowingBlocklayer = false;
	}
}

function MouseOver()
{
	//`log_dui("MouseOver" @ self);
	mPlayerController.HUDMouseOver();
}

function MouseOut()
{
	//`log_dui("MouseOut" @ self);
	mPlayerController.HUDMouseOut();
}

function bool IsRightMouseDown(optional GFxObject object)
{
	//`log_gui("isRigthMouseDown getHUD"@GetHUD());
	if(GetHUD().GetRightMouseDown())
	{
		//`log_dui("right click unreal");
		return true;
	}
	else
	{
		//`log_dui("no right click unreal");
		return false;
	}
}

function bool IsShiftDown()
{
	return class'H7PlayerController'.static.GetPlayerController().IsShiftDown();
}

function bool IsRightClickThisFrame() // up-click or down-click this frame
{
	return GetHUD().IsRightClickThisFrame();
}

function CaptureMouseWheel(bool val)
{
	mPlayerController.CaptureMouseWheel(val);
}

/////////////////////////////////////////////////////////////////////////////////////////////////// 
// Sound //////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////// 

function PlayGUISound(String str)
{
	if(class'H7GUISoundPlayer'.static.GetInstance()==none)return;
	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr( str );
}

/////////////////////////////////////////////////////////////////////////////////////////////////// 
// Assets /////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////// 

function String GetRadioButtonSymbolPath(int id)
{
	switch(id)
	{
		case 1: return GetFlashPath(class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mButtonIcons.mCheckDone);
		case 2: return GetFlashPath(class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mButtonIcons.mCheckFailed);
		case 3: return GetFlashPath(class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mButtonIcons.mCheckActive);
	}
	return "";
}

function String GetMagicTierSymbol(int tier)
{
	switch(tier)
	{
		case 0: return GetFlashPath(class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mButtonIcons.mUnskilled);
		case 1: return GetFlashPath(class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mButtonIcons.mNovice);
		case 2: return GetFlashPath(class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mButtonIcons.mExpert);
		case 3: return GetFlashPath(class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mButtonIcons.mMaster);
		case 4: return GetFlashPath(class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mButtonIcons.mRomanFive);
	}
	return "";
}

function String GetFlashPath(Texture2D asset)
{
	return "img://" $ PathName(asset);
}

function String GetAssetPath(String key)
{
	local Texture2d asset;
	local H7ButtonIcons icons;
	icons = class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mButtonIcons;

	switch(key)
	{
		case "BTN_SKILLWHEEL":asset = icons.mSkillwheel; break;
	
		case "BTN_PLUS":asset = Texture2D'H7ButtonIcons.ICO_add';break;
		case "BTN_MINUS":asset = Texture2D'H7ButtonIcons.ICO_subtract';break;
		case "BTN_SWITCH":asset = Texture2D'H7ButtonIcons.ICO_unit_SwitchUpgraded';break;
		case "BTN_FORWARD":asset = icons.mForward;break;
		case "BTN_BACKWARD":asset = icons.mBackward;break;
		case "BTN_PAUSE":asset = icons.mPause;break; 
		case "BTN_PLAY":asset = icons.mPlay;break;
		case "BTN_UPGRADE":asset = icons.mUpgrade;break;
		case "BTN_UPGRADE_GREEN":asset = icons.mUpgradeGreen;break;

		case "ARROW_LEFT":asset = icons.mLeft;break;
		case "ARROW_RIGHT":asset = icons.mRight;break;
		case "ARROW_UP":asset = icons.mUp;break;
		case "ARROW_DOWN":asset = icons.mDown;break;
		
		case "KICK":asset = icons.mKick;break;
		case "SETTING":asset = icons.mSetting;break;
		case "REFRESH":asset = icons.mRefresh;break;
		case "ALLHEROES":asset = icons.mAllHeroes;break;
		case "ATTACKER":asset = icons.mAttacker;break;
		case "DEFENDER":asset = icons.mDefender;break;
		case "HUMAN":asset = icons.mHuman;break;
		case "AI":asset = icons.mAI;break;

		case "FILTER_CLEAR":asset = icons.mCheckActive;break;
		case "FILTER_SAVE_ALL":asset = icons.mSaveAll;break;
		case "FILTER_SAVE_CAMPAIGN":asset = icons.mSaveCampaign;break;
		case "FILTER_SAVE_CUSTOM":asset = icons.mSaveCustom;break;
		case "FILTER_SAVE_HOTSEAT":asset = icons.mSaveHotseat;break;
		case "FILTER_SAVE_MULTIPLAYER":asset = icons.mSaveMultiplayer;break;
		

		case "STAT_MANA":asset = class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mStatIcons.GetStatIconByStr(key);break;
		// OPTIONAL other stats

		default: ;
	}

	return GetFlashPath(asset);
}

function String GetGUIColor()
{
	local Color playerColor;

	if(class'H7AdventureController'.static.GetInstance() != none)
	{
		playerColor = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetColor();
		return UnrealColorToFlashColor(playerColor);
	}
	else if(class'H7CombatController'.static.GetInstance() != none)
	{
		if(class'H7CombatController'.static.GetInstance().GetCurrentlyDeployingArmy() != none)
		{
			playerColor = class'H7CombatController'.static.GetInstance().GetCurrentlyDeployingArmy().GetPlayer().GetColor();
		}
		else if(class'H7CombatController'.static.GetInstance().GetLocalPlayer() != none)
		{
			playerColor = class'H7CombatController'.static.GetInstance().GetLocalPlayer().GetColor();
		}
		return UnrealColorToFlashColor(playerColor);
	}
	else if(class'WorldInfo'.static.GetWorldInfo().Game != none && class'H7CouncilManager'.static.GetInstance() != none)
	{
		// in council the color is the color of the current campaign councilor
		if(class'H7PlayerProfile'.static.GetInstance().HasCurrentCampaign() && class'H7DialogCntl'.static.GetInstance().GetSelectedCampaign() != none)
		{
			playerColor = class'H7DialogCntl'.static.GetInstance().GetSelectedCampaign().GetCouncillor().GetColor();
			return UnrealColorToFlashColor(playerColor);
		}
	}
	
	// nothing available, fall back to orange
	playerColor = MakeColor(255,153,0,255);
	return UnrealColorToFlashColor(playerColor);
}

/////////////////////////////////////////////////////////////////////////////////////////////////// 
// Localize ///////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////// 

function String FlashLocalize(String locaKey,optional String keybindingCommand,optional bool replaceIcons)
{
	local String localizedString;
	local int i;

	if(Len(locaKey) == 0) localizedString = "";
	else if(!class'H7Loca'.static.IsLocaKey(locaKey)) localizedString = locaKey; // if it is not a loca key we return it as is and hope it already is ok (prev, we did {} around it)
	else
	{
		//`log_dui("loca:" @ locaKey @ mLocaSection);

		if(class'H7GUIGeneralProperties'.static.GetInstance().GetOptionShowLocaKeys())
		{
			return locaKey;
		}

		// first look in the section that is linked to the current .fla file
		for(i=0; i<mLocaSection.Length; i++)
		{
			localizedString = Localize( mLocaSection[i], locaKey, "MMH7Game" );
			if(!class'H7Loca'.static.LocalizeFailed(localizedString)) break;
		}
	
		if(class'H7Loca'.static.LocalizeFailed(localizedString)) 
		{	
			// section lookup failed, try again in general section
			localizedString = Localize( "H7General", locaKey, "MMH7Game" );
		
			if(class'H7Loca'.static.LocalizeFailed(localizedString)) 
			{
				// failed again in general, give up:
				localizedString = "[" $ locaKey $ "]";
				;
			}
		}
	}

	// add a keybind character into or after it:
	if(keybindingCommand != "")
	{
		return class'H7PlayerController'.static.GetPlayerController().GetHTMLWithKeyBind(localizedString,keybindingCommand);
	}

	if(replaceIcons)
	{
		localizedString = class'H7Loca'.static.ResolveIconPlaceholders(localizedString);
	}

	return localizedString;
}

/////////////////////////////////////////////////////////////////////////////////////////////////// 
// Settings/Options /////////////////////////////////////////////////////////////////////////////// 
/////////////////////////////////////////////////////////////////////////////////////////////////// 

function bool GetSettingBool(String key)
{
	//`log_dui("GetSettingBool" @ key);
	return class'H7OptionsManager'.static.GetInstance().GetSettingBool(key);
}

function float GetSettingNumber(String key)
{
	//`log_dui("GetSettingNumber/GetSettingFloat" @ key);
	return class'H7OptionsManager'.static.GetInstance().GetSettingFloat(key); 
}

function String GetSettingEnum(String key)
{
	//`log_dui("GetSettingEnum" @ key);
	// OPTIONAL
	// (so far flash does not want to know any)
}

/////////////////////////////////////////////////////////////////////////////////////////////////// 
// General //////////////////////////////////////////////////////////////////////////////////////// 
/////////////////////////////////////////////////////////////////////////////////////////////////// 

function Log(string message)
{
	;
}

function bool Unreal()
{
	return true;
}

function bool IsDraggingUnit()
{
	return mIsDragginUnit;
}

function String UnrealColorToFlashColor(Color unrealColor)
{
	return "0x" $ UnrealColorToHex(unrealColor);
}

function String UnrealColorToHTMLColor(Color unrealColor)
{
	return "#" $ UnrealColorToHex(unrealColor);
}

function String UnrealColorToHex(Color unrealColor)
{
	local String flashStr;
	
	flashStr = ToHex((unrealColor.R * 16**4) + (unrealColor.G * 16**2) + unrealColor.B);
	flashStr = Mid(flashStr,2);

	return flashStr;
}

function OpenHeropediaWithHero(string archetypeID)
{
	GetHud().GetHeropedia().OpenWithHero(archetypeID);
}

function OpenHeropediaWithCreature(string stringID)
{
	GetHUD().GetHeropedia().OpenWithCreature(stringID);
}

/////////////////////////////////////////////////////////////////////////////////////////////////// 
// Resolution ///////////////////////////////////////////////////////////////////////////////////// 
/////////////////////////////////////////////////////////////////////////////////////////////////// 

function SetConstraints(int minX,int minY,int maxX,int maxY)
{
	if(mFlashController == none)
	{
		//`log_gui(self @ "has no FlashController");
	}
	else
	{
		mFlashController.SetConstraints(minX,minY,maxX,maxY);
	}
}

function Vector2D FlashPixels2UnrealPixels(Vector2D flashPixels)
{
	// OPTIONAL if neccessary
}

// gets the size of the flash scene area like it was created in the .fla file
function IntPoint GetFlashSize()
{
	local IntPoint flashSize;
	if(mFlashWidth == 0)
	{
		if(mContainer != none) mContainer.GetVariableInt("loaderInfo.width");
		else mFlashWidth = GetVariableInt("loaderInfo.width");
	}
	if(mFlashHeight == 0)
	{
		if(mContainer != none) mFlashHeight = mContainer.GetVariableInt("loaderInfo.height");
		else mFlashHeight = GetVariableInt("loaderInfo.height");
	}

	if(mFlashWidth == 0 || mFlashHeight == 0)
	{
		mFlashWidth = 1920;
		mFlashHeight = 1080;
	}

	flashSize.X = mFlashWidth;
	flashSize.Y = mFlashHeight;
	return flashSize;
}

// This calculation assumes projection mode: SHOW_ALL
// OPTIONAL move calculation into flash, so GetFlashSize is not needed anymore
function Vector2D UnrealPixels2FlashPixels(Vector2D unrealPixels)
{
	local Vector2D project, screen, flash, scaledFlash, calculatedPos, borders, finalFlash;
	local float scale;
	local Intpoint flashSize;
	
	if(GetHUD()==none) return calculatedPos;

	screen = GetHUD().GetUnrealSize();

	flashSize = GetFlashSize();
	flash.X = flashSize.X;
	flash.Y = flashSize.Y;

	if(flash.X == 0 || flash.Y == 0) 
	{
		;
		return flash;
	}

	project.X = screen.X / flash.X;
	project.Y = screen.Y / flash.Y;

	// find smaller projection 
	scale = (project.X<project.Y)? project.X : project.Y; // 1.19166666 // (!) min() does not work for some reason
	
	scaledFlash.X = flash.X * scale; // 953.3333333 in unreal pixels
	scaledFlash.Y = flash.Y * scale; // 715 in unreal pixels
	
	// find out where the borders are ; leftright or updown
	borders.X = (screen.X - scaledFlash.X) / 2; // 160 in unreal pixels
	borders.Y = (screen.Y - scaledFlash.Y) / 2; // 0 in unreal pixels
		
	// convert borders to flash pixels
	if( scale != 0.f )
	{
		borders.X /= scale; // 134 in flash pixels
		borders.Y /= scale; // 0 in flash pixels  
	}

	// calculate dimensions of flash pixels that overlay all of the window
	finalFlash.X = flash.X + borders.X*2; // 1068
	finalFlash.Y = flash.Y + borders.Y*2; // 600
	
	// project unreal pixels onto final flash area
	calculatedPos.X = (finalFlash.X / screen.X) * unrealPixels.X; // flash pixels
	calculatedPos.Y = (finalFlash.Y / screen.Y) * unrealPixels.Y; // flash pixels

	// offset by border
	calculatedPos.X -= borders.X;
	calculatedPos.Y -= borders.Y;

	return calculatedPos;
}

function ClosePopup()
{
	;
}

/////////////////////////////////////////////////////////////////////////////////////////////////// 
// Popups ///////////////////////////////////////////////////////////////////////////////////////// 
/////////////////////////////////////////////////////////////////////////////////////////////////// 

// code in child H7FlashMoviePopupCntl extends H7FlashMovieCntl;

/////////////////////////////////////////////////////////////////////////////////////////////////// 
// Keybindings ////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////// 

// flash has intercepted a keypress, unreal should handle it
// - should not be send if flash uses the key (for input fields, or keybindings-assignments)
// - first it checks if the current window has a function for it
// - if not, we send it to unreal and let it do an exec function
// Order:
// real focus - flash (input fields)
// real focus - unreal (popup keybinds)
// fake focus - flash (input fields, keybind listener)
// fake focus - unreal (popup keybinds)
function AnyKeyPressed(String unrealKeyName, int flashKeyCode, int flashCharCode, bool shift, bool control, bool alt)
{
	local int flashUsedIt;
	local H7FlashMovieCntl focusMovie;
	local Keybind key;

	;

	if(IsMovieSkippedLastFrame()) return;

	key.Name = Name(unrealKeyName);
	key.Shift = shift;
	key.Control = control;
	key.Alt = alt;

	// 1) popup uses it as popup-keybind

	if(self.IsA('H7FlashMovieBlockPopupCntl') && H7FlashMovieBlockPopupCntl(self).KeybindUsedByPopup(key)) return;

	if(GetHUD().GetFocusMovie() == self)
	{
		// apparently I was the highest priority real focus movie, so I already got the key input properly, no need to fake it
		// but I did not use it, if I had used it, I would not have called Unreal with AnyKeyPressed;
		// also unreal got it in parallel, so I can discard it here completely since Unreal works with the copy now
		//`log_dui("return; (self=focus)");
		return;
	}

	// 2) other flash movie uses it in input fields or as key assignments (recruitment,optionsmenu)
	focusMovie = GetHUD().GetFocusMovie();
	if(focusMovie != none) 
	{
		if(H7FlashMoviePopupCntl(focusMovie) != none && H7FlashMoviePopupCntl(focusMovie).WasOpenedThisFrame())
		{
			// popups don't process keyinputs when they were opened this frame
			return;
		}
		;
		flashUsedIt = focusMovie.GetFlashController().TriggerKeyboardEvent(true,flashKeyCode,flashCharCode,shift,control,alt);
		if(flashUsedIt == 1) 
		{
			;
			return;
		}
		else
		{
			//`log_dui("focus movie flash did not use it");
			if(focusMovie.IsA('H7FlashMoviePopupCntl') && H7FlashMoviePopupCntl(focusMovie).KeybindUsedByPopup(key))
			{
				;
				return;
			}
		}
	}
	else
	{
		//`log_dui("no focus movie");
	}
}

function AnyKeyReleased(String unrealKeyName, int flashKeyCode, int flashCharCode, bool shift, bool control, bool alt)
{
	local H7FlashMovieCntl focusMovie;
	local int flashUsedIt;

	;

	if(IsMovieSkippedLastFrame()) return;

	focusMovie = GetHUD().GetFocusMovie();
	if(focusMovie == self)
	{
		return; // see analog above
	}

	if(focusMovie != none)
	{
		;
		flashUsedIt = GetHUD().GetFocusMovie().GetFlashController().TriggerKeyboardEvent(false,flashKeyCode,flashCharCode,shift,control,alt);
		;
	}

	if(flashUsedIt == 1) return;
}

function bool IsMovieSkippedLastFrame()
{
	if(class'H7AdventurePlayerController'.static.GetAdventurePlayerController() != none)
	{
		if(class'H7AdventurePlayerController'.static.GetAdventurePlayerController().IsMovieSkippedLastFrame())
		{
			;
			return true;
		}
	}
	return false;
}

/////////////////////////////////////////////////////////////////////////////////////////////////// 
// Signs&Feedback ///////////////////////////////////////////////////////////////////////////////// 
/////////////////////////////////////////////////////////////////////////////////////////////////// 

function GFxObject GetAttributeIconStrings()
{
	local GFxObject iconStrings;
	;
	iconStrings = mContainer!=none ? mContainer.CreateObject("Object") : CreateObject("Object");

	iconStrings.SetString("AttackIcon", GetHUD().GetProperties().mStatIcons.GetStatIconPath(STAT_ATTACK));
	iconStrings.SetString("DefenseIcon", GetHUD().GetProperties().mStatIcons.GetStatIconPath(STAT_DEFENSE));

	iconStrings.SetString("MagicIcon", GetHUD().GetProperties().mStatIcons.GetStatIconPath(STAT_MAGIC));
	iconStrings.SetString("SpiritIcon", GetHUD().GetProperties().mStatIcons.GetStatIconPath(STAT_SPIRIT));

	iconStrings.SetString("DestinyIcon", GetHUD().GetProperties().mStatIcons.GetDestinyIconString());
	iconStrings.SetString("LuckIcon", GetHUD().GetProperties().mStatIcons.GetLuckIconString());
	iconStrings.SetString("ManaIcon", GetHUD().GetProperties().mStatIcons.GetStatIconPath(STAT_MANA));

	iconStrings.SetString("LeadershipIcon", GetHUD().GetProperties().mStatIcons.GetLeadershipIconString());
	iconStrings.SetString("MoralIcon", GetHUD().GetProperties().mStatIcons.GetMoralIconString());

	iconStrings.SetString("RangeIcon", GetHUD().GetProperties().mStatIcons.GetStatIconPath(STAT_RANGE));
	iconStrings.SetString("InitiativeIcon", GetHUD().GetProperties().mStatIcons.GetStatIconPath(STAT_INITIATIVE));

	iconStrings.SetString("ArcaneKnowledgeIcon", GetHUD().GetProperties().mStatIcons.GetStatIconPath(STAT_ARCANE_KNOWLEDGE));
	
	iconStrings.SetString("WalkIcon", GetHUD().GetProperties().mStatIcons.GetMovementIconString(CMOVEMENT_WALK));
	iconStrings.SetString("FlyIcon", GetHUD().GetProperties().mStatIcons.GetMovementIconString(CMOVEMENT_FLY));
	iconStrings.SetString("TeleportIcon", GetHUD().GetProperties().mStatIcons.GetMovementIconString(CMOVEMENT_TELEPORT));
	iconStrings.SetString("GhostwalkIcon", GetHUD().GetProperties().mStatIcons.GetMovementIconString(CMOVEMENT_GHOSTWALK));
	iconStrings.SetString("StaticIcon", GetHUD().GetProperties().mStatIcons.GetMovementIconString(CMOVEMENT_STATIC));

	iconStrings.SetString("MightMagicIcon", GetHUD().GetProperties().mMagicSchoolIcons.GetSchoolIconPath(MIGHT));
	iconStrings.SetString("AirMagicIcon", GetHUD().GetProperties().mMagicSchoolIcons.GetSchoolIconPath(AIR_MAGIC));
	iconStrings.SetString("DarkMagicIcon", GetHUD().GetProperties().mMagicSchoolIcons.GetSchoolIconPath(DARK_MAGIC));
	iconStrings.SetString("EarthMagicIcon", GetHUD().GetProperties().mMagicSchoolIcons.GetSchoolIconPath(EARTH_MAGIC));
	iconStrings.SetString("FireMagicIcon", GetHUD().GetProperties().mMagicSchoolIcons.GetSchoolIconPath(FIRE_MAGIC));
	iconStrings.SetString("LightMagicIcon", GetHUD().GetProperties().mMagicSchoolIcons.GetSchoolIconPath(LIGHT_MAGIC));
	iconStrings.SetString("PrimeMagicIcon", GetHUD().GetProperties().mMagicSchoolIcons.GetSchoolIconPath(PRIME_MAGIC));
	iconStrings.SetString("WaterMagicIcon", GetHUD().GetProperties().mMagicSchoolIcons.GetSchoolIconPath(WATER_MAGIC));

	return iconStrings;
}

// TUTORIAL

function HighlightClicked(string containerName, string elementName)
{
	GetHUD().TriggerNoteElementClick(containerName,elementName);
}

function bool IsRemoveWhenClicked(string containerName, string elementName)
{
	return GetHUD().IsRemoveWhenClicked(containerName,elementName);
}

