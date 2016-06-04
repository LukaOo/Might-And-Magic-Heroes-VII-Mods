//=============================================================================
// H7GFxInscriberPopup
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxInscriberPopup extends H7GFxTownPopup;

function Update(H7AdventureHero garrisonHero, H7AdventureHero visitingHero, H7TownBuilding inscriber, bool garrisonHeroSelected)
{
	local GFxObject garrisonHeroObj, visitingHeroObj, items, itemObj, scrollsObj, playerColor;
	local H7HeroItem item, scroll;
	local IntPoint itemPos;
	local int i;
	local array<H7HeroItem> inventoryItems;
	local H7AdventureHero hero;
	local array<H7HeroItem> scrolls;

	garrisonHeroObj = CreateObject("Object");
	visitingHeroObj = CreateObject("Object");

	if(garrisonHero != none)
	{
		garrisonHero.GUIWriteInto(garrisonHeroObj);
		;
	}

	if(visitingHero != none)
	{
		visitingHero.GUIWriteInto(visitingHeroObj);
		;
	}
	
	//by parameters we want to show visiting heroes inventory but there is none so we show garrison heros inventory
	if(visitingHero == none && !garrisonHeroSelected)
		hero = garrisonHero;
	else if(!garrisonHeroSelected)
		hero = visitingHero;
	else
		hero = garrisonHero;

	items = CreateArray();
	if(hero != none)
	{
		inventoryItems = hero.GetInventory().GetItems();
		ForEach inventoryItems(item, i)
		{
			itemPos = hero.GetInventory().GetItemPosByIndex(i);
			;
			itemObj = CreateItemObject(item, hero, itemPos);
			items.SetElementObject(i, itemObj);
		}
		;
	}
	scrolls = H7Inscriber(inscriber).GetCurrentlyAvailableScrolls();
	scrollsObj = CreateArray();
	;
	ForEach scrolls(scroll, i)
	{
		itemPos = H7Inscriber(inscriber).GetScrollPosByIndex(i);
		if(scroll == none) itemObj = CreateObject("Object");
        else itemObj = CreateItemObject(scroll, none, itemPos);
		scrollsObj.SetElementObject(i, itemObj);
	}
	
	SetString("mInscriberName", inscriber.GetName());
	SetObject("mGarrisonHero", garrisonHeroObj);
	SetObject("mVisitingHero", visitingHeroObj);
	SetObject("mItems", items);
	SetObject("mScrolls", scrollsObj);

	playerColor = CreateObject("Object");
	playerColor.SetInt( "PlayerColorR", hero.GetPlayer().GetColor().R);
	playerColor.SetInt( "PlayerColorG", hero.GetPlayer().GetColor().G);
	playerColor.SetInt( "PlayerColorB", hero.GetPlayer().GetColor().B);

	SetObject("mPlayerColor", playerColor);

	ActionscriptVoid("Update");
}
 
function SetScrollCost(int cost)
{
	local H7ResourceQuantity quan;

	quan.Type = class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetResourceSet().GetCurrencyResourceType();
	quan.Quantity = cost;
	
	SetInt("mCurrentScrollCost", cost);
	SetString("mGoldIcon", class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetResourceSet().GetCurrencyResourceType().GetIconPath());
	SetBool("mCanBuy", class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetResourceSet().CanSpendResource(quan));
	ActionScriptVoid("ShowCurrentScrollCost");
}

function SetHeroInventory(H7AdventureHero hero)
{
	local GFxObject  items, itemObj;
	local H7HeroItem item;
	local IntPoint itemPos;
	local int i;
	local array<H7HeroItem> inventoryItems;

	inventoryItems = hero.GetInventory().GetItems();

	items = CreateArray();

	ForEach inventoryItems(item, i)
	{
		itemPos = hero.GetInventory().GetItemPosByIndex(i);
		;
		itemObj = CreateItemObject(item, hero, itemPos);
		items.SetElementObject(i, itemObj);
	}
	SetObject("mItems", items);
	ActionScriptVoid("ShowItems");
}

function HighlightSlot(IntPoint scrollLocation)
{
	SetInt("mHighlightSlotX", scrollLocation.X);
	SetInt("mHighlightSlotY", scrollLocation.Y);
	ActionScriptVoid("HighlightSlot");
}
