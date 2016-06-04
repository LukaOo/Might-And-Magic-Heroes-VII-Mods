//=============================================================================
// H7GFxHeroWindow
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxHeroWindow extends H7GFxUIContainer; 

function Update(H7AdventureArmy army, H7AdventureHero hero)
{
	UpdateHeroInfo(army, hero);

    ActionScriptInt("Update");
}

function UpdateHeroInfo(H7AdventureArmy army, H7AdventureHero hero)
{
	local GFxObject object;

	;
	object = CreateObject("Object");

	hero.GUIWriteInto(object,LF_HERO_WINDOW);
	self.ListenTo(hero);
	hero.AddBuffsToDataObject(object, self);
	hero.AddItemBoniToDataObject(object, self);

	object.SetBool("IsDismissable", hero.GetArmy().CanFleeOrSurrender());

	
	;
	object.SetString("BGTexturePath", hero.GetFactionBGHeroWindow());
	object.SetString("HeroImagePath", hero.GetFlashImagePath());

	object.SetInt("PlayerColorR", hero.GetPlayer().GetColor().R);
	object.SetInt("PlayerColorG", hero.GetPlayer().GetColor().G);
	object.SetInt("PlayerColorB", hero.GetPlayer().GetColor().B);

	SetObject( "mData" , object);

	ActionscriptVoid("UpdateHeroInfo");

}

function ListenUpdate(H7IGUIListenable gameEntity)
{
	;
	H7AdventureHero(gameEntity).GUIWriteInto(GetObject("mData"));
	ActionscriptVoid("UpdateHeroInfo");
}

function UpdateArmyInfo(H7AdventureArmy army)
{
	/*local GFxObject object;
	local H7BaseCreatureStack stack;

	foreach army.GetBaseCreatureStacks()(stack)
	{
		
	}

	object = CreateArray();*/
}

function RemoveItemFromDragSlot()
{
	ActionscriptVoid("RemoveItemFromDragSlot");
}
