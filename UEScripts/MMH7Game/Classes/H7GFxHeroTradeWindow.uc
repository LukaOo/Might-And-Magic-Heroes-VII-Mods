//=============================================================================
// H7GFxHeroTradeWindowPopup
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxHeroTradeWindow extends H7GFxUIContainer
	dependson (H7StructsAndEnumsNative);

function Update(H7AdventureHero hero1, H7AdventureHero hero2, optional bool isAlliedTrade = false)
{
	local GFxObject object, hero1Info, hero2Info;
	
	object = CreateObject("Object");
	hero1Info = CreateObject("Object");
	hero2Info = CreateObject("Object");
	
	hero1.GUIWriteInto(hero1Info, LF_HERO_WINDOW);
	hero1.AddBuffsToDataObject(hero1Info, self);
	hero1.AddItemBoniToDataObject(hero1Info, self);

	hero1Info.SetString("BGTexturePath", hero1.GetFactionBGHeroWindow());
	hero1Info.SetString("HeroImagePath", hero1.GetFlashImagePath());

	hero1Info.SetInt("PlayerColorR", hero1.GetPlayer().GetColor().R);
	hero1Info.SetInt("PlayerColorG", hero1.GetPlayer().GetColor().G);
	hero1Info.SetInt("PlayerColorB", hero1.GetPlayer().GetColor().B);

	hero2Info.SetBool("Caravan", true);
	hero2Info.SetString("HeroIcon", "img://H7TextureGUI.CheckboxIcon_Caravan");
	if(!hero2.IsA('H7Caravan')) 
	{
		hero2.GUIWriteInto(hero2Info, LF_HERO_WINDOW);
		hero2.AddBuffsToDataObject(hero2Info, self);
		hero2.AddItemBoniToDataObject(hero2Info, self);
		hero2Info.SetBool("Caravan", false);
	}

	hero2Info.SetString("BGTexturePath", hero2.GetFactionBGHeroWindow());
	hero2Info.SetString("HeroImagePath", hero2.GetFlashImagePath());

	hero2Info.SetInt("PlayerColorR", hero2.GetPlayer().GetColor().R);
	hero2Info.SetInt("PlayerColorG", hero2.GetPlayer().GetColor().G);
	hero2Info.SetInt("PlayerColorB", hero2.GetPlayer().GetColor().B);

	object.SetBool("IsAlliedTrade", isAlliedTrade);
	object.SetObject("hero1", hero1Info);
	if(hero2!=none) object.SetObject("hero2", hero2Info);

	SetObject("mData", object);
	ActionscriptVoid("UpdateHeroInfo");
}

/*function UpdateHeroInfoAfterEquipChange(H7AdventureHero hero1, H7AdventureHero hero2)
{
	local GFxObject object, hero1Info, hero2Info;
	
	object = CreateObject("Object");
	hero1Info = CreateObject("Object");
	hero2Info = CreateObject("Object");
	
	hero1.GUIWriteInto(hero1Info, LF_HERO_WINDOW);
	hero1.AddBuffsToDataObject(hero1Info, self);
	hero1.AddItemBoniToDataObject(hero1Info, self);

	hero1Info.SetInt("PlayerColorR", hero1.GetPlayer().GetColor().R);
	hero1Info.SetInt("PlayerColorG", hero1.GetPlayer().GetColor().G);
	hero1Info.SetInt("PlayerColorB", hero1.GetPlayer().GetColor().B);

	hero2Info.SetBool("Caravan", true);
	hero2Info.SetString("HeroIcon", "img://H7TextureGUI.CheckboxIcon_Caravan");
	if(!hero2.IsA('H7Caravan')) 
	{
		hero2.GUIWriteInto(hero2Info, LF_HERO_WINDOW);
		hero2.AddBuffsToDataObject(hero2Info, self);
		hero2.AddItemBoniToDataObject(hero2Info, self);
		hero2Info.SetBool("Caravan", false);
	}

	hero2Info.SetInt("PlayerColorR", hero2.GetPlayer().GetColor().R);
	hero2Info.SetInt("PlayerColorG", hero2.GetPlayer().GetColor().G);
	hero2Info.SetInt("PlayerColorB", hero2.GetPlayer().GetColor().B);

	object.SetObject("hero1", hero1Info);
	if(hero2!=none) object.SetObject("hero2", hero2Info);

	SetObject("mNewHeroInfo", object);

	ActionscriptVoid("UpdateHeroInfoAfterEquipChange");
}*/

function RemoveItemFromDragSlot()
{
	ActionscriptVoid("RemoveItemFromDragSlot");
}

function UpdateMergeButtons(H7AdventureArmy army1, H7AdventureArmy army2, bool alliedTrade)
{
	if(class'H7AreaOfControlSiteLord'.static.GetUniqueStackTypeCount(army1, army2) <= 7)
		ActualUpdateMergeButtons(true, alliedTrade);
	else
		ActualUpdateMergeButtons(false, alliedTrade);

}

function ActualUpdateMergeButtons(bool canMerge, bool alliedTrade)
{
	ActionScriptVoid("UpdateMergeButtons");
}
