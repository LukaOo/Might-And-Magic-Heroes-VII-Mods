//=============================================================================
// H7InstantCommandUpgradeUnit
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandUpgradeUnit extends H7InstantCommandBase;

var private H7VisitableSite mSite;
var private int mCount;
var private int mSlotID;
var private bool mIsVisitingArmy;


function Init( H7VisitableSite site, int slotID, bool isVisitingArmy, int count )
{
	mSite = site;
	mCount = count;
	mSlotID = slotID;
	mIsVisitingArmy = isVisitingArmy;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mSite = H7VisitableSite(eventManageable);
	mSlotID = command.IntParameters[1];
	mIsVisitingArmy = bool(command.IntParameters[2]);
	mCount = command.IntParameters[3];
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_UPGRADE_UNIT;
	command.IntParameters[0] = mSite.GetID();
	command.IntParameters[1] = mSlotID;
	command.IntParameters[2] = int(mIsVisitingArmy);
	command.IntParameters[3] = mCount;
	
	return command;
}

function Execute()
{
	local H7AdventureHud hud;
	local H7Player thePlayer;
	
	if(mSite.GetVisitingArmy() != none && mSite.GetPlayer() != mSite.GetVisitingArmy().GetPlayer())
		thePlayer = mSite.GetVisitingArmy().GetPlayer();
    else
		thePlayer = mSite.GetPlayer();
	
	if(mSite.IsA('H7AreaOfControlSiteLord')) H7AreaOfControlSiteLord(mSite).UpgradeUnitComplete(mSlotID, mIsVisitingArmy, mCount);
	else if(mSite.IsA('H7Dwelling')) H7Dwelling(mSite).UpgradeUnitComplete(mSlotID, true, mCount);
	else if(mSite.IsA('H7TrainingGrounds')) H7TrainingGrounds(mSite).UpgradeUnitComplete(mSlotID, true, mCount);

	// notify gui
	if(thePlayer.IsControlledByLocalPlayer() || mSite.IsA('H7NeutralSite'))
	{
		hud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();
		if(hud.GetTownHudCntl().GetMiddleHUD().IsVisible())
		{
			hud.GetTownHudCntl().UpdateHUD();
		}
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("UPGRADE_UNIT");
	}
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mSite.GetPlayer();
}
