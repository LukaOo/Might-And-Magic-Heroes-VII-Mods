//=============================================================================
// H7CombatMapInfo
//=============================================================================
//
// Combat Map game mode.
// 
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CombatMapInfo extends H7GameInfo;

const NUM_COMBAT_PLAYERS = 2;

var bool				bIsReturningToMainMenu;
var protected float		mCurrentStartMatchWaitTime;

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
	local bool isServerTheAttacker;
	super.GenericPlayerInitialization( Controller );

	currentPlayerController = H7PlayerController(Controller);

	if( currentPlayerController != none )
	{
		// give the player if is attacker or not
		playerRepliInfo = H7PlayerReplicationInfo(Controller.PlayerReplicationInfo);
		if( playerRepliInfo != none )
		{
			isServerTheAttacker = true;
			if( class'H7TransitionData'.static.GetInstance().GetPlayersSettings().Length > 0  && class'H7TransitionData'.static.GetInstance().GetPlayersSettings()[0].mPosition == 2 )
			{
				isServerTheAttacker = false;
			}
			
			// first player is attacker, second is defender, the others are spectators
			if( GameReplicationInfo.PRIArray.Length == 1 )
			{
				playerRepliInfo.SetCombatPlayerType( isServerTheAttacker ? COMBATPT_ATTACKER : COMBATPT_DEFENDER );
			}
			else if( GameReplicationInfo.PRIArray.Length == 2 )
			{
				playerRepliInfo.SetCombatPlayerType( isServerTheAttacker ? COMBATPT_DEFENDER : COMBATPT_ATTACKER );
			}
			else
			{
				playerRepliInfo.SetCombatPlayerType( COMBATPT_SPECTATOR );
			}

			if( playerRepliInfo.GetCombatPlayerType() == COMBATPT_ATTACKER )
			{
				playerRepliInfo.SetReplicationPlayerNumber( PN_PLAYER_1 );
			}
			else if( playerRepliInfo.GetCombatPlayerType() == COMBATPT_DEFENDER )
			{
				playerRepliInfo.SetReplicationPlayerNumber( PN_PLAYER_2 );
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
	// check for min players needed for a nonranked match
	return NumPlayers == NUM_COMBAT_PLAYERS;
}

/** Makes the host ready */
function ForceHostReady()
{
	local H7CombatPlayerController playerController;

	ForEach WorldInfo.AllControllers(class'H7CombatPlayerController', playerController)
	{
		if( playerController.GetPlayerReplicationInfo() != None )
		{
			playerController.GetPlayerReplicationInfo().SetHostReady();
		}
	}
}

event PostLogin(PlayerController NewPlayer)
{
	Super.PostLogin(NewPlayer);

	if( Worldinfo.NetMode == NM_ListenServer )
	{	
		if( bWaitingToStartMatch && ArePlayersNeeded() )
		{
			ForceHostReady();
		}
	}
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

// overriden in states 
function StateEndCombat();

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
	}

	function StartMatch()
	{
		super.StartMatch();

		PreInitStartMatch();
		InitStartMatch();
		GotoState('CombatInProgress');
	}

	function PreInitStartMatch()
	{
		local H7CombatPlayerController combatPlayerController;

		ForEach WorldInfo.AllControllers(class'H7CombatPlayerController', combatPlayerController)
		{
			class'H7ReplicationInfo'.static.PrintLogMessage("Calling PreInitStartMatch in " @ combatPlayerController, 0);;
			combatPlayerController.SendPreInitStartCombat();
		}
	}

	function InitStartMatch()
	{
		local H7CombatPlayerController combatPlayerController;

		ForEach WorldInfo.AllControllers(class'H7CombatPlayerController', combatPlayerController)
		{
			class'H7ReplicationInfo'.static.PrintLogMessage("Calling InitStartMatch in " @ combatPlayerController, 0);;
			combatPlayerController.SendInitStartCombat();
		}
	}

Begin:
    if( WorldInfo.NetMode == NM_Standalone )
	{
		if( class'H7CombatMapGridController'.static.GetInstance() != none && class'H7CombatMapGridController'.static.GetInstance().GetID() > 0 )
		{
			StartMatch();
		}
	}
	else if( (ArePlayersNeeded() && ArePlayersReady()) || mCurrentStartMatchWaitTime > 30.f ) // give up to 30 seconds to the other player to join the match
	{
		StartMatch();
	}

	Sleep(0.1f);	//  Up the frequency so it's more responsive since we aren't doing actual timing here
	mCurrentStartMatchWaitTime += 0.1f;
	Goto('Begin');
}

State CombatInProgress
{
	function StateEndCombat() 
	{
		GotoState('EndCombat'); 
	}
}

State EndCombat
{

	/**
	 * Cleanup sessions and return to the main menu gracefully without a playercontroller
	 */
	function ReturnToMainMenuNoPC()
	{
		local H7PlayerController LP;

		LP = H7PlayerController(GetALocalPlayerController());

		if (!bIsReturningToMainMenu)
		{
			class'H7ReplicationInfo'.static.PrintLogMessage("("$Name$") H7CombatMapInfo::"$GetStateName()$":"$GetFuncName()@ "Return to the main menu without a playercontroller. Destroying game/party sessions.", 0);;

			// flag gets cleared when main menu reloads
			bIsReturningToMainMenu = true;

			// Cleanup game session 
			LP.DeleteSession('H7GameSession',OnDestroyGameComplete);
		}
	}
	/**
		* Delegate called when party destroy is complete
		*/
	function OnDestroyGameComplete(name SessionName,bool bWasSuccessful)
	{
		if (OnlineSub != None &&
			OnlineSub.GameInterface != None &&
			SessionName == 'H7GameSession')
		{
			// clear delegate for game deletion
			OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyGameComplete);
			class'H7ReplicationInfo'.static.GetInstance().GoToMainMenu();
		}
	}

	Begin:
		ReturnToMainMenuNoPC();
}

