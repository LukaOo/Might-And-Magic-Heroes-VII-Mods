//=============================================================================
// H7GFxMarketPlacePopup
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxMarketPlacePopup extends H7GFxTownPopup;

function Update(H7Town town, optional H7TradingPost post)
{
	local GFxObject mData, tradeTables, tradeTable, table, entry, playerResources, resource; 
	local int i, j;
	local float trf; // TradeRateFactor
	local H7TradingTable tradingTable;
	local array<ResourceStockpile> resses;
	local H7Resource currencyResource;
	local ResourceStockpile pile1, pile2;

	if(town != none)
		tradingTable = H7TownMarketPlace(town.GetBuildingByType(class'H7TownMarketplace')).GetTradingTable();
	else
		tradingTable = post.GetTradingTable();

	i = 1; j = 1;

	if(tradingTable == none)
	{
		;
		return;
	}
	resses = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetResourceSet().GetAllResourcesAsArray();
	currencyResource = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetResourceSet().GetCurrencyResourceType();
	
	mData = CreateObject("Object");
	mData.SetString("CurrencyResourceName", currencyResource.GetName());
	tradeTables = CreateArray();

	trf = calculateTradeRateFactor(post != none ? true : false );

	addCurrencyTradeTable(resses,currencyResource, tradingTable, trf, tradeTables);

	foreach resses(pile1)
	{
		if(pile1.Type == currencyResource) continue;
		tradeTable = CreateObject("Object");
		table = CreateArray();
		tradeTable.SetString("TableName", pile1.Type.GetName());
		//`log_gui("sellres " $ pile1.Type.GetName());
		j = 1;
		
		addCurrencyTradeEntry(pile1.Type, currencyResource, tradingTable, trf, table);

		foreach resses(pile2)
		{
			if(pile2.Type == currencyResource) continue;
			entry = CreateObject("Object");
			entry.SetString("Name", pile2.Type.GetName());
			entry.SetString("ArchetypeID", pile2.Type.GetIDString());
			entry.SetInt("Rate", tradingTable.GetRate(pile1.Type, pile2.Type, trf));
			entry.SetString("ResIcon", pile2.Type.GetIconPath());
			entry.SetString("RateStr", pile1.Type == pile2.Type ? "--:-" : entry.GetInt("Rate") $ ":1");
			table.SetElementObject(j, entry);
			j++;
		}
		tradeTable.SetObject("Table", table);
		tradeTables.SetElementObject(i,tradeTable);
		i++;
	}

	mData.SetObject("TradeTables", tradeTables);
	i = 1;
	playerResources = CreateArray();
	
	foreach resses(pile1)
	{
		resource = CreateObject("Object");
		resource.SetString("Name", pile1.Type.GetName()); 
		resource.SetString("ArchetypeID", pile1.Type.GetIDString());
		resource.SetInt("Amount", pile1.Quantity);
		resource.SetString("ResIcon", pile1.Type.GetIconPath());
		//set currencyResource Data at index 0
		playerResources.SetElementObject(pile1.Type == currencyResource ? 0 : i, resource);
		i++;
	}
	
	mData.SetObject("PlayerResources", playerResources);
	mData.SetFloat("TRF", trf);
	mData.SetInt("AmountMarketPlaces", getAmountMarketPlaces());
	if(town != none)
		mData.SetString("FactionIcon", town.GetFaction().GetFactionSepiaIconPath());
	else
		mData.SetString("FactionIcon", post.GetFactionSepiaIconPath());

	mData.SetBool("TradingPost", post != none ? true : false);
	SetObject("mData", mData);

	if(town != none) SetTransferData(playerResources, town);
	
	ActionscriptVoid("Update");

	if(town != none)
	{
		SetCaravanData(town);
		ListenTo(town);
	}
}

function SetTransferData(GFxObject playerResources, H7Town town)
{
	local GFxObject transferData;
	local array<H7Player> allies;
	local H7Player ally;
	local GFxObject alliesObj, allyObj, colorObj;
	local int i;

	//TransferData
	transferData = CreateObject("Object");
	alliesObj = CreateArray();
	transferData.SetObject("PlayerResources", playerResources);

	if(class'H7AdventureController'.static.GetInstance().GetTeamTrade())
	{
		i = 0;
		allies = class'H7AdventureController'.static.GetInstance().GetTeamManager().GetAllAlliesOf( town.GetPlayer() );
		;
		foreach allies(ally)
		{
			//{Name:"Khalid",  Icon:"", IsDefeated:false, Number:1, ID:34, Color:{r:255, g:96, b:0}},
			allyObj = CreateObject("Object");
			allyObj.SetString("Name", ally.GetName());
			allyObj.SetString("Icon", ally.GetFaction().GetFactionSepiaIconPath());
			allyObj.SetBool("IsDefeated", ally.GetStatus() == PLAYERSTATUS_QUIT ? true : false);
			allyObj.SetInt("Number", ally.GetPlayerNumber());
			allyObj.SetInt("ID", ally.GetID());
			colorObj = CreateObject("Object");
			colorObj.SetInt("r", ally.GetColor().R);
			colorObj.SetInt("g", ally.GetColor().G);
			colorObj.SetInt("b", ally.GetColor().B);
			allyObj.SetObject("Color", colorObj);
			alliesObj.SetElementObject(i, allyObj);
			i++;
		}
	}

	if(town != none)
		transferData.SetString("FactionIcon", town.GetFaction().GetFactionSepiaIconPath());

	transferData.SetObject("AlliedPlayers", alliesObj);
	SetObject("mTransferData", transferData);
}

function SetCaravanData(H7Town town)
{
	local GFxObject list,element;
	local int i;
	local array<ArrivedCaravan> arrivedCaravans;
	local ArrivedCaravan caravan;

	arrivedCaravans = town.GetArrivedCaravans();

	;

	list = CreateArray();
	i = 0;
	foreach arrivedCaravans(caravan)
	{
		element = CreateCaravanObjectFromData(caravan);
		
		list.SetElementObject(i,element);
		i++;
	}

	SetObject("mCaravanData", list);
	ActionscriptVoid("CaravanUpdate");
}

function ListenUpdate(H7IGUIListenable gameEntity)
{
	local H7Town town;
	town = H7Town(gameEntity);

	;

	// SetMarketData
	SetCaravanData(town);
}

function addCurrencyTradeTable(array<ResourceStockpile> resses, H7Resource currency, H7TradingTable tradingTable, float trf, out GFxObject tradeTables)
{
	local GFxObject tradeTable, table, entry;
	local int j;
	local ResourceStockpile pile;
	j = 0;

	tradeTable = CreateObject("Object");
	table = CreateArray();
	tradeTable.SetString("TableName", currency.GetName());
	;

	//add currency rate first
	entry = CreateObject("Object");
	entry.SetString("Name", currency.GetName());
	entry.SetString("ArchetypeID", currency.GetIDString());
	entry.SetString("ResIcon", currency.GetIconPath());
	entry.SetString("RateStr", "--:-");
	table.SetElementObject(0, entry);
	j++;

	foreach resses(pile)
	{
		if(pile.Type == currency) continue;
		entry = CreateObject("Object");
		entry.SetString("Name", pile.Type.GetName());
		entry.SetString("ArchetypeID", pile.Type.GetIDString());
		entry.SetInt("Rate", tradingTable.GetBuyValue(pile.Type, trf));
		entry.SetString("ResIcon", pile.Type.GetIconPath());
		//rateValues = marketPlace.GetTradingTable().GetMinimumGiveAndGetAmount(currency, pile.Type, trf);
		entry.SetString("RateStr", entry.GetInt("Rate") $ ":1");
		table.SetElementObject(j, entry);
		j++;
		//`log_gui("rate: " $ pile.Type.GetName() $ " " $ marketPlace.GetTradingTable().GetRate(currency, pile.Type));
	}
	tradeTable.SetObject("Table", table);
	tradeTables.SetElementObject(0,tradeTable);
}

function addCurrencyTradeEntry(H7Resource resource, H7Resource currencyResource, H7TradingTable tradingTable, float trf, out GFxObject table)
{
	local GFxObject entry;
	
	entry = CreateObject("Object");
	entry.SetString("Name", currencyResource.GetName());
	entry.SetString("ArchetypeID", currencyResource.GetIDString());
	entry.SetInt("Rate", tradingTable.GetSellValue(resource, trf));
	entry.SetString("ResIcon", currencyResource.GetIconPath());
	entry.SetString("RateStr", "1:" $ int(entry.GetFloat("Rate")));
	table.SetElementObject(0, entry);
}

function float calculateTradeRateFactor(bool tradingPostBuff)
{
	local H7AdventureHero hero;
	local int numMarketPlaces, heroesAddRate;
	local float heroesMultRate;
	local array<H7AdventureHero> heroes;
	local float globalTradeModifier;
	heroesMultRate = 1.0f;
	globalTradeModifier = class'H7AdventureController'.static.GetInstance().GetGlobalTradeModifier();
	heroes = class'H7AdventureController'.static.GetInstance().GetLocalPlayerHeroes();
	foreach heroes( hero )
	{
		heroesAddRate += hero.GetAddBoniOnStatByID(STAT_TRADE_RATE_BONUS);
		
		heroesMultRate *= hero.GetMultiBoniOnStatByID( STAT_TRADE_RATE_BONUS );

		;

	}
	
	numMarketPlaces = getAmountMarketPlaces() + tradingPostBuff ? 2 : 0;

	;
	;
	;
	;
	return FClamp( ( ( 2.0f / ( numMarketPlaces + heroesAddRate + 1.0f ) ) - ( heroesMultRate - 1.0f ) ) * globalTradeModifier , 0.29f, 10.0f );
}

function int getAmountMarketPlaces()
{
	local array<H7Town> towns;
	local H7Town town;
	local int numMaketPlaces;
	local array<H7TownBuildingData> buildings;
	local H7TownBuildingData building;

	towns = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetTowns();

	foreach towns(town)
	{
		buildings = town.GetBuildings();
		foreach buildings(building)
		{
			if(building.Building.IsA('H7TownMarketplace')) numMaketPlaces++;
		}
	}
	return numMaketPlaces;
}
