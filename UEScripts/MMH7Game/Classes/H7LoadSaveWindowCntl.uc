//=============================================================================
// H7LoadSaveWindowCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7LoadSaveWindowCntl extends H7FlashMovieBlockPopupCntl;

var protected H7GFxLoadSaveWindow mLoadSaveWindow;

var protected String mSelectedSaveGameFileName; // now Uplay Slot Index
var protected String mSelectedSaveGameSaveName;
//var protected int mDeletingSaveGameIndex;
//var protected int mSelectedSaveGameIndex;

var protected bool mLoadSelectedSaveGameAfterZoomIn;
var protected TextureRenderTarget2D        mScreenshot;
var protected bool                         mScreenshotInProgress;
var protected float                        mSavedBufferRatio;
var protected bool                         mSavedBufferActive;
var protected int                          mPendingSlotToSaveScreenshot;

var protected bool                         mSaveMode;
var protected bool                         mMainMenuMode;
var protected bool                         mCanExit;

static function H7LoadSaveWindowCntl GetInstance()   { return class'H7PlayerController'.static.GetPlayerController().GetHUD().GetLoadSaveWindowCntl(); }

function    H7GFxLoadSaveWindow     GetLoadSaveWindow() {return mLoadSaveWindow; }
function    H7GFxUIContainer        GetPopup() {return mLoadSaveWindow; }

function bool Initialize() 
{
	;
	// Start playing the movie
    Super.Start();
	// Initialize all objects in the movie
    AdvanceDebug(0);

	mLoadSaveWindow = H7GFxLoadSaveWindow(mRootMC.GetObject("aLoadSaveWindow", class'H7GFxLoadSaveWindow'));
	mLoadSaveWindow.SetVisibleSave(false);
	
	Super.Initialize();

	return true;
}

function InitWindowKeyBinds()
{
	CreatePopupKeybind('Delete',"DeleteCurrentSave",DeleteCurrentSave);
	
	super.InitWindowKeyBinds();
}

// mainMenuMode = there is no current game
function OpenLoad(optional bool mainMenuMode=false,optional bool canExit=true)
{
	;
	GetLoadSaveWindow().SetSaveMode(false);
	mSaveMode = false;
	mCanExit = canExit;
	Open(mainMenuMode);
}

function OpenSave()
{ 
	;
	GetLoadSaveWindow().SetSaveMode(true);
	mSaveMode = true;
	mCanExit = true;
	Open(false,true);
}

private function Open(optional bool mainMenuMode,optional bool saveMode)
{
	;

	class'H7PlayerController'.static.GetPlayerController().ScanForAllSaveGames();
	
	mMainMenuMode = mainMenuMode;

	if(!mainMenuMode)
	{
		TakeScreenShot();
		;
		GetLoadSaveWindow().SetScreenShot("img://" $ Pathname(mScreenshot)); // causes animation
	}
	else
	{
		mLoadSaveWindow.SetAnimateOnClosing(false); // closing zooms back to current game, but we have no current game here
	}

	GetLoadSaveWindow().SetData(!mMainMenuMode);
	
	GetLoadSaveWindow().SetCloseButton(mCanExit);

	// if save, select "new savegame" slot
	// if load, select "current game" slot
	// if main menu, preselect savegame1
	GetLoadSaveWindow().PreSelectIndex(0,true);

	// disable the current hud
	if(class'H7PlayerController'.static.GetPlayerController().GetMainMenuHud() != none)
	{
		class'H7PlayerController'.static.GetPlayerController().GetMainMenuHud().GetMainMenuCntl().GetMainMenu().SetVisibleSave(false);
	}
	else if(class'H7AdventureHudCntl'.static.GetInstance() != none && class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap())
	{
		class'H7AdventureHudCntl'.static.GetInstance().SetVisible(false);
	}
	else if(class'H7ReplicationInfo'.static.GetInstance().IsCombatMap())
	{
		class'H7CombatHudCntl'.static.GetInstance().SetCombatHudCntlVisible(false);
	}

	OpenPopup();
}

function Closed() // via flash called (after optional close animation has finished)
{
	ClosePopup();
	ZoomInComplete();
}

function ClosePopup()
{
	if(mCanExit || mLoadSelectedSaveGameAfterZoomIn) // you can close or it is a "load"-close
	{
		StopTakeScreenshot();

		super.ClosePopup();

		// hack - if game end state
		if(class'H7AdventureController'.static.GetInstance() != none 
			&& class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetQuestController().IsGameEnd())
		{
			// show end game menu again
			class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetQuestController().HideHUD(); // rehide hud, because super.ClosePopup showed parts
			class'H7PlayerController'.static.GetPlayerController().GetHud().GetPauseMenuCntl().ReOpenLastPopup();
		}

		// re-enable 1 of 3 huds
		if(class'H7PlayerController'.static.GetPlayerController().GetMainMenuHud() != none)
		{
			class'H7PlayerController'.static.GetPlayerController().GetMainMenuHud().GetMainMenuCntl().GetMainMenu().SetVisibleSave(true);
		}
		else if(class'H7AdventureHudCntl'.static.GetInstance() != none && class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap())
		{
			class'H7AdventureHudCntl'.static.GetInstance().SetVisible(true);
		}
		else if(class'H7ReplicationInfo'.static.GetInstance().IsCombatMap())
		{
			class'H7CombatHudCntl'.static.GetInstance().SetCombatHudCntlVisible(true);
		}

		class'H7PlayerController'.static.GetPlayerController().StopScan();

		if(mLoadSelectedSaveGameAfterZoomIn) // closed while zooming in to load
		{
			;
			ZoomInComplete(); // something interrupted the timer in flash that calls ZoomInComplete, so we have to call it here
		}

		mLoadSelectedSaveGameAfterZoomIn = false;
	}

	if( !class'H7ReplicationInfo'.static.GetInstance().IsMultiplayerGame() )
	{
		class'H7PlayerController'.static.GetPlayerController().SetPause( false );
	}
}

// test

function StartAdvance()
{
	super.StartAdvance();
}

function StopAdvance()
{
	super.StopAdvance();
}

function StopAdvanceReally()
{
	super.StopAdvanceReally();
}

///////////////////////////////////////////////////////////////////////////
// Save&Load //////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

function SaveGame(String filename)
{
	;
	mSelectedSaveGameFileName = filename;
	if(filename == "" || filename == "CURRENT_GAME" || filename == "-1") // new save slot
	{
		GetHUD().GetPopupCntl().GetRequestPopup().InputPopup("PU_ENTER_SAVEGAME",GetDefaultSaveGameName(),"SAVE","CANCEL",ProcessInput,none);
	}
	else // overwrite file
	{
		SaveGameName(filename,GetSaveNameFromFileName(filename));
	}
}

function string GetSaveNameFromFileName(string filename)
{
	local H7SaveGameHeaderManager header;
	header = class'H7PlayerController'.static.GetPlayerController().GetSaveGameHeaderManagerForSaveGame(int(filename));
	return header.GetName();
}

// reads what savegame name was put into the textfield by the user
function ProcessInput() 
{
	local string userInput,fileName;

	userInput = GetHUD().GetPopupCntl().GetRequestPopup().GetInput();
	fileName = mSelectedSaveGameFileName;
	;
	if(userInput != "")
	{
		SaveGameName(fileName,userInput);
	}
	else
	{
		GetHUD().GetPopupCntl().GetRequestPopup().InputPopup("PU_ENTER_SAVEGAME","","SAVE","CANCEL",ProcessInput,none);
	}
}

function SaveGameName(String filename,String savename)
{
	local string oldName;
	
	mSelectedSaveGameFileName = filename;
	mSelectedSaveGameSaveName = savename;
	if(class'H7PlayerController'.static.GetPlayerController().SaveGameExists(int(filename))) // check if exists
	{
		oldName = class'H7PlayerController'.static.GetPlayerController().GetSaveGameHeaderManagerForSaveGame(int(filename)).GetName();
		GetHUD().GetPopupCntl().GetRequestPopup().YesNoPopup(Repl(FlashLocalize("PU_OVERWRITE_CONFIRM"),"%savegame",oldName),"OVERWRITE","CANCEL",SaveGameConfirm,none);
	}
	else
	{
		SaveGameConfirm();
	}
}

function SaveGameConfirm()
{
	ClosePopup();
	GetHUD().GetPopupCntl().GetRequestPopup().NoChoicePopup("PU_SAVING");

	//`LOG_MP("SkillTrack: Performing ManualSave with TimeStamp "@class'H7PlayerController'.static.GetPlayerController().GetHud().GetTimeStamp()@" with name"@mSelectedSaveGameSaveName@"...");
	ScriptTrace();

	// ACTUAL SAVE | OVERWRITE
	class'H7PlayerController'.static.GetPlayerController().SaveGame(int(mSelectedSaveGameFileName),SAVETYPE_MANUAL,mSelectedSaveGameSaveName);

}

function LoadGame(String fileName)
{
	;
	if(fileName == "" || fileName == "-1") return;

	mSelectedSaveGameFileName = fileName;
	if(HasUnsavedChanges())
	{
		GetHUD().GetPopupCntl().GetRequestPopup().YesNoPopup("PU_LOAD_CONFIRM","PU_LOAD_ANYWAY","CANCEL",LoadGameConfirm,none);
	}
	else
	{
		LoadGameConfirm();
	}
}

function LoadGameConfirm()
{
	if(class'H7PlayerController'.static.GetPlayerController().GetSaveGameHeaderManagerForSaveGame(int(mSelectedSaveGameFileName)).GetGameMode() == MULTIPLAYER)
	{
		GetHUD().GetPopupCntl().GetRequestPopup().YesNoPopup(
			"PU_MULTIPLAYER_LOAD","PU_MULTIPLAYER_LOAD_LAN","PU_MULTIPLAYER_LOAD_INET",LoadMultiplayerGameLAN,LoadMultiplayerGameINET,true);

		if(	OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).GetLoginStatus(0) == LS_NotLoggedIn)
		{
			GetHUD().GetPopupCntl().GetRequestPopup().SetNoButtonState(false, class'H7Loca'.static.LocalizeSave("UPLAY_ONLINE_SERVICES_NOT_AVAILABLE","H7UPlay"));
		}
	}
	else
	{
		mLoadSelectedSaveGameAfterZoomIn = true;
		GetLoadSaveWindow().ZoomIn();
		// Goes to: ZoomInComplete(); and Closed();
	}
}

function LoadMultiplayerGameLAN()   { LoadMultiplayerGame(true);    }
function LoadMultiplayerGameINET()  { LoadMultiplayerGame(false);   }

function LoadMultiplayerGame(bool isLAN)
{
	local H7SaveGameHeaderManager header;
	local H7ContentScannerAdventureMapData mapHeader;
	local H7ListingSavegameDataScene saveData;

	header = class'H7PlayerController'.static.GetPlayerController().GetSaveGameHeaderManagerForSaveGame(int(mSelectedSaveGameFileName));

	class'H7ReplicationInfo'.static.PrintLogMessage("---LoadMultiplayerGame--> mSelectedSaveGameFileName:" @ mSelectedSaveGameFileName @ int(mSelectedSaveGameFileName) @ header.GetMapFileName(), 0);;

	saveData.SlotIndex = int(mSelectedSaveGameFileName);
	saveData.SavegameData = header.GetData();
	
	mapHeader.Filename = header.GetMapFileName();
	class'H7ListingMap'.static.ScanMapHeader( mapHeader.Filename, mapHeader.AdventureMapData, true );

	class'H7ReplicationInfo'.static.PrintLogMessage("----->" @ saveData.SlotIndex @ saveData.SavegameData.mSaveGameCheckSum @ mapHeader.Filename, 0);;
	class'H7MultiplayerGameManager'.static.GetInstance().CreateOnlineGame( 
		isLAN, false, mapHeader.AdventureMapData.mPlayerAmount, mapHeader,, saveData
	);
}

function ZoomInComplete()
{
	;
	if(mLoadSelectedSaveGameAfterZoomIn)
	{
		//ClosePopup();
		GetHUD().GetPopupCntl().GetRequestPopup().NoChoicePopup("PU_LOADING");
		// ACTUAL LOAD
		class'H7PlayerController'.static.GetPlayerController().StopScan();
		class'H7PlayerController'.static.GetPlayerController().LoadGameState(
			int(mSelectedSaveGameFileName),
			class'H7PlayerController'.static.GetPlayerController().GetSaveGameHeaderManagerForSaveGame(int(mSelectedSaveGameFileName)).GetMapFileName()
		);
	}
}

///////////////////////////////////////////////////////////////////////////
// Delete /////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

function DeleteCurrentSave()
{
	mLoadSaveWindow.TriggerDeleteClick();
}

function DeleteGame(String id)
{
	local string saveName;
	;
	mSelectedSaveGameFileName = id;
	
	saveName = class'H7PlayerController'.static.GetPlayerController().GetSaveGameHeaderManagerForSaveGame(int(mSelectedSaveGameFileName)).GetName();
	
	GetHUD().GetPopupCntl().GetRequestPopup().YesNoPopup(Repl(FlashLocalize("PU_DELETE_CONFIRM"),"%savegame",saveName),"DELETE","CANCEL",DeleteGameConfirm,none);
}

function DeleteGameConfirm()
{
	//mDeletingSaveGameIndex = GetIndexOf(mSelectedSaveGameFileName);
	//`log_gui("old i" @ mDeletingSaveGameIndex);
	
	// ACTUAL DELETE
	class'H7PlayerController'.static.GetPlayerController().DeleteSaveGame(int(mSelectedSaveGameFileName),DeleteGameComplete);
	
	GetHUD().GetRequestPopupCntl().GetRequestPopup().NoChoicePopup("PU_WAIT_FOR_SAVEGAME_DELETE");
}

function DeleteGameComplete()
{
	//local int currentGameSlot;

	GetHUD().GetRequestPopupCntl().GetRequestPopup().Finish();

	GetLoadSaveWindow().SetData(!mMainMenuMode);

	GetLoadSaveWindow().ActionScriptVoid("SelectNewSaveGameAfterDelete");

	//currentGameSlot = mMainMenuMode?0:1;
	
	/*
	if( mDeletingSaveGameIndex < class'H7PlayerController'.static.GetPlayerController().GetSaveGameList().length + currentGameSlot)
	{
		GetLoadSaveWindow().PreSelectIndex(mDeletingSaveGameIndex,false);
	}
	else if(mDeletingSaveGameIndex > 0)
	{
		GetLoadSaveWindow().PreSelectIndex(mDeletingSaveGameIndex-1,false);
	}
	else
	{
		// nothing to select anymore, but update menu
		GetLoadSaveWindow().PreSelectIndex(0, false);
		
	}
	mDeletingSaveGameIndex = INDEX_NONE;
	*/
}









///////////////////////////////////////////////////////////////////////////
// Screenshot /////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

function TakeScreenShot()
{
	local float sampleFactor;
	local PostProcessEffect effect;

	sampleFactor = 0.5;

	// re-use the existing things that we already use for Pixellated mode
	mScreenshot = TextureRenderTarget2D'H7PostProcess.PixelMode.T_PixelModeTarget';
	//mScreenshot.SRGB = false; // has no effect :-(
	effect = class'H7PlayerController'.static.GetLocalPlayer().PlayerPostProcess.FindPostProcessEffect('PixelModeRender');
	if (effect != None)
	{
		// save the used settings to restore them later because they belong to pixelmode
		mSavedBufferRatio = RenderTargetMaterialEffect(effect).RenderTargetRatioSize;
		mSavedBufferActive = effect.bShowInGame;
		effect.bShowInGame = true;
		RenderTargetMaterialEffect(effect).RenderTargetRatioSize = sampleFactor;
	}

	mScreenshotInProgress = true;

	//GetHUD().SetFrameTimer(2,StopTakeScreenshot);
}

function StopTakeScreenshot()
{
	local PostProcessEffect effect;

	effect = class'H7PlayerController'.static.GetLocalPlayer().PlayerPostProcess.FindPostProcessEffect('PixelModeRender');
	if (effect != None)
	{
		RenderTargetMaterialEffect(effect).RenderTargetRatioSize = mSavedBufferRatio;
		effect.bShowInGame = mSavedBufferActive;
	}

	mScreenshotInProgress = false;

	if(mPendingSlotToSaveScreenshot != INDEX_NONE) // savegame saved to disk before screenshot finished
	{
		SaveCurrentScreenshotTo(string(mPendingSlotToSaveScreenshot));
	}
}

// savegame system tells us it has saved a file to this slotIndex
function SavedGameToSlot(int slotIndex)
{
	if(mScreenshotInProgress)
	{
		mPendingSlotToSaveScreenshot = slotIndex;
	}
	else
	{
		SaveCurrentScreenshotTo(string(slotIndex));
	}
}

// saves what is currently in mScreenshot to filename.shot (which belongs to filename.h7save)
function SaveCurrentScreenshotTo(String filename)
{
	local bool success;
	local string savePath;

	mPendingSlotToSaveScreenshot = INDEX_NONE;

	savePath = class'H7ListingSavegame'.static.GetSavegameFolderPath();

	;

	success = class'H7EngineUtility'.static.SaveRenderTargetToFile(savePath $ filename $ ".shot",mScreenshot);

	if(success)
		;
	else 
		;
}

// loads the screenshot of a savegame into a texture2d
// later flash accesses this texture2d with a path
function LoadScreenshot(String filename)
{
	local Texture2D shotTexture;
	local string savePath;

	savePath = class'H7ListingSavegame'.static.GetSavegameFolderPath();

	;

	shotTexture = class'H7EngineUtility'.static.LoadTextureFromFile(savePath $ filename $ ".shot");

	;

	if(shotTexture == none)
	{
		shotTexture = class'H7BackgroundImageCntl'.static.GetInstance().mBackgroundImageProperties.FallbackScreenshot;
	}

	InformFlashOfPath("img://" $ Pathname(shotTexture));
}

function InformFlashOfPath(String path)
{
	GetLoadSaveWindow().ActionScriptVoid("InformFlashOfPath");
}

function TextureRenderTarget2D GetScreenshot()
{
	return mScreenshot;
}

function int GetResolutionWidth()
{
	local Vector2D currentRes;
	currentRes = class'H7PlayerController'.static.GetPlayerController().GetScreenResolution();
	return currentRes.X;
}

function int GetResolutionHeight()
{
	local Vector2D currentRes;
	currentRes = class'H7PlayerController'.static.GetPlayerController().GetScreenResolution();
	return currentRes.Y;
}



///////////////////////////////////////////////////////////////////////////
// SYSTEM DATA ////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
// save game system questions

function bool HasUnsavedChanges()
{
	if(mMainMenuMode) return false;
	return true; // OPTIONAL just assume yes for now
}

function String GetDefaultSaveGameName()
{
	return class'H7Loca'.static.LocalizeSave("DEFAULT_SAVEGAME_NAME","H7LoadSaveWindow"); // OPTIONAL something else
}

function int GetIndexOf(String filename)
{
	return class'H7PlayerController'.static.GetPlayerController().GetIndexOf(filename);
}

