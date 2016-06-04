//=============================================================================
// H7InstantCommandBuyScroll
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandBuyScroll extends H7InstantCommandBase;

var private H7Town mTown;
var private H7AdventureHero mHero;
var private int mScrollId;

function Init( H7AdventureHero hero, H7Town town, int scrollId )
{
	mHero = hero;
	mTown = town;
	mScrollId = scrollId;
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
	mTown = H7Town(eventManageable);	
	mScrollId = command.IntParameters[2];
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_BUY_SCROLL;
	command.IntParameters[0] = mHero.GetID();
	command.IntParameters[1] = mTown.GetID();
	command.IntParameters[2] = mScrollId;
	
	return command;
}

function Execute()
{
	local H7Inscriber inscriber;
	local H7HeroItem scrollToBuy;
	local H7EventContainerStruct eventContainer;
	local H7AdventureHud hud;

	inscriber = H7Inscriber(mTown.GetBuildingByType(class'H7Inscriber'));
	scrollToBuy = inscriber.BuyScrollByID(mScrollID);
	if(scrollToBuy == none) return;	

	mHero.GetInventory().AddItemToInventoryComplete(scrollToBuy);
	mHero.GetPlayer().GetResourceSet().ModifyCurrency(-scrollToBuy.GetBuyPrice(), true);

	eventContainer.EffectContainer = scrollToBuy;
	eventContainer.Targetable = mHero;
	scrollToBuy.TriggerEvents( ON_RECEIVE_ITEM, false, eventContainer );
	mHero.TriggerEvents( ON_RECEIVE_ITEM, false, eventContainer );

	// notify gui
	if(mTown.GetPlayer().IsControlledByLocalPlayer())
	{
		hud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();
		if(hud.GetInscriberCntl().GetPopup().IsVisible())
		{
			hud.GetInscriberCntl().BuyScrollComplete(mHero, scrollToBuy);
		}
	}
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mHero.GetPlayer();
}
