//=============================================================================
// H7SkirmishSetupWindowCntl
//
// This really is the lobby screen for singleplayer/hotseat/lan/internet games
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7SkirmishSetupWindowCntl extends H7FlashMovieCntl
	dependson(H7StructsAndEnums);

struct H7DropDownEntry
{
	var string Caption;
	var int Data; // bool 0/1 ; enum 0/1/2/3/4/...
	var string StrData; // higher priority if set
	var bool Enabled;
	var string Icon;
	var string Color;

	structdefaultproperties
	{
		Enabled=true;
		Color="-1";
	}
};

var protected H7GFxSkirmishSetupWindow mSkirmishSetup;
var protected H7GFxHeroSelection mHeroSelection;
var protected GFxCLIKWidget mBtnBack;
var protected H7GFxLog mChatWindow;
var protected H7Log mChatLog;
var protected H7GFxUIContainer mPopUpCustomDifficulty;

var protected H7Texture2DStreamLoad mMapThumbnail;

var protected bool mIsMultiplayer;
var protected bool mIsLoadedGame;
var protected bool mIsMaster;
var protected bool mIsHotseat;

var protected bool mHeroSelectionVisible;
var protected bool mCustomDifficultyVisible;
var protected bool mNatUpdaterActive;

var protected int mPendingKickPlayerIndex;
var protected EAIDifficulty mPendingKickAI;

public delegate OnKickDoneDelegate();

static function H7SkirmishSetupWindowCntl GetInstance() { return class'H7PlayerController'.static.GetPlayerController().GetMainMenuHud().GetSkirmishSetupWindowCntl(); }

function H7GFxSkirmishSetupWindow GetSkirmishWindow() { return mSkirmishSetup; }

function bool IsHeroSelectionVisible() {return mHeroSelectionVisible;}
function bool IsCustomDifficultyVisible() {return mCustomDifficultyVisible;}

function bool IsScenario()
{
	return EMapType(class'H7ReplicationInfo'.static.GetInstance().GetMapHeader().AdventureMapData.mMapType) == SCENARIO;
}

function bool IsSkirmish()
{
	return EMapType(class'H7ReplicationInfo'.static.GetInstance().GetMapHeader().AdventureMapData.mMapType) == SKIRMISH;
}

function bool Initialize()
{
	;

	Super.Start();

	AdvanceDebug(0);

	mSkirmishSetup = H7GFxSkirmishSetupWindow(mRootMC.GetObject("aSkirmishSetup", class'H7GFxSkirmishSetupWindow'));
	mSkirmishSetup.SetVisibleSave(false);

	mHeroSelection = H7GFxHeroSelection(mSkirmishSetup.GetObject("mHeroSelection", class'H7GFxHeroSelection'));
	mHeroSelection.SetVisibleSave(false);

	mPopUpCustomDifficulty = H7GFxUIContainer(mSkirmishSetup.GetObject("mPopUpCustomDifficulty", class'H7GFxUIContainer'));
	mPopUpCustomDifficulty.SetVisibleSave(false);

	mBtnBack = GFxCLIKWidget(mSkirmishSetup.getObject("mBtnBack", class'GFxCLIKWidget'));
	mBtnBack.AddEventListener('CLIK_click', btnBackClick);

	mChatWindow = H7GFxLog(mSkirmishSetup.getObject("mChat", class'H7GFxLog'));

	mChatLog = new class'H7Log';
	mChatWindow.Init(mChatLog);

	mMapThumbnail = new class'H7Texture2DStreamLoad';

	Super.Initialize();
	return true;
}

function OpenPopup(out H7LobbyData lobbyData,bool isMaster,bool isMultiplayer,bool isLoadedGame,bool isHotseat)
{
	; // OPTIONAL lan vs internet?

	class'H7SoundController'.static.GetInstance().LoadingScreenEnabled(false);
	class'H7TransitionData'.static.GetInstance().SetIsInMapTransition(true);

	mIsMaster = isMaster;
	mIsMultiplayer = isMultiplayer;
	mIsLoadedGame = isLoadedGame;
	mIsHotseat = isHotseat;
	//mMapData = lobbyData.mMapSettings.mMapFileName;

	// 0) hack fix initlobbydata
	InitAllPlayerHeroes();

	// 1) set up the screen with all possibilities
	mSkirmishSetup.SetVisibleSave(true);
	mSkirmishSetup.Update(lobbyData.mMapSettings.mMapFileName,isMaster,isLoadedGame); // generates all possibilities

	// 2) change all fields to the current actual settings:
	DisplayMapSettings(lobbyData.mMapSettings);
	DisplayGameSettings(lobbydata.mGameSettings);
	DisplayAllPlayerSettings();

	// deactivate fields done by flash after data changes

	mHeroSelection.SetAllHeroes(false, IsSkirmish());

	GetHUD().SetFocusMovie(self);

	SetPriority(50); // needed for chat input
	H7MainMenuHud(GetHUD()).GetMainMenuCntl().GetMainMenu().SetVisibleSave(false);

	class'Engine'.static.StopMovie(true);
	CheckOwnFaction();

	if(isMultiplayer)
	{
		RegisterNatUpdater(true);
}
	else
	{
		mSkirmishSetup.UpdateNatDisplay(0,false);
	}

	GetHUD().GetLogCntl().GetBorderBlack().SetVisibleSave(true);
}

function RegisterNatUpdater(bool register)
{
	;
	if(register && !mNatUpdaterActive)
	{
		;
		mNatUpdaterActive = true;
		GetHUD().SetFrameTimer(1,UpdateNatDisplay);
	}
	else if(!register && mNatUpdaterActive)
	{
		;
		mNatUpdaterActive = false;
	}
}

function UpdateNatDisplay()
{
	local int statusCode;
	local bool upnp;

	;
	if(mNatUpdaterActive)
	{
		GetHUD().SetFrameTimer(1,UpdateNatDisplay);
	}

	if(OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).mRDVManager != none)
	{
		statusCode = OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).mRDVManager.mStormManager.mNatType;
		upnp = OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).mRDVManager.mStormManager.mIsUPnPMappingDone;
	}

	mSkirmishSetup.UpdateNatDisplay(statusCode,upnp);
}

function CheckOwnFaction()
{
	local H7Faction is;
	local int playerIndex;
	local array<H7DropDownEntry> factions;
	local H7DropDownEntry faction;

	playerIndex = class'H7ReplicationInfo'.static.GetInstance().GetMyPlayerIndex();
	is = class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mFaction;
	factions  = GetFactionEnumList(playerIndex);

	foreach factions(faction)
	{
		if(faction.StrData == is.GetArchetypeID())
		{
			if(faction.Enabled)
			{
				return;
			}
		}
	}

	// change to first enabled faction
	foreach factions(faction)
	{
		if(faction.Enabled)
		{
			class'H7PlayerController'.static.GetPlayerController().ServerLobbySetPlayerFaction( playerIndex, faction.StrData );
		}
	}
}

function InitAllPlayerHeroes()
{
	local int i;
	;
	for(i=0;i<8;i++)
	{
		if(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mStartHero == none)
		{
			FixHeroSetting(i);
		}
	}
}

function DisplayAllPlayerSettings()
{
	local int i;
	for(i=0;i<8;i++)
	{
		DisplayPlayerSettings(i,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i]);
	}
}

function SetHeroSelectionVisible(bool visible)
{
	mHeroSelectionVisible = visible;
}

function SetCustomDifficultyVisible(bool visible)
{
	mCustomDifficultyVisible = visible;
}

//////////////////////////////////////////////////////////////////////////////////////////////7
// CHAT
//////////////////////////////////////////////////////////////////////////////////////////////7

// flash calls this
function SendChatLine(string line)
{
	;
	class'H7PlayerController'.static.GetPlayerController().SendLobbyChat( line );
}

// call this to add a message to the chat-gui
function AddChatLine(string line,string playerName)
{
	//local H7MessageSettings settings;
	local H7Message message;
	;
	
	message = new class'H7Message';
	if(playerName != "")
	{
		message.text = playerName $ ":" @ line;
	}
	else
	{
		message.text = "<font color='#ffff00'>" $ line $ "<font>";
	}

	mChatLog.AddMessage(message);
	//mChatLog.AddMessage();
}

//////////////////////////////////////////////////////////////////////////////////////////////7
// START HANDLING
//////////////////////////////////////////////////////////////////////////////////////////////7

function CheckStartConditions()
{
	local string blockReason;
	local bool canStart;

	if(mIsMaster)
	{
		canStart = CanStartSkirmish(blockReason);
		mSkirmishSetup.DisplayStartCondition(canStart,blockReason);
	}
}
function bool CanStartSkirmish(out string blockReason)
{
	local array<H7EditorHero> randomHeroes;
	local array<EStartPosition> positions;
	local array<H7EditorHero> heroes;
	local bool hasOpponent;
	local bool allSameTeam;
	local int i, humanCount;

	class'H7GameData'.static.GetInstance().GetRandomHeroes(randomHeroes);

	allSameTeam = true;

	for(i=0;i<8;i++)
	{
		// duplicate positions?
		if(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mSlotState != EPlayerSlotState_Closed
			&& (!mIsMultiplayer || class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mSlotState != EPlayerSlotState_Open) // SP-open = consider; MP-open= not consider
			&& class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mPosition != START_POSITION_RANDOM
			&& positions.Find(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mPosition) != INDEX_NONE)
		{
			blockReason = class'H7Loca'.static.LocalizeSave("TT_DUPLICATE_POSITION","H7SkirmishSetup");
			blockReason = Repl(blockReason,"%i",i+1);
			return false;
		}
				
		if( class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mSlotState != EPlayerSlotState_Closed
			&& (!mIsMultiplayer || class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mSlotState != EPlayerSlotState_Open) )
		{
			positions.AddItem(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mPosition);
		}

		// duplicate heroes?
		if( class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mSaveGameFileName == "")
		{
			if( class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mSlotState != EPlayerSlotState_Closed
				&& (!mIsMultiplayer || class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mSlotState != EPlayerSlotState_Open)
				&& class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mStartHero != none
				&& randomHeroes.Find(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mStartHero) == INDEX_NONE
				&& heroes.Find(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mStartHero) != INDEX_NONE )
			{
				blockReason = class'H7Loca'.static.LocalizeSave("TT_DUPLICATE_HERO","H7SkirmishSetup");
				blockReason = Repl(blockReason,"%i",i+1);
				return false;
			}

			if( class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mSlotState != EPlayerSlotState_Closed
				&& (!mIsMultiplayer || class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mSlotState != EPlayerSlotState_Open) 
				&& class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mStartHero != class'H7GameData'.static.GetInstance().GetRandomHero() )
			{
				heroes.AddItem( class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mStartHero );
			}
		}

		// opponent in multiplayer?
		// same team?
		if(i != 0 
			&& (
				class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mSlotState == EPlayerSlotState_Occupied // MP human
				|| class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mSlotState == EPlayerSlotState_AI // AI
				|| (!mIsMultiplayer && class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mSlotState == EPlayerSlotState_Open)) // Hotseat Human
			)
		{
			hasOpponent = true;
			if(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[0].mTeam != class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mTeam
				|| class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[0].mTeam == TN_NO_TEAM
				|| class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[1].mTeam == TN_NO_TEAM)
			{
				allSameTeam = false;
			}
		}

		if(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mSlotState == EPlayerSlotState_Occupied )
		{
			humanCount++;
		}

		// ready?
		if(i != 0 
			&& class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mSlotState == EPlayerSlotState_Occupied 
			&& !class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mIsReady)
		{
			blockReason = class'H7Loca'.static.LocalizeSave("TT_NOT_READY","H7SkirmishSetup");
			blockReason = Repl(blockReason,"%i",i+1);
			return false;
		}		
	}

	if(!hasOpponent)
	{
		blockReason = "TT_NO_OPPONENT";
		return false;
	}

	if(allSameTeam)
	{
		blockReason = "TT_ALL_PLAYERS_IN_SAME_TEAM";
		return false;
	}

	if(mIsMultiplayer && humanCount < 2)
	{
		blockReason = "TT_AT_LEAST_TWO_HUMAN_PLAYER";
		return false;
	}

	return true;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// GENERAL
///////////////////////////////////////////////////////////////////////////////////////////////////

// unreal has to generate list of possible entries for 1 specific drop down field
function array<H7DropDownEntry> GetEnumList(string enumName,optional int playerIndex)
{
	local array<H7DropDownEntry> list;
	local H7MapData mapData;

	;
	mapData = class'H7ReplicationInfo'.static.GetInstance().GetMapHeader().AdventureMapData;

	switch(enumName)
	{
		case "EVictoryCondition":
			return GetVictoryConditionEnumList();
		case "BStartBonus": // fake enum, because it is bool
			AddEntry(list,"NONE",0);
			AddEntry(list,"MAP_BONI",1);
		break;
		case "ETeamSetup":
			//return GetEnumListByObject(TEAM_MAX,Enum'ETeamSetup');
			AddEntry(list,"TEAM_CUSTOM",0, EMapType(mapData.mMapType) == SKIRMISH );
			AddEntry(list,"TEAM_MAP_DEFAULT",1);
			AddEntry(list,"TEAM_NO_TEAMS",2, EMapType(mapData.mMapType) == SKIRMISH);
		break;
		case "BPosition": // fake enum, because it is bool
			if(mapData.mRandomStartPositionAvailable)
			{
				AddEntry(list,"POS_RANDOM",1);
			}
			AddEntry(list,"POS_CUSTOM",0);
		break;
		case "BTurnType":
			AddEntry(list,"TURN_TYPE_SIMTURNS",1);
			AddEntry(list,"TURN_TYPE_NORMALTURNS",0);
		break;
		case "BSkillType":
			AddEntry(list,"SKILL_TYPE_RANDOM",1);
			AddEntry(list,"SKILL_TYPE_FREE",0);
		break;
		case "BTeamTrade":
			AddEntry(list,"YES",1);
			AddEntry(list,"NO",0);
		break;
		case "EForceQuickCombat":
			return GetEnumListByObject(FQC_MAX,Enum'EForceQuickCombat');
		break;
		case "BSpectatorMode":
			AddEntry(list,"SPECTATOR_VIEW",0);
			AddEntry(list,"SPECTATOR_BLOCK",1);
			break;
		case "EDifficulty":
			return GetEnumListByObject(DIFFICULTY_MAX,Enum'EDifficulty');
		break;
		case "ETimerAdv":
			return GetEnumListByObject(TIMER_ADV_MAX,Enum'ETimerAdv');
		break;
		case "ETimerCombat":
			return GetEnumListByObject(TIMER_COMBAT_MAX,Enum'ETimerCombat');
		break;
		// custom difficulty
		case "EDifficultyStartResources":
			return GetEnumListByObject(DSR_MAX,Enum'EDifficultyStartResources');
		case "EDifficultyCritterStartSize":
			return GetEnumListByObject(DCSS_MAX,Enum'EDifficultyCritterStartSize'); 
		case "EDifficultyCritterGrowthRate":
			return GetEnumListByObject(DCGR_MAX,Enum'EDifficultyCritterGrowthRate'); 
		case "EDifficultyAIEcoStrength":
			return GetEnumListByObject(DAIES_MAX,Enum'EDifficultyAIEcoStrength');
		
		// player row
		case "ESlot":
			return GetSlotEnumList(playerIndex);
		break;
		case "EPlayerColor":
			return GetColorEnumList();
			//return GetEnumListByObject(PCOLOR_MAX,Enum'EPlayerColor');
		case "EStartPosition":
			return GetPositionEnumList(playerIndex);
		case "ETeamNumber":
			return GetEnumListByObject(TN_MAX,Enum'ETeamNumber');
		case "EFaction":
			return GetFactionEnumList(playerIndex);
		case "EBonus":
			return GetBonusEnumList(playerIndex);
		//case "EHeroes":
			//return GetHeroesEnumList(playerIndex);

	}

	return list;
}

function array<H7DropDownEntry> GetPositionEnumList(int playerIndex)
{
	//local H7DropDownEntry entry;
	local PlayerLobbySelectedSettings playerSettings;
	local H7MapHeaderPlayerInfoProperty mapSettingsOfPosition;
	local array<H7DropDownEntry> list;
	local int i;
	local EStartPosition positionToCheck;

	;
		
	// random can never be selected manually, but it switches to it, wenn the global option is set to random, so only for that it needs to be activated
	if(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mMapSettings.mUseRandomStartPosition)
	{
		AddEntry(list,"START_POSITION_RANDOM",START_POSITION_RANDOM,true);
	}
	else
	{
		for(i=1;i<START_POSITION_MAX;i++)
		{
			// can the current occupant go to position i
			positionToCheck = EStartPosition(i);
			playerSettings = class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex];
			mapSettingsOfPosition = class'H7ReplicationInfo'.static.GetInstance().GetMapHeaderPlayerInfoByPosition(positionToCheck);
			if((CanUserBeInSlot(playerSettings,mapSettingsOfPosition) && NoOneElseHasPosition(playerIndex,positionToCheck))
				|| positionToCheck == playerSettings.mPosition) // is already in that position, so we enable it, so it can be selected in gui
			{
				;
				AddEntry(list,String(positionToCheck),positionToCheck,true);
			}
			else
			{
				;
				AddEntry(list,String(positionToCheck),positionToCheck,false);
			}
		}
	}
	return list;
}

function bool CanUserBeInSlot(PlayerLobbySelectedSettings user,H7MapHeaderPlayerInfoProperty slot)
{
	if(EPlayerSlot(slot.Slot) == EPlayerSlot_UserDefine) return true;
	if(EPlayerSlot(slot.Slot) == EPlayerSlot_Human && (user.mSlotState == EPlayerSlotState_Occupied || user.mSlotState == EPlayerSlotState_Open)) return true;
	if(EPlayerSlot(slot.Slot) == EPlayerSlot_AI && user.mSlotState == EPlayerSlotState_AI) return true;
	return false;
}

function bool NoOneElseHasPosition(int playerIndex,EStartPosition pos)
{
	return true; // checked in CanStartSkirmish
}

function AddEntry(out array<H7DropDownEntry> list,string caption,int data,optional bool enabled=true,optional string strData="",optional string icon)
{
	local H7DropDownEntry entry;
	entry.Caption = caption;
	entry.Data = data;
	entry.Enabled = enabled;
	entry.StrData = strData;
	entry.Icon = icon;
	entry.Color = "-1";
	list.AddItem(entry);
}

function array<H7DropDownEntry> GetColorEnumList()
{
	local H7DropDownEntry entry;
	local array<H7DropDownEntry> list;
	local array<EPlayerColor> skirmishColors;
	local int i;
	//local Name enumName;

	skirmishColors = class'H7GameUtility'.static.GetSkirmishColors();

	for(i=0;i<skirmishColors.Length;i++)
	{
		//enumName = GetEnum(Enum'EPlayerColor', i);
		entry.Caption = "";//String(enumName);
		entry.Data = skirmishColors[i];
		entry.Icon = "img://H7TextureGUI.GUI_Unit_Background";
		entry.Color = UnrealColorToFlashColor(class'H7GameUtility'.static.GetColor(skirmishColors[i]));
		list.AddItem(entry);
	}
	return list;
}

function array<H7DropDownEntry> GetVictoryConditionEnumList()
{
	local H7DropDownEntry entry;
	local array<H7DropDownEntry> list;
	local int vicCond;
	local EVictoryCondition vicCondEnum;
	local array<int> vicConds;

	vicConds = class'H7ReplicationInfo'.static.GetInstance().GetMapHeader().AdventureMapData.mAvailableVictoryConditions;
	
	if(vicConds.Find(E_H7_VC_DEFAULT) == INDEX_NONE) // scenarios have noting, so we need to add default
	{
		vicConds.AddItem(E_H7_VC_DEFAULT);
	}

	if(class'H7ReplicationInfo'.static.GetInstance().GetMapHeader().AdventureMapData.mWinConditionType == EGameWinConditionType_Standard) // if map setting is standard
	{
		vicConds.RemoveItem(E_H7_VC_STANDARD); // remove standard from base list
	}
	
	foreach vicConds(vicCond)
	{
		vicCondEnum = EVictoryCondition(vicCond);
		entry.Caption = String(vicCondEnum);
		entry.Data = vicCond;
		list.AddItem(entry);
	}

	return list;	
}

function array<H7DropDownEntry> GetEnumListByObject(int enumMax,Object enumObject) 
{
	local H7DropDownEntry entry;
	local array<H7DropDownEntry> list;
	local int i;
	local Name enumName;

	for(i=0;i<enumMax;i++)
	{
		enumName = GetEnum(enumObject, i);
		entry.Caption = String(enumName);
		entry.Data = i;
		list.AddItem(entry);
	}
	return list;
}

function array<H7DropDownEntry> GetFactionEnumList(int playerIndex)
{
	local array<H7DropDownEntry> list;
	local array<H7Faction> factions;
	local H7Faction faction;
	local array<H7Faction> privilegeFactions;
	local bool enabledFaction, isHostAISlot;

	class'H7GameData'.static.GetInstance().GetFactions(factions, true);
	class'H7GameData'.static.GetInstance().GetFactions(privilegeFactions);
	foreach factions(faction)
	{
		if(class'H7ReplicationInfo'.static.GetInstance().GetMapHeaderPlayerInfoByLobbyPlayerIndex(playerIndex).ForbiddenFactions.Find(faction.GetArchetypeID()) == INDEX_NONE)
		{
			enabledFaction = true;
			isHostAISlot = class'H7PlayerController'.static.GetPlayerController().IsServer() && class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mSlotState == EPlayerSlotState_AI;
			if(!mIsMultiplayer || isHostAISlot || playerIndex == class'H7ReplicationInfo'.static.GetInstance().GetMyPlayerIndex() )
			{
				enabledFaction = privilegeFactions.Find(faction) != INDEX_NONE;
			}
			AddEntry(list,faction.GetName(),0,enabledFaction,faction.GetArchetypeID(),faction.GetFactionColorIconPath());
		}
	}

	if(list.Length > 1)
	{
		AddEntry(list,class'H7GameData'.static.GetInstance().GetRandomFaction().GetName(),0,true,class'H7GameData'.static.GetInstance().GetRandomFaction().GetArchetypeID(),class'H7GameData'.static.GetInstance().GetRandomFaction().GetFactionColorIconPath());
	}

	if(list.Length == 0)
	{
		// add dummy entry for empty list
		AddEntry(list,"-",-1);
	}

	return list;
}
function array<H7DropDownEntry> GetBonusEnumList(int playerIndex)
{
	local array<H7DropDownEntry> list;
	AddEntry(list,"BONUS_NONE",0); // TODO
	return list;
}
function array<String> GetHeroesEnumList(int playerIndex, optional bool showHeroSelectionPopUp = false, optional H7Faction faction = none)
{
	local array<String> list;
	local int i;
	local H7EditorHero hero;
	local array<H7EditorHero> heroPool;
	local array<H7EditorHero> privilegeHeroes;
	local array<H7EditorHero> exclusiveSkirmishHeroes;
	local array<H7EditorHero> randomHeroesPool;


	// if player has a specific position and that position has no PlayerStart
	if(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mPosition != START_POSITION_RANDOM 
		&& !class'H7ReplicationInfo'.static.GetInstance().GetMapHeaderPlayerInfoByLobbyPlayerIndex(playerIndex).PlayerStartAvailable)
	{
		//add no hero
		//AddEntry(list,"HERO_NONE",0,true,"None");
	}
	else // hero has random position or specific position with PlayerStart
	{
		// get hero pool
		class'H7GameData'.static.GetInstance().GetHeroes(heroPool);

		if(IsSkirmish())
		{
			class'H7GameData'.static.GetInstance().GetExclusiveHeroesSkirmish(exclusiveSkirmishHeroes);
		}

		class'H7GameData'.static.GetInstance().GetPrivilegHeroesSkirmish(privilegeHeroes);
		class'H7GameData'.static.GetInstance().GetRandomHeroes(randomHeroesPool);

		//merge lists
		ForEach randomHeroesPool(hero)
			heroPool.AddItem(hero);

		heroPool.AddItem(class'H7GameData'.static.GetInstance().GetRandomHero());

		ForEach exclusiveSkirmishHeroes(hero)
			heroPool.AddItem(hero);

		ForEach privilegeHeroes(hero)
			heroPool.AddItem(hero);

		for(i = 0; i < heroPool.Length; i++)
		{
			hero = heroPool[i];
			if( // random position can have all heroes of that faction, specific position excludes forbidden heroes
				class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mPosition == START_POSITION_RANDOM ||
				class'H7ReplicationInfo'.static.GetInstance().GetMapHeaderPlayerInfoByLobbyPlayerIndex(playerIndex).ForbiddenHeroes.Find(hero.GetArchetypeID()) == INDEX_NONE
			   )
			{
				//if a faction was passed as argument, then check if the hero matches the faction...
				if(faction != none)
				{
					if(faction == hero.GetFaction())
					{
						list.AddItem(hero.GetArchetypeID());
						;
					}
				}
				else // ...else if no faction was passed then just add the hero
				{
					list.AddItem(hero.GetArchetypeID());
					;
				}

				
			}
		}
		// TODO add solmir
	}
	
	if(showHeroSelectionPopUp)
	{
		;
		mHeroSelection.Update(list, 
			                  playerIndex, 
			                  class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mStartHero.GetArchetypeID(), 
			                  class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mColor
			                  );
	}
	return list;
}

function GetHeroInfo(string heroArchetypeID)
{
	local array<H7EditorHero> heroes;
	local array<H7EditorHero> privilegeHeroes;
	local array<H7EditorHero> exclusiveSkirmishHeroes;
	local H7EditorHero hero;

	class'H7GameData'.static.GetInstance().GetHeroes(heroes, true);
	class'H7GameData'.static.GetInstance().GetPrivilegHeroesSkirmish(privilegeHeroes, true);
	class'H7GameData'.static.GetInstance().GetExclusiveHeroesSkirmish(exclusiveSkirmishHeroes, true);

	ForEach privilegeHeroes(hero)
		heroes.AddItem(hero);

	ForEach exclusiveSkirmishHeroes(hero)
		heroes.AddItem(hero);

	foreach heroes(hero)
	{
		if(hero.GetArchetypeID() == heroArchetypeID)
		{
			hero.SetCurrentMana(hero.GetMaxManaBase());
			mHeroSelection.UpdateHeroInfo(hero);
			return;
		}
	}
}

// GUI:
// data 0 = closed
// data 1 = open || hotseat-human || real-human
// data 2 = ai easy
// data 3 = ai normal
// data 4 = ai hard
// data 5 = ai heroic
// Gameplay:
// 0 = undefined = undefined
// 1 = closed    = closed
// 2 = open      = open || hotseat-human
// 3 = occupied  = real-human
// 4 = AI         0 easy
//                1 normal 
//                2 hard
//                3 heroic
function array<H7DropDownEntry> GetSlotEnumList(int playerIndex)
{
	local array<H7DropDownEntry> list;
	local bool closable;

	closable = true;
	if(IsScenario() || mIsLoadedGame) closable = false; // you can not close slots in loaded games, also can not close slots in scenarios
	if(playerIndex == 0) closable = false; // host can never be closed

	// but already closed slots are closable, to be selectable
	AddEntry(list,"CLOSED",0,closable || class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mSlotState == EPlayerSlotState_Closed);

	;
	;
	//`log_dui("  map(position):" @ class'H7ReplicationInfo'.static.GetInstance().GetMapHeaderPlayerInfoByLobbyPlayerIndex(playerIndex).Slot @ class'H7ReplicationInfo'.static.GetInstance().GetMapHeaderPlayerInfoByLobbyPlayerIndex(playerIndex).Name.);

	// there can be a human here
	if(class'H7ReplicationInfo'.static.GetInstance().GetMapHeaderPlayerInfoByLobbyPlayerIndex(playerIndex).Slot == EPlayerSlot_Human 
		|| class'H7ReplicationInfo'.static.GetInstance().GetMapHeaderPlayerInfoByLobbyPlayerIndex(playerIndex).Slot == EPlayerSlot_UserDefine)
	{
		if(class'H7ReplicationInfo'.static.GetInstance().IsMultiplayerGame())
		{
			// if there is a human here, show his name
			if(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mSlotState == EPlayerSlotState_Occupied) 
			{
				AddEntry(list,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mName,1);
			}
			else
			{
				// you can not open slots in loaded games (but already existing slots can be)
				AddEntry(list,"OPEN",1,!mIsLoadedGame || class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mSlotState != EPlayerSlotState_Closed);
			}
		}
		else
		{
			if(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mSlotState == EPlayerSlotState_Occupied) // human host is here (sp+hotseat)
			{
				AddEntry(list,"HUMAN",1,true);
			}
			else
			{
				AddEntry(list,"HUMAN",1,true);
			}
		}
	}
	else
	{
		AddEntry(list,"OPEN",1,false);
	}

	// there can be a AI here
	if((class'H7ReplicationInfo'.static.GetInstance().GetMapHeaderPlayerInfoByLobbyPlayerIndex(playerIndex).Slot == EPlayerSlot_AI 
		|| class'H7ReplicationInfo'.static.GetInstance().GetMapHeaderPlayerInfoByLobbyPlayerIndex(playerIndex).Slot == EPlayerSlot_UserDefine)
		&& playerIndex != 0)
	{
		// it's possible to have an AI here
		AddEntry(list,"AI_DIFFICULTY_EASY",2);
		AddEntry(list,"AI_DIFFICULTY_NORMAL",3);
		AddEntry(list,"AI_DIFFICULTY_HARD",4);
		AddEntry(list,"AI_DIFFICULTY_HEROIC",5);
	}
	return list;
}

//////////////////////////////////////////////////////////////////////////////////////////////7
// SINGLE PLAYER ROW CHANGES
//////////////////////////////////////////////////////////////////////////////////////////////7

function DisplayPlayerSettings(int playerIndex, PlayerLobbySelectedSettings playerData)
{
	mSkirmishSetup.DisplayPlayerSettings(playerIndex,playerData);
	//playerData.mSlot,playerData.mName,
	//	playerData.mColor,playerData.mPosition,playerData.mTeam,playerData.mFaction.GetArchetypeID(),playerData.mStartHero.GetArchetypeID(),playerData.mStartBonusIndex,playerData.mIsReady);
	CheckStartConditions();
}

// slotType 0=closed, 1=open/player, 2,3,4=ai
function SetPlayerSlot(int playerIndex,int slotType)
{
	local array<H7DropDownEntry> list;

	;
    if( class'H7PlayerController'.static.GetPlayerController().IsServer() )
	{
		if(slotType == 0) 
		{
			if(playerIndex == 0)
			{
				;
			}
			else
			{
				if( class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mSlotState == EPlayerSlotState_Occupied )
				{
					KickPlayerPopup( playerIndex , KickCloseDone );
				}
				else // open to close
				{
					class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mSlotState = EPlayerSlotState_Closed;
				}
			}
		}
		else if(slotType == 1) // if needed && class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mSlotState == EPlayerSlotState_Closed) 
		{
			class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mSlotState = EPlayerSlotState_Open;
			class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mIsReady = false;
		}
		else // set it to AI
		{
			if( class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mSlotState == EPlayerSlotState_Occupied )
			{
				mPendingKickAI = EAIDifficulty(slotType-2);
				KickPlayerPopup( playerIndex , KickAIDone );
			}
			else // "open" changed to "AI"
			{
				class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mAIDifficulty = EAIDifficulty(slotType-2);
				class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mSlotState = EPlayerSlotState_AI;
			}
		}
		class'H7ReplicationInfo'.static.GetInstance().LobbyUpdateOnlineGameSettingsSlots();
	}
	else
	{
		;
	}
	

	// refresh position and position option list
	list = GetPositionEnumList(playerIndex);
	SetNewList("mDropPosition",list,playerIndex);
	FixPositions();
	SetNewList("mDropFaction",GetEnumList("EFaction",playerIndex),playerIndex);
	// TODO FixColors(); if opened
	
	DisplayPlayerSettings(playerIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex]);
}

function SetPlayerColor(int playerIndex, int selectedColorEnum)
{
	local EPlayerColor selectecdColor;
	local int i;

	if( class'H7PlayerController'.static.GetPlayerController().IsServer() )
	{
		// who has this color?
		selectecdColor = EPlayerColor(selectedColorEnum);
		for(i=0;i<8;i++)
		{
			if(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mColor == selectecdColor)
			{
				class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mColor = class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mColor;
				DisplayPlayerSettings(i,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i]);
			}
		}
		class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mColor = selectecdColor;
		DisplayPlayerSettings(playerIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex]);
	}
	else
	{
		class'H7PlayerController'.static.GetPlayerController().ServerLobbySetPlayerColor( playerIndex, selectedColorEnum );
	}
}

// server-flash or clients change position 
function SetPlayerPosition(int playerIndex, int position)
{
	if( class'H7PlayerController'.static.GetPlayerController().IsServer() )
	{
		class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mPosition = EStartPosition( position );

		FixSlotSetting(playerIndex);
		FixFactionSetting(playerIndex);
		FixHeroSetting(playerIndex);
		FixPositions();

		DisplayPlayerSettings(playerIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex]);
	}
	else
	{
		class'H7PlayerController'.static.GetPlayerController().ServerLobbySetPlayerPosition( playerIndex, position );
	}
}

function FixSlotSetting(int playerIndex)
{
	SetNewList("mDropSlot",GetEnumList("ESlot",playerIndex),playerIndex);
}

function FixPositions()
{
	local int i,j;
	local EStartPosition position;
	local array<H7DropDownEntry> list;
	local H7DropDownEntry firstLegalOption;
	local bool optionIsLegal;

	for(i=0;i<8;i++)
	{
		list = GetPositionEnumList(i);
		//SetNewList("mDropPosition",list,i); // too costly
		position = class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mPosition;
		for(j=0;j<list.Length;j++)
		{
			optionIsLegal = false;
			if(list[j].Data == position && list[j].Enabled) 
			{
				optionIsLegal = true;
				break;
			}
		}
		if(!optionIsLegal)
		{
			if(GetFirstLegalOption(list,firstLegalOption))
			{
				;
				class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mPosition = EStartPosition(firstLegalOption.Data);
			}
			else
			{
				;
				class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mPosition = -1;
			}
			DisplayPlayerSettings(i,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i]);
		}
	}
}

function bool GetFirstLegalOption(array<H7DropDownEntry> list,out H7DropDownEntry firstLegalOption)
{
	local int i;
	for(i=0;i<list.Length;i++)
	{
		if(list[i].Enabled) 
		{
			firstLegalOption = list[i];
			return true;
		}
	}
	return false;
}

function FixFactionSetting(int playerIndex)
{
	local H7Faction is;
	local array<H7DropDownEntry> list; 
	local int i;

	// is:
	is = class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mFaction;
	// can be:
	list = GetEnumList("EFaction",playerIndex);
	
	for(i=0;i<list.Length;i++)
	{
		if(list[i].StrData == is.GetArchetypeID())
		{
			return;
		}
	}
	// not found, change to first one
	;
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mFaction = class'H7GameData'.static.GetInstance().GetFactionByArchetypeID(list[0].StrData);
	if( !class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() )
	{
		class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mFactionRef = list[0].StrData;
	}
	;
	// should cause automatic list update in server and client
}

function FixHeroSetting(int playerIndex)
{
	local H7EditorHero selectedHero;
	local H7Faction selectedFaction;
	local array<H7EditorHero> randomHeroesPool;
	local int i;

	// is:
	selectedHero = class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mStartHero; // mPlayerSettings[i].mStartHero.GetArchetypeID()
	selectedFaction = class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mFaction;
	
	if( selectedHero != none && selectedFaction == selectedHero.GetFaction() )
		return;
	
	class'H7GameData'.static.GetInstance().GetRandomHeroes(randomHeroesPool, true);

	for(i=0; i<randomHeroesPool.Length; i++)
	{
		if(randomHeroesPool[i].GetFaction() == selectedFaction)
		{
			class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mStartHero = randomHeroesPool[i];

			if( !class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() )
			{
				class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mStartHeroRef = Pathname(randomHeroesPool[i].GetOriginArchetype());
			}

			break;
		}
	}		
	
	if(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mStartHero != none)
	{
		;
	}
	else
	{
		;
	}
	// should cause automatic list update in server and client
}

function SetPlayerTeam(int playerIndex, int teamEnum)
{
	if( class'H7PlayerController'.static.GetPlayerController().IsServer() )
	{
		class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mTeam = ETeamNumber(teamEnum);
		DisplayPlayerSettings(playerIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex]);
	}
	else
	{
		class'H7PlayerController'.static.GetPlayerController().ServerLobbySetPlayerTeam( playerIndex, teamEnum );
	}
}

function SetPlayerFaction(int playerIndex, string factionArchetypeID)
{
	;
	if( class'H7PlayerController'.static.GetPlayerController().IsServer() )
	{
		class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mFaction = class'H7GameData'.static.GetInstance().GetFactionByArchetypeID( factionArchetypeID );
		if( !class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() )
		{
			class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mFactionRef = factionArchetypeID;
		}

		if( factionArchetypeID == class'H7GameData'.static.GetInstance().GetRandomFaction().GetArchetypeID() )
		{
			SetPlayerHero( playerIndex, class'H7GameData'.static.GetInstance().GetRandomHero().GetArchetypeID() );
		}
		
		FixHeroSetting(playerIndex);

		DisplayPlayerSettings(playerIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex]);
	}
	else
	{
		class'H7PlayerController'.static.GetPlayerController().ServerLobbySetPlayerFaction( playerIndex, factionArchetypeID );
	}
}

function SetPlayerHero(int playerIndex, string heroArchetypeID)
{
	;
	if( class'H7PlayerController'.static.GetPlayerController().IsServer() )
	{
		class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mStartHero = class'H7GameData'.static.GetInstance().GetHeroByArchetypeID( heroArchetypeID );
		if( !class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() )
		{
			class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mStartHeroRef = Pathname(class'H7GameData'.static.GetInstance().GetHeroByArchetypeID( heroArchetypeID ));
		}
		class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mFaction = class'H7GameData'.static.GetInstance().GetHeroByArchetypeID( heroArchetypeID ).GetFaction();
		DisplayPlayerSettings(playerIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex]);
	}
	else
	{
		class'H7PlayerController'.static.GetPlayerController().ServerLobbySetPlayerHero( playerIndex, heroArchetypeID );
	}
}

function SetPlayerStartBonus(int playerIndex, int bonusIndex)
{
	if( class'H7PlayerController'.static.GetPlayerController().IsServer() )
	{
		class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mStartBonusIndex = bonusIndex;
		DisplayPlayerSettings(playerIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex]);
	}
	else
	{
		class'H7PlayerController'.static.GetPlayerController().ServerLobbySetPlayerStartBonus( playerIndex, bonusIndex );
	}
}

function SetPlayerReady(int playerIndex, bool isReady)
{
	if( class'H7PlayerController'.static.GetPlayerController().IsServer() )
	{
		class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mIsReady = isReady;
		DisplayPlayerSettings(playerIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex]);
	}
	else
	{
		class'H7PlayerController'.static.GetPlayerController().SendPlayerReady( playerIndex, isReady );
	}
}

function KickPlayer(int playerIndex) // flash button pressed
{
	if(playerIndex == 0)
	{
		;
		return;
	}
	if( class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mSlotState == EPlayerSlotState_Occupied )
	{
		class'H7ReplicationInfo'.static.PrintLogMessage("KickPlayer" @ playerIndex @ class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mName, 0);;
		KickPlayerPopup( playerIndex , KickDone);
	}
}

function KickPlayerPopup(int playerIndex, delegate<OnKickDoneDelegate> callback)
{
	mPendingKickPlayerIndex = playerIndex;
	OnKickDoneDelegate = callback;
	class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().YesNoPopup(
		Repl(class'H7Loca'.static.LocalizeSave("KICK_CONFIRM","H7SkirmishSetup"),"%name",class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex].mName)
		,"YES","CANCEL",KickConfirm,none,true
	);
}

function KickConfirm()
{
	class'H7GameInfo'.static.GetH7GameInfoInstance().Kick( class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[mPendingKickPlayerIndex].mName );
	OnKickDoneDelegate();
}

function KickCloseDone()
{
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[mPendingKickPlayerIndex].mSlotState = EPlayerSlotState_Closed;
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[mPendingKickPlayerIndex].mIsReady = false;
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[mPendingKickPlayerIndex].mName = "";
	class'H7ReplicationInfo'.static.GetInstance().LobbyUpdateOnlineGameSettingsSlots();
	UpdateAfterPlayerLeaving( mPendingKickPlayerIndex );
}

function KickAIDone()
{
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[mPendingKickPlayerIndex].mSlotState = EPlayerSlotState_AI;
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[mPendingKickPlayerIndex].mAIDifficulty = mPendingKickAI;
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[mPendingKickPlayerIndex].mIsReady = true;
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[mPendingKickPlayerIndex].mName = "";
	class'H7ReplicationInfo'.static.GetInstance().LobbyUpdateOnlineGameSettingsSlots();
	UpdateAfterPlayerLeaving( mPendingKickPlayerIndex );
	SetNewList("mDropFaction",GetEnumList("EFaction",mPendingKickPlayerIndex),mPendingKickPlayerIndex);
}

function KickDone()
{
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[mPendingKickPlayerIndex].mSlotState = EPlayerSlotState_Open;
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[mPendingKickPlayerIndex].mIsReady = false;
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[mPendingKickPlayerIndex].mName = "";
	class'H7ReplicationInfo'.static.GetInstance().LobbyUpdateOnlineGameSettingsSlots();
	UpdateAfterPlayerLeaving( mPendingKickPlayerIndex );
}

function UpdateAfterPlayerLeaving( int playerIndex )
{
	SetNewList("mDropSlot",GetEnumList("ESlot",playerIndex),playerIndex);
	DisplayPlayerSettings(playerIndex,class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[playerIndex]);
	class'H7MultiplayerGameManager'.static.GetInstance().RemovePrivilegesOfPlayerIndex(playerIndex);
}

//////////////////////////////////////////////////////////////////////////////////////////////7
// MAP SETTING CHANGES
//////////////////////////////////////////////////////////////////////////////////////////////7

function DisplayMapSettings( out H7LobbyDataMapSettings mapSettings)
{
	local string vicDesc,baseText,locaKey,addionalLine;
	local int i;
	local H7MapData mapData;
	local EGameWinConditionType winCon;

	mapData = class'H7ReplicationInfo'.static.GetInstance().GetMapHeader().AdventureMapData;
		
	if(mapSettings.mVictoryCondition == E_H7_VC_DEFAULT) // use the victory condition the map-maker set up
	{
		winCon = EGameWinConditionType(mapData.mWinConditionType);
		locaKey =  Caps(string(winCon)) $ "_PARAM";
		baseText = class'H7Loca'.static.LocalizeSave(locaKey,"H7SkirmishSetup");
		switch(winCon)
		{
			case EGameWinConditionType_Standard:
				break;
			case EGameWinConditionType_AcquireArtifact:
				baseText = Repl(baseText, "%item", class'H7Loca'.static.LocalizeFieldParams(mapData.mWinConditionArtifactToAcquire));
				break;
			case EGameWinConditionType_AccumulateCreatures:
				baseText = Repl(baseText, "%creature", class'H7Loca'.static.LocalizeFieldParams(mapData.mWinConditionAccumulateCreatureTier));
				baseText = Repl(baseText,"%amount",mapData.mWinConditionAccumulateCreatureAmount);
				break;
			case EGameWinConditionType_AccumulateResources:
				for(i=0;i<mapData.mWinConditionResourcesToCollect.Length;i++)
				{
					addionalLine = class'H7Loca'.static.LocalizeSave(locaKey $ "_LINE","H7SkirmishSetup");
					addionalLine = Repl(addionalLine, "%resource", class'H7Loca'.static.LocalizeFieldParams(mapData.mWinConditionResourcesToCollect[i].Type));
					addionalLine = Repl(addionalLine,"%amount",mapData.mWinConditionResourcesToCollect[i].Quantity);
					baseText = baseText $ "\n" $ addionalLine; // OPTIONAL scroller in flash in case it gets too long, but should be ok with ... and tooltip
				}
				break;
			case EGameWinConditionType_TearOfAsha:
				break;
			case EGameWinConditionType_DefeatHero:
				baseText = Repl(baseText, "%hero", class'H7Loca'.static.LocalizeFieldParams(mapData.mWinConditionHeroToDefeat));
				break;
			case EGameWinConditionType_CaptureTown:
				baseText = Repl(baseText, "%town", class'H7Loca'.static.LocalizeFieldParams(mapData.mWinConditionTownToCapture));
				break;
			case EGameWinConditionType_DefeatArmy:
				baseText = Repl(baseText, "%army", class'H7Loca'.static.LocalizeFieldParams(mapData.mWinConditionArmyToDefeat));
				break;
			case EGameWinConditionType_ControlAllForts:
				break;
			case EGameWinConditionType_ControlAllMines:
				break;
			case EGameWinConditionType_TransportArtifact:
				baseText = Repl(baseText, "%item", class'H7Loca'.static.LocalizeFieldParams(mapData.mWinConditionArtifactToTransfer));
				baseText = Repl(baseText, "%town", class'H7Loca'.static.LocalizeFieldParams(mapData.mWinConditionArtifactTransferTown));
				break;
			case EGameWinConditionType_UserDefined:
				break;
			case EGameWinConditionType_Disabled:
				break;
		}
		vicDesc = baseText;
	}
	else
	{
		vicDesc = class'H7Loca'.static.LocalizeSave(string(mapSettings.mVictoryCondition) $ "_DESC","H7SkirmishSetup");
	}

	mSkirmishSetup.SetThumbnail(mMapThumbnail);

	if(mapData.mIsThumbnailDataAvailable)
	{
		;
		mMapThumbnail.SwitchStreamingTo(class'H7ReplicationInfo'.static.GetInstance().GetMapHeader().Filename, mapData.mThumbnailData, i);
		GetHUD().SetFrameTimer(1, updateThumbnail);
		mSkirmishSetup.ShowThumbnail();
	}
	else
	{
		;
		mSkirmishSetup.HideThumbnail();
	}

	mSkirmishSetup.DisplayMapSettings(mapSettings.mVictoryCondition,mapSettings.mCanUseStartBonus,mapSettings.mTeamSetup,mapSettings.mUseRandomStartPosition,vicDesc);
	CheckStartConditions();
}

function updateThumbnail()
{
	mMapThumbnail.PerformUpdate();
	GetHUD().SetFrameTimer(1, updateThumbnail);
}

function SetVictoryCondition(int index,int victoryConditionEnum)
{
	local H7OnlineGameSettings onlineSettings;

	if(!class'H7PlayerController'.static.GetPlayerController().IsServer()) return;

	onlineSettings = class'H7MultiplayerGameManager'.static.GetOnlineGameSettings();
	if( onlineSettings != none )
	{
		onlineSettings.SetVictoryCondition( EVictoryCondition(victoryConditionEnum) );

		if( !onlineSettings.bIsLanMatch )
		{
			class'GameEngine'.static.GetOnlineSubsystem().GameInterface.UpdateOnlineGame( 'H7GameSession', onlineSettings, true );
		}
	}

	//EVictoryCondition
	;
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mMapSettings.mVictoryCondition = EVictoryCondition(victoryConditionEnum);
	DisplayMapSettings(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mMapSettings);
}

function SetStartBonus(int index,int fromMap)
{
	if(!class'H7PlayerController'.static.GetPlayerController().IsServer()) return;
	//bool
	;
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mMapSettings.mCanUseStartBonus = fromMap==1;
	DisplayMapSettings(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mMapSettings);
}

function SetStartPositions(int index,int random)
{
	local int i;
	local H7OnlineGameSettings onlineSettings;

	if(!class'H7PlayerController'.static.GetPlayerController().IsServer()) return;

	onlineSettings = class'H7MultiplayerGameManager'.static.GetOnlineGameSettings();
	if( onlineSettings != none )
	{
		onlineSettings.SetUseRandomStartPosition( random==1 );

		if( !onlineSettings.bIsLanMatch )
		{
			class'GameEngine'.static.GetOnlineSubsystem().GameInterface.UpdateOnlineGame( 'H7GameSession', onlineSettings, true );
		}
	}

	//bool
	;
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mMapSettings.mUseRandomStartPosition = random==1;
	DisplayMapSettings(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mMapSettings);

	// special handling, change all positions of all players
	if(random==1)
	{
		for(i=0;i<8;i++)
		{
			class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mPosition = START_POSITION_RANDOM;
		}
	}
	else // custom
	{
		for(i=0;i<8;i++)
		{
			class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mPosition = EStartPosition(i+1);
		}
	}

	DisplayAllPlayerSettings();
}

function SetTeam(int index,int teamEnum)
{
	local int i;
	local H7OnlineGameSettings onlineSettings;

	if(!class'H7PlayerController'.static.GetPlayerController().IsServer()) return;

	onlineSettings = class'H7MultiplayerGameManager'.static.GetOnlineGameSettings();
	if( onlineSettings != none )
	{
		onlineSettings.SetTeamSetup( ETeamSetup(teamEnum) );

		if( !onlineSettings.bIsLanMatch )
		{
			class'GameEngine'.static.GetOnlineSubsystem().GameInterface.UpdateOnlineGame( 'H7GameSession', onlineSettings, true );
		}
	}

	//ETeamSetup
	;
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mMapSettings.mTeamSetup = ETeamSetup(teamEnum);
	DisplayMapSettings(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mMapSettings);

	// special handling, change all teams of all players
	if(ETeamSetup(teamEnum) == TEAM_NO_TEAMS)
	{
		for(i=0;i<8;i++)
		{
			class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mTeam = TN_NO_TEAM;
		}
	}
	else if(ETeamSetup(teamEnum) == TEAM_MAP_DEFAULT)
	{
		for(i=0;i<8;i++)
		{
			class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mTeam = ETeamNumber(class'H7ReplicationInfo'.static.GetInstance().GetMapHeader().AdventureMapData.mPlayerInfoProperties[i].Team);
		}
	}
	else if(ETeamSetup(teamEnum) == TEAM_CUSTOM)
	{
		for(i=0;i<8;i++)
		{
			class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mTeam = ETeamNumber(i+1);
		}
	}

	DisplayAllPlayerSettings();
}

//////////////////////////////////////////////////////////////////////////////////////////////7
// GAME SETTING CHANGES
//////////////////////////////////////////////////////////////////////////////////////////////7

function RequestGameSettings()
{
	DisplayGameSettings(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mGameSettings);
}

function DisplayGameSettings(out H7LobbyDataGameSettings gameSettings) // TODO spectator mode
{
	mSkirmishSetup.DisplayGameSettings(gameSettings);
	//mSkirmishSetup.DisplayGameSettings(gameSettings.mSimTurns,gameSettings.mForceQuickCombat,gameSettings.mUseRandomSkillSystem,gameSettings.mTeamsCanTrade,gameSettings.mDifficulty
	//	,gameSettings.mTimerAdv,gameSettings.mTimerCombat
	//	,);
	CheckStartConditions();
}

function SetSpeedAdv(float val)
{
	local H7OnlineGameSettings onlineSettings;

	;
	val = float(int(val*100))/100.f; 
	;

	onlineSettings = class'H7MultiplayerGameManager'.static.GetOnlineGameSettings();
	if( onlineSettings != none )
	{
		onlineSettings.SetGameSpeedAdventure( val );

		if( !onlineSettings.bIsLanMatch )
		{
			class'GameEngine'.static.GetOnlineSubsystem().GameInterface.UpdateOnlineGame( 'H7GameSession', onlineSettings, true );
		}
	}

	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mGameSettings.mGameSpeedAdventure = val;
	;
}

function SetSpeedCombat(float val)
{
	local H7OnlineGameSettings onlineSettings;

	val = float(int(val*100))/100.f;

	onlineSettings = class'H7MultiplayerGameManager'.static.GetOnlineGameSettings();
	if( onlineSettings != none )
	{
		onlineSettings.SetGameSpeedCombat( val );

		if( !onlineSettings.bIsLanMatch )
		{
			class'GameEngine'.static.GetOnlineSubsystem().GameInterface.UpdateOnlineGame( 'H7GameSession', onlineSettings, true );
		}
	}

	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mGameSettings.mGameSpeedCombat = val;
}

function SetSpeedAI(float val)
{
	local H7OnlineGameSettings onlineSettings;

	val = float(int(val*100))/100.f;

	onlineSettings = class'H7MultiplayerGameManager'.static.GetOnlineGameSettings();
	if( onlineSettings != none )
	{
		onlineSettings.SetGameSpeedAdventureAI( val );

		if( !onlineSettings.bIsLanMatch )
		{
			class'GameEngine'.static.GetOnlineSubsystem().GameInterface.UpdateOnlineGame( 'H7GameSession', onlineSettings, true );
		}
	}

	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mGameSettings.mGameSpeedAdventureAI = val;
}

function SetTurnType(int index,int value)
{
	local H7OnlineGameSettings onlineSettings;

	onlineSettings = class'H7MultiplayerGameManager'.static.GetOnlineGameSettings();
	if( onlineSettings != none )
	{
		onlineSettings.SetTurnType( value );

		if( !onlineSettings.bIsLanMatch )
		{
			class'GameEngine'.static.GetOnlineSubsystem().GameInterface.UpdateOnlineGame( 'H7GameSession', onlineSettings, true );
		}
	}

	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mGameSettings.mSimTurns = value==1;
}

function SetQuickCombat(int index,int value)
{
	local H7OnlineGameSettings onlineSettings;

	onlineSettings = class'H7MultiplayerGameManager'.static.GetOnlineGameSettings();
	if( onlineSettings != none )
	{
		onlineSettings.SetForceQuickCombat( EForceQuickCombat(value) );

		if( !onlineSettings.bIsLanMatch )
		{
			class'GameEngine'.static.GetOnlineSubsystem().GameInterface.UpdateOnlineGame( 'H7GameSession', onlineSettings, true );
		}
	}

	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mGameSettings.mForceQuickCombat = EForceQuickCombat(value);
}

function SetSkillType(int index,int value)
{
	local H7OnlineGameSettings onlineSettings;

	onlineSettings = class'H7MultiplayerGameManager'.static.GetOnlineGameSettings();
	if( onlineSettings != none )
	{
		onlineSettings.SetSkillType( value );

		if( !onlineSettings.bIsLanMatch )
		{
			class'GameEngine'.static.GetOnlineSubsystem().GameInterface.UpdateOnlineGame( 'H7GameSession', onlineSettings, true );
		}
	}

	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mGameSettings.mUseRandomSkillSystem = value==1;
}

function SetSpectatorMode(int index,int data)
{
	;
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mGameSettings.mSpectatorMode = data==0;
}

function SetTeamTrade(int index,int value)
{
	local H7OnlineGameSettings onlineSettings;

	onlineSettings = class'H7MultiplayerGameManager'.static.GetOnlineGameSettings();
	if( onlineSettings != none )
	{
		onlineSettings.SetTeamsCanTrade( value==1 );

		if( !onlineSettings.bIsLanMatch )
		{
			class'GameEngine'.static.GetOnlineSubsystem().GameInterface.UpdateOnlineGame( 'H7GameSession', onlineSettings, true );
		}
	}

	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mGameSettings.mTeamsCanTrade = value==1;
}

function SetDifficulty(int index,int value)
{
	local EDifficulty difficulty;
	local H7DifficultyParameters difParams;
	local H7OnlineGameSettings onlineSettings;

	onlineSettings = class'H7MultiplayerGameManager'.static.GetOnlineGameSettings();
	if( onlineSettings != none )
	{
		onlineSettings.SetDifficulty( EDifficulty(value) );

		if( !onlineSettings.bIsLanMatch )
		{
			class'GameEngine'.static.GetOnlineSubsystem().GameInterface.UpdateOnlineGame( 'H7GameSession', onlineSettings, true );
		}
	}

	difficulty = EDifficulty(value);
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mGameSettings.mDifficulty = difficulty;
	switch( difficulty )
	{
		case DIFFICULTY_EASY:
			difParams.mStartResources = DSR_ABUNDANCE;
			difParams.mCritterStartSize = DCSS_FEW;
			difParams.mCritterGrowthRate = DCGR_SLOW;
			difParams.mAiEcoStrength = DAIES_POOR;
			break;
		case DIFFICULTY_NORMAL:
			difParams.mStartResources = DSR_AVERAGE;
			difParams.mCritterStartSize = DCSS_AVERAGE;
			difParams.mCritterGrowthRate = DCGR_AVERAGE;
			difParams.mAiEcoStrength = DAIES_AVERAGE;
			break;
		case DIFFICULTY_HARD:
			difParams.mStartResources = DSR_LIMITED;
			difParams.mCritterStartSize = DCSS_MANY;
			difParams.mCritterGrowthRate = DCGR_FAST;
			difParams.mAiEcoStrength = DAIES_PROSPEROUS;
			break;
		case DIFFICULTY_HEROIC:
			difParams.mStartResources = DSR_SHORTAGE;
			difParams.mCritterStartSize = DCSS_HORDES;
			difParams.mCritterGrowthRate = DCGR_PROLIFIC;
			difParams.mAiEcoStrength = DAIES_RICH;
			break;
		case DIFFICULTY_CUSTOM:
			//TODO: open custom difficulty popup
			break;
	}
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mGameSettings.mDifficultyParameters = difParams;
}

function SetCustomDifficulty(string enumName,int value)
{
	local H7OnlineGameSettings onlineSettings;

	onlineSettings = class'H7MultiplayerGameManager'.static.GetOnlineGameSettings();
	if( onlineSettings != none )
	{
		onlineSettings.SetDifficulty( DIFFICULTY_CUSTOM );

		if( !onlineSettings.bIsLanMatch )
		{
			class'GameEngine'.static.GetOnlineSubsystem().GameInterface.UpdateOnlineGame( 'H7GameSession', onlineSettings, true );
		}
	}

	/*var savegame EDifficultyStartResources mStartResources; 
	var savegame EDifficultyCritterStartSize mCritterStartSize; 
	var savegame EDifficultyCritterGrowthRate mCritterGrowthRate;
	var savegame EDifficultyAIEcoStrength mAiEcoStrength; */
	switch(enumName)
	{
		case "EDifficultyStartResources":
			class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mGameSettings.mDifficultyParameters.mStartResources = EDifficultyStartResources(value);
			break;
		case "EDifficultyCritterStartSize":
			class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mGameSettings.mDifficultyParameters.mCritterStartSize = EDifficultyCritterStartSize(value);
			break;
		case "EDifficultyCritterGrowthRate":
			class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mGameSettings.mDifficultyParameters.mCritterGrowthRate = EDifficultyCritterGrowthRate(value);
			break;
		case "EDifficultyAIEcoStrength":
			class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mGameSettings.mDifficultyParameters.mAiEcoStrength = EDifficultyAIEcoStrength(value);
			break;
	}
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mGameSettings.mDifficulty = DIFFICULTY_CUSTOM; // OPTIONAL analysis if other 4 enums
	DisplayGameSettings(class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mGameSettings);
}

function SetAdvTimer(int index,int value)
{
	local H7OnlineGameSettings onlineSettings;

	onlineSettings = class'H7MultiplayerGameManager'.static.GetOnlineGameSettings();
	if( onlineSettings != none )
	{
		onlineSettings.SetTimerAdv( ETimerAdv(value) );

		if( !onlineSettings.bIsLanMatch )
		{
			class'GameEngine'.static.GetOnlineSubsystem().GameInterface.UpdateOnlineGame( 'H7GameSession', onlineSettings, true );
		}
	}
	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mGameSettings.mTimerAdv = ETimerAdv(value);
}

function SetCombatTimer(int index,int value)
{
	local H7OnlineGameSettings onlineSettings;

	onlineSettings = class'H7MultiplayerGameManager'.static.GetOnlineGameSettings();
	if( onlineSettings != none )
	{
		onlineSettings.SetTimerCombat( ETimerCombat(value) );

		if( !onlineSettings.bIsLanMatch )
		{
			class'GameEngine'.static.GetOnlineSubsystem().GameInterface.UpdateOnlineGame( 'H7GameSession', onlineSettings, true );
		}
	}

	class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mGameSettings.mTimerCombat = ETimerCombat(value);
}

//////////////////////////////////////////////////////////////////////////////////////////////7
// START GAME (new)
//////////////////////////////////////////////////////////////////////////////////////////////7

function StartGame()
{   
	local string theURL,mapName;
	local H7ContentScannerAdventureMapData empty;
	local H7ListingSavegameDataScene empty2;
	local array<int> privileges;
	local PrivilegesContainer container;

	class'H7MapSelectCntl'.static.GetInstance().StopScanner(); // since we leave it running while in the lobby, stop it in case it's not yet finished

	WriteLobbyDataToTransitionData();

	//start game here
	mapName = class'H7Loca'.static.GetMapFileNameByPath(class'H7ReplicationInfo'.static.GetInstance().GetMapHeader().Filename);
	;

	//class'H7MainMenuInfo'.static.GetInstance().SelectSkirmish(mapName);
	if( mIsMultiplayer )
	{
		if( mIsLoadedGame )
		{
			class'H7PlayerController'.static.GetPlayerController().LoadGameState( class'H7TransitionData'.static.GetInstance().GetMPLobbySaveDataToUse().SlotIndex, mapName, true );
		}
		else
		{

		}
		// tell clients it's starting
		class'H7PlayerProfile'.static.GetInstance().GetUserPrivileges(privileges, true);
		container.privileges = privileges;
		container.playerIndex = 0;
		class'H7MultiplayerGameManager'.static.GetInstance().AddSharedPrivileges(container);
		class'H7PlayerController'.static.GetPlayerController().SendLobbyStartGame( class'H7ReplicationInfo'.static.GetInstance().mMapHeader.AdventureMapData.mPlayerAmount );

		/** TRACKING **/
		TrackGameStart(true);

		if(class'H7ReplicationInfo'.static.GetInstance().IsLAN())
		{
			theURL = mapName $ "?bIsLanMatch=" $ true $ "?listen";
		}
		else
		{
			theURL = mapName $ "?bIsLanMatch=" $ false $ "?listen?stormsocket";
		}

		if(mIsLoadedGame)
		{
			theURL = theURL $ "?SaveGameState=" $ class'H7TransitionData'.static.GetInstance().GetMPLobbySaveDataToUse().SlotIndex;
		}

		class'H7ReplicationInfo'.static.GetInstance().UpdateOnlineGameStarted();

		// clear the lobby mapdata
		class'H7TransitionData'.static.GetInstance().SetMPLobbyMapDataToCreate(empty);
		class'H7TransitionData'.static.GetInstance().SetMPLobbySaveDataToUse(empty2);

		class'H7MainMenuInfo'.static.GetInstance().HostGame(theURL,true,false);
	}
	else
	{
		/** TRACKING **/
		TrackGameStart(false);
		
		class'H7MainMenuInfo'.static.GetInstance().StartSkirmish(mapName);
	}
}

function WriteLobbyDataToTransitionData()
{
	class'H7ReplicationInfo'.static.GetInstance().WriteLobbyDataToTransitionData( true );
}

function SetNewList(string dropDownName,array<H7DropDownEntry> list,optional int playerIndex=INDEX_NONE,optional bool blockSendingToUnreal)
{
	mSkirmishSetup.SetNewList(dropDownName,list,playerIndex,blockSendingToUnreal);
}

function TrackGameStart(bool online)
{
	OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).PushEvent("UTT_GAMEMODE_START", GetGameType(online), new class'JsonObject'()  );
}

function string GetGameType(bool online)
{
	local EMapType maptype;
	local int i,human;
	

	maptype = EMapType( class'H7ReplicationInfo'.static.GetInstance().GetMapHeader().AdventureMapData.mMapType );
	
	
	for( i=0;i<class'H7ReplicationInfo'.static.GetInstance().mMapHeader.AdventureMapData.mPlayerAmount;++i)
	{
		
		if( !mIsMultiplayer ) 
		{
			if( class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[i].mSlotState == EPlayerSlotState_Open)
			{
				human++;
			}
		}
	}

	
	if( !mIsMultiplayer )
	{
		if( class'H7ReplicationInfo'.static.GetInstance().IsLAN() )
		{
			return string(maptype)$".LAN";
		}

		if( human >= 1 ) // because slot 0 is host = EPlayerSlotState_Occupied 
		{
			return string(maptype)$".HOTSEAT";
		}
		else
		{
			return string(maptype)$".SINGLEPLAYER";
		}
	}
	else 
	{
		return string(maptype)$".MULTIPLAYER";
	}
	
	return string(maptype);
}


function btnBackClick(EventData data)
{
	ClosePopup();
}

function Closed()
{
	// turn back on because flash hid it:
	mSkirmishSetup.SetVisibleSave(true);
	mHeroSelection.Reset();
	ClosePopup();
}

function CloseHeroSelection()
{
	mHeroSelection.SetVisibleSave(false);
	mHeroSelectionVisible = false;
}

function CloseCustomDifficulty()
{
	mPopUpCustomDifficulty.SetVisibleSave(false);
	mCustomDifficultyVisible = false;
}

function ClosePopup() // ESC or BACK or CLOSE[x]-Button
{
	RegisterNatUpdater(false);
	if(mIsMultiplayer)
	{
		if(mIsMaster)
		{
			class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().YesNoPopup("PU_LOBBY_DESTROY_CONFIRM","YES","NO",ClosePopupForReal,none,true);
		}
		else
		{
			class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().YesNoPopup("PU_LOBBY_QUIT_CONFIRM","YES","NO",ClosePopupForReal,none,true);
		}
	}
	else
	{
		ClosePopupForReal();
	}
}

function ClosePopupForReal()
{
	local H7ContentScannerAdventureMapData empty;

	if(class'H7ReplicationInfo'.static.GetInstance().IsMultiplayerGame())
	{
		// multiplayer host or multiplayer client -> back to main menu (map reload)
		if( class'H7PlayerController'.static.GetPlayerController().IsServer() )
		{
			class'H7TransitionData'.static.GetInstance().SetMPLobbyMapDataToCreate(empty);
			class'GameEngine'.static.GetOnlineSubsystem().GameInterface.DestroyOnlineGame('H7GameSession');

			// TODO MP tell all clients the lobby was destroyed by setting their tansitiondata:
			//class'H7TransitionData'.static.GetInstance().SetMPServerCancelledLobbySession(true);
		}
		class'H7TransitionData'.static.GetInstance().SetMPClientCancelledLobbySession( true );
		class'H7ReplicationInfo'.static.GetInstance().GoToMainMenu();
	}
	else
	{
		// singleplayer -> back to map select
		mSkirmishSetup.Reset();
		mHeroSelection.Reset();
		mSkirmishSetup.SetVisibleSave(false);
		
		H7MainMenuHud( GetHUD() ).GetMapSelectCntl().GetMapList().SetVisibleSave(true);
	}
	mHeroSelectionVisible = false;
}

