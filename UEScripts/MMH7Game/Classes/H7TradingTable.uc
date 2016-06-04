//=============================================================================
// H7TradingTable
//
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7TradingTable extends Object
		hidecategories(Object,Attachment,Collision,Physics,Advanced,Debug,Mobile,Movement);

var() protected array<TradingTableEntry> tradingTable<DisplayName=TradingTable>;

function array<TradingTableEntry> GetTradingTable() {return tradingTable;}

/**
 * Get the rate at wich you can exchange resourceToSell for resourceToBuy
 */
function int GetRate(H7Resource resourceToSell, H7Resource resourceToBuy, float trf) //trf = TradeRateFactor
{
	local int buyValue, sellValue;
	local TradingTableEntry entry;

	if(resourceToSell == resourceToBuy) return 0;

	foreach tradingTable(entry)
	{
		if(entry.Resource.GetTypeIdentifier() == resourceToSell.GetTypeIdentifier()) sellValue = entry.SellValue;
		if(entry.Resource.GetTypeIdentifier() == resourceToBuy.GetTypeIdentifier()) buyValue = entry.BuyValue;
		if(buyValue != 0 && sellValue != 0) break;
	}

	if(buyValue == 0 || sellValue == 0)
	{
		;
		return 0;
	}

	
	//calculate buyValue with trf
	buyValue = (trf * buyValue) / (5 * sellValue);
	return buyValue < 1 ? 1 : buyValue; 
}

/**
 * returns the amount of the current currency resource needed to buy one unit of the provided resource
 */
function int GetBuyValue(H7Resource resourceToBuy, float trf)
{
	local TradingTableEntry entry;
	local int buyValue;

	foreach tradingTable(entry)
	{
		if(entry.Resource == resourceToBuy) buyValue = entry.BuyValue;
	}
	
	if(buyValue == 0)
	{
		;
		return 0;
	}

	return buyValue * trf;
}

function int GetSellValue(H7Resource resourceToSell, float trf)
{
	local TradingTableEntry entry;
	local int sellValue;

	foreach tradingTable(entry)
	{
		if(entry.Resource == resourceToSell) sellValue = entry.SellValue;
	}
	
	if(sellValue == 0)
	{
		;
		return 0;
	}

	return sellValue / trf;
}
