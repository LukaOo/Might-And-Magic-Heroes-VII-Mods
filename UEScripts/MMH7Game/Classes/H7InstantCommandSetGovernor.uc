//=============================================================================
// H7InstantCommandSetGovernor
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandSetGovernor extends H7InstantCommandBase;

var private H7Town mTown;
var private H7AdventureHero mGovernor;

function Init( H7Town town, H7AdventureHero governor )
{
	mTown = town;
	mGovernor = governor;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mTown = H7Town(eventManageable);
	
	if( command.IntParameters[1] != -1 )
	{
		eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[1] );
		mGovernor = H7AdventureHero(eventManageable);
	}
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;
	local int governorId;

	governorId = mGovernor != none ? mGovernor.GetID() : -1;

	command.Type = ICT_SET_GOVERNOR;
	command.IntParameters[0] = mTown.GetID();
	command.IntParameters[1] = governorId;
	
	return command;
}

function Execute()
{
	local H7AdventureHud hud;

	mTown.SetGovernorComplete( mGovernor );

	if(mTown.GetPlayer().IsControlledByLocalPlayer())
	{
		hud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();
		if(hud.GetTownHudCntl().GetMiddleHUD().IsVisible())
		{
			hud.GetTownHudCntl().GovernorConfirmComplete();
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
