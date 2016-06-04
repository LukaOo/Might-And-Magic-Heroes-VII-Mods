//=============================================================================
// H7GFxThievesGuildPopup
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxThievesGuildPopup extends H7GFxTownPopup;

/**
 *  fromDenOfThievesAfterUse: determines if the popup is being updated from a den of thieves AFTER 
 *  revealing information -> to prevet popup from pre-selecting a locked information tile ->
 *  so the selected tile will still be selected after revealing the information
 */
function Update(H7DenOfThieves denOfThieves, bool fromDenOfThievesAfterUse)
{
	local array<H7Player> players;
	local H7player player;
	local int playerCount;
	local GFxObject data, playersData, currentPlayerData, pColor;
	local Array<H7PlayerSpyInfo> infos;
	local H7PlayerSpyInfo info;
	local H7AdventureController advCntl;
//	local int currentPlayerTeamNumber;
//	local bool allies;

	advCntl = class'H7AdventureController'.static.GetInstance();
	players = advCntl.GetPlayers();
	data = CreateObject("Object");
	playersData = CreateArray();
	playerCount = 1;
	infos = advCntl.GetCurrentPlayer().GetThievesGuildManager().GetPlayerSpyInfos();
	//currentPlayerTeamNumber = advCntl.GetCurrentPlayer().GetTeamNumber();


	foreach players(player)
	{
		if(player.GetPlayerNumber() == PN_NEUTRAL_PLAYER) continue;
		foreach infos(info)
		{
			//only add actual players
			if(info.PlayerID != player.GetID()) 
			{
				continue;
			}
			currentPlayerData = CreateObject("Object");
			//show me as first entry
			if(player == advCntl.GetLocalPlayer())
			{   
				playersData.SetElementObject(0, CreatePlayerData(player, currentPlayerData, info));
				continue;
			}
			playersData.SetElementObject(playerCount, CreatePlayerData(player, currentPlayerData, info));
			playerCount++;
		}
	}

	data.SetObject("Players", playersData);

	pColor = CreateObject("Object");
	pColor.SetInt("r", advCntl.GetCurrentPlayer().GetColor().R);
	pColor.SetInt("g", advCntl.GetCurrentPlayer().GetColor().G);
	pColor.SetInt("b", advCntl.GetCurrentPlayer().GetColor().B);
	data.SetObject("PlayerColor", pColor);
	data.SetString("HTMLPlayerColor", class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().UnrealColorToHTMLColor(advCntl.GetCurrentPlayer().GetColor()));


	player = advCntl.GetCurrentPlayer();
	if( denOfThieves != none )
	{
		;
		data.SetInt("TotalSpies", denOfThieves.GetInstantSpyMission());
		data.SetInt("AvailableSpies", denOfThieves.GetInstantSpyMissionRemaining());
	}
	else
	{
		data.SetInt("TotalSpies", player.GetThievesGuildManager().GetTotalSpiesCount());
		data.SetInt("AvailableSpies", player.GetThievesGuildManager().GetTotalSpiesCount() - player.GetThievesGuildManager().GetBusySpiesCount());
	}
	data.SetInt("GoldAvailable", player.GetResourceSet().GetResource(player.GetResourceSet().GetResourceByResourceTypeIdentifier("Gold")));


	data.SetInt("AvailableCurrency", advCntl.GetCurrentPlayer().GetResourceSet().GetCurrency());
	data.SetInt("Cost", advCntl.GetConfig().mCostPerInformation);
	data.SetString("CurrencyName", advCntl.GetCurrentPlayer().GetResourceSet().GetCurrencyResourceType().GetName());
	data.SetString("CurrencyIconPath", advCntl.GetCurrentPlayer().GetResourceSet().GetCurrencyResourceType().GetIconPath());
	data.SetBool("FromDenOfThievesAfterUse", fromDenOfThievesAfterUse);

	data.SetString("CurrencyIconPath", player.GetResourceSet().GetCurrencyResourceType().GetIconPath());

	 advCntl.GetCurrentPlayer().GetThievesGuildManager().SetStateOfNewInfoToUnlocked();

	//dungeon
	SetObject("mDungeonInfo", GetSpecialDungeonInfo(player));
	

	SetObject("mData", data);

	ActionScriptVoid("Update");
}

function GFxObject CreatePlayerData(H7Player player , GFxObject obj, H7PlayerSpyInfo info)
{
	local GFxObject commonIncome, commonIncomeRes, rareIncome, rareIncomeRes, pColor, bestHero, newInfo;
	local int rareIncomeCount, totalRareIncome, newInfoCount;
	local H7ResourceSet set;
	local Array<ResourceStockpile> resources;
	local ResourceStockpile resource;

	//stupid unreal!
	local Array<H7Town> towns;
	local Array<H7AdventureHero> heroes;

	//General Data
	obj.SetInt("ID", player.GetID());
	obj.SetString("Name", player.GetName());
	obj.SetInt("Team", player.GetTeamNumber());
	obj.SetInt("PlayerNumber", player.GetPlayerNumber());
	obj.SetBool("CanPlunder", player.CanApplyPlunder());
	obj.SetBool("CanSabotage", player.CanApplySabotage());
		
	pColor = CreateObject("Object");
	pColor.SetInt("r", player.GetColor().R);
	pColor.SetInt("g", player.GetColor().G);
	pColor.SetInt("b", player.GetColor().B);
	obj.SetObject("Color", pColor);
	obj.SetString("HTMLPlayerColor", class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().UnrealColorToHTMLColor(player.GetColor()));

	if(player.GetStatus() == PLAYERSTATUS_QUIT)
	{
		obj.SetBool("IsDead", true);
		return obj;
	}
	obj.SetBool("IsDead", false);

	////////////////////// player is not dead ///////////////////

	newInfo = CreateArray();
	newInfoCount = 0;

	if(info.PlayerName == ESIS_new){newInfo.SetElementString(newInfoCount, "Name"); newInfoCount++;}

	towns = player.GetTowns();
	obj.SetInt("Towns", towns.Length);
	if(info.Towns == ESIS_new){newInfo.SetElementString(newInfoCount, "Towns"); newInfoCount++;}

	heroes = player.GetHeroes();
	obj.SetInt("Heroes", heroes.Length);
	if(info.Heroes == ESIS_new){newInfo.SetElementString(newInfoCount, "Heroes"); newInfoCount++;}

	bestHero = CreateObject("Object");
	if((info.BestHero == ESIS_new || info.BestHero == ESIS_unlocked) && player.GetBestHero() != none )
	{	player.GetBestHero().GUIWriteInto(bestHero);
		obj.SetObject("BestHero", bestHero );}
	else if(info.BestHero == ESIS_new || info.BestHero == ESIS_unlocked)
		obj.SetObject("BestHero", bestHero); // if player has no hero but the info is revealed -> send empty object
	else if(info.BestHero == ESIS_spying)
		obj.SetInt("BestHero", -1);
	if(info.BestHero == ESIS_new){ newInfo.SetElementString(newInfoCount, "BestHero");newInfoCount++;}

	set = player.GetResourceSet();
	commonIncome = CreateArray();
	rareIncome = CreateArray();
	rareIncomeCount = 0;
	totalRareIncome = 0;

	//Resources detailed
	;
	if(info.CommonResourceIncome == ESIS_new || info.CommonResourceIncome == ESIS_unlocked)
	{
		commonIncomeRes = CreateObject("Object");
		commonIncomeRes.SetInt("Income", set.GetIncome(set.GetResourceByResourceTypeIdentifier("Wood")));
		commonIncomeRes.SetString("Icon", set.GetResourceByResourceTypeIdentifier("Wood").GetIconPath());
		commonIncomeRes.SetString("Name", set.GetResourceByResourceTypeIdentifier("Wood").GetName());
		commonIncome.SetElementObject(0, commonIncomeRes);

		commonIncomeRes = CreateObject("Object");
		commonIncomeRes.SetInt("Income", set.GetIncome(set.GetResourceByResourceTypeIdentifier("Ore")));
		commonIncomeRes.SetString("Icon", set.GetResourceByResourceTypeIdentifier("Ore").GetIconPath());
		commonIncomeRes.SetString("Name", set.GetResourceByResourceTypeIdentifier("Ore").GetName());
		commonIncome.SetElementObject(1, commonIncomeRes);

		obj.SetObject("CommonIncomeDetailed", commonIncome);
	}

	//iterate over all resources
	//if the resource is not the currency, neither wood, nor ore then its considere rare #CODERSWAG
	;
	if(info.RareResourceIncome == ESIS_new || info.RareResourceIncome == ESIS_unlocked)
	{
		resources = set.GetAllResourcesAsArray();
		foreach resources(resource)
		{
			if(resource.Type == set.GetCurrencyResourceType())continue;
			if(resource.Type.GetTypeIdentifier() == "Wood" || resource.Type.GetTypeIdentifier() == "Ore")continue;
		
			rareIncomeRes = CreateObject("Object");
			rareIncomeRes.SetString("Name", resource.Type.GetName());
			rareIncomeRes.SetInt("Income", set.GetIncome(resource.Type));
			rareIncomeRes.SetString("Icon", resource.Type.GetIconPath());
			rareIncome.SetElementObject(rareIncomeCount, rareIncomeRes);
			rareIncomeCount++;
			totalRareIncome += set.GetIncome(resource.Type);
		}
		obj.SetObject("RareIncomeDetailed", rareIncome);
	}

	if(info.Gold == ESIS_new || info.Gold == ESIS_unlocked) 
		obj.SetInt("Gold", set.GetIncome(set.GetCurrencyResourceType()));
	else if(info.Gold == ESIS_spying)
		obj.SetInt("Gold", -1);
	if(info.Gold == ESIS_new){ newInfo.SetElementString(newInfoCount, "Gold");newInfoCount++;}

	if(info.CommonResourceIncome  == ESIS_new || info.CommonResourceIncome == ESIS_unlocked) 
		obj.SetInt("Common", set.GetIncome(set.GetResourceByResourceTypeIdentifier("Wood")) + set.GetIncome(set.GetResourceByResourceTypeIdentifier("Ore")));
	else if(info.CommonResourceIncome == ESIS_spying)
		obj.SetInt("Common", -1);
	if(info.CommonResourceIncome == ESIS_new){ newInfo.SetElementString(newInfoCount, "Common");newInfoCount++;}

	if(info.RareResourceIncome  == ESIS_new || info.RareResourceIncome == ESIS_unlocked) 
		obj.SetInt("Rare", totalRareIncome);
	else if(info.RareResourceIncome == ESIS_spying)
		obj.SetInt("Rare", -1);
	if(info.RareResourceIncome == ESIS_new){ newInfo.SetElementString(newInfoCount, "Rare");newInfoCount++;}

	if(info.MapDiscovery  == ESIS_new || info.MapDiscovery == ESIS_unlocked) 
		obj.setInt("Map", player.GetExplorationPercentage());
	else if(info.MapDiscovery == ESIS_spying)
		obj.SetInt("Map", -1);
	if(info.MapDiscovery == ESIS_new){ newInfo.SetElementString(newInfoCount, "Map");newInfoCount++;}

	if(info.TearOfAshan  == ESIS_new || info.TearOfAshan == ESIS_unlocked) 
		obj.SetString("Tear", string( player.GetNumOfVisitedObelisks()) @ "/" @ string(Min(class'H7AdventureController'.static.GetInstance().GetAmountOfObelisks(), 8)));
	else if(info.TearOfAshan == ESIS_spying)
		obj.SetInt("Tear", -1);
	if(info.TearOfAshan == ESIS_new){ newInfo.SetElementString(newInfoCount, "Tear");newInfoCount++;}

	obj.SetInt("PlunderCount", info.PlunderCount);
	obj.SetInt("SabotageCount", info.SabotageCount);

	obj.SetObject("NewInfos", newInfo);

	return obj;
}

function UpdateBestHeroWindow(H7AdventureArmy army)
{
	local GFxObject object, skillsObj, skillObj;
	local H7AdventureHero hero;
	local array<H7Skill> skills;
	local H7Skill skill;
	local int skillIndex;
	
	hero = army.GetHero();
	object = CreateObject("Object");

	hero.GUIWriteInto(object,LF_HERO_WINDOW);
	
	object.SetString("BGTexturePath", hero.GetFactionBGHeroWindow());

	hero.GUIAddListener(self);
	//hero.AddBuffsToDataObject(object, self);
	hero.AddItemBoniToDataObject(object, self);

	
	object.SetString("BGTexturePath", hero.GetFactionBGHeroWindow());
	object.SetString("HeroImagePath", hero.GetFlashImagePath());

	object.SetString("SpecialName", hero.GetSpecialization().GetName());
	object.SetString("SpecialDesc", hero.GetSpecialization().GetTooltipForCaster(hero));
	object.SetString("SpecialIcon", hero.GetSpecialization().GetFlashIconPath());
	object.SetString("SpecialFrame", hero.GetFactionSpecializationFrame());

	object.SetInt("PlayerColorR", hero.GetPlayer().GetColor().R);
	object.SetInt("PlayerColorG", hero.GetPlayer().GetColor().G);
	object.SetInt("PlayerColorB", hero.GetPlayer().GetColor().B);


//////SKILLS
	
	skillsObj = CreateArray();
	skills = hero.GetSkillManager().GetAllSkills();

	;
	for(skillIndex = 0; skillIndex < skills.Length; skillIndex++)
	{
		skill = skills[skillIndex];
		;
		
		
		skillObj = CreateObject("Object");
		skillObj.SetString("Name", skill.GetName());
		skillObj.SetString("Icon", "img://" $ Pathname( skill.GetIcon() ));
		skillObj.SetInt("Points", skill.GetInvestedPointsCount());
		skillsObj.SetElementObject(skillIndex, skillObj);
	}

	object.SetObject("Skills", skillsObj);
	SetObject( "mBestHeroData" , object);
	
	ActionScriptVoid("UpdateBestHeroWindow");
}

function CloseHeroInfo()
{
	ActionScriptVoid("CloseHeroInfo");
}

function GFxObject GetSpecialDungeonInfo(H7player player)
{
	local H7Town town;
	local array<H7Town> towns;
	local H7TownBuildingData spiesGuild, hallOfIntrigue;
	local string spiesGuildName, hallOfIntrigueName;

	local GFxObject dungeonInfo;

	local bool isDungeon;
	local int  spiesGuildCount;
	local int  hallOfIntrigueCount;

	spiesGuildCount = 0;

	towns = player.GetTowns();

	foreach towns(town)
	{   
		spiesGuild = town.GetBuildingTemplateByType(class'H7TownSpiesGuild');
		if(spiesGuild.Building != none)
		{
			isDungeon = true;
			spiesGuildName = spiesGuild.Building.GetName();
			if(spiesGuild.IsBuilt) spiesGuildCount++;
		}
		hallOfIntrigue = town.GetBuildingTemplateByType(class'H7TownHallOfIntrigue');
		if(hallOfIntrigue.Building != none)
		{
			isDungeon = true;
            hallOfIntrigueName = hallOfIntrigue.Building.GetName();
			if(hallOfIntrigue.IsBuilt) hallOfIntrigueCount++;
		}
	}

	dungeonInfo = CreateObject("Object");

	dungeonInfo.SetBool("IsDungeon", isDungeon);
	dungeonInfo.SetInt("SpiesGuildCount", spiesGuildCount);
	dungeonInfo.SetInt("HallOfIntriguesCount", hallOfIntrigueCount);
	dungeonInfo.SetString("SpiesGuildName", spiesGuildName);
	dungeonInfo.SetString("HallOfIntrigueName", hallOfIntrigueName);
	dungeonInfo.SetInt("RunningPlundersCount", player.GetThievesGuildManager().GetRunningPlundersCount());
	dungeonInfo.SetInt("RunningSabotageCount", player.GetThievesGuildManager().GetRunningSabotageCount());
	dungeonInfo.SetInt("PlunderCost", class'H7AdventureController'.static.GetInstance().GetConfig().mPlunderCost);
	dungeonInfo.SetInt("SabotageCost", class'H7AdventureController'.static.GetInstance().GetConfig().mSabotageCost);

	return dungeonInfo;
}

function UpdateDungeonInfo()
{
	local H7Player player;

	player = class'H7AdventureController'.static.GetInstance().GetCurrentPlayer();
	SetObject("mDungeonInfo", GetSpecialDungeonInfo(player));
	ActionScriptVoid("CheckDungeonInfo");
}

function UpdatePlayerMoney(int money)
{
	SetInt("mMoney", money);
}
