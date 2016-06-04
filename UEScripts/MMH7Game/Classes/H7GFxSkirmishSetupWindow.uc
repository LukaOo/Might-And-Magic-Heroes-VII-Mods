//=============================================================================
// H7GFxSkirmishSetupWindow
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxSkirmishSetupWindow extends H7GFxUIContainer;

struct native PlayerLobbySelectedSettingsGUI
{
	var EPlayerSlotState		mSlotState;
	var string					mName;
	var EAIDifficulty			mAIDifficulty;
	var ETeamNumber				mTeam;
	var string			        mStartHero;
	var string                  mStartHeroIcon;
	var string                  mStartHeroName;
	var bool                    mStartHeroIsMight;
	var int                     mStartHeroLevel;
	var String                  mStartHeroArchetypeID;
	var bool                    mHeropediaAvailable;
	var EPlayerColor			mColor;
	var string                  mFaction;
	var int                     mStartBonusIndex; // -1 = random, 0 = first map-defined bonus, 1 = second ... 
	var EStartPosition          mPosition;
	var int                     mArmyIndex;
	var bool                    mIsReady;
	var bool                    mPlayerStartAvailable;
};

function Update(string mapName,bool isMaster,bool isLoadedGame) 
{
	local GFxObject data;
	local H7MapData mapData;

	mapData = class'H7ReplicationInfo'.static.GetInstance().GetMapHeader().AdventureMapData;

	data = CreateObject("Object");

	;
	class'H7ReplicationInfo'.static.PrintLogMessage("MyIndex" @ class'H7ReplicationInfo'.static.GetInstance().GetMyPlayerIndex(), 0);;
	
	data.SetBool("IsMaster",isMaster);
	data.SetBool("IsLoadedGame",isLoadedGame);
	data.SetBool("IsScenario",EMapType(mapData.mMapType) == SCENARIO);
	if(isLoadedGame)
	{
		data.SetString("SaveGameFileName",class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mSaveGameFileName);
	}
	data.SetInt("MyIndex",class'H7ReplicationInfo'.static.GetInstance().GetMyPlayerIndex());
	data.SetBool("IsMultiplayer",class'H7ReplicationInfo'.static.GetInstance().IsMultiplayerGame());
	
	/*
	`log_dui("MapName" @ class'H7ReplicationInfo'.static.GetInstance().GetMapHeader().MapData.mMapName);
	`log_dui("MapName2" @ class'H7Loca'.static.GetMapFileNameByPath(class'H7ReplicationInfo'.static.GetInstance().GetMapHeader().Filepath));
	`log_dui("mapName3" @ mapName);
	`log_dui("mapName4" @ class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mMapSettings.mMapFileName);

	`log_dui("Filepath" @ class'H7ReplicationInfo'.static.GetInstance().GetMapHeader().Filepath);
	`log_dui("MapInfo" @ class'H7ReplicationInfo'.static.GetInstance().GetMapHeader().MapData.mMapInfoObjectName);
	`log_dui("MapNameLoca" @ class'H7Loca'.static.LocalizeMapInfoObjectByName( 
		class'H7ReplicationInfo'.static.GetInstance().GetMapHeader().MapData.mMapInfoObjectName ,
		mapName,
		"mName",
		class'H7ReplicationInfo'.static.GetInstance().GetMapHeader().MapData.mMapName
	));
	*/

	data.SetString("MapName",class'H7Loca'.static.LocalizeMapInfoObjectByName( 
		class'H7ReplicationInfo'.static.GetInstance().GetMapHeader().AdventureMapData.mMapInfoObjectName ,
		mapName,
		"mName",
		class'H7ReplicationInfo'.static.GetInstance().GetMapHeader().AdventureMapData.mMapName
	));

	data.SetInt("MapPlayers",class'H7ReplicationInfo'.static.GetInstance().GetMapHeader().AdventureMapData.mPlayerAmount);

	SetObject("mData", data);

	ActionScriptVoid("Update"); // all drop down windows will request all their possibilities now
	SetVisibleSave( true );
}

function SetThumbnail(H7Texture2DStreamLoad mapThumbnail)
{
	;
	SetString("mMapThumbnailPath", "img://" $ Pathname( mapThumbnail ));

	ActionScriptVoid("SetThumbnail");
}

function ShowThumbnail()
{
	ActionScriptVoid("ShowThumbnail");
}

function HideThumbnail()
{
	ActionScriptVoid("HideThumbnail");
}

function UpdateNatDisplay(int statusCode,bool upnp)
{
	ActionScriptVoid("UpdateNatDisplay");
}

function DisplayStartCondition(bool canStart,optional string blockReason)
{
	ActionScriptVoid("DisplayStartCondition");
}

function DisplayMapSettings(EVictoryCondition v,bool bonus,ETeamSetup t,bool position,string vicDescription)
{
	;
	ActionScriptVoid("DisplayMapSettings");
}

function DisplayGameSettings(H7LobbyDataGameSettings gameSettings)
{
	ActionScriptVoid("DisplayGameSettings");
}

function DisplayPlayerSettings(int index, PlayerLobbySelectedSettings playerData)
{
	local PlayerLobbySelectedSettingsGUI guiStruct;

	guiStruct.mFaction = playerData.mFaction != none ? playerData.mFaction.GetArchetypeID() : "";
	guiStruct.mAIDifficulty =  playerData.mAIDifficulty;
	guiStruct.mColor =  playerData.mColor;
	guiStruct.mIsReady =  playerData.mIsReady;
	guiStruct.mName =  playerData.mName;
	guiStruct.mPosition =  playerData.mPosition;
	guiStruct.mSlotState =  playerData.mSlotState;
	guiStruct.mStartBonusIndex =  playerData.mStartBonusIndex;
	guiStruct.mStartHero = playerData.mStartHero != none ? playerData.mStartHero.GetArchetypeID() : "None";
	guiStruct.mStartHeroIcon = playerData.mStartHero != none ? playerData.mStartHero.GetFlashIconPath() : "None";
	guiStruct.mStartHeroName = playerData.mStartHero != none ? playerData.mStartHero.GetName() : "None";
	guiStruct.mStartHeroIsMight = playerData.mStartHero != none ? playerData.mStartHero.IsMightHero() : false;
	guiStruct.mStartHeroLevel =  playerData.mStartHero != none ? playerData.mStartHero.GetLevel() : 1;
	guiStruct.mStartHeroArchetypeID = playerData.mStartHero != none ? playerData.mStartHero.GetArchetypeID() : "None";
	guiStruct.mHeropediaAvailable = playerData.mStartHero != none ? class'H7HeropediaCntl'.static.GetInstance().IsHeroDataAvailable( playerData.mStartHero.GetHPArchetypeID()) : false;
	guiStruct.mPlayerStartAvailable = class'H7ReplicationInfo'.static.GetInstance().GetMapHeaderPlayerInfoByLobbyPlayerIndex(index).PlayerStartAvailable;
	guiStruct.mTeam =  playerData.mTeam;

	DisplayPlayerSettingsGUI(index,guiStruct);
}

function DisplayPlayerSettingsGUI(int index, PlayerLobbySelectedSettingsGUI playerData)
{
	ActionScriptVoid("DisplayPlayerSettings");
}

function SetNewList(string dropDownName,array<H7DropDownEntry> list,optional int playerIndex=INDEX_NONE,optional bool blockSendingToUnreal)
{
	ActionScriptVoid("SetNewList");
}
