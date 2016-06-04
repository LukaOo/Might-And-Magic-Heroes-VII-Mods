/*=============================================================================
* H7BlackMarket
* =============================================================================
*  Reveals an area around the visiting hero.
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7BlackMarket extends H7TownBuilding
	hidecategories(Defenses)
	native
	savegame;

var (properties) protected bool mUseItemPoolOverride<DisplayName=Use item pool override>;
var (properties) protected array<H7HeroItem> mItemPoolOverride<DisplayName=Item Pool override>;
var (properties) protected ETrigger mRefreshOffers<DisplayName=New Items To Offer>;
/**Filtering the itemlist by itemtype works only for the auto generated Itempool. The Override version needs to defined by hand */
var (properties) protected bool mEnableForbiddenItemTypeList <DisplayName ="Enable Forbidden Item Types List">;
var (properties) protected array <EItemType> mForbiddenItemType <DisplayName ="Forbidden Item Types">;

var protected savegame array<H7HeroItem> mItemPool;
var protected float mBuyPriceMultiplicator;
var protected float mSellPriceMultiplicator;

var protected savegame array<int> mItemRandValues;
var protected savegame array<H7HeroItem> mCurrentItems;

native function EUnitType GetEntityType();
native function GetModifiersByID( out array<H7MeModifiesStat> outStats, Estat desiredStat, optional EOperationType checkForOperation1 = -1, optional EOperationType checkForOperation2 = -1, optional bool nextRound);

function array <H7HeroItem> GetCurrentlyAvailableItems()    { return mCurrentItems; }
function       SetBuyPriceMultiplicator(float val)          { mBuyPriceMultiplicator = val; }
function       SetSellPriceMultiplicator(float val)         { mSellPriceMultiplicator = val; }
function float GetBuyPriceMultiplicator()                   { return GetModifiedStatByID(STAT_MERCHANT_BUY); }
function float GetSellPriceMultiplicator()                  { return GetModifiedStatByID(STAT_MERCHANT_SELL); }

function TriggerEvents(ETrigger triggerEvent, bool forecast, optional H7EventContainerStruct container)
{
	if(triggerEvent == mRefreshOffers)
	{
		SetCurrentItems();
	}
	super.TriggerEvents(triggerEvent, forecast, container);
}

function InitTownBuilding(H7Town town)
{
	local H7GameData gameData;
	local int i,j;
	local array<H7HeroItem> localItemList;
	local H7HeroItem item;

	super.InitTownBuilding( town );

	gameData = class'H7GameData'.static.GetInstance();

	mItemPool.Length = 0;

	
	for(i = 0; i < ITIER_MAX; i++)
	{
		localItemList = gameData.GetItemList(ETier(i), false);

		for(j = 0; j < localItemList.Length; j++)
		{
			if(localItemList[i].IsStackable()) continue;
			mItemPool.AddItem(localItemList[j]);
		}
	}

	if(mEnableForbiddenItemTypeList)
	{
		for(i= 0; i <mForbiddenItemType.Length; i++)
		{
			foreach mItemPool(item)
			{
				if(item.GetType() == mForbiddenItemType[i])
				{
					mItemPool.RemoveItem(item);
				}
			}
		}
	}
	
	SetCurrentItems();
}

function SetCurrentItems()
{
	local int i, j, currentHighestRandValue, currentHighestRandValueIndex;
	local array<H7HeroItem> itemPoolToUse;
	currentHighestRandValue = 0;

	itemPoolToUse = mUseItemPoolOverride ? mItemPoolOverride : mItemPool;

	//generate the random values for items
	mItemRandValues.Length = itemPoolToUse.Length;
	for(i = 0; i < itemPoolToUse.Length; i++)
	{
		mItemRandValues[i] += class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(100);			
	}
	
	//select items for sale by their random value
	for(i = 0; i < 6; i++)
	{
		for(j = 0; j < itemPoolToUse.Length; j++)
		{
			if(mItemRandValues[j] > currentHighestRandValue)
			{
				currentHighestRandValue = mItemRandValues[j];
				currentHighestRandValueIndex = j;
			}
		}

		mCurrentItems[i] = class'H7HeroItem'.static.CreateItem( itemPoolToUse[currentHighestRandValueIndex] );
		//give scroll another randValue so it could come up again
		mItemRandValues[currentHighestRandValueIndex] = 0;
		;
		currentHighestRandValue = 0;
		currentHighestRandValueIndex = 0;
	}
}

function H7HeroItem GetItemByID(int id)
{
	local H7HeroItem item;

	foreach mCurrentItems(item)
	{
		if(item.GetID() == id) return item;
	}

	;
	return none;
}

function H7HeroItem BuyItemByID(int id)
{
	local H7HeroItem itemToBuy;

	itemToBuy = GetItemByID(id);
	if(itemToBuy == none) return none;

	mCurrentItems[mCurrentItems.Find(itemToBuy)] = none;
	return itemToBuy;
}


function float GetModifiedStatByID(Estat desiredStat)
{
	local float statBase,statAdd,statMulti;

	statBase = GetBaseStatByID(desiredStat);
	statAdd =  GetAddBoniOnStatByID(desiredStat);
	statMulti = GetMultiBoniOnStatByID(desiredStat);

	//	`log_uss(desiredStat @ "(" @ statBase @ "+" @ statAdd @ ") *" @ statMulti);
	return ( statBase + statAdd ) * statMulti;
}


/** @param desiredStat Stat that will be affected
 *  @return Sum of additive modifications, coming from abilities, buffs etc.
 */
function float GetAddBoniOnStatByID(Estat desiredStat)
{
	local float modifierSum;

	local H7MeModifiesStat currentMod;
	local array<H7MeModifiesStat> applicableMods;
	GetModifiersByID(applicableMods, desiredStat, OP_TYPE_ADD);
	foreach applicableMods(currentMod)
	{
		modifierSum += currentMod.mModifierValue;
	}

	return modifierSum;
}

/** @param desiredStat Stat that will be affected
 *  @return Sum of percentages in modifications, where 50% extra means 1.5f
 */
function float GetMultiBoniOnStatByID(Estat desiredStat)
{
	local float modifierSum;

	local H7MeModifiesStat currentMod;
	local array<H7MeModifiesStat> applicableMods;	
	GetModifiersByID(applicableMods, desiredStat, OP_TYPE_ADDPERCENT, OP_TYPE_MULTIPLY);
	modifierSum = 1; 

	foreach applicableMods(currentMod)
	{
		
		if(currentMod.mCombineOperation == OP_TYPE_ADDPERCENT)
		{
			modifierSum += modifierSum * currentMod.mModifierValue * 0.01f;
		} 
		else if(currentMod.mCombineOperation == OP_TYPE_MULTIPLY)
		{
			modifierSum *= currentMod.mModifierValue;
		}
	}
	return modifierSum;
}

//Base Stats
function float GetBaseStatByID(Estat desiredStat)
{
	switch(desiredStat)
	{
		case STAT_MERCHANT_BUY: 
			return mBuyPriceMultiplicator;
		case STAT_MERCHANT_SELL:
			return mSellPriceMultiplicator;
	}
	return 0;
}

