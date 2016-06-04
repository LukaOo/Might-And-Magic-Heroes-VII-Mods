//=============================================================================
// H7GFxMerchantPopup
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxMerchantPopUp extends H7GFxUIContainer
	dependson (H7StructsAndEnumsNative);

function UpdateFromMerchant(H7AdventureHero hero, H7Merchant merchant)
{
	local GFxObject object, heroInfo, currentItemsObj, itemObj;
	local array<H7HeroItem> currentItems;
	local int i;
	local IntPoint pos;

	object = CreateObject("Object");
	heroInfo = CreateObject("Object");
	
	hero.GUIWriteInto(heroInfo, LF_HERO_WINDOW);
	hero.AddBuffsToDataObject(heroInfo, self);
	hero.AddItemBoniToDataObject(heroInfo, self);

	heroInfo.SetString("BGTexturePath", hero.GetFactionBGHeroWindow());
	heroInfo.SetString("HeroImagePath", hero.GetFlashImagePath());

	heroInfo.SetInt("PlayerColorR", hero.GetPlayer().GetColor().R);
	heroInfo.SetInt("PlayerColorG", hero.GetPlayer().GetColor().G);
	heroInfo.SetInt("PlayerColorB", hero.GetPlayer().GetColor().B);
	object.SetObject("HeroInfo", heroInfo);
	
	currentItems = merchant.GetCurrentlyAvailableItems();
	currentItemsObj = CreateArray();
	pos.X = 0; pos.Y = 0;

	;
	;

	for(i = 0; i < currentItems.Length; i++)
	{
		if(currentItems[i] == none) itemObj = CreateObject("Object");
		else 
		{
			itemObj = CreateItemObject(currentItems[i], none, pos);
			itemObj.SetInt("Cost", currentItems[i].GetBuyPrice() * merchant.GetBuyPriceMultiplicator());
		}
		currentItemsObj.SetElementObject(i, itemObj);
	}
	object.SetObject("CurrentItems", currentItemsObj);
	object.SetString("GoldIcon", class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetResourceSet().GetCurrencyResourceType().GetIconPath());
	
	SetObject("mVisitingHero", heroInfo);
	SetObject("mData", object);
	ActionscriptVoid("UpdateFromMerchant");
}

function UpdateFromBlackMarket(H7BlackMarket merchant, optional H7AdventureHero garrisonHero, optional H7AdventureHero visitingHero)
{
	local GFxObject object, garrisonHeroObj, visitingHeroObj, currentItemsObj, itemObj;
	local array<H7HeroItem> currentItems;
	local int i;
	local IntPoint pos;

	object = CreateObject("Object");
	garrisonHeroObj = CreateObject("Object");
	visitingHeroObj = CreateObject("Object");

	if(garrisonHero != none && garrisonHero.IsHero())
	{
		garrisonHero.GUIWriteInto(garrisonHeroObj);
		garrisonHero.AddBuffsToDataObject(garrisonHeroObj, self);
		garrisonHero.AddItemBoniToDataObject(garrisonHeroObj, self);
		garrisonHeroObj.SetString("BGTexturePath", garrisonHero.GetFactionBGHeroWindow());
		garrisonHeroObj.SetString("HeroImagePath", garrisonHero.GetFlashImagePath());

		garrisonHeroObj.SetInt("PlayerColorR", garrisonHero.GetPlayer().GetColor().R);
		garrisonHeroObj.SetInt("PlayerColorG", garrisonHero.GetPlayer().GetColor().G);
		garrisonHeroObj.SetInt("PlayerColorB", garrisonHero.GetPlayer().GetColor().B);

		garrisonHeroObj.SetBool("IsMight", garrisonHero.IsMightHero());
	}

	if(visitingHero != none && visitingHero.IsHero())
	{
		visitingHero.GUIWriteInto(visitingHeroObj);
		visitingHero.AddBuffsToDataObject(visitingHeroObj, self);
		visitingHero.AddItemBoniToDataObject(visitingHeroObj, self);
		visitingHeroObj.SetString("BGTexturePath", visitingHero.GetFactionBGHeroWindow());
		visitingHeroObj.SetString("HeroImagePath", visitingHero.GetFlashImagePath());

		visitingHeroObj.SetInt("PlayerColorR", visitingHero.GetPlayer().GetColor().R);
		visitingHeroObj.SetInt("PlayerColorG", visitingHero.GetPlayer().GetColor().G);
		visitingHeroObj.SetInt("PlayerColorB", visitingHero.GetPlayer().GetColor().B);

		visitingHeroObj.SetBool("IsMight", visitingHero.IsMightHero());
	}

	object.SetInt("PlayerColorR", merchant.GetPlayer().GetColor().R);
	object.SetInt("PlayerColorG", merchant.GetPlayer().GetColor().G);
	object.SetInt("PlayerColorB", merchant.GetPlayer().GetColor().B);

	currentItems = merchant.GetCurrentlyAvailableItems();
	currentItemsObj = CreateArray();
	pos.X = 0; pos.Y = 0;

	for(i = 0; i < currentItems.Length; i++)
	{
		if(currentItems[i] == none) itemObj = CreateObject("Object");
		else 
		{
			itemObj = CreateItemObject(currentItems[i], none, pos);
			itemObj.SetInt("Cost", currentItems[i].GetBuyPrice() * merchant.GetBuyPriceMultiplicator());
		}
		currentItemsObj.SetElementObject(i, itemObj);
	}
	object.SetObject("CurrentItems", currentItemsObj);
	object.SetString("GoldIcon", class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetResourceSet().GetCurrencyResourceType().GetIconPath());
	
	SetObject("mGarrisonHero", garrisonHeroObj);
	SetObject("mVisitingHero", visitingHeroObj);
	SetObject("mData", object);
	ActionscriptVoid("UpdateFromMarket");
}

function DisableHeroInventory()
{
	ActionScriptVoid("DisableHeroInventory");
}

function HighlightSlot(IntPoint scrollLocation)
{
	SetInt("mHighlightSlotX", scrollLocation.X);
	SetInt("mHighlightSlotY", scrollLocation.Y);
	ActionScriptVoid("HighlightSlot");
}
