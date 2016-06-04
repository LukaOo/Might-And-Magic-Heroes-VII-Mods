//=============================================================================
// H7SaveGameHeaderManager
//
// manages the data struct (provides functions to access/process/fill the data struct) H7SavegameData
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7SaveGameHeaderManager extends Object
	dependson(H7StructsAndEnums,H7SavegameDataHolder,H7ListingSavegame);

var protected H7SavegameData mHeaderData;
var protected H7SavegameHealthStatus mStatus;

function String GetName() 
{
	local string displayName;
	displayName = mHeaderData.mName;
	if(displayName == "")
	{
		if(GetSaveType() == SAVETYPE_AUTO)
		{
			displayName = class'H7Loca'.static.LocalizeSave("SAVETYPE_AUTO","H7LoadSaveWindow");
		}
		else if(GetSaveType() == SAVETYPE_QUICK)
		{
			displayName = class'H7Loca'.static.LocalizeSave("SAVETYPE_QUICK","H7LoadSaveWindow");
		}
	}

	if(IsUnsupported())
	{
		displayName = class'H7Loca'.static.LocalizeSave("SAVE_UNSUPPORTED","H7LoadSaveWindow");
	}
	
	if(IsCorrupted())
	{
		displayName = class'H7Loca'.static.LocalizeSave("SAVE_CORRUPTED","H7LoadSaveWindow");
	}
	return displayName;
} 
function SetName(string savename) { mHeaderData.mName = savename; }

function SetData(H7SavegameData data, H7SavegameHealthStatus status) { mHeaderData = data; mStatus = status; }
function H7SavegameData GetData() { return mHeaderData; }

function bool IsCorrupted(){	return mStatus == H7_HS_CORRUPTED;}
function bool IsUnsupported(){	return mStatus == H7_HS_UNSUPPORTEDVERSION;}

function H7LobbyDataGameSettings GetGameSettings() { return mHeaderData.mGameSettings;}
function H7LobbyDataMapSettings GetMapSettings() { return mHeaderData.mMapSettings;}
function array<PlayerLobbySelectedSettings> GetplayerSettings() { return mHeaderData.mPlayersSettings; }
function int GetSaveTimeUnix() { return mHeaderData.mSaveTimeUnix;}
function EGameMode GetGameMode() { return mHeaderData.mGameMode;}
function EDifficulty GetDifficulty() { return mHeaderData.mGameSettings.mDifficulty;}
function ESaveType GetSaveType() { return mHeaderData.mSaveType;}
function String GetSaveTime() {	return mHeaderData.mSaveTime;}
//function String GetMapFilePath() { return mHeaderData.mMapFilePath;} // this dont work in MP use GetMapFileName
function String GetMapFileName() {	return mHeaderData.mMapFileName;}
function String GetMapLocaName() 
{
	if(IsCorrupted() || IsUnsupported()) return "";
	return class'H7Loca'.static.LocalizeMapInfoObjectByName(mHeaderData.mMapInfo,mHeaderData.mMapFileName,"mName",mHeaderData.mMapName);
}
function string GetVictoryConditionAsString() { return String(mHeaderData.mMapSettings.mVictoryCondition); }

function EMapType GetMapType() 
{ 
	return mHeaderData.mMapType;
}

function String GetGameModeAsString() 
{
	local EGameMode tmp;
	tmp = EGameMode(mHeaderData.mGameMode);
	return String(tmp);
}

function String GetDifficultyAsString()
{
	local EDifficulty tmp;
	tmp = EDifficulty(mHeaderData.mGameSettings.mDifficulty);
	return String(tmp);
}

function String GetSaveTypeAsString() 
{
	local ESaveType tmp;
	tmp = ESaveType(mHeaderData.mSaveType);
	return String(tmp);
}

function String GetMapTypeAsString() 
{ 
	local EMapType tmp;
	tmp = GetMapType();
	return String(tmp);
}

function String GetSkillTypeAsString()
{
	if(mHeaderData.mGameSettings.mUseRandomSkillSystem) return "SKILL_TYPE_RANDOM";
	else return "SKILL_TYPE_FREE";
}

// info "aquiring" getter
// warning, returns fake unixtime-like number (only use for sorting)
function int GetTimeStamp()
{
	local int year,month,day7,day,hour,min,sec,msec;
	local int unixtime;

	GetSystemTime(year,month,day7,day,hour,min,sec,msec);

	unixtime = (sec+60*(min+60*(hour+24*(day+31*(month+12*(year-1970))))));

	return unixtime;
}

// sucks up the info of the current game status and writes it into itself
function Setup(ESaveType saveType,optional string userInputName,optional bool generateCheckSum)
{
	local int year,month,day7,day,hour,min,sec,msec;
	local H7CampaignDefinition campaignDef;
	local H7MapInfo theMapInfo;
	local H7AdventureController adventureController;
	
	;
	;

	adventureController = class'H7AdventureController'.static.GetInstance();

	theMapInfo = adventureController.GetMapInfo();
	
	GetSystemTime(year,month,day7,day,hour,min,sec,msec);
	campaignDef = adventureController.GetCampaign();
	
	// basic infos not from settings
	mHeaderData.mName = userInputName;
	mHeaderData.mSaveTimeUnix = GetTimeStamp(); // intended for sorting (TODO sorting)
	mHeaderData.mGameMode = adventureController.GetCurrentGameMode();
	mHeaderData.mTurnCounter = adventureController.GetTurns();
	mHeaderData.mSaveType = saveType;
	mHeaderData.mSaveTime = year $ "-" $ AddZero(month) $ "-" $ AddZero(day) @ AddZero(hour) $ ":" $ AddZero(min) $ ":" $ AddZero(sec);

	if(generateCheckSum)
	{
		mHeaderData.mSaveGameCheckSum = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomIntRange( 0 , MaxInt ); // fake checksum
		class'H7ReplicationInfo'.static.PrintLogMessage("Checksum" @ mHeaderData.mSaveGameCheckSum, 0);;
	}

	// infos from current map
	if(class'GameEngine'.static.GetOnlineSubsystem() != none && class'GameEngine'.static.GetOnlineSubsystem().GameInterface != none
		&& class'GameEngine'.static.GetOnlineSubsystem().GameInterface.GetGameSettings('H7GameSession') != none)
	{
		mHeaderData.mMapFilePath = class'H7MultiplayerGameManager'.static.GetOnlineGameSettings().GetMapFilepath();
	}
	mHeaderData.mMapFileName = class'H7ReplicationInfo'.static.GetInstance().GetCurrentMapName(); // optional remove on next full rebuild // why? // because duplicate to mMapSettings.mMapFileName
	if(theMapInfo != none)
	{	
		mHeaderData.mMapType = theMapInfo.GetMapType();
		// unfortunately a lot of maps are scenario/skirmish but should appear as campaign maps, so we hack it in this case
		if(mHeaderData.mMapType == SCENARIO || mHeaderData.mMapType == SKIRMISH)
		{
			if(class'H7AdventureController'.static.GetInstance().GetCampaign() != none)
			{
				// map is played in campaign context -> save as campaign type
				mHeaderData.mMapType = CAMPAIGN;
			}
		}
		mHeaderData.mMapInfo = String(theMapInfo);
		mHeaderData.mMapName = theMapInfo.GetNameUnlocalized(); // the hardcode string will only be used when loca fails
	}
	else
	{
		;
	}

	if(campaignDef == none)
	{
		mHeaderData.mCampaignID = "none";
	}
	else
	{
		mHeaderData.mCampaignID = string(campaignDef);
	}

	// infos from map settings
	mHeaderData.mMapSettings = adventureController.GetMapSettings();
	
	// infos from game settings
	mHeaderData.mGameSettings = adventureController.GetGameSettings();

	// infos from player settings
	mHeaderData.mPlayersSettings = adventureController.GetPlayerSettings();

	;
}

function String AddZero(int value)
{
	if(value < 10) return "0" $ value;
	else return String(value);
}
