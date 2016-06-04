//=============================================================================
// H7AdventureMapInfo
//=============================================================================
//
// Adventure map game mode.
// 
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7AdventureMapInfo extends H7GameInfo;

var protected float				mCurrentStartMatchWaitTime;
var protected bool				mIsSimTurns;

// Pending player pawn for the player controller to spawn when loading a game state
var Pawn PendingPlayerPawn;

var protected string PendingSaveGameFileName;

// The campaign data if the game belongs to a campaign
// var H7CampaignDefinition CampaignData; // --> this is now in H7TransitionData

static function H7AdventureMapInfo GetInstance() { return H7AdventureMapInfo( class'WorldInfo'.static.GetWorldInfo().Game ); }

function bool IsSimTurns() { return mIsSimTurns; }

event InitGame(string Options, out string ErrorMessage)
{
	//local string CampaignName;
	//local H7CampaignDefinition CampaignData;

	Super.InitGame(Options, ErrorMessage);

	// Set the pending save game file name if required
	if (HasOption(Options, "SaveGameState"))
	{
		PendingSaveGameFileName = ParseOption(Options, "SaveGameState");
		PendingSaveGameFileName = Repl(PendingSaveGameFileName, ".sav", "");
	}
	else
	{
		PendingSaveGameFileName = "";
	}

	mIsSimTurns = HasOption(Options, "simturns");

	/*
	// Set campaign name, if any
	if (HasOption(Options, "Campaign")) 
	{
		// This is hack, can (should?) be removed
		CampaignName = ParseOption(Options, "Campaign");

		// Load CampaignName file from disk. TODO: is this expected to be a relative path?
		if (Len(CampaignName) > 0)
		{
			CampaignName = "..\\..\\MMH7Game\\" $ CampaignName;
			CampaignData = new class'H7CampaignDefinition';
			class'Engine'.static.BasicLoadObject(CampaignData, CampaignName, false, 0);
			class'H7TransitionData'.static.GetInstance().SetCampaign(CampaignData);
		}
	}
	else
	{
		// This is the correct way (but a pointless log)
		CampaignData = class'H7PlayerProfile'.static.GetInstance().GetCurrentCampaign().CampaignRef;
	}
	`log_story("Current map is part of campaign:" @ CampaignData);
	*/

}


/** 
 * Handles all player initialization that is shared between the travel methods (i.e. called from both PostLogin() and HandleSeamlessTravelPlayer())
 *
 * @param		Controller		Player that is being initialized
 * @network						Server
 */
function GenericPlayerInitialization(Controller Controller)
{
	local H7PlayerController currentPlayerController;
	local H7PlayerReplicationInfo playerRepliInfo;
	local array<PlayerLobbySelectedSettings> playerSettings;
	local PlayerLobbySelectedSettings playerSetting;
	local int i;

	super.GenericPlayerInitialization( Controller );

	currentPlayerController = H7PlayerController(Controller);

	if( currentPlayerController != none )
	{
		playerRepliInfo = H7PlayerReplicationInfo(Controller.PlayerReplicationInfo);
		if( playerRepliInfo != none )
		{
			// I give playerRepliInfo a playernumber (the player he will play in this game)
			if(class'H7TransitionData'.static.GetInstance().UseMe())
			{
				playerSettings = class'H7TransitionData'.static.GetInstance().GetPlayersSettings();
				foreach playerSettings(playerSetting,i)
				{
					if(playerSetting.mName == playerRepliInfo.PlayerName)
					{
						// this client will play the playernumber that the row with his name has set as position
						playerRepliInfo.SetReplicationPlayerNumber( EPlayerNumber(int(playerSetting.mPosition)) );
					}
				}
			}
			else
			{
				playerRepliInfo.SetReplicationPlayerNumber( EPlayerNumber(GameReplicationInfo.PRIArray.Length) ); // server PN_PLAYER_1, first client PN_PLAYER_2, etc.
			}
		}
	}
}

/** Check for minimum number of players */
function bool ArePlayersNeeded()
{
	local array<MapInfoPlayerProperty> playerList;
	local int targetNumPlayers;

	if( class'H7AdventureGridManager'.static.GetInstance() == none )
	{
		return false;
	}

	targetNumPlayers = class'H7TransitionData'.static.GetInstance().GetHumanPlayersCounter();
	if( targetNumPlayers == 0 ) // in case we launch the game without using the lobby
	{
		playerList = H7MapInfo( class'H7GameUtility'.static.GetAdventureMapMapInfo() ).GetPlayerProperties();
		targetNumPlayers = playerList.Length - 1; // -1 -> we dont count the neutral player
	}

	// check for min players needed for a nonranked match
	return NumPlayers == targetNumPlayers;
}

/* 
 * Is the server currently at capacity?
 * @param bSpectator - Whether we should check against player or spectator limits
 * @return TRUE if the server is full, FALSE otherwise
 */
function bool AtCapacity(bool bSpectator, optional string playerName)
{
	local H7OnlineGameSettings onlineSettings;
	local array<PlayerLobbySelectedSettings> playerList;
	local int i;
	local bool playerFound;

	// we dont want to allow the players to join the game once the adventure started
	if( class'H7AdventureController'.static.GetInstance() != none )
	{
		return true;
	}

	if ( WorldInfo.NetMode == NM_Standalone )
	{
		return false;
	}

	
	onlineSettings = class'H7MultiplayerGameManager'.static.GetOnlineGameSettings();

	// if the game already started, check if the player is in the players list
	if( onlineSettings.IsGameStarted() )
	{
		playerList = class'H7TransitionData'.static.GetInstance().GetPlayersSettings();
		playerFound = false;
		for(i = 0; i < playerList.Length; i++)
		{
			if( playerList[i].mName == playerName )
			{
				playerFound = true;
			}
		}
		
		if( !playerFound )
		{
			return true; 
		}
	}

	if ( bSpectator )
	{
		return ( (NumSpectators >= MaxSpectators)
			&& ((WorldInfo.NetMode != NM_ListenServer) || (NumPlayers > 0)) );
	}
	else
	{
		return ( (onlineSettings.NumPublicConnections>0) && ( ( GetNumPlayers() + onlineSettings.GetNumClosedSlots() + onlineSettings.GetNumAISlots() )>= onlineSettings.NumPublicConnections) );
	}
}

auto State PendingMatch
{
	event BeginState(name PreviousStateName)
	{
		if (GameReplicationInfo != None)
		{
			GameReplicationInfo.bMatchHasBegun = false;
		}

		bWaitingToStartMatch = true;
		mCurrentStartMatchWaitTime = 0.f;

		H7ReplicationInfo(GameReplicationInfo).SetPendingSaveGameFileName( PendingSaveGameFileName );
	}

	function StartMatch()
	{
		PreInitStartMatch();
		InitStartMatch();
		super.StartMatch();

		GotoState('MatchInProgress');

		class'H7TransitionData'.static.GetInstance().TriggerReadyForMatineeListener();
	}

	function PreInitStartMatch()
	{
		local H7AdventurePlayerController adventurePlayerController;

		ForEach WorldInfo.AllControllers(class'H7AdventurePlayerController', adventurePlayerController)
		{
			adventurePlayerController.SendPreInitStartAdventureMap();
		}
	}

	function InitStartMatch()
	{
		local H7AdventurePlayerController adventurePlayerController;

		ForEach WorldInfo.AllControllers(class'H7AdventurePlayerController', adventurePlayerController)
		{
			adventurePlayerController.SendInitStartAdventureMap();
		}
	}

	Begin:
	if( WorldInfo.NetMode == NM_Standalone )
	{
		if(  class'H7AdventureGridManager'.static.GetInstance() != none 
			&& class'H7AdventureGridManager'.static.GetInstance().IsInitialized() 
			&& class'H7PlayerController'.static.GetPlayerController().GetHud().IsLoaded() )
		{	
			class'H7ReplicationInfo'.static.PrintLogMessage("StartMatch", 0);;
			StartMatch();
		}
	}
	else if( (ArePlayersNeeded() && ArePlayersReady()) || mCurrentStartMatchWaitTime > 180.f ) // give up to 3 minutes to players to join the match
	{
		StartMatch();
	}
	Sleep( 0.1f );
	mCurrentStartMatchWaitTime += 0.1f;
	goto( 'Begin');
}

state MatchInProgress
{
}

