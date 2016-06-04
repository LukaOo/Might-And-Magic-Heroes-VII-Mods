//=============================================================================
// H7GFxHallOfHerosPopup
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxHallOfHerosPopup extends H7GFxTownPopup
	dependson (H7StructsAndEnumsNative);

function Update(array<RecruitHeroData> datas)
{
	local GFxObject object, heroArray, tmpHero;
	local H7EditorHero hero;
	local RecruitHeroData data;
	local int i;

	hero = datas[0].Army.GetHero();

	//UpdateHeroInfo(hero);

	object = CreateObject("Object");

	heroArray = CreateArray();
	i = 0;
	foreach datas(data)
	{
		hero = data.Army.GetHero();
		;
		tmpHero = CreateObject("Object");
		hero.GUIWriteInto(tmpHero);
		heroArray.SetElementObject(i, tmpHero);
		i++;
	}
	
	object.SetObject("Heros", heroArray);

	SetObject( "mData" , object);
	ActionscriptVoid("Update");
}

function UpdateHeroInfo(H7EditorHero hero, RecruitHeroData recruitment,H7Town town)
{
	local GFxObject object;
	local array<H7AdventureHero> activeHeroes;

	if(hero == none || recruitment.Army == none || town == none)
	{
		;
		return;
	}

	;

	object = CreateObject("Object");
	object.SetInt("PlayerGold", class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetResourceSet().GetCurrency());
	object.SetInt("Cost", recruitment.Cost);
	object.SetString("CurrencyName", class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetResourceSet().GetCurrencyResourceType().GetName());
	object.SetBool("SlotInTown", town.CanRecruitHero(hero.GetArmy()));
	object.SetBool("IsAvailable", recruitment.IsAvailable);

	hero.GUIWriteInto(object, LF_EVERYTHING);
	if(hero.GetSpecialization() != none)
	{
		object.SetString("SpecialName", hero.GetSpecialization().GetName());
		object.SetString("SpecialDesc", hero.GetSpecialization().GetTooltipForCaster(hero));
		object.SetString("SpecialIcon", hero.GetSpecialization().GetFlashIconPath());
		object.SetString("SpecialFrame", hero.GetFactionSpecializationFrame());
	}

	object.SetInt("PlayerColorR", class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetColor().R);
	object.SetInt("PlayerColorG", class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetColor().G);
	object.SetInt("PlayerColorB", class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetColor().B);

	object.SetString("BGTexturePath", hero.GetFactionBGHeroWindow());
	object.SetString("HeroImagePath", hero.GetFlashImagePath());
	
	activeHeroes = class'H7AdventureController'.static.GetInstance().GetPlayerByID(class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetID()).GetHeroes();
	object.SetBool("HasReachedHeroCap", activeHeroes.Length >=8 ? true : false);

	SetObject("mData", object);
	ActionscriptVoid("UpdateHeroInfo");
}

public function ResetWithoutHeroCircle()
{
	ActionscriptVoid("ResetWithoutHeroCircle");
}

public function Closed()
{
	ActionscriptVoid("Closed");
}
