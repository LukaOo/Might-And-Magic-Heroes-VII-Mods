//=============================================================================
// H7InstantCommandRecruit
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandRecruit extends H7InstantCommandBase;

var private H7AreaOfControlSiteLord mSite;
var private H7Dwelling mOriginDwelling;
var private H7AreaOfControlSite mCaravanTarget;
var private string mCreatureName;
var private int mCount;
var private bool mIsHiringFromAoC;
var private bool mRecruitToCaravan;
var private bool mRecruitToDwellingVisitor;
var private bool mUpdateGui;

function Init( H7AreaOfControlSiteLord site, string creatureName, int count, bool isHiringFromAoC, H7Dwelling originDwelling, bool recruitToCaravan, bool recruitToDwellingVisitor, H7AreaOfControlSite caravanTarget, bool updateGui  )
{
	mSite = site;
	mCreatureName = creatureName;
	mOriginDwelling = originDwelling;
	mCount = count;
	mIsHiringFromAoC = isHiringFromAoC;
	mRecruitToCaravan = recruitToCaravan;
	mRecruitToDwellingVisitor = recruitToDwellingVisitor;
	mCaravanTarget = caravanTarget;
	mUpdateGui = updateGui;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mSite = H7AreaOfControlSiteLord(eventManageable);
	mCreatureName = command.StringParameter;
	mCount = command.IntParameters[1];
	mIsHiringFromAoC = bool(command.IntParameters[2]);
	mRecruitToCaravan = bool(command.IntParameters[3]);
	mRecruitToDwellingVisitor = bool(command.IntParameters[4]);
	mUpdateGui = bool(command.IntParameters[7]);

	if(command.IntParameters[5] != -1)
	{
		eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[5] );
		mOriginDwelling = H7Dwelling(eventManageable);
	}

	if(command.IntParameters[6] != -1)
	{
		eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[6] );
		mCaravanTarget = H7AreaOfControlSite(eventManageable);
	}
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;
	local int dwellingId;
	local int caravanTargetId;

	dwellingId = mOriginDwelling != none ? mOriginDwelling.GetID() : -1;
	caravanTargetId = mCaravanTarget != none ? mCaravanTarget.GetID() : -1;

	command.Type = ICT_RECRUIT;
	command.StringParameter = mCreatureName;
	command.IntParameters[0] = mSite.GetID();
	command.IntParameters[1] = mCount;
	command.IntParameters[2] = int(mIsHiringFromAoC);
	command.IntParameters[3] = int(mRecruitToCaravan);
	command.IntParameters[4] = int(mRecruitToDwellingVisitor);
	command.IntParameters[5] = dwellingId;
	command.IntParameters[6] = caravanTargetId;
	command.IntParameters[7] = int(mUpdateGui);
	
	return command;
}

function Execute()
{
	local H7AdventureHud hud;
	local int slotIndex;
	local EArmyNumber targetArmy;

	mSite.RecruitComplete( mCreatureName, mCount, mIsHiringFromAoC, slotIndex, mOriginDwelling, targetArmy, mRecruitToCaravan, mRecruitToDwellingVisitor, mCaravanTarget );

	// notify gui
	if(!mUpdateGui) return;

	if(mSite.GetPlayer().IsControlledByLocalPlayer())
	{
		hud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();
		if(hud.GetTownRecruitmentCntl().GetPopup().IsVisible())
		{
			hud.GetTownRecruitmentCntl().RecruitUnitsComplete(mSite, slotIndex, targetArmy, mRecruitToCaravan);
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
