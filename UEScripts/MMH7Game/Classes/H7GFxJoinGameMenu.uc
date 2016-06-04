//=============================================================================
// H7GFxJoinGameMenu
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxJoinGameMenu extends H7GFxUIContainer;

function SetGames(array<OnlineGameSearchResult> searchResults)
{
	local int SearchIdx,NumActivePlayers, totalSlots;
	local string SlotString;
	local GFxObject DataProvider;
	local GFxObject TmpObject;
	local H7OnlineGameSettings gameSettings;
	local string mapName;

	//SearchResults = class'H7MainMenuInfo'.static.GetInstance().SearchResults;
	DataProvider = CreateArray();
	
	for (SearchIdx = 0; SearchIdx < SearchResults.Length; SearchIdx++)
	{
		gameSettings = H7OnlineGameSettings(SearchResults[SearchIdx].GameSettings);
		totalSlots = gameSettings.NumPublicConnections - gameSettings.GetNumClosedSlots();
		NumActivePlayers = gameSettings.NumPublicConnections - gameSettings.NumOpenPublicConnections + gameSettings.GetNumAISlots();
		SlotString = NumActivePlayers $ "/" $ totalSlots;
		if( gameSettings.GetNumAISlots() > 0 )
		{
			SlotString $= " (" $ gameSettings.GetNumAISlots() $ ")";
		}

		TmpObject = CreateObject("Object");
		TmpObject.SetInt("SlotsFilled",NumActivePlayers);
		TmpObject.SetInt("SlotsMax",totalSlots);
		TmpObject.SetString("ServerSlots", SlotString);
		TmpObject.SetInt("Ping", gameSettings.PingInMs ); 
		TmpObject.SetInt("NAT", gameSettings.GetNatType() );
		TmpObject.SetString("Creator", gameSettings.GetServerName());
		TmpObject.SetString("MapFileName", gameSettings.GetMapFilepath());
		TmpObject.SetString("MapName", gameSettings.GetMapNameLocalized());
		TmpObject.SetString("SkillType", gameSettings.GetSkillTypeAsStringLocalized());
		TmpObject.SetString("TurnType", gameSettings.GetTurnTypeAsStringLocalized());
		
		if(gameSettings.GetGameType() == 1)
		{
			TmpObject.SetBool("Duel", true );
			TmpObject.SetString("Position", gameSettings.GetSkillType() == 1 ? "DUEL_POSITION_1" : "DUEL_POSITION_2");
		}
		
		if(false/*UplayFriend*/) // TODO MP
		{
			TmpObject.SetString("FriendIcon", "img://" $ Pathname(class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mButtonIcons.mFriend) );
		}

		if(NumActivePlayers == totalSlots)
		{
			TmpObject.SetString("FullIcon", "img://" $ Pathname(class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mButtonIcons.mFull) );
		}

		// detail infos:
		// ...

		DataProvider.SetElementObject(SearchIdx, TmpObject);
		class'H7ReplicationInfo'.static.PrintLogMessage("Server found:" @ SearchIdx @ gameSettings.GetMapNameLocalized() @ gameSettings.OwningPlayerName @ gameSettings.OwningPlayerId.Uid.A @ gameSettings.OwningPlayerId.Uid.B, 0);;
		class'H7ReplicationInfo'.static.PrintLogMessage("------------>" @ gameSettings.bIsLanMatch @ gameSettings.bAllowJoinInProgress @ gameSettings.GetServerName() @ gameSettings.GetTurnType() @ gameSettings.GetSkillType(), 0);;
		class'H7ReplicationInfo'.static.PrintLogMessage("------------>" @ gameSettings.NumPublicConnections @ gameSettings.NumOpenPublicConnections @ gameSettings.GetNumClosedSlots() @ gameSettings.GetNumAISlots(), 0);;
		class'H7ReplicationInfo'.static.PrintLogMessage("------------>" @ gameSettings.IsSavedGame(), 0);;

		if(gameSettings.IsSavedGame())
		{
			TmpObject.SetString("SaveIcon" , "img://" $ Pathname(class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mButtonIcons.mSaveAll) );
		}

		TmpObject.SetString("VictoryCondition", gameSettings.GetVictoryConditionAsStringLocalized());
		TmpObject.SetString("Team", gameSettings.GetTeamSetupAsString() );
		TmpObject.SetString("Position", gameSettings.GetUseRandomStartPosition()?"POS_RANDOM":"POS_CUSTOM");
		TmpObject.SetString("QuickCombat", gameSettings.GetForceQuickCombatAsStringLocalized());
		TmpObject.SetString("TeamTrade", gameSettings.GetTeamsCanTrade()?"YES":"NO");
		TmpObject.SetString("Difficulty", gameSettings.GetDifficultyAsString());
		
		TmpObject.SetFloat("SpeedAdv",gameSettings.GetGameSpeedAdventure());
		TmpObject.SetFloat("SpeedCombat",gameSettings.GetGameSpeedCombat());
		TmpObject.SetFloat("SpeedAI",gameSettings.GetGameSpeedAdventureAI());
		
		TmpObject.SetString("TimerAdv",gameSettings.GetTimerAdvAsString());
		TmpObject.SetString("TimerCombat",gameSettings.GetTimerCombatAsString());
		
		mapName = gameSettings.GetMapFilepath();
		TmpObject.SetString("MapSize",class'H7JoinGameMenuCntl'.static.GetInstance().GetMapSize(mapName));
		TmpObject.SetString("MapType",class'H7JoinGameMenuCntl'.static.GetInstance().GetMapType(mapName));
	}

	SetObject("mData",DataProvider);
	
	Update();
}

function SetLANDuelMode(bool isLAN,bool isDuel)
{
	ActionscriptVoid("SetLANDuelMode");
}

function Update( )
{
	ActionscriptVoid("Update");
}

function ReloadThumbnail(string path)
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

function DisableRefreshButton()
{
	ActionscriptVoid("DisableRefreshButton");
}

function UpdateNatDisplay(int statusCode,optional bool upnp)
{
	ActionscriptVoid("UpdateNatDisplay");
}
