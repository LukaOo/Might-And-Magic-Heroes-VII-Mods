//=============================================================================
// H7InstantCommandThievesGuildPlunder
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandThievesGuildPlunder extends H7InstantCommandBase;

var private H7Player mPlunderingPlayer;
var private H7Player mPlunderedPlayer;

function Init( H7Player plunderingPlayer, H7Player plunderedPlayer )
{
	mPlunderingPlayer = plunderingPlayer;
	mPlunderedPlayer = plunderedPlayer;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	mPlunderingPlayer = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( EPlayerNumber(command.IntParameters[0]) );
	mPlunderedPlayer = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( EPlayerNumber(command.IntParameters[1]) );
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_THIEVES_GUILD_PLUNDER;
	command.IntParameters[0] = mPlunderingPlayer.GetPlayerNumber();
	command.IntParameters[1] = mPlunderedPlayer.GetPlayerNumber();

	return command;
}

function Execute()
{
	local H7AdventureHud hud;

	mPlunderedPlayer.ApplyPlunder(mPlunderingPlayer);

	// notify gui
	if(mPlunderingPlayer.IsControlledByLocalPlayer())
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
	return mPlunderingPlayer;
}
