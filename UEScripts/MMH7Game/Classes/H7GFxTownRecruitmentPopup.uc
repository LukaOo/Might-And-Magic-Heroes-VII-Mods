class H7GFxTownRecruitmentPopup extends H7GFxTownPopup;

// currentVassal = town, fort or dwelling
function Update(H7AreaOfControlSite currentLocation, H7AreaOfControlSite intitialLocation)
{
	local GFxObject mData, resourcesObj, resourceObj, creatureList, colorObject;
	local GFxObject aocArray;
	local array<String> savedCreatures;
	local int aocArrayLength;
	local array<H7Town> playerTowns;    
	local H7Town town;
	local array<H7Fort> playerForts;
	local H7fort fort;
	local array<int> aocNumbers; // contains the numbers of aoc's already added to aocArray
	local GfxObject buyAllItems, buyAllItem;

	local int resourceCounter;

	local array<ResourceStockpile> set;
	local ResourceStockpile pile;

	aocArrayLength=0;

	aocArray = CreateArray();
	buyAllItems = CreateArray();
	creatureList = CreateArray();
	mData = CreateObject("Object");

	set = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetResourceSet().GetAllResourcesAsArray();


	if(currentLocation.IsA('H7Dwelling'))
	{
		//aocNumbers.AddItem( class'H7AdventureGridManager'.static.GetInstance().GetAoCIndexOfCell( fort.GetEntranceCell() ));
		writeAOCData(currentLocation, aocArray, savedCreatures, creatureList, none,none,H7Dwelling(currentLocation), 0);
		
		buyAllItem = CreateObject("Object");
		CreateRecruitAllObject( currentLocation, buyAllItem, true);
		buyAllItems.SetElementObject(0, buyAllItem);
		mData.Setbool("CaravanEnabled", false);
		
	}
	else // In forts and towns you get the list of all your towns and forts + CARAVAN OUTPOST
	{
		playerTowns = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetTowns();
		playerForts = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetForts();

		foreach playerTowns(town)
		{
			if( aocNumbers.Find( town.GetAreaOfControlID() ) == -1 )
			{
				aocNumbers.AddItem( town.GetAreaOfControlID() );
				writeAOCData(currentLocation, aocArray, savedCreatures, creatureList, town, none, none, aocArrayLength);
				buyAllItem = CreateObject("Object");
				if(currentLocation.GetID() != town.getID())
					CreateRecruitAllObjectForCaravan(town, buyAllItem);
				else
					CreateRecruitAllObject(town, buyAllItem, currentLocation.GetID() == town.GetID() ? true : false);
				BuyAllItems.SetElementObject(aocArrayLength, buyAllItem);
				aocArrayLength++;
			}
			else
			{
				class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("Town" @ town.GetName() @ "is in same AOC as another town!!!!",MD_QA_LOG);;
				;
			}
		}

		foreach playerForts(fort)
		{
			if( aocNumbers.Find( fort.GetAreaOfControlID() ) == -1 )
			{
				aocNumbers.AddItem( fort.GetAreaOfControlID() );
				writeAOCData(currentLocation, aocArray, savedCreatures, creatureList, none, fort, none, aocArrayLength);
				buyAllItem = CreateObject("Object");
				if(currentLocation.GetID() != fort.GetID())
					CreateRecruitAllObjectForCaravan(fort, buyAllItem);
				else
					CreateRecruitAllObject( fort, buyAllItem, currentLocation.GetID() == fort.GetID() ? true : false);
				BuyAllItems.SetElementObject(aocArrayLength, buyAllItem);
				aocArrayLength++;
			}
			else
			{
				class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("Fort" @ fort.GetName() @ "is in same AOC as another town!!!!",MD_QA_LOG);;
				;
			}
		}
		mData.Setbool("CaravanEnabled", true);
	}

	mData.SetObject("Creatures", creatureList);

	colorObject = CreateObject("Object");
	colorObject.SetInt("r",currentLocation.GetPlayer().GetColor().R);
	colorObject.SetInt("g",currentLocation.GetPlayer().GetColor().G);
	colorObject.SetInt("b",currentLocation.GetPlayer().GetColor().B);
	mData.SetObject("Color", colorObject);

	// Set resources
	resourcesObj = CreateArray();
	resourceCounter = 0;
	foreach set(pile)
	{
		resourceObj = CreateObject("Object");
		resourceObj.SetString("Name", pile.Type.GetName());
		resourceObj.SetInt("Amount", pile.Quantity);
		resourcesObj.SetElementObject(resourceCounter, resourceObj);
		resourceCounter++;
	}
	mData.SetObject("Resources", resourcesObj);
	mData.SetObject("aocArray", aocArray);
	mData.SetObject("BuyAllItems", buyAllItems);
	mData.SetInt("CurrentLordID", currentLocation.GetID());
	mData.SetInt("LocationID", intitialLocation.GetID());
	mData.SetString("LocationName", intitialLocation.GetName());

	SetObject("mData", mData);
	ActionscriptVoid("Update");
}

function UpdateCaravanArmy(H7CaravanArmy caravan)
{
	SetObject("mCaravanData", CreateArmyObject( caravan ));
	ActionScriptVoid("UpdateCaravanArmy");
}

function UpdateFromNeutralDwelling(H7Dwelling dwelling)
{
	local GFxObject mData, resourcesObj, resourceObj, creatureList, colorObject;
	local GFxObject aocArray;
	local GfxObject buyAllItems, buyAllItem;
	local int resourceCounter;
	local array<ResourceStockpile> set;
	local ResourceStockpile pile;


	aocArray = CreateArray();
	buyAllItems = CreateArray();
	creatureList = CreateArray();
	mData = CreateObject("Object");

	set = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetResourceSet().GetAllResourcesAsArray();

	//aocNumbers.AddItem( class'H7AdventureGridManager'.static.GetInstance().GetAoCIndexOfCell( fort.GetEntranceCell() ));
	writeNeutralDwellingData(dwelling, aocArray, creatureList);
		
	buyAllItem = CreateObject("Object");
	CreateRecruitAllObject( dwelling, buyAllItem, false);
	buyAllItems.SetElementObject(0, buyAllItem);

	mData.SetObject("Creatures", creatureList);

	colorObject = CreateObject("Object");
	colorObject.SetInt("r",dwelling.GetPlayer().GetColor().R);
	colorObject.SetInt("g",dwelling.GetPlayer().GetColor().G);
	colorObject.SetInt("b",dwelling.GetPlayer().GetColor().B);
	mData.SetObject("Color", colorObject);

	// Set resources
	resourcesObj = CreateArray();
	resourceCounter = 0;
	foreach set(pile)
	{
		resourceObj = CreateObject("Object");
		resourceObj.SetString("Name", pile.Type.GetName());
		resourceObj.SetInt("Amount", pile.Quantity);
		resourcesObj.SetElementObject(resourceCounter, resourceObj);
		resourceCounter++;
	}
	mData.SetObject("Resources", resourcesObj);
	mData.SetObject("aocArray", aocArray);
	mData.SetObject("BuyAllItems", buyAllItems);
	mData.SetInt("CurrentLordID", dwelling.GetID());
	mData.SetInt("LocationID", dwelling.GetID());
	mData.SetString("LocationName", dwelling.GetName());
	mData.Setbool("CaravanEnabled", false);

	SetObject("mData", mData);
	ActionscriptVoid("Update");

}

// refactor town,fort,dwellingsite to 1
function writeAOCData(H7AreaOfControlSite location, out GFxObject aocArray, out array<String> savedCreatures, out GFxObject creatureList, H7Town town, H7Fort fort, H7Dwelling dwellingsite, int index)
{
	local GFxObject dwellingObject, dwellings, aocObject;
	local array<H7TownBuildingData> townDwellings;
	local H7TownBuildingData buildingData;
	local H7TownDwelling dwelling;
	local EPlayerNumber owningPlayerNr;

	local int canBuildIdolOfFertility;
	local int builtIdolOfFertility;
	local int canUseIdolOfFertility;

	local array<H7Dwelling> outsideDwellings;
	local H7Dwelling outsideDwelling;
	local array<H7DwellingCreatureData> outsideDwellingsCreatureDatas;

	local H7DwellingCreatureData dwellingCreatureData;
	local array<H7Creature> recruitableCreatures;
	local int dwellingCounter;

	local GFxObject dwellingCreatureNames;
	local GFxObject reserveList;
	local int reserveListCounter;
	local int outsideDwellingCreatureCounter;
	local GFxObject growthList;
	local int baseGrowthCounter;
	local float checkPathToSite;
	local float caravanMovement;
	local H7EventContainerStruct conti;
	local array<H7IEffectTargetable> targets;

	if(town!=none) { town.GetDwellings( townDwellings ); }

	aocObject = CreateObject("Object");
	dwellings = CreateArray();
	dwellingCounter = 0;


	if( town.GetCaravanArmy() == none )
	{
		town.CreateNewCaravan();
	}

	if( town.GetCaravanArmy() != none )
	{
		targets.AddItem( town.GetCaravanArmy().GetHero() );
		conti.Targetable = town.GetCaravanArmy().GetHero();
		conti.TargetableTargets = targets;
		town.TriggerEvents( ON_CARAVAN_CREATED, false, conti );
		caravanMovement = town.GetCaravanArmy().GetHero().GetMovementPoints();
	}
	else
	{
		caravanMovement = class'H7AdventureController'.static.GetInstance().GetConfig().mCaravanMaxMovementPoints;
	}

	town.GetCaravanArmy().GetHero().GetMovementPoints();

	//set the Town
	if(town!=none)
	{
		;
		checkPathToSite = town.CheckPathToSite(location);
		// TODO check if Golden Path is built

		aocObject.SetString("LordName", town.GetName());
		aocObject.SetString("LordIcon", town.GetFlashIconPath());
		aocObject.SetInt("LordLevel", town.GetLevel());
		aocObject.SetFloat("CaravanTime", checkPathToSite > 0 ? FCeil( checkPathToSite / caravanMovement ) : FCeil( checkPathToSite )  );
		aocObject.SetInt("LordID", town.GetID());
		aocObject.SetString("FactionIcon", town.GetFaction().GetFactionSepiaIconPath());
		outsideDwellings = town.GetOutsideDwellings();
		owningPlayerNr = town.GetPlayerNumber();
		;

		checkIdolOfFertility(town, canBuildIdolOfFertility, builtIdolOfFertility, canUseIdolOfFertility);
	}
	else if(fort != none)
	{
		;
		checkPathToSite = fort.CheckPathToSite(location);
		aocObject.SetString("LordName", fort.GetName());
		aocObject.SetString("LordIcon", fort.GetFlashIconPath());
		aocObject.SetInt("LordLevel", fort.GetLevel());
		aocObject.SetFloat("CaravanTime", checkPathToSite > 0 ? FCeil( checkPathToSite / caravanMovement ) : FCeil( checkPathToSite )  );
		aocObject.setInt("LordID", fort.GetID());
		aocObject.SetString("FactionIcon", fort.GetFaction().GetFactionSepiaIconPath());
		outsideDwellings = fort.GetOutsideDwellings();
		owningPlayerNr = fort.GetPlayerNumber();
	}
	else if(dwellingsite != none)
	{
		;
		checkPathToSite = dwellingsite.CheckPathToSite(location);
		aocObject.SetString("LordName", dwellingsite.GetName());
		aocObject.SetString("LordIcon", dwellingsite.GetFlashIconPath());
		aocObject.SetInt("LordLevel", 0);
		aocObject.SetFloat("CaravanTime", checkPathToSite > 0 ? FCeil( checkPathToSite / caravanMovement ) : FCeil( checkPathToSite )  );
		aocObject.setInt("LordID", dwellingsite.GetID());
		aocObject.SetString("FactionIcon", dwellingsite.GetFaction().GetFactionSepiaIconPath());
		outsideDwellings.AddItem(dwellingsite); //the visited outside dwelling
		owningPlayerNr =dwellingsite.GetPlayerNumber();
	}

	

	// TownDwellings
	foreach townDwellings(buildingData)
	{
		dwelling = H7TownDwelling( buildingData.Building );
		recruitableCreatures = dwelling.GetRecruitableCreatures();
		dwellingCreatureData = dwelling.GetCreaturePool();
	
		//`log_gui("adding dwelling to aocObject " $ dwelling.GetName());

		dwellingObject = CreateObject("Object");
		dwellingObject.setInt("ID", fort!=none ? fort.GetID() : town.GetID());
		dwellingObject.SetBool("TownDwelling", true);
		dwellingObject.SetString("DwellingName", dwelling.GetName());
		dwellingObject.SetBool("IsUpgradeable", false);

		dwellingObject.SetBool("CanBuildFertility", canBuildIdolOfFertility == 1 ? true : false);
		dwellingObject.SetBool("BuiltFertility", builtIdolOfFertility == 1 ? true : false);
		dwellingObject.SetBool("CanUseFertility", canUseIdolOfFertility == 1 ? true : false);

		if( dwelling.GetUpgrade() != none )
		{
			dwellingObject.SetBool("IsUpgradeable", true);
			dwellingObject.SetString("UpgradeName", dwelling.GetUpgrade().GetName());
		}
		dwellingObject.SetInt("Reserve", dwellingCreatureData.Reserve);

		growthList = CreateArray();	
		dwellingCreatureNames = CreateArray();
		if(recruitableCreatures.Length > 0)
		{

			dwellingCreatureNames.SetElementString(0, recruitableCreatures[0].GetName());
			if(savedCreatures.Find(recruitableCreatures[0].GetName())==-1)
			{
				AddCreatureObject(recruitableCreatures[0], savedCreatures.Length, creatureList, town);
				savedCreatures.AddItem(recruitableCreatures[0].GetName());
			}
			
			// By default we would not get the upgraded version of the base creature if the dwelling is not upgraded,
			// so the length of recruitableCreatures would be 1, but we still want to show the creature in the gui without 
			// being able to recruit it
			if(recruitableCreatures.Length == 1 && recruitableCreatures[0].GetUpgradedCreature() != none)
			{
				recruitableCreatures.AddItem(recruitableCreatures[0].GetUpgradedCreature());
			}

			//  not true anymore -> IF the dwelling is upgraded and we can recruit the upgraded version
			if(recruitableCreatures.Length > 1)
			{
				dwellingCreatureNames.SetElementString(1, recruitableCreatures[1].GetName());
				if(savedCreatures.Find(recruitableCreatures[1].GetName()) == -1)
				{
					AddCreatureObject(recruitableCreatures[1], savedCreatures.Length, creatureList, town);
					savedCreatures.AddItem(recruitableCreatures[1].GetName());
				}
			}
		}
		dwellingObject.SetObject("CreatureNames", dwellingCreatureNames);
		// Create Growth Tooltip
		CreateGrowthBonusObject(town, dwellingCreatureData.Creature, dwellingObject, dwelling);
		dwellings.SetElementObject(dwellingCounter, dwellingObject);

		dwellingCounter++;
	}
	
	//OutsideDwellings
	foreach outsideDwellings(outsideDwelling)
	{
		;
		if(outsideDwelling.GetPlayerNumber() != owningPlayerNr)
		{
			;
			continue;
		}
		reserveListCounter = 0;
		outsideDwellingCreatureCounter = 0;
		baseGrowthCounter = 0;
		growthList = CreateArray();	
		//DwellingData
		//`log_gui("adding outsideDwelling to aocObject " $ outsideDwelling.GetName());
		dwellingObject = CreateObject("Object");
		dwellingObject.SetBool("TownDwelling", false);
		dwellingObject.SetString("DwellingName", outsideDwelling.GetName());
		dwellingObject.SetInt("ID", outsideDwelling.GetID());
		dwellingObject.SetString("Icon", outsideDwelling.GetFlashIconPath());

		if(outsideDwelling.GetPlayerNumber() != class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetPlayerNumber())
		{
			dwellingObject.SetBool("Owned", false);
		}
		else
		{
			dwellingObject.SetBool("Owned", true);
		}
		
		dwellingObject.SetBool("IsUpgradeable", false);
		if( !outsideDwelling.IsUpgraded() )
		{
			dwellingObject.SetBool("IsUpgradeable", true);
			dwellingObject.SetObject("UpgradeCost", CreateUpgradeCostArray(outsideDwelling.GetUpgradeCost()));
			dwellingObject.SetBool("CanUpgrade", class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetResourceSet().CanSpendResources(outsideDwelling.GetUpgradeCost()));
		}
		reserveList = CreateArray();
		dwellingCreatureNames = CreateArray();
		outsideDwellingsCreatureDatas = outsideDwelling.GetCreaturePool();
		
		// foreach base Creature
		foreach outsideDwellingsCreatureDatas(dwellingCreatureData)
		{
			if( dwellingCreatureData.Creature == none )
			{
				class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("dwelling"@outsideDwelling@outsideDwelling.GetName()@"has invalid creature pool data",MD_QA_LOG);;
				continue;
			}
			//CreatureData
			reserveList.SetElementInt(reserveListCounter, dwellingCreatureData.Reserve);
			reserveListCounter++;
			dwellingCreatureNames.SetElementString(outsideDwellingCreatureCounter, dwellingCreatureData.Creature.GetName());
			outsideDwellingCreatureCounter++;
			growthList.SetElementInt(baseGrowthCounter, outsideDwelling.GetCreatureIncome( dwellingCreatureData.Creature) );
			baseGrowthCounter++;
			if(savedCreatures.Find(dwellingCreatureData.Creature.GetName()) == -1)
			{
				AddCreatureObject(dwellingCreatureData.Creature, savedCreatures.Length, creatureList, outsideDwelling);
				savedCreatures.AddItem(dwellingCreatureData.Creature.GetName());
			}
			if(dwellingCreatureData.Creature.GetUpgradedCreature() != none)
			{
				reserveList.SetElementInt(reserveListCounter, dwellingCreatureData.Reserve);
				reserveListCounter++;
				dwellingCreatureNames.SetElementString(outsideDwellingCreatureCounter, dwellingCreatureData.Creature.GetUpgradedCreature().GetName());
				outsideDwellingCreatureCounter++;
				//growthList.SetElementInt(baseGrowthCounter, dwellingCreatureData.Income);
				//baseGrowthCounter++;	
				if(savedCreatures.Find(dwellingCreatureData.Creature.GetUpgradedCreature().GetName()) == -1)
				{
					AddCreatureObject(dwellingCreatureData.Creature.GetUpgradedCreature(), savedCreatures.Length, creatureList, outsideDwelling);
					savedCreatures.AddItem(dwellingCreatureData.Creature.GetUpgradedCreature().GetName());
				}
			}
		}	

		// Create Growth Tooltip
		CreateOutsideDwellingGrowthBonusObject(outsideDwelling, dwellingCreatureData, dwellingObject);
		dwellingObject.SetObject("ReserveList", reserveList);
		dwellingObject.SetObject("CreatureNames", dwellingCreatureNames);
		dwellingObject.SetObject("GrowthList", growthList);
		
		;
		dwellings.SetElementObject(dwellingCounter, dwellingObject);
		dwellingCounter++;
	}
		
	if( town != none )
	{
		aocObject.SetString("TownIcon", town.GetFlashIconPath());
	}
	aocObject.SetObject("Dwellings", dwellings);

	// check if there is at least one free slot, if not create an array containing all the
	// creature names in visiting and garrison army
	// NOTE: as of 12.5. the method below is not used anymore since getRecruitAllData already takes
	// the free army slots inot account
	//CreateArmyUnitsTypesObject(town, none, fort, aocObject);

	aocArray.SetElementObject(index, aocObject);
}

function writeNeutralDwellingData(H7Dwelling dwelling, out GFxObject aocArray, out GFxObject creatureList)
{
	local GFxObject dwellingObject, dwellings, aocObject;
	local array<String> savedCreatures;
	
	local array<H7DwellingCreatureData> outsideDwellingsCreatureDatas;
	
	local H7DwellingCreatureData dwellingCreatureData;

	local GFxObject dwellingCreatureNames;
	local GFxObject reserveList;
	local int reserveListCounter;
	local int outsideDwellingCreatureCounter;
	local GFxObject growthList;
	local int baseGrowthCounter, i;

	
	aocObject = CreateObject("Object");
	dwellings = CreateArray();
	
	aocObject.SetString("LordName", dwelling.GetName());
	aocObject.SetString("LordIcon", dwelling.GetFaction().GetFactionSepiaIconPath());
	aocObject.SetInt("LordLevel", 0);
	aocObject.SetFloat("CaravanTime", -1 );
	aocObject.setInt("LordID", dwelling.GetID());
	aocObject.SetString("FactionIcon", dwelling.GetFaction().GetFactionSepiaIconPath());
	
	reserveListCounter = 0;
	outsideDwellingCreatureCounter = 0;
	baseGrowthCounter = 0;
	growthList = CreateArray();	
	
	//DwellingData
	dwellingObject = CreateObject("Object");
	dwellingObject.SetBool("TownDwelling", false);
	dwellingObject.SetString("DwellingName", dwelling.GetName());
	dwellingObject.SetInt("ID", dwelling.GetID());
	dwellingObject.SetString("Icon", dwelling.GetFaction().GetFactionSepiaIconPath());
	dwellingObject.SetBool("Owned", true);
	dwellingObject.SetBool("IsUpgradeable", false);
	
	reserveList = CreateArray();
	dwellingCreatureNames = CreateArray();
	outsideDwellingsCreatureDatas = dwelling.GetCreaturePool();
		
	// foreach base Creature
	foreach outsideDwellingsCreatureDatas(dwellingCreatureData, i)
	{
		if( dwellingCreatureData.Creature == none )
		{
			class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("dwelling"@dwelling@dwelling.GetName()@"has invalid creature pool data",MD_QA_LOG);;
			continue;
		}
		//CreatureData
		reserveList.SetElementInt(reserveListCounter, dwellingCreatureData.Reserve);
		reserveListCounter++;
		dwellingCreatureNames.SetElementString(outsideDwellingCreatureCounter, dwellingCreatureData.Creature.GetName());
		outsideDwellingCreatureCounter++;
		growthList.SetElementInt(baseGrowthCounter, dwelling.GetCreatureIncome(dwellingCreatureData.Creature)); //dwellingCreatureData.Income);
		baseGrowthCounter++;
		if(savedCreatures.Find(dwellingCreatureData.Creature.GetName()) == -1)
		{
			AddCreatureObject(dwellingCreatureData.Creature, savedCreatures.Length, creatureList, dwelling);
			savedCreatures.AddItem(dwellingCreatureData.Creature.GetName());
		}
	
		/*if((dwellingCreatureData.Creature.GetUpgradedCreature() != none &&
		   outsideDwellingsCreatureDatas.Length - 1 < i + 1 &&
		   outsideDwellingsCreatureDatas[i+1].Creature.GetName() != dwellingCreatureData.Creature.GetUpgradedCreature().GetName())
		   && (outsideDwellingCreatureCounter%2 == 0) )*/
		
		if(outsideDwellingCreatureCounter%2 != 1) continue;
		
		if(dwellingCreatureData.Creature.GetUpgradedCreature() != none &&
		   outsideDwellingsCreatureDatas[i+1].Creature.GetName() == dwellingCreatureData.Creature.GetUpgradedCreature().GetName() )
		{
		
			baseGrowthCounter--;
		}
		else
		{
			dwellingCreatureNames.SetElementString(outsideDwellingCreatureCounter, "");
			outsideDwellingCreatureCounter++;
			reserveList.SetElementInt(reserveListCounter, -1);
			reserveListCounter++;
		}
		
	}	

	// Create Growth Tooltip
	dwellingObject.SetObject("ReserveList", reserveList);
	dwellingObject.SetObject("CreatureNames", dwellingCreatureNames);
	dwellingObject.SetObject("GrowthList", growthList);
		
	dwellings.SetElementObject(0, dwellingObject);
	
		
	aocObject.SetObject("Dwellings", dwellings);

	// check if there is at least one free slot, if not create an array containing all the
	// creature names in visiting and garrison army
	// NOTE: as of 12.5. the method below is not used anymore since getRecruitAllData already takes
	// the free army slots inot account
	//CreateArmyUnitsTypesObject(town, none, fort, aocObject);

	aocArray.SetElementObject(0, aocObject);

}

function checkIdolOfFertility(H7Town town, out int canBuildIdolOfFertility, out int builtIdolOfFertility, out int canUseIdolOfFertility)
{
	local H7TownBuilding building;
	building = town.GetBuildingByType(class'H7TownIdolOfFertility');
	
	if(building != none)
	{   
		canBuildIdolOfFertility = 1;
		builtIdolOfFertility = 1;
		canUseIdolOfFertility = H7TownIdolOfFertility(building).CanBeActivated() ? 1 : 0;
	}
	else
	{
		builtIdolOfFertility = 0;
	}
}

function GFxObject CreateUpgradeCostArray(array<H7ResourceQuantity> upgradeCosts)
{
	local H7ResourceQuantity cost;
	local GFxObject list,costObject;
	local int i;

	list = CreateArray();

	i = 0;
	foreach upgradeCosts(cost)
	{
		costObject = CreateObject("Object");
		costObject.SetString("Name",cost.Type.GetName());
		costObject.SetInt("Amount",cost.Quantity);
		costObject.SetString("ResIcon",cost.Type.GetIconPath());
		
		list.SetElementObject(i,costObject);
		i++;
	}

	return list;
}

function RightMouseDown()
{
	ActionscriptVoid("RightMouseDown");
}

function AddCreatureObject(H7Creature creature, int i, out GFxObject creatures, optional H7AreaOfControlSite location)
{
	local GFxObject creatureObject;
	local array<H7ResourceQuantity> cost;
	local float currencyMod;
	local int j;

	creatureObject = CreateObject("Object");

	creatureObject = CreateUnitObjectAdvanced(creature);

	if(H7AreaOfControlSiteLord(location) != none)
	{
		H7AreaOfControlSiteLord(location).CalculateRecruitmentCosts(creature, 1, cost);
	}
	else
	{
		cost = creature.GetUnitCost();
	}

	if( H7CustomNeutralDwelling( location ) != none )
	{
		if( location.GetVisitingArmy() != none )
		{
			currencyMod = location.GetVisitingArmy().GetHero().GetModifiedStatByID( STAT_NEUTRAL_CREATURE_COST );
			for( j = 0; j < cost.Length; ++j )
			{
				if( cost[j].Type == location.GetVisitingArmy().GetPlayer().GetResourceSet().GetCurrencyResourceType() )
				{
					cost[j].Quantity *= currencyMod;
					break;
				}
			}
		}
	}
	
	cost.Sort( CreatureCostResourceCompareGUI );
	creatureObject.SetObject("Cost", CreateCostArray(cost));

	creatures.SetElementObject(i, creatureObject);
}

function int CreatureCostResourceCompareGUI( H7ResourceQuantity a, H7ResourceQuantity b )
{
	if( a.Type.GetGUIPriority() > b.Type.GetGUIPriority() ) return -1;
	if( a.Type.GetGUIPriority() < b.Type.GetGUIPriority() ) return 1;
	return 0;
}

function CreateRecruitAllObject(H7AreaOfControlSite site, out GFxObject buyAllItem, optional bool checkArmy)//H7AdventureArmy visitingArmy)
{
	local GFxObject BuyAll, costItem;
	local int i;
	local array<H7RecruitmentInfo> datas;
	local H7RecruitmentInfo data;
	local bool checkGarrisonArmy;


	if(checkArmy) checkGarrisonArmy = true;
	
	//GetRecruitAllData already checks for freeSlots
	datas = site.GetRecruitAllData(checkGarrisonArmy);
	
	BuyAll = CreateArray();
	BuyAllItem.SetInt("LordID", site.GetID());
	
	i = 0;
	foreach datas(data)
	{
		if(data.Count == 0) continue;
		
		//`log_gui("buy all"@ data.Creature.GetName()@data.Count);
		costItem = CreateObject("Object");
		costItem.SetString("Name", data.Creature.GetName());
		costItem.SetString("ArchetypeID", data.Creature.GetIDString());
		costItem.SetInt("Count", data.Count);
		costItem.SetInt("DwellingID", data.OriginDwelling!=none ? data.OriginDwelling.GetID() : site.GetID());
		costItem.SetObject("Cost", CreateCostArray(data.Costs));

		BuyAll.SetElementObject(i, costItem);
		i++;
	}
	
	buyAllItem.SetObject("BuyAll", BuyAll);

	if(datas.Length == 0)
		buyAllItem.SetString("BlockReason", site.GetRecruitAllBlockReason());
}

function CreateRecruitAllObjectForCaravan(H7AreaOfControlSiteLord lord, out GFxObject buyAllItem)
{
	local GFxObject BuyAll, costItem;
	local int i;
	local array<H7RecruitmentInfo> datas;
	local H7RecruitmentInfo data;
	
	//GetRecruitAllData already checks for freeSlots
	datas = lord.GetRecruitAllDataForCaravan();
	
	BuyAll = CreateArray();
	BuyAllItem.SetInt("LordID", lord.GetID());
	
	i = 0;
	foreach datas(data)
	{
		if(data.Count == 0) continue;
		
		//`log_gui("buy all"@ data.Creature.GetName()@data.Count);
		costItem = CreateObject("Object");
		costItem.SetString("Name", data.Creature.GetName());
		costItem.SetString("ArchetypeID", data.Creature.GetIDString());
		costItem.SetInt("Count", data.Count);
		costItem.SetInt("DwellingID", data.OriginDwelling!=none ? data.OriginDwelling.GetID() : lord.GetID());
		costItem.SetObject("Cost", CreateCostArray(data.Costs));

		BuyAll.SetElementObject(i, costItem);
		i++;
	}
	
	buyAllItem.SetObject("BuyAll", BuyAll);

	if(datas.Length == 0)
		buyAllItem.SetString("BlockReason", lord.GetRecruitAllBlockReasonForCaravan());
}

// Not used anymore
function CreateArmyUnitsTypesObject(H7Town town, H7Dwelling dwelling, H7Fort fort, out GFxObject obj)
{
	local GFxObject typeList;
    local array<H7BaseCreatureStack> creatures;
	local array<String> creatureNames;
	local String creatureName;
	local int i, freeSlots;
	
	typeList = CreateArray();
	if(town != none) 
	{ 
		creatures = town.GetGarrisonArmy().GetBaseCreatureStacks();
		freeSlots = town.getFreeStackSlots();
	}
	if(fort != none) 
	{
		creatures = fort.GetGarrisonArmy().GetBaseCreatureStacks();
		freeSlots = fort.getFreeStackSlots();
	}
	if(dwelling != none)
	{   
		creatures = dwelling.GetVisitingArmy().GetBaseCreatureStacks();
		freeSlots = dwelling.GetVisitingArmy().GetFreeSlotCount();
	}
	
	for(i=0; i<creatures.Length; i++)
	{
		if( creatures[i] != none && creatureNames.Find(creatures[i].GetStackType().GetName()) == -1) 
		{
			creatureNames.AddItem(creatures[i].GetStackType().GetName());
		}
	}

	if(town != none && town.GetVisitingArmy() != none)
	{
		creatures = town.GetVisitingArmy().GetBaseCreatureStacks();
		for(i=0; i<creatures.Length; i++)
		{
			if( creatures[i] != none && creatureNames.Find(creatures[i].GetStackType().GetName()) == -1) 
			{
				creatureNames.AddItem(creatures[i].GetStackType().GetName());
			}
		}
	}

	i = 0;
	
	foreach creatureNames(creatureName)
	{
		typeList.SetElementString(i, creatureName);
		i++;
	}
	obj.SetObject("Names", typeList);
	obj.SetInt("FreeSlot", freeSlots);

}

function CreateGrowthBonusObject(H7Town town, H7Creature creature, GFxObject dwellingObject, H7TownDwelling dwelling)
{
	local GFxObject bonuses, bonus;
	local int i;
	local array<H7TooltipModifierInfo> infos;
	local H7TooltipModifierInfo info;

	town.GetGrowthBonus(creature, infos, dwelling);

	bonuses = CreateArray();
	i = 0;

	bonus = CreateObject("Object");
	bonus.SetString("Category", "");
	bonus.SetString("Source", dwelling.GetName());
	bonus.SetInt("Value", dwelling.GetCreatureIncome());
	bonuses.SetElementObject(i, bonus );
	i++;

	foreach infos(info)
	{
		bonus = CreateObject("Object");
		bonus.SetString("Category", info.Category);
		bonus.SetString("Source", info.Source);
		bonus.SetInt("Value", info.Value);
		bonuses.SetElementObject(i, bonus);
		i++;
	}

	dwellingObject.SetObject("GrowthBonus", bonuses);
}

function CreateOutsideDwellingGrowthBonusObject(H7Dwelling dwelling, H7DwellingCreatureData creatureData, GFxObject dwellingObject)
{
	local GFxObject bonuses, bonus;
	local int i;
	local array<H7TooltipModifierInfo> infos;
	local H7TooltipModifierInfo info;

	dwelling.GetGrowthBonus(creatureData.Creature, infos);
	bonuses = CreateArray();
	i = 0;

	foreach infos(info)
	{
		bonus = CreateObject("Object");
		bonus.SetString("Category", info.Category);
		bonus.SetString("Source", info.Source);
		bonus.SetInt("Value", info.Value);
		bonuses.SetElementObject(i, bonus);
		i++;
	}

	dwellingObject.SetObject("GrowthBonus", bonuses);
}

function RecruitAll()
{
	ActionscriptVoid("RecruitAllFromUnreal");
}
