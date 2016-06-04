//=============================================================================
// H7GFxHeroSelection
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxHeroSelection extends H7GFxUIContainer;

function SetAllHeroes(bool forDuel = false, bool isSkirmish = false)
{
	local GFxObject obj, factionsObj, factionObj;
	local array<H7Faction> factions;
	local H7Faction faction;
	local int i, j;
	local string archetypeID;

	local array<H7EditorHero> allHeroes, heroes, privilegHeroes, exclusiveSkirmishHeroes;
	local GFxObject heroesObj, heroObj;
	local H7EditorHero hero;

	obj = CreateObject("Object");

	class'H7GameData'.static.GetInstance().GetFactions(factions);
	factionsObj = CreateArray();

	factionObj = CreateObject("Object");
	factionObj.SetString("Name", class'H7GameData'.static.GetInstance().GetRandomFaction().GetName());
	factionObj.SetString("Icon", class'H7GameData'.static.GetInstance().GetRandomFaction().GetFactionColorIconPath());
	factionsObj.SetElementObject(0, factionObj);

	ForEach factions(faction, i)
	{
		factionObj = CreateObject("Object");
		factionObj.SetString("Name", faction.GetName());
		factionObj.SetString("Icon", faction.GetFactionColorIconPath());

		factionsObj.SetElementObject(i+1, factionObj);
		//factionsObj.SetElementObject(i, factionObj);
	}
	obj.SetObject("Factions", factionsObj);

	if(forDuel)
	{
		class'H7GameData'.static.GetInstance().GetPrivilegHeroesDuel(privilegHeroes);
		class'H7GameData'.static.GetInstance().GetDuelHeroes(allHeroes);
	
	}else
	{
		if(isSkirmish)
		{
			class'H7GameData'.static.GetInstance().GetExclusiveHeroesSkirmish(exclusiveSkirmishHeroes);
		}
		class'H7GameData'.static.GetInstance().GetPrivilegHeroesSkirmish(privilegHeroes);
		class'H7GameData'.static.GetInstance().GetHeroes(allHeroes);
	}
	;

	foreach privilegHeroes(hero)
	{
		heroes.AddItem(hero);
	}
	foreach allHeroes(hero)
	{
		heroes.AddItem(hero);
	}
	foreach exclusiveSkirmishHeroes(hero)
	{
		heroes.AddItem(hero);
	}

	i = 0;
	heroesObj = CreateArray();
	ForEach heroes(hero, i)
	{
		;
		heroObj = CreateObject("Object");
		heroObj.SetString("Name", hero.GetName());
		heroObj.SetString("FactionName", hero.GetFaction().GetName());
		heroObj.SetString("Icon", hero.GetFlashIconPath());
		heroObj.SetString("UnrealID", hero.GetArchetypeID());
		if(hero.GetHeropediaOverwrite() != none)
			archetypeID = hero.GetHeropediaOverwrite().GetArchetypeID();
		else
			archetypeID = hero.GetArchetypeID();
		heroObj.SetString("ArchetypeID", archetypeID);
		heroObj.SetBool("HeropediaAvailable", class'H7HeropediaCntl'.static.GetInstance().IsHeroDataAvailable(archetypeID));
		heroObj.SetBool("IsRandom", false);
		heroObj.SetBool("IsMight", hero.IsMightHero());
		heroObj.Setint("Level", forDuel ? 30 : 1);
		heroesObj.SetElementObject(i, heroObj);
	}

	j = 0;
	//add random Heroes
	hero = class'H7GameData'.static.GetInstance().GetRandomHero();
	;
	heroObj = CreateObject("Object");
	heroObj.SetString("Name", class'H7Loca'.static.LocalizeSave("RANDOM_HERO","H7SkirmishSetup"));
	heroObj.SetString("FactionName", hero.GetFaction().GetName());
	heroObj.SetString("Icon", hero.GetFlashIconPath());
	heroObj.SetString("UnrealID", hero.GetArchetypeID());
	heroObj.SetString("ArchetypeID", hero.GetArchetypeID());
	heroObj.SetBool("HeropediaAvailable", false);
	heroObj.SetBool("IsRandom", true);
	heroObj.SetBool("IsMight", hero.IsMightHero());
	heroObj.Setint("Level", forDuel ? 30 : 1);
	heroesObj.SetElementObject(i + j + 1, heroObj);


	class'H7GameData'.static.GetInstance().GetRandomHeroes(heroes);
	ForEach heroes(hero, j)
	{
		;
		heroObj = CreateObject("Object");
		heroObj.SetString("Name", hero.GetName());
		heroObj.SetString("FactionName", hero.GetFaction().GetName());
		heroObj.SetString("Icon", hero.GetFlashIconPath());
		heroObj.SetString("UnrealID", hero.GetArchetypeID());
		heroObj.SetString("ArchetypeID", hero.GetArchetypeID());
		heroObj.SetBool("HeropediaAvailable", false);
		heroObj.SetBool("IsRandom", true);
		heroObj.SetBool("IsMight", hero.IsMightHero());
		heroObj.Setint("Level", forDuel ? 30 : 1);
		heroesObj.SetElementObject(i + j + 2, heroObj);
	}

	obj.SetObject("Heroes", heroesObj);
	obj.SetString("IconAllHeroes", GetHud().GetMouseCntl().GetAssetPath("ALLHEROES"));

	SetObject("mData", obj);

	ActionScriptVoid("SetAllHeroes");
}

//alos opens the heroSelection
function Update(array<String> heroIDs, int playerIndex, String currentlySelectedHeroID, EPlayerColor playerColor)
{
	local GFxObject obj, heroIDsObj;
	local int i;
	local Color c;	

	obj = CreateObject("Object");
	heroIDsObj = CreateArray();

	for(i = 0; i < heroIDs.Length; i++)
	{
		heroIDsObj.SetElementString(i, heroIDs[i]);
	}

	obj.SetObject("AvailableHeroIDs", heroIDsObj);
	obj.SetInt("PlayerIndex", playerIndex);
	obj.SetString("CurrentlySelectedHeroID", currentlySelectedHeroID);
	c = class'H7GameUtility'.static.GetColor(playerColor);
	obj.SetString("PlayerColor", GetHud().GetMouseCntl().UnrealColorToFlashColor( c ));

	SetObject("mPlayerData", obj);

	ActionScriptVoid("Update");
}

function UpdateHeroInfo(H7EditorHero hero)
{
	local GFxObject object, skillObj;
	local GFxObject ultimateSkills, majorSkills, minorSkills;
	local array<H7ClassSkillData> skills;
	local H7ClassSkillData skillData;

	local int skillIndex;

	object = CreateObject("Object");

	hero.GUIWriteInto(object);
	if(hero.GetSpecialization() != none)
	{
		object.SetString("SpecialName", hero.GetSpecialization().GetName());
		object.SetString("SpecialDesc", hero.GetSpecialization().GetTooltipForCaster(hero));
		object.SetString("SpecialIcon", hero.GetSpecialization().GetFlashIconPath());
		object.SetString("SpecialFrame", hero.GetFactionSpecializationFrame());
	}

	//Skill info
	ultimateSkills = CreateArray();
	majorSkills = CreateArray();
	minorSkills = CreateArray();
	
	skills = hero.GetHeroClass().GetEditorSkills();

	//Localize("H7EffectContrainer", "TT_SKILL_REQ_RANK", "MMH7Game");

	;
	for(skillIndex = 0; skillIndex < skills.Length; skillIndex++)
	{
		skillData = skills[skillIndex];
		;
		skillObj = CreateObject("Object");
		skillObj.SetString("Name", skillData.Skill.GetName());

		skillObj.SetString("Icon", "img://" $ Pathname( skillData.Skill.GetIcon() ));
		//skillObj.SetString("Desc", skillData.Skill.GetArchetypeDescription(SR_ALL_RANKS));
		skillObj.SetString("Desc", skillData.Skill.GetDescription(SR_ALL_RANKS));


		//add the skillObject to its respective array
		if(skillIndex < 3)
		{
			ultimateSkills.SetElementObject(skillIndex, skillObj);
		}
		else if(skillIndex < 6)
		{
			majorSkills.SetElementObject(skillIndex - 3, skillObj);	
		}
		else
		{
			minorSkills.SetElementObject(skillIndex - 6, skillObj);
		}
	}

	object.SetString("Novice", class'H7Loca'.static.LocalizeSave("SR_NOVICE","H7Abilities"));
	object.SetString("Expert", class'H7Loca'.static.LocalizeSave("SR_EXPERT","H7Abilities"));
	object.SetString("Master", class'H7Loca'.static.LocalizeSave("SR_MASTER","H7Abilities"));

	object.SetString("FactionIcon", hero.GetFaction().GetFactionColorIconPath());

	object.SetObject("UltimateSkills", ultimateSkills);
	object.SetObject("MajorSkills", majorSkills);
	object.SetObject("MinorSkills", minorSkills);

	SetObject("mHeroInfo", object);
	ActionScriptVoid("UpdateHeroInfo");
}

function UpdateHeroInfoDuel(H7EditorHero hero)
{
	local GFxObject object, skillObj, abilitiesObj, abilityObj;
	local GFxObject masterSkills, expertSkills, noviceSkills, unskilledSkills;
	local array<H7HeroSkill> preLearnedSkills;
	local H7HeroSkill preLearnedSkill;
	local H7HeroAbility ability, ultimate;
	local int abilitiesSet, masterSkillsSet, expertSkillsSet, noviceSkillsSet, unskilledSkillsSet;

	local int skillIndex;

	object = CreateObject("Object");

	hero.GUIWriteInto(object);
	if(hero.GetSpecialization() != none)
	{
		object.SetString("SpecialName", hero.GetSpecialization().GetName());
		object.SetString("SpecialDesc", hero.GetSpecialization().GetTooltipForCaster(hero));
		object.SetString("SpecialIcon", hero.GetSpecialization().GetFlashIconPath());
		object.SetString("SpecialFrame", hero.GetFactionSpecializationFrame());
	}

	//Skill info
	masterSkills = CreateArray();
	expertSkills = CreateArray();
	noviceSkills = CreateArray();
	unskilledSkills = CreateArray();
	
	hero.GetPreLearnedHeroSkills(preLearnedSkills);
	//Localize("H7EffectContrainer", "TT_SKILL_REQ_RANK", "MMH7Game");

	;
	unskilledSkillsSet = 0;
	noviceSkillsSet = 0;
	expertSkillsSet = 0;
	masterSkillsSet = 0;
	for(skillIndex = 0; skillIndex < preLearnedSkills.Length; skillIndex++)
	{
		preLearnedSkill = preLearnedSkills[skillIndex];
		;
		skillObj = CreateObject("Object");
		skillObj.SetString("Name", preLearnedSkill.Skill.GetName());

		skillObj.SetString("Icon", "img://" $ Pathname( preLearnedSkill.Skill.GetIcon() ));
		if(preLearnedSkill.Rank >= SR_NOVICE)
			skillObj.SetString("NoviceDesc", preLearnedSkill.Skill.GetDescription(SR_NOVICE));
		if(preLearnedSkill.Rank >= SR_EXPERT)
			skillObj.SetString("ExpertDesc", preLearnedSkill.Skill.GetDescription(SR_EXPERT));
		if(preLearnedSkill.Rank >= SR_MASTER)
			skillObj.SetString("MasterDesc", preLearnedSkill.Skill.GetDescription(SR_MASTER));

		abilitiesSet = 0;
		ultimate = preLearnedSkill.Skill.GetUltimateSkillAbiliyArchetype();
		abilitiesObj = CreateArray();
		ForEach preLearnedSkill.LearnedAbilities(ability)
		{
			if(ability == none) continue;
			if(ability == ultimate) skillObj.SetBool("HasUltimate", true);
			abilityObj = CreateObject("Object");
			abilityObj.SetString("Name", ability.GetName());
			abilityObj.SetString("Desc", ability.GetTooltip());
			abilityObj.SetString("Icon", ability.GetFlashIconPath());
			abilitiesObj.SetElementObject(abilitiesSet, abilityObj);
			abilitiesSet++;
		}
		skillObj.SetObject("Abilities", abilitiesObj);

		//add the skillObject to its respective array
		if(preLearnedSkill.Rank == SR_MASTER)
		{
			masterSkills.SetElementObject(masterSkillsSet, skillObj);
			masterSkillsSet++;
		}
		else if(preLearnedSkill.Rank == SR_EXPERT)
		{
			expertSkills.SetElementObject(expertSkillsSet, skillObj);	
			expertSkillsSet++;
		}
		else if(preLearnedSkill.Rank == SR_NOVICE)
		{
			noviceSkills.SetElementObject(noviceSkillsSet, skillObj);
			noviceSkillsSet++;
		}
		else
		{
			unskilledSkills.SetElementObject(unskilledSkillsSet, skillObj);
			unskilledSkillsSet++;
		}
	}
	
	object.SetString("Novice", class'H7Loca'.static.LocalizeSave("SR_NOVICE","H7Abilities"));
	object.SetString("Expert", class'H7Loca'.static.LocalizeSave("SR_EXPERT","H7Abilities"));
	object.SetString("Master", class'H7Loca'.static.LocalizeSave("SR_MASTER","H7Abilities"));
	object.SetString("Unskilled", class'H7Loca'.static.LocalizeSave("SR_UNSKILLED","H7Abilities"));

	object.SetString("FactionIcon", hero.GetFaction().GetFactionColorIconPath());

	object.SetObject("MasterSkills", masterSkills);
	object.SetObject("ExpertSkills", expertSkills);
	object.SetObject("NoviceSkills", noviceSkills);
	object.SetObject("UnskilledSkills", unskilledSkills);

	SetObject("mHeroInfo", object);
	ActionScriptVoid("UpdateHeroInfo");
}
