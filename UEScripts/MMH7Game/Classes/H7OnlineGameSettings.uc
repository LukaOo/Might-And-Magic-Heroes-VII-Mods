//=============================================================================
// H7OnlineGameSettings
//
// If you want to add a new field, talk with Manuel
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7OnlineGameSettings extends OnlineGameSettings;


// This cannot be done, we can extend the OnlineGameSettings only for setting the defaultproperties, but not adding new variables (they will be ignored)
//var databinding string MapName; 

function SetServerName(string serverName)
{
	SetStringProperty(OSP_SERVERNAME, serverName);
}

function string GetServerName()
{
	return GetPropertyAsString(OSP_SERVERNAME);
}

function SetMapInfoNumber(int mapInfoNumber)
{
	SetIntProperty(OSP_MAPINFONUMBER, mapInfoNumber);
}

function int GetMapInfoNumber()
{
	local int value;
	GetIntProperty(OSP_MAPINFONUMBER, value );
	return value;
}

function string GetMapNameLocalized()
{
	return class'H7Loca'.static.LocalizeField(
		class'H7Loca'.static.GetSectionByInfoNumber( GetMapInfoNumber() , GetGameType() == 1 ) ,
		class'H7Loca'.static.GetMapFileNameByPath( GetMapFilepath() ) ,
		"mName" ,
		class'H7Loca'.static.GetMapFileNameByPath( GetMapFilepath() ) // since we don't have the map header we can not use the fallback name
	);
}

function SetMapFilepath(string mapName)
{
	SetStringProperty(OSP_MAPFILENAME, mapName);
}

function string GetMapFilepath()
{
	return GetPropertyAsString(OSP_MAPFILENAME);
}

function NatTypeFriendly GetNatType()
{
	local int value;
	GetIntProperty(OSP_NAT_TYPE, value );
	return NatTypeFriendly(value);
}

function SetTurnType(int turnType)
{
	SetIntProperty(OSP_TURNTYPE, turnType);
}

function int GetTurnType()
{
	local int value;
	GetIntProperty(OSP_TURNTYPE, value );
	return value;
}

function string GetTurnTypeAsStringLocalized()
{
	local int value;
	GetIntProperty(OSP_TURNTYPE, value );
	if(value == 1) return class'H7Loca'.static.LocalizeSave("TURN_TYPE_SIMTURNS","H7SkirmishSetup");
	else return class'H7Loca'.static.LocalizeSave("TURN_TYPE_NORMALTURNS","H7SkirmishSetup");
}

function SetSkillType(int skillType)
{
	SetIntProperty(OSP_SKILLTYPE, skillType);
}

function int GetSkillType()
{
	local int value;
	GetIntProperty(OSP_SKILLTYPE, value );
	return value;
}

function string GetSkillTypeAsStringLocalized()
{
	local int value;
	GetIntProperty(OSP_SKILLTYPE, value );
	if(value == 1) return class'H7Loca'.static.LocalizeSave("SKILL_TYPE_RANDOM","H7SkirmishSetup");
	else return class'H7Loca'.static.LocalizeSave("SKILL_TYPE_FREE","H7SkirmishSetup");
}

function SetNumClosedSlots(int numClosedSlots)
{
	SetIntProperty(OSP_NUMCLOSEDSLOTS, numClosedSlots);
}

function int GetNumClosedSlots()
{
	local int value;
	GetIntProperty(OSP_NUMCLOSEDSLOTS, value );
	return value;
}

function SetNumAISlots(int numAISlots)
{
	SetIntProperty(OSP_NUMAISLOTS, numAISlots);
}

function int GetNumAISlots()
{
	local int value;
	GetIntProperty(OSP_NUMAISLOTS, value );
	return value;
}

// 0 == skirmish, 1 == duel
function SetGameType(int gameType)
{
	SetIntProperty(OSP_GAMETYPE, gameType);
}

// 0 == skirmish, 1 == duel
function int GetGameType()
{
	local int value;
	GetIntProperty(OSP_GAMETYPE, value );
	return value;
}

function SetIsGameStarted(bool isGameStarted)
{
	bGameStarted = isGameStarted; // this will be used by the LAN to know if the game started
	SetIntProperty(OSP_ISGAMESTARTED, isGameStarted ? 1 : 0);
}

function bool IsGameStarted()
{
	local int value;
	GetIntProperty(OSP_ISGAMESTARTED, value );
	return value == 1;
}

function int GetSessionId()
{
	local int value;
	GetIntProperty(OSP_SESSION_ID, value );
	return value;
}

//
// additional info that will come directly from the server and not from the Sandbox
//
function SetIsSavedGame(bool isSavedGame)
{
	SetIntProperty(OSP_ISSAVEDGAME, isSavedGame ? 1 : 0);
}

function bool IsSavedGame()
{
	local int value;
	GetIntProperty(OSP_ISSAVEDGAME, value );
	return value == 1;
}

function SetVictoryCondition(EVictoryCondition victoryCondition)
{
	SetIntProperty(OSP_VICTORYCONDITION, victoryCondition);
}

function EVictoryCondition GetVictoryCondition()
{
	local int value;
	GetIntProperty(OSP_VICTORYCONDITION, value );
	return EVictoryCondition(value);
}

function string GetVictoryConditionAsStringLocalized()
{
	local EVictoryCondition vicCon;
	vicCon = GetVictoryCondition();
	return string(vicCon);
}

function SetUseRandomStartPosition(bool useRandomStartPosition)
{
	SetIntProperty(OSP_USERANDOMPOSITION, useRandomStartPosition ? 1 : 0);
}

function bool GetUseRandomStartPosition()
{
	local int value;
	GetIntProperty(OSP_USERANDOMPOSITION, value );
	return value == 1;
}

function SetGameSpeedAdventure(float gameSpeedAdventure)
{
	SetFloatProperty(OSP_GAMESPEEDADVENTURE, gameSpeedAdventure);
}

function float GetGameSpeedAdventure()
{
	local float value;
	GetFloatProperty(OSP_GAMESPEEDADVENTURE, value );
	return value + 0.001f;
}

function SetGameSpeedAdventureAI(float gameSpeedAdventureAI)
{
	SetFloatProperty(OSP_GAMESPEEDADVENTUREAI, gameSpeedAdventureAI);
}

function float GetGameSpeedAdventureAI()
{
	local float value;
	GetFloatProperty(OSP_GAMESPEEDADVENTUREAI, value );
	return value + 0.001f;
}

function SetGameSpeedCombat(float gameSpeedCombat)
{
	SetFloatProperty(OSP_GAMESPEEDCOMBAT, gameSpeedCombat);
}

function float GetGameSpeedCombat()
{
	local float value;
	GetFloatProperty(OSP_GAMESPEEDCOMBAT, value );
	return value + 0.001f;
}

function SetTimerCombat(ETimerCombat timerCombat)
{
	SetIntProperty(OSP_TIMERCOMBAT, timerCombat);
}

function ETimerCombat GetTimerCombat()
{
	local int value;
	GetIntProperty(OSP_TIMERCOMBAT, value );
	return ETimerCombat(value);
}

function string GetTimerCombatAsString()
{
	local ETimerCombat t;
	t = GetTimerCombat();
	return string(t);
}

function SetTimerAdv(ETimerAdv timerAdv)
{
	SetIntProperty(OSP_TIMERADV, timerAdv);
}

function ETimerAdv GetTimerAdv()
{
	local int value;
	GetIntProperty(OSP_TIMERADV, value );
	return ETimerAdv(value);
}

function string GetTimerAdvAsString()
{
	local ETimerAdv t;
	t = GetTimerAdv();
	return string(t);
}

function SetForceQuickCombat(EForceQuickCombat forceQuickCombat)
{
	SetIntProperty(OSP_FORCEQUICKCOMBAT, forceQuickCombat);
}

function EForceQuickCombat GetForceQuickCombat()
{
	local int value;
	GetIntProperty(OSP_FORCEQUICKCOMBAT, value );
	return EForceQuickCombat(value);
}

function string GetForceQuickCombatAsStringLocalized()
{
	local EForceQuickCombat q;
	q = GetForceQuickCombat();
	return string(q);
}

function SetTeamsCanTrade(bool teamsCanTrade)
{
	SetIntProperty(OSP_TEAMSCANTRADE, teamsCanTrade ? 1 : 0);
}

function bool GetTeamsCanTrade()
{
	local int value;
	GetIntProperty(OSP_TEAMSCANTRADE, value );
	return value == 1;
}

function SetDifficulty(EDifficulty difficulty)
{
	SetIntProperty(OSP_DIFFICULTY, difficulty);
}

function EDifficulty GetDifficulty()
{
	local int value;
	GetIntProperty(OSP_DIFFICULTY, value );
	return EDifficulty(value);
}

function SetTeamSetup(ETeamSetup teamSetup)
{
	SetIntProperty(OSP_TEAMSETUP, teamSetup);
}
function string GetDifficultyAsString()
{
	local EDifficulty d;
	d = GetDifficulty();
	return string(d);
}

function ETeamSetup GetTeamSetup()
{
	local int value;
	GetIntProperty(OSP_TEAMSETUP, value );
	return ETeamSetup(value);
}

function string GetTeamSetupAsString()
{
	local ETeamSetup t;
	t = GetTeamSetup();
	return string(t);
}

