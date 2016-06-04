//=============================================================================
// H7InstantCommandSabotage
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandSabotage extends H7InstantCommandBase;

var private H7Player mSabotagingPlayer;
var private H7Player mSabotagedPlayer;

function Init( H7Player sabotagingPlayer, H7Player sabotagedPlayer )
{
	mSabotagingPlayer = sabotagingPlayer;
	mSabotagedPlayer = sabotagedPlayer;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	mSabotagingPlayer = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( EPlayerNumber(command.IntParameters[0]) );
	mSabotagedPlayer = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( EPlayerNumber(command.IntParameters[1]) );
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_SABOTAGE;
	command.IntParameters[0] = mSabotagingPlayer.GetPlayerNumber();
	command.IntParameters[1] = mSabotagedPlayer.GetPlayerNumber();

	return command;
}

function Execute()
{
	local H7AdventureHud hud;

	mSabotagedPlayer.ApplySabotage(mSabotagingPlayer);

	// notify gui
	if(mSabotagingPlayer.IsControlledByLocalPlayer())
	{
		hud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();
		if(hud.GetThievesGuildCntl().GetPopup().IsVisible())
		{
			hud.GetThievesGuildCntl().GetThievesGuildPopup().UpdateDungeonInfo();
		}
	}
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mSabotagingPlayer;
}
