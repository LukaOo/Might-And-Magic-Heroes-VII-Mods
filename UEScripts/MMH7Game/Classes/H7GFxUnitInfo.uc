//=============================================================================
// H7GFxUnitInfo
//
// Wrapper for UnitInfo.as
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxUnitInfo extends H7GFxUIContainer;

var protected H7Unit mOldDisplayedUnit;

function H7Unit GetCurrentlyDisplayedUnit()
{
	return mOldDisplayedUnit;
}

function Update( )
{
	ActionscriptVoid("Update");
}

function Hide()
{
	SetVisibleSave(false);
	mOldDisplayedUnit = none;
	class'H7ListeningManager'.static.GetInstance().RemoveListener(self);
}

function ListenUpdate(H7IGUIListenable unit)
{
	;
	SetUnitInfo(H7Unit(unit));
}

function SetUnitInfo(H7Unit unit)
{	
	local GFxObject data;

	//if( mOldDisplayedUnit == unit ) { return; } // don't update if unit is still the same // this breaks the listening system
	
	data = CreateObject("Object");
	
	CreateUnitObjectForInfoWindow( unit, data );

	SetObject( "mData" , data);
	Update();

	mOldDisplayedUnit = unit;

	ListenTo(unit);
}

 function CreateUnitObjectForInfoWindow( H7Unit unit, out GFxObject object) 
{	
	// Unit
	object = CreateUnitObject(unit);
	CreateAbilities( unit, object );
	CreateBuffs( unit, object );

	object.SetInt("MaxLuck", class'H7CombatController'.static.GetInstance().GetCombatConfiguration().GetLuckMax());
	object.SetInt("MinLuck", class'H7CombatController'.static.GetInstance().GetCombatConfiguration().GetLuckMin());
	object.SetInt("MaxMorale", class'H7CombatController'.static.GetInstance().GetCombatConfiguration().GetMoraleMax());
	object.SetInt("MinMorale", class'H7CombatController'.static.GetInstance().GetCombatConfiguration().GetMoraleMin());

}

// new function that should handle hero,stack,warfareunit,every unit
function GFxObject CreateUnitObject(H7Unit unit)
{
	local GFxObject object;
	local H7CombatHero hero;
	local H7CreatureStack creatureStack;
	local H7WarUnit warUnit; 
	local H7TowerUnit tower; 
	
	// common basics
	object = CreateObject("Object");
	object.SetInt( "UnrealID"       , unit.GetID());
	object.SetString( "UnitType"    , String(GetEnum(Enum'EUnitType',unit.GetEntityType())));
	object.SetString( "UnitName"    , unit.GetName() );
	object.SetString( "FactionName" , unit.GetFaction().GetName() );
	object.SetString( "Icon"        , unit.GetFlashIconPath() );
	object.SetString( "SchoolName"  , String(GetEnum(Enum'EAbilitySchool',unit.GetSchool())) );

	// tier or class
	if(unit.IsA('H7CreatureStack')) object.SetString( "TypeInfo" , H7CreatureStack(unit).GetCreature().GetTierString() );
	else if(unit.IsA('H7CombatHero')) object.SetString( "TypeInfo" , H7CombatHero(unit).GetHeroClass().GetName() );
	else if(unit.IsA('H7WarUnit')) object.SetString( "TypeInfo" , class'H7Loca'.static.LocalizeSave("UNIT_TYPE_WARFARE","H7General"));
	else if(unit.IsA('H7TowerUnit')) object.SetString( "TypeInfo" , class'H7Loca'.static.LocalizeSave("UNIT_TYPE_TOWER","H7General"));
	else object.SetString( "TypeInfo" , class'H7Loca'.static.LocalizeSave("UNIT_TYPE_UNIT","H7General") );

	// specials (level ismight stacksize StackSizeOriginal)
	if(unit.IsA('H7CombatHero')) 
	{
		hero = H7CombatHero(unit);
		object.SetInt( "Level"          , hero.GetLevel() );
		object.SetBool( "IsMight"       , hero.GetSchool() == MIGHT );
		object.SetInt( "XP"             , hero.GetExperiencePoints());
		object.SetInt("CurrentMana", hero.GetCurrentMana());
		object.SetInt("MaxMana", hero.GetMaxMana());
		CreateHeroInfoObject( H7CombatHero(unit), object );
	}
	else if(unit.IsA('H7CreatureStack')) 
	{
		creatureStack = H7CreatureStack(unit);
		object.SetInt   ( "StackSize", creatureStack.GetStackSize() );
		object.SetInt   ( "StackSizeOriginal", creatureStack.GetInitialStackSize() );
		object.SetInt   ( "Health", creatureStack.GetTopCreatureHealth() );
		object.SetInt   ( "HealthOriginal", creatureStack.GetHitPoints() );
		object.SetString( "ArchetypeID", creatureStack.GetCreature().GetIDString() );
		CreateCreatureObject( H7CreatureStack(unit), object );
	}
	else if(unit.IsA('H7WarUnit')) 
	{
		warUnit = H7WarUnit(unit);
		object.SetInt   ( "StackSize", warUnit.GetStackSize() );
		object.SetInt   ( "StackSizeOriginal", warUnit.GetInitialStackSize() );
		object.SetInt   ( "Health", warUnit.GetCurrentHitPoints() );
		object.SetInt   ( "HealthOriginal", warUnit.GetHitPoints() );
		object.SetString( "ArchetypeID", warUnit.GetTemplate().GetIDString());
		CreateWarUnitObject( H7WarUnit(unit), object );
	}
	else if(unit.IsA('H7TowerUnit'))
	{
		tower = H7TowerUnit(unit);
		object.SetInt   ( "StackSize", tower.GetStackSize() );
		object.SetInt   ( "StackSizeOriginal", tower.GetInitialStackSize() );
		object.SetInt   ( "Health", tower.GetCurrentHitPoints() );
		object.SetInt   ( "HealthOriginal", tower.GetHitPoints() );
		CreateTowerUnitObject(H7TowerUnit(unit), object );
	}

	object.SetString( "PlayerName", unit.GetPlayer().GetName() );
	
	if(class'H7ReplicationInfo'.static.GetInstance().IsMultiplayerGame())
	{
		if(!unit.IsControlledByAI() && unit.GetPlayer() == class'H7CombatController'.static.GetInstance().GetLocalPlayer())
			object.Setbool( "IsHuman", true);
		else
			object.Setbool( "IsHuman", false);
	}
	else
	{
		if(!unit.IsControlledByAI())
			object.Setbool( "IsHuman", true);
		else
			object.SetBool( "IsHuman", false);
	}

	// OPTIONAL remove redundant color
	object.SetInt( "PlayerColorR", unit.GetPlayer().GetColor().R);
	object.SetInt( "PlayerColorG", unit.GetPlayer().GetColor().G);
	object.SetInt( "PlayerColorB", unit.GetPlayer().GetColor().B);
	object.SetObject( "Color", CreateColorObject(unit.GetPlayer().GetColor()) );

	return object;
}

function CreateHeroInfoObject( H7CombatHero hero, out GFxObject object )
{	
	local String archetypeID;
	// hero info
	// basic stats
	
	archetypeID = hero.GetHPArchetypeID();//hero.GetAdventureArmy().GetHero().GetHPArchetypeID();
	object.SetString("ArchetypeID", archetypeID);
	;
	object.SetBool("HeropediaAvailable", class'H7HeropediaCntl'.static.GetInstance().IsHeroDataAvailable(archetypeID));
	;

	object.SetInt( "MinDamageOriginal", hero.GetMinimumDamageBase() );    
	object.SetInt( "MinDamage", hero.GetMinimumDamage() );
	
	object.SetInt( "MaxDamageOriginal", hero.GetMaximumDamageBase() );
	object.SetInt( "MaxDamage", hero.GetMaximumDamage() );

	object.SetInt( "AttackOriginal", hero.GetBaseStatByID(STAT_ATTACK) );
	object.SetInt( "Attack", hero.GetAttack() );
	object.SetString("AttackIcon", GetHUD().GetProperties().mStatIcons.GetStatIconPath(STAT_ATTACK));

	object.SetInt( "MagicOriginal", hero.GetBaseStatByID(STAT_MAGIC));
	object.SetInt( "Magic", hero.GetMagic());

	object.SetInt( "SpiritOriginal", hero.GetBaseStatByID(STAT_SPIRIT));
	object.SetInt( "Spirit", hero.GetSpirit());

	object.SetInt( "DefenseOriginal", hero.GetBaseStatByID(STAT_DEFENSE) );
	object.SetInt( "Defense", hero.GetDefense() ); 
	object.SetString( "Range", "CATTACKRANGE_FULL");

	object.SetInt( "DestinyOriginal", hero.GetBaseStatByID(STAT_LUCK_DESTINY) );
	object.SetInt( "Destiny", hero.GetDestiny() );

	object.SetInt( "LeadershipOriginal", hero.GetBaseStatByID(STAT_MORALE_LEADERSHIP) );
	object.SetInt( "Leadership", hero.GetLeadership() );

	object.SetInt( "MovementPointsOriginal", hero.GetBaseStatByID(STAT_MAX_MOVEMENT) );
	object.SetInt( "MovementPoints", hero.GetModifiedStatByID(STAT_MAX_MOVEMENT) );

	object.SetInt( "ArcaneKnowledgeOriginal", hero.GetBaseStatByID(STAT_ARCANE_KNOWLEDGE) );
	object.SetInt( "ArcaneKnowledge", hero.GetArcaneKnowledgeAsInt() );

	object.SetInt( "InitiativeOriginal", hero.GetBaseStatByID(STAT_INITIATIVE) );
	object.SetInt( "Initiative", hero.GetInitiative() );
}

function CreateTowerUnitObject( H7TowerUnit tower, out GFxObject object)
{
	object.SetInt( "MinDamageOriginal", tower.GetMinimumDamageBase() );
	object.SetInt( "MinDamageHero", 0 );
	object.SetInt( "MinDamage", tower.GetMinimumDamage() );
	
	object.SetInt( "MaxDamageOriginal", tower.GetMaximumDamageBase() );
	object.SetInt( "MaxDamageHero", 0 );
	object.SetInt( "MaxDamage", tower.GetMaximumDamage() );

	object.SetString( "Range"      , string(  GetEnum( Enum'EAttackRange', tower.GetAttackRange())));
	
	object.SetString( "MovementType", String(  GetEnum( Enum'EMovementType', tower.GetMovementType())));
	object.SetInt( "MovementPointsOriginal", tower.GetMovementPoints() ) ;
	object.SetInt( "MovementPointsHero", 0 );
	object.SetInt( "MovementPoints",  tower.GetMovementPoints() ) ;
	
	object.SetInt( "InitiativeOriginal", tower.GetBaseStatByID(STAT_INITIATIVE) );
	object.SetInt( "InitiativeHero", 0 );
	object.SetInt( "Initiative", tower.GetInitiative() );
}

function CreateWarUnitObject( H7Warunit warunit, out GFxObject object)
{
	object.SetInt( "MinDamageOriginal", warunit.GetMinimumDamageBase() );
	object.SetInt( "MinDamageHero", 0 );
	object.SetInt( "MinDamage", warunit.GetMinimumDamage() );
	
	object.SetInt( "MaxDamageOriginal", warunit.GetMaximumDamageBase() );
	object.SetInt( "MaxDamageHero", 0 );
	object.SetInt( "MaxDamage", warunit.GetMaximumDamage() );

	object.SetInt( "AttackOriginal", warunit.GetBaseStatByID(STAT_ATTACK) );
	object.SetInt( "AttackHero", 0 );
	object.SetInt( "Attack", warunit.GetAttack() );

	object.SetInt( "DefenseOriginal", warunit.GetBaseStatByID(STAT_DEFENSE) );
	object.SetInt( "DefenseHero", 0 );
	object.SetInt( "Defense", warunit.GetDefense() );

	object.SetString( "Range"      , string(  GetEnum( Enum'EAttackRange', warunit.GetAttackRange())));
	
	object.SetString( "MovementType", String(  GetEnum( Enum'EMovementType', warunit.GetMovementType())));
	object.SetInt( "MovementPointsOriginal", warunit.GetMovementPoints() ) ;
	object.SetInt( "MovementPointsHero", 0 );
	object.SetInt( "MovementPoints",  warunit.GetMovementPoints() ) ;
	
	object.SetInt( "InitiativeOriginal", warunit.GetBaseStatByID(STAT_INITIATIVE) );
	object.SetInt( "InitiativeHero", 0 );
	object.SetInt( "Initiative", warunit.GetInitiative() );
}

function CreateCreatureObject( H7CreatureStack creatureStack, out GFxObject object )
{
	local H7CombatHero hero;
	local int currentAttack;

	hero = creatureStack.GetCombatArmy().GetCombatHero();

	// flash mutliplies the stack size on it

	;

	object.SetFloat( "MinDamageOriginal", creatureStack.GetCreature().GetMinimumDamage() );
	object.SetFloat( "MinDamageHero", 0 );
	object.SetFloat( "MinDamage", creatureStack.GetMinimumDamage() );
	creatureStack.GetStatModSourceList(STAT_MIN_DAMAGE);

	;

	object.SetFloat( "MaxDamageOriginal", creatureStack.GetCreature().GetMaximumDamage() );
	object.SetFloat( "MaxDamageHero", 0 );
	object.SetFloat( "MaxDamage", creatureStack.GetMaximumDamage() );
	creatureStack.GetStatModSourceList(STAT_MAX_DAMAGE);

	currentAttack = creatureStack.GetAttack();
	object.SetInt( "AttackOriginal", creatureStack.GetCreature().GetAttack() );
	object.SetInt( "AttackHero", hero != none ? hero.GetAttack() : 0 );
	object.SetInt( "Attack", currentAttack >= 0 ? currentAttack : 0 );  // no negative values in GUI
	creatureStack.GetStatModSourceList(STAT_ATTACK);

	object.SetInt( "DefenseOriginal", creatureStack.GetCreature().GetDefense() );
	object.SetInt( "DefenseHero", hero != none ? hero.GetDefense() : 0 );
	object.SetInt( "Defense", creatureStack.GetDefense() );
	creatureStack.GetStatModSourceList(STAT_DEFENSE);

	object.SetInt( "LuckOriginal", creatureStack.GetCreature().GetDestiny() );
	object.SetInt( "LuckHero", hero != none ? hero.GetDestiny() : 0 );
	object.SetInt( "Luck", creatureStack.GetLuck() );
	creatureStack.GetStatModSourceList(STAT_LUCK_DESTINY);

	object.SetInt( "MoraleOriginal", creatureStack.GetCreature().GetLeadership() );
	object.SetInt( "MoraleHero", hero != none ? hero.GetLeadership() : 0 );
	object.SetString( "Morale", (creatureStack.GetResistanceModifierForTag(TAG_MORAL) == 0)?"Immune":String(creatureStack.GetMorale()) );
	creatureStack.GetStatModSourceList(STAT_MORALE_LEADERSHIP);

	object.SetString( "Range"      , String(  GetEnum( Enum'EAttackRange', creatureStack.GetAttackRange())));
	creatureStack.GetStatModSourceList(STAT_RANGE);

	object.SetString( "MovementType", String(  GetEnum( Enum'EMovementType', creatureStack.GetMovementType())));
	object.SetInt( "MovementPointsOriginal", creatureStack.GetCreature().GetMovementPoints() ) ;
	object.SetInt( "MovementPointsHero", 0 );
	object.SetInt( "MovementPoints",  creatureStack.GetMovementPoints() ) ;
	creatureStack.GetStatModSourceList(STAT_MAX_MOVEMENT);

	object.SetInt( "InitiativeOriginal", creatureStack.GetCreature().GetInitiative() );
	object.SetInt( "InitiativeHero", 0 );
	object.SetInt( "Initiative", creatureStack.GetInitiative() );
	creatureStack.GetStatModSourceList(STAT_INITIATIVE);

}



function CreateBuffs( H7Unit unit, out GFxObject object)
{
	local GFxObject dataProviderBuffs,TempObj;
	local H7BaseBuff buff;
	local array<H7BaseBuff> buffs;
	local int i;
	local string tt;

	dataProviderBuffs = CreateArray();
	unit.GetBuffManager().GetActiveBuffs(buffs);
	i = 0;
	foreach buffs(buff)
	{
		if( buff.IsDisplayed() || class'H7GUIGeneralProperties'.static.GetInstance().GetOptionHiddenBuffs() )
		{
			tt = buff.GetTooltip();

			TempObj = CreateObject("Object");
			TempObj.SetBool( "BuffIsDisplayed", buff.IsDisplayed() || class'H7GUIGeneralProperties'.static.GetInstance().GetOptionHiddenBuffs() );
			TempObj.SetBool( "BuffIsDebuff", buff.IsDebuff() );
			TempObj.SetString( "BuffName", buff.GetName() ); 
			TempObj.SetString( "BuffTooltip", tt );
			TempObj.SetString( "BuffIcon", buff.GetFlashIconPath() );
			TempObj.SetInt( "BuffDuration", buff.GetCurrentDuration() );

			// for basespell tooltip generator
			TempObj.SetString( "AbilityName", buff.GetName() ); 
			TempObj.SetString( "AbilityDesc", tt );
			
			dataProviderBuffs.SetElementObject(i, TempObj);
			i++;
			;
		}
	}
	object.SetObject("Buffs", dataProviderBuffs);
}

function CreateAbilities( H7Unit unit, out GFxObject object )
{
	local GFxObject dataProviderAbilities,TempObj;
	local H7BaseAbility ability;
	local array<H7BaseAbility> abilities;
	local int i;
	
	dataProviderAbilities = CreateArray();
	unit.GetAbilityManager().GetAbilities( abilities );
	i = 0;
	foreach abilities(ability)
	{
		if(!ability.IsSpell() && (ability.IsDisplayed() || class'H7GUIGeneralProperties'.static.GetInstance().GetOptionHiddenBuffs()))
		{
			// data for flash:H7AbilityElement
			TempObj = CreateObject("Object");
			TempObj.SetBool( "AbilityIsDisplayed", ability.IsDisplayed() || class'H7GUIGeneralProperties'.static.GetInstance().GetOptionHiddenBuffs() );
			TempObj.SetBool( "AbilityIsPassive", ability.IsPassive() );
			TempObj.SetString( "AbilityName", ability.GetName() ); 
			TempObj.SetString( "AbilityDesc", ability.GetTooltip() );
			TempObj.SetString( "AbilityIcon", ability.GetFlashIconPath() ); 
			dataProviderAbilities.SetElementObject(i, TempObj);
			i++;
		}
	}

	object.SetObject("Abilities", dataProviderAbilities);
}

public function UpdateHeroMana(int currentMana, int maxMAna)
{
	ActionscriptVoid("UpdateHeroMana");
}




