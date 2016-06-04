//=============================================================================
// H7GFxBattleMapResultWindow
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxCheatWindow extends H7GFxUIContainer;


function Update(String map)
{
	local GFxObject data;
	local H7EditorHero hero;
	local H7Unit currentUnit;
	
	// OPTIONAL: decide if we want to edit creature stats separately too or just modify the hero
	
	data = CreateObject("Object");

	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		hero = class'H7CombatController'.static.GetInstance().GetActiveArmy().GetHero();
		currentUnit = class'H7CombatController'.static.GetInstance().GetActiveUnit();
		
		CreateSkills(data,hero);

		data.SetInt( "MagicOriginal", hero.GetBaseStatByID(STAT_MAGIC));
		data.SetInt( "Magic", hero.GetMagic());

		data.SetInt( "SpiritOriginal", hero.GetBaseStatByID(STAT_SPIRIT));
		data.SetInt( "Spirit", hero.GetSpirit());

		if(currentUnit == none)
		{
			;
		}
		else
		{
			data.SetBool("IsHero", hero == currentUnit );
			data.SetString("UnitName", currentUnit.GetName());
		
			data.SetInt( "MinDamage", currentUnit.GetMinimumDamage() );
			data.SetInt( "MinDamageOriginal", currentUnit.GetMinimumDamageBase() );
			data.SetInt( "MaxDamage", currentUnit.GetMaximumDamage() );
			data.SetInt( "MaxDamageOriginal", currentUnit.GetMaximumDamageBase() );
		
			data.SetInt( "AttackOriginal", currentUnit.GetBaseStatByID(STAT_ATTACK) );
			data.SetInt( "Attack", currentUnit.GetAttack() );

			data.SetInt( "DefenseOriginal", currentUnit.GetBaseStatByID(STAT_DEFENSE) );
			data.SetInt( "Defense", currentUnit.GetDefense() );

			data.SetInt( "DestinyOriginal", currentUnit.GetBaseStatByID(STAT_LUCK_DESTINY) );
			data.SetInt( "Destiny", currentUnit.GetDestiny() );

			data.SetInt( "LeadershipOriginal", currentUnit.GetBaseStatByID(STAT_MORALE_LEADERSHIP) );
			data.SetInt( "Leadership", currentUnit.GetLeadership() );

			data.SetInt( "InitiativeOriginal", currentUnit.GetBaseStatByID(STAT_INITIATIVE) );
			data.SetInt( "Initiative", currentUnit.GetInitiative() );

			data.SetInt( "MoveOriginal", currentUnit.GetBaseStatByID(STAT_MOVE_COUNT));
			data.SetInt( "Move", currentUnit.GetMovementPoints());
		}

		data.SetString("Map", "CombatMap");
	}
	else
	{
		hero = class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero();
		
		CreateSkills(data,hero);

		data.SetBool("IsHero", true);
		data.SetString("UnitName", hero.GetName());

		data.SetInt( "Destiny", hero.GetDestiny() );
		data.SetInt( "Leadership", hero.GetLeadership() );
		
		data.SetInt( "MinDamage", hero.GetMinimumDamage() );
		data.SetInt( "MinDamageOriginal", hero.GetMinimumDamageBase() );
		data.SetInt( "MaxDamage", hero.GetMaximumDamage() );
		data.SetInt( "MaxDamageOriginal", hero.GetMaximumDamageBase() );
		data.SetInt( "AttackOriginal", hero.GetBaseStatByID(STAT_ATTACK) );
		data.SetInt( "Attack", hero.GetAttack() );
	
		data.SetInt( "DefenseOriginal", hero.GetDefense() );
		data.SetInt( "Defense", hero.GetDefense() );

		data.SetInt( "DestinyOriginal", hero.GetDestiny() );

		data.SetInt( "LeadershipOriginal", hero.GetLeadership() );

		data.SetInt( "InitiativeOriginal", hero.GetBaseStatByID(STAT_INITIATIVE) );
		data.SetInt( "Initiative", hero.GetInitiative() );

		data.SetInt( "MoveOriginal", hero.GetBaseStatByID(STAT_MOVE_COUNT));
		data.SetInt( "Move", hero.GetMovementPoints());

		data.SetBool( "TurnOver",  class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTurnOverCntl().GetIsHotSeat() );

		data.SetString("Map", "AdventureMap");
	}

	data.SetBool("NoMana",class'H7GUIGeneralProperties'.static.GetInstance().GetUnlimitedMana());
	data.SetBool("NoMove",class'H7GUIGeneralProperties'.static.GetInstance().GetUnlimitedMovement());
	data.SetBool("UnlimitedBuilding",class'H7GUIGeneralProperties'.static.GetInstance().IsUnlimitedBuilding());

	SetObject( "mData" , data);

	ActionscriptVoid("Update");
}

// 0-2 ultimate
// 3-5 major
// 6-9 minor
function String GetSkillClassString(int index)
{
	if(index >= 0 && index <= 2) return "ultimate";
	if(index >= 3 && index <= 6) return "major";
	if(index >= 7 && index <= 9) return "minor";
	return "???";
}

function CreateSkills(out GFxObject data,H7EditorHero hero)
{
	local GFxObject skillOb,list,entry;
	local array<H7Skill> skills;
	local H7Skill skill;
	local int i;
	local array<string> skillnames;
	local string    skillname;

	;
	skillOb = CreateObject("Object");

	// Hero Skills
	i = 0;
	list = CreateArray();
	skills = hero.GetSkillManager().GetAllSkills();
	;
	for(i=0;i<10;i++)
	{
		entry = CreateObject("Object");
		if(i < skills.Length) 
		{
			skill = skills[i];
			;
			entry.SetInt("ID",skill.GetID());
			entry.SetString("AID",skill.GetArchetypeID());
			entry.SetString("Name",i $ GetSkillClassString(i) $ ":" @ skill.GetName());
			entry.SetInt("Rank",skill.GetCurrentSkillRank() - 1);
			entry.SetObject("Abilities",CreateAbilities(skill,hero));
		}
		else 
		{
			skill = none;
			entry.SetInt("ID",0);
			entry.SetString("Name",i $ GetSkillClassString(i) $ ":" @ "None");
			entry.SetInt("Rank",0);
		}

		list.SetElementObject(i,entry);
	}
	skillOb.SetObject("HeroSkills",list);

	// Game Skills
	list = CreateArray();
    skillnames = class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().GetCheatData().GetSkillNames();
	;
	foreach skillnames(skillname,i)
	{
		entry = CreateObject("Object");	
		entry.SetString("AID", skillname);
		entry.SetString("Name",skillname);
		
		list.SetElementObject(i,entry);
	}
	skillOb.SetObject("AllSkills",list);


	data.SetObject("Skills",skillOb);	
}

function GFxObject CreateAbilities(H7Skill skill,H7EditorHero hero)
{
	local GFxObject list,abilityData;
	local array<H7HeroAbility> abilities;
	local H7HeroAbility ability;
	local int i;

	list = CreateArray();
	abilities = skill.GetAllSkillAbilitiesArchetype();
	abilities.AddItem(skill.GetUltimateSkillAbiliyArchetype());
	i = 0;
	foreach abilities(ability)
	{
		;
		abilityData = CreateObject("Object");
		abilityData.SetString("ID",ability.GetArchetypeID());
		abilityData.SetString("Name",ability.GetName());
		abilityData.SetBool("Learned",hero.GetAbilityManager().HasAbility(ability));
		abilityData.SetBool("CanLearn",skill.CanLearnAbility(ability));
	
		list.SetElementObject(i,abilityData);
		i++;
	}

	return list;
}
