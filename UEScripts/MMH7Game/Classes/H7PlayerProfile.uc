//=============================================================================
// H7PlayerProfile
//
// Contains all infos about a player
// - is a global savegame file like Ivan_1,Ivan_2
// contains:
// - achivements (uplay)
// - heropedia entry states ()
// - campaign completion states
// - ...?
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7PlayerProfile extends Object
	hidecategories(Object)
	dependson(H7StructsAndEnumsNative)
	native;

const PLAYERPROFILE_REVISION = 5;

var protected string mName;

// UPlay account name (static)
var protected string mUserName;
// UPlay privileges IDs
var protected transient array<int> mUserPrivileges;

var protected bool mHasEnteredCouncil;
var protected transient bool mHasEnteredCouncilForTheFirstTime;

var array<CampaignProgress> mCampaignsProgress;
// DON'T CHANGE THIS DIRECTLY ! Use ChangeCurrentCampaign
var protected int mPlayedCampaignID;

// All played cinematics (BIK), unique
var protected array<MovieData> mPlayedBIKCinematic;
// All map types, non-unique
var protected int mNumOfStartedMaps;

// Gameplay time (AM+CM) excluding Pause/Cinematics cleared every 60s
var protected float mGameplayTimeSec;

// Minutes -> Total gameplay time (AM+CM) excluding Pause/Cinematics/Matinees
var protected int mTotalGameplayTimeMin; // <- @FUNFACT: It will take ~4083 YEARS of gameplay to overflow it :)

// Minutes -> Duel excluding Pause/Cinematics/Matinees. Reseted after combat is finished.
var transient protected int mDuelMapTime; 
var transient protected float mDuelMapSec;

var protected array<H7MapSaveMapping> mContinueSaveGames; // TODO actually fill this array

// List of all played maps and their data, unique, exclude campaign
var protected array<BaseMapProgress> mNormalMapsData;

// Difficulty that is selected in GUI when starting map (or inhereted from previous map)
var protected H7DifficultyParameters mSelectedDifficulty;

// Currently played map ID for faster access in mMapsData 
var protected transient int mCurrentNormalMapID;

var protected transient string mCurrentMapFile;

var transient bool mScanningSaves;
var transient H7ListingSavegame mSaveGameScanner;
var transient array<H7ListingSavegameDataScene> mScannedSaves;

var transient bool mReloadProfile;

var transient array<H7SavegameTask_Base> mSaveLoadTasks;

var transient bool mSavedThisTick;
var transient bool mSavedTransThisTick;
var transient bool mLoadedThisTick;
var transient bool mCheckedThisTick;

var transient bool mSaveTaskSucceeded;
var transient bool mLoadTaskSucceeded;
var transient bool mCheckTaskSucceeded;

var transient H7CampaignTransitionManager mCampaignTransManager;
var transient bool mLookingForCampTransData;

var transient bool mRewardsPulled;

var transient H7AchievementManager mAchievementManager;

var array<H7UPlayReward> mUPlayRewards;
// Cache for UPlay actions coz UPlay...
var array<H7UPlayAction> mUPlayActions;

var transient bool mScanningCampaigns;
var transient array<H7CampaignDefinition> mUserCampaignDefinitions;
var transient H7ListingCampaign mUserCampaignScanner;

function bool AreRewardsPulled() { return mRewardsPulled; }

function H7CampaignTransitionManager GetCampTransManager() { return mCampaignTransManager; }
function H7AchievementManager GetAchievementManager() { return mAchievementManager; } 

static function H7PlayerProfile GetInstance()           {   return class'H7TransitionData'.static.GetInstance().GetPlayerProfile();   }
static function string GetFileName(string profileName)  {	return profileName $ ".h7p";    }

native function bool HasPrivileg(int privileg);
native function GetUserPrivileges(out array<int> userPrivileges, bool onlyOwned);
native function string GetPrivilegeName(int privilege);

function H7DifficultyParameters GetSelectedDifficulty() { return mSelectedDifficulty; } 
function EDifficulty GetSelectedDifficultyConverted() { return GetDifficulty(mSelectedDifficulty); }
function SetSelectedDifficulty(H7DifficultyParameters newDifficultyParams) { mSelectedDifficulty = newDifficultyParams; }
function int GetNumCustomCampaign() { return mUserCampaignDefinitions.Length; }

function EDifficulty GetDifficulty(H7DifficultyParameters difficultyParams)
{
	if(difficultyParams.mStartResources == DSR_ABUNDANCE
	&& difficultyParams.mCritterStartSize == DCSS_FEW
	&& difficultyParams.mCritterGrowthRate == DCGR_SLOW
	&& difficultyParams.mAiEcoStrength == DAIES_POOR)
	{
		return DIFFICULTY_EASY;
	}
	else if(difficultyParams.mStartResources == DSR_AVERAGE
		 	&& difficultyParams.mCritterStartSize == DCSS_AVERAGE
		 	&& difficultyParams.mCritterGrowthRate == DCGR_AVERAGE
			&& difficultyParams.mAiEcoStrength == DAIES_AVERAGE)
	{
		return DIFFICULTY_NORMAL;
	}
	else if(difficultyParams.mStartResources == DSR_LIMITED
		 	&& difficultyParams.mCritterStartSize == DCSS_MANY
		 	&& difficultyParams.mCritterGrowthRate == DCGR_FAST
			&& difficultyParams.mAiEcoStrength == DAIES_PROSPEROUS)
	{   
		return DIFFICULTY_HARD;
	}
	else if(difficultyParams.mStartResources == DSR_SHORTAGE
		 	&& difficultyParams.mCritterStartSize == DCSS_HORDES
		 	&& difficultyParams.mCritterGrowthRate == DCGR_PROLIFIC
			&& difficultyParams.mAiEcoStrength == DAIES_RICH)
	{
		return DIFFICULTY_HEROIC;
	}
	else
	{
		return DIFFICULTY_CUSTOM;
	}
}

function bool IsHigherDifficulty(H7DifficultyParameters diffParamCheck, H7DifficultyParameters diffParamCompare)
{
	local EDifficulty simpleDiff1, simpleDiff2;

	simpleDiff1 = GetDifficulty(diffParamCheck);
	simpleDiff2 = GetDifficulty(diffParamCompare);

	// Custom difficulty is considered as lowest
	if(simpleDiff1 == DIFFICULTY_CUSTOM)
	{   
		return false;
	}

	// If compre diff is Custom anything then Custom is higher
	if(simpleDiff1 != DIFFICULTY_CUSTOM && simpleDiff2 == DIFFICULTY_CUSTOM)
	{
		return true;
	}

	if(simpleDiff1 > simpleDiff2)
	{
		return true;
	}

	return false;
}

function BaseMapProgress CampaignMapToBase(CampaignMapProgress campaignData)
{
	local BaseMapProgress temp;

	// Since UC is so brilliant with structs...
	temp.MapFileName = Caps(campaignData.MapFileName);
	temp.StartTimesCount = campaignData.StartTimesCount;
	temp.StartTimesUntilCompleted = campaignData.StartTimesUntilCompleted;
	temp.TotalGameplayTimeMin = campaignData.TotalGameplayTimeMin;
	temp.GameplayTimeSec = campaignData.GameplayTimeSec;
	temp.WasOnceCompleted = campaignData.WasOnceCompleted;
	temp.TurnsUntilCompleted = campaignData.TurnsUntilCompleted;

	return temp;
}   

//////////////////////
// Tracking
//////////////////////

function int GetNumOfMapStarts()   { return mNumOfStartedMaps; }
function array<BaseMapProgress> GetNormalMapsList() { return mNormalMapsData; }

function BaseMapProgress GetBasicMapData(string mapFileName)
{
	local int index;
	local int i, j;
	local BaseMapProgress dummy;

	index = WasNormalMapPlayed(mapFileName);

	if(index > -1)
	{
		return mNormalMapsData[index];
	}
	else
	{
		for(i = 0; i < mCampaignsProgress.Length; ++i)
		{
			if(mCampaignsProgress[i].CurrentMap.MapFileName == Caps(mapFileName) )
			{
				return CampaignMapToBase(mCampaignsProgress[i].CurrentMap);
			}

			for(j = 0; j < mCampaignsProgress[i].CompletedMaps.Length; ++j)
			{
				if(mCampaignsProgress[i].CompletedMaps[j].MapFileName == Caps(mapFileName) )
				{
					return CampaignMapToBase(mCampaignsProgress[i].CompletedMaps[j]);
				}
			}
		}
	}

	return dummy;
}

function CampaignMapProgress GetCampaignMapData(string mapFileName)
{
	local int i, j;
	local CampaignMapProgress dummy;


	for(i = 0; i < mCampaignsProgress.Length; ++i)
	{
		if(Caps(mCampaignsProgress[i].CurrentMap.MapFileName) == Caps(mapFileName) )
		{
			return mCampaignsProgress[i].CurrentMap;
		}

		for(j = 0; j < mCampaignsProgress[i].CompletedMaps.Length; ++j)
		{
			if(Caps(mCampaignsProgress[i].CompletedMaps[j].MapFileName) == Caps(mapFileName) )
			{
				return mCampaignsProgress[i].CompletedMaps[j];
			}
		}
	}

	return dummy;
}

function RecreateCustomCampaignDefinitions()
{
	local int i;

	for( i = 0; i < mCampaignsProgress.Length; ++i)
	{
		if(mCampaignsProgress[i].CampaignRef == none || (mCampaignsProgress[i].CampaignRef != none && mCampaignsProgress[i].CampaignRef.mCampaignMaps.Length == 0))
		{   
			mCampaignsProgress[i].CampaignRef = new class'H7CampaignDefinition';
			mCampaignsProgress[i].CampaignRef.InitFromRawData(mCampaignsProgress[i].RawCampaignData);
		}
	}
}

function H7RawCampaignData GetRawCampaign(H7CampaignDefinition campRef)
{
	local H7RawCampaignData rawData;
	local int i;
	local string mapName;

	rawData.mAuthor = campRef.mAuthor;
	rawData.mRevision = campRef.mRevision;
	rawData.mName = (Len(campRef.mNameFallback) == 0) ? campRef.mNameInst : campRef.mNameFallback;
	rawData.mDescription = campRef.mDescriptionInst;
	rawData.mFileName = campRef.GetFileName();
	rawData.mContainerObjectName = campRef.mContainerObjectName;

	for(i = 0; i < campRef.mCampaignMaps.Length; ++i)
	{
		rawData.mCampaignMaps.AddItem(campRef.mCampaignMaps[i].mFileName);
		mapName = (Len(campRef.mCampaignMaps[i].mFallbackName) == 0) ? campRef.mCampaignMaps[i].mNameInst : campRef.mCampaignMaps[i].mFallbackName;
		rawData.mCampaignMapNames.AddItem(mapName);
		rawData.mCampaignMapInfoNumbers.AddItem(string(campRef.mCampaignMaps[i].mMapInfoNumber));
	}

	return rawData;
}

// Checks if map was played, if so returns index (false is -1)
function int WasNormalMapPlayed(string mapFileName)
{
	local int i;

	for(i = 0; i < mNormalMapsData.Length; ++i)
	{
		if(Caps(mNormalMapsData[i].MapFileName) == Caps(mapFileName) )
		{
			return i;
		}
	}

	return -1;
}

function array<MovieData> GetPlayedCinematics() { return mPlayedBIKCinematic; }
function int GetPlayedCinematicsNum() { return mPlayedBIKCinematic.Length; } 

function bool WasCinematicPlayed(string cinematicName)
{
	local int i;

	for(i = 0; i < mPlayedBIKCinematic.Length; ++i)
	{
		if(mPlayedBIKCinematic[i].MovieName == cinematicName)
		{
			return true;
		}
	}

	return false;
}

// Adds played BIK video to list, keeps list unique
function AddPlayedCinematic(string cinematicName, bool wasSkipped, float playTime)
{
	local MovieData temp;

	if(!WasCinematicPlayed(cinematicName))
	{
		temp.MovieName = cinematicName;
		temp.WasSkipped = wasSkipped;
		temp.PlayTime = playTime;

		mPlayedBIKCinematic.AddItem(temp);
		TrackingCutScenePlayed(temp);
	}
}

function int GetTurnsCampaignCompletion(int campaignIndex) 
{
	local int i,counter;
	for (i = 0; i < mCampaignsProgress[campaignIndex].CompletedMaps.Length; ++i)
	{
		counter += mCampaignsProgress[campaignIndex].CompletedMaps[i].TurnsUntilCompleted; 
		
	}
	return counter;
}

function string GetCurrentMapName( int PlayedCampaignID )
{
	return mCampaignsProgress[PlayedCampaignID].CampaignRef.GetMapByIndex(mCampaignsProgress[PlayedCampaignID].CurrentMap.MapIndexInCampaign);
}

// Returns number of campaigns that were started but not completed
function int GetNumStartedCampaigns(optional bool includeCurrent = true)
{
	local int i;
	local int count;
	
	for(i = 0; i < mCampaignsProgress.Length; ++i)
	{
		// Don't count current campaign
		if(!includeCurrent && i == mPlayedCampaignID)
		{
			continue;
		}

		// We don't need to check for anything else since list is filled only with campaigns that were started
		if(!mCampaignsProgress[i].IsCompleted)
		{
			++count;
		}
	}

	return count; 
}

// Returns number of completed campaigns
function int GetNumCompletedCampaigns(optional bool includeCurrent = true)             
{	
	local int i;
	local int count;
	
	for(i = 0; i < mCampaignsProgress.Length; ++i)
	{
		// Don't count current campaign
		if(!includeCurrent && i == mPlayedCampaignID)
		{
			continue;
		}

		if(mCampaignsProgress[i].IsCompleted)
		{
			++count;
		}
	}

	return count;  
}

// @param campaignRef -> If is none, it will sum all started/completed campaigns 
function int GetNumCompletedMaps(optional H7CampaignDefinition campaignRef)
{
	local CampaignProgress campaignData;
	local int i, j, count;

	count = 0;

	if(campaignRef == none)
	{
		for(i = 0; i < mCampaignsProgress.Length; ++i)
		{
			for(j = 0; j < mCampaignsProgress[i].CompletedMaps.Length; ++j)
			{
				if(mCampaignsProgress[i].CompletedMaps[j].CurrentMapState == MST_Completed)
				{
					count += 1;
				}
				
			}
		}
	}
	else
	{
		campaignData = GetCampaignDataByDef(campaignRef);

		for(i = 0; i < campaignData.CompletedMaps.Length; ++i)
		{

			if(campaignData.CompletedMaps[i].CurrentMapState == MST_Completed)
			{
				count += 1;
			}
			
		}
	}
	

	return count;
}


function string GetSanitizedMinutes(int minutes)
{
	local int hours, leftMinutes;
	local int temp;

	leftMinutes = minutes;

	temp = (leftMinutes % 60);
	hours = (leftMinutes - temp) / 60;
	leftMinutes -= temp;

	if(hours <= 0)
	{
		return (string(hours)$"h"@string(temp)$"min");
	}
	else
	{
		return (string(hours)$"h"@string(leftMinutes)$"min");
	}
}

function int GetTotalGameplayTimeMin()
{
	return mTotalGameplayTimeMin;
}

function int GetDuelMapTimeMin()
{
	return mDuelMapTime;
}

function ResetDuelTimers()
{
	mDuelMapTime = 0;
	mDuelMapSec = 0;
}


// @param campaignRef -> If is none, it will sum all started/completed campaigns 
function int GetCampaignGameplayTimeMin(optional H7CampaignDefinition campaignRef)
{
	local int i, time;

	time = 0;

	if(campaignRef == none)
	{
		for(i = 0; i < mCampaignsProgress.Length; ++i)
		{
			time += mCampaignsProgress[i].TotalGameplayTimeMin;
		}
	}
	else
	{
		time = GetCampaignDataByDef(campaignRef).TotalGameplayTimeMin;
	}
	

	return time;
}

function int GetCampaignMapGameplayTimeMin(string mapFileName)
{
	local int i, j;

	for( i = 0; i < mCampaignsProgress.Length; ++i)
	{
		for(j = 0; j < mCampaignsProgress[i].CompletedMaps.Length; ++j)
		{
			if(mCampaignsProgress[i].CompletedMaps[j].MapFileName == Caps(mapFileName))
			{
				return mCampaignsProgress[i].CompletedMaps[j].TotalGameplayTimeMin;
			}
		}

		if(mCampaignsProgress[i].CurrentMap.MapFileName == Caps(mapFileName))
		{
			return mCampaignsProgress[i].CurrentMap.TotalGameplayTimeMin;
		}
	}

	return -1;
}

// If non of the params will be passed sum of all times will be returned
function int GetNormalMapGameplayTimeMin(optional string mapFileName)
{
	local int i, time, mapIndex;

	time = 0;

	if(mapFileName != "")
	{
		mapIndex = WasNormalMapPlayed(mapFileName);

		if(mapIndex > -1)
		{
			time = mNormalMapsData[mapIndex].TotalGameplayTimeMin;
		}
		
	}
	else
	{
		for(i = 0; i < mNormalMapsData.Length; ++i)
		{
			time += mNormalMapsData[i].TotalGameplayTimeMin;
		}
	}

	return time;
}

function TickDuelMapTime( float deltaTime)
{
	mDuelMapSec += deltaTime;

	// Every 60s clear timer, leave leftovers
	if(mDuelMapSec >= 60.0f)
	{
		mDuelMapSec -= 60.0f;

		mDuelMapTime += 1;
	}
}

function TickGameplayTime( float deltaTime)
{
	mGameplayTimeSec += deltaTime;

	// Every 60s clear timer, leave leftovers
	if(mGameplayTimeSec >= 60.0f)
	{
		mGameplayTimeSec -= 60.0f;

		mTotalGameplayTimeMin += 1;
	}
}

function TickCampaignTime( float deltaTime, H7CampaignDefinition campaignDef)
{
	local int campaignID;

	if(campaignDef != none)
	{
		campaignID = GetCampaignID(campaignDef);

		if(campaignID < 0)
		{
			return;
		}

		mCampaignsProgress[campaignID].GameplayTimeSec += deltaTime;

		// Every 60s clear timer, leave leftovers
		if(mCampaignsProgress[campaignID].GameplayTimeSec >= 60.0f)
		{
			mCampaignsProgress[campaignID].GameplayTimeSec -= 60.0f;

			mCampaignsProgress[campaignID].TotalGameplayTimeMin += 1;
		}

		// Count time only for latest map in campaign
		if(mCampaignsProgress[campaignID].CurrentMap.CurrentMapState != MST_NotStarted && Caps(mCampaignsProgress[campaignID].CurrentMap.MapFileName) == Caps(mCurrentMapFile) )
		{
			mCampaignsProgress[campaignID].CurrentMap.GameplayTimeSec += deltaTime;

			// Every 60s clear timer, leave leftovers
			if(mCampaignsProgress[campaignID].CurrentMap.GameplayTimeSec >= 60.0f)
			{
				mCampaignsProgress[campaignID].CurrentMap.GameplayTimeSec -= 60.0f;

				mCampaignsProgress[campaignID].CurrentMap.TotalGameplayTimeMin += 1;
			}
		}
	}
}

function TickMapTime(float deltaTime)
{
	if( mCurrentNormalMapID != -1 && mNormalMapsData.Length > mCurrentNormalMapID )
	{
		mNormalMapsData[mCurrentNormalMapID].GameplayTimeSec += deltaTime;

		// Every 60s clear timer, leave leftovers
		if(mNormalMapsData[mCurrentNormalMapID].GameplayTimeSec >= 60.0f)
		{
			mNormalMapsData[mCurrentNormalMapID].GameplayTimeSec -= 60.0f;

			mNormalMapsData[mCurrentNormalMapID].TotalGameplayTimeMin += 1;
		}
	}
}

function TrackingCutScenePlayed(MovieData data)
{
	local JsonObject obj;

	obj = new class'JsonObject'() ;
	obj.SetStringValue("cutSceneName", data.MovieName);
	obj.SetBoolValue("cutSceneSkipped", data.WasSkipped );
	obj.SetIntValue("cutSceneDuration", int( data.PlayTime ) );
	
	if(class'GameEngine'.static.GetOnlineSubsystem() != none && OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()) != none)
	OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).PushEvent("UTT_CUT_SCENES","cut.scenes", obj );
}

function TrackingCampaignComplete()
{
	local JsonObject obj;

	obj = new class'JsonObject'() ;
	obj.SetStringValue("campaignName", string(mCampaignsProgress[mPlayedCampaignID].CampaignRef)  );
	obj.SetIntValue("nbTurns", GetTurnsCampaignCompletion( mPlayedCampaignID ));
	obj.SetIntValue("playTime", GetCampaignGameplayTimeMin(mCampaignsProgress[mPlayedCampaignID].CampaignRef));
	obj.SetIntValue("startedCampaigns",  GetNumStartedCampaigns(true));
	obj.SetIntValue("completedCampaigns", GetNumCompletedCampaigns(true) );
	
	if(class'GameEngine'.static.GetOnlineSubsystem() != none && OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()) != none)
	OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).PushEvent("UTT_CAMPAIGN_COMPLETE","campaign.complete", obj );
}

//////////////////////
// Profile Init/Save/Load
//////////////////////

// init
static function InitPlayerProfile(string profileName)
{
	local H7PlayerProfile profile;
	local array<int> userPrivileges;
	local array<int> allPrivileges;
	local int i, j;
	local JsonObject obj;
	local int year,month,day7,day,hour,min,sec,msec;
	
	;

	if(class'H7TransitionData'.static.GetInstance().GetPlayerProfile() != none)
	{
		return;
	}

	profile = new class'H7PlayerProfile';

	if(profile == none)
	{
		return;
	}

	// hang the profile on the transition data so that everybody can access it
	class'H7TransitionData'.static.GetInstance().SetPlayerProfile(profile);

	profile.mSaveGameScanner = new class'H7ListingSavegame';
	profile.mCampaignTransManager = new class'H7CampaignTransitionManager';

	profile.mAchievementManager = new class'H7AchievementManager';
	profile.mAchievementManager.SetPlayerProfile(profile);

	profile.CheckProfileSlot();

	profile.GetUserPrivileges(userPrivileges, true);
	profile.GetUserPrivileges(allPrivileges, false);

	profile.GetSystemTime(year,month,day7,day,hour,min,sec,msec);

	obj = new class'JsonObject'() ;

	for( i = 0; i < allPrivileges.Length; ++i)
	{
		j = userPrivileges.Find(allPrivileges[i]);

		obj.SetStringValue("id_"$i, string( allPrivileges[i] )  );
		obj.SetStringValue("dlcName_"$i, profile.GetPrivilegeName(allPrivileges[i])  );
		obj.SetStringValue("startDate_"$i,  ""$year$"-"$month$"-"$day$"T"$hour$":"$min$":"$sec$"."$msec$"Z"  ); // 2014-01-30T05:12:14.000Z

		if(j > -1)
		{
			obj.SetBoolValue("ownedByUser_"$i, true);
		}
		else
		{
			obj.SetBoolValue("ownedByUser_"$i, false);
		}

		obj.SetBoolValue("balance_"$i, true);
	}
	
	// Ubi has a new policy <1kb package size, conclusion this tracking msg this is out for now.
	//if(class'GameEngine'.static.GetOnlineSubsystem() != none && OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()) != none)
	//{
	//	OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).PushEvent("UTT_PLAYER_DLC","see JSon", obj );		
	//}


	
}

// -1 Error, 0 Ready, 1 InProgress, 2 Waiting to start
event TickSave(float DeltaTime)
{
	local int i, slotCheckResult, isScanningDone;
	local array<H7ListingSavegameDataScene> tempSaves;


	mSavedThisTick = false;
	mLoadedThisTick = false;
	mCheckedThisTick = false;
	mSavedTransThisTick = false;

	if(mAchievementManager != none)
	{
		mAchievementManager.UpdateStatus();
	}

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
					// Save profile file
					if(H7SavegameTask_Saving(mSaveLoadTasks[i]) != none && H7SavegameTask_Saving(mSaveLoadTasks[i]).GetTargetSlotIndex() == class'H7SaveGameController'.const.SLOT_PROFILE )
					{   
						mSaveTaskSucceeded = H7SavegameTask_Saving(mSaveLoadTasks[i]).FinishSaveTask();

						if(!mSaveTaskSucceeded)
						{
							;
						}		
					}
					// Save Campaign Transition file
					else if(H7SavegameTask_Saving(mSaveLoadTasks[i]) != none && H7SavegameTask_Saving(mSaveLoadTasks[i]).GetTargetSlotIndex() == class'H7SaveGameController'.const.SLOT_OFFICIALCAMPAIGNTRANSITION )
					{   
						mSaveTaskSucceeded = H7SavegameTask_Saving(mSaveLoadTasks[i]).FinishSaveTask();

						if(!mSaveTaskSucceeded)
						{
							;
						}		
					}
					// Load profile file
					else if(H7SavegameTask_Loading(mSaveLoadTasks[i]) != none && H7SavegameTask_Loading(mSaveLoadTasks[i]).GetTargetSlotIndex() == class'H7SaveGameController'.const.SLOT_PROFILE) 
					{
						mLoadTaskSucceeded = H7SavegameTask_Loading( mSaveLoadTasks[i] ).FinishObjectLoadTask(self);

						if(!mLoadTaskSucceeded)
						{
							;
						}
						else
						{
							// Recreate custom campaign defs inside of campaign progress
							RecreateCustomCampaignDefinitions();
							mAchievementManager.PullUPlayRewards();
							mAchievementManager.PullActions();
						}

						
					}
					//Load Campaign Transition Manager/Data
					else if(H7SavegameTask_Loading(mSaveLoadTasks[i]) != none && H7SavegameTask_Loading( mSaveLoadTasks[i] ).GetTargetSlotIndex() == class'H7SaveGameController'.const.SLOT_OFFICIALCAMPAIGNTRANSITION )
					{
						mLoadTaskSucceeded = H7SavegameTask_Loading( mSaveLoadTasks[i] ).FinishObjectLoadTask(mCampaignTransManager);

						mLookingForCampTransData = false;

						if(!mLoadTaskSucceeded)
						{
							;
						}
					}
					// Check if Profile slot is filled
					else if(H7SavegameTask_Checking(mSaveLoadTasks[i]) != none && H7SavegameTask_Checking(mSaveLoadTasks[i]).GetTargetSlotIndex() == class'H7SaveGameController'.const.SLOT_PROFILE)
					{
						mCheckTaskSucceeded = H7SavegameTask_Checking( mSaveLoadTasks[i] ).FinishTaskCheckSlot( slotCheckResult );

						// Profile slot filled
						if( slotCheckResult > 0 )
						{
							LoadProfileFile();
						}
						else // No profile file, pull basic data from UPlay
						{
							UpdateFromUPlay();
						}


					}
					// Check if Campaign Transition slot is filled
					else if(H7SavegameTask_Checking(mSaveLoadTasks[i]) != none && H7SavegameTask_Checking(mSaveLoadTasks[i]).GetTargetSlotIndex() == class'H7SaveGameController'.const.SLOT_OFFICIALCAMPAIGNTRANSITION)
					{
						mCheckTaskSucceeded = H7SavegameTask_Checking( mSaveLoadTasks[i]).FinishTaskCheckSlot( slotCheckResult );

						// Campaign Transition found -> Load
						if( slotCheckResult > 0 )
						{
							LoadCampaignTransData();
						}
						else // No Campaign transition data found -> Create
						{
							mLookingForCampTransData = false;
						}
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

			// Scaning is done, update continue button
			if(class'H7PlayerController'.static.GetPlayerController() != none && class'H7PlayerController'.static.GetPlayerController().GetMainMenuHud() != none && class'H7PlayerController'.static.GetPlayerController().GetMainMenuHud().GetMainMenuCntl() != none)
			{
				class'H7PlayerController'.static.GetPlayerController().GetMainMenuHud().GetMainMenuCntl().UpdateContinueButton();
			}
		}
	}
}

function UpdateFromUPlay()
{
	// Pull base data from UPlay
	mUserName = class'H7PlayerController'.static.GetPlayerController().PlayerReplicationInfo.PlayerName;

	mAchievementManager.PullUPlayRewards();
	mAchievementManager.PullActions();

	CheckCampaignTransitionSlot();
}

function CheckProfileSlot()
{
	local H7SavegameTask_Checking newCheckTask;

	// Did we performed an check this tick? Why Check twice same tick \o/ ?
	if(!mCheckedThisTick)
	{
		newCheckTask = new class'H7SavegameTask_Checking';

		if(newCheckTask != none)
		{
			newCheckTask.StartTaskCheckSlot( class'H7SaveGameController'.const.SLOT_PROFILE);

			mSaveLoadTasks.AddItem(newCheckTask);

			mCheckedThisTick = true;
		}
		else
		{
			;
		}
	}
}

function CheckCampaignTransitionSlot()
{
	local H7SavegameTask_Checking newCheckTask;

	// Did we performed an check this tick? Why Check twice same tick \o/ ?
	if(!mLookingForCampTransData)
	{
		newCheckTask = new class'H7SavegameTask_Checking';

		if(newCheckTask != none)
		{
			newCheckTask.StartTaskCheckSlot(class'H7SaveGameController'.const.SLOT_OFFICIALCAMPAIGNTRANSITION);

			mSaveLoadTasks.AddItem(newCheckTask);

			mLookingForCampTransData = true;
		}
		else
		{
			;
		}
	}
}

function LoadCampaignTransData()
{
	
	local H7SavegameTask_Loading newLoadTask;

	// Did we performed an load this tick? Why Load twice same tick \o/ ?
	if(mLookingForCampTransData)
	{
		newLoadTask = new class'H7SavegameTask_Loading';

		if(newLoadTask != none)
		{
			newLoadTask.StartLoadTask( class'H7SaveGameController'.const.SLOT_OFFICIALCAMPAIGNTRANSITION);

			mSaveLoadTasks.AddItem(newLoadTask);

			mLookingForCampTransData =  false;
		}
		else
		{
			;
		}
	}
}

function LoadProfileFile()
{
	local H7SavegameTask_Loading newLoadTask;

	// Did we performed an load this tick? Why Load twice same tick \o/ ?
	if(!mLoadedThisTick)
	{
		newLoadTask = new class'H7SavegameTask_Loading';

		if(newLoadTask != none)
		{
			newLoadTask.StartLoadTask( class'H7SaveGameController'.const.SLOT_PROFILE);

			mSaveLoadTasks.AddItem(newLoadTask);

			mLoadedThisTick = true;
		}
		else
		{
			;
		}
	}

	if(!mLookingForCampTransData) 
	{
		CheckCampaignTransitionSlot();
	}
}

function Save()
{
	local H7SavegameTask_Saving newSaveTask;

	// Did we performed an save this tick? Why Save twice same tick \o/ ?
	if(!mSavedThisTick)
	{
		newSaveTask = new class'H7SavegameTask_Saving';

		if(newSaveTask != none)
		{
			newSaveTask.StartObjectSaveTaskToAreaSlot(H7SavegameSlotType_Profile, mUserName $ "Profile", self);

			mSavedThisTick = true;

			mSaveLoadTasks.AddItem(newSaveTask);
		}
		else
		{
			;
		}
	}
}

function SaveCampaignTransition()
{
	local H7SavegameTask_Saving newSaveTask;

	// Did we performed an save this tick? Why Save twice same tick \o/ ?
	if(!mSavedTransThisTick)
	{
		newSaveTask = new class'H7SavegameTask_Saving';

		if(newSaveTask != none && mCampaignTransManager != none)
		{
			newSaveTask.StartObjectSaveTaskToAreaSlot(H7SavegameSlotType_CampaignTransition, mUserName $ "TransitionData", mCampaignTransManager);

			mSavedTransThisTick = true;

			mSaveLoadTasks.AddItem(newSaveTask);
		}
		else
		{
			;
		}
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

//////////////////////
// Campaigns Management
//////////////////////

// returns the savegame that is loaded when I press "Continue" for this campaign
// @param theCampaign   If there is none passed the function will return LastPlayedCampaign LastSave
// @param mapFileName   Used to verify continueSave
function H7ListingSavegameDataScene GetContinueSave(optional H7CampaignDefinition theCampaign, optional string mapFileName)
{
	return FindLastCampaignSave(mScannedSaves, theCampaign, mapFileName);
}

native function H7ListingSavegameDataScene FindLastCampaignSave(array<H7ListingSavegameDataScene> savesList, optional H7CampaignDefinition campaignRef, optional string mapFileName);

// This is called on OLD map
function HandleCampaignMapRestart(string mapFileName, H7CampaignDefinition campaignRef)
{
	
	// No map file name -> go to MainMenu
	if(mapFileName == "")
	{
		class'H7TransitionData'.static.GetInstance().SetCampaignDefinition(none);
		class'H7ReplicationInfo'.static.GetInstance().GoToMainMenu();
	}

	if(campaignRef != none) // Campaign map started
	{
		class'H7TransitionData'.static.GetInstance().SetCampaignDefinition(campaignRef);
		class'H7ReplicationInfo'.static.GetInstance().WriteGameDataToTransitionData();
		class'H7ReplicationInfo'.static.GetInstance().StartMap( mapFileName );
	}
}

function bool IsPartOfCurrentCampaign(string mapFileName)
{
	local int i;
	local array<string> campaignMaps;

	campaignMaps = mCampaignsProgress[mPlayedCampaignID].CampaignRef.GetMaps();

	for( i = 0; i < campaignMaps.Length; ++i)
	{
		if(Caps(mapFileName) == Caps(campaignMaps[i]))
		{
			return true;
		}
	}

	return false;
}


// Called when AdventureController of a map is created, after init/serial
function HandleMapStart(string mapFileName, optional H7CampaignDefinition campaignRef) 
{ 
	local BaseMapProgress mapData;
	local int mapDataIndex;

	++mNumOfStartedMaps;
	mCurrentMapFile = Caps(mapFileName);
	if(campaignRef != none) // Campaign map started
	{
		// Check if we play same campaign as profile thinks
		if(mCampaignsProgress[mPlayedCampaignID].CampaignRef != campaignRef)
		{
			ChangeCurrentCampaign(campaignRef);
		}

		// Load Transition data 
		mCampaignTransManager.LoadTransitionMap(campaignRef.GetPrevMap(mapFileName));

		// Replay
		if( mapFileName != "" && IsAReplay(campaignRef, mapFileName) )
		{
			mCampaignsProgress[mPlayedCampaignID].ReplayMap.CurrentMapState = MST_InProgress;
		}
		else // New/Next map
		{
			if( mCampaignsProgress[mPlayedCampaignID].CurrentMap.CurrentMapState != MST_Completed )
			{
				mCampaignsProgress[mPlayedCampaignID].CurrentMap.CurrentMapState = MST_InProgress;
			}

			if(!mCampaignsProgress[mPlayedCampaignID].CurrentMap.WasOnceCompleted)
			{
				mCampaignsProgress[mPlayedCampaignID].CurrentMap.StartTimesUntilCompleted += 1;
			}
		}

		mCurrentNormalMapID = -1;
	}
	else // Other then campaign map started
	{
		mapDataIndex = WasNormalMapPlayed(mapFileName);
	
		// Map is not on the list add it
		if(mapDataIndex < 0)
		{
			mapData.MapFileName = Caps(mapFileName);
			
			mapDataIndex = mNormalMapsData.Length;

			mNormalMapsData.AddItem(mapData);
		}

		mCurrentNormalMapID = mapDataIndex;

		if(!mNormalMapsData[mCurrentNormalMapID].WasOnceCompleted)
		{
			mNormalMapsData[mCurrentNormalMapID].StartTimesUntilCompleted += 1;
		}

		mNormalMapsData[mCurrentNormalMapID].StartTimesCount += 1;
	}
	
	Save();
}

// Called on Map before MapTransition if player WON it
function HandleMapFinish(bool isCampaign)
{
	local CampaignMapProgress dummy;
	local H7AdventureController adventureController;

	adventureController = class'H7AdventureController'.static.GetInstance();

	if(isCampaign)
	{   
		
		// Save transition data
		if(adventureController != none)
		{       
			mCampaignTransManager.SaveTransitionMap(Caps(adventureController.GetMapFileName()) );

			SaveCampaignTransition();
		}		

		// If there is any replay data it means we finished replay map
		if(mCampaignsProgress[mPlayedCampaignID].ReplayMap.CurrentMapState == MST_InProgress && mCampaignsProgress[mPlayedCampaignID].ReplayMap.MapIndexInCampaign > -1)
		{
			OverrideMapProgress(mCampaignsProgress[mPlayedCampaignID].ReplayMap);

			mCampaignsProgress[mPlayedCampaignID].ReplayMap = dummy;
			// Go Back to council
		}
		else if(mCampaignsProgress[mPlayedCampaignID].CurrentMap.MapFileName == Caps(adventureController.GetMapFileName()) ) // Loads after completions should fail here
		{
			if(mCampaignsProgress[mPlayedCampaignID].CurrentMap.CurrentMapState == MST_InProgress)
			{
			
				mCampaignsProgress[mPlayedCampaignID].CurrentMap.CurrentMapState = MST_Completed;

			}

			if(!mCampaignsProgress[mPlayedCampaignID].CurrentMap.WasOnceCompleted)
			{
				// Dont send this stuff for campaigns that are replayed (reseted)
				if(!WasMapCompletedBefore(mPlayedCampaignID))
				{
					/** TRACKING */
					if(class'GameEngine'.static.GetOnlineSubsystem() != none && OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()) != none)
						OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).PushEvent("UTT_PLAYER_PROGRESSION", GetCurrentMapName(mPlayedCampaignID), new class'JsonObject'() );

					// Map Completion achievement
					mAchievementManager.HandleMapCompleted(Caps(adventureController.GetMapFileName()) );
				}
				
				mCampaignsProgress[mPlayedCampaignID].CurrentMap.TurnsUntilCompleted = adventureController.GetTurns();
				mCampaignsProgress[mPlayedCampaignID].CurrentMap.WasOnceCompleted = true; 

				mCampaignsProgress[mPlayedCampaignID].CurrentMap.HighestDifficulty = mCampaignsProgress[mPlayedCampaignID].CurrentMap.CurrentDifficulty;	
			}
			else
			{
				// Check if current map difficulty is the highest ever
				if(IsHigherDifficulty(mCampaignsProgress[mPlayedCampaignID].CurrentMap.CurrentDifficulty, mCampaignsProgress[mPlayedCampaignID].CurrentMap.HighestDifficulty))
				{
					mCampaignsProgress[mPlayedCampaignID].CurrentMap.HighestDifficulty = mCampaignsProgress[mPlayedCampaignID].CurrentMap.CurrentDifficulty;
				}
			}

			CompleteCurrentMap(mCampaignsProgress[mPlayedCampaignID].CampaignRef);
		}
	}
	else
	{
		if(mCurrentNormalMapID > -1 && adventureController.GetMapInfo() != none && adventureController.GetMapInfo().IsOfficial())
		{
			if(mAchievementManager != none && !mAchievementManager.GetCompletedOneSkirmishMap() && !class'H7ReplicationInfo'.static.GetInstance().mIsTutorial)
			{
				mAchievementManager.ActionCompleted_PYS();
				mAchievementManager.SetCompletedOneSkirmishMap();
			}

			mNormalMapsData[mCurrentNormalMapID].TurnsUntilCompleted = adventureController.GetTurns();
			mNormalMapsData[mCurrentNormalMapID].WasOnceCompleted = true;
		}	
	}

	Save();
}

function CampaignFinishedCouncilMatinee( H7CampaignDefinition campaignRef, bool introMatinee)
{
	if(introMatinee)
	{
		mCampaignsProgress[GetCampaignID(campaignRef)].CouncilIntroPlayed = true;
	}
	else
	{
		mCampaignsProgress[GetCampaignID(campaignRef)].CouncilOutroPlayed = true;
	}
}

function bool WasCouncilIntroPlayed(H7CampaignDefinition campaignRef)
{
	return mCampaignsProgress[GetCampaignID(campaignRef)].CouncilIntroPlayed;
}

function bool WasCouncilOutroPlayed(H7CampaignDefinition campaignRef)
{
	return mCampaignsProgress[GetCampaignID(campaignRef)].CouncilOutroPlayed;
}

function int GetCurrentCampaignID()
{
	return mPlayedCampaignID;
}

function ProgressScenePlayed()
{
	mCampaignsProgress[mPlayedCampaignID].ProgressScenePlayed = true;
}

function CampaignProgress GetCurrentCampaign()
{
	local CampaignProgress temp;

	if(HasCurrentCampaign() && mPlayedCampaignID != -1)
	{
		temp = mCampaignsProgress[mPlayedCampaignID];
	}
	
	temp = temp;

	return temp;
}

function bool HasCurrentCampaign()
{
	return mCampaignsProgress.Length > 0;
}

function ChangeCurrentCampaign(H7CampaignDefinition campaignRef)
{
	local int campID;

	campID = GetCampaignID(campaignRef);

	if(campID > -1)
	{
		mPlayedCampaignID = campID;
	}
	
}

function bool HasEnteredCouncil()
{
	return mHasEnteredCouncil;
}

function bool ShouldDisplayAdvice()
{
	if(mHasEnteredCouncilForTheFirstTime)
	{
		mHasEnteredCouncilForTheFirstTime = false;
		return true;
	}
	return false;
}

function SetHasEnteredCouncil()
{
	if(!mHasEnteredCouncil)
	{
		;
		mHasEnteredCouncil = true;
		mHasEnteredCouncilForTheFirstTime = true;
		Save();
	}
}

//It resets the status of that campaign (last completed map = 0, campaign  started = false, selected difficulty = none), 
//so it also makes this  button disappear. 
//One of two possible Ivan audios is played and then the  audio of the new character 
//text is played and the buttons at the bottom  are adjusted accordingly.
function ResetCampaignProgress(H7CampaignDefinition campaignRef )
{
	local int campaignIndex;
	local int i;
	local H7DifficultyParameters diffParams;

	campaignIndex = GetCampaignID(campaignRef);

	//clear storypoints
	for(i = 0; i < mCampaignsProgress[campaignIndex].CompletedMaps.Length; ++i)
	{
		//mCampaignsProgress[campaignIndex].CompletedMaps[i].HighestDifficulty = diffParams;
		//mCampaignsProgress[campaignIndex].CompletedMaps[i].CurrentDifficulty = diffParams;
		mCampaignsProgress[campaignIndex].CompletedMaps[i].UnlockedStorypoints.Length = 0;
		mCampaignsProgress[campaignIndex].CompletedMaps[i].CurrentMapState = MST_NotStarted;
	}

	//mCampaignsProgress[campaignIndex].CurrentMap = dummy;
	if(mCampaignsProgress[campaignIndex].CompletedMaps.Length > 0)
	{
		mCampaignsProgress[campaignIndex].CurrentMap = mCampaignsProgress[campaignIndex].CompletedMaps[0];
	}

	mCampaignsProgress[campaignIndex].CurrentMap.HighestDifficulty = diffParams;
	mCampaignsProgress[campaignIndex].CurrentMap.CurrentDifficulty = diffParams;
	mCampaignsProgress[campaignIndex].CurrentMap.UnlockedStorypoints.Length = 0;
	mCampaignsProgress[campaignIndex].CurrentMap.CurrentMapState = MST_NotStarted;

	mCampaignsProgress[campaignIndex].CouncilIntroPlayed = false;
	mCampaignsProgress[campaignIndex].CouncilOutroPlayed = false;

	SetSelectedDifficulty(diffParams);

	Save();

	// If we are in council -> Update map
	if(H7CouncilGameInfo(class'WorldInfo'.static.GetWorldInfo().Game) != none && H7CouncilGameInfo(class'WorldInfo'.static.GetWorldInfo().Game).GetCouncilManager() != none )
	{
		H7CouncilGameInfo(class'WorldInfo'.static.GetWorldInfo().Game).GetCouncilManager().GetMapManager().UpdateMap();
	}
}

// If campaign is owned by UPlay account return True (based on UplayIDs)
function bool CheckCampaignUPlayID( H7CampaignDefinition campaignRef )
{
	local array<H7CampaignDefinition> campaigns;
	local int i;

	if(class'H7GameData'.static.GetInstance() != none)
	{
		class'H7GameData'.static.GetInstance().GetCampaigns(campaigns);

		for( i = 0; i < campaigns.Length; ++i)
		{
			if(campaigns[i] == campaignRef)
			{
				return true;
			}
		}
	}

	return false;
}

function ContinueLastCampaign()
{
	// If campaign is not completed
	if(CanCountinueLastCampaign())
	{
		StartCampaignMap(mCampaignsProgress[mPlayedCampaignID].CampaignRef);
	}
}		

// Checks if campaign was finished so we know if there is point in continue button
function bool CanCountinueLastCampaign()
{
	if( mCampaignsProgress.Length > 0 && mPlayedCampaignID <  mCampaignsProgress.Length && mPlayedCampaignID != -1 && mCampaignsProgress[mPlayedCampaignID].CampaignRef != none )
	{
		if( GetCampaignFinishedMapsNum(mCampaignsProgress[mPlayedCampaignID].CampaignRef) < mCampaignsProgress[mPlayedCampaignID].CampaignRef.GetMapsNum() )
		{
			return true;
		}
	}
	
	return false;
}

function StartCampaignMap( H7CampaignDefinition campaignRef,optional string mapFileName = "",optional bool checkPrivilege = true, optional bool restartCurrentMap = false)
{
	local CampaignProgress campaignData;
	local H7ListingSavegameDataScene continueSave;
	
	if(checkPrivilege && campaignRef.RequiresFactionPrivilege() && !CheckCampaignUPlayID(campaignRef))
	{
		return;
	}

	if(IsCampaignEverStarted(campaignRef))
	{
		ChangeCurrentCampaign(campaignRef);

		// Replay
		if(mapFileName != "" && IsAReplay(campaignRef, mapFileName))
		{
			// Find out index of map we are replaying
			mCampaignsProgress[mPlayedCampaignID].ReplayMap = mCampaignsProgress[mPlayedCampaignID].CompletedMaps[GetCampaignMapIndex(campaignRef, mapFileName)];

			// Override with new data
			mCampaignsProgress[mPlayedCampaignID].ReplayMap.UnlockedStorypoints.Length = 0;
			mCampaignsProgress[mPlayedCampaignID].ReplayMap.CurrentDifficulty = GetSelectedDifficulty();
			//mCampaignsProgress[mPlayedCampaignID].ReplayMap.CurrentMapState = MST_NotStarted;
			class'H7TransitionData'.static.GetInstance().SetCampaignDefinition(mCampaignsProgress[mPlayedCampaignID].CampaignRef);
			class'H7ReplicationInfo'.static.GetInstance().StartMap(mCampaignsProgress[mPlayedCampaignID].CampaignRef.GetMapByIndex(mCampaignsProgress[mPlayedCampaignID].ReplayMap.MapIndexInCampaign));
		}
		else // New/Next map
		{
			if(restartCurrentMap)
			{
				mCampaignsProgress[mPlayedCampaignID].CurrentMap.CurrentMapState = MST_NotStarted;

				mCampaignsProgress[mPlayedCampaignID].CurrentMap.UnlockedStorypoints.Length = 0;
				mCampaignsProgress[mPlayedCampaignID].CurrentMap.CurrentDifficulty = GetSelectedDifficulty();
			}

			// Old Campaign but next map was never loaded, so instead of loading savegame we load new(next) map
			if(mCampaignsProgress[mPlayedCampaignID].CurrentMap.CurrentMapState == MST_NotStarted)
			{
				class'H7TransitionData'.static.GetInstance().SetCampaignDefinition(mCampaignsProgress[mPlayedCampaignID].CampaignRef);
				if(mCampaignsProgress[mPlayedCampaignID].CurrentMap.MapIndexInCampaign == 0)
				{
					if(campaignRef.mStartMatineeName != "" && !mCampaignsProgress[mPlayedCampaignID].CouncilIntroPlayed)
					{
						class'H7CouncilManager'.static.GetInstance().GetMatineeManager().PlayMatineeByObjComment(campaignRef.mStartMatineeName);

						mCampaignsProgress[mPlayedCampaignID].CouncilIntroPlayed = true;
					}
					else
					{
						class'H7ReplicationInfo'.static.GetInstance().StartMap(mCampaignsProgress[mPlayedCampaignID].CampaignRef.GetMapByIndex(mCampaignsProgress[mPlayedCampaignID].CurrentMap.MapIndexInCampaign));
					}
				}
				else
				{
					class'H7ReplicationInfo'.static.GetInstance().StartMap(mCampaignsProgress[mPlayedCampaignID].CampaignRef.GetMapByIndex(mCampaignsProgress[mPlayedCampaignID].CurrentMap.MapIndexInCampaign));
				}
				
			}
			else // last map is unfinished -> load save
			{
				continueSave = GetContinueSave(campaignRef, mCampaignsProgress[mPlayedCampaignID].CurrentMap.MapFileName);

				// If there is a save -> load it
				if(continueSave.SlotIndex > -1 && Caps(continueSave.SavegameData.mMapFileName) == Caps(mCampaignsProgress[mPlayedCampaignID].CurrentMap.MapFileName) )
				{
					class'H7PlayerController'.static.GetPlayerController().LoadGameState(
								continueSave.SlotIndex,
								continueSave.SavegameData.mMapFileName
							);
				}
				else // There is no save -> load 'fresh' current map
				{
					class'H7TransitionData'.static.GetInstance().SetCampaignDefinition(mCampaignsProgress[mPlayedCampaignID].CampaignRef);
					class'H7ReplicationInfo'.static.GetInstance().StartMap(mCampaignsProgress[mPlayedCampaignID].CampaignRef.GetMapByIndex(mCampaignsProgress[mPlayedCampaignID].CurrentMap.MapIndexInCampaign));
				}
			}
		}
	}
	else // If its first time we play campaign QUEUE THE MOVIE!!
	{
		campaignData.CampaignProgressIndex = mCampaignsProgress.Length;
		campaignData.CampaignRef = campaignRef;
		campaignData.RawCampaignData = GetRawCampaign(campaignRef);
		campaignData.CurrentMap.MapFileName = Caps(campaignRef.GetFirstMap());
		campaignData.CurrentMap.MapIndexInCampaign = 0;
		campaignData.CurrentMap.CurrentDifficulty = GetSelectedDifficulty();

		mCampaignsProgress.AddItem(campaignData);

		ChangeCurrentCampaign(campaignRef);

		class'H7TransitionData'.static.GetInstance().SetCampaignDefinition(mCampaignsProgress[mPlayedCampaignID].CampaignRef);
		if(campaignRef.mStartMatineeName != "")
		{
			class'H7CouncilManager'.static.GetInstance().GetMatineeManager().PlayMatineeByObjComment(campaignRef.mStartMatineeName);

			mCampaignsProgress[mPlayedCampaignID].CouncilIntroPlayed = true;
		}
		else
		{
			class'H7ReplicationInfo'.static.GetInstance().StartMap(campaignData.CurrentMap.MapFileName);
		}
		
	}

	/** TRACKING */
	if(class'GameEngine'.static.GetOnlineSubsystem() != none && OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()) != none)
	{
		OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).PushEvent("UTT_GAMEMODE_START","CAMPAIGN.SINGLEPLAYER", new class'JsonObject'()  );
		OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).PushEvent("UTT_CAMPAIGN_START", string(campaignRef) , new class'JsonObject'()  );
	}

	// initialize the loadscreen
	campaignRef.DynLoadObjectProperty('mLoadScreenBackground');
	class'H7PlayerController'.static.GetPlayerController().InitLoadingScreen(campaignRef.GetLoadscreenBackground());
}

function bool IsMapCompletedInCampaign(H7CampaignDefinition campaignDef, int mapIndexInCampaign)
{
	local CampaignProgress campaignData;
	local int i;

	campaignData = GetCampaignDataByDef(campaignDef);
	
	for(i = 0; i < campaignData.CompletedMaps.Length; ++i)
	{
		if(campaignData.CompletedMaps[i].MapIndexInCampaign == mapIndexInCampaign)
		{
			// Presence of map in list should be enough but hey, stuff goes wrong
			return campaignData.CompletedMaps[i].CurrentMapState == MST_Completed ? true : false;
		}
	}

	return false;
}

function bool IsAReplay(H7CampaignDefinition campeignRef ,string mapFileName)
{
	local CampaignProgress tempCamp;
	local int i;

	tempCamp = GetCampaignDataByDef(campeignRef);

	for( i = 0; i < tempCamp.CompletedMaps.Length; ++i)
	{
		if(Caps(tempCamp.CompletedMaps[i].MapFileName) == Caps(mapFileName) && tempCamp.CompletedMaps[i].CurrentMapState == MST_Completed)
		{
			return true;
		}
	}

	return false;
}

function OverrideMapProgress(CampaignMapProgress newMapProgress)
{
	local int mapIndex;

	mapIndex = GetCampaignMapIndex( mCampaignsProgress[mPlayedCampaignID].CampaignRef, newMapProgress.MapFileName);

	if(mapIndex > -1)
	{
		mCampaignsProgress[mPlayedCampaignID].CompletedMaps[mapIndex].UnlockedStorypoints = newMapProgress.UnlockedStorypoints;
		mCampaignsProgress[mPlayedCampaignID].CompletedMaps[mapIndex].CurrentMapState = MST_Completed;
		mCampaignsProgress[mPlayedCampaignID].CompletedMaps[mapIndex].CurrentDifficulty = newMapProgress.CurrentDifficulty;


		// We dont want to override higher difficulty with lower
		if(IsHigherDifficulty(newMapProgress.CurrentDifficulty, mCampaignsProgress[mPlayedCampaignID].CompletedMaps[mapIndex].HighestDifficulty))
		{
			mCampaignsProgress[mPlayedCampaignID].CompletedMaps[mapIndex].HighestDifficulty = newMapProgress.CurrentDifficulty;
		}
		
	}
}


// Unlocks storypoint for current map
function UnlockStorypoint(int storypointIndex)
{
	local int i;

	if(mCampaignsProgress.Length > 0)
	{
		for(i = 0; i < mCampaignsProgress[mPlayedCampaignID].CurrentMap.UnlockedStorypoints.Length; ++i)
		{
			if(mCampaignsProgress[mPlayedCampaignID].CurrentMap.UnlockedStorypoints[i] == storypointIndex)
			{
				// If story point was already added -> ignore it
				return;
			}
		}
		mCampaignsProgress[mPlayedCampaignID].CurrentMap.UnlockedStorypoints.AddItem(storypointIndex);
	}
}

function GetPlayedMapFileNames(out array<string> mapNames, optional H7CampaignDefinition campaignRef)
{

}

function bool WasMapPlayed(H7CampaignDefinition campaignRef, string mapFileName)
{
	local CampaignProgress tempCampaign;
	local int i;

	tempCampaign = GetCampaignDataByDef(campaignRef);

	if(tempCampaign.CampaignRef != none)
	{
		// Is it completed map?
		for( i = 0; i < tempCampaign.CompletedMaps.Length; ++i )
		{
			if(Caps(tempCampaign.CompletedMaps[i].MapFileName) == Caps(mapFileName) && tempCampaign.CompletedMaps[i].CurrentMapState != MST_NotStarted)
			{
				 return true;
			}
		}
		
		// Maybe its current map?
		if(Caps(tempCampaign.CurrentMap.MapFileName) == Caps(mapFileName) )
		{
			return true;
		}
	}

	return false;
}

function bool IsIvanCampaignFinished()
{
	local int i;

	for( i = 0; i < mCampaignsProgress.Length; ++i)
	{
		if(mCampaignsProgress[i].CampaignRef != none &&  mCampaignsProgress[i].CampaignRef.IsIvanCampaign())
		{
			return IsCampaignComplete(mCampaignsProgress[i].CampaignRef);
		}
	}

	return false;
}

function CampaignMapProgress GetPreviousMapInCampaign(H7CampaignDefinition campaignRef)
{
	local CampaignProgress CampaignData;
	local int i;
	
	CampaignData = GetCampaignDataByDef(campaignRef);

	for(i = 0; i < CampaignData.CompletedMaps.Length; ++i)
	{
		if(CampaignData.CompletedMaps[i].MapFileName == CampaignData.CurrentMap.MapFileName && i > 0)
		{
			return CampaignData.CompletedMaps[i - 1];
		}
	}

	// Return current map if there is no previous
	return CampaignData.CurrentMap;
}


// Handles completing map and sets data for another (or completes campaign data)
function CompleteCurrentMap( H7CampaignDefinition campaignRef)
{
	local bool wasOnceCompleted;
	local int newMapIndex, i;
	local CampaignMapProgress dummyProgress; // DON'T TOUCH! :<

	
	newMapIndex = mCampaignsProgress[mPlayedCampaignID].CurrentMap.MapIndexInCampaign + 1;

	// If new map is out of bounds it means we finished campaign 
	if(newMapIndex >= campaignRef.GetMaxMaps()) 
	{
		newMapIndex = campaignRef.GetMaxMaps() - 1;
		mCampaignsProgress[mPlayedCampaignID].CurrentMap.CurrentMapState = MST_Completed;
		if(!IsMapCompletedInCampaign(campaignRef, mCampaignsProgress[mPlayedCampaignID].CurrentMap.MapIndexInCampaign))
		{
			for(i = 0; i < mCampaignsProgress[mPlayedCampaignID].CompletedMaps.Length; ++i)
			{
				if(Caps(mCampaignsProgress[mPlayedCampaignID].CompletedMaps[i].MapFileName) == Caps(mCampaignsProgress[mPlayedCampaignID].CurrentMap.MapFileName) )
				{
					wasOnceCompleted = true;
					break;
				}
			}

			// Is already on the list -> Replace
			if(wasOnceCompleted)
			{
				mCampaignsProgress[mPlayedCampaignID].CompletedMaps[i] = mCampaignsProgress[mPlayedCampaignID].CurrentMap;
			}
			else // Is not on the list -> Add
			{
				mCampaignsProgress[mPlayedCampaignID].CompletedMaps.AddItem(mCampaignsProgress[mPlayedCampaignID].CurrentMap);
			}
		}
		// If we complete it for the first time, mark it as complete and queue concil end matinee
		if(!mCampaignsProgress[mPlayedCampaignID].IsCompleted)
		{
			mCampaignsProgress[mPlayedCampaignID].IsCompleted = true;

			if(mAchievementManager != none)
			{
				if(!mAchievementManager.GetCompletedOneCampaign())
				{
					if(GetNumCompletedCampaigns(true) >= 1)
					{
						mAchievementManager.ActionCompleted_LFTP();

						mAchievementManager.SetCompletedOneCampaign();
					}
				}

				if(!mAchievementManager.GetCompletedTwoCampaigns())
				{
					if(GetNumCompletedCampaigns(true) >= 2)
					{
						mAchievementManager.ActionCompleted_ML();

						mAchievementManager.SetCompletedTwoCampigns();
					}
				}

				if(!mAchievementManager.GetCompletedFinalCampaign())
				{
					if(campaignRef.IsIvanCampaign() && GetNumCompletedCampaigns(false) >= 2)
					{
						mAchievementManager.ActionCompleted_SAAIDY();

						mAchievementManager.SetCompletedFinalCampaign();
					}

					
				}
			}
		}


		/** TRACKING */
		TrackingCampaignComplete();

		//class'WorldInfo'.static.GetWorldInfo().AddOnScreenDebugMessage(-1, 3.0f, MakeColor(255, 255, 255, 255) , "Campaign ->"@ campaignRef.mName@"is finished!" );

		newMapIndex = campaignRef.GetMaxMaps() - 1;

		if(mCampaignsProgress[mPlayedCampaignID].CampaignRef.mEndMatineeName != "" && mCampaignsProgress[mPlayedCampaignID].CampaignRef.mEndMatineeName != "none" && !mCampaignsProgress[mPlayedCampaignID].CampaignRef.IsIvanCampaign()
				&& !mCampaignsProgress[mPlayedCampaignID].CouncilOutroPlayed)
		{
			class'H7TransitionData'.static.GetInstance().SetPendingMatinee(mCampaignsProgress[mPlayedCampaignID].CampaignRef.mEndMatineeName);

			mCampaignsProgress[mPlayedCampaignID].CouncilOutroPlayed = true;
		}
	
		return;
	}
	else
	{
		// If we replay some mission, it means we completed it before
		if(!IsMapCompletedInCampaign(campaignRef, mCampaignsProgress[mPlayedCampaignID].CurrentMap.MapIndexInCampaign))
		{
			for(i = 0; i < mCampaignsProgress[mPlayedCampaignID].CompletedMaps.Length; ++i)
			{
				if(Caps(mCampaignsProgress[mPlayedCampaignID].CompletedMaps[i].MapFileName) == Caps(mCampaignsProgress[mPlayedCampaignID].CurrentMap.MapFileName) )
				{
					wasOnceCompleted = true;
					break;
				}
			}

			if(mAchievementManager != none && !mAchievementManager.GetCompletedFirstCampaignMap() )
			{
				mAchievementManager.SetCompletedFirstCampaignMap();

				mAchievementManager.ActionCompleted_DIH();
			}
			

			// Is already on the list -> Replace
			if(wasOnceCompleted)
			{
				mCampaignsProgress[mPlayedCampaignID].CompletedMaps[i] = mCampaignsProgress[mPlayedCampaignID].CurrentMap;
			}
			else // Is not on the list -> Add
			{
				mCampaignsProgress[mPlayedCampaignID].CompletedMaps.AddItem(mCampaignsProgress[mPlayedCampaignID].CurrentMap);
			}
			
		}

		//class'WorldInfo'.static.GetWorldInfo().AddOnScreenDebugMessage(-1, 3.0f, MakeColor(0, 255, 0, 255) , "Campaign map ->" @ mCampaignsProgress[mPlayedCampaignID].CampaignRef.GetMapByIndex(mCampaignsProgress[mPlayedCampaignID].CurrentMap.MapIndexInCampaign) @ "is COMPLETED." );

		// Set up new progress data
		mCampaignsProgress[mPlayedCampaignID].CurrentMap = dummyProgress;

		mCampaignsProgress[mPlayedCampaignID].CurrentMap.MapIndexInCampaign = newMapIndex;
		mCampaignsProgress[mPlayedCampaignID].CurrentMap.MapFileName = Caps(mCampaignsProgress[mPlayedCampaignID].CampaignRef.GetMapByIndex(newMapIndex));

		if(mCampaignsProgress[mPlayedCampaignID].CompletedMaps.Length > 0)
		{
			mCampaignsProgress[mPlayedCampaignID].CurrentMap.CurrentDifficulty = mCampaignsProgress[mPlayedCampaignID].CompletedMaps[newMapIndex -1].CurrentDifficulty;	
			// Get difficulty from previous map
			SetSelectedDifficulty(mCampaignsProgress[mPlayedCampaignID].CompletedMaps[newMapIndex -1].CurrentDifficulty);
		}
		
	}

}

// Check if map was completed in previos playthrough of this campaign
function bool WasMapCompletedBefore(int playedCampaignID)
{
	local int i;

	for(i = 0; i < mCampaignsProgress[playedCampaignID].CompletedMaps.Length; ++i)
	{
		if(Caps(mCampaignsProgress[playedCampaignID].CompletedMaps[i].MapFileName) == Caps(mCampaignsProgress[playedCampaignID].CurrentMap.MapFileName) )
		{
			return true;
		}
	}

	return false;
}

function bool SelectedDifficultyEqualsLastPlayedDifficulty(H7CampaignDefinition campaignRef,out EDifficulty lastPlayedDifficulty)
{
	local H7DifficultyParameters current,last;
	local int i;

	current = mSelectedDifficulty;
	
	i = GetCampaignID(campaignRef);
	if(i == INDEX_NONE) return true;

	if( mCampaignsProgress[i].CurrentMap.CurrentMapState == MST_NotStarted && mCampaignsProgress[i].CurrentMap.WasOnceCompleted)
	{
		last = mCampaignsProgress[i].CompletedMaps[mCampaignsProgress[i].CompletedMaps.Length - 1].CurrentDifficulty;
	}
	else
	{
		last = mCampaignsProgress[i].CurrentMap.CurrentDifficulty;
	}
	lastPlayedDifficulty = GetDifficulty(last);

	return last.mCritterGrowthRate == current.mCritterGrowthRate && last.mCritterStartSize == current.mCritterStartSize && last.mStartResources == current.mStartResources;
}

// Checks if there is progress for CampaignRef (if not it means campaign was never started)
function bool IsCampaignEverStarted ( H7CampaignDefinition campaign )
{
	return (GetCampaignDataByDef(campaign).CampaignRef != none) ? true : false;
}

function bool IsCampaignStarted( H7CampaignDefinition campaignRef )
{
	local int i, campaignIndex;

	campaignIndex = GetCampaignID(campaignRef);

	if(campaignIndex <= -1) return false;

	if(mCampaignsProgress[campaignIndex].CurrentMap.CurrentMapState == MST_InProgress) return true;

	for(i = 0; i < mCampaignsProgress[campaignIndex].CompletedMaps.Length; ++i)
	{
		if(mCampaignsProgress[campaignIndex].CompletedMaps[i].CurrentMapState == MST_Completed)
		{
			return true;
		}
	}

	return false;
}

// Get CampaignProgress based on CampaignDefinition
native function int GetCampaignID( H7CampaignDefinition campaignRef);

function int GetCampaignMapIndex( H7CampaignDefinition campaignRef, string mapFileName)
{
	local int i, campaignIndex;

	campaignIndex = GetCampaignID(campaignRef);

	for(i = 0; i < mCampaignsProgress[campaignIndex].CompletedMaps.Length; ++i)
	{
		if(Caps(mCampaignsProgress[campaignIndex].CompletedMaps[i].MapFileName) == Caps(mapFileName) )
		{
			return i;
		}
	}

	return -1; // not found
}

// CARE -> It will return copy of struct.
function CampaignProgress GetCampaignDataByDef( H7CampaignDefinition campaignRef) 
{
	local CampaignProgress Result;
	local int i;

	for( i = 0; i < mCampaignsProgress.Length; ++i )
	{
		if(mCampaignsProgress[i].CampaignRef.IsSameCampaign(campaignRef) )
		{
			Result = mCampaignsProgress[i];
			break;
		}
	}

	return Result;
}

function bool IsCampaignComplete(H7CampaignDefinition campaignRef) 
{	
	return GetCampaignDataByDef(campaignRef).IsCompleted;  
}

function int GetCampaignFinishedMapsNum(H7CampaignDefinition campaignRef)
{
	local int i, count, campaignIndex;

	campaignIndex = GetCampaignID(campaignRef);

	if(campaignIndex < 0)
	{
		return -1;
	}

	for( i = 0; i < mCampaignsProgress[campaignIndex].CompletedMaps.Length; ++i)
	{
		if(mCampaignsProgress[campaignIndex].CompletedMaps[i].CurrentMapState == MST_Completed)
		{
			count += 1;
		}
	}

	return count;
}

// TODO Seen Matinee handling
function array<string> GetSeenMatinees()
{
	local array<string> seenMatinees;

	// TODO add intro and outro matinees depending on campaign states 
	// TODO add progress matinees depending on GetNumCompletedCampaigns
	// TODO is a string enough to identify a matinee, need also name,faction,type[intro,outro,progress]
	seenMatinees = seenMatinees;

	return seenMatinees;
}

// Sets name of savefile  
function SetContinueSave(string saveName, string mapFileName,H7CampaignDefinition campaignRef)
{
	local int campaignIndex;

	if(campaignIndex < 0)
	{
		return;
	}

	campaignIndex = GetCampaignID(campaignRef);

	// It is current campaign
	if(mPlayedCampaignID == campaignIndex)
	{
		// And it is current map
		if(mCampaignsProgress[mPlayedCampaignID].CurrentMap.MapFileName == Caps(mapFileName))
		{
			mCampaignsProgress[mPlayedCampaignID].CurrentMap.LastMapSave.mMapFileName = mapFileName;
			mCampaignsProgress[mPlayedCampaignID].CurrentMap.LastMapSave.mSaveFileName = saveName;

		}
	}
}

function array<int> GetStoryPointsByMap(string mapFileName)
{
	local CampaignProgress cProgress;
	local CampaignMapProgress mProgress;
	local array<int> empty;
	empty = empty;
	foreach mCampaignsProgress(cProgress)
	{
		foreach cProgress.CompletedMaps(mProgress)
		{
			if(Caps(mProgress.MapFileName) == Caps(mapFileName))
			{
				return mProgress.UnlockedStorypoints;
			}
		}
		if(Caps(cProgress.CurrentMap.MapFileName) == Caps(mapFileName))
		{
			return  cProgress.CurrentMap.UnlockedStorypoints;
		}
	}
	return empty;
}

function bool HasFinishedMap(string mapName)
{
	local CampaignProgress progress;
	local CampaignMapProgress mapProgress;
	
	ForEach mCampaignsProgress(progress)
	{
		ForEach progress.CompletedMaps(mapProgress)
		{
			if(mapProgress.MapFileName == caps(mapName))
				return true;
		}
	}

	return false;
}

function bool HasStartedMap(string mapName)
{
	local CampaignProgress progress;
	
	ForEach mCampaignsProgress(progress)
	{
		if(progress.CurrentMap.CurrentMapState == MST_InProgress
		   && progress.CurrentMap.MapFileName == mapName)
			return true;
	}

	return false;
}

function bool HasCampaignProgress()
{
	return mCampaignsProgress.Length > 0;
}

//////////////////////
// Cheaty Cheats
//////////////////////
function Cheat_CompleteMapForCampaign( H7CampaignDefinition campaignRef )
{
	local CampaignProgress campaignData;
	local H7DifficultyParameters diffParams;

	diffParams.mStartResources = DSR_LIMITED;
	diffParams.mCritterStartSize = DCSS_MANY;
	diffParams.mCritterGrowthRate = DCGR_FAST;
	diffParams.mAiEcoStrength = DAIES_PROSPEROUS;

	SetSelectedDifficulty(diffParams);

	if(!IsCampaignEverStarted(campaignRef))
	{
		campaignData.CampaignProgressIndex = mCampaignsProgress.Length;
		campaignData.CampaignRef = campaignRef;
		campaignData.CurrentMap.MapFileName = Caps(campaignRef.GetFirstMap());
		campaignData.CurrentMap.MapIndexInCampaign = 0;

		mCampaignsProgress.AddItem(campaignData);
	}


	ChangeCurrentCampaign(campaignRef);

	HandleMapStart(campaignRef.GetMapByIndex(mCampaignsProgress[mPlayedCampaignID].CompletedMaps.Length), campaignRef);

	// Add some random story points from map (or not so random...)
	mCampaignsProgress[mPlayedCampaignID].CurrentMap.UnlockedStorypoints.AddItem(1);
	mCampaignsProgress[mPlayedCampaignID].CurrentMap.UnlockedStorypoints.AddItem(3);
	mCampaignsProgress[mPlayedCampaignID].CurrentMap.UnlockedStorypoints.AddItem(4);
	mCampaignsProgress[mPlayedCampaignID].CurrentMap.CurrentDifficulty = diffParams;

			
	mCampaignsProgress[mPlayedCampaignID].CurrentMap.CurrentMapState = MST_Completed;
	mCampaignsProgress[mPlayedCampaignID].CurrentMap.TurnsUntilCompleted = 5;
	mCampaignsProgress[mPlayedCampaignID].CurrentMap.WasOnceCompleted = true;
	mCampaignsProgress[mPlayedCampaignID].CurrentMap.HighestDifficulty = mCampaignsProgress[mPlayedCampaignID].CurrentMap.CurrentDifficulty;	

	CompleteCurrentMap(mCampaignsProgress[mPlayedCampaignID].CampaignRef);

	// If we are in council -> Update map
	if(H7CouncilGameInfo(class'WorldInfo'.static.GetWorldInfo().Game) != none)
	{
		H7CouncilGameInfo(class'WorldInfo'.static.GetWorldInfo().Game).GetCouncilManager().GetMapManager().UpdateMap();
	}
}

// Function for testing, this should be REMOVED when done
function Cheat_WipePlayerProfile(bool areYouSure)
{
	if(areYouSure)
	{
		mCampaignsProgress.Length = 0;
		mNormalMapsData.Length = 0;
		mTotalGameplayTimeMin = 0;
		mGameplayTimeSec = 0;
		mPlayedCampaignID = -1;
		mNumOfStartedMaps = 0;
		mPlayedBIKCinematic.Length = 0;
		mHasEnteredCouncil = false;

		mSelectedDifficulty.mStartResources = DSR_AVERAGE;
		mSelectedDifficulty.mCritterStartSize = DCSS_AVERAGE;
		mSelectedDifficulty.mCritterGrowthRate = DCGR_AVERAGE;
		mSelectedDifficulty.mAiEcoStrength = DAIES_AVERAGE;

		mUPlayActions.Length = 0;
		mUPlayRewards.Length = 0;
		
		// If we are in council -> Update map
		if(H7CouncilGameInfo(class'WorldInfo'.static.GetWorldInfo().Game) != none)
		{
			H7CouncilGameInfo(class'WorldInfo'.static.GetWorldInfo().Game).GetCouncilManager().GetMapManager().UpdateMap();
		}

		class'WorldInfo'.static.GetWorldInfo().AddOnScreenDebugMessage(-1, 3.0f, MakeColor(255, 0, 255, 255) , "! PLAYER PROFILE CLEARED !" );
		Save();
	}
}


function Cheat_PrintProfileData()
{
	// BOTTOM
	class'WorldInfo'.static.GetWorldInfo().AddOnScreenDebugMessage(-1, 60.0f, MakeColor(255, 0, 0, 255) , "          | Num of map launches -> " $ mNumOfStartedMaps );
	class'WorldInfo'.static.GetWorldInfo().AddOnScreenDebugMessage(-1, 60.0f, MakeColor(255, 0, 0, 255) , "          | Num of Completed Campagin Maps -> " $ GetNumCompletedMaps() );
	class'WorldInfo'.static.GetWorldInfo().AddOnScreenDebugMessage(-1, 60.0f, MakeColor(255, 0, 0, 255) , "          | Num of Completed Campagins -> " $ GetNumCompletedCampaigns() );
	class'WorldInfo'.static.GetWorldInfo().AddOnScreenDebugMessage(-1, 60.0f, MakeColor(255, 0, 0, 255) , "          | Num of Started Campagins -> " $ GetNumStartedCampaigns() );
	class'WorldInfo'.static.GetWorldInfo().AddOnScreenDebugMessage(-1, 60.0f, MakeColor(255, 0, 0, 255) , "          | Total Campaign Gameplay Time -> " $ GetSanitizedMinutes(GetCampaignGameplayTimeMin()) );
	class'WorldInfo'.static.GetWorldInfo().AddOnScreenDebugMessage(-1, 60.0f, MakeColor(255, 0, 0, 255) , "          | Total Gameplay Time -> " $ GetSanitizedMinutes(GetTotalGameplayTimeMin()) );
	class'WorldInfo'.static.GetWorldInfo().AddOnScreenDebugMessage(-1, 60.0f, MakeColor(255, 0, 0, 255) , "          | UPlayName -> " $ mName );
	class'WorldInfo'.static.GetWorldInfo().AddOnScreenDebugMessage(-1, 60.0f, MakeColor(255, 0, 0, 255) , "PLAYER PROFILE DATA:" );
	// TOP
}

