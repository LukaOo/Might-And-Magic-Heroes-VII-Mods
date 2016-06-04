//=============================================================================
// SaveGameStatePlayerController: Player Controller used to test the 
// SaveGameState.
//
// This player controller has an example of how you would use the SaveGameState
// code base within your game.
// 
// Copyright 1998-2012 Epic Games, Inc. All Rights Reserved.
//=============================================================================
class SaveGameStatePlayerController extends GamePlayerController
	dependson(H7ListingSavegame, H7CampaignDefinition)
	config(Game)
	native(Core);

//var protected string mQuicksaveFileName;
//var protected string mAutosaveFileName;

var protected H7SaveGameHeaderManager mSaveGameHeaderManager;

var protected H7ListingSavegame mSaveGameScanner; // scanner
var protected bool mCanPoll; // if I can poll the scanner
var protected array<H7ListingSavegameDataScene> mSaveGameList; // last/currently scanned list

var transient bool mScanningSaves;
var transient array<H7ListingSavegameDataScene> mScannedSaves;



var transient array<H7SavegameTask_Base> mSaveLoadTasks;

var transient bool mSavedThisTick;
var transient bool mLoadedThisTick;

var transient bool mSaveTaskSucceeded;
var transient bool mLoadTaskSucceeded;
var transient bool mDeleteTaskSucceeded;

var transient bool mCheckTaskSucceeded;

var transient int mSlotCheckStatus;
var transient bool mPreSlotCheck;
var transient bool mPostSlotCheck;

var transient bool mSlotCheckMP;

var protected bool mWantsQuickLoad;

struct native H7SaveGameEntry
{
	var String name;
	var int time;
	var String humanTime;
};

public delegate mOnDeleteComplete();

function H7SaveGameHeaderManager GetSaveGameHeaderManager() { return mSaveGameHeaderManager; }
function H7Hud GetHUD() { return none; }

simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	mSaveGameScanner = new class'H7ListingSavegame';
	mSaveGameHeaderManager = new class'H7SaveGameHeaderManager';
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Savegame List Scanning
///////////////////////////////////////////////////////////////////////////////////////////////////

function ScanForAllSaveGames()
{
	mSaveGameList.Length = 0;
	mSaveGameScanner.Start();
	mCanPoll = true;
	
	GetHUD().SetFrameTimer(1,ProcessScan);
}

function ProcessScan()
{
	local array<H7ListingSavegameDataScene> newSavegames;
	local int isDone;
	local int i;

	if(!mCanPoll) return;

	mSaveGameScanner.Poll(newSavegames,isDone);

	for(i=0;i<newSavegames.Length;i++)
	{
		//newSavegames[i].SlotIndex = newSavegames[i].SlotIndex;
		mSaveGameList.AddItem(newSavegames[i]);
	}

	if(class'H7PlayerController'.static.GetPlayerController().GetHud().GetLoadSaveWindowCntl().GetLoadSaveWindow().IsVisible())
	{
		class'H7PlayerController'.static.GetPlayerController().GetHud().GetLoadSaveWindowCntl().GetLoadSaveWindow().AddSaveGames(newSavegames);
	}

	if(isDone == 0)
	{
		GetHUD().SetFrameTimer(1,ProcessScan);
	}
	else
	{
		ScanComplete();
	}
}

function ScanComplete()
{
	;

	StopScan();
	SortSaveGameList();

	if(mWantsQuickLoad)
	{
		mWantsQuickLoad = false;

		if(H7AdventurePlayerController(self) != none)
		{
			H7AdventurePlayerController(self).DeferredQuickLoadPopup();
		}
	}
}

function StopScan()
{
	mCanPoll = false;
	mSaveGameScanner.Stop();
}

function ScanForAllSaveGamesMP(optional bool justSlotCheck = false)
{
	mSaveGameList.Length = 0;
	mSaveGameScanner.Start();
	mCanPoll = true;
	mSlotCheckMP = justSlotCheck;
	
	GetHUD().SetFrameTimer(1,ProcessScanMP);
}

function ProcessScanMP()
{
	local array<H7ListingSavegameDataScene> newSavegames;
	local int isDone;
	local int i;

	if(!mCanPoll) return;

	mSaveGameScanner.Poll(newSavegames,isDone);

	for(i=0;i<newSavegames.Length;i++)
	{
		mSaveGameList.AddItem(newSavegames[i]);
	}

	if(isDone == 0)
	{
		GetHUD().SetFrameTimer(1,ProcessScanMP);
	}
	else
	{
		StopScan();
		if(mSlotCheckMP)
		{
			mSlotCheckMP = false;
			class'H7ReplicationInfo'.static.GetInstance().CompleteSlotCheckMP();
		}
		else
		{
			class'H7ReplicationInfo'.static.GetInstance().SavegameMPScanCompleted();
		}
		
	}
}
function int GetSlotIdMP( int checksum )
{
	local int i;

	for(i=0;i<mSaveGameList.Length;i++)
	{
		class'H7ReplicationInfo'.static.PrintLogMessage("CHECKSUM:" @ mSaveGameList[i].SavegameData.mSaveGameCheckSum, 0);;
		if( mSaveGameList[i].SavegameData.mSaveGameCheckSum == checksum )
		{
			return mSaveGameList[i].SlotIndex;
		}
	}

	return -1;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Load&Save
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * This exec function will save the game state to the file name provided.
 *
 * @param		slotIndex		Slot index to save the SaveGameState to
 */
exec function SaveGame(int slotIndex,optional ESaveType saveType = SAVETYPE_NONE,optional string userInputName)
{
	local H7InstantCommandSaveGame command;
	
	if( class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() && class'H7ReplicationInfo'.static.GetInstance().Role == ROLE_Authority )
	{
		command = new class'H7InstantCommandSaveGame';
		command.Init( slotIndex, userInputName );
		class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
	}
	else
	{
		SaveGameComplete( slotIndex, saveType, userInputName );
	}
}

function SaveGameComplete(int slotIndex,optional ESaveType saveType = SAVETYPE_NONE,optional string userInputName)
{
	local H7SavegameData headerData;
	local H7SavegameTask_Saving newSaveTask;

	mSaveGameHeaderManager.Setup(saveType,userInputName,true);
	headerData = mSaveGameHeaderManager.GetData();
	
	switch( saveType )
	{
		case SAVETYPE_NONE:
		case SAVETYPE_MANUAL:
			if( mSavedThisTick ) { break; }
			if( slotIndex != INDEX_NONE )
			{
				newSaveTask = new class'H7SavegameTask_Saving';
				if(newSaveTask != none)
				{
					newSaveTask.StartSceneSaveTask( slotIndex, userInputName, headerData );

					mSaveLoadTasks.AddItem(newSaveTask);

					mSavedThisTick = true;
				}
				else
				{
					;
				}
			}
			else
			{
				newSaveTask = new class'H7SavegameTask_Saving';
				if(newSaveTask != none)
				{
					newSaveTask.StartSceneSaveTaskToAreaSlot( H7SavegameSlotType_Normal, userInputName, headerData );

					mSaveLoadTasks.AddItem(newSaveTask);

					mSavedThisTick = true;
				}
				else
				{
					;
				}
			}
			break;
		case SAVETYPE_QUICK:
			if( mSavedThisTick ) { break; }
			newSaveTask = new class'H7SavegameTask_Saving';
			if(newSaveTask != none)
			{
				newSaveTask.StartSceneSaveTask( class'H7SavegameController'.const.SLOT_QUICKSAVE, userInputName, headerData );

				mSaveLoadTasks.AddItem(newSaveTask);

				mSavedThisTick = true;
			}
			else
			{
				;
			}
			break;
		case SAVETYPE_AUTO:
			if( mSavedThisTick ) { break; }
			newSaveTask = new class'H7SavegameTask_Saving';
			if(newSaveTask != none)
			{
				newSaveTask.StartSceneSaveTaskToAreaSlot( H7SavegameSlotType_Autosave, "Autosave", headerData );

				mSaveLoadTasks.AddItem(newSaveTask);

				mSavedThisTick = true;
			}
			else
			{
				;
			}

			break;
		default:
	}
	
	if(saveType != SAVETYPE_AUTO)
	{
		GetHUD().GetRequestPopupCntl().GetRequestPopup().Finish();
	}
}

function ClearSavesCache()
{
	mScannedSaves.Length = 0;
	mScanningSaves = false;
	// Call scanner to stop in case its running
	if(mSaveGameScanner != none)
	{
		mSaveGameScanner.Stop();
	}
	
}

// Called when entering councilHub to cache list of savegames to memory
function CacheSaves()
{
	if(mSaveGameScanner != none)
	{
		mScannedSaves.Length = 0;

		mSaveGameScanner.Start();

		mScanningSaves = true;
	}
}

/**
 * This exec function will load the game state from the file name provided
 *
 * @param		slotIdx		Slot index of load the SaveGameState from
 */
exec function LoadGameState(int slotIdx, string mapName, optional bool isMultiplayer = false)
{
	local H7SavegameTask_Loading newLoadTask;
	local MaterialInterface loadedLoadScreen;
	local array<H7CampaignDefinition> theCampaigns;
	local H7CampaignDefinition theCampaign;
	local H7MapEntry theMapEntry;

	// Instance the save game state
	if( !class'WorldInfo'.static.GetWorldInfo().IsMenuLevel() )
	{
		if( class'H7AdventureController'.static.GetInstance() != none )
		{
			class'H7AdventureController'.static.GetInstance().TrackingMapEnd("LOAD");
			class'H7AdventureController'.static.GetInstance().TrackingGameModeEnd();
		}
		else // then it is a duel map
		{
			class'H7CombatController'.static.GetInstance().TrackingMapEnd("LOAD");
			class'H7CombatController'.static.GetInstance().TrackingGameModeEnd();
		}
	}

	// initialize the loadscreen
	if (!isMultiplayer)
	{
		class'H7GameData'.static.GetInstance().GetCampaigns(theCampaigns);
		foreach theCampaigns(theCampaign)
		{
			foreach theCampaign.mCampaignMaps(theMapEntry)
			{
				if (theMapEntry.mFileName ~= mapName)
				{
					theCampaign.DynLoadObjectProperty('mLoadScreenBackground');
					loadedLoadScreen = theCampaign.GetLoadscreenBackground();
					break;
				}
			}
		}
	}
	class'H7PlayerController'.static.GetPlayerController().InitLoadingScreen(loadedLoadScreen);

	if( !mLoadedThisTick )
	{
		newLoadTask = new class'H7SavegameTask_Loading';

		if(newLoadTask != none)
		{
			newLoadTask.StartLoadTask( slotIdx );

			mSaveLoadTasks.AddItem(newLoadTask);
			class'H7TransitionData'.static.GetInstance().SetCurrentLoadTask( newLoadTask );

			mLoadedThisTick = true;
		}
		else
		{
			;
		}

		;
		// Start the map with the command line parameters required to then load the save game state
		class'H7TransitionData'.static.GetInstance().SetLoadingSave( true ); //TODO: MP, add functionality to notify clients that they need to load and it's a loaded game (BEFORE MAP LOAD)
		class'H7TransitionData'.static.GetInstance().SetLoadedGame( true );

		if( !isMultiplayer )
		{
			ConsoleCommand("start "$mapName);
		}
	}
}

exec function DeleteSaveGame(int slotIndex,delegate<mOnDeleteComplete> callbackFunction)
{
	local int i;

	mOnDeleteComplete = callbackFunction;

	// delete from uplay
	DeleteSaveGameInUplay(slotIndex);

	// delete from list (so we don't have to rescan)
	for(i=mSaveGameList.Length-1;i>=0;i--)
	{
		if(mSaveGameList[i].SlotIndex == slotIndex)
		{
			mSaveGameList.Remove(i,1);
		}
	}
}

function DeleteSaveGameInUplay(int slotIndex)
{
	local H7SavegameTask_Delete newDeleteTask;

	newDeleteTask = new class'H7SavegameTask_Delete';
	if(newDeleteTask != none)
	{
		newDeleteTask.StartDeleteTask( slotIndex );

		mSaveLoadTasks.AddItem(newDeleteTask);
	}
	else
	{
		;
	}
}

// returns a list of all available save games
exec function array<H7ListingSavegameDataScene> GetSaveGameList()
{
	return mSaveGameList;
}

function SortSaveGameList()
{
	mSaveGameList.Sort(SaveGameSort);
}

delegate int SaveGameSort(H7ListingSavegameDataScene A, H7ListingSavegameDataScene B) { return A.SavegameData.mSaveTimeUnix < B.SavegameData.mSaveTimeUnix ? -1 : 0; }

function int GetIndexOf(string fileName)
{
	local int i;
	
	for(i=0;i<mSaveGameList.Length;i++)
	{
		if(mSaveGameList[i].SlotIndex == int(fileName))
		{
			return i;
		}
	}

	return INDEX_NONE;
}

function bool SaveGameExists(int slotIndex)
{
	local int i;

	for(i=0;i<mSaveGameList.Length;i++)
	{
		if(mSaveGameList[i].SlotIndex == slotIndex)
		{
			return true;
		}
	}

	return false;
}

// extracts the savegameheader from a savegame and returns the savegameheader(manager)
exec function H7SaveGameHeaderManager GetSaveGameHeaderManagerForSaveGame(int slotIndex)
{
	local H7SaveGameHeaderManager headerManager;
	//local H7SavegameData headerData;
	local H7ListingSavegameDataScene header;

	// check if in list
	foreach mSaveGameList(header)
	{
		if(header.SlotIndex == slotIndex)
		{
			headerManager = new class'H7SaveGameHeaderManager';
			headerManager.SetData(header.SavegameData,header.HealthStatus);
			return headerManager;
		}
	}

	// complete and utter failure, no way to rescue this
	;

	/*
	// hard load
	class'H7SavegameController'.static.ScanSavegameHeader(FileName,headerData);
	headerManager = new class'H7SaveGameHeaderManager';
	headerManager.SetData(headerData);

	// add it to list in case it is requested again
	header.Name = FileName;
	header.SavegameData = headerData;
	mSaveGameList.AddItem(header);
	*/

	return headerManager;
}

/**
 * This function just scrubs the FileName to ensure that it is valid
 *
 * @param		FileName		Unscrubbed file name
 * @return						Returns the scrubbed file name
 */
// DEPRECATED only used for transition saves
function String ScrubFileName(string FileName)
{
	// Add the extension if it does not exist
	if (InStr(FileName, ".sav",, true) == INDEX_NONE)
	{
		FileName $= ".sav";
	}

	// If the file name has spaces, replace then with under scores
	FileName = Repl(FileName, " ", "_");

	return FileName;
}

// input: My Cool Save Game
// output: My Cool Save Game
function String ScrubUserSaveName(string userSaveName)
{
	// scrub forbidden chars // already done in flash for now OPTIONAL allow in flash, then scrub here

	return userSaveName;
}

// input: My Cool Save Game.h7save
// output: My Cool Save Game
function String ScrubScannerSaveName(string scannerSaveName)
{
	scannerSaveName = Repl(scannerSaveName, ".h7save", "");

	return scannerSaveName;
}





///////////////////////////////////////////////////////////////////////////////////////////////////
// Hero Transition Save
///////////////////////////////////////////////////////////////////////////////////////////////////

//exec function SetTransitionSave(string FileName)
//{
//	local SaveGameTransition SaveGameTransition;
//	SaveGameTransition = new class'SaveGameTransition';
//	FileName = ScrubFileName(FileName);
//	SaveGameTransition.Save();
//	if (class'Engine'.static.BasicSaveObject(SaveGameTransition, FileName, true, 1)) // TODO CRITICAL now broken with new system
//	{
		
//	}
//}
/**
 * This exec function will save the playerprofilestate to the file name provided.
 *
 * @param      FileName      File name to save the SaveGameState to
 */
exec function SavePlayerProfileState(string FileName)
{
	local PlayerProfileState playerProfileState;

	local H7MapInfo currentMapinfo;
	
	currentMapInfo = H7MapInfo(class'H7GameUtility'.static.GetAdventureMapMapInfo());

	if(currentMapinfo == None)
	{
		return;
	}

	// Instance the save game state
	playerProfileState = new () class'PlayerProfileState';
	if (playerProfileState == None)
	{
		return;
	}
	
	// Scrub the file name
	FileName = ScrubFileName(FileName);

	// Ask the save game state to save the game
	//playerProfileState.Save();

	// Serialize the save game state object onto disk
	if (class'Engine'.static.BasicSaveObject(playerProfileState, FileName, false, class'PlayerProfileState'.const.SAVEGAMESTATE_REVISION))
	{
		// If successful then send a message
		ClientMessage("Saved game state to "$FileName$".", 'System');
	}
}

/**
 * This exec function will load the playerprofile from the file name provided
 *
 * @param    FileName    File name of load the SaveGameState from
 */
exec function LoadPlayerProfileState(string FileName)
{
	local PlayerProfileState playerProfileState;
	local H7MapInfo currentMapinfo;
	
	currentMapInfo = H7MapInfo(class'H7GameUtility'.static.GetAdventureMapMapInfo());

	if(currentMapinfo == None)
	{
		return;
	}

	// Instance the save game state
	playerProfileState = new () class'PlayerProfileState';

	if (playerProfileState == None)
	{
		return;
	}

	// Scrub the file name
	FileName = ScrubFileName(FileName);

	// Attempt to deserialize the save game state object from disk
	if (class'Engine'.static.BasicLoadObject(playerProfileState, FileName, false, class'PlayerProfileState'.const.SAVEGAMESTATE_REVISION))
	{
		//playerProfileState.Load();
	}
}

event ComputeTick()
{
	local int i, isScanningDone, slotIndex;
	local array<H7ListingSavegameDataScene> tempSaves;
	local H7SavegameTask_Saving saveTask;
	//local H7SavegameTask_Loading loadTask;
	local H7SavegameTask_Delete deleteTask;

	mSavedThisTick = false;
	mLoadedThisTick = false;

	if(mSaveLoadTasks.Length > 0)
	{
		for(i = 0; i < mSaveLoadTasks.Length; ++i)
		{
			if(mSaveLoadTasks[i] != none)
			{
				if(mSaveLoadTasks[i].GetCurrentTaskState() == H7SavegameControllerTaskState_InProgress)
				{
					mSaveLoadTasks[i].UpdateStatus();
				}

			
				if(mSaveLoadTasks[i].GetCurrentTaskState() == H7SavegameControllerTaskState_ReadyToFinish)
				{
					if(H7SavegameTask_Saving(mSaveLoadTasks[i]) != none)
					{   
						saveTask = H7SavegameTask_Saving(mSaveLoadTasks[i]);

						mSaveTaskSucceeded = saveTask.FinishSaveTaskGetSlot(slotIndex);

						if(!mSaveTaskSucceeded)
						{
							;
						}
						else
						{
							class'H7LoadSaveWindowCntl'.static.GetInstance().SavedGameToSlot(slotIndex);
						}
					}
					//else if(H7SavegameTask_Loading(mSaveLoadTasks[i]) != none)
					//{
					//	loadTask = H7SavegameTask_Loading(mSaveLoadTasks[i]);

					//	mLoadTaskSucceeded = loadTask.FinishSceneLoadTask();

					//	if(!mLoadTaskSucceeded)
					//	{
					//		`warn("-- Load Failed -- " @ loadTask );
					//	}
					//}
					else if( H7SavegameTask_Delete( mSaveLoadTasks[i] ) != none )
					{
						deleteTask = H7SavegameTask_Delete(mSaveLoadTasks[i]);

						mDeleteTaskSucceeded = deleteTask.FinishDeleteTask();

						if(!mDeleteTaskSucceeded)
						{
							;
						}
						mOnDeleteComplete();
					}

					mSaveLoadTasks[i] = none;
				}
			}
		}

		// Clear empty space
		for(i = mSaveLoadTasks.Length-1; i >= 0; --i)
		{
			if(mSaveLoadTasks[i] == none)
			{
				mSaveLoadTasks.Remove(i, 1);
			}
		}
	}

	if(mScanningSaves)
	{
		mSaveGameScanner.Poll(tempSaves, isScanningDone);

		for(i = 0; i < tempSaves.Length; ++i)
		{
			mScannedSaves.AddItem(tempSaves[i]);
		}

		if(isScanningDone > 0)
		{
			mSaveGameScanner.Stop();

			mScanningSaves = false;
		}
	}
}

exec function ExitHeroes()
{
	if(class'H7AdventureController'.static.GetInstance() != none)
	{
		class'H7AdventureController'.static.GetInstance().TrackingMapEnd("FORCE_QUIT");
		class'H7AdventureController'.static.GetInstance().TrackingGameModeEnd();
	}
	else if(class'H7CombatController'.static.GetInstance() != none)
	{
		class'H7CombatController'.static.GetInstance().TrackingMapEnd("FORCE_QUIT");
		class'H7CombatController'.static.GetInstance().TrackingGameModeEnd();
	}

	class'H7PlayerController'.static.GetPlayerController().ConsoleCommand("quit");
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


