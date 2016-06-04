//=============================================================================
// H7GfxMapList
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GfxMapList extends H7GFxUIContainer
	dependson(H7ListingMap);

function Update(H7Texture2DStreamLoad mapThumbnail)
{
	SetString("mMapThumbnailPath", "img://" $ Pathname( mapThumbnail ));

	ActionScriptVoid("Update");
	SetVisibleSave( true );
}

function AddCustomCampaigns(array<H7CampaignDefinition> campaigns,int continueIndex)
{
	local GFxObject polledMapsObj, polledMapObj;
	local int i, mapsAdded;
	local int currentMapNumber;
	local int completedMaps;

	polledMapsObj = CreateArray();
	mapsAdded = 0;

	for(i = 0; i<campaigns.Length; i++)
	{
		completedMaps = class'H7PlayerProfile'.static.GetInstance().GetNumCompletedMaps(campaigns[i]);
		currentMapNumber = completedMaps + 1;
		if(currentMapNumber > campaigns[i].GetMaxMaps()) currentMapNumber = 0;

		polledMapObj = CreateObject("Object");
	
		polledMapObj.SetInt("Index", continueIndex + i );
		polledMapObj.SetString("Name", campaigns[i].GetName() );
		polledMapObj.SetString("Description", campaigns[i].GetDescription() );
		polledMapObj.SetString("Creator", campaigns[i].GetAuthor() );
		polledMapObj.SetInt("CompletedMaps", completedMaps );
		polledMapObj.SetInt("MaxMaps", campaigns[i].GetMaxMaps() );
		polledMapObj.SetInt("CurrentMap", currentMapNumber );
		
		AddMapData(polledMapObj,campaigns[i]);

		polledMapObj.SetString("PlayerCount", "-");
		polledMapObj.SetString("Size", "-");
		polledMapObj.SetString("Type", class'H7Loca'.static.LocalizeSave("CAMPAIGN","H7SkirmishSetup"));
		polledMapObj.SetBool("IsCampaign",  true);

		polledMapsObj.SetElementObject(mapsAdded, polledMapObj);
		mapsAdded++;
	}

	SetObject("mPolledMaps", polledMapsObj);
	ActionScriptVoid("AddMaps");
}

function AddMapData(GFxObject data,H7CampaignDefinition theCampaign)
{
	local GFxObject mapList;
	local array<string> maps;
	local string map;
	local int i;

	mapList = CreateArray();
	maps = theCampaign.GetMaps();
	foreach maps(map,i)
	{
		mapList.SetElementString(i,theCampaign.GetMapLocaName(map));
	}

	data.SetObject("MapList",mapList);
}

function AddMap(H7ContentScannerAdventureMapData advData, int continueIndex)
{
	local GFxObject polledMapsObj, polledMapObj, victoryConditionsObj, loseConditionsObj;
	//local int i;
	local String descriptionKey, description, mapName;
	local EH7MapSize mapSize;
	local EMapType mapType;

	polledMapsObj = CreateArray();
	//mapsAdded = 0;

	
	if(advData.AdventureMapData.mMapType == CAMPAIGN) return;
	
	;

	victoryConditionsObj = CreateArray();
	loseConditionsObj = CreateArray();
		
	polledMapObj = CreateObject("Object");

	mapName = class'H7Loca'.static.LocalizeMapInfoObjectByName( 
		advData.AdventureMapData.mMapInfoObjectName ,
		class'H7Loca'.static.GetMapFileNameByPath(advData.Filename),
		"mName",
		advData.AdventureMapData.mMapName 
	);
		
	polledMapObj.SetInt("Index", continueIndex);
	polledMapObj.SetString("Name", mapName );

	setVicotryConditions(advData.AdventureMapData, victoryConditionsObj);
	polledMapObj.SetObject("VictoryConditions", victoryConditionsObj);

	setLoseConditions(advData.AdventureMapData, loseConditionsObj);
	polledMapObj.SetObject("LoseConditions", loseConditionsObj);

	descriptionKey = "TheWorld:PersistentLevel.WorldInfo_0."$advData.AdventureMapData.mMapInfoObjectName@"H7MapInfo";
	description = class'H7Loca'.static.LocalizeField(descriptionKey,advData.Filename,"mDescription", advData.AdventureMapData.mMapDescription);
	polledMapObj.SetString("Description", description);

	polledMapObj.SetInt("PlayerCount", advData.AdventureMapData.mPlayerAmount);

	mapSize = EH7MapSize(advData.AdventureMapData.mMapSize);
	polledMapObj.SetString("Size",  class'H7Loca'.static.LocalizeSave(String(mapSize),"H7SkirmishSetup"));

	mapType = EMapType(advData.AdventureMapData.mMapType);
	polledMapObj.SetString("Type",  class'H7Loca'.static.LocalizeSave(String(mapType),"H7SkirmishSetup"));

	polledMapsObj.SetElementObject(0, polledMapObj);
	
	

	SetObject("mPolledMaps", polledMapsObj);
	ActionScriptVoid("AddMaps");
}

/*function AddMaps(array<H7ListingMapData> polledMaps,int continueIndex)
{
	local GFxObject polledMapsObj, polledMapObj, victoryConditionsObj, loseConditionsObj;
	local int i, mapsAdded;
	local String descriptionKey, description, mapName;
	local EH7MapSize mapSize;
	local EMapType mapType;

	polledMapsObj = CreateArray();
	mapsAdded = 0;

	for(i = 0; i<polledMaps.Length; i++)
	{
		if(polledMaps[i].MapData.mMapType == CAMPAIGN) continue;

		victoryConditionsObj = CreateArray();
		loseConditionsObj = CreateArray();
		
		polledMapObj = CreateObject("Object");

		mapName = class'H7Loca'.static.LocalizeMapInfoObjectByName( 
			polledMaps[i].MapData.mMapInfoObjectName ,
			class'H7Loca'.static.GetMapFileNameByPath(polledMaps[i].Filename),
			"mName",
			polledMaps[i].MapData.mMapName 
		);
		
		polledMapObj.SetInt("Index", continueIndex + i );
		polledMapObj.SetString("Name", mapName );

		setVicotryConditions(polledMaps[i].MapData, victoryConditionsObj);
		polledMapObj.SetObject("VictoryConditions", victoryConditionsObj);

		setLoseConditions(polledMaps[i].MapData, loseConditionsObj);
		polledMapObj.SetObject("LoseConditions", loseConditionsObj);

		descriptionKey = "TheWorld:PersistentLevel.WorldInfo_0."$polledMaps[i].MapData.mMapInfoObjectName@"H7MapInfo";
		description = class'H7Loca'.static.LocalizeField(descriptionKey,polledMaps[i].Filename,"mDescription", polledMaps[i].MapData.mMapDescription);
		polledMapObj.SetString("Description", description);

		polledMapObj.SetInt("PlayerCount", polledMaps[i].MapData.mPlayerAmount);

		mapSize = EH7MapSize(polledMaps[i].MapData.mMapSize);
		polledMapObj.SetString("Size",  `Localize("H7SkirmishSetup", String(mapSize)));

		mapType = EMapType(polledMaps[i].MapData.mMapType);
		polledMapObj.SetString("Type",  `Localize("H7SkirmishSetup", String(mapType)));

		polledMapsObj.SetElementObject(mapsAdded, polledMapObj);
		mapsAdded++;
	}

	SetObject("mPolledMaps", polledMapsObj);
	ActionScriptVoid("AddMaps");
}*/

function setVicotryConditions(H7MapData data, out GFxObject conditionsObj)
{
	local EGameWinConditionType victoryCondition;
	local EGameWinConditionType standardVictoryCondition;

	standardVictoryCondition = EGameWinConditionType_Standard;

	victoryCondition = EGameWinConditionType(data.mWinConditionType);

	//add victoryCondition
	conditionsObj.SetElementString(0,  class'H7Loca'.static.LocalizeSave(String(victoryCondition),"H7SkirmishSetup")); 

	if(data.mMapType == SKIRMISH)
	{
		if(victoryCondition != EGameWinConditionType_Standard && data.mIncludeStandardWinConditions)
		{
			//add standard condition to conditionObj
			conditionsObj.SetElementString(1, class'H7Loca'.static.LocalizeSave(string(standardVictoryCondition),"H7SkirmishSetup"));
		}
	}
}

function setLoseConditions(H7MapData data, out GFxObject conditionsObj)
{
	local EGameLoseConditionType loseCondition;
	local EGameLoseConditionType standardLoseCondition;

	standardLoseCondition = EGameLoseConditionType_Standard;

	loseCondition = EGameLoseConditionType(data.mLoseConditionType);

	//add victoryCondition
	conditionsObj.SetElementString(0,  class'H7Loca'.static.LocalizeSave(String(loseCondition),"H7SkirmishSetup")); 

	if(data.mMapType == SKIRMISH)
	{
		if(loseCondition != EGameLoseConditionType_Standard)
		{
			//add standard condition to conditionObj
			conditionsObj.SetElementString(1, class'H7Loca'.static.LocalizeSave(string(standardLoseCondition),"H7SkirmishSetup"));
		}
	}
}

function ListingMapDone()
{
	ActionscriptVoid("ListingMapDone");
}

function ReloadThumbnail()
{
	ActionScriptVoid("ReloadThumbnail");
}

function ShowThumbnail()
{
	ActionScriptVoid("ShowThumbnail");
}

function NoThumbnailAvailable()
{
	ActionScriptVoid("NoThumbnailAvailable");
}

function DisplayDifficultySettings(int global,int res,int strength,int growth,int ai)
{
	ActionScriptVoid("DisplayDifficultySettings");
}

function SetFilter(string mapTypeCaption)
{
	ActionScriptVoid("SetFilter");
}

function Reset()
{
	super.Reset();
	SetVisibleSave(false);
}
