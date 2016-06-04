//=============================================================================
// H7MerchantPopUpCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7MerchantPopUpCntl extends H7ItemSlotMovieCntl; 

var protected H7GFxMerchantPopUp mMerchantPopUp;
var protected H7GFxUIContainer mHeroInfo;

var protected H7Merchant mMerchant;
var protected H7BlackMarket mMarket;
var protected H7Town mTown;
var float mBuyPriceMultiplicator;
var float mSellPriceMultiplicator;

function H7Merchant GetMerchant() {return mMerchant;}
function H7GFxInventory GetInventory() {return mInventory;}
function H7GFxHeroEquip GetHeroEquip() {return mHeroEquip;}
function H7GFxMerchantPopUp GetMerchantPopUp() {return mMerchantPopUp;}
function H7GFxUIContainer GetPopUp() {return mMerchantPopUp;}

function float GetBuyPriceMultiplicator() {return mBuyPriceMultiplicator;}
function float GetSellPriceMultiplicator() {return mSellPriceMultiplicator;}

function bool Initialize()
{
	;
	Super.Start();
	AdvanceDebug(0);

	mMerchantPopUp = H7GFxMerchantPopUp(mRootMC.GetObject("aMerchantPopUp", class'H7GFxMerchantPopUp'));
	mHeroInfo = H7GFxUIContainer(mMerchantPopUp.GetObject("mHeroInfo", class'H7GFxUIContainer'));

	mHeroEquip = H7GFxHeroEquip(mMerchantPopUp.GetObject("aHeroEquip", class'H7GFxHeroEquip'));
	mInventory = H7GFxInventory(mMerchantPopUp.GetObject("aInventory", class'H7GFxInventory'));
	
	mMerchantPopUp.SetVisibleSave(false);

	Super.Initialize();
	return true;
}

function UpdateFromMerchant(H7AdventureHero hero, H7Merchant merchant)
{
	local H7HeroItem ring;
	local array<H7HeroItem> items;

	mCurrentHero = hero;
	mMerchant = merchant;

	mBuyPriceMultiplicator = mMerchant.GetBuyPriceMultiplicator();
	mSellPriceMultiplicator = mMerchant.GetSellPriceMultiplicator();

	if(hero.GetEquipment().GetRing1() != none) ring = hero.GetEquipment().GetRing1();
	hero.GetEquipment().GetItemsAsArray(items);
	mHeroEquip.Update(items, ring, hero);
	mInventory.Update(hero.GetInventory().GetItems(), hero);
	mMerchantPopUp.UpdateFromMerchant(hero, merchant);

	mMerchantPopUp.SetVisibleSave(true);
	OpenPopup();

	H7AdventureHud( GetHud() ).GetAdventureHudCntl().GetCommandPanel().SetTownMode(true);
	H7AdventureHud( GetHud() ).BlockFlashBelow(H7AdventureHud( GetHud() ).GetAdventureHudCntl());
}

function Update(H7Town town) //from BlackMarket
{
	local H7HeroItem ring;
	local array<H7HeroItem> items;

	mTown = town;
	mMarket = H7BlackMarket( town.GetBuildingByType(class'H7BlackMarket') );
		
	if(town.GetVisitingArmy() != none && mCurrentHero == none)
		mCurrentHero = town.GetVisitingArmy().GetHero();
	else if(town.GetGarrisonArmy() != none && town.GetGarrisonArmy().GetHero() != none && mCurrentHero == none)
		mCurrentHero = town.GetGarrisonArmy().GetHero();

	mBuyPriceMultiplicator = mMarket.GetBuyPriceMultiplicator();
	mSellPriceMultiplicator = mMarket.GetSellPriceMultiplicator();

	;

	if(mCurrentHero != none)
	{
		if(mCurrentHero.GetEquipment().GetRing1() != none) ring = mCurrentHero.GetEquipment().GetRing1();
		mCurrentHero.GetEquipment().GetItemsAsArray(items);
		mHeroEquip.Update(items, ring, mCurrentHero);
		mInventory.Update(mCurrentHero.GetInventory().GetItems(), mCurrentHero);
	}

	//to avoid none errors
	if(town.GetVisitingArmy() != none && town.GetGarrisonArmy() != none && town.GetGarrisonArmy().GetHero() != none)
		mMerchantPopUp.UpdateFromBlackMarket(mMarket, town.GetGarrisonArmy().GetHero(), town.GetVisitingArmy().GetHero());
	else if(town.GetVisitingArmy() != none)
		mMerchantPopUp.UpdateFromBlackMarket(mMarket, none, town.GetVisitingArmy().GetHero());
	else if(town.GetGarrisonArmy() != none && town.GetGarrisonArmy().GetHero() != none)
		mMerchantPopUp.UpdateFromBlackMarket(mMarket, town.GetGarrisonArmy().GetHero(), none);
	else
		mMerchantPopUp.UpdateFromBlackMarket(mMarket);

	mMerchantPopUp.SetVisibleSave(true);
	OpenPopup();
	class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().GetTownInfo().SetVisibleSave(false);

}

function UpdateFromSellCommand()
{
	if(mTown != none)
		Update(mTown);
	else
		UpdateFromMerchant(mCurrentHero, mMerchant);
}

// called when clicking on a heroSlot
public function ShowHeroItems(bool garrisonHeroItems)
{
	if(garrisonHeroItems)
	{
		mCurrentHero = mTown.GetGarrisonArmy().GetHero();
		mInventory.Update(mTown.GetGarrisonArmy().GetHero().GetInventory().GetItems(), mCurrentHero);
	}
	else
	{
		mCurrentHero = mTown.GetVisitingArmy().GetHero();
		mInventory.Update(mTown.GetVisitingArmy().GetHero().GetInventory().GetItems(), mCurrentHero);
	}
}

// SELLING

function int GetItemSellPriceByID(int itemID)
{
	if(mCurrentHero.GetInventory().GetItemByID(itemID) != none)
		return mCurrentHero.GetInventory().GetItemByID(itemID).GetSellPrice() * mSellPriceMultiplicator;
	else
		return mCurrentHero.GetEquipment().GetItemByID(itemID).GetSellPrice() * mSellPriceMultiplicator;
}

function BtnSellClicked( int itemToSellID)
{
	local H7HeroItem item;
	local H7InstantCommandSellArtifact command;

	item = mCurrentHero.GetInventory().GetItemByID(itemToSellID);
    if(item != none && item.IsStoryItem())
    {
		return;
	}
	
	command = new class'H7InstantCommandSellArtifact';
	command.Init( mCurrentHero, itemToSellID, mSellPriceMultiplicator );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}


// BUYING

function bool CanSpend(int itemID)
{
	local H7ResourceQuantity quan;

	quan.Type = class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetResourceSet().GetCurrencyResourceType();

	if(mMerchant != none)
	{
		quan.Quantity = mMerchant.GetItemByID(itemID).GetBuyPrice() * mBuyPriceMultiplicator;
	}
	else
	{
		quan.Quantity = mMarket.GetItemByID(itemID).GetBuyPrice() * mBuyPriceMultiplicator;
	}

	 return class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetResourceSet().CanSpendResource(quan);
}

function BtnBuyClicked(int itemID)
{
	local H7InstantCommandBuyArtifactMerchant commandMerchant;
	local H7InstantCommandBuyArtifactBlackMarket commandBlackMarket;

	
	if(mMerchant != none)
	{
		commandMerchant = new class'H7InstantCommandBuyArtifactMerchant';
		commandMerchant.Init( mCurrentHero, mMerchant, itemID, mBuyPriceMultiplicator );
		class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( commandMerchant );
	}
	else 
	{
		commandBlackMarket = new class'H7InstantCommandBuyArtifactBlackMarket';
		commandBlackMarket.Init( mCurrentHero, mTown, itemID, mBuyPriceMultiplicator );
		class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( commandBlackMarket );
	}
}

// actualy that method should be name 'itemSlotDoubleClicked'...
function bool EquipItemByDoubleClick(int itemID)
{
	local H7HeroItem item;
	local H7ResourceQuantity cost;
	cost.Type = mCurrentHero.GetPlayer().GetResourceSet().GetCurrencyResourceType();

	;
		
	item = mCurrentHero.GetInventory().GetItemByID(itemID);
    if(item != none)
	{
		//item in inventory was double clicked so we want to sell it
		BtnSellClicked(itemID);
		return true;
	}

	item = mMerchant.GetItemByID(itemID);
	if(item != none)
	{
		cost.Quantity = item.GetBuyPrice() * mBuyPriceMultiplicator;
		if(mCurrentHero.GetPlayer().GetResourceSet().CanSpendResource(cost))
		{
			BtnBuyClicked(itemID);
			return true;
		}
		return false;
	}
	return false;
}

function ClosePopUp()
{
	super.ClosePopup();
	H7AdventureHud( GetHud() ).GetAdventureHudCntl().GetCommandPanel().SetTownMode(false);

	if(mTown != none) class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().TownPopupWasClosed(self);
	
	mMerchant = none;
	mMarket = none;
	mTown = none;

	mCurrentHero = none;
}

function GetStatModSourceList(String statStr,int unrealID)
{
	local H7Unit unit;
	local EStat stat;
	local array<H7StatModSource> mods;
	local int i;

	;

	unit = mCurrentHero;

	for(i=0;i<=STAT_MAX;i++)
	{
		stat = EStat(i);
		if(String(stat) == statStr)
		{
			break;
		}
	}

	// special redirects
	if(statStr == "DAMAGE") stat = STAT_MIN_DAMAGE; 
	if(statStr == "STAT_MOVEMENT_TYPE") stat = STAT_MAX_MOVEMENT;

	if(stat == STAT_MAX)
	{
		;
		return;
	}

	;

	mods = unit.GetStatModSourceList(stat);

	mHeroInfo.SetStatModSourceList(mods);
}

