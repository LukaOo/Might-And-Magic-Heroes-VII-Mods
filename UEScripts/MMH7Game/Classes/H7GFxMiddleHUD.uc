//=============================================================================
// H7GFxMiddleHUD
//
// Wrapper for H7TownHud.as
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxMiddleHUD extends H7GFxUIContainer;

var String mTownPopupBlockReason;

var H7Faction mFactionAcademy;
var H7Faction mFactionAcademy2;
var H7Faction mFactionDungeon;
var H7Faction mFactionNecro;

function SetDataFromTown(H7Town town, optional bool isUpdate = true)
{
	local GFxObject data, upgradeData;

	if(town == none)
	{
		;
		scripttrace();
		return;
	}

	data = CreateObject("Object");
	upgradeData = CreateObject("Object");

	data.SetObject("garrisonArmy",CreateArmyObject(town.GetGarrisonArmy()));
	data.SetObject("caravanArmy",CreateCaravanObject(town.GetCaravanArmy())); 
	data.SetObject("visitArmy",CreateArmyObject(town.GetVisitingArmy()));
	data.SetObject("governor",CreateHeroObject(town.GetGovernor()));
	data.SetObject("townGuard",CreateArmyObjectFromPool(town));
	data.SetBool("isUpdate", isUpdate);

	if(town.GetVisitingArmy() != none && town.GetVisitingArmy().GetPlayer() == town.GetPlayer() &&
	   class'H7AreaOfControlSiteLord'.static.GetUniqueStackTypeCount(town.GetVisitingArmy(), town.GetGarrisonArmy()) <= 7)
	{
		data.SetBool("CanMergeArmies", true);
	}
	else
		data.SetBool("CanMergeArmies", false);

	/*`log_gui("visiting army"@town.GetVisitingArmy());
	`log_gui("player"@town.GetVisitingArmy().GetPlayer() == town.GetPlayer());
	`log_gui("unique units"@class'H7AreaOfControlSiteLord'.static.GetUniqueStackTypeCount(town.GetVisitingArmy(), town.GetGarrisonArmy()));
	`log_gui("CAN_MERGE_ARMIES is actually:" @ town.GetVisitingArmy() != none && town.GetVisitingArmy().GetPlayer() == town.GetPlayer() &&
	   class'H7AreaOfControlSiteLord'.static.GetUniqueStackTypeCount(town.GetVisitingArmy(), town.GetGarrisonArmy()) <= 7);
    */
	data.SetObject("Color", CreateColorObject(town.GetPlayer().GetColor()));

	createUpgradeObject(town, town.GetGarrisonArmy(),ARMY_NUMBER_GARRISON, upgradeData);
	createUpgradeObject(town, town.GetVisitingArmy(),ARMY_NUMBER_VISIT, upgradeData);
	createUpgradeObject(town, town.GetCaravanArmy(),ARMY_NUMBER_CARAVAN, upgradeData);
	
	SetObject("mData",data);
	SetObject("mUpgradeData", upgradeData);
	InitTownMiddleHUD();

	BuildGovernorTooltip(town.GetGovernor());

	SetupQuickBar(town);
}

function SetDataFromDwelling(H7Dwelling dwelling)
{
	local GFxObject data, upgradeData;

	data = CreateObject("Object");
	upgradeData = CreateObject("Object");
	
	;
	data.SetObject("visitArmy",CreateArmyObject(dwelling.GetVisitingArmy()));
	createUpgradeObject(dwelling, dwelling.GetVisitingArmy(),ARMY_NUMBER_VISIT, upgradeData );
	
	data.SetBool("DwellingMode", true);
	data.SetString("DwellingName", dwelling.GetName());

	data.SetObject("Color", CreateColorObject(dwelling.GetPlayer().GetColor()));

	SetObject("mData",data);
	SetObject("mUpgradeData", upgradeData);
	InitTownMiddleHUD();

	SetupQuickBar(dwelling);
}

function SetDataFromFort(H7Fort fort)
{
	local GFxObject data, upgradeData;
	data = CreateObject("Object");
	upgradeData = CreateObject("Object");

	data.SetObject("garrisonArmy",CreateArmyObject(fort.GetGarrisonArmy()));
	data.SetObject("visitArmy",CreateArmyObject(fort.GetVisitingArmy()));
	data.SetObject("townGuard",CreateArmyObjectFromPool(fort));
	
	if(fort.GetVisitingArmy() != none && fort.GetVisitingArmy().GetPlayer() == fort.GetPlayer() &&
	   class'H7AreaOfControlSiteLord'.static.GetUniqueStackTypeCount(fort.GetVisitingArmy(), fort.GetGarrisonArmy()) <= 7)
	{
		data.SetBool("CanMergeArmies", true);
	}
	else
		data.SetBool("CanMergeArmies", false);

	// Upgrade Units vom fort screen?
	
	data.SetObject("Color", CreateColorObject(fort.GetPlayer().GetColor()));

	data.SetBool("FortMode", true);
	data.SetString("FortName", fort.GetName());

	SetObject("mData",data);
	SetObject("mUpgradeData", upgradeData);
	InitTownMiddleHUD();

	// Do Forts have Governors?

	SetupQuickBar(fort);
}


function SetDataFromGarrison(H7Garrison garrison)
{
	local GFxObject data, upgradeData;
	data = CreateObject("Object");
	
	data.SetObject("garrisonArmy",CreateArmyObject(garrison.GetGarrisonArmy()));
	data.SetObject("visitArmy",CreateArmyObject(garrison.GetVisitingArmy()));
	data.SetObject("townGuard",CreateArmyObjectFromPool(garrison));
	
	data.SetObject("Color", CreateColorObject(garrison.GetPlayer().GetColor()));

	data.SetBool("GarrisonMode", true);
	data.SetString("FortName", garrison.GetName());

	SetObject("mData",data);
	
	// empty = no upgrades
	upgradeData = CreateObject("Object");
	SetObject("mUpgradeData", upgradeData);
	
	InitTownMiddleHUD();
	
	SetupQuickBar(garrison);
}

function UpdateCaravanButton()
{
	ActionScriptVoid("UpdateCaravanButton");
}
/**
 * If you set one parameter, you also have to set the other
 * If called without any parameters all slots will be set to be not in use
 */
function SetDraggedSlotInUse(optional int slotIndex = -1, optional int armyNr = -1)
{
	local GFxObject data;
	data = CreateObject("Object");

	if(slotIndex != -1)
	{
		data.SetInt("SlotIndex", slotIndex);
		data.SetInt("ArmyNumber", armyNr);
	}
	SetObject("mSlotUseData", data);

	ActionScriptVoid("SetSlotInUse");
}

function bool CanPopup(ETownPopup popup,H7AreaOfControlSite site)
{
	local array<H7TownBuildingData> buildBuildings;
	local H7TownBuildingData buildBuilding;
	local array<RecruitHeroData> recruitDatas;
	
	// exceptions
	if(popup==POPUP_RECRUIT)
	{
		//as of 30.07.15 the recruitButton is ALWAYS enabled
		return true;
		//if(town.HasOutSideDwellingsBelongingToOwner()) return true;
	}
	if(popup==POPUP_CARAVAN)
	{
		//return true; // for testing
		if( H7AreaOfControlSiteLord( site ) != none && H7AreaOfControlSiteLord( site ).HasWaitingCaravans()) return true;
		else
		{
			mTownPopupBlockReason = "TT_TOWNBAR_NO_CARAVANS";
			return false;
		}
	}

	// buildings
	if(site.IsA('H7Town'))
	{
		buildBuildings = H7Town(site).GetBuildings();
		foreach buildBuildings(buildBuilding)
		{
			if(buildBuilding.Building.GetPopup() == popup)
			{
				// exception
				if(popup==POPUP_HALLOFHEROS)
				{
					recruitDatas = class'H7AdventureController'.static.GetInstance().GetHallOfHeroesManager().GetHeroesPool( class'H7AdventureController'.static.GetInstance().GetLocalPlayer(), H7Town(site) );
					if(recruitDatas.Length == 0) 
					{
						mTownPopupBlockReason = "TT_TOWNBAR_NO_HEROES";
						return false;
					}
				}
				return true;
			}
		}
		mTownPopupBlockReason = "TT_TOWNBAR_NOT_BUILT";
	}
	
	return false;
}

// dw fo ga to cop
function SetupQuickBar(H7AreaOfControlSite site)
{
	local GFxObject quickbar,slot;
	local H7Town town;
	local int i;

	if(site.IsA('H7Town') || site.IsA('H7Fort'))
	{
		town = H7Town(site);
		quickbar = CreateArray();

		for(i=1;i<POPUP_MAX;i++)
		{
			slot = CreateObject("Object");
			slot.SetBool("Invisible",site.IsA('H7Fort'));
			switch(i) // OPTIONAL moddable
			{
				case POPUP_BUILD:
					slot.SetString("Desc", class'H7Loca'.static.LocalizeSave("MIDHUD_BUILD","H7Town") );
					slot.SetString("Icon","img://" $ PathName( Texture2D'H7ButtonIcons.ICO_townHall' ));
					slot.SetString("Command","OpenMainBuilding");
				break;
				case POPUP_RECRUIT:
					slot.SetString("Desc", class'H7Loca'.static.LocalizeSave("MIDHUD_RECRUIT","H7Town") );
					slot.SetString("Icon","img://" $ PathName( Texture2D'H7ButtonIcons.ICO_recruitment' ));
					slot.SetString("Command","OpenRecruitmentWindow");
					slot.SetBool("Invisible", false );
				break;
				case POPUP_MARKETPLACE:
					slot.setString("Desc", class'H7Loca'.static.LocalizeSave("MIDHUD_MARKETPLACE","H7Town") );
					slot.SetString("Icon", "img://" $ PathName(Texture2D'H7ButtonIcons.ICO_marketplace'));
					slot.SetString("Command","OpenMarketPlace");
				break;
				case POPUP_HALLOFHEROS:
					slot.setString("Desc", class'H7Loca'.static.LocalizeSave("MIDHUD_HALLOFHEROES","H7Town") );
					slot.SetString("Icon", "img://" $ PathName(Texture2D'H7ButtonIcons.ICO_hallOfHeroes'));
					slot.SetString("Command","OpenHallOfHeroes");
				break;
				case POPUP_MAGICGUILD:
					slot.setString("Desc",  class'H7Loca'.static.LocalizeSave("MIDHUD_MAGICGUILD","H7Town") );
					slot.SetString("Icon", "img://" $ PathName(Texture2D'H7ButtonIcons.ICO_MagicGuild'));
					slot.SetString("Command","OpenMagicGuild");
				break;
				case POPUP_TOWNGUARD:
					slot.setString("Desc",  class'H7Loca'.static.LocalizeSave("MIDHUD_TOWNGUARD","H7Town") );
					slot.SetString("Icon", "img://" $ PathName(Texture2D'H7ButtonIcons.ICO_townDefense'));
					slot.SetString("Command","OpenTownDefense");
				break;
				case POPUP_WARFARE:
					slot.setString("Desc",  class'H7Loca'.static.LocalizeSave("MIDHUD_WARFARE","H7Town") );
					slot.SetString("Icon", "img://" $ PathName(Texture2D'H7ButtonIcons.ICO_warUnit'));
					slot.SetString("Command","OpenWarfare");
				break;
				case POPUP_THIEVES:
					slot.setString("Desc",  class'H7Loca'.static.LocalizeSave("MIDHUD_THIEVES","H7Town") );
					slot.SetString("Icon", "img://" $ PathName(Texture2D'H7ButtonIcons.ICO_thievesGuild'));
					slot.SetString("Command","OpenGuildOfThieves");
				break;
				case POPUP_CARAVAN:
					slot.setString("Desc",  class'H7Loca'.static.LocalizeSave("MIDHUD_CARAVAN","H7Town") );
					slot.SetString("Icon", "img://" $ PathName(Texture2D'H7ButtonIcons.ICO_caravan'));
					slot.SetString("Command","OpenCaravan");
					slot.SetBool("Invisible", false );
				break;
				case POPUP_CUSTOM1:
					if(town != none)
					{
						if(town.GetFaction() == mFactionAcademy || town.GetFaction() == mFactionAcademy2)
						{
							slot.setString("Desc",  class'H7Loca'.static.LocalizeSave("MIDHUD_ACADEMY_CUSTOM_1","H7Town") );
							slot.SetString("Icon", "img://" $ PathName(Texture2D'H7ButtonIcons.ICO_artifact_reycler'));
						}
						else if(town.GetFaction() == mFactionNecro)
						{
							slot.setString("Desc",  class'H7Loca'.static.LocalizeSave("MIDHUD_NECRO_CUSTOM_1","H7Town") );
							slot.SetString("Icon", "img://" $ PathName(Texture2D'H7ButtonIcons.ICO_altar_of_sacrifice'));
						}
						else if(town.GetFaction() == mFactionDungeon)
						{
							slot.setString("Desc",  class'H7Loca'.static.LocalizeSave("MIDHUD_DUNGEON_CUSTOM_1","H7Town") );
							slot.SetString("Icon", "img://" $ PathName(Texture2D'H7ButtonIcons.ICO_black_market'));
						}
						else
						{
							slot.SetBool("Invisible", true );
						}
					}
					else
					{
						slot.SetBool("Invisible", true );
					}
					slot.SetString("Command","OpenCustom1"); 
				break;
				case POPUP_CUSTOM2:
					if(town != none && town.GetFaction() == mFactionAcademy || town.GetFaction() == mFactionAcademy2)
					{
						slot.setString("Desc",  class'H7Loca'.static.LocalizeSave("MIDHUD_ACADEMY_CUSTOM_2","H7Town") );
						slot.SetString("Icon", "img://" $ PathName(Texture2D'H7ButtonIcons.ICO_inscriber'));
					}
					else
					{
						slot.SetBool("Invisible", true );
					}
					slot.SetString("Command","OpenCustom2");
				break;
				default:
					;
			}

			slot.SetInt("Popup", i );
			slot.SetBool("Active", CanPopup(ETownPopup(i),H7AreaOfControlSiteLord(site)) );
			slot.SetString("BlockReason", mTownPopupBlockReason );
		
			quickbar.SetElementObject(i-1,slot);
		}

		if(CanPopup(POPUP_THIEVES, H7AreaOfControlSiteLord(site)))
		{
			if(town.GetPlayer().GetThievesGuildManager().ThievesGuildHasNewInfo())
				StartQuickSlotGlow(POPUP_THIEVES, class'H7Loca'.static.LocalizeSave("NEW_INFO","H7Town"));
		}
	}

	SetObject("mQuickbarData",quickbar);
	UpdateQuickBar();
}

private function UpdateQuickBar()
{
	ActionScriptVoid("UpdateQuickBar");
}

public function RecruitSlotGlow(int slotIndex, int armyNumber)
{
	ActionScriptVoid("RecruitSlotGlow");
}

public function RecruitAllSlotGlow(array<int> recruitmentSlotIndixes, array<EArmyNumber> reenforcedArmies )
{
	ActionScriptVoid("RecruitAllSlotGlow");
}

/**
 * Initilizes a pulsing glow on a quickbar button
 * 
 * @param popup the enum of the popup associated with the button
 * 
 * */
public function StartQuickSlotGlow(int popup, optional String message)
{
	local GFxObject glowData;

	glowData = CreateObject("Object");
	glowData.SetInt("Popup", popup);
	glowData.SetString("Message", message);
	SetObject("mBtnGlowData", glowData);
	ActionScriptVoid("StartQuickSlotGlow");
}

public function StopQuickSlotGlow()
{
	ActionScriptVoid("StopQuickSlotGlow");
}

function UpdateUpgradeButtons(H7AreaOfControlSite site)
{
	local GFxObject upgradeData;
	upgradeData = CreateObject("Object");

	createUpgradeObject(site, site.GetGarrisonArmy(),ARMY_NUMBER_GARRISON, upgradeData);
	createUpgradeObject(site, site.GetVisitingArmy(),ARMY_NUMBER_VISIT, upgradeData);
	if(site.isA('H7Town')) createUpgradeObject(site, H7Town(site).GetCaravanArmy(),ARMY_NUMBER_CARAVAN, upgradeData);

	SetObject("mUpgradeData", upgradeData);

	ActionScriptVoid("UpdateUpgradeButtons");
}

// flash has internally saved source and target, except when target was unknown, in this case, it has to be send as param 2 and 3
function TransferResult(bool success,optional int army,optional int i)
{
	;
	ActionScriptVoid("TransferResult");
}

function StackDismissed()
{
	ActionscriptVoid("StackDismissed");
}

function HighlightTargetBar(optional bool val)
{
	ActionscriptVoid("HighlightTargetBar");
}

function HighlightButton(int popupID,optional bool val)
{
	ActionscriptVoid("HighlightButton");
}

function DragFromOutside(H7BaseCreatureStack stack,int caravanIndex,int unitIndex) // TODO refactor to take heros and units
{
	local GFxObject unitData;
	local int caravanFakeIndex;
	
	unitData = CreateCreatureStackObject(stack);
	
	caravanFakeIndex = caravanIndex + ARMY_NUMBER_CARAVAN + 1;
	
	unitData.SetInt("CaravanIndex",caravanFakeIndex);
	unitData.SetInt("UnitIndex",unitIndex);
	
	GetObject("mArmyControlPanel").SetObject("mOutsideData",unitData);
	GetObject("mArmyControlPanel").ActionscriptVoid("DragFromOutside");
}

function BuildGovernorTooltip(H7AdventureHero governor)
{
	local GFxObject list,entry;
	local array<H7BaseAbility> govAbilities;
	local int i;

	if(governor == none)
	{
		;
		SetObject("mGovernorTooltipData",none);
	}
	else
	{
		;
		
		list = CreateArray();

		govAbilities = governor.GetGovernorAbilities();
		for( i = 0; i < govAbilities.Length; ++i )
		{
			entry = CreateObject("Object");
			entry.SetString("icon", govAbilities[i].GetFlashIconPath());
			entry.SetString("name", govAbilities[i].GetName());
			entry.SetString("desc", govAbilities[i].GetTooltip());
			list.SetElementObject(i, entry);
		}

		SetObject("mGovernorTooltipData",list);
	}

	UpdateGovernorTooltip();

}

function createUpgradeObject(H7AreaOfControlSite site, H7AdventureArmy army, EArmyNumber number, out GFxObject upgradeData)
{
	local GFxObject upgradeList, singleUpgrade, quantitiyData, costs;
	local H7BaseCreatureStack stack;
	local array<H7BaseCreatureStack> stacks;
	local int i, k, l, creatureIndex, upgradeAbleCreatureCount;
 	local array<H7ResourceQuantity> upgradeCost, singleUpgCost;
	local H7ResourceQuantity quantity;
	local bool noUpgradedStackAndUnableToUpgradeAllCreatures;
 	local H7ResourceSet set;

	if(army == none) return;
	
	// Set resources
	set = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetResourceSet();

	i = 0;
	upgradeList = CreateArray();

	stacks = army.GetBaseCreatureStacks();

	for(creatureIndex = 0; creatureIndex<stacks.Length;creatureIndex++) 
	{
		stack = stacks[creatureIndex];
		noUpgradedStackAndUnableToUpgradeAllCreatures = true;
		singleUpgrade = CreateObject("Object");

		singleUpgCost.Length = 0;
		upgradeCost = site.GetUpgradeInfo(false, upgradeAbleCreatureCount, stack, -1, singleUpgCost);

		if(upgradeCost.Length == 0)
		{
			upgradeList.SetElementObject(i, none);
			i++;
			continue;
		}
		else if(upgradeAbleCreatureCount == 0 && singleUpgCost.Length != 0)
		{
			upgradeCost = singleUpgCost;
			upgradeAbleCreatureCount = 1;
		}

		k = 0;
		singleUpgrade.SetString("Name", stack.GetStackType().GetName());
		singleUpgrade.SetInt("Count", upgradeAbleCreatureCount);

		// if the army has no free slot and we can NOT upgrade all creatures of the current stack
		if(!army.CheckFreeArmySlot() && upgradeAbleCreatureCount<stack.GetStackSize())
		{
			// we are looking for another stack of the upgraded type
			for(l=0; l<stacks.Length; l++)
			{
				if(stack.GetStackType().GetUpgradedCreature() == stacks[l].GetStackType()){ noUpgradedStackAndUnableToUpgradeAllCreatures = false; break;} 
			}
		
		    singleUpgrade.SetBool("NoUpgradedStackAndUnableToUpgradeAllCreatures", noUpgradedStackAndUnableToUpgradeAllCreatures);
			if(noUpgradedStackAndUnableToUpgradeAllCreatures)
			{
				// the army has no free slot and doesnt contain a stack of the upgraded creature and we cant
				// upgrade all creatures at once
				upgradeList.SetElementObject(i, singleUpgrade);
				i++;
				continue;
			}
		}

		// resource Cost
		costs = CreateArray();
		k = 0;
		foreach upgradeCost(quantity)
		{
			quantitiyData = CreateObject("Object");
			quantitiyData.SetString("Name", quantity.Type.GetName());
			quantitiyData.SetString("Icon", quantity.Type.GetIconPath());
			quantitiyData.SetInt("Amount", quantity.Quantity);
			quantitiyData.SetBool("TooMuch", set.GetResource(quantity.Type) < quantity.Quantity ? True : false);

			costs.SetElementObject(k, quantitiyData);
			k++;
		}
		singleUpgrade.SetObject("Costs", costs);
		
		upgradeList.SetElementObject(i, singleUpgrade);
		i++;
	}
	
	switch(number)
	{
		case ARMY_NUMBER_GARRISON:
			upgradeData.SetObject("GarrisonArmyUpgradeData", upgradeList);
		break;
		case ARMY_NUMBER_VISIT:
			upgradeData.SetObject("VisitingArmyUpgradeData", upgradeList);
		break;	
		case ARMY_NUMBER_CARAVAN:
			upgradeData.SetObject("CaravanArmyUpgradeData", upgradeList);
		break;
		
	}
}
// ---------- private helper functions -----------------

private function InitTownMiddleHUD()
{
	ActionScriptVoid("InitHUD");
}


private function UpdateGovernorTooltip()
{
	ActionScriptVoid("UpdateGovernorTooltip");
}

// switches the army rows
public function SetCaravanMode(optional bool val=true, optional bool playTween=true)
{
	GetObject("mArmyControlPanel").ActionScriptVoid("SetCaravanMode");
}

// greys out the gui or enables it
public function EnableCaravan(optional bool val=true)
{
	;
	GetObject("mArmyControlPanel").ActionScriptVoid("EnableCaravan");
}

