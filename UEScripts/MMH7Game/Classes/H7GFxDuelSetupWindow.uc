//=============================================================================
// H7GFxDuelSetupWindow
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxDuelSetupWindow extends H7GFxUIContainer
	dependson(H7GFxSkirmishSetupWindow);

function SetupThumbnailPathTexture(H7Texture2DStreamLoad streamingTexture)
{
	SetupThumbnailPath("img://" $ PathName(streamingTexture));
}

function SetupThumbnailPath(string path)
{
	ActionScriptVoid("SetupThumbnailPath");
}

// general info
function Update() 
{
	local GFxObject data;

	data = CreateObject("Object");

	// retrieve the current situation:
	data.SetInt("MyIndex",class'H7ReplicationInfo'.static.GetInstance().GetMyPlayerIndex());
	data.SetBool("IsMaster",class'H7PlayerController'.static.GetPlayerController().IsServer());
	data.SetBool("IsMultiplayer",class'H7ReplicationInfo'.static.GetInstance().IsMultiplayerGame());
	data.SetBool("IsLAN",class'H7ReplicationInfo'.static.GetInstance().IsLAN());

	/*
	// need map header!
	mapLocaName = class'H7Loca'.static.LocalizeMapInfoObjectByName( 
		class'H7ReplicationInfo'.static.GetInstance().mMapHeaderCombat.MapData.mMapInfoObjectName ,
		mapFileName,
		"mName",
		class'H7ReplicationInfo'.static.GetInstance().mMapHeaderCombat.MapData.mMapName,
		true
	);
	data.SetString("MapName",mapLocaName);
	*/

	SetObject("mData", data);

	ActionScriptVoid("Update"); // all drop down windows will request all their possibilities now
	SetVisibleSave( true );
}

function AddMaps(array<H7ListingCombatMapData> polledMaps)
{
	local GFxObject polledMapsObj, polledMapObj;
	local int i;
	local String description, mapName;

	polledMapsObj = CreateArray();

	for(i = 0; i<polledMaps.Length; i++)
	{
		polledMapObj = CreateObject("Object");

		mapName = class'H7Loca'.static.LocalizeMapInfoObjectByName( 
			polledMaps[i].MapData.mMapInfoObjectName ,
			class'H7Loca'.static.GetMapFileNameByPath(polledMaps[i].Filename),
			"mName",
			polledMaps[i].MapData.mMapName ,
			true
		);		
		description = class'H7Loca'.static.LocalizeMapInfoObjectByName( 
			polledMaps[i].MapData.mMapInfoObjectName ,
			class'H7Loca'.static.GetMapFileNameByPath(polledMaps[i].Filename),
			"mDescription",
			polledMaps[i].MapData.mMapDescription,
			true
		);

		mapName = mapName @ "(" $ polledMaps[i].MapData.mMapSizeX @ "x" @ polledMaps[i].MapData.mMapSizeY $ ")";

		//polledMapObj.SetString("MapFileName", class'H7Loca'.static.GetMapFileNameByPath(polledMaps[i].Filepath) );
		polledMapObj.SetString("MapFileName", polledMaps[i].Filename);
		polledMapObj.SetString("Name", mapName );
		polledMapObj.SetString("Description", description);
		polledMapObj.SetInt("SizeX", polledMaps[i].MapData.mMapSizeX);
		polledMapObj.SetInt("SizeY", polledMaps[i].MapData.mMapSizeY);
		polledMapObj.SetBool("Siege", polledMaps[i].MapData.mMapSiege);

		polledMapsObj.SetElementObject(i, polledMapObj);
	}

	SetObject("mPolledMaps", polledMapsObj);
	ActionScriptVoid("AddMaps");
}

function AddMap(H7ContentScannerCombatMapData polledMap)
{
	local GFxObject polledMapsObj, polledMapObj;
	local String description, mapName;

	polledMapsObj = CreateArray();

	//for(i = 0; i<polledMaps.Length; i++)
	//{
		polledMapObj = CreateObject("Object");

		mapName = class'H7Loca'.static.LocalizeMapInfoObjectByName( 
			polledMap.CombatMapData.mMapInfoObjectName ,
			class'H7Loca'.static.GetMapFileNameByPath(polledMap.Filename),
			"mName",
			polledMap.CombatMapData.mMapName ,
			true
		);		
		description = class'H7Loca'.static.LocalizeMapInfoObjectByName( 
			polledMap.CombatMapData.mMapInfoObjectName ,
			class'H7Loca'.static.GetMapFileNameByPath(polledMap.Filename),
			"mDescription",
			polledMap.CombatMapData.mMapDescription,
			true
		);

		mapName = mapName @ "(" $ polledMap.CombatMapData.mMapSizeX @ "x" @ polledMap.CombatMapData.mMapSizeY $ ")";

		//polledMapObj.SetString("MapFileName", class'H7Loca'.static.GetMapFileNameByPath(polledMaps[i].Filepath) );
		polledMapObj.SetString("MapFileName", polledMap.Filename);
		polledMapObj.SetString("Name", mapName );
		polledMapObj.SetString("Description", description);
		polledMapObj.SetInt("SizeX", polledMap.CombatMapData.mMapSizeX);
		polledMapObj.SetInt("SizeY", polledMap.CombatMapData.mMapSizeY);
		polledMapObj.SetBool("Siege", polledMap.CombatMapData.mMapSiege);

		polledMapsObj.SetElementObject(0, polledMapObj);
	//}

	SetObject("mPolledMaps", polledMapsObj);
	ActionScriptVoid("AddMaps");
}

function ListingMapDone()
{
	ActionscriptVoid("ListingMapDone");
}

// setting struct 1 - map
function DisplayMapSettings(string mapFileName,string mapLocaName)
{
	;
	ActionScriptVoid("DisplayMapSettings");
}

// setting struct 2 - game
function DisplayGameSettings(H7LobbyDataGameSettings gameSettings)
{
	ActionScriptVoid("DisplayGameSettings");
}

// setting struct 3 - player
function DisplayPlayerSettings(int playerIndex, PlayerLobbySelectedSettings playerData)
{
	local PlayerLobbySelectedSettingsGUI guiStruct;
	
	guiStruct.mName =  playerData.mName;
	guiStruct.mSlotState =  playerData.mSlotState;
	guiStruct.mAIDifficulty =  playerData.mAIDifficulty;
	guiStruct.mPosition =  playerData.mPosition;
	guiStruct.mColor =  playerData.mColor;
	
	guiStruct.mFaction = playerData.mFaction != none ? playerData.mFaction.GetArchetypeID() : "";
	guiStruct.mStartHero = playerData.mStartHero != none ? playerData.mStartHero.GetArchetypeID() : "None";
	guiStruct.mStartHeroIcon = playerData.mStartHero != none ? playerData.mStartHero.GetFlashIconPath() : "None";
	guiStruct.mStartHeroName = playerData.mStartHero != none ? playerData.mStartHero.GetName() : "None";
	guiStruct.mStartHeroLevel = playerData.mStartHero != none ? playerData.mStartHero.GetLevel() : 1;
	guiStruct.mStartHeroIsMight = playerData.mStartHero != none ? playerData.mStartHero.IsMightHero() : true;
	guiStruct.mStartHeroArchetypeID = playerData.mStartHero != none ? playerData.mStartHero.GetHPArchetypeID() : "None";
	guiStruct.mHeropediaAvailable = playerData.mStartHero != none ? class'H7HeropediaCntl'.static.GetInstance().IsHeroDataAvailable( playerData.mStartHero.GetHPArchetypeID()) : false;
	guiStruct.mArmyIndex = class'H7GameData'.static.GetInstance().GetDuelArmyIndex(playerData.mArmy,playerData.mFaction);
	
	guiStruct.mIsReady =  playerData.mIsReady;
	
	DisplayPlayerSettingsGUI(playerIndex,guiStruct);

	DisplayArmy(playerIndex,guiStruct.mArmyIndex,playerData.mArmy);
}
function DisplayPlayerSettingsGUI(int index, PlayerLobbySelectedSettingsGUI playerData)
{
	ActionScriptVoid("DisplayPlayerSettings");
}
function DisplayStartCondition(bool canStart,optional string blockReason)
{
	ActionScriptVoid("DisplayStartCondition");
}
// special helper/update functions

// 0 = host (left)
// 1 = client (right)
function DisplayArmy(int playerIndex,int armyIndex,H7EditorArmy army)
{
	local GFxObject data;
	data = CreateObject("Object");
	data.SetInt("PlayerIndex",playerIndex);
	data.SetObject("Army",CreateDuelArmyObject(playerIndex,armyIndex,army,
		class'H7GameUtility'.static.GetColor(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mColor))
	);
	SetObject("mData",data);
	UpdateArmy();
}

function GFxObject CreateDuelArmyObject(int playerIndex,int armyIndex,H7EditorArmy army,Color fallBackColor)
{
	local GFxObject data;
	data = CreateObject("Object");
	data.SetInt("ArmyIndex",armyIndex);
	if(IsRandomArmy(army))
	{
		data.SetString("ArmyName",Repl(class'H7Loca'.static.LocalizeSave("RANDOM_ARMY","H7DuelSetup"),"%faction",class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mFaction.GetName()));
	}
	else
	{
		data.SetString("ArmyName",class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mFaction.GetNumberedArmyName(armyIndex));
	}
	data.SetObject("Creatures", CreateArmyObject(army,,fallBackColor));
	data.SetObject("Warfares", CreateWarefareUnitsObject(army,fallBackColor));
	data.SetBool("IsRandom",IsRandomArmy(army));
	data.SetBool("HasLeft",armyIndex > 0);
	data.SetBool("HasRight",none != class'H7GameData'.static.GetInstance().GetDuelArmy(armyIndex+1,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mFaction));
	return data;
}

function bool IsRandomArmy(H7EditorArmy army)
{
	return army == class'H7GameData'.static.GetInstance().GetRandomDuelArmy();
}

function UpdateArmy()
{
	ActionScriptVoid("UpdateArmy");
}

function SetNewList(string dropDownName,array<H7DropDownEntry> list,optional int playerIndex=INDEX_NONE,optional bool blockSendingToUnreal)
{
	ActionScriptVoid("SetNewList");
}
