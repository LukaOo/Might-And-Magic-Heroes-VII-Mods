//=============================================================================
// H7GfxRandomSkillingPopup
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GfxRandomSkillingPopUp extends H7GFxUIContainer;

struct H7RandomSkillData
{
	
};

struct H7SkillAbilityData
{
	var String abilityName;
	var int abilityRank;
	var int skillLevel;
	var String skillLevelStr;
	var String iconPath;
	var String abilityID;
	var int skillID;
	var bool learned;
};

function Update(H7EditorHero hero)
{
	local GFxObject object, colorObject, heroObj;

	local array<H7Skill> skills;
	local H7Skill skill;
	local array<H7HeroAbility> abilities;
	local H7HeroAbility ability;

	local int attackIncrease, defenseIncrease, magicIncrease, spiritIncrease;

	local array<H7LevelUpData> levelUpData;
	local H7LevelUpData singleLevelUp;
	local H7SkillAbilityData abilityStruct, skillStruct, learnedSkill;
	local array<H7SkillAbilityData> availableAbilities, availableSkills;
	local array<H7SkillAbilityData> learnedSkills;

	levelUpData = hero.GetSkillManager().GetRndSkillManager().GetCurrentStatIncreases();
	attackIncrease  = 0;
	defenseIncrease = 0;
	magicIncrease   = 0;
	spiritIncrease  = 0;
	skills = hero.GetSkillManager().GetRndSkillManager().GetPickedSkills();
	abilities = hero.GetSkillManager().GetRndSkillManager().GetPickedAbilities();

	object = CreateObject("Object");

	foreach skills(skill)
	{
		;
		switch(skill.GetCurrentSkillRank()+1)
		{
			case 2 : skillStruct.abilityName = skill.GetName() @ class'H7Loca'.static.LocalizeSave("SPELL_RANK_NOVICE","H7COMBAT"); 
			         skillStruct.skillLevelStr = "SR_NOVICE";
			         break;
			case 3 : skillStruct.abilityName = skill.GetName() @ class'H7Loca'.static.LocalizeSave("SPELL_RANK_EXPERT","H7COMBAT"); 
			         skillStruct.skillLevelStr = "SR_EXPERT";
			         break;
			case 4 : skillStruct.abilityName = skill.GetName() @ class'H7Loca'.static.LocalizeSave("SPELL_RANK_MASTER","H7COMBAT"); 
					 skillStruct.skillLevelStr = "SR_MASTER";		 
			         break;
		}
		skillStruct.skillLevel = skill.GetCurrentSkillRank()+1;
		skillStruct.iconPath = "img://" $ Pathname( skill.GetIcon() );
		skillStruct.skillID = skill.GetID();
		;
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

	object.SetString("HeroName", hero.GetName());
	object.SetString("Level", String(levelUpData[levelUpData.Length - 1].Level));
	object.SetString("Class", hero.GetHeroClass().GetName());
	object.SetInt("SkillPoints", hero.GetSkillPoints());
	
	object.SetInt( "AttackOriginal", hero.GetBaseStatByID(STAT_ATTACK) );
	object.SetInt( "DefenseOriginal", hero.GetBaseStatByID(STAT_DEFENSE) );
	object.SetInt( "MagicOriginal", hero.GetBaseStatByID(STAT_MAGIC));
	object.SetInt( "SpiritOriginal", hero.GetBaseStatByID(STAT_SPIRIT));

	foreach levelUpData(singleLevelUp)
	{
		switch(singleLevelUp.Stat)
		{
			case STAT_ATTACK:  attackIncrease += singleLevelUp.Value; break;
			case STAT_DEFENSE: defenseIncrease += singleLevelUp.Value; break;
			case STAT_MAGIC:   magicIncrease += singleLevelUp.Value; break;
			case STAT_SPIRIT:  spiritIncrease += singleLevelUp.Value; break;
		}
	}

	object.SetInt( "AttackIncrease" , attackIncrease  );
	object.SetInt( "DefenseIncrease", defenseIncrease );
	object.SetInt( "MagicIncrease"  , magicIncrease   );
	object.SetInt( "SpiritIncrease" , spiritIncrease  );

	//LearnedSkills
	skills = hero.GetSkillManager().GetRndSkillManager().GetLeanedSkills();
	foreach skills(skill)
	{
		if(skill.GetCurrentSkillRank() == 1) continue;
		
		;
		switch(skill.GetCurrentSkillRank())
		{
			case 2 : learnedSkill.abilityName = skill.GetName() @ class'H7Loca'.static.LocalizeSave("SPELL_RANK_NOVICE","H7COMBAT"); break;
			case 3 : learnedSkill.abilityName = skill.GetName() @ class'H7Loca'.static.LocalizeSave("SPELL_RANK_EXPERT","H7COMBAT"); break;
			case 4 : learnedSkill.abilityName = skill.GetName() @ class'H7Loca'.static.LocalizeSave("SPELL_RANK_MASTER","H7COMBAT"); break;
		}
		learnedSkill.skillLevel = skill.GetCurrentSkillRank();
		learnedSkill.iconPath = "img://" $ Pathname( skill.GetIcon() );
		learnedSkill.skillID = skill.GetID();
		learnedSkill.learned = true;
		learnedSkills.AddItem(learnedSkill);
	}
	
	SetLearnedSkills(learnedSkills);

	object.SetString("AttackIcon", GetHud().GetProperties().mStatIcons.GetStatIconPath(STAT_ATTACK, hero));
	object.SetString("DefenseIcon", GetHud().GetProperties().mStatIcons.GetStatIconPath(STAT_DEFENSE, hero));
	object.SetString("MagicIcon", GetHud().GetProperties().mStatIcons.GetStatIconPath(STAT_MAGIC, hero));
	object.SetString("SpiritIcon", GetHud().GetProperties().mStatIcons.GetStatIconPath(STAT_SPIRIT, hero));

	colorObject = CreateObject("Object");
	colorObject.SetInt("r", hero.GetPlayer().GetColor().R);
	colorObject.SetInt("g", hero.GetPlayer().GetColor().G);
	colorObject.SetInt("b", hero.GetPlayer().GetColor().B);
	object.SetObject("Color", colorObject);

	heroObj = CreateObject("Object");
	hero.GUIWriteInto(heroObj);
	object.SetObject("Hero", heroObj);

	SetObject("mData", object);
	ActionScriptVoid("Update");

}

function SetAvailableSkillsAndAbilities(array<H7SkillAbilityData> availableSkills, array <H7SkillAbilityData> availableAbilities)
{
	ActionScriptVoid("SetSkillsAndAbilities");
}

function SetLearnedSkills(array<H7SkillAbilityData> learnedSkills)
{
	ActionScriptVoid("SetLearnedSkills");
}

function ResetBecuaseOpenPopUpFailed()
{
	ActionScriptVoid("Reset");
}
