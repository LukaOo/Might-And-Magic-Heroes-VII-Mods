//=============================================================================
// H7InstantCommandCheatWinLose
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandCheatWinLose extends H7InstantCommandBase;

var private H7Player mPlayer;
var private bool mWin;

function Init( H7Player player, bool win )
{
	mPlayer = player;
	mWin = win;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	mPlayer = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( EPlayerNumber(command.IntParameters[0]) );
	mWin = bool(command.IntParameters[1]);
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_CHEAT_WIN_LOSE;
	command.IntParameters[0] = mPlayer.GetPlayerNumber();
	command.IntParameters[1] = int(mWin);
	
	return command;
}

function Execute()
{
	if( mWin )
	{
		if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
		{
			class'H7CombatController'.static.GetInstance().WinCombat();
		}
		else
		{
			mPlayer.GetQuestController().WinGame();
		}
	}
	else
	{
		if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
		{
			class'H7CombatController'.static.GetInstance().LoseCombat();
		}
		else
		{
			mPlayer.GetQuestController().LoseGame();
		}
	}
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mPlayer;
}
