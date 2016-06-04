//=============================================================================
// H7AiActionDevelopTownBuilding
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionDevelopTownBuilding extends H7AiActionBase;

function String DebugName()
{
	return "Develop Town Building";
}

function Setup()
{
	mABID=__AID_MAX;
}

/// override function(s)

function RunScoresTown( H7AiAdventureSensors sensors, H7AreaOfControlSiteLord currentControlSite, out array<AiActionScore> scores, optional H7AdventureConfiguration cfg )
{
	local AiActionScore             score;
	local H7AiSensorInputConst      sic;
	local H7Player                  ply;
	local array<H7TownBuilding>     utBuildings;
	local H7Town                    town;
	local bool                      buildingRequirementCheck, buildingCostCheck;
	local H7TownBuilding            building;
	local array<H7AreaOfControlSiteVassal>  vassals;
	local H7AreaOfControlSiteVassal vassal;
	local H7Dwelling                dwelling;
	local bool                      alternateMain;
	local bool                      useTechTree;
	local array<H7TownBuildingData> buildingData;
	local H7TownBuildingData        bData;

	useTechTree = true;

	sic = sensors.GetSensorIConsts();

	score.action = Self;
	score.score = 0.0f;

	// economy buildings scoring
	town=H7Town(currentControlSite);
	if(town==None) return; // should never be called if site is not a town so ..
	ply=town.GetPlayer();
	if(ply==None) return;
	ply.AiClearNeedForTownDev();
	ply.AiClearNeedForRecruitment();

	sic.SetTargetVisSite(currentControlSite);

	alternateMain=true;

	// #1 use fixed tech tree
	if( town.GetFaction().GetArchetypeID() == "H7FactionHaven" )
	{
		if(town.GetAiIsMain()==true)
		{
			if(alternateMain==false) utBuildings=cfg.mAiAdvMapConfig.mConfigTechTrees.Haven.Military; else utBuildings=cfg.mAiAdvMapConfig.mConfigTechTrees.Haven.Economy;
		}
		else
			utBuildings=cfg.mAiAdvMapConfig.mConfigTechTrees.Haven.Defensive;
	}
	else if( town.GetFaction().GetArchetypeID() == "H7FactionAcademy" )
	{
		if(town.GetAiIsMain()==true)
		{
			if(alternateMain==false) utBuildings=cfg.mAiAdvMapConfig.mConfigTechTrees.Academy.Military; else utBuildings=cfg.mAiAdvMapConfig.mConfigTechTrees.Academy.Economy;
		}
		else
			utBuildings=cfg.mAiAdvMapConfig.mConfigTechTrees.Academy.Defensive;
	}
	else if( town.GetFaction().GetArchetypeID() == "H7FactionStronghold" )
	{
		if(town.GetAiIsMain()==true)
		{
			if(alternateMain==false) utBuildings=cfg.mAiAdvMapConfig.mConfigTechTrees.Stronghold.Military; else utBuildings=cfg.mAiAdvMapConfig.mConfigTechTrees.Stronghold.Economy;
		}
		else
			utBuildings=cfg.mAiAdvMapConfig.mConfigTechTrees.Stronghold.Defensive;
	}
	else if( town.GetFaction().GetArchetypeID() == "H7FactionDungeon" )
	{
		if(town.GetAiIsMain()==true)
		{
			if(alternateMain==false) utBuildings=cfg.mAiAdvMapConfig.mConfigTechTrees.Dungeon.Military; else utBuildings=cfg.mAiAdvMapConfig.mConfigTechTrees.Dungeon.Economy;
		}
		else
			utBuildings=cfg.mAiAdvMapConfig.mConfigTechTrees.Dungeon.Defensive;
	}
	else if( town.GetFaction().GetArchetypeID() == "H7FactionSylvan" )
	{
		if(town.GetAiIsMain()==true)
		{
			if(alternateMain==false) utBuildings=cfg.mAiAdvMapConfig.mConfigTechTrees.Sylvan.Military; else utBuildings=cfg.mAiAdvMapConfig.mConfigTechTrees.Sylvan.Economy;
		}
		else
			utBuildings=cfg.mAiAdvMapConfig.mConfigTechTrees.Sylvan.Defensive;
	}
	else if( town.GetFaction().GetArchetypeID() == "H7FactionNecropolis" )
	{
		if(town.GetAiIsMain()==true)
		{
			if(alternateMain==false) utBuildings=cfg.mAiAdvMapConfig.mConfigTechTrees.Necropolis.Military; else utBuildings=cfg.mAiAdvMapConfig.mConfigTechTrees.Necropolis.Economy;
		}
		else
			utBuildings=cfg.mAiAdvMapConfig.mConfigTechTrees.Necropolis.Defensive;
	}
	else if( town.GetFaction().GetArchetypeID() == "H7FactionFortress" )
	{
		if(town.GetAiIsMain()==true)
		{
			if(alternateMain==false) utBuildings=cfg.mAiAdvMapConfig.mConfigTechTrees.Fortress.Military; else utBuildings=cfg.mAiAdvMapConfig.mConfigTechTrees.Fortress.Economy;
		}
		else
			utBuildings=cfg.mAiAdvMapConfig.mConfigTechTrees.Fortress.Defensive;
	}
	else if( town.GetFaction().GetArchetypeID() == "H7FactionInferno" )
	{
		if(town.GetAiIsMain()==true)
		{
			if(alternateMain==false) utBuildings=cfg.mAiAdvMapConfig.mConfigTechTrees.Inferno.Military; else utBuildings=cfg.mAiAdvMapConfig.mConfigTechTrees.Inferno.Economy;
		}
		else
			utBuildings=cfg.mAiAdvMapConfig.mConfigTechTrees.Inferno.Defensive;
	}
	else if( town.GetFaction().GetArchetypeID() == "H7FactionSanctuary" )
	{
		if(town.GetAiIsMain()==true)
		{
			if(alternateMain==false) utBuildings=cfg.mAiAdvMapConfig.mConfigTechTrees.Sanctuary.Military; else utBuildings=cfg.mAiAdvMapConfig.mConfigTechTrees.Sanctuary.Economy;
		}
		else
			utBuildings=cfg.mAiAdvMapConfig.mConfigTechTrees.Sanctuary.Defensive;
	}
	else //fallback in case we are not running a standard setting
	{
		useTechTree = false;
		buildingData = town.GetBuildingTree();
		foreach buildingData( bData )
		{
			if( !bData.IsBuilt )
			{
				utBuildings.AddItem( bData.Building );
			}
		}
	}

	if( utBuildings.Length > 0 )
	{
		foreach utBuildings(building)
		{
			if(building!=None && town.IsBuildingBuilt(building)==false )
			{
				// this one needs further investigation
				buildingRequirementCheck = town.CheckBuildingRequirements(building);
				buildingCostCheck = ply.AiCanSpendResourcesOnTownDev(building.GetCost(town));
				if( buildingRequirementCheck == false )
				{
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				}
				if( buildingCostCheck == false )
				{
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
					// mod. need values for trading
					ply.AiModifyNeedForTownDev(building.GetCost(town));
				}

				if(buildingRequirementCheck==true && buildingCostCheck==true )
				{
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

					score.params = new () class'H7AiActionParam';
					score.params.Clear();
					score.params.SetVisSite(APID_1,sic.GetTargetVisSite());
					score.params.SetTownBuilding(APID_2,building);

					score.dbgString = "Action.DevelopTown; " $ town.GetName() $ "-" $ building.GetName() $ "; BaseUtil(" $ building.GetBuildingBaseUtility() $ ") ";

					score.score=building.GetBuildingBaseUtility();
					scores.AddItem(score);
					
				}

				if( useTechTree )
				{
					break;
				}

				break;
			}
		}

		// check for external dwellings
		vassals=town.GetVassals();
		foreach vassals(vassal)
		{
			if( vassal.IsA('H7Dwelling') && vassal.GetPlayerNumber()==town.GetPlayerNumber() )
			{
				dwelling=H7Dwelling(vassal);
				if(dwelling!=None && dwelling.IsUpgraded()==false)
				{
					if( ply.AiCanSpendResourcesOnTownDev(dwelling.GetUpgradeCost()) == true )
					{
						score.params = new () class'H7AiActionParam';
						score.params.Clear();
						score.params.SetVisSite(APID_1,sic.GetTargetVisSite());
						score.params.SetVisSite(APID_3,vassal);

						score.dbgString = "Action.DevelopTown; " $ town.GetName() $ "- external dwelling " $ vassal.GetName() $ "; BaseUtil(" $ vassal.GetAiBaseUtility() $ ") ";

						score.score=vassal.GetAiBaseUtility();
						scores.AddItem(score);
					}
				}
			}
		}
	}
}

function bool PerformActionTown( H7AreaOfControlSiteLord site, AiActionScore score )
{
	local H7Town town;
	local H7TownBuilding building;
	local H7VisitableSite site_dwelling;
	local int cost;

	town = H7Town(score.params.GetVisSite(APID_1));
	building = score.params.GetTownBuilding(APID_2);
	site_dwelling = score.params.GetVisSite(APID_3);
	if(town!=None && building!=None)
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		// transfere (all) money from treasure chest
		cost=town.GetPlayer().GetAiSaveUpSpendingTownDev().GetCurrency();
		town.GetPlayer().GetAiSaveUpSpendingTownDev().ModifyCurrencySilent(-cost);
		town.GetPlayer().GetResourceSet().ModifyCurrencySilent(cost);

		return town.BuildBuilding(building.GetIDString());
	}
	if(town!=None && site_dwelling!=None)
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		// transfere (all) money from treasure chest
		cost=town.GetPlayer().GetAiSaveUpSpendingTownDev().GetCurrency();
		town.GetPlayer().GetAiSaveUpSpendingTownDev().ModifyCurrencySilent(-cost);
		town.GetPlayer().GetResourceSet().ModifyCurrencySilent(cost);

		H7Dwelling(site_dwelling).Upgrade();

		return true;
	}

	return false;
}
