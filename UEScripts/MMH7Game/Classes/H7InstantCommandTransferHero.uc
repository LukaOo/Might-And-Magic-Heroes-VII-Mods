//=============================================================================
// H7InstantCommandTransferHero
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandTransferHero extends H7InstantCommandBase;

var private H7AreaOfControlSite mSite;
var private EArmyNumber mFromArmy;
var private EArmyNumber mToArmy;

function Init( H7AreaOfControlSite site, EArmyNumber fromArmy, EArmyNumber toArmy )
{
	mSite = site;
	mFromArmy = fromArmy;
	mToArmy = toArmy;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mSite = H7AreaOfControlSite(eventManageable);
	mFromArmy = EArmyNumber(command.IntParameters[1]);
	mToArmy = EArmyNumber(command.IntParameters[2]);
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_TRANSFER_HERO;
	command.IntParameters[0] = mSite.GetID();
	command.IntParameters[1] = mFromArmy;
	command.IntParameters[2] = mToArmy;

	return command;
}

function Execute()
{
	local H7AdventureHud hud;
	local bool success;

	success = mSite.TransferHeroComplete( mFromArmy, mToArmy );

	// notify gui
	if(mSite.GetPlayer().IsControlledByLocalPlayer())
	{
		hud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();
		if(hud.GetTownHudCntl().GetMiddleHUD().IsVisible())
		{
			hud.GetTownHudCntl().CompleteHeroTransfer(success);
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
	return mSite.GetLocation();
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mSite.GetPlayer();
}
