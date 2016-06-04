//=============================================================================
// H7GFxUIContainer
//
// Wrapper for UIContainer.as
// - In Flash every HUD/Window/Popup extends from UIContainer, so equivalent in unreal everything extends from H7GFxUIContainer
// - common functions for all "GUIContainer" elements will be here 
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxUIContainer extends H7GFxListener;

var protected bool mVisible;

function string GetFlashName()
{
	return ActionscriptString("GetFlashName");
}

function Realign(int flashWidth,int flashHeight)
{
	ActionscriptVoid("Realign");
}

function RealignAdventureMap(int flashWidth,int flashHeight)
{
	ActionscriptVoid("RealignAdventureMap");
}

function H7Hud GetHud()
{   
	return class'H7PlayerController'.static.GetPlayerController().GetHud();
}

function bool IsLocaKey(string unknown)
{
	return Caps(unknown) == unknown && Len(unknown) > 0;
}

///////////////////////////////////////////////////////////////////////////
// hack because scaleform broke and can not tell us anymore, if visible or not
///////////////////////////////////////////////////////////////////////////

function SetVisibleSave(bool val)
{
	// super dumb hack for super retarded spectatormode
	if( H7CombatHud(GetHud()) != none )
	{
		if((IsA('H7GFxInitiativeList') ||
			IsA('H7GFxCreatureAbilityButtonPanel') ||
		    IsA('H7GFxCombatMenu') || 
		    IsA('H7GFxDeploymentBar') || 
		   self == H7CombatHud(GetHud()).GetCombatHudCntl().GetHeroPanel() ||
		   self == H7CombatHud(GetHud()).GetCombatHudCntl().GetTacticsBanner() ||
		   self == H7CombatHud(GetHud()).GetCombatHudCntl().GetTimer() ||
		   self == H7CombatHud(GetHud()).GetCombatHudCntl().GetCombatMenu())
		   && (H7CombatHud(GetHud()).GetSpectatorHUDCntl()!=None && H7CombatHud(GetHud()).GetSpectatorHUDCntl().GetPopup()!=None && H7CombatHud(GetHud()).GetSpectatorHUDCntl().GetPopup().IsVisible())
		   && val )
		{
			return;
		}
	}

	ActionScriptVoid("SetVisible");
	SetVisible(val);
	mVisible = val;
}

function bool IsVisible()
{
	return mVisible;
}

///////////////////////////////////////////////////////////////////////////
// hack because scaleform queues clicks for paused movies                //
///////////////////////////////////////////////////////////////////////////

function BlockInputTemporary(bool verbose=false)
{
	ActionScriptVoid("BlockInputTemporary");
}

///////////////////////////////////////////////////////////////////////////
// Data Managment and Transfer                                           //
///////////////////////////////////////////////////////////////////////////

function GFxObject GetNewObject()
{
	return CreateObject("Object");
}

function GFxObject GetNewArray()
{
	return CreateArray();
}

// if something is a dataobject it can listen to a gameEntity and if this gameEntity changes, the function ListenUpdate is called on the dataobject
function GFxObject CreateDataObject()
{
	local GFxObject flashDataObject; // its H7DataObject.as; even though it looks like Object.as
	
	flashDataObject = CreateObject("H7DataObject");

	if(flashDataObject == none) // fallback, when movie.fla can not create H7DataObject
	{
		flashDataObject = CreateObject("Object");
		;
	}
	
	return flashDataObject;
}

///////////////////////////////////////////////////////////////////////////
// Popup                                                                 //
///////////////////////////////////////////////////////////////////////////

// Popup related stuff -> TODO refactor to child class in future

function Hide()
{
	SetVisibleSave(false);
}

function PlayOpenAnimationNextFrame()
{
	GetHud().SetFrameTimer(1,PlayOpenAnimation);
}		

function PlayOpenAnimation()
{
	ActionScriptVoid("PlayOpenAnimation");
}

function Reset()
{
	ActionScriptVoid("Reset");
}

/////////////////////DRAG'N'DROP/////////////////////////
function ResetDragAndDrop()
{
	ActionScriptVoid("ResetDragDrop");
}

///////////////////////////////////////////////////////////////////////////
// Assets                                                                 //
///////////////////////////////////////////////////////////////////////////

function String GetFlashPath(Texture2D asset)
{
	return "img://" $ PathName(asset);
}

///////////////////////////////////////////////////////////////////////////
// not really global stuff but helper functions needed for some elements //
///////////////////////////////////////////////////////////////////////////

function GFxObject CreateColorObject(Color ucolor)
{
	local GFxObject colorObject;
	colorObject = CreateObject("Object");	
	colorObject.SetInt("r",ucolor.R);
	colorObject.SetInt("g",ucolor.G);
	colorObject.SetInt("b",ucolor.B);
	return colorObject;
}

function GFxObject CreateResourceArray(array<H7ResourceQuantity> resources)
{
	local H7ResourceQuantity resource;
	local GFxObject list,resourceObject;
	local int i;

	list = CreateArray();

	i = 0;
	foreach resources(resource)
	{
		resourceObject = CreateObject("Object");
		resourceObject.SetString("Name",resource.Type.GetName());
		resourceObject.SetInt("Amount",resource.Quantity);
		resourceObject.SetString("ResIcon",resource.Type.GetIconPath());
		
		list.SetElementObject(i,resourceObject);
		i++;
	}

	return list;
}

function GFxObject CreateCaravanObjectFromData(ArrivedCaravan army)
{
	local GFxObject data;
	local array<H7BaseCreatureStack> stacks;
	local Color caravanColor;
	local GFxObject units;
	local int i;

	caravanColor = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetColor();

	data = CreateObject("Object");
	units = CreateArray();

	data.SetInt("id",army.index);
	data.SetString("SourceLord",army.sourceLord.GetName());
	data.SetString("TargetLord",army.targetLord.GetName());
	data.SetInt("PlayerColorR", caravanColor.R);
	data.SetInt("PlayerColorG", caravanColor.G);
	data.SetInt("PlayerColorB", caravanColor.B);
	data.SetBool("Arrived",true);
	stacks = army.stacks;

	for(i=0;i<7;i++)
	{
		if(i<stacks.Length && stacks[i] != none)
		{
			units.SetElementObject(i,CreateUnitObjectFromStack(stacks[i]));
		}
		else
		{
			units.SetElementObject(i,CreateCreatureStackObject(none));
		}
	}

	data.SetObject("units",units);

	return data;
} 

function GFxObject CreateCaravanObject(H7CaravanArmy army)
{
	local GFxObject data,emptyHero;

	//`log_gui("CreateCaravanObject" @ army);

	data = CreateArmyObject(army);

	if(army == none)
	{
		emptyHero = CreateObject("Object");
		data.SetObject("hero",emptyHero);
	}
	else
	{
		if(army.GetHero() != none) 
		{
			data.SetInt("id",army.GetHero().GetID());
		}
		if(army.GetSourceLord() != none) 
		{
			data.SetString("SourceLord",army.GetSourceLord().GetName());
		}
		if(army.GetTargetLord() != none) 
		{
			data.SetString("TargetLord",army.GetTargetLord().GetName());
		}
		data.SetInt("ETA",army.GetETA());
	}
	
	data.SetString("FactionIcon","img://H7TextureGUI.CheckboxIcon_Caravan");
	
	return data;
}


function GFxObject CreateArmyObjectFromSite( H7AreaOfControlSite site,optional bool obfuscateStackSize )
{
	local H7DwellingCreatureData unit;
	local array<H7DwellingCreatureData> pool;
	local GFxObject units,armyObject;
	local int i;

	pool = site.GetLocalGuard();
	armyObject = CreateDataObject();
	units = CreateArray();
	
	for(i=0;i<pool.Length;i++)
	{
		unit = pool[i];
		units.SetElementObject(i,CreateUnitObjectFromPool(site,unit,obfuscateStackSize));
	}
	if(pool.Length == 0) // no garrison = 4 empty slots
	{
		units.SetElementObject(0,none);
		units.SetElementObject(1,none);
		units.SetElementObject(2,none);
		units.SetElementObject(3,none);
	}

	armyObject.SetObject("units",units);

	armyObject.SetInt( "PlayerColorR", site.GetPlayer().GetColor().R);
	armyObject.SetInt( "PlayerColorG", site.GetPlayer().GetColor().G);
	armyObject.SetInt( "PlayerColorB", site.GetPlayer().GetColor().B);

	return armyObject;
}

function GFxObject CreateArmyObject(H7EditorArmy army,optional bool obfuscateStackSize,optional Color fallbackColor,optional bool addManaCost,optional H7TeleportCosts costs)
{
	local array<H7BaseCreatureStack> stacks;
	local array<CreatureStackProperties> stackProps;
	local GFxObject units,armyObject,creatureObject;
	local int i,cost;
	local ECreatureTier tier;

	units = CreateArray();
	
	armyObject = CreateDataObject();

	if(army == none) return armyObject;

	stacks = army.GetBaseCreatureStacks();
	if(stacks.Length == 0) // uninitialized army, use stackproperties
	{
		stackProps = army.GetCreatureStackProperties();
		for(i=0;i<7;i++)
		{
			creatureObject = CreateUnitObjectAdvanced(stackProps[i].Creature);
			units.SetElementObject(i,creatureObject);
			if(creatureObject != none)
			{
				units.GetElementObject(i).SetInt( "StackSize",  stackProps[i].Size ) ;
			}
		}
	}
	else
	{
		for(i=0;i<7;i++)
		{
			if(stacks[i]!=none)
			{
				units.SetElementObject(i,CreateUnitObjectAdvanced(stacks[i].GetStackType()));
				units.GetElementObject(i).SetInt( "StackSize",  stacks[i].GetStackSize() ) ;
				if(obfuscateStackSize)
				{
					units.GetElementObject(i).SetString( "StackSizeOverwrite",  stacks[i].GetStackSizeObfuscated() ) ;
				}
				if(addManaCost)
				{
					tier = stacks[i].GetStackType().GetTier();
					switch(tier)
					{
						case CTIER_CHAMPION:cost = Abs(stacks[i].GetStackSize() * costs.ChampionCreatureCosts);break;
						case CTIER_CORE:cost = Abs(stacks[i].GetStackSize() * costs.CoreCreatureCosts);break;
						case CTIER_ELITE:cost = Abs(stacks[i].GetStackSize() * costs.EliteCreatureCosts);break;
					}
				
					units.GetElementObject(i).SetInt( "SpecialResourceNumber", cost ) ;
					units.GetElementObject(i).SetString( "SpecialResourceIcon", class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mStatIcons.GetStatIconPath(STAT_MANA) ) ;
				}
			}
			else
			{
				units.SetElementObject(i,CreateUnitObjectAdvanced(none));
			}
		}
	}

	if(H7AdventureArmy(army) != none)
	{
		armyObject.SetInt("id",H7AdventureArmy(army).GetHero().GetID());
		armyObject.SetInt( "PlayerColorR", H7AdventureArmy(army).GetHero().GetPlayer().GetColor().R);
		armyObject.SetInt( "PlayerColorG", H7AdventureArmy(army).GetHero().GetPlayer().GetColor().G);
		armyObject.SetInt( "PlayerColorB", H7AdventureArmy(army).GetHero().GetPlayer().GetColor().B);
	}
	else
	{
		armyObject.SetInt("id",1); // dummy id
		armyObject.SetInt( "PlayerColorR", fallbackColor.R);
		armyObject.SetInt( "PlayerColorG", fallbackColor.G);
		armyObject.SetInt( "PlayerColorB", fallbackColor.B);
	}

	armyObject.SetObject("units",units);
	
	// Icon
	if(H7AdventureArmy(army) != none && H7AdventureArmy(army).GetHero().IsHero()) armyObject.SetObject("hero",CreateHeroObject(H7AdventureArmy(army).GetHero()));
	else if(army.GetPlayerNumber() != PN_NEUTRAL_PLAYER) //army is caravan
	{
		if(army.GetStrongestCreature() != none)
		{
			armyObject.SetString("FactionIcon", army.GetStrongestCreature().GetFaction().GetFactionSepiaIconPath());
		}
		else if(H7AdventureArmy(army).GetGarrisonedSite() != none &&
			    H7Town(H7AdventureArmy(army).GetGarrisonedSite()) != none)
			armyObject.SetString("FactionIcon", H7Town(H7AdventureArmy(army).GetGarrisonedSite()).GetFaction().GetFactionSepiaIconPath());
	}

	

	return armyObject;
}

/**
 * Returns an GFxObject containg the creatures from indices 7 to 11
 * this means that the local guard must be added to the army before calling this method
 */
function GFxObject CreateLocalGuardObject(array<H7BaseCreatureStack> localGuardStacks, H7EditorHero commandingHero)
{
	local H7BaseCreatureStack stack;
	local GFxObject units,armyObject;
	local int i;
	
	units = CreateArray();
	
	armyObject = CreateDataObject();

	if(localGuardStacks.Length == 0) return armyObject;
	i = 0;
	foreach localGuardStacks(stack, i)
	{
		if(stack!=none)
		{
			units.SetElementObject(i,CreateUnitObjectAdvanced(stack.GetStackType()));
			units.GetElementObject(i).SetInt( "StackSize",  stack.GetStackSize() ) ;
		}
		else
		{
			units.SetElementObject(i,CreateUnitObjectAdvanced(none));
		}
	}

	armyObject.SetInt("id", commandingHero.GetID());
	armyObject.SetObject("units",units);

	armyObject.SetInt( "PlayerColorR", commandingHero.GetPlayer().GetColor().R);
	armyObject.SetInt( "PlayerColorG", commandingHero.GetPlayer().GetColor().G);
	armyObject.SetInt( "PlayerColorB", commandingHero.GetPlayer().GetColor().B);

	return armyObject;
}

function GFxObject CreateCombatArmyObject(H7CombatArmy army)
{
	local array<H7BaseCreatureStack> stacks; 
	local H7BaseCreatureStack stack;
	local GFxObject units,armyObject;
	local int i;

	units = CreateArray();
	
	armyObject = CreateDataObject();
	if(army == none) return armyObject;

	stacks = army.GetBaseCreatureStacks();
	for(i=0;i<7;i++)
	{
		if(i<stacks.Length && stacks[i] != none)
		{
			units.SetElementObject(i,CreateUnitObjectAdvanced(stacks[i].GetStackType()));
			units.GetElementObject(i).SetInt( "StackSize",  stacks[i].GetStackSize() ) ;
		}
		else
		{
			units.SetElementObject(i,CreateCreatureStackObject(none));
		}
	}

	armyObject.SetInt("id",army.GetHero().GetID());
	armyObject.SetObject("units",units);
	
	// Icon
	if(army.GetHero().IsHero()) armyObject.SetObject("hero",CreateHeroObject(army.GetHero()));
	else if(army.GetPlayerNumber() != PN_NEUTRAL_PLAYER) //army is caravan
	{
		foreach stacks(stack)
		{
			if(stack != none) armyObject.SetString("FactionIcon", stack.GetStackType().GetFaction().GetFactionSepiaIconPath());
		}
	}

	armyObject.SetInt( "PlayerColorR", army.GetHero().GetPlayer().GetColor().R);
	armyObject.SetInt( "PlayerColorG", army.GetHero().GetPlayer().GetColor().G);
	armyObject.SetInt( "PlayerColorB", army.GetHero().GetPlayer().GetColor().B);


	return armyObject;
}

/**
 * Returns a dataObject for the given creatureStack
 * 
 * @param unit The creature stack for which to create the dataObject
 * 
 * */
function GFxObject CreateCreatureStackObject(H7BaseCreatureStack stack)
{
	local GFxObject data;
	if(stack == none) return data;
	data = CreateObject("Object");
	
	data.SetInt("StackSize",stack.GetStackSize());
	data.SetString("IconPath",stack.GetStackType().GetFlashIconPath());
	data.SetString("Icon",stack.GetStackType().GetFlashIconPath());
	data.SetString("Name", stack.GetStackType().GetName());
	data.SetString("UnitType", stack.GetStackType().GetName());	
	data.SetString("ArchetypeID", stack.GetStackType().GetIDString());
	if(stack.GetStackType().GetOverwriteIDString() != "")
		data.SetString("ArchetypeID", stack.GetStackType().GetOverwriteIDString());
	return data;
}

function GFxObject CreateUnitObjectAdvanced(H7Creature creature) // OPIONAL could get a shorter version for name,icon only
{
	local GFxObject creatureObject, abilitiesObj;
	local array<H7BaseAbility> abilities;
	local H7BaseAbility ability;
	local int i;
	if(creature == none) return creatureObject;
	creatureObject = CreateObject("Object");

	creatureObject.SetString( "Name", creature.GetName() );
	creatureObject.SetString( "UnitType", creature.GetName());	// needed for unitSlot.UpdateSlots
	creatureObject.SetString( "ArchetypeID", creature.GetIDString());
	if(creature.GetOverwriteIDString() != "")
		creatureObject.SetString("ArchetypeID", creature.GetOverwriteIDString());
	creatureObject.SetString( "Icon" , creature.GetFlashIconPath() );
	creatureObject.SetString( "Faction", creature.GetFaction().GetName() );
	creatureObject.SetString( "Tier",creature.GetTierString() );
	creatureObject.SetInt( "Health", creature.GetHitPointsBase() );
	creatureObject.SetString( "MovementType", string(  GetEnum( Enum'EMovementType',creature.GetMovementType() ) )   );
	creatureObject.SetString( "SchoolName",  string( GetEnum( Enum'EAbilitySchool', creature.GetSchool() ) ) );

	// basic stats 
	creatureObject.SetInt( "MinDamage",creature.GetMinimumDamage() );
	creatureObject.SetInt( "MaxDamage",creature.GetMaximumDamage() );
	
	creatureObject.SetInt( "Attack", creature.GetAttack() );
	creatureObject.SetInt( "Defense", creature.GetDefense() );
	
	creatureObject.SetString( "Range", string(  GetEnum( Enum'EAttackRange', creature.GetAttackRange())));
	creatureObject.SetInt( "Luck", creature.GetDestiny() );
	creatureObject.SetInt( "Morale", creature.GetLeadership() );
	creatureObject.SetInt( "Initiative", creature.GetInitiative() );
	creatureObject.SetInt( "MovementPoints",  creature.GetMovementPoints() ) ;

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
			abilitiesObj.SetElementString(i, ability.GetFlashIconPath());
			i++;
		}
	}
	creatureObject.SetObject("Abilities", abilitiesObj);

	return creatureObject;
}

// creating same format as CreateCombatArmyObject
function GFxObject CreateArmyObjectFromStacks(array<H7BaseCreatureStack> stacks)
{
	local H7BaseCreatureStack stack;
	local GFxObject ob,list;
	local int i;

	ob = CreateObject("Object");

		list = CreateArray();
		for(i=0;i<stacks.Length;i++)
		{
			stack = stacks[i];
			list.SetElementObject(i,CreateUnitObjectFromStack(stack));
		}

	ob.SetObject("units",list);
	ob.SetInt("id",0);
	ob.SetBool("OnlyTake",true);

	return ob;
}

function GFxObject CreateUnitObjectFromStack(H7BaseCreatureStack stack)
{
	local GFxObject data;

	data = CreateUnitObjectAdvanced(stack.GetStackType());
	data.SetInt("StackSize",stack.GetStackSize());
	
	return data;
}

// not really a standard army object for the armyrow, used for local guard display in popup OPTIONAL remove
function GFxObject CreateArmyObjectFromPool( H7AreaOfControlSite site )
{
	local H7DwellingCreatureData unit;
	local array<H7DwellingCreatureData> pool;
	local GFxObject list;
	local int i;

	pool = site.GetLocalGuard();
	list = CreateArray();
	for(i=0;i<pool.Length;i++)
	{
		unit = pool[i];
		list.SetElementObject(i,CreateUnitObjectFromPool(site,unit));
	}
	return list;
}

function GFxObject CreateUnitObjectFromPool( H7AreaOfControlSite site, H7DwellingCreatureData unit, bool obfuscateStackSize=false )
{
	local GFxObject data;
	
	data = CreateUnitObjectAdvanced(unit.Creature);
	if( unit.Creature == none ) { return data; }

	data.SetInt("Growth", site.GetGuardIncomeFor(unit));
	data.SetInt("Capacity", site.GetGuardCapacityFor(unit));
	data.SetInt("StackSize",unit.Reserve);

	if(obfuscateStackSize)
	{
		data.SetString( "StackSizeOverwrite", class'H7BaseCreatureStack'.static.GetObfuscatedSize(unit.Reserve) ) ;
	}

	data.SetString("IconPath",unit.Creature.GetFlashIconPath());
	data.SetString("Icon",unit.Creature.GetFlashIconPath());
	data.SetString("Name", unit.Creature.GetName());
	data.SetString("UnitType", unit.Creature.GetName());

	return data;
}

function GFxObject CreateHeroObject(H7EditorHero hero)
{
	local GFxObject data;
	local String archetypeID;

	data = CreateObject("Object");
	if(hero == none || !hero.IsHero() ) return data;

	data.SetInt("UnrealID",hero.GetID());
	data.SetString("IconPath",hero.GetFlashIconPath());
	data.SetString("Icon",hero.GetFlashIconPath());
	data.SetString("Name",hero.GetName());
	data.SetString("Class", hero.GetHeroClass().GetName());
	data.SetString("Faction", hero.GetFaction().GetName());
	data.SetInt( "Level", hero.GetLevel() );
	data.SetInt( "MaxLevel", class'H7AdventureController'.static.GetInstance().GetMapInfo().GetMaxHeroLevelForPlayer( hero.GetPlayer().GetPlayerNumber() ));
	data.SetString("UnitType", "UNIT_HERO");
	data.SetBool("IsMight", hero.GetSchool() == MIGHT);
	if(hero.GetHeropediaOverwrite() != none)
		archetypeID = hero.GetHeropediaOverwrite().GetArchetypeID();
	else if(class'H7GameUtility'.static.IsArchetype(self))
		archetypeID = String(self);
	else
		archetypeID = hero.GetHPArchetypeID();
	
	data.SetString("ArchetypeID", archetypeID);
	data.SetBool("HeropediaAvailable", class'H7HeropediaCntl'.static.GetInstance().IsHeroDataAvailable(archetypeID));
	return data;
}

// data object of all warfare units of an army
function GFxObject CreateWarefareUnitsObject(H7EditorArmy army, optional Color fallBackColor)
{
	local array<H7EditorWarUnit> warfareUnits;
	local GFxObject units,armyObject;
	local int i, warUnitsSet;

	units = CreateArray();
	
	armyObject = CreateObject("Object");
	if(army == none) return armyObject;

	warUnitsSet = 0;
	warfareUnits = army.GetWarUnitTemplates();
	for(i=0;i<warfareUnits.Length;i++)
	{
		if(warfareUnits[i] != none)
		{
			units.SetElementObject(warUnitsSet,CreateWarfareUnitObject(warfareUnits[i]));
			warUnitsSet++;
		}
	}

	if( H7AdventureArmy(army) != none )
	{
		armyObject.SetInt("id", H7AdventureArmy(army).GetHero().GetID());
	}
	else if( H7CombatArmy(army) != none )
	{
		armyObject.SetInt("id", H7CombatArmy(army).GetHero().GetID());
	}
	armyObject.SetObject("units",units);
	//armyObject.SetObject("hero",CreateHeroObject(army.GetHeroTemplate()));

	if( army.GetPlayer() != none )
	{
		fallBackColor = army.GetPlayer().GetColor();
	}

	armyObject.SetInt( "PlayerColorR", fallBackColor.R);
	armyObject.SetInt( "PlayerColorG", fallBackColor.G);
	armyObject.SetInt( "PlayerColorB", fallBackColor.B);

	return armyObject;
}

function GFxObject CreateWarfareUnitObject(H7EditorWarunit warunit)
{
	local GFxObject data;
	local EWarUnitClass warUnitClass;
	if(warunit == none) return data;
	data = CreateObject("Object");

	data.SetString("Icon",warunit.GetFlashIconPath());
	data.SetString("Name", warunit.GetName());
	data.SetString("Faction", warunit.GetFaction().GetName());
	
	warUnitClass = warunit.GetWarUnitClass();
	data.SetString("Class", String(warUnitClass));
	data.SetString("Tier", class'H7Loca'.static.LocalizeSave(String(warUnitClass),"H7Abilities") );
	data.SetInt("ClassInt", warUnitClass);
	data.SetString("ArchetypeID", warUnit.GetIDString());
	data.SetString("SchoolName", String(GetEnum(Enum'EAbilitySchool',warunit.GetSchool())) );

	data.SetInt( "Health", warunit.GetHitPoints() );
	data.SetInt( "HealthOriginal", warunit.GetHitPoints() );

	data.SetInt( "MinDamageOriginal", warunit.GetMinimumDamageBase() );
	data.SetInt( "MinDamageHero", 0 );
	data.SetInt( "MinDamage", warunit.GetMinimumDamage() );
	data.SetInt( "MaxDamageOriginal", warunit.GetMaximumDamageBase() );
	data.SetInt( "MaxDamageHero", 0 );
	data.SetInt( "MaxDamage", warunit.GetMaximumDamage() );

	data.SetInt( "AttackOriginal", warunit.GetBaseStatByID(STAT_ATTACK) );
	data.SetInt( "AttackHero", 0 );
	data.SetInt( "Attack", warunit.GetAttack() );

	data.SetInt( "DefenseOriginal", warunit.GetBaseStatByID(STAT_DEFENSE) );
	data.SetInt( "DefenseHero", 0 );
	data.SetInt( "Defense", warunit.GetDefense() );

	data.SetString( "Range"      , string(  GetEnum( Enum'EAttackRange', warunit.GetAttackRange())));
	
	data.SetString( "MovementType", String(  GetEnum( Enum'EMovementType', warunit.GetMovementType())));
	data.SetInt( "MovementPointsOriginal", warunit.GetMovementPoints() ) ;
	data.SetInt( "MovementPointsHero", 0 );
	data.SetInt( "MovementPoints",  warunit.GetMovementPoints() ) ;
	
	data.SetInt( "Luck", 0);
	data.SetInt( "Morale", 0);

	data.SetInt( "InitiativeOriginal", warunit.GetBaseStatByID(STAT_INITIATIVE) );
	data.SetInt( "InitiativeHero", 0 );
	data.SetInt( "Initiative", warunit.GetInitiative() );

	return data;
}


function GFxObject CreateItemObject(H7HeroItem item, optional H7EditorHero hero, optional IntPoint pos)
{
	local GFxObject itemObj;
	local string infoBox,tooltipMain,tooltipAdd;
	local EItemType type;
	local ETier tier;
	local array<H7SpellEffect> spells;

	if(hero != none)
	{
		item.SetOwner(hero);
	}
	
	type = item.GetType();
	tier = item.GetTier();

	itemObj = CreateObject( "Object" );
	
	switch(type)
	{
		case ITYPE_SCROLL:
			// info box of spell
			spells = item.GetSpellEffects();
			infoBox = H7HeroAbility(spells[0].mSpellStruct.mSpell).GetInfoBox(hero,false);
			itemObj.SetBool("ShowBasicAsPreDesc", true ); // show normal scroll description as pre description above icon+infobox
			break;
		case ITYPE_CONSUMABLE:
			// no info box
			break;
		case ITYPE_INVENTORY_ONLY: // ???
			break;
		case ITYPE_ALL: // ???
		default: // equipment
			infoBox = "<font color='" $ item.GetTierColorHTML(false) $ "'>" $ class'H7Loca'.static.LocalizeSave(string(tier),"H7HeroItem") $ "</font>";
			infoBox = infoBox $ "\n" $ item.GetTypeLoca();
			if(item.GetItemSet() != none)
			{
				infoBox = infoBox $ "\n" $ item.GetItemSet().GetName();
			}
	}

	itemObj.SetInt("itemID", item.GetID());
	itemObj.SetInt("PosX", pos.X);
	itemObj.SetInt("PosY", pos.Y);

	itemObj.SetString("Name", item.GetColoredName());

	itemObj.SetString("IconPath", item.GetFlashIconPath());
	itemObj.SetString("InfoBox", infoBox);
	
	itemObj.SetBool("IsStackable", item.IsStackable());
	itemObj.SetBool("IsNotUnequipable", item.CannotUnequip());
	itemObj.SetBool("IsConsumeable", item.GetType() == ITYPE_CONSUMABLE);
	itemObj.SetBool("IsExchangeable", item.IsExchangeable());
	itemObj.SetBool("IsStoryItem", item.IsStoryItem());
	
	itemObj.SetString("type", String(item.GetType()));
	itemObj.SetInt("Tier", item.GetTier());
	itemObj.SetString("TypeLoca", item.GetTypeLoca());

	tooltipMain = item.GetTooltipForOwner(hero);
	tooltipAdd = Split(tooltipMain,"-SPLITTOOLTIPHERE-",true);
	tooltipMain = Left(tooltipMain,InStr(tooltipMain,"-SPLITTOOLTIPHERE-"));

	itemObj.SetString("Tooltip" , tooltipMain);
	itemObj.SetString("TooltipAdd" , tooltipAdd);

	tooltipMain = item.GetTooltipForOwner(hero, true);
	tooltipAdd = Split(tooltipMain,"-SPLITTOOLTIPHERE-",true);
	tooltipMain = Left(tooltipMain,InStr(tooltipMain,"-SPLITTOOLTIPHERE-"));

	itemObj.SetString("TooltipAdv" , tooltipMain);
	itemObj.SetString("TooltipAdvAdd" , tooltipAdd);

	if(item.GetItemSet() != none)
	{
		item.GetItemSet().SetOwner(hero);

		itemObj.SetString("SetName" , item.GetItemSet().GetName());
		itemObj.SetString("SetTooltip" , item.GetItemSet().GetTooltip());

		if(item.GetItemSet().IsArchetype()) item.GetItemSet().SetOwner(none);
	}	

	if(item.IsArchetype())
	{
		item.SetOwner(none);
	}

	return itemObj;
}

function GFxObject CreateBuildingObject(H7TownBuildingData building,H7Town town)
{
	return CreateBuildingObjectFromBuildng(building.Building, town);
}

function GFxObject CreateBuildingObjectFromBuildng(H7TownBuilding building, H7Town town)
{
	local GFxObject data;
	local H7TownBuilding tmpBuilding;
	local string buildingName, desc, flashPath;
	local array<string> placeholders;
	local string placeholder;

	local H7ScriptingController scriptingController;
	local H7TownDwellingOverride dwellingOverride;
	local bool hasOverride;

	data = CreateObject("Object");

	;

	// check for scripting overrides
	hasOverride = false;
	if(building.IsA('H7TownDwelling'))
	{
		scriptingController = class'H7ScriptingController'.static.GetInstance();
		dwellingOverride = scriptingController.GetTownDwellingOverride(town, H7TownDwelling(class'H7GameUtility'.static.IsArchetype(building) ? building : building.ObjectArchetype));
		hasOverride = scriptingController.IsTownDwellingOverrideValid(dwellingOverride);
	}
	
	data.SetString("ID",building.GetIDString());

	buildingName = (hasOverride && Len(dwellingOverride.Name) > 0) ? dwellingOverride.Name : building.GetName();
	data.SetString("Name", buildingName);

	desc = (hasOverride && Len(dwellingOverride.Description) > 0) ? dwellingOverride.Description : building.GetDesc();
	placeholders = class'H7EffectContainer'.static.GetPlaceholders(desc);
	foreach placeholders(placeholder)
	{
		desc = Repl(desc,placeholder,class'H7EffectContainer'.static.ResolveIconPlaceholder(placeholder));
	}

	data.SetString("Desc",desc);
	data.SetInt("Level",building.GetPrerequisiteLevel());
	data.SetInt("TownLevel",town.GetLevel());
	data.SetObject("Color",CreateColorObject(class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetColor())); // OPTIONAL use same for all buildings

	data.SetBool("IsBuilt", town.IsBuildingBuilt(building));
	data.SetBool("IsAffordable",town.CanAffordBuilding( building ) );
	data.SetBool("IsAccessable",town.CheckBuildingRequirements( building ));

	flashPath = (hasOverride && dwellingOverride.Icon != none) ? ("img://" $ Pathname(dwellingOverride.Icon)) : building.GetFlashIconPath();
	data.SetString("Icon", flashPath );

	data.SetString("InfoIcon",building.GetFlashInfoIconPath(town.IsBuildingBuilt(building)) );
	data.SetString("FactionIcon",town.GetFactionWatermarkPath() );
	town.DelFactionWatermarkRef();
	data.SetBool("TownCanBuild",!town.HasBuiltToday());
	
	data.SetObject("Cost",CreateBuildingCostArray(building, town) );
	
	if(building.GetUpgrade() != none)
	{
		data.SetString("Upgrade",building.GetUpgrade().GetIDString());
		//`log_gui("     |--->" @ building.Building.GetUpgrade() @ building.Building.GetUpgrade().GetName());
	}

	if(building.GetAlternate() != none)
	{
		data.SetString("Alternate",building.GetAlternate().GetIDString());
	}

	data.SetObject("Prerequisite",CreatePreReqArray(building, town));

	tmpBuilding = town.GetUpgradeBase(building);
	if(tmpBuilding != none)
	{
		data.SetString("UpgradeBase", tmpBuilding.GetIDString() );
		data.SetString("UpgradeBaseName", tmpBuilding.GetName() );
		data.SetBool("UpgradeBaseBuilt", town.IsBuildingBuilt(tmpBuilding));
	}

	if(H7TownDwelling(building) != none && H7TownDwelling(building).GetCreaturePool().Creature != none)
	{
		data.SetString("Creature",H7TownDwelling(building).GetCreaturePool().Creature.GetIDString());
	}

	return data;
}

function GFxObject CreateBuildingCostArray(H7TownBuilding building, H7Town town)
{
	local array<H7ResourceQuantity> costs;

	costs = building.GetCost(town);
	
	return CreateCostArray(costs);
}

function GFxObject CreatePreReqArray(H7TownBuilding building, H7Town town)
{
	local H7TownBuilding prereq,alternate;
	local array<H7TownBuilding> prereqs;
	local GFxObject list, preq;
	local int i;

	prereqs = building.GetPrerequisites();

	list = CreateArray();
	i = 0;
	foreach prereqs(prereq)
	{
		alternate = prereq.GetAlternateBothWays(town); // if a prereq has an alternate, it also counts as prereq
		
		if(!town.IsAvailable(prereq)) // special case where prereq is not there and is replaced with it's alternate:
		{
			if(alternate == none)
			{
				;
				continue;
			}
			prereq = alternate;
		}

		preq = CreateObject("Object");
		preq.SetString("Name", prereq.GetIDString()); // ID
		if(alternate != none)
		{
			preq.SetString("LocaName", prereq.GetName() @ class'H7Loca'.static.LocalizeSave("OR","H7General") @ alternate.GetName() ); // Name
		}
		else
		{
			preq.SetString("LocaName", prereq.GetName()); // Name
		}
		preq.SetBool("IsBuilt", town.IsBuildingBuilt(prereq,true,true));
		list.SetElementObject(i,preq);
		i++;
	}

	// create non-building prereqs in form of a building prereq, to be part of the prereq array
	// - tear of ashen
	if( H7TownTearOfAsha( building ) != none && (town.GetVisitingArmy() != none || town.GetGarrisonArmy() != none))
	{
		preq = CreateObject("Object");
		preq.SetString("Name", "TEAR_REQ"); // ID
		preq.SetString("LocaName", Repl(class'H7Loca'.static.LocalizeSave("TT_TEAR","H7Town"),"%item",class'H7AdventureController'.static.GetInstance().GetMapInfo().mTearOfAshaTemplate.GetName())); // Name
		if( town.GetVisitingArmy() != none )
		{
			preq.SetBool("IsBuilt",town.GetVisitingArmy().GetHero().HasTearOfAsha() ); // IsBuilt = Requirement fullfilled = a hero has the tear
		}
		else if( town.GetGarrisonArmy() != none )
		{
			preq.SetBool("IsBuilt",town.GetGarrisonArmy().GetHero().HasTearOfAsha() ); // IsBuilt = Requirement fullfilled = a hero has the tear
		}
		list.SetElementObject(i,preq);
		i++;
	}
	// - capitol
	// I am a capitol and need to check if there already is one for this player
	if( H7TownHall( building ) != none && H7TownHall( building ).IsCapitol() )
	{
		preq = CreateObject("Object");
		preq.SetString("Name", "CAPITOL_REQ"); // ID
		preq.SetString("LocaName", class'H7Loca'.static.LocalizeSave("TT_UNIQUE","H7Town")); // Name
		preq.SetBool("IsBuilt",!town.GetPlayer().HasCapitol()); // IsBuilt = Requirement fullfilled = Captol does not exist yet
		list.SetElementObject(i,preq);
		i++;
	}

	return list;
}

public function GFxObject CreateCostArray(array<H7ResourceQuantity> costs)
{
	local H7ResourceQuantity cost;
	local GFxObject list,costObject;
	local int i;

	list = CreateArray();

	i = 0;
	costs.Sort( class'H7Resource'.static.CostResourceCompareGUI );
	foreach costs(cost)
	{
		if( cost.Type != none )
		{
			costObject = CreateObject("Object");
			costObject.SetString("Name",cost.Type.GetName());
			costObject.SetInt("Amount",cost.Quantity);
			costObject.SetString("ResIcon",cost.Type.GetIconPath());
			costObject.SetBool("CanSpend", class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetResourceSet().CanSpendResource(cost));

			list.SetElementObject(i,costObject);
			i++;
		}
	}

	return list;
}

function SetStatModSourceList(array<H7StatModSource> list)
{
	local GFxObject gfxList;//,gfxElement;
	local H7StatModSource statModSource;
	local int i;

	gfxList = CreateArray();

	foreach list(statModSource,i)
	{
		if(statModSource.mSource.IsA('H7BuffHeroArmyBonus')) continue; // hero army bonus buff excluded
		if(statModSource.mSource != None)
		{
			gfxList.SetElementString(i,statModSource.mMod.mModifierValue $ "_" $ statModSource.mSource.GetName() $ "_" $ Mid(String(statModSource.mMod.mCombineOperation),8) );
		}
		else
		{
			gfxList.SetElementString(i,statModSource.mMod.mModifierValue $ "_" $ statModSource.mSourceName $ "_" $ Mid(String(statModSource.mMod.mCombineOperation),8) );
		}
	}

	SetObject("mStatModSourceList",gfxList);

	ActionscriptVoid("SetStatModSourceList");
}

function GFxObject GetBattleSiteRewardsObject(optional H7EditorHero hero, optional H7BattleSite currentBattleSite = none)
{
	local GFxObject obj, itemRewardsObj, itemObj, resourceRewardsObj, resourceObj, statRewardsObj, statRewardObj;
	local GFxObject heroObj;
	local H7BattleSite battleSite;
	local array<H7HeroItem> itemRewards;
	local H7HeroItem item;
	local array<H7ResourceQuantity> resourceRewards;
	local H7ResourceQuantity quan;
	local Array<H7MeModifiesStat> statRewards;
	local H7MeModifiesStat statReward;
	local H7EditorHero heroReward;
	local int i;
	local string tmp;

	
	obj = CreateObject("Object");
	itemRewardsObj = CreateArray();
	resourceRewardsObj = CreateArray();
	statRewardsObj = CreateArray();

	if(currentBattleSite != none)
		battleSite = currentBattleSite;
	else
		battleSite = class'H7AdventureController'.static.GetInstance().GetCurrentBattleSite();

	itemRewards = battlesite.GetItemRewardSetup();
	i = 0;
	ForEach itemRewards(item, i)
	{
		itemObj = CreateObject("Object");
		itemObj = CreateItemObject(item, hero);
		itemRewardsObj.SetElementObject(i, itemObj);
	}

	resourceRewards = battlesite.GetResourceRewardSetup();
	i = 0;
	ForEach resourceRewards(quan, i)
	{
		resourceObj = CreateObject("Object");
		resourceObj.SetString("Name", quan.Type.GetName());
		resourceObj.SetInt("Quantity", quan.Quantity);
		resourceObj.SetString("Icon", quan.Type.GetIconPath());
		resourceRewardsObj.SetElementObject(i, resourceObj);
	}

	statRewards = battleSite.GetStatModRewardSetup();
	i = 0;
	ForEach statRewards(statReward, i)
	{
		statRewardObj = CreateObject("Object");
		if(class'H7GUIGeneralProperties'.static.GetInstance().mStatIconsInText.GetStatIcon(statReward.mStat) != none)
		{
			tmp = class'H7Effect'.static.GetHumanReadableStatMod(statReward) 
				@ Repl(class'H7GUIGeneralProperties'.static.GetInstance().mStatIconsInText.GetStatIconPathHTML(statReward.mStat),"#TT_POINT#","18")
				@ class'H7EffectContainer'.static.GetLocaNameForStat( statReward.mStat , true );
		}
		else
		{
			tmp = class'H7Effect'.static.GetHumanReadableStatMod(statReward) 
				@ class'H7EffectContainer'.static.GetLocaNameForStat( statReward.mStat , true );
		}
		// some flash uses Desc others use Icon Value and Name
		statRewardObj.SetString("Desc", tmp );
		statRewardObj.SetString("Icon", class'H7GUIGeneralProperties'.static.GetInstance().mStatIconsInText.GetStatIconPath(statReward.mStat) );
		statRewardObj.SetString("Value", class'H7Effect'.static.GetHumanReadableStatMod(statReward) );
		statRewardObj.SetString("Name", class'H7EffectContainer'.static.GetLocaNameForStat( statReward.mStat , true ) );
		
		statRewardsObj.SetElementObject(i, statRewardObj);
	}

	if(battleSite.IsA('H7CrusaderCommandery') && H7CrusaderCommandery(battleSite).GetHeroRewardGUI() != none)
	{
		heroReward = H7CrusaderCommandery(battleSite).GetHeroRewardGUI();
		heroObj = CreateObject("Object");
		heroObj.SetString("Name",heroReward.GetName());
		heroObj.SetString( "Icon", heroReward.GetFlashIconPath() );
		heroObj.SetInt( "Level", heroReward.GetLevel() );
		heroObj.SetBool("AffinityMight", heroReward.IsMightHero());
		obj.SetObject("HeroReward", heroObj);
	}

	obj.SetObject("ResourceRewards", resourceRewardsObj);
	obj.SetObject("ItemRewards", itemRewardsObj);
	obj.SetObject("StatRewards", statRewardsObj);
	

	return obj;
}
