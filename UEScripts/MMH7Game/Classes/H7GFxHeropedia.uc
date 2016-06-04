//=============================================================================
// H7GFxHeropedia
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxHeropedia extends H7GFxUIContainer
	dependson (H7StructsAndEnumsNative);

function SetListItemsHeroes(array<H7EditorHero> heroes)
{
	local GFxObject herosObj, heroEntryObj, factionsObj, factionObj;
	local array<H7Faction> factions;
	local int i;

	herosObj = CreateArray();
	factionsObj = CreateArray();
	
	class'H7GameData'.static.GetInstance().GetFactions(factions, true);
	factions.AddItem( class'H7GameData'.static.GetInstance().GetNeutralFaction() );

	for(i = 0; i < heroes.Length; i++)
	{
		heroEntryObj = CreateObject("Object");
		heroEntryObj.SetString("Name", heroes[i].GetName());
		heroEntryObj.SetString("ID", heroes[i].GetArchetypeID());
		heroEntryObj.SetString("FactionID", heroes[i].GetFaction().GetArchetypeID());
		heroEntryObj.SetString("Icon", heroes[i].GetFlashIconPath());
		herosObj.SetElementObject(i, heroEntryObj);
	}

	for(i = 0; i < factions.Length; i++)
	{
		factionObj = CreateObject("Object");
		factionObj.SetString("Name", factions[i].GetName());
		factionObj.SetString("ID", factions[i].GetArchetypeID());
		factionObj.SetString("Icon", factions[i].GetFactionColorIconPath());
		factionsObj.SetElementObject(i, factionObj);
	}

	

	SetObject("mFactionList", factionsObj);
	SetObject("mHeroList", herosObj);
;
	ActionScriptVoid("SetHeroes");
	ActionScriptVoid("SetFactions");
}

function AddMapSpecificHeroes(array<H7EditorHero> mapSpecificHeroes)
{
	local GFxObject herosObj, heroEntryObj, factionsObj, factionObj;
	local array<H7Faction> factions, mapSpecificFactions;
	local int i;

	herosObj = CreateArray();
	factionsObj = CreateArray();
	class'H7GameData'.static.GetInstance().GetFactions(factions, true);
	mapSpecificFactions = H7MapInfo(class'WorldInfo'.static.GetWorldInfo().GetVanillaMapInfo()).GetCustomFactions();

	for(i = 0; i < mapSpecificHeroes.Length; i++)
	{
		heroEntryObj = CreateObject("Object");
		heroEntryObj.SetString("Name", mapSpecificHeroes[i].GetName());
		heroEntryObj.SetString("ID", mapSpecificHeroes[i].GetArchetypeID());
		heroEntryObj.SetString("FactionID", mapSpecificHeroes[i].GetFaction().GetArchetypeID());
		
		if(factions.Find( mapSpecificHeroes[i].GetFaction() ) == -1 &&
		   mapSpecificFactions.Find( mapSpecificHeroes[i].GetFaction() ) == -1)
			mapSpecificFactions.AddItem(mapSpecificHeroes[i].GetFaction()); 

		heroEntryObj.SetString("Icon", mapSpecificHeroes[i].GetFlashIconPath());
		herosObj.SetElementObject(i, heroEntryObj);
	}

	for(i = 0; i < mapSpecificFactions.Length; i++)
	{
		factionObj = CreateObject("Object");
		factionObj.SetString("Name", mapSpecificFactions[i].GetName());
		factionObj.SetString("ID", mapSpecificFactions[i].GetArchetypeID());
		factionObj.SetString("Icon", mapSpecificFactions[i].GetFactionColorIconPath());
		factionsObj.SetElementObject(i, factionObj);
	}

	SetObject("mMapSpecificFactions", factionsObj);
	SetObject("mMapSpecificHeroes", herosObj);
	ActionScriptVoid("SetMapSpecificHeroes");
	ActionScriptVoid("SetMapSpecificFactions");
}

function SetListItemsCreatures(array<H7Creature> actualCreatureArray)
{
	local GFxObject creaturesObj, creatureObj;
	local H7Creature creature;
	local int i;

	creaturesObj = CreateArray();
	i = 0;

	ForEach actualCreatureArray(creature, i)
	{
		creatureObj = CreateObject("Object");
		creatureObj.SetString("Name", creature.GetName());
		creatureObj.SetString("ID", creature.GetIDString());
		creatureObj.SetString("FactionID", creature.GetFaction().GetArchetypeID());
		creatureObj.SetString("Icon", creature.GetFlashIconPath());
		creaturesObj.SetElementObject(i, creatureObj);
	}

	SetObject("mCreatureList", creaturesObj);
	ActionScriptVoid("SetCreatures");
}

function AddMapSpecificCreatures(array<H7Creature> mapSpecificCreatures)
{
	local GFxObject creaturesObj, creatureObj;
	local H7Creature creature;
	local int i;

	creaturesObj = CreateArray();
	i = 0;

	ForEach mapSpecificCreatures(creature, i)
	{
		creatureObj = CreateObject("Object");
		creatureObj.SetString("Name", creature.GetName());
		creatureObj.SetString("ID", creature.GetIDString());
		creatureObj.SetString("FactionID", creature.GetFaction().GetArchetypeID());
		creatureObj.SetString("Icon", creature.GetFlashIconPath());
		creaturesObj.SetElementObject(i, creatureObj);
	}

	SetObject("mMapSpecificCreatures", creaturesObj);
	ActionScriptVoid("SetMapSpecificCreatures");
}

function SetListItemsLore(array<H7GeneralLoreEntry> generalLore)
{
	local GFxObject loresObj, loreObj;
	local H7GeneralLoreEntry loreEntry;
	local int i;

	loresObj = CreateArray();
	i = 0;

	ForEach generalLore(loreEntry, i)
	{
		loreObj = CreateObject("Object");
		loreObj.SetString("Name", loreEntry.GetName());
		loreObj.SetString("ID", loreEntry.GetName());
		loreObj.SetString("Text", loreEntry.GetText());
		loreObj.SetString("Icon", loreEntry.GetFlashIconPath());
		loresObj.SetElementObject(i, loreObj);
	}

	SetObject("mLoreList", loresObj);
	ActionScriptVoid("SetLores");
}

function SetListItemsWarUnits(array<H7EditorWarUnit> warUnits)
{
	local GFxObject warUnitsObj, warUnitEntryObj;
	local int i;

	warUnitsObj = CreateArray();

	for(i = 0; i < warUnits.Length; i++)
	{
		warUnitEntryObj = CreateObject("Object");
		warUnitEntryObj.SetString("Name", warUnits[i].GetName());
		warUnitEntryObj.SetString("ID", warUnits[i].GetIDString());
		warUnitEntryObj.SetString("FactionID", warUnits[i].GetFaction().GetArchetypeID());
		warUnitEntryObj.SetString("Icon", warUnits[i].GetFlashIconPath());
		warUnitsObj.SetElementObject(i, warUnitEntryObj);
	}

	SetObject("mWarUnitsList", warUnitsObj);
	ActionScriptVoid("SetWarUnits");
}

function UpdateHeroTest()
{	
	local array<H7EditorHero> heroes;
	class'H7GameData'.static.GetInstance().GetHeroes(heroes, true);
	OpenHeroPage(heroes[29]);
}

function OpenHeroPage(H7EditorHero hero)
{
	local GFxObject object, armyObj, stackObj, bioObj;
	local array<CreatureStackProperties> defaultArmy;
	local CreatureStackProperties stack;
	local array<H7HeroBioData> bioData;
	local int i;

	;
	object = CreateObject("Object");
	armyObj = CreateArray();
	i = 0;

	hero.GUIWriteInto(object,LF_HERO_WINDOW);
	if(hero.GetSpecialization() != none)
	{
		object.SetString("SpecialName", hero.GetSpecialization().GetName());
		object.SetString("SpecialDesc", hero.GetSpecialization().GetTooltipForCaster(hero));
		object.SetString("SpecialIcon", hero.GetSpecialization().GetFlashIconPath());
		object.SetString("SpecialFrame", hero.GetFactionSpecializationFrame());
	}
	object.SetString("FactionSkillIcon",  "img://" $ Pathname( hero.mStartSkills[0].GetIcon()) );
	object.SetString("FactionSkillName", hero.mStartSkills[0].GetName());
	object.SetString("StartSkillIcon",  "img://" $ Pathname( hero.mStartSkills[1].GetIcon()) );
	object.SetString("StartSkillName", hero.mStartSkills[1].GetName());
	
	object.SetString("FactionID", hero.GetFaction().GetArchetypeID());

	defaultArmy = hero.GetHoHDefaultArmy();
	ForEach defaultArmy(stack, i)
	{
		stackObj = CreateUnitObjectAdvanced(stack.Creature);
		stackObj.SetInt("StackSize", stack.Size);
		armyObj.SetElementObject(i, stackObj);
	}
	object.SetObject("Army", armyObj);

	//Biography
	bioData = hero.GetHeroBioData();
	bioObj = CreateArray();
	for(i = 0; i < bioData.Length; i++)
	{
		if(bioData[i].GetCondition() == "")
			bioObj.SetElementString(i, bioData[i].GetText());

		//map has to be completed
		if(!bioData[i].GetStartedCondition() && class'H7PlayerProfile'.static.GetInstance().HasFinishedMap(bioData[i].GetCondition()))
			bioObj.SetElementString(i, bioData[i].GetText());
			
		//map has to be started
		if(bioData[i].GetStartedCondition() && class'H7PlayerProfile'.static.GetInstance().HasStartedMap(bioData[i].GetCondition()))
			bioObj.SetElementString(i, bioData[i].GetText());
	
	}
	
	object.SetObject("Bio", bioObj);

	SetObject( "mHeroPageData" , object);

	ActionscriptVoid("OpenHeroPage");
}

function OpenCreaturePage(H7Creature creature)
{
	local GFxObject obj, abilityObj, abilitiesObj;
	local array<H7BaseAbility> abilities;
	local H7BaseAbility ability;
	local int i;

	obj = CreateUnitObjectAdvanced(creature);
	obj.SetString("FactionID", creature.GetFaction().GetArchetypeID());
	obj.SetString("Artwork", creature.GetFlashArtworkPath());
	obj.SetString("Lore", creature.GetLore());
	obj.SetBool("IsWarUnit", false);
	obj.SetBool("IsUpgrade", !creature.IsBaseCreature());
	if(creature.GetFaction() != class'H7GameData'.static.GetInstance().GetNeutralFaction()) 
		obj.SetString("Other", creature.IsBaseCreature() ? creature.GetUpgradedCreature().GetName() : creature.GetBaseCreature().GetName());

	abilitiesObj = CreateArray();
	abilities = creature.GetAbilities();
	abilities.AddItem(creature.GetMeleeAttackAbility());
	if(creature.GetRangedAttackAbility() != none) abilities.AddItem(creature.GetRangedAttackAbility());
	abilities.AddItem(creature.GetDefendAbility());
	abilities.AddItem(creature.GetWaitAbility());
	abilities.AddItem(creature.GetMoralAbility());
	abilities.AddItem(creature.GetLuckAbility());
	abilities.AddItem(creature.GetRetaliationAbility());
	
	i = 0;
	foreach abilities(ability)
	{
		if(!ability.IsSpell() && (ability.IsDisplayed() || class'H7GUIGeneralProperties'.static.GetInstance().GetOptionHiddenBuffs()))
		{
			abilityObj = CreateObject("Object");
			abilityObj.SetString( "AbilityName", ability.GetName() ); 
			abilityObj.SetString( "AbilityTooltip", ability.GetTooltipForCaster(creature) );
			abilityObj.SetString( "AbilityIcon", ability.GetFlashIconPath() ); 
			abilitiesObj.SetElementObject(i, abilityObj);
			i++;
		}
	}
	obj.SetObject("Abilities", abilitiesObj);

	SetObject("mCreaturePageData", obj);
	ActionscriptVoid("OpenCreaturePage");
}

function OpenWarUnitPage(H7EditorWarUnit warUnit)
{
	local GFxObject obj, abilityObj, abilitiesObj;
	local array<H7BaseAbility> abilities;
	local H7BaseAbility ability;
	local int i;

	obj = CreateWarfareUnitObject(warUnit);//UnitObjectAdvanced(creature);
	obj.SetString("FactionID", warUnit.GetFaction().GetArchetypeID());
	obj.SetString("Artwork", warUnit.GetFlashArtworkPath());
	obj.SetString("Lore", warUnit.GetLore());
	obj.SetBool("IsWarUnit", true);
	//obj.SetBool("IsUpgrade", !creature.IsBaseCreature());
	//obj.SetString("Other", creature.IsBaseCreature() ? creature.GetUpgradedCreature().GetName() : creature.GetBaseCreature().GetName());

	abilitiesObj = CreateArray();
	//warUnit.GetAbilityManager().GetAbilities(abilities);
	abilities.AddItem(warUnit.GetDefaultAttackAbility());
	abilities.AddItem(warUnit.GetDefaultSupportAbility());

	i = 0;
	foreach abilities(ability)
	{
		if(!ability.IsSpell() && (ability.IsDisplayed() || class'H7GUIGeneralProperties'.static.GetInstance().GetOptionHiddenBuffs()))
		{
			abilityObj = CreateObject("Object");
			abilityObj.SetString( "AbilityName", ability.GetName() ); 
			//ability.SetCaster( warUnit );
			abilityObj.SetString( "AbilityTooltip", ability.GetTooltipForCaster(warUnit,,SR_NOVICE) );
			abilityObj.SetString( "AbilityIcon", ability.GetFlashIconPath() ); 
			abilitiesObj.SetElementObject(i, abilityObj);
			i++;
		}
	}
	obj.SetObject("Abilities", abilitiesObj);

	SetObject("mCreaturePageData", obj);
	ActionscriptVoid("OpenCreaturePage");
}
