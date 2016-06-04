//=============================================================================
// H7PlayerReplicationInfo
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7PlayerReplicationInfo extends PlayerReplicationInfo
	native;

var protected EPlayerNumber				mPlayerNumber;
var protected bool						mIsCombatMapAttacker; // false = defender, true = attacker, Combat Map only
var protected bool						mIsHostReady;
var protected bool						mIsPlayerReady;
var protected ECombatPlayerType			mCombatPlayerType;
var protected bool						mIsInCombat;	// true = the player is in a combat map, false = the player is in an adventure map
var protected repnotify bool            mTurnFinished; // is used for sim turns
var protected bool                      mCanBeginNextTurn; // is used for sim turns

simulated function ECombatPlayerType	GetCombatPlayerType()								{ return mCombatPlayerType; }
simulated function bool					IsHostReady()										{ return mIsHostReady; }
simulated function bool					IsPlayerReady()										{ return mIsPlayerReady; }
simulated function EPlayerNumber		GetPlayerNumber()									{ return mPlayerNumber; }
simulated function bool					IsInCombatMap()										{ return mIsInCombat; }
simulated function bool					IsInAdventureMap()									{ return !mIsInCombat; }
simulated function bool                 IsTurnFinished()                                    { return mTurnFinished; }
simulated function bool                 CanBeginNextTurn()                                  { return mCanBeginNextTurn; }
simulated function H7Player             GetPlayer()
{
	if( class'H7AdventureController'.static.GetInstance() != none )
	{
		return class'H7AdventureController'.static.GetInstance().GetPlayerByNumber(mPlayerNumber);
	}
	else if( class'H7CombatController'.static.GetInstance() != none )
	{
		return class'H7CombatController'.static.GetInstance().GetPlayerByNumber(mPlayerNumber);
	}

	return none;
}

replication
{
    if (bNetDirty)
		mPlayerNumber, mCombatPlayerType, mIsHostReady, mIsPlayerReady, mIsInCombat, mTurnFinished;
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	class'H7ReplicationInfo'.static.PrintLogMessage(self @ "PostBeginPlay", 0);;
	if(class'H7AdventureController'.static.GetInstance() == none && class'H7CombatController'.static.GetInstance() == none) // I guess this is always the case, or we would never see this message
	{
		if(class'H7ReplicationInfo'.static.GetInstance().IsMultiplayerGame())
		{
			SetTimer(1.0f, true, nameof(ShowPlayerJoinGameMessage));
		}
	}
}

protected simulated function ShowPlayerJoinGameMessage()
{
	if( class'H7MessageSystem'.static.GetInstance() != none)
	{
		class'H7MessageSystem'.static.GetInstance().AddReplForNextMessage("%player",PlayerName);
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("MSG_JOINED_GAME", MD_LOG , , H7PlayerReplicationInfo( class'H7ReplicationInfo'.static.GetInstance().GetALocalPlayerController().PlayerReplicationInfo ).GetPlayerNumber() );
		ClearTimer('ShowPlayerJoinGameMessage');
	}
}

reliable server function SetCombatPlayerType( ECombatPlayerType newType )
{
	mCombatPlayerType = newType;
	class'H7ReplicationInfo'.static.PrintLogMessage(self @ "SetCombatPlayerType" @ mCombatPlayerType, 0);;
}

reliable server function SetHostReady()
{
	mIsHostReady = true;
	class'H7ReplicationInfo'.static.PrintLogMessage(self @ "SetHostReady", 0);;
}

reliable server function SetPlayerReady()
{
	mIsPlayerReady = true;
	class'H7ReplicationInfo'.static.PrintLogMessage(self @ "SetPlayerReady", 0);;
}

function simulated ResetTurnFinished()
{
	mTurnFinished = false;
}

function simulated ResetCandBeginNextTurn()
{
	mCanBeginNextTurn = false;
}

reliable server function SetTurnFinished()
{
	local array<PlayerReplicationInfo> PRIarray;
	local PlayerReplicationInfo PRI;
	local H7PlayerReplicationInfo H7PRI;
	local bool allPlayerTurnFinished;
	local H7InstantCommandEndturn command;

	if(mTurnFinished)
	{
		// don't end turn twice
		return;
	}

	mTurnFinished = true;
	allPlayerTurnFinished = true;
	
	PRIarray = class'H7ReplicationInfo'.static.GetInstance().PRIArray;
	foreach PRIarray( PRI )
	{
		H7PRI = H7PlayerReplicationInfo(PRI);
		if( !H7PRI.IsTurnFinished() && !H7PRI.GetPlayer().IsControlledByAI() && H7PRI.GetPlayer().GetStatus() != PLAYERSTATUS_QUIT)
		{
			allPlayerTurnFinished = false;
			break;
		}
	}

	if( allPlayerTurnFinished )
	{
		if( class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager() != none )
		{
			class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager().OnEndTurn();
		}

		command = new class'H7InstantCommandEndturn';
		command.Init( class'H7AdventureController'.static.GetInstance().GetLocalPlayer() );
		class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);
	}

	class'H7ReplicationInfo'.static.GetInstance().DataChanged();
	class'H7ReplicationInfo'.static.PrintLogMessage(self @ "SetTurnFinished" @ mTurnFinished, 0);;
}

reliable server function SetCanBeginNextTurn()
{
	local array<PlayerReplicationInfo> PRIarray;
	local PlayerReplicationInfo PRI;
	local H7PlayerReplicationInfo H7PRI;
	local bool allPlayerCanBeginNextTurn;
	local H7InstantCommandBeginTurn command;

	mCanBeginNextTurn = true;
	allPlayerCanBeginNextTurn = true;

	PRIarray = class'H7ReplicationInfo'.static.GetInstance().PRIArray;
	foreach PRIarray( PRI )
	{
		H7PRI = H7PlayerReplicationInfo(PRI);
		if( !H7PRI.CanBeginNextTurn() && H7PRI.GetPlayer().GetStatus() != PLAYERSTATUS_QUIT )
		{
			allPlayerCanBeginNextTurn = false;
			break;
		}
	}

	if(allPlayerCanBeginNextTurn)
	{
		class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager().UpdateUnitActionCounter( class'H7ReplicationInfo'.static.GetInstance().GetUnitActionsCounter() );
		command = new class'H7InstantCommandBeginTurn';
		class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);

		foreach PRIarray( PRI )
		{
			H7PlayerReplicationInfo(PRI).ResetCandBeginNextTurn();
			H7PlayerReplicationInfo(PRI).ResetTurnFinished();
		}
		class'H7ReplicationInfo'.static.GetInstance().DataChanged();
	}

	class'H7ReplicationInfo'.static.PrintLogMessage(self @ "SetCanBeginNextTurn" @ mCanBeginNextTurn, 0);;
}

reliable server function SetReplicationPlayerNumber( EPlayerNumber newPlayerNumber )
{
	mPlayerNumber = newPlayerNumber;
	class'H7ReplicationInfo'.static.PrintLogMessage(self @ "SetPlayerNumber" @ newPlayerNumber, 0);;
}

reliable server function SetIsInCombatMap( bool isInCombatMap )
{
	mIsInCombat = isInCombatMap;
	class'H7ReplicationInfo'.static.PrintLogMessage(self @ "SetIsInCombatMap" @ isInCombatMap, 0);;
}

simulated event ReplicatedEvent( name VarName )
{
	super.ReplicatedEvent( VarName );

	if(VarName == 'mTurnFinished')
	{
		class'H7ReplicationInfo'.static.GetInstance().DataChanged();
	}
}
