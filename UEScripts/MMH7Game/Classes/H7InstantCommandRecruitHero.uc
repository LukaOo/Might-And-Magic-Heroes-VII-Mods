//=============================================================================
// H7InstantCommandRecruitHero
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandRecruitHero extends H7InstantCommandBase;

var private H7Town mTown;
var private int mHeroId;

function Init( H7Town town, int heroId )
{
	mTown = town;
	mHeroId = heroId;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mTown = H7Town(eventManageable);
	mHeroId = command.IntParameters[1];
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_RECRUIT_HERO;
	command.IntParameters[0] = mTown.GetID();
	command.IntParameters[1] = mHeroId;
	
	return command;
}

function Execute()
{
	local H7AdventureHud hud;
	local bool success;

	success = mTown.RecruitHeroComplete( mHeroId );

	if(success && mTown.GetPlayer().IsControlledByLocalPlayer())
	{
		hud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();
		if(hud.GetTownHudCntl().GetMiddleHUD().IsVisible())
		{
			hud.GetTownHudCntl().RecruitHeroComplete(mHeroId);
		}
	}
}

/**
 * Sim Turns:
 * Determines if this instant command waits for ongoing move/startCombat commands in the area of the command location
 */
function bool WaitForInterceptingCommands()
{
	return true;
}

/**
 * Sim Turns:
 * used to check for intersection with ongoing move commands
 */
function Vector GetInterceptLocation()
{
	return mTown.GetLocation();
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mTown.GetPlayer();
}
