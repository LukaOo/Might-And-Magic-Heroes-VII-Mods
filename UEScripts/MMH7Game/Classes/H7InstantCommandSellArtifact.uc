//=============================================================================
// H7InstantCommandSellArtifact
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandSellArtifact extends H7InstantCommandBase;

var private H7AdventureHero mHero;
var private int mItemId;
var private int mSellPriceMultiplicator;

function Init( H7AdventureHero hero, int itemId, int sellPriceMultiplicator )
{
	mHero = hero;
	mItemId = itemId;
	mSellPriceMultiplicator = sellPriceMultiplicator;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mHero = H7AdventureHero(eventManageable);
	mItemId = command.IntParameters[1];
	mSellPriceMultiplicator = command.IntParameters[2];
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_SELL_ARTIFACT;
	command.IntParameters[0] = mHero.GetID();
	command.IntParameters[1] = mItemId;
	command.IntParameters[2] = mSellPriceMultiplicator;
	
	return command;
}

function Execute()
{
	local H7AdventureHud hud;
	local H7HeroItem itemToSell;
	local array<H7HeroItem> items;


	itemToSell = mHero.GetInventory().GetItemByID(mItemId);

	if(itemToSell !=none)
	{
		if( itemToSell.IsEqual( class'H7AdventureController'.static.GetInstance().GetMapInfo().mTearOfAshaTemplate ) )
		{
			return;
		}
		mHero.GetInventory().RemoveItemComplete(itemToSell);
		class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetResourceSet().ModifyCurrency(itemToSell.GetSellPrice() * mSellPriceMultiplicator, true);

		// notify gui
		if(mHero.GetPlayer().IsControlledByLocalPlayer())
		{
			hud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();
			if(hud.GetMerchantPopUpCntl().GetPopup().IsVisible())
			{
				hud.GetMerchantPopUpCntl().GetInventory().Update(mHero.GetInventory().GetItems(), mHero);
				hud.GetMerchantPopUpCntl().GetMerchantPopUp().DisableHeroInventory();
			}
		}
		
		return;
	}

	itemToSell = mHero.GetEquipment().GetItemByID(mItemId);
	if(itemToSell != none)
	{
		if( itemToSell.IsEqual( class'H7AdventureController'.static.GetInstance().GetMapInfo().mTearOfAshaTemplate ) )
		{
			return;
		}
		mHero.GetEquipment().RemoveItem(itemToSell);
		mHero.GetEquipment().GetItemsAsArray(items);
		class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetResourceSet().ModifyCurrency(itemToSell.GetSellPrice() * mSellPriceMultiplicator, true);
		
		// notify gui
		if(mHero.GetPlayer().IsControlledByLocalPlayer())
		{
			hud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();
			if(hud.GetMerchantPopUpCntl().GetPopup().IsVisible())
			{
				hud.GetMerchantPopUpCntl().GetHeroEquip().Reset();
				hud.GetMerchantPopUpCntl().GetHeroEquip().Update(items, mHero.GetEquipment().GetRing1(), mHero);
				hud.GetMerchantPopUpCntl().UpdateFromSellCommand();
			}
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
