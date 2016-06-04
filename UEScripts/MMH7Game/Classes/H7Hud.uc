//=============================================================================
// H7Hud
//
// Here goes what is common to all the huds: Combat-HUD, Adventure-HUD, Town-HUD
// 
// A hud consist of multiple flash-movies (=GFXMoviePlayer) on top of each other
//
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7Hud extends HUD;

struct H7StartupEntry
{
	var String movieName;
	var int duration;
};

struct H7TutorialClickListener
{
	var H7SeqAct_HighlightGUIElement node;
	var string containerName;
	var string elementName;
};

struct H7FrameTimer
{
	var int framesToWait;
	var delegate<OnFrameReached> callbackFunction;
};

struct H7SecondsTimer
{
	var float secondsToWait;
	var delegate<OnFrameReached> callbackFunction;
};

// General
var protected WorldInfo mWorld; // shortcut reference
var protected Vector2D mOldRes;
var protected int mUnrealWidth,mUnrealHeight;
var protected int mFramesDone;
var protected bool mDelayInit;
var protected int mFinishHudAtFrame;
var protected bool mIsLoaded;
var protected bool mRightClickThisFrame;
var protected bool mRightMouseDown;
var protected bool mLeftMouseDown;
var protected bool mLeftClickThisFrame;
var protected bool mTickFunctionality;
var protected bool mTickFunctionalityInited;
var protected H7FCTController mFCTController;
var protected H7ListeningManager mListeningManager;
var protected int mRightMouseDownSince;
var protected int mLeftMouseDownSince;
var protected H7FlashMovieCntl mCurrentLoadingMovie;
var protected int mCurrentLoadingMovieStartTime;
var protected array<H7StartupEntry> mStartupLog;
var protected EHUDMode mHudMode;
var protected array<H7TutorialClickListener> mTutorialClickListeners;
var protected bool mPreventAllPendingHighlights;

// Settings
var protected H7GUIGeneralProperties mProperties;

// List of Flash Movies in this HUD:
var protected array<H7FlashMovieCntl> mMovies;
var protected array<H7FlashMovieCntl> mMoviesToDelete;
var protected H7MouseCntl mMouseCntl;
var protected H7BackgroundImageCntl mBackgroundImageCntl;
var protected H7OptionsMenuCntl mOptionsMenuCntl;
var protected H7CheatWindowCntl mCheatWindowCntl;
var protected H7RequestPopupCntl mRequestPopupCntl;
var protected H7SpellbookCntl mSpellbookCntl;
var protected H7OverlaySystemCntl mOverlaySystemCntl; // over 3d world , under gui
var protected H7GUIOverlaySystemCntl mGUIOverlaySystemCntl; // over gui
var protected H7PauseMenuCntl mPauseMenuCntl;
var protected H7LoadSaveWindowCntl mLoadSaveWindowCntl;
var protected H7CombatPopUpCntl mCombatPopUpCntl;
var protected H7LoadingScreenCntl mLoadingScreenCntl;
var protected H7DialogCntl mDialogCntl;
var protected H7LogSystemCntl mLogSystemCntl;
var protected H7HeropediaCntl mHeropediaCntl;

var protected H7FlashMovieCntl mFocusMovie;

// Cursor Stuff
var protected Texture2D mCursorTexture;
var protected Rotator mCursorRotation;
var protected Texture2D mObjectTexture;
var protected Rotator mObjectRotation;
var protected bool mFirstTimeHardwareCursor;
var protected bool mOverwriteHardwareCursor;
var protected H7FlashMoviePopupCntl mCurrentContext;
var private bool mPopupWasRequester;
const ATTACK_CURSOR_OFFSET_X = -16;
const ATTACK_CURSOR_OFFSET_Y = -32;
const TACTICS_CURSOR_OFFSET_X = -16;
const TACTICS_CURSOR_OFFSET_Y = -16;

var globalconfig bool HideH7HUD;

// only children implement it
//static function H7Hud GetInstance() { return class'H7PlayerController'.static.GetPlayerController().GetHud(); }

var protected array<H7FrameTimer> mFrameTimers;
var protected array<H7SecondsTimer> mSecondsTimers;
public delegate OnFrameReached();

function H7GUIGeneralProperties         GetProperties()             {   return mProperties;         }
function H7BackgroundImageCntl          GetBackgroundImageCntl()    {   return mBackgroundImageCntl;} 
function H7OptionsMenuCntl              GetOptionsMenuCntl()        {   return mOptionsMenuCntl;    }            
function H7CheatWindowCntl              GetCheatWindowCntl()        {   return mCheatWindowCntl;    }
function H7RequestPopupCntl             GetRequestPopupCntl()       {   return mRequestPopupCntl;   }    
function H7RequestPopupCntl             GetPopupCntl()              {   return mRequestPopupCntl;   }   
function H7DialogCntl                   GetDialogCntl()             {   return mDialogCntl;   }   
function H7SpellbookCntl                GetSpellbookCntl()          {   return mSpellbookCntl;      }
function H7OverlaySystemCntl            GetOverlaySystemCntl()      {   return mOverlaySystemCntl;  }    
function H7GUIOverlaySystemCntl         GetGUIOverlaySystemCntl()   {   return mGUIOverlaySystemCntl;  }  
function H7PauseMenuCntl                GetPauseMenuCntl()          {   return mPauseMenuCntl;      }
function H7LoadSaveWindowCntl           GetLoadSaveWindowCntl()     {   return mLoadSaveWindowCntl; }
function H7CombatpopUpCntl              GetCombatPopUpCntl()        {   return mCombatPopUpCntl;    }
function H7FlashMoviePopupCntl          GetCurrentContext()         {   return mCurrentContext;     }
function H7LoadingScreenCntl            GetLoadingScreen()          {   return mLoadingScreenCntl;  }
function H7MouseCntl                    GetMouseCntl()              {   return mMouseCntl;  }
function H7LogSystemCntl                GetLogCntl()                {   return mLogSystemCntl;  }
function H7HeropediaCntl                GetHeropedia()              {   return mHeropediaCntl; }

function H7StatIcons                    GetStatIcons()              {   return mProperties.mStatIcons;          }
function H7StatIcons                    GetStatIconsInText()        {   return mProperties.mStatIconsInText;    }
function H7MagicSchoolIcons             GetSchoolIcons()            {   return mProperties.mMagicSchoolIcons;  }            

// tmp
public delegate OnHudCompleted();
function int GetFramesDones() { return mFramesDone; }



/////////////////////////////////////////////////////////////////////////////////////
// CREATION /////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
// ----------- order of calls -------
// PostBeginPlay()              - does nothing anymore, because there is no MyHud
// -- Unreal Engine sets MyHud  
// -- call Init() from outside:  
// PreInit()                    - adding base movies under
//      child.Init()            - adding movies
// PostInit()                   - adding base movies over
// InitHUD()                    - init/advance all movies
// CompleteHUD()                - hiding/callbacks/stuff
// EnableTickFunctionality()    - become alive!

// implement in children!
simulated function Init() {}

// Children have to call this at the BEGINNING of their Init()
simulated function PreInit()
{
	;

	// properties
	if( mProperties == none) // TODO why is this defined on the first break point without ever being set
	{
		mProperties = new class'H7GUIGeneralProperties';		
	}
	class'H7PatchingController'.static.GetInstance().PerformGUIPatching(mProperties);
	
	HideHUD();

	mWorld = class'WorldInfo'.static.GetWorldInfo();

	mMouseCntl = new class'H7MouseCntl';
	mOptionsMenuCntl = new class'H7OptionsMenuCntl';
	mCheatWindowCntl = new class'H7CheatWindowCntl';
	mBackgroundImageCntl = new class'H7BackgroundImageCntl';
	mRequestPopupCntl = new class'H7RequestPopupCntl';
	mSpellbookCntl = new class'H7SpellbookCntl';
	mOverlaySystemCntl = new class'H7OverlaySystemCntl';
	mPauseMenuCntl = new class'H7PauseMenuCntl';
	mCombatPopUpCntl = new class'H7CombatpopUpCntl';
	mLoadSaveWindowCntl = new class'H7LoadSaveWindowCntl';
	mLoadingScreenCntl = new class'H7LoadingScreenCntl';
	mGUIOverlaySystemCntl = new class'H7GUIOverlaySystemCntl';
	mDialogCntl = new class'H7DialogCntl';
	mLogSystemCntl = new class'H7LogSystemCntl';
	mHeropediaCntl = new class'H7HeropediaCntl';

	// Global Movies that should be UNDER everything
	mMovies.AddItem(mOverlaySystemCntl);

	// OVER HUD but BELOW WINDOWS
	//mMovies.AddItem(mBackgroundImageCntl); // --> copy this into children: over the hud, but below windows
	//mMovies.AddItem(mLogSystemCntl); // --> copy this into children: over the hud, but below windows

	//mMovies.AddItem(mSpellbookCntl); // --> copy this into children: over the hud, but below windows
	
	// children add their flas after this function in child.Init()	
}

// Children have to call this at the END of their Init()
function PostInit()
{
	;

	// children add their flas before this function
	
	// Global Movies that should be OVER everything
	mMovies.AddItem(mCombatPopUpCntl);
	mMovies.AddItem(mOptionsMenuCntl);
	mMovies.AddItem(mCheatWindowCntl);
	mMovies.AddItem(mLoadSaveWindowCntl);
	mMovies.AddItem(mPauseMenuCntl);
	mMovies.AddItem(mRequestPopupCntl);
	mMovies.AddItem(mDialogCntl);
	mMovies.AddItem(mGUIOverlaySystemCntl);
	mMovies.AddItem(mLoadingScreenCntl);
	mMovies.AddItem(mHeropediaCntl);
	// mouse
	mMovies.AddItem(mMouseCntl);

	mMoviesToDelete = mMovies;

	InitHUD();
}

function InitHUD()
{
	local H7FlashMovieCntl movie;
	
	;

	foreach mMovies(movie)
	{
		//if(!movie.IsA('H7TownRecruitmentPopupCntl') && !movie.IsA('H7RequestPopupCntl')) continue;
		//if(!movie.IsA('H7TownRecruitmentPopupCntl')) continue; 
		//if(!movie.IsA('H7RequestPopupCntl')) continue;
		//if(movie.IsA('H7TownPopupsCntl')) continue;
		//if(!movie.IsA('H7PauseMenuCntl') && !movie.IsA('H7LoadSaveWindowCntl') && !movie.IsA('H7AdventureHudCntl')) continue;		
		//if(!movie.IsA('H7TownHudCntl') && !movie.IsA('H7TownBuildingPopupCntl') && !movie.IsA('H7ContainerCntl') && !movie.IsA('H7AdventureHudCntl')) continue;		
		
		;
		movie.SetPlayerOwner(H7PlayerController(PlayerOwner));
		movie.SetTimingMode(TM_Real);
		
		movie.Initialize();
	}

	if(!mProperties.mAmbientOcclusion) // unreal always starts with true, so turn it off
	{
		mProperties.SetAmbientOcclusion(mProperties.mAmbientOcclusion);
	}

	;

	ShowStartupLog();

	CompleteHUD();
}

function RestartMovie(H7FlashMovieCntl movie)
{
	movie.Close(true);
	movie.Initialize();
}

function CompleteHUD()
{
	;

	mIsLoaded = true;
	ChildCompleted();

	if(class'H7PlayerController'.static.GetPlayerController().bCinematicMode)
	{
		;
	}
	else
	{
		ShowHUD();
		if (HideH7HUD)
		{
			HideHUD();
		}
	}

	EnableTickFunctionality();
}

function ChildCompleted()
{
	// empty
}

function bool IsAllowFocus()
{
	// don't allow focus during game start and during load
	return mTickFunctionalityInited;
}

function EnableTickFunctionality()
{
	;
	
	mTickFunctionalityInited = true;

	if(class'H7PlayerController'.static.GetPlayerController().GetHud().IsA('H7AdventureHud'))
	{
		class'H7AdventureHudCntl'.static.GetInstance().GetNoteBar().Init( class'H7MessageSystem'.static.GetInstance().GetNoteBar() );
	}

	if(mLogSystemCntl.GetLog() != none)
	{
		mLogSystemCntl.GetLog().Init( class'H7MessageSystem'.static.GetInstance().GetLog() );
	}
	else 
	{
		;
	}

	if(mLogSystemCntl.GetQALog() != none)
	{
		mLogSystemCntl.GetQALog().Init( class'H7MessageSystem'.static.GetInstance().GetQALog() );
	}
	else
	{
		;
	}

	if(mLogSystemCntl.GetChat() != none)
	{
		mLogSystemCntl.GetChat().Init( class'H7MessageSystem'.static.GetInstance().GetChat() );
	}
	else 
	{
		;
	}

	class'H7GUIOverlaySystemCntl'.static.GetInstance().GetSideBar().Init( class'H7MessageSystem'.static.GetInstance().GetSideBar() );	

	mTickFunctionality = true; // TODO what if cinematic atm?
}

function bool GetTickEnabled()
{
	return mTickFunctionalityInited;
}

function SetAdventureHudVisible(bool visible)
{
}

function CloseAllWindows()
{
	local H7FlashMovieCntl cntl;
	foreach mMovies(cntl)
	{ 
		cntl.ClosePopup();
	}
}

function HighlightGUIElement(string container, string element, optional string text, optional H7SeqAct_HighlightGUIElement node)
{
	local H7FlashMovieCntl cntl;
	local H7TutorialClickListener listener;

	;

	if(InStr(text,"\n") != INDEX_NONE)
	{
		;
	}

	if(InStr(text,"\\n") != INDEX_NONE)
	{
		;
		ReplaceText(text,"\\n","\n");
	}

	foreach mMovies(cntl)
	{
		if(cntl.GetFlashController(false) != none && cntl.GetContainer() == none) // calls should only go once to container, not to all popups inside the container 
		{
			cntl.GetFlashController().HighlightElement(container,element,text,node!=none?node.GetAssetNr():1);
		}
	}

	listener.containerName = container;
	listener.elementName = element;
	listener.node = node;

	mTutorialClickListeners.AddItem(listener);
}

// deletes all pending hightlights in the queue
// prevents adding of new hightlights into the queue for the current frame
// but really since we can not clean up the queue, we block all queue triggers for 1 frames (to block the timer added before in the same frame but not the timers added after in the same frame)
// the above plan does not work anymore because the timers are processed in reverse, which means the block is removed before the highlight, so we block 2 frames now
// and just hope nobody triggers this and actually wants to show a highlight
function PreventAllPendingHighlights()
{
	mPreventAllPendingHighlights = true;
	SetFrameTimer(2,ResetPreventAllPendingHighlights);
}

function ResetPreventAllPendingHighlights()
{
	mPreventAllPendingHighlights = false;
}

function bool IsPreventingAllPendingHighlights()
{
	return mPreventAllPendingHighlights;
}

function DeleteAllHighlights()
{
	local H7FlashMovieCntl cntl;
	local H7TutorialClickListener listener;
	foreach mMovies(cntl)
	{
		if(cntl.GetFlashController(false) != none) 
		{
			cntl.GetFlashController().DeleteAllHighlights();
			cntl.StartAdvance(); // so the hiding is propagated, tick function will clean it up later
		}
	}
	
	// shut down all latent running nodes so they can be triggerd again:
	foreach mTutorialClickListeners(listener)
	{
		listener.node.EndTicking();
	}
	mTutorialClickListeners.Length = 0;

}

function TriggerNoteElementClick(string containerName,string elementName)
{
	local H7TutorialClickListener listener;
	foreach mTutorialClickListeners(listener)
	{
		if(listener.containerName == containerName && listener.elementName == elementName && listener.node != none)
		{
			listener.node.TriggerClick();
		}
	}
}

function bool IsRemoveWhenClicked(string containerName,string elementName)
{
	local H7TutorialClickListener listener;
	foreach mTutorialClickListeners(listener)
	{
		if(listener.containerName == containerName && listener.elementName == elementName && listener.node != none)
		{
			return listener.node.IsRemoveWhenClicked();
		}
	}

	if(containerName == "aMainMenu" && elementName == "mBtnTutorial")
	{
		class'H7GUIGeneralProperties'.static.GetInstance().mClickedTutorial = true;
		class'H7GUIGeneralProperties'.static.GetInstance().SaveConfig();
	}

	if(containerName == "aMainMenu" && elementName == "mBtnLostTales")
	{
		class'H7GUIGeneralProperties'.static.GetInstance().mClickedLostTales = true;
		class'H7GUIGeneralProperties'.static.GetInstance().SaveConfig();
	}

	if(containerName == "aMainMenu" && elementName == "mBtnLostTales2")
	{
		class'H7GUIGeneralProperties'.static.GetInstance().mClickedLostTales2 = true;
		class'H7GUIGeneralProperties'.static.GetInstance().SaveConfig();
	}

	// if we don't know, we just remove it
	return true;
}

// called every tick
event PostRender()
{
	//`log_gui("Hud.tick");
	//`log_dui("----------------------------------------------------------------------HUD TICK---------------------------------------------------------------");
	mFramesDone++;
	
	if(mTickFunctionality)
	{
		
		if(bShowHUD) RenderCanvasCursor();

		CheckForResolutionChange();

		StopUnnecessaryPopups();

		if(mFCTController != none)
		{
			mFCTController.Render(Canvas);
		}
		else
		{
			if(class'H7FCTController'.static.GetInstance()!=none)
				mFCTController = class'H7FCTController'.static.GetInstance();
		}

		mOverlaySystemCntl.Update(Canvas);

		GetListeningManager().Update();
		
		class'H7PlayerController'.static.GetPlayerController().GetMessageSystem().TryToAssignMessages();
	}
	
	SetRightClickThisFrame(false);
	SetLeftClickThisFrame(false);

	//mMouseCntl.SetMouse();
	//mMouseCntl.Advance(0);

	DisplayKismetMessages();

	TickFrameTimers();
	TickSecondsTimers();

	class'H7PlayerController'.static.GetPlayerController().ApplyBufferedCommands();
}

// low performance-needy rolling check function that checks 1 movie for shut down per frame
function StopUnnecessaryPopups()
{
	local H7FlashMovieCntl cntl;
	local int i;

	i = mFramesDone % mMovies.Length;
	cntl = mMovies[i];
	if(H7FlashMoviePopupCntl(cntl) != none && !cntl.GetPause())
	{
		if(cntl.CanBeStopped())
		{
			;
			SetFrameTimer(mMovies.Length,cntl.StopAdvance);
		}
	}
}

function DisplayKismetMessages()
{
	local int KismetTextIdx;

	KismetTextIdx = 0;
	while( KismetTextIdx < KismetTextInfo.length )
	{
		if( KismetTextInfo[KismetTextIdx].MessageEndTime > 0 && KismetTextInfo[KismetTextIdx].MessageEndTime <= WorldInfo.TimeSeconds)
		{
			KismetTextInfo.Remove(KismetTextIdx,1);
		}
		else
		{
			/*DrawText(KismetTextInfo[KismetTextIdx].MessageText$KismetTextInfo[KismetTextIdx].AppendedText, 
					 KismetTextInfo[KismetTextIdx].MessageOffset, KismetTextInfo[KismetTextIdx].MessageFont, KismetTextInfo[KismetTextIdx].MessageFontScale, KismetTextInfo[KismetTextIdx].MessageColor);*/
			Canvas.Font = class'Engine'.Static.GetMediumFont();
			Canvas.SetPos(30.0f, 30.0f + KismetTextIdx * 11.5f);
			Canvas.SetDrawColor(255,255,255,255);
			Canvas.DrawText(KismetTextInfo[KismetTextIdx].MessageText$KismetTextInfo[KismetTextIdx].AppendedText);
			++KismetTextIdx;
		}
	}
}



function bool IsLoaded()
{
	return mIsLoaded;
}


//Called when this is destroyed
singular event Destroyed()
{
	local H7FlashMovieCntl movie;

	;
	
	HideHUD();

	if(mMoviesToDelete.Length > 0)
	{
		foreach mMoviesToDelete(movie)
		{
			;
			movie.Close(true);
			movie = none;
		}
	}

	;
	
}

function EnsureInit(H7FlashMovieCntl movie)
{
	if(!movie.WasInitialized())
	{
		if(movie.GetVariableObject("root") == none) // savety check in case the movie did not set its flag but is loaded in fact
		{
			;
			movie.SetPlayerOwner(H7PlayerController(PlayerOwner));
			movie.SetTimingMode(TM_Real);
			movie.Initialize();
			mMovies.RemoveItem(movie);
		}
		else
		{
			;
			movie.SetInitialized();
		}
	}
}


exec function ToggleHUD()
{
	//`log_gui("ToggleHUD");
	super.ToggleHUD();
	;

	HideH7HUD = !bShowHUD;
	mTickFunctionality = bShowHUD && mTickFunctionalityInited;
	SaveConfig();

	SetAdditionalElements(bShowHUD);

}

function SetAdditionalElements(bool val)
{
	// path preview

	

	// building flags
	

}

exec function ShowHUD()
{
	;
	bShowHUD = false;
	ToggleHUD();
}

exec function HideHUD()
{
	;
	bShowHUD = true;
	ToggleHUD();
}

function EHUDMode GetHUDMode() { return mHudMode; }
function SetHUDMode(EHUDMode mode,optional EHUDMode onlyFromMode) // OPTIONAL do entirely with gui-hiding-messages
{
	//local H7Message message;
	//local array<H7Message> messages;

	;

	// "waiting for connect" ends
	if(onlyFromMode == HM_WAITING_FOR_OTHERS_CONNECT && mode == HM_NORMAL) GetRequestPopupCntl().GetRequestPopup().Finish();
	
	if(onlyFromMode != HM_NORMAL && onlyFromMode != mHudMode) return; // for when some state ends, but it should not go to normal, because some other state is still running
	
	mHudMode = mode;

	switch(mode)
	{
		case HM_NORMAL:
			class'H7BackgroundImageCntl'.static.GetInstance().UnloadBackground(); 
			if(class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap())
			{
				H7AdventureHud(self).GetAdventureHudCntl().GetMinimap().SetVisibleSave(true);
				H7AdventureHud(self).GetAdventureHudCntl().GetHeroHUD().SetVisibleSave(true);
				H7AdventureHud(self).GetAdventureHudCntl().GetTopBar().SetVisibleSave(true);
				H7AdventureHud(self).GetAdventureHudCntl().GetTownList().SetVisibleSave(true);
				H7AdventureHud(self).GetAdventureHudCntl().GetCommandPanel().SetVisibleSave(true);
				H7AdventureHud(self).GetLogCntl().GetLog().SetVisibleSave(true);
				H7AdventureHud(self).GetLogCntl().GetQALog().SetVisibleSave(true);
				H7AdventureHud(self).GetGUIOverlaySystemCntl().GetSideBar().SetVisibleSave(true);
				H7AdventureHud(self).GetAdventureHudCntl().GetNoteBar().SetVisibleSave(true);
				H7AdventureHud(self).GetSpellbookCntl().GetQuickBar().SetVisibleSave(true);
				H7AdventureHud(self).GetAdventureHudCntl().GetCommandPanel().SetMyTurn(true);
				H7AdventureHud(self).GetAdventureHudCntl().GetPlayerBuffs().SetVisibleSave(true);
				H7AdventureHud(self).GetLogCntl().SetLogStatus("aLog",class'H7GUIGeneralProperties'.static.GetInstance().GetLogStatus());
				GetOverlaySystemCntl().GetFloatingSystem().SetVisibleSave(true);
			}
			else if(H7CombatHud(self) != none) // normal combat hud
			{
				H7CombatHud(self).GetCombatHudCntl().GetInitiativeList().SetVisibleSave(true);
				H7CombatHud(self).GetCombatHudCntl().GetCombatMenu().SetVisibleSave(true);
				H7CombatHud(self).GetCombatHudCntl().GetHeroPanel().SetVisibleSave(true);
				H7CombatHud(self).GetCombatHudCntl().GetCreatureAbilityButtonPanel().SetVisibleSave(true);
				H7CombatHud(self).GetLogCntl().GetLog().SetVisibleSave(true);
				H7CombatHud(self).GetLogCntl().GetQALog().SetVisibleSave(true);
				H7CombatHud(self).GetGUIOverlaySystemCntl().GetSideBar().SetVisibleSave(true);
				H7AdventureHud(self).GetSpellbookCntl().GetQuickBar().SetVisibleSave(true);
			}
			else // council hud
			{
				if(class'H7CouncilManager'.static.GetInstance() != none)
				{
					class'H7CouncilManager'.static.GetInstance().EnableHUD();
				}
				else
				{
					;
				}
			}
			class'H7MessageSystem'.static.GetInstance().DeleteMessagesByAction(MA_BLOCK_GAMEPLAY_AND_HIDE_GUI);
			GetRequestPopupCntl().GetRequestPopup().Finish();
		break;

		case HM_WAITING_FOR_OTHERS_TURN:
			class'H7BackgroundImageCntl'.static.GetInstance().UnloadBackground(); 
			if(self.isA('H7AdventureHud'))
			{
				H7AdventureHud(self).GetAdventureHudCntl().GetMinimap().SetVisibleSave(true);
				H7AdventureHud(self).GetAdventureHudCntl().GetHeroHUD().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetTopBar().SetVisibleSave(true);
				H7AdventureHud(self).GetAdventureHudCntl().GetTopBar().ShowOtherPlayerPlaying(class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetName(), H7AdventureHud(self).GetAdventureHudCntl().UnrealColorToHTMLColor( class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetColor() ));
				H7AdventureHud(self).GetAdventureHudCntl().GetTownList().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetCommandPanel().SetVisibleSave(true);
				H7AdventureHud(self).GetAdventureHudCntl().GetCommandPanel().SetMyTurn(false);
			}
			//messages = class'H7MessageSystem'.static.GetInstance().GetMessagesWithActiveAction(MA_BLOCK_GAMEPLAY_AND_HIDE_GUI);
			//if(messages.Length == 0)
			//{
			//	message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mOtherPlayerTurn.CreateMessageBasedOnMe();
			//	message.AddRepl("%player",class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetName());
			//	class'H7MessageSystem'.static.GetInstance().SendMessage(message);
			//}
		break;
		case HM_WAITING_FOR_OTHERS_CONNECT:
			if(self.isA('H7AdventureHud'))
			{
				H7AdventureHud(self).GetAdventureHudCntl().GetMinimap().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetHeroHUD().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetTopBar().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetTownList().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetCommandPanel().SetVisibleSave(false);
				H7AdventureHud(self).GetLogCntl().SetLogStatus("aLog",true);
			}
			GetLogCntl().GetLog().SetVisibleSave(true); // hack bc log is somehow invisible but don't know why
			class'H7BackgroundImageCntl'.static.GetInstance().LoadBackground(class'H7BackgroundImageCntl'.static.GetInstance().mBackgroundImageProperties.MainMenuImage); 
			GetRequestPopupCntl().GetRequestPopup().NoChoicePopup( "MSG_WAIT_LOADING" );
		break;
		case HM_WAITING_FOR_AI:
			class'H7BackgroundImageCntl'.static.GetInstance().UnloadBackground(); 
			if(self.isA('H7AdventureHud'))
			{
				H7AdventureHud(self).GetAdventureHudCntl().GetMinimap().SetVisibleSave(true);
				H7AdventureHud(self).GetAdventureHudCntl().GetHeroHUD().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetTopBar().SetVisibleSave(true);
				H7AdventureHud(self).GetAdventureHudCntl().GetTopBar().ShowOtherPlayerPlaying(class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetName(), H7AdventureHud(self).GetAdventureHudCntl().UnrealColorToHTMLColor( class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetColor() ));
				H7AdventureHud(self).GetAdventureHudCntl().GetTownList().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetCommandPanel().SetVisibleSave(true);
				H7AdventureHud(self).GetAdventureHudCntl().GetCommandPanel().SetMyTurn(false);
			}
		break;
		case HM_WAITING_OTHER_PLAYER_ANSWER:
			class'H7BackgroundImageCntl'.static.GetInstance().UnloadBackground(); 
			if(self.isA('H7AdventureHud'))
			{
				H7AdventureHud(self).GetAdventureHudCntl().GetMinimap().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetHeroHUD().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetTopBar().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetTownList().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetCommandPanel().SetVisibleSave(false);
			}
			GetRequestPopupCntl().GetRequestPopup().NoChoicePopup( "MSG_WAIT_ANSWER" );
		break;
		case HM_WAITING_OTHER_PLAYER_RETREAT:
			class'H7BackgroundImageCntl'.static.GetInstance().UnloadBackground(); 
			if(self.isA('H7AdventureHud'))
			{
				H7AdventureHud(self).GetAdventureHudCntl().GetMinimap().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetHeroHUD().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetTopBar().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetTownList().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetCommandPanel().SetVisibleSave(false);
			}
			GetRequestPopupCntl().GetRequestPopup().NoChoicePopup( "MSG_WAIT_RETREAT" );
		break;
		case HM_CINEMATIC_SUBTITLE: // Narration GUI
			class'H7BackgroundImageCntl'.static.GetInstance().UnloadBackground(); 
			if(class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap())
			{
				H7AdventureHud(self).GetSpellbookCntl().GetQuickBar().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetMinimap().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetHeroHUD().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetTopBar().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetTownList().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetCommandPanel().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetNoteBar().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetActorTooltip().ShutDown();
				H7AdventureHud(self).GetLogCntl().GetLog().SetVisibleSave(false);
				H7AdventureHud(self).GetLogCntl().GetQALog().SetVisibleSave(false);
				H7AdventureHud(self).GetGUIOverlaySystemCntl().GetSideBar().SetVisibleSave(false);		
				GetOverlaySystemCntl().GetFloatingSystem().SetVisibleSave(false);
			}
			else if(H7CombatHud(self) != none)
			{
				H7CombatHud(self).GetCombatHudCntl().GetInitiativeList().SetVisibleSave(false);
				H7CombatHud(self).GetCombatHudCntl().GetCombatMenu().SetVisibleSave(false);
				H7CombatHud(self).GetCombatHudCntl().GetHeroPanel().SetVisibleSave(false);
				H7CombatHud(self).GetCombatHudCntl().GetCreatureAbilityButtonPanel().SetVisibleSave(false);
				H7CombatHud(self).GetLogCntl().GetLog().SetVisibleSave(false);
				H7CombatHud(self).GetLogCntl().GetQALog().SetVisibleSave(false);
				H7CombatHud(self).GetGUIOverlaySystemCntl().GetSideBar().SetVisibleSave(false);
			}
			else // council
			{
				GetDialogCntl().GetMapControls().SetVisibleSave(false);
				GetDialogCntl().GetNarrationDialog().SetVisibleSave(false);
				GetDialogCntl().GetNarrationTop().SetVisibleSave(false);
				GetDialogCntl().GetCouncilDialog().SetVisibleSave(false);
				GetDialogCntl().GetDialog().SetVisibleSave(false);
				H7MainMenuHud(self).GetMainMenuCntl().GetCouncilorTooltip().SetVisibleSave(false);
				H7MainMenuHud(self).GetMainMenuCntl().GetCouncilorWindow().SetVisibleSave(false);
				H7MainMenuHud(self).GetMainMenuCntl().GetBackButton().SetVisibleSave(false);
				H7MainMenuHud(self).GetMainMenuCntl().GetMainMenu().SetVisibleSave(false);
			}
		break;
		case HM_IN_BETWEEN_TURNS_FOR_HOTSEAT:
			if(class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap())
			{
				H7AdventureHud(self).GetAdventureHudCntl().GetMinimap().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetHeroHUD().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetTopBar().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetTownList().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetCommandPanel().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetNoteBar().SetVisibleSave(false);
				H7AdventureHud(self).GetLogCntl().GetLog().SetVisibleSave(false);
				H7AdventureHud(self).GetLogCntl().GetQALog().SetVisibleSave(false);
				H7AdventureHud(self).GetGUIOverlaySystemCntl().GetSideBar().SetVisibleSave(false);
				//class'H7BackgroundImageCntl'.static.GetInstance().LoadBackground(class'H7BackgroundImageCntl'.static.GetInstance().mBackgroundImageProperties.MainMenuImage); 
			}
		break;
		case HM_MAPVIEW:
			class'H7BackgroundImageCntl'.static.GetInstance().UnloadBackground(); 
			if(self.isA('H7AdventureHud'))
			{
				H7AdventureHud(self).GetAdventureHudCntl().GetMinimap().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetHeroHUD().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetTopBar().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetTownList().SetVisibleSave(false);
				H7AdventureHud(self).GetSpellbookCntl().GetQuickBar().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetCommandPanel().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetNoteBar().SetVisibleSave(false);
				H7AdventureHud(self).GetLogCntl().GetLog().SetVisibleSave(false);
				H7AdventureHud(self).GetAdventureHudCntl().GetMPTurnInfo().SetVisibleSave(false);
			}
		break;
	}
}

/////////////////////////////////////////////////////////////////////////////////////
// RESOLUTION ///////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////

// called every frame
function CheckForResolutionChange()
{
	local Vector2D currentRes;

	currentRes = class'H7PlayerController'.static.GetPlayerController().GetScreenResolution();
	if(mOldRes.x != currentRes.x || mOldRes.y != currentRes.y)
	{
		ResolutionChanged(currentRes);
		mOldRes = currentRes;
	}
}

// called on event
// override/extend it in children but call Super.ResolutionChanged() first
function ResolutionChanged(Vector2D newRes)
{
	local Vector2d topLeft;
	local Vector2d topLeftFlash;
	local Vector2d newResFlash;
	local H7FlashMovieCntl movie;
	local String message;
	
	if(mOldRes.X > 0 && mOldRes.Y > 0)
	{
		message = class'H7Loca'.static.LocalizeSave("MSG_RESOLUTION_CHANGED","H7Message");
		message = Repl(message, "%resX", int(newRes.X));
		message = Repl(message, "%resY", int(newRes.Y));
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage( message ,MD_SIDE_BAR);
	}

	mUnrealWidth = newRes.X;
	mUnrealHeight = newRes.Y;

	// tooltip constraints
	topLeft.X = 0;
	topLeft.Y = 0;
	foreach mMovies(movie)
	{
		topLeftFlash = movie.UnrealPixels2FlashPixels(topLeft);
		newResFlash = movie.UnrealPixels2FlashPixels(newRes);
		movie.SetConstraints(topLeftFlash.X,topLeftFlash.Y,newResFlash.X,newResFlash.Y);
	}
	
	// spellbook might not be initialized because even through H7Hud has the reference, children decide wheter to init it or not
	newResFlash = mSpellbookCntl.UnrealPixels2FlashPixels(newRes);
	if(mSpellbookCntl.GetQuickBar() != none)
	{
		mSpellbookCntl.GetQuickBar().Realign(newResFlash.x,newResFlash.y);
	}
	if(mSpellbookCntl.GetSpellbook() != none)
	{
		mSpellbookCntl.GetSpellbook().Realign(newResFlash.x,newResFlash.y);
	}

	newResFlash = mGUIOverlaySystemCntl.UnrealPixels2FlashPixels(newRes);
	mGUIOverlaySystemCntl.GetSideBar().Realign(newResFlash.x,newResFlash.y);
	mGUIOverlaySystemCntl.GetUplayNote().Realign(newResFlash.x,newResFlash.y);

	newResFlash = mOverlaySystemCntl.UnrealPixels2FlashPixels(newRes);
	if(mLogSystemCntl.GetLog() != none)
	{
		mLogSystemCntl.GetLog().Realign(newResFlash.x,newResFlash.y);
	}
	if(mLogSystemCntl.GetQALog() != none)
	{
		mLogSystemCntl.GetQALog().Realign(newResFlash.x,newResFlash.y);
	}

	newResFlash = mDialogCntl.UnrealPixels2FlashPixels(newRes);
	mDialogCntl.GetCouncilDialog().Realign(newResFlash.x,newResFlash.y);
	mDialogCntl.GetDialog().Realign(newResFlash.x,newResFlash.y);
	mDialogCntl.GetNarrationDialog().Realign(newResFlash.x,newResFlash.y);
	mDialogCntl.GetNarrationTop().Realign(newResFlash.x,newResFlash.y);
	mDialogCntl.GetMapControls().Realign(newResFlash.x,newResFlash.y);
	mDialogCntl.GetSubtitle().Realign(newResFlash.x,newResFlash.y);
}

function Vector2D GetUnrealSize() //GetPlayerController and GetScreenResolution-GetViewportSize is expensive so we buffer
{
	local Vector2D screen;
	if(mUnrealHeight == 0 || mUnrealWidth == 0)
	{
		screen = class'H7PlayerController'.static.GetPlayerController().GetScreenResolution();
		mUnrealWidth = screen.X;
		mUnrealHeight = screen.Y;
	}
	screen.X = mUnrealWidth;
	screen.Y = mUnrealHeight;
	return screen;
}

/////////////////////////////////////////////////////////////////////////////////////
// INPUT ////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////

function int GetPlayTime()
{
	return WorldInfo.RealTimeSeconds * 1000;
}

function int GetTimeStamp()
{
	local int year,month,day7,day,hour,min,sec,msec;
	local int unixtime;

	GetSystemTime(year,month,day7,day,hour,min,sec,msec);

	unixtime = (sec+60*(min+60*(hour+24*(day+31*(month+12*(year-1970))))));

	return unixtime;
}

function float GetRealTimeSeconds()
{
	return WorldInfo.RealTimeSeconds;
}

function int GetTimeMS()
{
	local int year,month,day7,day,hour,min,sec,msec;
	local int unixtime;

	GetSystemTime(year,month,day7,day,hour,min,sec,msec);

	unixtime = msec+1000*(sec+60*(min+60*(hour)));

	return unixtime;
}


// true as long as right mouse is down
function SetRightMouseDown(bool val)
{
	// if rightmouse was down and is now up
	if(mRightMouseDown && !val)
	{
		mRightClickThisFrame = true; // release counts as click
	}
	if(!mRightMouseDown && val) // first frame pressing right mouse down
	{
		mRightMouseDownSince = GetPlayTime();
	}
	mRightMouseDown = val;
}

function bool GetRightMouseDown()
{
	return mRightMouseDown;
}
function bool IsRightMouseDown()
{
	return mRightMouseDown;
}
function int GetRightMouseDownSince()
{
	return mRightMouseDownSince;
}
// In case a flash click arrives during this frame it will be interpreted as a rightclick
// - reset every frame
function SetRightClickThisFrame(bool val)
{
	mRightClickThisFrame = val;
	if(val)
	{
		;
	}
}
function bool IsRightClickThisFrame()
{
	return mRightClickThisFrame;
}

// true as long as left mouse is down
function SetLeftMouseDown(bool val)
{
	// if leftmouse was down and is now up
	if(mLeftMouseDown && !val)
	{
		mLeftClickThisFrame = true; // release counts as click
	}
	if(!mLeftMouseDown && val) // first frame pressing left mouse down
	{
		mLeftMouseDownSince = GetPlayTime();
	}
	mLeftMouseDown = val;
}

function bool GetLeftMouseDown()
{
	return mLeftMouseDown;
}
function bool IsLeftMouseDown()
{
	return mLeftMouseDown;
}
function int GetLeftMouseDownSince()
{
	return mLeftMouseDownSince;
}

// In case a flash click arrives during this frame it will be interpreted as a rightclick
// - reset every frame
function SetLeftClickThisFrame(bool val)
{
	//if(mRightClickThisFrame) `log_gui("setting rightClickThisFrameTo"@val);
	mLeftClickThisFrame = val;
}

function bool IsLeftClickThisFrame()
{
	return mLeftClickThisFrame;
}

/////////////////////////////////////////////////////////////////////////////////////
// POPUP ////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////

// requestpopup is special and will never be currentContext
// all other popups will be current context, some of which allow opening of other popups, others don't
function bool CanOpenPopup(H7FlashMoviePopupCntl popup)
{
	// rule 1 - existing request popup always blocks everything new
	if(class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().IsVisible()) return false; 

	if(mCurrentContext != none)
	{
		//stupid hack
		if(mCurrentContext.IsA('H7SpectatorHUDCntl') && popup.IsA('H7PauseMenuCntl'))
			return true;
		if(mCurrentContext.IsA('H7SpectatorHUDCntl') && popup.IsA('H7OptionsMenuCntl'))
			return true;

		// oh, oh now it's getting complicated:
		// rule 1.5 - popups can always open when they are already open
	    if(mCurrentContext == popup) 
	    {
			return true;
	    }

		// rule 2 - request can always open above others
		if(popup.IsA('H7RequestPopupCntl')) return true;

		// rule 3 - popup vs popup
		if(!mCurrentContext.IsBlockingFlash(true) && !popup.IsBlockingFlash(true))
		{
			// normal -> normal
			//closingCurrentPopup = true;
			return true;
		}
		else if(!mCurrentContext.IsBlockingFlash(true) && popup.IsBlockingFlash(true))
		{
			// normal -> block
			//closingCurrentPopup = true;
			return true;
		}
		else if(mCurrentContext.IsBlockingFlash(true) && popup.IsBlockingFlash(true))
		{
			// block -> block
			;
			return false;
		}
		else if(mCurrentContext.IsBlockingFlash(true) && !popup.IsBlockingFlash(true))
		{
			// block -> normal
			;
			return false;
		}
	}

	return true;
}

// OPTIONAL multiple popups layered-stack handling
// - closes current popups
// - marks the popup as current context, so it can be closed with ESC
// if it is a blocking popup also:
// - blocks unreal
// - block every movie besides the one where the popup is
// - also shows a black layer on the movie right under the popup
function PopupWasOpened(H7FlashMoviePopupCntl popupMovie)
{
	//local string message;

	mPopupWasRequester = (popupMovie == mRequestPopupCntl);
	
	// close the old one?
	if(mCurrentContext != none)
	{
		if(!mPopupWasRequester) // normal popup is opening
		{
			if(mCurrentContext == popupMovie)
			{
				// same popup just updates itself (replaces itself) - neither display warning, not close it
			}
			else if(mCurrentContext.IsBlockingFlash(true)) // current popup is blocking flash
			{
				// conflict! - a popup has opened itself over a block popup
				// should never happen, since CanOpenPopup should have returned false
				//message = `Localize("H7Message", "MSG_CANNOT_CLOSE" , "MMH7Game" );
				//message = Repl(message, "%context", mCurrentContext);
				//class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage( message ,MD_SIDE_BAR);
				;
			}
			else // new popup replaces old popup (switch)
			{
				PopupWasClosed(false);
				mCurrentContext.ClosePopup(); // this triggers also PopupWasClosed()
				if(mCurrentContext.GetPopup().IsVisible() && !mCurrentContext.IsA('H7HallOfHerosPopupCntl')) // it did not really close, probably just closed an inner popup (Magic Guild / Building Popup / etc.)
				{
					mCurrentContext.ClosePopup();
				}
			}
		}
		else
		{
			// request popup is opening -> always ok, no need to close old popup or throw warning
		}
	}

	// save reference to close it, in case another popups is opened in the future
	if(!mPopupWasRequester)
	{
		SetCurrentContext(popupMovie);
		TriggerKismetNodeOpenPopup(popupMovie.GetPopup().GetFlashName());

		// force again the external interface in case a townpopup replaced a townpopup
		if(mCurrentContext.GetContainer() != none)
		{
			mCurrentContext.GetContainer().SetExternalInterface(mCurrentContext);
		}
	}
	
	if(!class'H7ReplicationInfo'.static.GetInstance().IsCombatMap())
	{
		// tell command panel to update highlight
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetCommandPanel().UpdateSelectState(popupMovie,true);
		
		// hide player buffs
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetPlayerBuffs().SetVisibleSave(false);
	}

	// blocking
	if(popupMovie.IsBlockingFlash())
	{
		BlockFlashBelow(popupMovie);
	}
	if(popupMovie.IsBlockingUnreal())
	{
		BlockUnreal();
	}
	if(popupMovie.IsHidingSidebar())
	{
		class'H7PlayerController'.static.GetPlayerController().GetHud().GetGUIOverlaySystemCntl().GetSideBar().SetVisibleSave(false);
		class'H7AdventureHudCntl'.static.GetInstance().GetNoteBar().SetVisibleSave(false);
	}

	if(class'H7AdventureHudCntl'.static.GetInstance() != none)
	{
		class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().SetPopupMode(true);
	}
	
	if(mDialogCntl.GetDialog().IsVisible() && mDialogCntl.GetCurrentAutoPlay() || mDialogCntl.GetNarrationDialog().IsVisible() 
		|| popupMovie.IsA('H7SkillwheelCntl') || popupMovie.IsA('H7HeroWindowCntl') || popupMovie.IsA('H7SpellbookCntl') 
		|| popupMovie.IsA('H7QuestLogCntl') || popupMovie.IsA('H7PauseMenuCntl'))
	{
		return;
	}
	else
	{
		// sound
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("POP_UP_OPEN_SOUND");
	}
}

/**
 *  Blocks input on unreal 3d-world, camera, keybindings (tbd)
 */
function BlockUnreal()
{
	// disable Unreal
	if( H7PlayerController(PlayerOwner) != none )
	{
		H7PlayerController(PlayerOwner).SetIsPopupOpen(true);
	}
	if(class'H7Camera'.static.GetInstance() != none)
	{
		class'H7Camera'.static.GetInstance().LockCamera(true);
	}
}

function UnblockUnreal()
{
	// enable Unreal
	H7PlayerController(PlayerOwner).SetIsPopupOpen(false);
	if(class'H7ReplicationInfo'.static.GetInstance().IsCombatMap()
		|| (class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() && !class'H7TownHudCntl'.static.GetInstance().IsInAnyScreen()))
	{
		class'H7Camera'.static.GetInstance().LockCamera(false);
	}
}

/**
 *  Blocks input on every flashmovie _below_ the popupMovie
 */
function BlockFlashBelow(H7FlashMovieCntl popupMovie,optional bool withBlockLayer=true)
{
	local H7FlashMovieCntl movie;
	local H7FlashMovieCntl prevMovie;

	// disable Flashmovies
	if(popupMovie != none)
	{
		prevMovie = none;

		foreach mMovies(movie) // moves from the lowest fla to the highest
		{
			if(prevMovie != none && prevMovie != popupMovie)
			{
				if(movie == popupMovie) // show block-layer on the prev movie below this one
				{
					prevMovie.EnableMouse(); // hack - to make sure flash reacts when calling Disable the second time // remove on next flash all compile
					prevMovie.DisableMouse(withBlockLayer);
					//`log_gui("block+layer" @ prevMovie);
					return; // when finding the popup, return, thus skipping all higher popups and not blocking them
				}
				else
				{
					//`log_gui("block" @ prevMovie);
					prevMovie.DisableMouse(false);
				}
			}
			prevMovie = movie;
		}
	}
	else
	{
		;
	}
}

function BlockAllFlashMovies()
{
	local H7FlashMovieCntl movie;

	foreach mMovies(movie) // moves from the lowest fla to the highest
	{
		movie.DisableMouse(false);
	}
}

function UnblockAllFlashMovies()
{
	local H7FlashMovieCntl movie;
	
	// enable Flashmovies
	foreach mMovies(movie)
	{
		movie.EnableMouse();
	}
}

function UnblockHeropedia()
{
	mHeropediaCntl.EnableMouse();
}

function PopupWasClosed(optional bool setCurrentToNone=true)
{
	// request popup is over other popup?
	if( (mPopupWasRequester==true && mCurrentContext!=None)	|| 
		(mCurrentContext!=None && mCurrentContext.IsA('H7PauseMenuCntl') && 
		 H7CombatHud(self).GetSpectatorHUDCntl().GetPopup()!=None && H7CombatHud(self).GetSpectatorHUDCntl().GetPopup().IsVisible())) 
	{
		// do nothing
		mPopupWasRequester = false;
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("POP_UP_CLOSE_SOUND");
		// enable Flashmovies
		UnblockAllFlashMovies();

		if(mCurrentContext.IsA('H7PauseMenuCntl') && H7CombatHud(self).GetSpectatorHUDCntl().GetPopup().IsVisible())
			SetCurrentContext(H7CombatHud(self).GetSpectatorHUDCntl()); 

		// but reblock them
		;	
		if(mCurrentContext.GetContainer() != none)
			BlockFlashBelow(mCurrentContext.GetContainer());
		else
			BlockFlashBelow(mCurrentContext);
		
		return;
	}

	UnblockUnreal();

	// enable Flashmovies
	UnblockAllFlashMovies();

	// bring back boxy side messages
	if(GetHUDMode() != HM_CINEMATIC_SUBTITLE)
	{
		class'H7PlayerController'.static.GetPlayerController().GetHud().GetGUIOverlaySystemCntl().GetSideBar().SetVisibleSave(true);
	}

	// enable minimap options
	if(class'H7AdventureHudCntl'.static.GetInstance() != none)
	{
		class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().SetPopupMode(false);
	}
	
	if(mCurrentContext != none && !mCurrentContext.IsA('H7LoadSaveWindowCntl'))
	{
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("POP_UP_CLOSE_SOUND");
	}
	
	if(mCurrentContext != none)
	{
		TriggerKismetNodeClosePopup(mCurrentContext.GetPopup().GetFlashName());
	}

	if(!mPopupWasRequester && setCurrentToNone)
	{
		SetCurrentContext(none);
	}

	if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() )
	{
		
		// tell command panel to update highlight
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetCommandPanel().UpdateSelectState(mCurrentContext,false);
		
		if(GetHUDMode() == HM_NORMAL)
		{
			class'H7AdventureHudCntl'.static.GetInstance().GetNoteBar().SetVisibleSave(true);
		
			// show player buffs
			class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetPlayerBuffs().SetVisibleSave(true);
		}
	}

	mPopupWasRequester = false;
}

//Player opened popup
function TriggerKismetNodeOpenPopup(string popupName)
{
	local H7PlayerEventParam param;
	local H7Player thePlayer;

	if(class'H7AdventureController'.static.GetInstance() != none)
	{
		thePlayer = class'H7AdventureController'.static.GetInstance().GetLocalPlayer();

		if(thePlayer != none)
		{
			param = new class'H7PlayerEventParam';
			param.mEventPlayerNumber = thePlayer.GetPlayerNumber();
			param.mPopupName = popupName;
			class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_PopupChange', param, thePlayer, 0);
		}
	}
}

//Player closes popup
function TriggerKismetNodeClosePopup(string popupName)
{
	local H7PlayerEventParam param;
	local H7Player thePlayer;
	if(class'H7AdventureController'.static.GetInstance() != none)
	{
		thePlayer = class'H7AdventureController'.static.GetInstance().GetLocalPlayer();

		if(thePlayer != none)
		{
			param = new class'H7PlayerEventParam';
			param.mEventPlayerNumber = thePlayer.GetPlayerNumber();
			param.mPopupName = popupName;
			class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_PopupChange', param, thePlayer, 1);
		}
	}
}

//Player opened popup
function TriggerKismetNodePathSet()
{
	local H7PlayerEventParam param;
	local H7Player thePlayer;

	if(class'H7AdventureController'.static.GetInstance() != none)
	{
		thePlayer = class'H7AdventureController'.static.GetInstance().GetLocalPlayer();

		if(thePlayer != none)
		{
			param = new class'H7PlayerEventParam';
			param.mEventPlayerNumber = thePlayer.GetPlayerNumber();
			class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_PathSet', param, thePlayer, 0);
		}
	}
}

function SetCurrentContext(H7FlashMoviePopupCntl popup)
{
	mCurrentContext = popup;
}

// Closes current popup. 
// Ultimately Popup itself decides what to do at ClosePopup, so it can refuse, do something else, display confirm popups, etc
// If this is just a (user) request to close, send forceClose = false
// If a popup was closed, this returns true, else it returns false.
function bool CloseCurrentPopup(optional bool wasCanceled = false,optional bool forceClose = true)
{
	if(mCurrentContext != none)
	{
		mCurrentContext.SetWasCanceled( wasCanceled );
		mCurrentContext.ClosePopup();
		// simturns special case: if on advMap and player 1 has necromancy popup open and player 2 starts a
		// combat we need to hard close the combatpopup, otherwise a request popup would apppear for player 1
		// asking him if he realy wants to abandom the creature and the necromancy popup would get stuck on
		// his screen forever
		if(forceClose && mCurrentContext != none && mCurrentContext.IsA('H7CombatPopUpCntl') && class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap())
		{
			H7CombatPopUpCntl(mCurrentContext).ClosePopupHard();
		}
		
		return true;
	}
	return false;
}

/////////////////////////////////////////////////////////////////////////////////////
// CURSOR ///////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////

// set new cursor settings - called by PlayerController
// - UnrealCursor(Canvas) will be read during the render phase
// - Flash Cursor is send instant
function SetSoftwareCursor(Texture2D cursorTexture, Rotator cursorRotation,	optional float cursorOffsetX,optional float cursorOffsetY
				  ,optional Texture2D objectTexture, optional Rotator objectRotation, optional int objectOffsetX, optional int objectOffsetY,optional int obsizeX, optional int obsizeY
				  )
{
	local bool cursorChanged;
	local bool objectChanged;
	
	if(cursorTexture == Texture2D'H7Cursors.MeleeNorth') // || cursorTexture == Texture2D'H7Cursors.Move')
	{
		mOverwriteHardwareCursor = true;
	}
	else
	{
		mOverwriteHardwareCursor = false;
	}

	//`log_dui("SetSoftwareCursor" @ cursorTexture @ cursorRotation.Yaw @ mOverwriteHardwareCursor);

	if(cursorTexture == Texture2D'H7Cursors.MeleeNorth')
	{
		// use given rotation
	}
	else
	{
		// ignore given rotation (it's wrong)
		cursorRotation.Yaw = 0;
		cursorRotation.Pitch = 0;
		cursorRotation.Roll = 0;
	}

	if(mCursorRotation.Yaw != cursorRotation.Yaw)
	{
		mCursorRotation = cursorRotation;
		cursorChanged = true;
	}
	
	if(cursorTexture != none && mCursorTexture != cursorTexture)
	{
		mCursorTexture = cursorTexture;
		cursorChanged = true;
	}

	if(mObjectRotation.Yaw != ObjectRotation.Yaw)
	{
		mObjectRotation = ObjectRotation;
		objectChanged = true;
	}
	
	if(objectTexture != none && mObjectTexture != ObjectTexture)
	{
		mObjectTexture = ObjectTexture;
		objectChanged = true;
	}


	if(cursorChanged && mMouseCntl != none)
	{
		if(mProperties.mFlashMouse || mOverwriteHardwareCursor)
		{
			//`log_dui("show flash cursor");
			mMouseCntl.GetMouse().LoadCursorTexture(cursorTexture,cursorRotation,cursorOffsetX,cursorOffsetY);
		}
		else
		{
			mMouseCntl.GetMouse().UnLoadCursor();
		}
	}

	if(objectChanged)
	{
		// always show flash object no matter if hardware,canvas or flash cursor
		mMouseCntl.GetMouse().LoadObjectTexture(objectTexture,objectRotation,objectOffsetX,objectOffsetY,obsizeX,obsizeY);
	}
	
	// OPTIONAL dynamic runtime on/off cursor system switch according to editor/option settings	
}

function bool IsOverwritingHardwareCursor()
{
	return mOverwriteHardwareCursor;
}

function int UnLoadCursorObject()
{
	mObjectTexture = none;
	return mMouseCntl.GetMouse().UnLoadObject();
}

// will be called by PostRender, reads current cursor settings
// - only renders canvas cursor - if enabled
// - called every frame
function RenderCanvasCursor()
{
	local LocalPlayer myLocalPlayer;
	local Vector2D mousePos;
	local CanvasIcon icon;

	if(mCursorTexture != none && mProperties.mCanvasMouse)
	{
		myLocalPlayer = LocalPlayer(PlayerOwner.Player);
		mousePos = myLocalPlayer.ViewportClient.GetMousePosition();

		Canvas.DrawColor = MakeColor(255,255,255,255);
		
		// attack cursor
		if(mCursorTexture == Texture2D'H7Cursors.MeleeNorth')
		{
			Canvas.SetPos(mousePos.X + ATTACK_CURSOR_OFFSET_X, mousePos.Y + ATTACK_CURSOR_OFFSET_Y);
			RotateCursor();
		}
		// cursor of the creatures on the tactics phase
		else if( mCursorTexture.SizeX == 128 && mCursorTexture.SizeY == 128 )
		{
			
			Canvas.SetPos(mousePos.X + TACTICS_CURSOR_OFFSET_X, mousePos.Y + TACTICS_CURSOR_OFFSET_Y);
			Canvas.DrawRotatedTile( mCursorTexture, mCursorRotation,   32, 32,   0, 0, 128, 128,   0, 0 );
		}
		// rest if cursors
		else
		{
			icon = Canvas.MakeIcon(mCursorTexture);
			Canvas.DrawIcon(icon, mousePos.X, mousePos.Y);
		}
	}
}

function Texture2d GetCursorTexture()
{
	return mCursorTexture;
}

function RotateCursor()
{		
	mCursorRotation.pitch = 0;
	mCursorRotation.roll = 0;

	//	                                                    tile_size   texture_cutout  tile_rotate_point [0,1]    
	Canvas.DrawRotatedTile(mCursorTexture,mCursorRotation,  32,32,       0,0,32,32,      0.5,1); 	
}

//DEPRECATED: Use this to switch between software and hardware cursor
function bool IsMouseInGame()
{
	local LocalPlayer lPlayer;
	local Vector2D viewportSize;
	local bool isInGame;

	isInGame = true;

	if (PlayerOwner != None)
	{
		lPlayer = LocalPlayer(PlayerOwner.Player);
		
		if (lPlayer != None && lPlayer.ViewportClient != None)
		{
			lPlayer.ViewportClient.GetViewportSize( viewportSize );
			isInGame = lPlayer.ViewportClient.GetMousePosition().X > 1 &&
						lPlayer.ViewportClient.GetMousePosition().X < viewportSize.X - 1 &&
						lPlayer.ViewportClient.GetMousePosition().Y > 1 &&
						lPlayer.ViewportClient.GetMousePosition().Y < viewportSize.Y - 1;
		}
	}

	return isInGame;
}

function H7ListeningManager GetListeningManager()
{
	if(mListeningManager == none)
	{
		mListeningManager = new class'H7ListeningManager';
	}
	return mListeningManager;
}

///////////////////////////////////////////////////////////////////////////////////////////////
// keybindiungs 

function bool IsFocusOnInput() // checks if the fake-focus movie has focused a InputField
{
	if(GetFocusMovie() != none && GetFocusMovie().GetFlashController() != none && GetFocusMovie().GetFlashController().IsInputFocus() == 1) return true;
	return false;
}

function LoseFocusOnInput()
{
	if(GetFocusMovie() != none && GetFocusMovie().GetFlashController() != none)
	{
		GetFocusMovie().GetFlashController().LoseFocusOnInput();
	}
}

function H7FlashMovieCntl GetFocusMovie()
{
	return mFocusMovie;
}

function SetFocusMovie(H7FlashMovieCntl movie)
{
	//`log_dui("now in focus:" @ movie);
	mFocusMovie = movie;
}

///////////////////////////////////////////////////////////////////////////////////////////////
// performance test

function LogStart(H7FlashMovieCntl movie)
{
	mCurrentLoadingMovieStartTime = GetTimeMS();
	mCurrentLoadingMovie = movie;
	//`log_dui(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" @ mCurrentLoadingMovieStartTime @ mCurrentLoadingMovie);
}

function LogEnd(H7FlashMovieCntl movie)
{
	local int end;
	local H7StartupEntry entry;

	if(movie != mCurrentLoadingMovie) ;
	end = GetTimeMS();

	//`log_dui(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" @ end @ movie);
	//`log_dui(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" @ (end-mCurrentLoadingMovieStartTime) @ movie);

	entry.movieName = String(movie);
	entry.duration = (end-mCurrentLoadingMovieStartTime);
	mStartupLog.AddItem(entry);
}

function ShowStartupLog()
{
	local H7StartupEntry entry;

	foreach mStartupLog(entry)
	{
		;
	}
}


function SetSelfMadeTimer(float secondsToWait,delegate<OnFrameReached> callbackFunction)
{
	local H7SecondsTimer newTimer;
	newTimer.secondsToWait = secondsToWait;
	newTimer.callbackFunction = callbackFunction;

	mSecondsTimers.AddItem(newTimer);
}

function ClearSelfMadeTimer(delegate<OnFrameReached> callbackFunction)
{
	mSecondsTimers.Length = 0; // OPTIONAL actually match functions once system is used by multiple entities
}

function TickSecondsTimers()
{
	local H7SecondsTimer aTimer;
	local int i;
	local delegate<OnFrameReached> callbackFunction;
	local float deltaTime;

	deltaTime = class'WorldInfo'.static.GetWorldInfo().DeltaSeconds;

	for(i=mSecondsTimers.Length-1;i>=0;i--)
	{
		aTimer = mSecondsTimers[i];
		if(aTimer.secondsToWait <= 0)
		{
			callbackFunction = aTimer.callbackFunction;
			callbackFunction();
			mSecondsTimers.Remove(i,1);
		}
		else
		{
			mSecondsTimers[i].secondsToWait = mSecondsTimers[i].secondsToWait - deltaTime;
		}
	}
}

// frame test

function SetFrameTimer(int framesToWait,delegate<OnFrameReached> callbackFunction)
{
	local H7FrameTimer newTimer;
	newTimer.framesToWait = framesToWait;
	newTimer.callbackFunction = callbackFunction;

	mFrameTimers.AddItem(newTimer);
}

function TickFrameTimers()
{
	local H7FrameTimer aTimer;
	local int i;
	local delegate<OnFrameReached> callbackFunction;
	
	for(i=mFrameTimers.Length-1;i>=0;i--)
	{
		aTimer = mFrameTimers[i];
		if(aTimer.framesToWait <= 0)
		{
			callbackFunction = aTimer.callbackFunction;
			callbackFunction();
			mFrameTimers.Remove(i,1);
		}
		else
		{
			mFrameTimers[i].framesToWait = mFrameTimers[i].framesToWait - 1;
		}
	}
}

// frame test

///////////////////////////////////////////////////////////////////////////////////////////////////
// Letter Boxing

// one function to have everything in the same place and get rid of all the chaotic calls all over the place
function UpdateBorderBlack()
{
	local H7FlashMoviePopupCntl currentPopup;
	local bool newVisible;

	// reset to default: off
	newVisible = false;

	// all the cases where it appeares:
	// 1. fullscreen popups
	currentPopup = GetCurrentContext();
	if(currentPopup != none && currentPopup.IsFullscreen())
	{
		newVisible = true;
	}

	// 2. townscreens
	if(self.IsA('H7AdventureHud') && H7AdventureHud(self).GetTownHudCntl().IsInAnyScreen())
	{
		newVisible = true;
	}

	// 3. main menu 
	if(self.IsA('H7MainMenuHud'))
	{
		// screens that are sadly technically no popups
		if(H7MainMenuHud(self).GetSkirmishSetupWindowCntl().GetSkirmishWindow().IsVisible()
			|| H7MainMenuHud(self).GetDuelSetupWindowCntl().GetDuelWindow().IsVisible()
			|| H7MainMenuHud(self).GetMapSelectCntl().GetMapList().IsVisible()
			|| H7MainMenuHud(self).GetLobbySelectCntl().GetLobbyList().IsVisible()
			) 
		{
			newVisible = true;
		}
		// credits
		//if(H7MainMenuHud(self).GetMainMenuCntl().IsPlayingCredits())
		//{
		//	newVisible = true;
		//}
		// main menu
		// decision was NO	
	}

	// 4. hero pedia
	if(GetHeropedia().GetPopup().IsVisible())
	{
		newVisible = true;
	}

	GetLogCntl().GetBorderBlack().SetVisibleSave(newVisible);
}

