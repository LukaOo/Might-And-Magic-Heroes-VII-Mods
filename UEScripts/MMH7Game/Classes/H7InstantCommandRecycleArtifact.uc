//=============================================================================
// H7InstantCommandTransferHero
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandRecycleArtifact extends H7InstantCommandBase;

var private H7Town mTown;
var private int mItemId;

function Init( H7Town town, int itemID )
{
	mTown = town;
	mItemId = itemID;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mTown = H7Town(eventManageable);
	mItemId = command.IntParameters[1];
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_RECYCLE_ARTIFACT;
	command.IntParameters[0] = mTown.GetID();
	command.IntParameters[1] = mItemId;

	return command;
}

function Execute()
{
	local H7HeroItem item;
	local H7AdventureHero hero;
	local array<H7ResourceQuantity> recycleValues;
	local float multiplier;
	local int i;
	local H7AdventureHud hud;
	local H7ArtifactRecyclingTable valueTable;

	if(mTown.GetGarrisonArmy().GetHero().IsHero())
	{
		hero = mTown.GetGarrisonArmy().GetHero();
		item = hero.GetInventory().GetItemByID(mItemId);
	}
	if(item == none && mTown.GetVisitingArmy() != none)
	{
		hero = mTown.GetVisitingArmy().GetHero();
		item = hero.GetInventory().GetItemByID(mItemId);
	}

	if(item == none)
	{
		;
		return;
	}

	hero.GetInventory().RemoveItemComplete(item);

	valueTable = H7ArtifactRecycler(mTown.GetBuildingByType(class'H7ArtifactRecycler')).GetRecyclingTable();
	recycleValues = valueTable.GetRecycleValueByType(item.GetType());
	multiplier = valueTable.GetMultiplierByTier(item.GetTier());

	for(i = 0; i < recycleValues.Length; i++)
	{
		hero.GetPlayer().GetResourceSet().ModifyResource(recycleValues[i].Type, recycleValues[i].Quantity * multiplier, true);
	}

	// notify gui
	if(mTown.GetPlayer().IsControlledByLocalPlayer())
	{
		hud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();
		if(hud.GetArtifactRecyclerCntl().GetPopup().IsVisible())
		{
			hud.GetArtifactRecyclerCntl().RecycleItemComplete(hero);
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
