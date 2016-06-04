class H7GFxHeroInfo extends H7GFxUIContainer
	dependson(H7StructsAndEnumsNative);

function Update(H7AdventureHero hero)
{
	local GFxObject object;
	
	object = CreateObject("Object");
	
	object.SetBool("Caravan", true);
	object.SetString("HeroIcon", "img://H7TextureGUI.CheckboxIcon_Caravan");
	if(!hero.IsA('H7Caravan')) 
	{
		hero.GUIWriteInto(object, LF_HERO_WINDOW);
		hero.AddBuffsToDataObject(object, self);
		hero.AddItemBoniToDataObject(object, self);
		object.SetBool("Caravan", false);
		
	}

	self.ListenTo(hero);

	object.SetString("BGTexturePath", hero.GetFactionBGHeroWindow());
	object.SetString("HeroImagePath", hero.GetFlashImagePath());

	object.SetInt("PlayerColorR", hero.GetPlayer().GetColor().R);
	object.SetInt("PlayerColorG", hero.GetPlayer().GetColor().G);
	object.SetInt("PlayerColorB", hero.GetPlayer().GetColor().B);

	SetObject("mData", object);
	ActionscriptVoid("Update");
}

function ListenUpdate(H7IGUIListenable gameEntity)
{
	;
	H7AdventureHero(gameEntity).GUIWriteInto(GetObject("mData"));
	ActionscriptVoid("Update");
}
