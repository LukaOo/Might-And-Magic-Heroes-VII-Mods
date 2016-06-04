//=============================================================================
// H7GameInfo
//=============================================================================
//
// Base class for the game modes (combat, adventuremap, ...)
// 
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GameInfo extends GameInfo;

var H7CombatController m_OverrideController;
var float              m_OverrideGameSpeed;

static function H7GameInfo GetH7GameInfoInstance()
{
	return H7GameInfo( class'WorldInfo'.static.GetWorldInfo().Game );
}

function H7CombatController GetCombatController()  { return m_OverrideController; }
function float              GetGameSpeed()         { return m_OverrideGameSpeed; }

event InitGame( string Options, out string ErrorMessage )
{
	local string InOpt, InOpt2;
	
	InOpt = ParseOption( Options, "GameSpeed");
	InOpt2 = ParseOption( Options, "CombatSetup");

	if( InOpt != "" )
	{
		;
		m_OverrideGameSpeed = float(InOpt);
	}

	if( InOpt2 != "")
	{
		 m_OverrideController = H7CombatController( DynamicLoadObject( InOpt2 , class'H7CombatController') );
	}
	super.InitGame(Options, ErrorMessage);
}

// Restart Player and SpawnDefaultPawnFor are overriden to avoid a Pawn to be spawned. We cleary don't need one for Heroes.
function RestartPlayer(Controller NewPlayer) //override
{
}

function Pawn SpawnDefaultPawnFor(Controller NewPlayer, NavigationPoint StartSpot) // override
{
	return none;
}

/**
 * Wrapper for determining whether all required players are ready to play.
 */
function bool ArePlayersReady()
{
	local PlayerController PC;
	local H7PlayerReplicationInfo PRI;

	// look for the host ready flag
	foreach WorldInfo.AllControllers(class'PlayerController',PC)
	{
		PRI = H7PlayerReplicationInfo(PC.PlayerReplicationInfo);
		//if( PRI == None || !PRI.IsHostReady() || !PRI.IsPlayerReady() )
		if( PRI == None || !PRI.IsPlayerReady() )
		{
			return false;
		}
	}
	return true;
}

/** Check for minimum number of players */
function bool ArePlayersNeeded()
{
	;
	return false;
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

	super.GenericPlayerInitialization( Controller );

	currentPlayerController = H7PlayerController(Controller);
	if( currentPlayerController != none )
	{
		if((class'H7TransitionData'.static.GetInstance().GetMPLobbyMapDataToCreate().Filename != ""
			|| class'H7TransitionData'.static.GetInstance().GetMPLobbyCombatMapDataToCreate().Filename != "")
			&& class'H7ReplicationInfo'.static.GetInstance().mLobbyData.mPlayers[0].mSlotState == EPlayerSlotState_Occupied) // prevent host from adding himself
		{
			class'H7ReplicationInfo'.static.PrintLogMessage("Player joined:" @ Controller.PlayerReplicationInfo.PlayerName @ Controller.PlayerReplicationInfo.SessionName, 0);;
			class'H7ReplicationInfo'.static.GetInstance().AddPlayerToLobbyData(Controller.PlayerReplicationInfo.PlayerName);
		}
	}
}

function Logout( Controller Exiting )
{
	local H7PlayerController currentPlayerController;
	local int playerNum;

	currentPlayerController = H7PlayerController(Exiting);
	if( currentPlayerController != none )
	{
		playerNum = H7PlayerReplicationInfo(currentPlayerController.PlayerReplicationInfo).GetPlayerNumber();
		if(class'H7CombatPlayerController'.static.GetCombatPlayerController() != none)
		{
			class'H7CombatPlayerController'.static.GetCombatPlayerController().SendPlayerDisconnected(playerNum);
		}
		else
		{
			// TODO MP disconnect without combat player controller?
		}
	}

	super.Logout(Exiting);
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

	if ( WorldInfo.NetMode == NM_Standalone )
	{
		return false;
	}

	class'H7ReplicationInfo'.static.GetInstance().LobbyUpdateOnlineGameSettingsSlots();
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
		class'H7ReplicationInfo'.static.GetInstance().LobbyUpdateOnlineGameSettingsSlots();
		onlineSettings = class'H7MultiplayerGameManager'.static.GetOnlineGameSettings();
		return ( (onlineSettings.NumPublicConnections>0) && ( ( GetNumPlayers() + onlineSettings.GetNumClosedSlots() + onlineSettings.GetNumAISlots() )>= onlineSettings.NumPublicConnections) );
	}
}

/**
 * Registers the dedicated server with the online service
 */
function RegisterServer()
{
	// DO NOTHING, if we keep the function from GameInfo, we will create 2 online game sessions
}

// Multiplayer
function HostGame( string URL, bool bAbsolute, bool bSkipGameNotify )
{
	WorldInfo.ServerTravel(URL, bAbsolute, bSkipGameNotify);
}

