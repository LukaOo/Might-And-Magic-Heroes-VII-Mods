//=============================================================================
// H7GFxTownGuardPopup
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxTownGuardPopup extends H7GFxTownPopup;

var array<H7TownBuildingData> buildings;

function Update(H7AreaOfControlSite site)
{
	local GFxObject data, buildingData;
	local H7Town town;	 
	local H7TownBuildingData fort1, fort2, fort3, siegeBuilding;
	local array<H7TownBuildingData> guardEnhancers;
	local H7TownBuildingData guardEnhancer;
	local H7TownBuilding championGuardTower,advDef;
	local String wallAndGetLevel, archetypePath;

	;

	data = CreateObject("Object");
		
	// buildings
	if(site.isA('H7Town'))
	{
		town = H7Town(site);
		buildingData = CreateObject("Object");
	
		buildings = town.GetBuildingTemplatesByType(class'H7TownGuardBuilding');

		fort1 = getFort1();
		fort2 = getFort2();
		fort3 = getFort3();

		//Fortification 1
		data.SetObject("Fortification1", CreateBuildingObject(fort1, town));

		//Fortification 2
		data.SetObject("Fortification2", CreateBuildingObject(fort2, town));

		//Fortification 3
		data.SetObject("Fortification3", CreateBuildingObject(fort3, town));
	
		wallAndGetLevel = String( town.GetBuildingLevelByType(class'H7TownGuardBuilding') );
		if( wallAndGetLevel == "1" ) wallAndGetLevel = "";

		// Walls
		buildingData = CreateObject("Object");
		archetypePath = PathName(town.GetCombatMapWall());
		archetypePath = archetypePath $ wallAndGetLevel;
		buildingData.SetString("Icon", class'H7PlayerController'.static.GetPlayerController().GetHUD().GetProperties().GetIconWallPath());
		buildingData.SetInt("HP", H7CombatMapWall(DynamicLoadObject(archetypePath, class'H7CombatMapWall')).GetHitpoints());//town.GetCombatMapWall().GetHitpoints());
		buildingData.SetString("Name", town.GetCombatMapWall().GetName());
		data.SetObject("Walls", buildingData);

		// Gate
		buildingData = CreateObject("Object");
		archetypePath = PathName(town.GetCombatMapGate());
		archetypePath = archetypePath $ wallAndGetLevel;
		buildingData.SetString("Icon",class'H7PlayerController'.static.GetPlayerController().GetHUD().GetProperties().GetIconGatePath());
		town.DelFactionGateImageRef();
		buildingData.SetInt("HP", H7CombatMapGate(DynamicLoadObject(archetypePath, class'H7CombatMapGate')).GetHitpoints());
		buildingData.SetString("Name", town.GetCombatMapGate().GetName());
		data.SetObject("Gate", buildingData);

		// Tower
		siegeBuilding = town.GetBuildingTemplateByType(class'H7TownTower');
		buildingData = CreateObject("Object");
		buildingData.SetString("Icon", class'H7PlayerController'.static.GetPlayerController().GetHUD().GetProperties().GetIconTowerPath());
		town.DelFactionTowerImageRef();
		buildingData.SetInt("HP", town.GetCombatMapTower().GetHitpoints() );
		buildingData.SetString("Name", town.GetCombatMapTower().GetName() );
		buildingData.SetInt("MaxDamage", town.GetCombatMapTower().GetTowerUnitArchetype().GetMaximumDamage() );
		buildingData.SetInt("MinDamage", town.GetCombatMapTower().GetTowerUnitArchetype().GetMinimumDamage() );
		buildingData.SetString("SchoolName",  string( GetEnum( Enum'EAbilitySchool', town.GetCombatMapTower().GetTowerUnitArchetype().GetSchool() )));
		buildingData.SetBool("IsBuilt", siegeBuilding.IsBuilt);
		data.SetObject("Tower", buildingData);

		town.DelCombatMapTowerRef(); 

		// siegeBuildings
		siegeBuilding = town.GetBuildingTemplateByType(class'H7TownMoat');
		data.SetObject("Moat", CreateBuildingObject(siegeBuilding, town));

		guardEnhancers = town.GetBuildingsByType(class'H7TownGuardGrowthEnhancer');
		
		ForEach guardEnhancers(guardEnhancer)
		{
			if(H7TownGuardGrowthEnhancer(guardEnhancer.Building).IsChampionGuardTower())
			{
				championGuardTower = guardEnhancer.Building;//siegeBuilding.Building.GetAlternate();
				buildingData = CreateBuildingObjectFromBuildng(championGuardTower, town);
				data.SetObject("ChampionGuardTower", buildingData);
			}
		}

		advDef = advDef;
		/*
		advDef = town.GetBuildingsByType(class'H7TownAdv'); // TODOD
		buildingData = CreateBuildingObjectFromBuildng(advDef, town);
		data.SetObject("AdvDefense", buildingData);
		*/

		// ChampionGuardTower
		// siegeBuilding contains moat
		/*if(siegeBuilding.Building.GetAlternate() != none)
		{
			championGuardTower = siegeBuilding.Building.GetAlternate();
			buildingData = CreateBuildingObjectFromBuildng(championGuardTower, town);
			data.SetObject("ChampionGuardTower", buildingData);
		}*/

		;
		;
		;
		//`log_gui("A WAll mxHP" @ ),
	}

	
	// local guard
	if(site.isA('H7Town'))
	{
		data.SetString("BannerIconPath", H7Town(site).GetFactionBannerIconPath());
		town.DelFactionBannerIconRef();
		data.SetObject("townGuard",CreateArmyObjectFromPool(site));
	}
	else
	{
		data.SetString("Title",site.GetName());
		data.SetString("BannerIconPath", H7Garrison(site).GetFactionBannerIconPath());
		 H7Garrison(site).DelFactionBannerIconRef();
		data.SetObject("townGuard",CreateArmyObjectFromPool(site));
	}

	SetObject("mData", data);

	ActionScriptVoid("Update");
}

function H7TownBuildingData getFort1()
{
	local bool found;
	local H7TownBuildingData building, building2;
	local array<H7TownBuilding> pres;

	foreach buildings(building)
	{
		found = false;
		pres = building.Building.GetPrerequisites();
		foreach buildings(building2)
		{
			if(pres.Find( building2.Building) != INDEX_NONE){ found = true; break; }
		}
		if(!found) return building;
	}
}

function H7TownBuildingData getFort2()
{
	local H7TownBuildingData building, building2;
	local H7TownBuilding upgrade,upgrade2;

	foreach buildings(building)
	{
		upgrade = building.Building.GetUpgrade();
		if(upgrade != none) // building could be 1 or 2
		{
			foreach buildings(building2)
			{
				upgrade2 = building2.Building.GetUpgrade();
				if(upgrade2 == building.Building) // only 2 has an upgrade, and an upgrade pointing towards it
				{
					return building;
				}
			}
		}
	}
}

function H7TownBuildingData getFort3()
{
	local H7TownBuildingData building;

	foreach buildings(building)
	{
		if(buildings.Find('Building', building.Building.GetUpgrade()) == -1) return building;
	}
}
