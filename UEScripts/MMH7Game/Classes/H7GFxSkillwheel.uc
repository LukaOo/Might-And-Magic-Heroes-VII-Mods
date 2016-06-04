class H7GFxSkillwheel extends H7GFxUIContainer; 

var protected array<H7Skill> learnedSkills;
var protected H7Skill heroSkill;

function Update(H7EditorHero hero, bool showAll)
{
	local GFxObject object, skillObj, abilityObj, colorObject;
	local GFxObject ultimateSkills, majorSkills, minorSkills;
	local array<H7Skill> skills;
	local array<H7HeroAbility> abilities;
	local H7Skill skill;
	local EAbilitySchool abilitySchool;
	local string replColor;

	local int skillIndex;
	local int j;
	local int k;

	replColor = class'H7TextColors'.static.GetInstance().UnrealColorToHTMLColor(class'H7TextColors'.static.GetInstance().mReplacementColor);

	object = CreateObject("Object");
	ultimateSkills = CreateArray();
	majorSkills = CreateArray();
	minorSkills = CreateArray();
	
	k = 0;

	skills = hero.GetSkillManager().GetAllSkills();

	//Localize("H7EffectContrainer", "TT_SKILL_REQ_RANK", "MMH7Game");

	;
	for(skillIndex = 0; skillIndex < skills.Length; skillIndex++)
	{
		j = 0;
		skill = skills[skillIndex];
		;
		skillObj = CreateArray();

		abilityObj = CreateObject("Object");
		abilityObj.SetString("skillName", skill.GetName());
		abilityObj.SetString("schoolColor", "0x" $ class'H7EffectContainer'.static.GetSchoolColor(skill.GetSchool()));
		abilityObj.SetInt("skillLevel", int( skill.GetCurrentSkillRank() ) ); // Rank decides which skill is learned
		abilityObj.SetString("skillLevelStr", "SR_NOVICE");

		abilityObj.SetString("abilityName", skill.GetName() @ class'H7Loca'.static.LocalizeSave("SPELL_RANK_NOVICE","H7COMBAT") );
		abilityObj.SetString("iconPath", "img://" $ Pathname( skill.GetIcon() ));
		abilityObj.SetInt("skillID", skill.GetID());
		skillObj.SetElementObject(0, abilityObj);

		abilityObj = CreateObject("Object");
		abilityObj.SetString("abilityName", skill.GetName() @ class'H7Loca'.static.LocalizeSave("SPELL_RANK_EXPERT","H7COMBAT"));
		abilityObj.SetString("iconPath", "img://" $ Pathname( skill.GetIcon() ));
		//for now ervery skill rank has the same icon
		//abilityObj.SetString("SkillIcon", skill.GetFlashIconPath(SR_EXPERT));
		abilityObj.SetString("skillLevelStr", "SR_EXPERT");
		abilitySchool = skill.GetSchool();
		abilityObj.SetString("School", String(abilitySchool));

		if(!hero.GetSkillManager().CanLearnSkillRank(skill.GetID(), SR_EXPERT))
		{
			abilityObj.SetString("requirement", Repl( class'H7Loca'.static.LocalizeSave("TT_REQ_ONE_ABILITY","H7SkillWheel"), "%skillrank", "<font color='" $ replColor $ "'>" $ skill.GetName() @ class'H7Loca'.static.LocalizeSave(String(GetEnum(Enum'ESkillRank', SR_NOVICE)),"H7Abilities") $ "</font>"));
		}
		abilityObj.SetInt("skillID", skill.GetID());
		skillObj.SetElementObject(1, abilityObj);
		j = 2;

		// if this is an ultimate of a major skill, also add the master skill
		if(skillIndex < 6)
		{
			abilityObj = CreateObject("Object");
			abilityObj.SetString("abilityName", skill.GetName() @ class'H7Loca'.static.LocalizeSave("SPELL_RANK_MASTER","H7Combat"));
			if(!hero.GetSkillManager().CanLearnSkillRank(skill.GetID(), SR_MASTER))
			{
				abilityObj.SetString("requirement", Repl( class'H7Loca'.static.LocalizeSave("TT_REQ_ONE_ABILITY","H7SkillWheel"), "%skillrank", "<font color='" $ replColor $ "'>" $skill.GetName() @ class'H7Loca'.static.LocalizeSave(String(GetEnum(Enum'ESkillRank', SR_EXPERT)),"H7Abilities") $ "</font>"));
			}
			abilityObj.SetString("skillLevelStr", "SR_MASTER");
			abilityObj.SetString("iconPath", "img://" $ Pathname( skill.GetIcon() ));
			abilityObj.SetInt("skillID", skill.GetID());
			abilityObj.SetString("School", String(abilitySchool));
			skillObj.SetElementObject(2, abilityObj);
			j = 3;
		}

		abilities = skill.GetAllSkillAbilitiesArchetype();
		
		if(skillIndex < 3) //add ultimate ability
		{
			abilities.AddItem(skill.GetUltimateSkillAbiliyArchetype());
		}


		/// THIS ARE JUST ARCHETYPES!!
		for(k = 0; k <= 4; k++)//get all abilities from rank 1 and 2
		{
			abilityObj = CreateObject("Object");
			abilityObj.SetString("abilityName", abilities[k].GetName());
			abilityObj.SetString("abilityId", abilities[k].GetArchetypeID());
			if(skill.GetCurrentSkillRank() < abilities[k].GetRank())
			{
				abilityObj.SetString("requirement", Repl( class'H7Loca'.static.LocalizeSave("TT_REQ_SKILLLEVEL","H7SkillWheel"), "%skillrank", "<font color='" $ replColor $ "'>" $ skill.GetName() @ class'H7Loca'.static.LocalizeSave(String(GetEnum(Enum'ESkillRank', abilities[k].GetRank())),"H7Abilities") $ "</font>"));
			}
			abilityObj.SetString("iconPath", abilities[k].GetFlashIconPath());
			abilityObj.SetBool("learned", hero.GetSkillManager().HasLearnedAbility(abilities[k]));
			skillObj.SetElementObject(j, abilityObj);
			j++;
		}

		if(skillIndex < 6)// get the rank 3 ability
		{
			abilityObj = CreateObject("Object");
			abilityObj.SetString("abilityName", abilities[5].GetName());
			abilityObj.SetString("abilityId", abilities[k].GetArchetypeID());
			if(skill.GetCurrentSkillRank() < abilities[k].GetRank())
			{
				abilityObj.SetString("requirement", Repl( class'H7Loca'.static.LocalizeSave("TT_REQ_SKILLLEVEL","H7SkillWheel"), "%skillrank", "<font color='" $ replColor $ "'>" @ skill.GetName() @ class'H7Loca'.static.LocalizeSave(String(GetEnum(Enum'ESkillRank', abilities[k].GetRank())),"H7Abilities") $ "</font>"));
			}
			abilityObj.SetString("iconPath", abilities[5].GetFlashIconPath());
			abilityObj.SetBool("learned", hero.GetSkillManager().HasLearnedAbility(abilities[5]));
			skillObj.SetElementObject(j, abilityObj);	
			j++;
		}
		
		if(skillIndex < 3)// get the ultimate ability
		{
			abilityObj = CreateObject("Object");
			abilityObj.SetString("abilityName", abilities[6].GetName());
			abilityObj.SetString("abilityId", abilities[6].GetArchetypeID());
			if(!hero.GetSkillManager().CanLearnUltimate(skill.GetID()))
			{
				abilityObj.SetString("requirement", Repl( class'H7Loca'.static.LocalizeSave("TT_REQ_ALL_ABILITIES","H7SkillWheel"), "%skillrank", "<font color='" $ replColor $ "'>" @ skill.GetName() $ "</font>"));
			}
			abilityObj.SetString("iconPath", abilities[6].GetFlashIconPath());
			abilityObj.SetBool("learned", hero.GetSkillManager().HasLearnedAbility(abilities[6]));
			skillObj.SetElementObject(j, abilityObj);	
		}

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

	if(class'H7AdventureController'.static.GetInstance().GetRandomSkilling())
	{
		addRandomSkillsAndAbilities(hero);
		object.SetBool("RandomSkilling", true);
	}

	/*abilityObj = CreateObject("Object");
	abilityObj.SetString("AbilityName", hero.GetSpecialization().GetName());
	abilityObj.SetString("AbilityDesc", hero.GetSpecialization().GetTooltipForCaster(hero));
	object.SetObject("Specialization", abilityObj);*/

	object.SetObject("UltimateSkills", ultimateSkills);
	object.SetObject("MajorSkills", majorSkills);
	object.SetObject("MinorSkills", minorSkills);
	;
	object.SetInt("SkillPoints", hero.GetSkillPoints());
	object.SetBool("ShowAll", showAll);

	colorObject = CreateObject("Object");
	colorObject.SetInt("r", hero.GetPlayer().GetColor().R);
	colorObject.SetInt("g", hero.GetPlayer().GetColor().G);
	colorObject.SetInt("b", hero.GetPlayer().GetColor().B);
	object.SetObject("Color", colorObject);

	object.SetString("HeroName", hero.GetName());
	object.SetString("FactionName", hero.GetFaction().GetName());
	object.SetString("ClassName", hero.GetHeroClass().GetName());
	if(hero.GetSpecialization() != none)
	{
		object.SetString("SpecialName", hero.GetSpecialization().GetName());
		object.SetString("SpecialDesc", hero.GetSpecialization().GetTooltipForCaster(hero));
		object.SetString("SpecialIcon", hero.GetSpecialization().GetFlashIconPath());
		;
		object.SetString("SpecialFrame", hero.GetFactionSpecializationFrame());
	}
	object.SetString("HeroIcon", hero.GetFlashIconPath());
	object.SetString("FactionIcon", hero.GetFaction().GetFactionSepiaIconPath());

	SetObject("mData", object);
	ActionscriptVoid("Update");
}

function addRandomSkillsAndAbilities(H7EditorHero hero)
{

	local array<H7Skill> skills;
	local H7Skill skill;
	local array<H7HeroAbility> abilities;
	local H7HeroAbility ability;

	local H7SkillAbilityData abilityStruct, skillStruct;
	local array<H7SkillAbilityData> availableAbilities, availableSkills;
	
	skills = hero.GetSkillManager().GetRndSkillManager().GetPickedSkills();
	abilities = hero.GetSkillManager().GetRndSkillManager().GetPickedAbilities();

	foreach skills(skill)
	{
		;
		switch(skill.GetCurrentSkillRank()+1)
		{
			case 2 : skillStruct.abilityName = skill.GetName() @ class'H7Loca'.static.LocalizeSave("SPELL_RANK_NOVICE","H7COMBAT"); break;
			case 3 : skillStruct.abilityName = skill.GetName() @ class'H7Loca'.static.LocalizeSave("SPELL_RANK_EXPERT","H7COMBAT"); break;
			case 4 : skillStruct.abilityName = skill.GetName() @ class'H7Loca'.static.LocalizeSave("SPELL_RANK_MASTER","H7COMBAT"); break;
		}
		skillStruct.skillLevel = skill.GetCurrentSkillRank()+1;
		skillStruct.iconPath = "img://" $ Pathname( skill.GetIcon() );
		skillStruct.skillID = skill.GetID();
		skillStruct.learned = false;

		availableSkills.AddItem(skillStruct);
	}

	foreach abilities(ability)
	{
	 	;
		abilityStruct.abilityName = ability.GetName();
		abilityStruct.abilityID = ability.GetArchetypeID();
		abilityStruct.skillID = hero.GetSkillManager().GetSkillBySkillType( ability.GetSkillType() ).GetID();
		abilityStruct.iconPath = ability.GetFlashIconPath();
		abilityStruct.abilityRank = ability.GetRank();
		abilityStruct.learned = false;
	
		availableAbilities.AddItem(abilityStruct);
	}

	SetAvailableSkillsAndAbilities(availableSkills, availableAbilities);
}   

function SetAvailableSkillsAndAbilities(array<H7SkillAbilityData> availableSkills, array <H7SkillAbilityData> availableAbilities)
{
	ActionScriptVoid("SetAvailableSkillsAndAbilities");
}

function DisableAll()
{
	ActionScriptVoid("DisableAll");
}

function SetNewRandomSkillsAndAbilities(H7EditorHero hero)
{
	addRandomSkillsAndAbilities(hero);
	ActionScriptVoid("ShowNewRandomSkillsAndAbilities");
}

function SetHallOfHeroesMode()
{
	ActionScriptVoid("SetHallOfHeroesMode");
}

function SetArcaneAcademyMode()
{
	ActionScriptVoid("SetArcaneAcademyMode");
}

function SetSchoolOfWarMode()
{
	ActionScriptVoid("SetSchoolOfWarMode");
}

function CreateNewSkillwheel()
{
	ActionScriptVoid("CreateNewSkillwheel");
}   
