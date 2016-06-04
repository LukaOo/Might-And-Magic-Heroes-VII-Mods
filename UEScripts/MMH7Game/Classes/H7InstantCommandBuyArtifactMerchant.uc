//=============================================================================
// H7InstantCommandBuyArtifactMerchant
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandBuyArtifactMerchant extends H7InstantCommandBase;

var private H7Merchant mMerchant;
var private H7AdventureHero mHero;
var private int mItemId;
var private int mBuyPriceMultiplicator;

function Init( H7AdventureHero hero, H7Merchant merchant, int itemId, int buyPriceMultiplicator )
{
	mHero = hero;
	mMerchant = merchant;
	mItemId = itemId;
	mBuyPriceMultiplicator = buyPriceMultiplicator;
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
	mMerchant = H7Merchant(eventManageable);	
	mItemId = command.IntParameters[2];
	mBuyPriceMultiplicator = command.IntParameters[3];
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_BUY_ARTIFACT_MERCHANT;
	command.IntParameters[0] = mHero.GetID();
	command.IntParameters[1] = mMerchant.GetID();
	command.IntParameters[2] = mItemId;
	command.IntParameters[3] = mBuyPriceMultiplicator;
	
	return command;
}

function Execute()
{
	local H7AdventureHud hud;
	local H7HeroItem itemToBuy;
	local H7EventContainerStruct eventContainer;

	itemToBuy = mMerchant.BuyItemByID(mItemID);
	if( itemToBuy==none )
	{
		return;
	}

	mHero.GetInventory().AddItemToInventoryComplete(itemToBuy);
	mHero.GetPlayer().GetResourceSet().ModifyCurrency(-itemToBuy.GetBuyPrice() * mBuyPriceMultiplicator, true);

	eventContainer.EffectContainer = itemToBuy;
	eventContainer.Targetable = mHero;
	itemToBuy.TriggerEvents( ON_RECEIVE_ITEM, false, eventContainer );
	mHero.TriggerEvents( ON_RECEIVE_ITEM, false, eventContainer );
	
	// notify gui
	if(mHero.GetPlayer().IsControlledByLocalPlayer())
	{
		hud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();
		if(hud.GetMerchantPopUpCntl().GetPopup().IsVisible())
		{
			hud.GetMerchantPopUpCntl().UpdateFromMerchant(mHero, mMerchant);
			
			;
			if(mHero.GetInventory().GetItemByID(itemToBuy.GetID()) != none)
				hud.GetMerchantPopUpCntl().GetMerchantPopUp().HighlightSlot(mHero.GetInventory().GetItemPosByItem(itemToBuy));
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
