//=============================================================================
// H7GFxArtifactRecyclerPopup
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxArtifactRecyclerPopup extends H7GFxTownPopup;

function Update(H7AdventureHero garissonHero, H7AdventureHero visitingHero, String recyclerName)
{
	local GFxObject garissonHeroObj, visitingHeroObj, items, itemObj, playerColor;
	local H7HeroItem item;
	local IntPoint itemPos;
	local int i;
	local array<H7HeroItem> inventoryItems;
	local H7AdventureHero hero;

	garissonHeroObj = CreateObject("Object");
	visitingHeroObj = CreateObject("Object");

	if(garissonHero != none)
	{
		garissonHero.GUIWriteInto(garissonHeroObj);
		inventoryItems = garissonHero.GetInventory().GetItems();
		hero = garissonHero;
		;
	}

	if(visitingHero != none)
	{
		visitingHero.GUIWriteInto(visitingHeroObj);
		inventoryItems = visitingHero.GetInventory().GetItems();
		hero = visitingHero;
		;
	}
	
	items = CreateArray();
	if(hero != none)
	{
		ForEach inventoryItems(item, i)
		{
			itemPos = hero.GetInventory().GetItemPosByIndex(i);
			;
			itemObj = CreateItemObject(item, hero, itemPos);
			items.SetElementObject(i, itemObj);
		}
	}
	;

	SetString("mRecyclerName", recyclerName);
	SetObject("mGarissonHero", garissonHeroObj);
	SetObject("mVisitingHero", visitingHeroObj);
	SetObject("mItems", items);

	playerColor = CreateObject("Object");
	if(hero!=none)
	{
		playerColor.SetInt( "PlayerColorR", hero.GetPlayer().GetColor().R);
		playerColor.SetInt( "PlayerColorG", hero.GetPlayer().GetColor().G);
		playerColor.SetInt( "PlayerColorB", hero.GetPlayer().GetColor().B);
	}
	SetObject("mPlayerColor", playerColor);

	ActionscriptVoid("Update");
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

function SetRecycleValues(array<H7ResourceQuantity> recycleValues, float multiplier)
{
	local GFxObject recycleValuesObj, recycleValue;
	local int i;

	recycleValuesObj = CreateArray();

	for(i = 0; i < recycleValues.Length; i++)
	{
		recycleValue = CreateObject("Object");
		recycleValue.SetString("Name", recycleValues[i].Type.GetName());
		recycleValue.SetInt("Amount", recycleValues[i].Quantity * multiplier);
		recycleValue.SetString("ResIcon", recycleValues[i].Type.GetIconPath());
		
		recycleValuesObj.SetElementObject(i,recycleValue);
	}

	SetObject("mCurrentItemRecycleValues", recycleValuesObj);

	ActionScriptVoid("ShowCurrentItemRecycleValues");
}
