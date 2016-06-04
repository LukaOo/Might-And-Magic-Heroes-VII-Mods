//=============================================================================
// H7InstantCommandRecruitWarfare
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandRecruitWarfare extends H7InstantCommandBase;

var private H7Town mTown;
var private bool mIsAttackHybrid;
var private H7AdventureArmy mArmy;

function Init( H7Town town, bool isAttackHybrid, H7AdventureArmy army )
{
	mTown = town;
	mIsAttackHybrid = isAttackHybrid;
	mArmy = army;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mTown = H7Town(eventManageable);
	mIsAttackHybrid = bool(command.IntParameters[1]);
	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[2] );
	mArmy = H7AdventureHero(eventManageable).GetAdventureArmy();
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_RECRUIT_WARFARE;
	command.IntParameters[0] = mTown.GetID();
	command.IntParameters[1] = int(mIsAttackHybrid);
	command.IntParameters[2] = mArmy.GetHero().GetID();

	return command;
}

function Execute()
{
	local H7AdventureHud hud;
	local H7TownUtilityUnitDwelling building;
	local array<H7EditorWarUnit> killList;
	local H7EditorWarUnit killUnit;

	;

	building = mTown.GetBuildingWarfare( mIsAttackHybrid );
	
	if( building == none ) 
	{
		;
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("Warfare building not build" @ mIsAttackHybrid,MD_QA_LOG);;
	}

	if( building.CanHireWarUnit( mArmy ) )
	{
		killList = mArmy.GetWarUnitKillListWhenBuying(mIsAttackHybrid,mTown);
		foreach killList(killUnit)
		{
			mArmy.RemoveWarUnit(killUnit);
		}

		building.HireWarUnit( mArmy );
	}
	else
	{
		;
	}

	// notify gui
	if( mTown.GetPlayer().IsControlledByLocalPlayer() )
	{
		hud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();
		if( hud.GetTownWarfareCntl().GetPopup().IsVisible() )
		{
			hud.GetTownWarfareCntl().Update( mTown );
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
