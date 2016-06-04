/*=============================================================================
* H7TownMarketplace
* =============================================================================
*  Class for the in-town Marketplace.
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7TownMarketplace extends H7TownBuilding;

var(properties) protected H7TradingTable mTradingTable<DisplayName=Trading Table>;

function H7TradingTable GetTradingTable() {return mTradingTable;}
