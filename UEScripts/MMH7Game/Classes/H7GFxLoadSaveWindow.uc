//=============================================================================
// H7GFxLoadSaveWindow
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxLoadSaveWindow extends H7GFxUIContainer
	dependson(H7ListingSavegame);

function SetAnimateOnClosing(bool val) { ActionScriptVoid("SetAnimateOnClosing"); }

function SetData(bool withCurrentData)
{
	local array<H7ListingSavegameDataScene> unrealList;
	local H7ListingSavegameDataScene savegameHeader;
	local GFxObject list,savegameData;
	local int i;
	local H7SaveGameHeaderManager savegameInfo,currentGameInfo;

	savegameInfo = new class'H7SaveGameHeaderManager';
	unrealList = class'H7PlayerController'.static.GetPlayerController().GetSaveGameList();

	list = CreateArray();
	i = 0;
	
	if(withCurrentData) // main menu has no current data
	{
		// whether save or load:	
		// create a fake entry that represents the current game situation:
		currentGameInfo = class'H7PlayerController'.static.GetPlayerController().GetSaveGameHeaderManager();
		currentGameInfo.Setup(SAVETYPE_MANUAL,"",false); // will be manual save when saved (but for now is just tmp/dummy info)
		savegameData = CreateGameDataObject(currentGameInfo);
		savegameData.SetString("FileName","-1");
		savegameData.SetString("Name",class'H7Loca'.static.LocalizeSave("CURRENT_GAME","H7LoadSaveWindow"));
		savegameData.SetString("Icon","img://" $ PathName(GetHud().GetProperties().mButtonIcons.mSaveNew));
		savegameData.SetInt("ScreenshotWidth",class'H7LoadSaveWindowCntl'.static.GetInstance().GetResolutionWidth());
		savegameData.SetInt("ScreenshotHeight",class'H7LoadSaveWindowCntl'.static.GetInstance().GetResolutionHeight());
		
		list.SetElementObject(i,savegameData);
		i++;
	}

	// contains the savegames that are already scanned, also all savegames after deleting a savegame
	// currently scanned savegames will arrive later
	foreach unrealList(savegameHeader)
	{
		;
		savegameInfo.SetData(savegameHeader.SavegameData,savegameHeader.HealthStatus);
		
		if(!IsDevAccount() && savegameInfo.GetGameMode() == MULTIPLAYER && savegameInfo.GetData().mPlayersSettings[0].mName != class'H7PlayerController'.static.GetPlayerController().PlayerReplicationInfo.PlayerName)
		{
			continue;
		}
		
		savegameData = CreateGameDataObject(savegameInfo);
		savegameData.SetString("FileName",string(savegameHeader.SlotIndex));
	
		list.SetElementObject(i,savegameData);
		i++;
	}

	SetObject("mData",list);

	Update();
}

public function AddSaveGames(array<H7ListingSavegameDataScene> polledGames)
{
	local H7SaveGameHeaderManager saveGameHeader;
	local H7SavegameData saveGameHeaderData;
	local GFxObject savegameData, savegameList;
	local int i;

	savegameList = CreateArray();
	saveGameHeader = new class'H7SaveGameHeaderManager';

	for(i = 0; i<polledGames.Length; i++)
	{
		;
		saveGameHeaderData = polledGames[i].SavegameData;
		saveGameHeader.SetData(saveGameHeaderData,polledGames[i].HealthStatus);
		
		if(!IsDevAccount() && saveGameHeader.GetGameMode() == MULTIPLAYER && saveGameHeader.GetData().mPlayersSettings[0].mName != class'H7PlayerController'.static.GetPlayerController().PlayerReplicationInfo.PlayerName)
		{
			continue;
		}

		savegameData = CreateGameDataObject(saveGameHeader);
		savegameData.SetString("FileName",string(polledGames[i].SlotIndex));
		
		savegameList.SetElementObject(i, savegameData);
	}

	SetObject("mPolledSaveGames", savegameList);
	ActionScriptVoid("AddSaveGames");
}

function bool IsDevAccount() // YOLO
{
	return InStr(class'H7PlayerController'.static.GetPlayerController().PlayerReplicationInfo.PlayerName,",") != INDEX_NONE;
}

// does not add "FileName", add it after the call
function GFxObject CreateGameDataObject(H7SaveGameHeaderManager savegameInfo)
{
	local GFxObject savegameData;
	local Texture2D icon;
	local string displayName;

	displayName = savegameInfo.GetName();

	savegameData = CreateObject("Object");

	savegameData.SetString("Name",displayName);
	savegameData.SetBool("Corrupted",savegameInfo.IsCorrupted());
	savegameData.SetBool("Unsupported",savegameInfo.IsUnsupported());
	savegameData.SetString("MapName",savegameInfo.GetMapLocaName());
	savegameData.SetString("MapType",savegameInfo.GetMapTypeAsString());
	savegameData.SetString("GameType",savegameInfo.GetGameModeAsString());
	savegameData.SetString("SaveType",savegameInfo.GetSaveTypeAsString());
	savegameData.SetString("SkillType",savegameInfo.GetSkillTypeAsString());
	savegameData.SetInt("UnixTime",savegameInfo.GetSaveTimeUnix());
	savegameData.SetString("Date",savegameInfo.GetSaveTime());
	savegameData.SetString("Difficulty",savegameInfo.GetDifficultyAsString());
	savegameData.SetString("VictoryCondition",savegameInfo.GetVictoryConditionAsString());
	savegameData.SetString("SaveType",savegameInfo.GetSaveTypeAsString());

	//`log_dui(class'H7PlayerController'.static.GetPlayerController().PlayerReplicationInfo.PlayerName @ IsDevAccount());

	if(!IsDevAccount() && savegameInfo.GetGameMode() == MULTIPLAYER && savegameInfo.GetData().mPlayersSettings[0].mName != class'H7PlayerController'.static.GetPlayerController().PlayerReplicationInfo.PlayerName)
	{
		savegameData.SetBool("Blocked",true);
		savegameData.SetString("BlockReason",Repl(class'H7Loca'.static.LocalizeSave("TT_MULTIPLAYER_SAVE_NOT_HOST","H7LoadSaveWindow"),"%host",savegameInfo.GetData().mPlayersSettings[0].mName));
	}

	if(savegameInfo.GetSaveType() == SAVETYPE_QUICK)
	{
		icon = GetHud().GetProperties().mButtonIcons.mSaveQuick;
	}
	else if(savegameInfo.GetGameMode() == SINGLEPLAYER)
	{
		if(savegameInfo.GetMapType() == SKIRMISH || savegameInfo.GetMapType() == SCENARIO)
		{
			icon = GetHud().GetProperties().mButtonIcons.mSaveCustom;
		}
		else 
		{
			icon = GetHud().GetProperties().mButtonIcons.mSaveCampaign;
		}
	}
	else if(savegameInfo.GetGameMode() == HOTSEAT)
	{
		icon = GetHud().GetProperties().mButtonIcons.mSaveHotseat;
	}
	else if(savegameInfo.GetGameMode() == MULTIPLAYER)
	{
		icon = GetHud().GetProperties().mButtonIcons.mSaveMultiplayer;
	}
	savegameData.SetString("Icon","img://" $ Pathname(icon));

	return savegameData;
}

function Update( )
{
	ActionscriptVoid("Update");
}

// call before update
function SetSaveMode(bool val)
{
	ActionscriptVoid("SetSaveMode");
}

function SetCloseButton(bool val)
{
	ActionscriptVoid("SetCloseButton");
}

function SetScreenShot(String screenshot)
{
	;
	ActionscriptVoid("SetScreenShot");
}

// call after update
function PreSelectIndex(int i,bool screenshotAlreadySet)
{
	;
	ActionscriptVoid("PreSelectIndex");
}

function ZoomIn()
{
	ActionscriptVoid("ZoomIn");
}

function TriggerDeleteClick()
{
	ActionscriptVoid("TriggerDeleteClick");
}
