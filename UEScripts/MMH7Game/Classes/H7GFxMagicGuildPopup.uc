//=============================================================================
// H7GFxMagicGuildPopup
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxMagicGuildPopup extends H7GFxTownPopup;

function Update(H7Town town)
{
	local GFxObject data, spellsData;
	local H7TownMagicGuild bestMagicGuild;
	local array<H7HeroAbility> spells;
	local H7TownBuildingData magicGuild, arcaneLibrary;
	local array<H7TownBuildingData> magicGuilds;
	local H7HeroAbility townPortalSpell;

	magicGuild = town.GetBuildingDataByType(class'H7TownMagicGuild');
	bestMagicGuild = H7TownMagicGuild(town.GetBestBuilding(magicGuild).Building);

	spells = town.GetAvailableSpells();
	data = CreateObject("Object");
	spellsData = CreateArray();
	townPortalSpell = H7TownPortal(town.GetBuildingByType(class'H7TownPortal')).GetTownPortalSpell();

	CreateSpellList( spells , townPortalSpell, spellsData );

	data.SetObject( "Spells", spellsData );

	AddSchoolsAndPortal( data, town );

	//For the case the player build the expert magic guild and the novice was predefined and he haven't choosen the spec, it needs to be still active afterwards
	if(!town.GetMageGuildSpecialisationStatus()) // TODO Achim why is the magic guild rank relevant && bestMagicGuild.GetRank() == SR_NOVICE || !town.GetMageGuildSpecialisationStatus() && bestMagicGuild.GetRank() == SR_EXPERT)
	{
		AddSchoolSelect( data , bestMagicGuild , town);
	}

	magicGuilds = town.GetBuildingsByType(class'H7TownMagicGuild');
	arcaneLibrary = town.GetBuildingDataByType(class'H7TownArcaneLibrary');

	//reusing magicGuild variable
	//set which guild tiers need to be tweened
	foreach magicGuilds(magicGuild)
	{
		if(!magicGuild.IsBuilt) continue;
		switch(H7TownMagicGuild(magicGuild.Building).GetRank())
		{
			case SR_UNSKILLED: data.SetBool("UnskilledSeen", H7TownMagicGuild(magicGuild.Building).WasSeenByPlayer());
							   if(arcaneLibrary.Building != none && arcaneLibrary.IsBuilt) data.SetBool("UnskilledLibrarySeen", H7TownMagicGuild(magicGuild.Building).HasSeenLibrarySpells());
							   break;
			case SR_NOVICE:    data.SetBool("NoviceSeen", H7TownMagicGuild(magicGuild.Building).WasSeenByPlayer());
							   if(arcaneLibrary.Building != none && arcaneLibrary.IsBuilt) data.SetBool("NoviceLibrarySeen", H7TownMagicGuild(magicGuild.Building).HasSeenLibrarySpells());
							   break;
			case SR_EXPERT:    data.SetBool("ExpertSeen", H7TownMagicGuild(magicGuild.Building).WasSeenByPlayer());
							   if(arcaneLibrary.Building != none && arcaneLibrary.IsBuilt) data.SetBool("ExpertLibrarySeen", H7TownMagicGuild(magicGuild.Building).HasSeenLibrarySpells());
							   break;
			case SR_MASTER:    data.SetBool("MasterSeen", H7TownMagicGuild(magicGuild.Building).WasSeenByPlayer());
							   if(arcaneLibrary.Building != none && arcaneLibrary.IsBuilt) data.SetBool("MasterLibrarySeen", H7TownMagicGuild(magicGuild.Building).HasSeenLibrarySpells());
							   break;
		}
		if(town.GetMageGuildSpecialisationStatus())
		{
			H7TownMagicGuild(magicGuild.Building).SetSeenByPlayer(true);
			
			if(arcaneLibrary.Building != none && arcaneLibrary.IsBuilt)
				H7TownMagicGuild(magicGuild.Building).SetSeenLibrarySpells(true);
		}
		
	}

	data.SetInt( "MagicGuildRank", bestMagicGuild.GetRank());
	SetObject("mData", data);

	ActionScriptVoid("Update");
}

protected function AddSchoolsAndPortal(out GFxObject data,H7Town town)
{
	local String factionName;
	local EAbilitySchool prefSchool,specSchool,forbiddenSchool;
	local H7HeroAbility townPortalSpell;

	factionName = town.GetFaction().GetName();
	prefSchool = town.GetFaction().GetPreferredAbilitySchool();
	forbiddenSchool = town.GetFaction().GetForbiddenAbilitySchool();
	specSchool = town.GetSpecialisation();

	;

	if(prefSchool != ABILITY_SCHOOL_NONE)
	{
		data.SetString("prefTT",Repl(Repl(class'H7Loca'.static.LocalizeSave("TT_SCHOOL_PREFERED","MagicGuild"),"%faction",factionName),"%school",class'H7Loca'.static.LocalizeSave("SCHOOL_" $ prefSchool,"H7Abilities")));
		data.SetString("prefIcon",class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mMagicSchoolIcons.GetSchoolIconPath(prefSchool));
	}
	else
	{
		data.SetString("prefTT",Repl(Repl(class'H7Loca'.static.LocalizeSave("TT_SCHOOL_PREFERED_NO","MagicGuild"),"%faction",factionName),"%school",class'H7Loca'.static.LocalizeSave("SCHOOL_" $ prefSchool,"H7Abilities")));
		data.SetString("prefIcon",""); // icon becomes invisible
	}

	if(specSchool != ABILITY_SCHOOL_NONE)
	{
		data.SetString("specTT",Repl(Repl(class'H7Loca'.static.LocalizeSave("TT_SCHOOL_SPECIALIZED","MagicGuild"),"%faction",factionName),"%school",class'H7Loca'.static.LocalizeSave("SCHOOL_" $ specSchool,"H7Abilities")));
		data.SetString("specIcon",class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mMagicSchoolIcons.GetSchoolIconPath(specSchool));
	}
	else
	{
		data.SetString("specTT",class'H7Loca'.static.LocalizeSave("TT_SCHOOL_SPECIALIZED_NO","MagicGuild"));
		data.SetString("specIcon",class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mMagicSchoolIcons.GetSchoolIconPath(specSchool)); // no school icon 
	}

	if(forbiddenSchool != ABILITY_SCHOOL_NONE)
	{
		data.SetString("forbTT",Repl(Repl(class'H7Loca'.static.LocalizeSave("TT_SCHOOL_FORBIDDEN","MagicGuild"),"%faction",factionName),"%school",class'H7Loca'.static.LocalizeSave("SCHOOL_" $ forbiddenSchool,"H7Abilities")));
		data.SetString("forbIcon",class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mMagicSchoolIcons.GetSchoolIconPath(forbiddenSchool));
	}
	else
	{
		data.SetString("forbTT",Repl(Repl(class'H7Loca'.static.LocalizeSave("TT_SCHOOL_FORBIDDEN_NO","MagicGuild"),"%faction",factionName),"%school",class'H7Loca'.static.LocalizeSave("SCHOOL_" $ forbiddenSchool,"H7Abilities")));
		data.SetString("forbIcon",""); // icon becomes invisible
	}

	data.SetString("FactionBanner",town.GetFactionBannerIconPath());
	town.DelFactionBannerIconRef();
	data.SetString("TownPortalSymbol",town.GetFactionPortalFramePath());
	town.DelFactionTownPortalFrameRef();
	
	//townPortal Spell
	townPortalSpell = H7TownPortal(town.GetBuildingByType(class'H7TownPortal')).GetTownPortalSpell();
	if(townPortalSpell != none)
		data.SetObject("TownPortalSpell",CreateGuildSpellObject(townPortalSpell));
}

protected function AddSchoolSelect(out GFxObject data,H7TownMagicGuild bestMagicGuild,H7Town town)
{
	local EAbilitySchool forbiddenSchool,prefSchool,loopSchool;
	local GFxObject school,schoolList;
	local int i,j;

	j = 0;
	forbiddenSchool = town.GetFaction().GetForbiddenAbilitySchool();
	prefSchool = town.GetFaction().GetPreferredAbilitySchool();
	
	if(!town.GetMageGuildSpecialisationStatus())
	{
		data.SetString("Question",class'H7Loca'.static.LocalizeSave("TT_SPEC_QUESTION","MagicGuild"));

		schoolList = CreateArray();

		for(i=0;i<EAbilitySchool_MAX;i++)
		{
			loopSchool = EAbilitySchool(i);
			if(loopSchool != forbiddenSchool && loopSchool != prefSchool && loopSchool != ALL 
				&& loopSchool != ALL_MAGIC && loopSchool != ABILITY_SCHOOL_NONE && loopSchool != MIGHT)
			{
				school = CreateObject("Object");
				school.SetInt("ID",loopSchool);
				school.SetString("Name",class'H7Loca'.static.LocalizeSave("SCHOOL_" $ loopSchool,"H7Abilities"));
				school.SetString("Icon",class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mMagicSchoolIcons.GetSchoolIconPath(loopSchool));
				schoolList.SetElementObject(j,school);
				j++;
			}
		}

		data.SetObject("Schools",schoolList);
	}
}

protected function CreateSpellList( array<H7HeroAbility> spells, H7HeroAbility townPortalSpell, out GfxObject object )
{
	local GFxObject tempObj; 
	local H7HeroAbility spell;
	local int i;

	i = 0;
	;

	foreach spells( spell ) 
	{
		if(spell == townPortalSpell)
		{
			;
			continue;
		}
		;

		tempObj = CreateGuildSpellObject(spell);

		object.SetElementObject(i, tempObj);
		i++;
	}
}

function GFxObject CreateGuildSpellObject(H7HeroAbility spell)
{
	local GFxObject tempObj,skillLines;
	local string ttMessage;
	local byte spellLevelNumber;
	local int akNeeded;
	local ESkillRank rankNeeded;
	
	if(!spell.DidInstanciateEffects())
	{
		spell.InstanciateEffectsFromStructData();
	}

	// OPTIONAL .Available to grey out or not
	tempObj = CreateObject( "Object" );
	tempObj.SetInt( "AbilityId", spell.GetID() );
	tempObj.SetBool( "IsCombatAbility", spell.IsCombatAbility());
	tempObj.SetBool( "DamageFilter", spell.IsDamageFilter() );
	tempObj.SetBool("UtilityFilter", spell.IsUtilityFilter());
	tempObj.SetString ( "AbilityIconPath", spell.GetFlashIconPath() );
	tempObj.SetString ( "AbilityDesc", spell.GetTooltip() );
	tempObj.SetString( "AbilityName", spell.GetName() );
	tempObj.SetBool( "AbilityCanCast", spell.CanCast() );
	tempObj.SetInt( "AbilityManaCost", spell.GetManaCost() );
	tempObj.SetInt( "Rank", spell.GetRank() );
	
	spellLevelNumber = spell.GetRank();
	
	//tempObj.SetString("School", String(spell.GetSchool()));
	//tempObj.SetString ( "SchoolIconPath", spell.GetSchoolFlashPath(spell.GetSchool()) );
	
	// Fire Magic - Tier 3
	tempObj.SetString("SchoolName", class'H7Loca'.static.LocalizeSave("FULL_SCHOOL_" $ String(spell.GetSchool()),"H7Abilities") @ "-" @ Repl(class'H7Loca'.static.LocalizeSave("TIER_X","H7Abilities"),"%tier",String(spellLevelNumber))  );
	tempObj.SetString("SchoolColor", "0x" $ spell.GetSchoolColor(spell.GetSchool()) ) ;
	
	// Level 1 Spell
	//ttMessage = `Localize("H7Abilities","RANK_DESC_SR_ALL_RANKS","MMH7Game");
	//ttMessage = Repl(ttMessage, "%ranknumber", spellLevelNumber );
	//tempObj.SetString( "RankDesc", ttMessage );

	// Requires Expert in Fire Magic
	ttMessage = class'H7Loca'.static.LocalizeSave("CASTER_SKILL","H7Abilities");
	rankNeeded = spell.GetRank();
	akNeeded = class'H7AdventureController'.static.GetInstance().GetConfig().mArcaneKnowledgeTiers[int(rankNeeded)-1];
	ttMessage = Repl(ttMessage, "%arcaneknowledge", String(akNeeded) @ class'H7GUIGeneralProperties'.static.GetInstance().mStatIconsInText.GetStatIconPathHTML(STAT_ARCANE_KNOWLEDGE) @ class'H7Loca'.static.LocalizeSave("STAT_ARCANE_KNOWLEDGE","H7Abilities") );
	if(spell.GetRank() != SR_UNSKILLED)
	{
		tempObj.SetString( "SkillHeadline", ttMessage );
	}

	skillLines = CreateArray();
	skillLines.SetElementString(0,spell.GetEffectOnRankAsLine(SR_UNSKILLED));
	skillLines.SetElementString(1,spell.GetEffectOnRankAsLine(SR_NOVICE));
	skillLines.SetElementString(2,spell.GetEffectOnRankAsLine(SR_EXPERT));
	skillLines.SetElementString(3,spell.GetEffectOnRankAsLine(SR_MASTER));

	tempObj.SetObject("SkillLines", skillLines);
	return tempObj;
}

function NewSpellsByUpgrade()
{
	ActionScriptVoid("NewSpellByUpgrade");
}

function NewSpellByArcaneLibary()
{
	ActionScriptVoid("NewSpellByArcaneLibary");
}
