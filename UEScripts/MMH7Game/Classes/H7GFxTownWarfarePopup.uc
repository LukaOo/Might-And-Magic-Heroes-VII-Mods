//=============================================================================
// H7GFxTownWarfarePopup
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxTownWarfarePopup extends H7GFxTownPopup;

var H7Town mTown;

function Update(H7Town town)
{
	local GFxObject data;
	local H7TownBuildingData entry;
	local array<H7TownBuildingData> warfareBuildings;
	local H7EditorWarUnit attackOrHybridUnit,supportUnit,unit;
	local H7TownBuildingData attackOrHybridBuilding,supportBuilding;

	mTown = town;

	data = CreateObject("Object");

	// find all relevant units and buildings
	warfareBuildings = town.GetBuildingTemplatesByType(class'H7TownUtilityUnitDwelling');
	foreach warfareBuildings(entry)
	{
		unit = H7TownUtilityUnitDwelling(entry.Building).GetWarunitTemplate();
		if(unit == none)
		{
			class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(entry.Building @ "does not have a warfare unit",MD_QA_LOG);;
			continue;
		}
		if(unit.GetWarUnitClass() == WCLASS_ATTACK || unit.GetWarUnitClass() == WCLASS_HYBRID)
		{
			attackOrHybridUnit = unit;
			attackOrHybridBuilding = entry;
		}
		if(unit.GetWarUnitClass() == WCLASS_SUPPORT)
		{
			supportUnit = unit;
			supportBuilding = entry;
		}
	}

	data.SetObject("AttackBuilding",CreateWarfareBuildingData(attackOrHybridBuilding,attackOrHybridUnit,town));

	if(supportUnit == none || supportBuilding.Building == none)
	{
		// assuming hybrid mode
	}
	else
	{
		data.SetObject("SupportBuilding",CreateWarfareBuildingData(supportBuilding,supportUnit,town));
	}

	// visit army
	data.SetObject("VisitingHero",CreateArmyObjectOnlyWarfare(town.GetVisitingArmy()));
	// garrison army
	data.SetObject("GarrisonHero",CreateArmyObjectOnlyWarfare(town.GetGarrisonArmy()));
	
	SetObject("mData", data);

	ActionScriptVoid("Update");
}

function GFxObject CreateWarfareBuildingData(H7TownBuildingData building,H7EditorWarUnit unit,H7Town town)
{
	local GFxObject data;
	
	data = CreateBuildingObject(building,town);

	data.SetObject("Unit",CreateWarfareData(building,unit,town));

	return data;
}

function GFxObject CreateWarfareData(H7TownBuildingData building,H7EditorWarUnit unit,H7Town town)
{
	local GFxObject data;
	
	data = CreateObject("Object");

	data.SetString("Name",unit.GetName());
	data.SetString("Icon",unit.GetFlashIconPath());
	data.SetInt("StackSize",1);
	data.SetObject("Color",CreateColorObject(town.GetPlayer().GetColor()));
	data.SetString("Faction",unit.GetFaction().GetName()); // using loca string as matching mechanic :-(
	data.SetObject("Cost",CreateCostArray(unit.GetUnitCost()));
	data.SetBool("CanAfford",unit.CanPlayerAffordWarUnit(town.GetPlayer()));
	data.SetString("Desc",unit.GetDesc()); // TODO Desc Tooltipreplacement system?
	data.SetString("ArchetypeID", unit.GetIDString());

	return data;
}

function GFxObject CreateArmyObjectOnlyWarfare(H7AdventureArmy army)
{
	local GFxObject data,units;
	local H7EditorWarUnit townUnit,heroUnit;

	data = CreateObject("Object");
	
	if(army == none) return data;
	if(army.GetHero() == none) return data;
	if(!army.GetHero().IsHero()) return data;

	data.SetObject("hero",CreateHeroObject(army.GetHero()));

	units = CreateArray();

	// left unit in gui = attack | hybrid
	townUnit = mTown.GetBuildingWarfare(true).GetWarunitTemplate();
	heroUnit = army.GetWarUnitByType(WCLASS_ATTACK);
	if(heroUnit == none)
	{
		heroUnit = army.GetWarUnitByType(WCLASS_HYBRID);
	}
	
	units.SetElementObject(0,CreateWarfarData(heroUnit,townUnit ));
	
	// right unit in gui = support | none
	townUnit = mTown.GetBuildingWarfare(false).GetWarunitTemplate();
	heroUnit = army.GetWarUnitByType(WCLASS_SUPPORT);
	
	units.SetElementObject(1,CreateWarfarData(heroUnit,townUnit ));
	
	data.SetObject("units",units);

	return data;
}

function GFxObject CreateWarfarData(H7EditorWarUnit existingUnit,H7EditorWarUnit availableUnit)
{
	local GFxObject data;

	if(existingUnit != none && existingUnit.GetIDString() == availableUnit.GetIDString())
	{
		data = CreateUnitObjectAdvancedWarfare(existingUnit);
		data.SetInt("StackSize",1);
	}
	else
	{
		data = CreateUnitObjectAdvancedWarfare(availableUnit);
		data.SetInt("StackSize",0);
	}

	return data;
}

// analog to CreateUnitObjectAdvanced
function GFxObject CreateUnitObjectAdvancedWarfare(H7EditorWarUnit creature) // OPIONAL could get a shorter version for name,icon only
{
	local GFxObject creatureObject;

	creatureObject = CreateObject("Object");
	if(creature == none) return creatureObject;
	
	creatureObject.SetString( "Name", creature.GetName() );
	creatureObject.SetString("ArchetypeID", creature.GetIDString());
	creatureObject.SetString("Icon" , creature.GetFlashIconPath() );
	creatureObject.SetString( "Faction", creature.GetFaction().GetName() );
	creatureObject.SetString( "Tier", class'H7Loca'.static.LocalizeSave("WARFARE_UNIT","H7General") );
	creatureObject.SetInt( "Health", creature.GetHitPoints() );
	creatureObject.SetString( "MovementType", string(  GetEnum( Enum'EMovementType',creature.GetMovementType() ) )   );
	creatureObject.SetString("SchoolName",  string( GetEnum( Enum'EAbilitySchool', creature.GetSchool() ) ) );

	// basic stats 
	creatureObject.SetInt( "MinDamage",1 ); // TODO 
	creatureObject.SetInt( "MaxDamage",2 ); // TODO 
	
	creatureObject.SetInt( "Attack", creature.GetAttack() );
	creatureObject.SetInt( "Defense", creature.GetDefense() );
	
	creatureObject.SetString( "Range", string(  GetEnum( Enum'EAttackRange', creature.GetAttackRange())));
	creatureObject.SetInt( "Luck", creature.GetDestiny() );
	creatureObject.SetInt( "Morale", creature.GetLeadership() );
	creatureObject.SetInt( "Initiative", creature.GetInitiative() );
	creatureObject.SetInt( "MovementPoints",  creature.GetMovementPoints() ) ;

	return creatureObject;
}

function TestCall()
{
	;
}
