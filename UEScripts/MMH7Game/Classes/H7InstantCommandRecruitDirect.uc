//=============================================================================
// H7InstantCommandRecruitDirect
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandRecruitDirect extends H7InstantCommandBase;

var private H7Dwelling mDwelling;
var private H7CustomNeutralDwelling mCustomDwelling;
var private string mCreatureName;
var private int mCount;
var private H7Player mPlayerRequester;

function Init(string creatureName, int count, optional H7Dwelling dwelling)
{
	mCreatureName = creatureName;

	if(dwelling != none)
	{
		mDwelling = dwelling;
	}

	mCount = count;

	mPlayerRequester = class'H7AdventureController'.static.GetInstance().GetLocalPlayer();
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mDwelling = H7Dwelling(eventManageable);
	mCount = command.IntParameters[1];
	mCreatureName = command.StringParameter;
	mPlayerRequester = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( EPlayerNumber(command.IntParameters[2]) );
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_RECRUIT_DIRECT;
	command.StringParameter = mCreatureName;
	command.IntParameters[0] = mDwelling.GetID();
	command.IntParameters[1] = mCount;
	command.IntParameters[2] = mPlayerRequester.GetPlayerNumber();

	return command;
}

function Execute()
{
	local H7AdventureHud hud;
	local int slotIndex;

	mDwelling.Recruit(mCreatureName, mCount, slotIndex);

	// notify gui
	;
	if(mDwelling.GetPlayer().IsControlledByLocalPlayer() || (mDwelling.GetVisitingArmy() != none && mDwelling.GetVisitingArmy().GetPlayer().IsControlledByLocalPlayer()))
	{
		hud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();
		if(hud.GetTownRecruitmentCntl().GetPopup().IsVisible())
		{
			hud.GetTownRecruitmentCntl().RecruitUnitsComplete(none, slotIndex, ARMY_NUMBER_VISIT, false);
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
	return mDwelling.GetSite().GetLocation();
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mPlayerRequester;
}
