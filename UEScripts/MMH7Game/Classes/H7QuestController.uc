//=============================================================================
// H7QuestController
//
// 
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7QuestController extends Object
	hidecategories(Object,Attachment,Collision,Physics,Advanced,Debug,Mobile,Movement,Display)  
	dependson(H7StructsAndEnumsNative)
	native;

enum EEndGameAction
{
	EGA_NEXT_MAP,
	EGA_COUNCIL,
	EGA_MAINMENU,
	EGA_OBSERVER,
	EGA_LOAD_GAME,
	EGA_RESTART_MAP
};

var H7Player mPlayer;
var H7AdventureController mAdventureController;
var protected array<H7SeqAct_Quest_NewNode> mAllQuests;
var protected array<H7SeqCon_Event> mAllEvents;
var protected EMapType mMapType;
var protected SeqAct_Interp mEndMatinee;
var protected EEndGameAction mPendingEndGameAction;

var protected bool mWonGame;
var protected bool mLostGame;

var protected H7SeqAct_WinMap mWinSequence;
var protected H7SeqAct_LoseMap mLoseSequence;
var protected bool mQueuedForWin;
var protected bool mQueuedForLoss;
var protected bool mSkipEndGameAction;

// Skripting
var H7MapEventParam mMapEventParam;

function bool				IsQueuedForWin()                    { return mQueuedForWin; }
function bool				IsQueuedForLoss()                   { return mQueuedForLoss; }
function					SetQueuedForWin( bool win )         { mQueuedForWin = win; }
function					SetQueuedForLoss( bool loss )       { mQueuedForLoss= loss; }

function					SetWinSeq( H7SeqAct_WinMap win )    { mWinSequence = win; }
function					SetLossSeq( H7SeqAct_LoseMap loss ) { mLoseSequence= loss; }
function H7SeqAct_WinMap    GetWinSeq()                         { return mWinSequence; }   
function H7SeqAct_LoseMap   GetLoseSeq()                        { return mLoseSequence; }

function SeqAct_Interp GetEndMatinee() { return mEndMatinee; }
function EEndGameAction GetPendingEndGameAction() { return mPendingEndGameAction; }
function SetSkipEndGameAction(bool value) { mSkipEndGameAction = value; }

/**
 * Set a player as an owner of this controller
 */
function SetPlayer( H7Player playerr )
{
	mPlayer = playerr;
}

/**
 * Initialize this controller
 */
function Init()
{
	local H7MapInfo levelMapInfo;

	levelMapInfo = H7MapInfo(class'H7GameUtility'.static.GetAdventureMapMapInfo());
	mMapType = levelMapInfo.GetMapType();

	//	Fetch quests from Kismet
	mAdventureController = class'H7AdventureController'.static.GetInstance();

	mMapEventParam = new class'H7MapEventParam';
}

function H7SeqAct_Quest_NewNode GetQuestForObjective(H7SeqAct_QuestObjective searchObjective)
{
	local array<H7SeqAct_Quest_NewNode> quests;
	local H7SeqAct_Quest_NewNode quest;
	local array<H7SeqAct_QuestObjective> objectives;
	local H7SeqAct_QuestObjective objective;

	quests = GetActiveQuestNodes();

	foreach quests(quest)
	{
		objectives = quest.GetCurrentObjectives();
		foreach objectives(objective)
		{
			if(objective == searchObjective)
			{
				return quest;
			}
		}
	}

	return none;
}

function H7SeqAct_QuestObjective GetObjectiveForCondition(H7SeqCon_Condition searchCondition)
{
	local array<H7SeqAct_Quest_NewNode> quests;
	local H7SeqAct_Quest_NewNode quest;
	local array<H7SeqAct_QuestObjective> objectives;
	local H7SeqAct_QuestObjective objective;
	local H7SeqCon_Condition condition;
	local array<H7SeqCon_Condition> conditions;

	quests = GetActiveQuestNodes();

	foreach quests(quest)
	{
		objectives = quest.GetCurrentObjectives();
		foreach objectives(objective)
		{
			conditions = objective.GetWinConditions();
			foreach conditions(condition)
			{
				if(condition == searchCondition)
				{
					return objective;
				}
			}
			conditions = objective.GetLoseConditions();
			foreach conditions(condition)
			{
				if(condition == searchCondition)
				{
					return objective;
				}
			}
		}
	}

	return none;
}

function EEndGameAction GetEndGameAction()
{
	if(HasNextMap() && !IsReplay())
	{
		return EGA_NEXT_MAP;
	}
	else if(IsLastCampaignMap())
	{
		return EGA_COUNCIL;
	}
	else if(IsReplay())
	{
		return EGA_COUNCIL;
	}
	else
	{
		return EGA_MAINMENU;
	}
}

function bool IsReplay()
{
	local H7PlayerProfile playerProfile;
	local string map;

	map = class'H7ReplicationInfo'.static.GetInstance().GetCurrentMapName();
	playerProfile = class'H7PlayerProfile'.static.GetInstance();

	if(playerProfile.mCampaignsProgress[playerProfile.GetCurrentCampaignID()].ReplayMap.CurrentMapState == MST_InProgress 
	&& playerProfile.mCampaignsProgress[playerProfile.GetCurrentCampaignID()].ReplayMap.MapFileName == Caps(map) )
	{
		return true;
	}

	return false;
}

function bool HasNextMap()
{
	local H7CampaignDefinition currentCampaign;
	local string map;

	map = class'H7ReplicationInfo'.static.GetInstance().GetCurrentMapName();
	currentCampaign = class'H7AdventureController'.static.GetInstance().GetCampaign();
	if(currentCampaign != none)
	{
		return "" != currentCampaign.GetNextMap(map);
	}
	// debug hack
	if(H7MapInfo(class'WorldInfo'.static.GetWorldInfo().GetVanillaMapInfo()) != none 
		&& H7MapInfo(class'WorldInfo'.static.GetWorldInfo().GetVanillaMapInfo()).GetNextMap() != "")
	{
		return true;
	}
	return false;
}

function bool IsLastCampaignMap()
{
	local H7CampaignDefinition currentCampaign;

	currentCampaign = class'H7AdventureController'.static.GetInstance().GetCampaign();
	if(currentCampaign != none)
	{
		return currentCampaign.IsLastMap(class'H7ReplicationInfo'.static.GetInstance().GetCurrentMapName());
	}
	return false;
}

// WIN ////////////////////////////////////////////////////////////////////////////////////////////

function WinGame()
{
	if( mWonGame || mLostGame ) { return; } // no double win
	mWonGame = true; // we remember we won the game but don't do anything yet, in case popups are open
	CheckWinGame();
}

function CheckWinGame()
{
	local array<H7Player> players;
	local int i;

	players = mAdventureController.GetPlayers();
	for(i=1; i<players.Length; i++)
	{
		if(!players[i].GetQuestController().IsGameEnd() && !class'H7TeamManager'.static.GetInstance().IsAllied(players[i], mPlayer))
		{
			players[i].GetQuestController().LoseGame();
		}
	}

	if(mPlayer != mAdventureController.GetLocalPlayer())
	{
		return;
	}

	if(mWonGame)
	{	
		;
		HideHUD();

		// Tell PlayerProfile that we completed the map and we can consider it as COMPLETED
		class'H7PlayerProfile'.static.GetInstance().HandleMapFinish(mAdventureController.GetCampaign() != none ? true : false);
		
		class'H7PlayerController'.static.GetPlayerController().GetHUD().GetPauseMenuCntl().UpdateResultPopUpWin();
		
		class'H7SoundController'.static.GetInstance().UpdateMusicGameStateSwitch("VICTORY_SCREEN");
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("WIN_MAP");

		EndGame();
	}
}

// LOSE ////////////////////////////////////////////////////////////////////////////////////////////

function LoseGame()
{
	if( mWonGame || mLostGame ) { return; } // no double lose
	mLostGame = true;

	if(mPlayer != mAdventureController.GetLocalPlayer())
	{
		return;
	}

	// check lose game after 2 frames so all other questControllers updated properly if the game was won by someone already
	class'H7PlayerController'.static.GetPlayerController().GetHud().SetFrameTimer(2, CheckLoseGame);
}

function CheckLoseGame()
{
	if(mLostGame)
	{
		;
		HideHUD();
		class'H7PlayerController'.static.GetPlayerController().GetHUD().GetRequestPopupCntl().GetRequestPopup().Finish(); // closes new week popup when you lose at the start of the turn

		if(mPlayer == mAdventureController.GetCurrentPlayer() && mPlayer.IsControlledByAI() )
		{
			if(class'H7AdventureController'.static.GetInstance().IsHotSeat()) 
				AIHotseatLoseConfirmed();
			return;
		}
		
		if(class'H7PlayerController'.static.GetPlayerController().GetHUD().GetPauseMenuCntl().GetPopup().IsA('H7GFxMapResultPopUp')
		   && class'H7PlayerController'.static.GetPlayerController().GetHUD().GetPauseMenuCntl().GetPopup().IsVisible())
			return;
		
		class'H7PlayerController'.static.GetPlayerController().GetHUD().GetPauseMenuCntl().UpdateResultPopUpLose(IsGameWonBySomeone());
		class'H7SoundController'.static.GetInstance().UpdateMusicGameStateSwitch("DEFEAT_SCREEN");
		
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("LOSE_MAP");
		EndGame();
	}
}
// COMMON (WIN+LOSE) END GAME

function bool IsGameEnd()
{
	return mLostGame || mWonGame;
}

function bool IsGameWon()
{
	return mWonGame;
}

function AIHotseatLoseConfirmed()
{
	if( IsGameWonBySomeone() && IsGameEnd() )
	{
		DoEndGameAction(EGA_MAINMENU);
	}
	else
	{
		mAdventureController.EndMyTurn();
	}
}

function EndGame()
{
	// make sure the town screen is closed before we show any shiny stuff
	class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().LeaveTownScreen();
	class'H7AdventureHudCntl'.static.GetInstance().SetVisible(false);
	class'H7SpellbookCntl'.static.GetInstance().GetQuickBar().SetVisibleSave(false);
	// where are other hud elements not in AdvCntl closed? -> See HideHUD which is called earlier
	// OPTIONAL where are any and all open popups closed?
	
	class'H7PlayerController'.static.GetPlayerController().SetIsUnrealInputAllowed(false);

	mMapEventParam.mActivePlayerWon = mWonGame;
	class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_MapFinished', mMapEventParam, mPlayer);
}

function HideHUD() // for end of map
{
	if(class'H7TownHudCntl'.static.GetInstance().IsInAnyScreen())
	{
		class'H7TownHudCntl'.static.GetInstance().Leave();
	}

	class'H7PlayerController'.static.GetPlayerController().GetHud().GetLogCntl().GetQALog().SetVisibleSave(false);
	class'H7PlayerController'.static.GetPlayerController().GetHud().GetLogCntl().GetLog().SetVisibleSave(false);
		
	if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() )
	{
		class'H7AdventureHudCntl'.static.GetInstance().GetActorTooltip().ShutDown();
		class'H7AdventureHudCntl'.static.GetInstance().SetVisible(false);
		
		class'H7TownHudCntl'.static.GetInstance().GetTownInfo().SetVisibleSave(false);
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetGUIOverlaySystemCntl().GetSideBar().SetVisibleSave(false);
	}
	else
	{
		class'H7CombatHud'.static.GetInstance().SetCombatHudVisible(false);
	}
}

function CheckEndMatinee()
{
	if(mEndMatinee != none && mEndMatinee.bIsPlaying)
	{
		class'H7PlayerController'.static.GetPlayerController().GetHud().SetFrameTimer(1,CheckEndMatinee);
	}
	else
	{
		DoEndGameAction(mPendingEndGameAction,true);
	}
}

function DoEndGameAction(EEndGameAction action,bool skipMatinee=false)
{
	local H7AdventureController advCntl;
	local string trackingMSG;

	advCntl = class'H7AdventureController'.static.GetInstance();

	mPendingEndGameAction = action;

	mMapEventParam.mActivePlayerWon = mWonGame;
	class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_GameEndPopupClosed', mMapEventParam, mPlayer);

	if(mSkipEndGameAction)
	{
		return;
	}
	
	if(!skipMatinee)
	{
		mEndMatinee = class'H7AdventureController'.static.GetInstance().GetMapInfo().GetEndMatinee();
		if(mEndMatinee != none)
		{
			mEndMatinee.SetPosition(0);
			mEndMatinee.ForceActivateInput(0);
			class'H7PlayerController'.static.GetPlayerController().GetHud().SetFrameTimer(1,CheckEndMatinee);
			return;
		}
	}

	/** TRACKING **/
	switch(action)
	{
		case EGA_NEXT_MAP:
			/**MAPEND */ 
			advCntl.TrackingMapEnd("MAPEND");
			mAdventureController.GotoNextMap();
			break;
		case EGA_COUNCIL:
			advCntl.TrackingMapEnd("MAPEND");
			advCntl.TrackingGameModeEnd();
			class'H7SoundController'.static.GetInstance().UpdateMusicGameStateSwitch("STOP_AMBIENT");
			class'H7ReplicationInfo'.static.GetInstance().StartMap(class'H7GameData'.static.GetInstance().GetHubMapName());
			break;
		case EGA_MAINMENU:
			advCntl.TrackingMapEnd("MAPEND");
			advCntl.TrackingGameModeEnd();
			class'H7ReplicationInfo'.static.GetInstance().GoToMainMenu();
			break;
		case EGA_OBSERVER:
			// TODO MP
			if(!class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() && mPlayer == mAdventureController.GetCurrentPlayer())
			{
				mAdventureController.EndMyTurn();
			}
			break;
		case EGA_LOAD_GAME: 
			class'H7PlayerController'.static.GetPlayerController().GetHud().CloseCurrentPopup();
			class'H7PlayerController'.static.GetPlayerController().GetHud().GetPauseMenuCntl().GetPauseMenu().SetVisibleSave(false);
			class'H7PlayerController'.static.GetPlayerController().GetHud().GetPauseMenuCntl().GetMapResultPopUp().SetVisibleSave(false);
			class'H7PlayerController'.static.GetPlayerController().GetHud().GetLoadSaveWindowCntl().OpenLoad(true,true);
			break;
		case EGA_RESTART_MAP:

			trackingMSG = IsGameWon() ? "WON_RESTART" : "LOST_RESTART" ;
			advCntl.TrackingMapEnd(trackingMSG);
			if(advCntl.GetCampaign() != none) // If campaign let profile handle it
			{
				class'H7PlayerProfile'.static.GetInstance().HandleCampaignMapRestart(advCntl.GetMapFileName(), advCntl.GetCampaign());
			}
			else
			{
				class'H7ReplicationInfo'.static.GetInstance().WriteGameDataToTransitionData(true);
				class'H7ReplicationInfo'.static.GetInstance().StartMap( class'H7ReplicationInfo'.static.GetInstance().GetCurrentMapName() );
			}
			
			break;

		default:
			;
	}
}

function bool IsGameWonBySomeone()
{
	local array<H7Player> players;
	local int i;
	players = mAdventureController.GetPlayers();
	for(i=1; i<players.Length; i++)
	{
		if(players[i].GetQuestController().IsGameWon())
		{
			return true;
		}
	}
	return false;
}

function H7SeqAct_Quest_NewNode GetQuestByID(String id)
{
	local H7SeqAct_Quest_NewNode currentQuest;

	if(mAllQuests.Length == 0)
	{
		GetActiveQuestNodes(); // ensure availability in mAllQuests
	}

	foreach mAllQuests( currentQuest )
	{
		if( currentQuest.GetID() == id )
		{
			return currentQuest;
		}
	}

	return none;
}

native function array<H7SeqAct_Quest_NewNode> GetActiveQuestNodes();
native function array<H7SeqCon_Event> GetActiveEvents();
