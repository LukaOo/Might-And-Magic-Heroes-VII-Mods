//=============================================================================
// H7InstantCommandInventoryAction
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandInventoryAction extends H7InstantCommandBase;

var private H7HeroItem mItem;
var private EInventoryAction mAction;
var private H7AdventureHero mHero;
var private H7AdventureHero mOwner;
var private int mPosX;
var private int mPosY;
var private bool mUpdateGUI;

function Init( EInventoryAction action, H7AdventureHero hero, H7HeroItem item, int posX = -1, int posY = -1, optional bool updateGUI = false)
{
	local H7ICaster caster;

	mAction = action;
	mHero = hero;
	mItem = item;
	caster = item.GetOwner();
	mOwner = H7AdventureHero(caster);
	mPosX = posX;
	mPosY = posY;
	mUpdateGUI = updateGUI;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	mAction = EInventoryAction( command.IntParameters[0] );
	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[1] );
	mHero = H7AdventureHero(eventManageable);
	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[2] );	
	mitem = H7HeroItem(eventManageable);	
	mPosX = command.IntParameters[3];
	mPosY = command.IntParameters[4];
	if( command.IntParameters[5] != -1 )
	{
		eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[5] );
		mOwner = H7AdventureHero(eventManageable);
	}
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;
	local int itemOwnerId;

	itemOwnerId = mOwner != none ? mOwner.GetID() : -1;

	command.Type = ICT_INVENTORY_ACTION;
	command.IntParameters[0] = mAction;
	command.IntParameters[1] = mHero.GetID();
	command.IntParameters[2] = mItem.GetID();
	command.IntParameters[3] = mPosX;
	command.IntParameters[4] = mPosY;
	command.IntParameters[5] = itemOwnerId;
	
	return command;
}

function Execute()
{
	local H7EventContainerStruct eventContainer;

	if( mAction == IA_SET_ITEM_POS )
	{
		mHero.GetInventory().SetItemPosComplete( mItem.GetID(), mPosX, mPosY );
	}
	else if( mAction == IA_ADD_ITEM )
	{
		mHero.GetInventory().AddItemToInventoryComplete( mItem, mPosX, mPosY );
		eventContainer.EffectContainer = mItem;
		eventContainer.Targetable = mHero;
		mItem.TriggerEvents( ON_RECEIVE_ITEM, false, eventContainer );
		mHero.TriggerEvents( ON_RECEIVE_ITEM, false, eventContainer );
		// register the gift that recieved a hero of the localplayer
		if( mOwner != none && mOwner.GetPlayer() != mHero.GetPlayer() && mHero.GetPlayer().IsControlledByLocalPlayer() )
		{
			;
			class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTradeResultCntl().AddReceivedItem(mItem.GetID(), mHero, mOwner);
		}
		// unregister the gift that recieved a hero of the localplayer
		else if( mOwner != none && mOwner.GetPlayer() != mHero.GetPlayer() && mOwner.GetPlayer().IsControlledByLocalPlayer() )
		{
			;
			class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTradeResultCntl().RemoveReceivedItem(mItem.GetID(), mHero, mOwner);
		}
	}
	else if( mAction == IA_REMOVE_ITEM )
	{
		mHero.GetInventory().RemoveItemComplete( mItem );
	}
	else if( mAction == IA_EQUIP_ITEM )
	{
		mHero.GetEquipment().SetItemComplete( mItem );
	}
	else if( mAction == IA_UNEQUIP_ITEM )
	{
		mHero.GetEquipment().RemoveItemComplete( mItem );
	}
	mHero.ClearStatCache();
	mHero.DataChanged();
	if(mOwner != none) 
	{
		mOwner.ClearStatCache();
		mOwner.DataChanged();
	}

	if(mUpdateGUI)
	{
		if(class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetHeroWindowCntl().GetPopup().IsVisible())
			class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetHeroWindowCntl().Update(mHero.GetID());
	}
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	if(mOwner != none)
	{
		return mOwner.GetPlayer();
	}
	else
	{
		return mHero.GetPlayer();
	}
}
