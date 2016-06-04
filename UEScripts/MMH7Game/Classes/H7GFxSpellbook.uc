//=============================================================================
// H7GFxSpellbook
//
// Wrapper for H7GFxSpellbook.as
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxSpellbook extends H7GFxUIContainer
	dependson(H7StructsAndEnumsNative);

var H7MagicSchoolIcons mIcons;

function SetFilterIcons(H7MagicSchoolIcons icons)
{
	local GFxObject iconPaths;
	iconPaths = CreateObject("Object");

	iconPaths.SetString("FilterMight", "img://" $ Pathname(icons.GetSchoolIcon(MIGHT)));
	iconPaths.SetString("FilterAir", "img://" $ Pathname(icons.GetSchoolIcon(AIR_MAGIC)));
	iconPaths.SetString("FilterDark", "img://" $ Pathname(icons.GetSchoolIcon(DARK_MAGIC)));
	iconPaths.SetString("FilterEarth", "img://" $ Pathname(icons.GetSchoolIcon(EARTH_MAGIC)));
	iconPaths.SetString("FilterFire", "img://" $ Pathname(icons.GetSchoolIcon(FIRE_MAGIC)));
	iconPaths.SetString("FilterLight", "img://" $ Pathname(icons.GetSchoolIcon(LIGHT_MAGIC)));
	iconPaths.SetString("FilterPrime", "img://" $ Pathname(icons.GetSchoolIcon(PRIME_MAGIC)));
	iconPaths.SetString("FilterWater", "img://" $ Pathname(icons.GetSchoolIcon(WATER_MAGIC)));

	iconPaths.SetString("FilterCombat", "img://" $ Pathname(icons.GetFilterIcon("combat")));
	iconPaths.SetString("FilterAdventure", "img://" $ Pathname(icons.GetFilterIcon("adventure")));
	iconPaths.SetString("FilterDamage", "img://" $ Pathname(icons.GetFilterIcon("damage")));
	iconPaths.SetString("FilterUtility", "img://" $ Pathname(icons.GetFilterIcon("utility")));
	iconPaths.SetString("FilterNoFilter", "img://" $ Pathname(icons.GetFilterIcon("nofilter")));

	SetObject("mIcons", iconPaths);
	ActionscriptVoid("SetFilterIcons");
}

function SetBGs(H7MagicSchoolIcons icons)
{
	local GFxObject iconPaths;
	iconPaths = CreateObject("Object");

	iconPaths.SetString("MightBG", "img://" $ Pathname(icons.GetSchoolBG(MIGHT)));
	iconPaths.SetString("AirBG", "img://" $ Pathname(icons.GetSchoolBG(AIR_MAGIC)));
	iconPaths.SetString("DarkBG", "img://" $ Pathname(icons.GetSchoolBG(DARK_MAGIC)));
	iconPaths.SetString("EarthBG", "img://" $ Pathname(icons.GetSchoolBG(EARTH_MAGIC)));
	iconPaths.SetString("FireBG", "img://" $ Pathname(icons.GetSchoolBG(FIRE_MAGIC)));
	iconPaths.SetString("LightBG", "img://" $ Pathname(icons.GetSchoolBG(LIGHT_MAGIC)));
	iconPaths.SetString("PrimeBG", "img://" $ Pathname(icons.GetSchoolBG(PRIME_MAGIC)));
	iconPaths.SetString("WaterBG", "img://" $ Pathname(icons.GetSchoolBG(WATER_MAGIC)));

	SetObject("mBGs", iconPaths);
}

function SetTitleIcons(H7MagicSchoolIcons icons)
{
	local GFxObject iconPaths;
	iconPaths = CreateObject("Object");
	mIcons = icons;	

	iconPaths.SetString("MightTitleIcon", "img://" $ Pathname(icons.GetSchoolTitleIcon(MIGHT)));
	iconPaths.SetString("AirTitleIcon", "img://" $ Pathname(icons.GetSchoolTitleIcon(AIR_MAGIC)));
	iconPaths.SetString("DarkTitleIcon", "img://" $ Pathname(icons.GetSchoolTitleIcon(DARK_MAGIC)));
	iconPaths.SetString("EarthTitleIcon", "img://" $ Pathname(icons.GetSchoolTitleIcon(EARTH_MAGIC)));
	iconPaths.SetString("FireTitleIcon", "img://" $ Pathname(icons.GetSchoolTitleIcon(FIRE_MAGIC)));
	iconPaths.SetString("LightTitleIcon", "img://" $ Pathname(icons.GetSchoolTitleIcon(LIGHT_MAGIC)));
	iconPaths.SetString("PrimeTitleIcon", "img://" $ Pathname(icons.GetSchoolTitleIcon(PRIME_MAGIC)));
	iconPaths.SetString("WaterTitleIcon", "img://" $ Pathname(icons.GetSchoolTitleIcon(WATER_MAGIC)));

	SetObject("mTitleIcons", iconPaths);
}

function SetSpellFrames(H7MagicSchoolIcons icons)
{
	local GFxObject iconPaths;
	iconPaths = CreateObject("Object");

	iconPaths.SetString("MightFrameBase", "img://" $ Pathname(icons.GetSpellFrame(MIGHT, false)));
	iconPaths.SetString("MightFrameUpgrade", "img://" $ Pathname(icons.GetSpellFrame(MIGHT, true)));
	iconPaths.SetString("AirFrameBase", "img://" $ Pathname(icons.GetSpellFrame(AIR_MAGIC, false)));
	iconPaths.SetString("AirFrameUpgrade", "img://" $ Pathname(icons.GetSpellFrame(AIR_MAGIC, true)));
	iconPaths.SetString("DarkFrameBase", "img://" $ Pathname(icons.GetSpellFrame(DARK_MAGIC, false)));
	iconPaths.SetString("DarkFrameUpgrade", "img://" $ Pathname(icons.GetSpellFrame(DARK_MAGIC, true)));
	iconPaths.SetString("EarthFrameBase", "img://" $ Pathname(icons.GetSpellFrame(EARTH_MAGIC, false)));
	iconPaths.SetString("EarthFrameUpgrade", "img://" $ Pathname(icons.GetSpellFrame(EARTH_MAGIC, true)));
	iconPaths.SetString("FireFrameBase", "img://" $ Pathname(icons.GetSpellFrame(FIRE_MAGIC, false)));
	iconPaths.SetString("FireFrameUpgrade", "img://" $ Pathname(icons.GetSpellFrame(FIRE_MAGIC, true)));
	iconPaths.SetString("LightFrameBase", "img://" $ Pathname(icons.GetSpellFrame(LIGHT_MAGIC, false)));
	iconPaths.SetString("LightFrameUpgrade", "img://" $ Pathname(icons.GetSpellFrame(LIGHT_MAGIC, true)));
	iconPaths.SetString("PrimeFrameBase", "img://" $ Pathname(icons.GetSpellFrame(PRIME_MAGIC, false)));
	iconPaths.SetString("PrimeFrameUpgrade", "img://" $ Pathname(icons.GetSpellFrame(PRIME_MAGIC, true)));
	iconPaths.SetString("WaterFrameBase", "img://" $ Pathname(icons.GetSpellFrame(WATER_MAGIC, false)));
	iconPaths.SetString("WaterFrameUpgrade", "img://" $ Pathname(icons.GetSpellFrame(WATER_MAGIC, true)));

	SetObject("mSpellFrames", iconPaths);
}

function Update( )
{
	ActionscriptVoid("Update");
}


function SetData(H7EditorHero hero, bool onCombatMap)
{
	local GFxObject data;
	data = CreateObject("Object");
	
	CreateScreenObject( hero, data, onCombatMap );
	SetObject( "mData" , data);

	Update();
	SetVisibleSave(true);
}

function CreateScreenObject( H7EditorHero hero , out GFxObject object, bool onCombatMap )
{
	local GFxObject spellListObject; 
	local array<H7HeroAbility> spells;
	hero.GetSpells( spells ); 
	spellListObject = CreateArray();
	CreateSpellList( spells, spellListObject , hero );
	
	// basic localization + Text 
	object.SetBool("OnCombatMap", onCombatMap);
	object.SetObject( "SpellList" , spellListObject );
	object.SetInt( "CurrentHeroMana", hero.GetCurrentMana()  ); 
	object.SetInt( "MaxHeroMana", hero.GetMaxMana());
	object.SetString("HeroName", hero.GetName());
	object.SetInt( "MaxMana", hero.GetMaxMana() );
	;
}


protected function CreateSpellList( array<H7HeroAbility> spells, out GfxObject object, H7EditorHero hero, optional int i )
{
	local GFxObject tempObj; 
	local H7HeroAbility spell;
	local String blockReason,infoString;
	local array<String> stackableItemsAlreadyInObject;

	;

	foreach spells( spell ) 
	{
		if(H7HeroItem(spell.GetSourceEffect()) != none && stackableItemsAlreadyInObject.Find( H7HeroItem(spell.GetSourceEffect()).GetName() ) != -1)
		{
			;
			continue;
		}

		blockReason = "";
		//`log_gui("creating spell obejct for"@spell.GetName());
		tempObj = CreateObject( "Object" );
		tempObj.SetInt( "AbilityId", spell.GetID() );
		tempObj.SetBool( "IsCombatAbility", spell.IsCombatAbility());
		tempObj.SetBool( "IsActive", hero.HasBuffFromAbility( spell ));
		if(hero.HasBuffFromAbility( spell ))
		{
			tempObj.SetString( "Note", "<font size='#TT_BODY#' color='#ff0000'>" $ class'H7Loca'.static.LocalizeSave("TT_ONLY_REFRESH","H7Abilities") $ "</font>");
		}
		tempObj.SetBool("IsScroll", H7HeroItem(spell.GetSourceEffect()) != none);
		if(H7HeroItem(spell.GetSourceEffect()) != none && H7HeroItem(spell.GetSourceEffect()).IsStackable())
		{
			tempObj.SetInt("StackSize",  hero.GetInventory().GetTotalCountOfScroll(H7HeroItem(spell.GetSourceEffect())));
			stackableItemsAlreadyInObject.AddItem(H7HeroItem(spell.GetSourceEffect()).GetName());
		}
		else if( hero.GetSkillManager().GetSkillBySkillType(spell.GetSkillType()) != none )
		{
			// if ability doesnt originate from scroll, add the sillname of ability so in case the skillLevel
			// is too low we can add the skill name to the block reason
			tempObj.SetString( "SkillName", hero.GetSkillManager().GetSkillBySkillType(spell.GetSkillType()).GetName());
		}
		tempObj.SetBool( "IsWarcry", spell.GetSchool() == MIGHT ? true : false);
		tempObj.SetBool( "DamageFilter", spell.IsDamageFilter() );
		tempObj.SetBool("UtilityFilter", spell.IsUtilityFilter());
		tempObj.SetString("School", String(spell.GetSchool()));
		tempObj.SetString ( "AbilityIconPath", spell.GetFlashIconPath() );
		tempObj.SetString ( "SchoolIconPath", spell.GetSchoolFlashPath(spell.GetSchool()) );
		tempObj.SetString( "AbilityName", spell.GetName() );
		tempObj.SetString ( "AbilityDesc", spell.GetTooltipForCaster(hero,false) ); // don't reset rank override; it's needed later!
		tempObj.SetInt( "AbilityManaCost", spell.GetManaCost() );
		tempObj.SetBool( "AbilityCanCast", spell.CanCast(blockReason) );
		tempObj.SetString( "BlockReason", blockReason);
		tempObj.SetInt("PassedCooldown", spell.GetCooldownTimerCurrent());
		tempObj.SetInt("MaxCooldown", spell.GetCooldownTimer());
		tempObj.SetString("Frame", "img://" $ Pathname( mIcons.GetSpellFrame(spell.GetSchool(), spell.IsUpgraded(hero))));
		
		// info box
		infoString = spell.GetInfoBox(hero,!spell.IsFromScroll());
		tempObj.SetString( "CasterRank", infoString ); // remove on next gui rebuild
		tempObj.SetString( "InfoBox", infoString );
		
		spell.SetRankOverride(SR_MAX); // now we can reset the rank override

		object.SetElementObject(i, tempObj);

		i++;
		
	}
}

// Default properties block
