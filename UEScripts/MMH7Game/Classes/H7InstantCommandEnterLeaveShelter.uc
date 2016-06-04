//=============================================================================
// H7InstantCommandTeleportToTown
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandEnterLeaveShelter extends H7InstantCommandBase;

var private H7AdventureHero mHero;
var private H7Shelter mShelter;
var private bool mEnter;

function Init( H7Shelter shelter, H7AdventureHero hero, bool enter )
{
	mHero = hero;
	mShelter = shelter;
	mEnter = enter;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mHero = H7AdventureHero(eventManageable);
	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[1] );
	mShelter = H7Shelter(eventManageable);
	mEnter = command.IntParameters[2] == 1 ? true : false;	
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_ENTER_LEAVE_SHELTER;
	command.IntParameters[0] = mHero.GetID();
	command.IntParameters[1] = mShelter.GetID();
	command.IntParameters[2] = mEnter ? 1 : 0;
	
	return command;
}

function Execute()
{
	local H7AdventureArmy army;

	army = mHero.GetAdventureArmy();

	if(mEnter)
	{
		army.SetCell( none, false, false, false );
		army.SetVisitableSite( mShelter );
		army.SetGarrisonedSite( mShelter );
		army.HideArmy();
		army.SetArmyLocked( true );
		mShelter.SetShelteredArmy(army);
	}
	else
	{
		army.SetCell( mShelter.GetEntranceCell() );
		army.SetVisitableSite( none );
		army.SetGarrisonedSite( none );
		army.SetArmyLocked( false );
		army.ShowArmy();
		mShelter.SetShelteredArmy(none);
	}

	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
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
	return mShelter.GetLocation();
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mHero.GetPlayer();
}
