//=============================================================================
// H7InstantCommandUseFertilityIdol
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandUseFertilityIdol extends H7InstantCommandBase;

var private H7Town mTown;
var private int mDwellingId;

function Init( H7Town town, int dwellingId )
{
	mTown = town;
	mDwellingId = dwellingId;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mTown = H7Town(eventManageable);

	mDwellingId = command.IntParameters[1];
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_USE_FERTILITY_IDOL;
	command.IntParameters[0] = mTown.GetID();
	command.IntParameters[1] = mDwellingId;
	return command;
}

function Execute()
{
	local H7AdventureHud hud;
	local array<H7TownBuildingData> dwellings;	

	mTown.GetDwellings( dwellings );
	H7TownIdolOfFertility( mTown.GetBuildingByType( class'H7TownIdolOfFertility') ).AddGrowthToPool(H7TownDwelling(dwellings[ mDwellingId ].Building));

	if(mTown.GetPlayer().IsControlledByLocalPlayer())
	{
		hud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();
		if(hud.GetTownRecruitmentCntl().GetPopup().IsVisible())
		{
			hud.GetTownRecruitmentCntl().UpdateFromLord(mTown);
		}
	}
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mTown.GetPlayer();
}
