//=============================================================================
// H7InstantCommandSelectSpecialisation
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandSelectSpecialisation extends H7InstantCommandBase;

var private H7Town mTown;
var private int mSchool;

function Init( H7Town town, int school )
{
	mTown = town;
	mSchool = school;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mTown = H7Town(eventManageable);
	mSchool = command.IntParameters[1];
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_SELECT_SPECIALISATION;
	command.IntParameters[0] = mTown.GetID();
	command.IntParameters[1] = mSchool;
	
	return command;
}

function Execute()
{
	local H7TownMagicGuild bestMagicGuild;
	local H7TownBuildingData townData;
	local H7AdventureHud hud;

	townData = mTown.GetBuildingDataByType(class'H7TownMagicGuild');
	bestMagicGuild = H7TownMagicGuild(mTown.GetBestBuilding(townData).Building);

	if(!mTown.GetMageGuildSpecialisationStatus())
	{
		bestMagicGuild.SetMageGuildSpecialisation(EAbilitySchool(mSchool), mTown); 
		mTown.InitMagicGuilds();
	}

	// notify gui
	if(mTown.GetPlayer().IsControlledByLocalPlayer())
	{
		hud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();
		if(hud.GetMagicGuildCntl().GetPopup().IsVisible())
		{
			hud.GetMagicGuildCntl().SelectSchoolComplete();
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
