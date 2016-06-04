//=============================================================================
// H7TeamManager
//=============================================================================
// 
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7TeamManager extends Object
	native;

var array<H7Player> mPlayers;
var H7AdventureController mAdventureController;

function InitTeamManager()
{
	mAdventureController = H7AdventureController( Outer );

	if( mAdventureController == none )
	{
		mAdventureController = class'H7AdventureController'.static.GetInstance();

		if( mAdventureController == none )
		{
			;
			return;
		}
	}

	mPlayers = mAdventureController.GetPlayers();
}

function array<H7Player> GetAllEnemiesOf( H7Player thaPlayah )
{
	local array<H7Player> enemies;
	local int i;

	for( i = 0; i < mPlayers.Length; ++i )
	{
		if( IsHostile( mPlayers[i], thaPlayah ) )
		{
			enemies.AddItem( mPlayers[i] );
		}
	}

	return enemies;
}

function array<H7Player> GetAllAlliesOf( H7Player thaPlayah )
{
	local array<H7Player> allies;

	allies = GetPlayerOfTeam( thaPlayah.GetTeamNumber() );

	allies.RemoveItem( thaPlayah ); // remove self from list

	return allies;
}

function array<H7Player> GetAllAlliesIncludingSelf( H7Player thaPlayah )
{
	local array<H7Player> result;
	result = GetPlayerOfTeam( thaPlayah.GetTeamNumber() );
	if (result.Length == 0)//if failed to get players of the same team
	{
		result.AddItem(thaPlayah);
	}
	return result;
}

native function GetAllAlliesAndSpectatorNumbers( EPlayerNumber playerNumber, out array<EPlayerNumber> numbers );

function array<H7Player> GetPlayerOfTeam( ETeamNumber teamNumber )
{
	local array<H7Player> players;
	local int i;

	if(teamNumber == TN_NO_TEAM)
	{
		return players;
	}

	for( i = 0; i < mPlayers.Length; ++i )
	{
		if( mPlayers[i].GetTeamNumber() == TN_NO_TEAM)
		{
			continue;
		}

		if( mPlayers[i].GetTeamNumber() == teamNumber )
		{
			players.AddItem( mPlayers[i] );
		}
	}

	return players;
}

native function bool IsAllied( H7Player playerA, H7Player playerB );

function bool IsHostile( H7Player playerA, H7Player playerB )
{
	return !IsAllied( playerA, playerB );
}

function bool HasAllies( H7Player thaPlayah )
{
	local array<H7Player> allies;

	allies = GetAllAlliesOf( thaPlayah );

	return allies.Length > 0;
}

function static H7TeamManager GetInstance()
{
	return class'H7AdventureController'.static.GetInstance().GetTeamManager();
}
