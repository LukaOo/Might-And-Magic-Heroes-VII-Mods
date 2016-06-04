/*=============================================================================
* H7Merchant
* =============================================================================
*  Heroes can buy and sell items here
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7Merchant extends H7NeutralSite
	implements(H7ITooltipable)
	hidecategories(Defenses)
	dependson(H7ITooltipable)
	native;

/**Not more as six items!*/
var (properties) protected H7MultiRewardData mOfferData<DisplayName = "Defined Tier Offer Data">;   
var (properties) protected ETrigger mRefreshOffers<DisplayName=New Items To Offer>;
/**Filtering the itemlist by itemtype works only for the auto generated Itempool. The Override version needs to defined by hand */
var (properties) protected bool mEnableForbiddenItemTypeList <DisplayName ="Enable Forbidden Item Types List">;
var (properties) protected array <EItemType> mForbiddenItemType <DisplayName ="Forbidden Item Types">;

var protected float mBuyPriceMultiplicator;
var protected float mSellPriceMultiplicator;

var protected savegame array<int> mItemRandValues;
var protected savegame array<H7HeroItem> mCurrentItems;
var protected savegame array<bool> mUniqueItemSold;

function array <H7HeroItem> GetCurrentlyAvailableItems()    { return mCurrentItems; }
function       SetBuyPriceMultiplicator(float val)          { mBuyPriceMultiplicator = val; }
function       SetSellPriceMultiplicator(float val)         { mSellPriceMultiplicator = val; }
function float GetBuyPriceMultiplicator()                   { return GetModifiedStatByID(STAT_MERCHANT_BUY); }
function float GetSellPriceMultiplicator()                  { return GetModifiedStatByID(STAT_MERCHANT_SELL); }

native function EUnitType GetEntityType();
native function GetModifiersByID( out array<H7MeModifiesStat> outStats, Estat desiredStat, optional EOperationType checkForOperation1 = -1, optional EOperationType checkForOperation2 = -1, optional bool nextRound);


function TriggerEvents(ETrigger triggerEvent, bool forecast, optional H7EventContainerStruct container)
{
	if(triggerEvent == mRefreshOffers)
	{
		SetCurrentItems();
	}
	super.TriggerEvents(triggerEvent, forecast, container);
}

event InitAdventureObject()
{

	super.InitAdventureObject();
	
	class'H7AdventureController'.static.GetInstance().AddMerchant( self );

	if( !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
	{
		SetCurrentItems();
	}
}

function SetCurrentItems()
{
	local H7GameData gameData;
	local int i,rnd,j,k;
	local array<H7HeroItem> localItemList;
	local array<H7HeroItem> sortedItemList;
	local bool isForbidden;

	gameData = class'H7GameData'.static.GetInstance();

	//Random item from global list
	mCurrentItems.Length = 0;

	for(i = 0; i < mOfferData.RewardData.Length; i++)
	{
		//Create a random item, if there is nothing defined or the unique item is sold
		if(mOfferData.RewardData[i].Item == none || mUniqueItemSold[i] )
		{
			if(mOfferData.RewardData[i].ItemTier != ITIER_MINOR_MAJOR && mOfferData.RewardData[i].ItemTier != ITIER_ALL)
			{
				localItemList = gameData.GetItemList(mOfferData.RewardData[i].ItemTier, false);
			}
			else
			{
				localItemList = DefineItemTier(mOfferData.RewardData[i].ItemTier);
			}

			for(j = 0; j < localItemList.Length; j++)
			{
				if( mOfferData.RewardData[i].ItemType == localItemList[j].GetType()
					|| mOfferData.RewardData[i].ItemType == ITYPE_ALL )
				{
					if(mEnableForbiddenItemTypeList)
					{
						for( k = 0; k < mForbiddenItemType.Length; k++ )
						{
							if(mForbiddenItemType[k] == localItemList[j].GetType())
							{
								isForbidden = true;
							}
						}
					}

					if(!isForbidden)
					{
						sortedItemList.AddItem(localItemList[j]);
					}
					else
					{
						isForbidden = false;
					}
				}
			}

			rnd = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(sortedItemList.Length);
			mCurrentItems.AddItem(class'H7HeroItem'.static.CreateItem(sortedItemList[rnd]));
			sortedItemList.Length = 0;
		}
		else
		{
			mCurrentItems.AddItem(class'H7HeroItem'.static.CreateItem(mOfferData.RewardData[i].Item));
		}
	}
}

function array<H7HeroItem> DefineItemTier(ETier itemTier)
{
	local int rnd, i;
	local ETier electedTier;
	local H7GameData gameData;
	local bool noConsumables;

	gameData = class'H7GameData'.static.GetInstance();

	//If forbidden ignore that itemtier list
	for(i = 0; i < mForbiddenItemType.Length; i++)
	{
		if(mForbiddenItemType[i] == ITYPE_CONSUMABLE || mForbiddenItemType[i] == ITYPE_SCROLL)
		{
			noConsumables = true;
		}
	}

	if(itemTier == ITIER_MINOR_MAJOR)
	{
		rnd = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(2);
		electedTier = ETier(rnd);

		return gameData.GetItemList(electedTier, false);
	}

	if(itemTier == ITIER_ALL)
	{
		if(!noConsumables)
		{
			rnd = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(4);
			electedTier = ETier(rnd);

			return gameData.GetItemList(electedTier, false);
		}
		else
		{
			rnd = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(3);
			electedTier = ETier(rnd);

			return gameData.GetItemList(electedTier, false);
		}
	}
}

function OnVisit(out H7AdventureHero hero)
{
	super.OnVisit(hero);
	if(hero.GetPlayer().GetPlayerNumber() == class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetPlayerNumber())
	{
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetMerchantPopUpCntl().UpdateFromMerchant(hero, self);
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

	CheckForUniqueItem(itemToBuy);
	mCurrentItems[mCurrentItems.Find(itemToBuy)] = none;

	return itemToBuy;
}

function CheckForUniqueItem(H7HeroItem item)
{
	local int i;

	for(i = 0; i < mOfferData.RewardData.Length; i++)
	{
		if(mOfferData.RewardData[i].Item == item && mOfferData.RewardData[i].UniqueOffering)
		{
			//The unique item was bought
			mUniqueItemSold[i] = true;
		}
	}
}


function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;

	data.type = TT_TYPE_STRING;
	data.Title = GetName();
	data.Description = "<font size='#TT_BODY#'>" $ class'H7Loca'.static.LocalizeSave("TT_MERCHANT_DESC","H7ArtifactRecycler") $ "</font>";

	return data;
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

