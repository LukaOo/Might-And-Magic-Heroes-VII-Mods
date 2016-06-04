//=============================================================================
// H7GameData
//
// Contains all global infos about the game 
// - linked to by H7TransitionData
// - OPTIONAL separate GameDataDuringMapPlay from GameDataInMainMenu?
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GameData extends Object
	hidecategories(Object)
	native;

// Do not access the fields directly. Use the getters instead to ensure proper filtering/privileg checks.
var() private array<H7CampaignDefinition> mCampaigns<DisplayName="Campaigns">;
var() private array<H7Faction> mFactions<DisplayName="Factions">;
var() private H7Faction mNeutralFaction<DisplayName="Neutral Faction">;
var() private string mHubMapName<DisplayName="Hub Map Name">; // OPTIONAL move to campaign for maximum moddability
var() private H7ArtifactCollection mArtifactPool[ETier.ITIER_MAX]<DisplayName="Artifact Pool">;
var() private array<H7FactionCreatureData> mCreatureLists<DisplayName="Creature Lists">;
var() private array<H7EditorHero> mHeroPool<DisplayName="Hero pool for Hall of Heroes and Start Hero">;
var() private array<H7EditorHero> mExclusiveHeroesSkirmish<DisplayName="Skirmish exclusive Hall of Heroes pool">;
var() private array<H7EditorHero> mHeropediaHeroes<DisplayName="Heropedia Heroes">;
var() private array<H7EditorHero> mPrivilegHeroesSkirmish<DisplayName="Hero pool for Skirmish Privileg Heroes">;
var() private array<H7EditorHero> mPrivilegHeroesDuel<DisplayName="Hero pool for Duel Privileg Heroes">;
var() private array<H7EditorHero> mRandomHeroPool<DisplayName="Hero pool for random Hero selection">;
var() private array <H7HeroAbility> mSpells<DisplayName="Spells">;
var() private H7ResourceSet mResourceSet<DisplayName="Resource Set">;
var() private array<H7GenericTownNames> mGenericTownNames<DisplayName="Generic Town Names">;
var() private array<H7EditorArmy> mDuelArmies<DisplayName="Duel Armies">;
var() private array<H7EditorHero> mDuelHeroes<DisplayName="Duel Heroes">;
var() private H7EditorArmy mRandomDuelArmy<DisplayName="Random Duel Army">;
var() private array<H7GeneralLoreEntry> mGeneralLore<DisplayName="General Lore">;
var() private array<H7EditorWarUnit> mWarUnits<DisplayName="Warfare Units">;
var() private H7Faction mRandomFaction<DisplayName="Random Faction">;
var() private H7EditorHero mRandomHero<DisplayName= "Random Hero">;

var protected transient array<string> mUsedGenericTownNames;

static function H7GameData GetInstance() { return class'H7TransitionData'.static.GetInstance().GetGameData(); }

static native function int GetSourceVersion();
static native function string GetBuildStr();
static native function string GetRevisionStr();

function native GetCampaigns(out array<H7CampaignDefinition> campaigns);
function native GetFactions(out array<H7Faction> factions, optional bool ignorePrivileges);
function native GetArtifacts(out array<H7ArtifactCollection> artifacts);
function native GetCreatureLists(out array<H7FactionCreatureData> creatures);
function native GetHeroes(out array<H7EditorHero> heroes, optional bool ignorePrivileges);
function native GetMapHeroes(out array<H7EditorHero> heroes);
function native GetExclusiveHeroesSkirmish(out array<H7EditorHero> heroes, optional bool ignorePrivileges);
function native GetRandomHeroes(out array<H7EditorHero> randomHeroes, optional bool ignorePrivileges);
function native GetPrivilegHeroesSkirmish(out array<H7EditorHero> privilegHeroes, optional bool ignorePrivileges);
function native GetPrivilegHeroesDuel(out array<H7EditorHero> privilegHeroes, optional bool ignorePrivileges);
function native array<H7HeroAbility> GetSpells();
function native H7Faction GetNeutralFaction();
function native H7ResourceSet GetResourceSet(); // returns mResourceSet
function native GetDuelHeroes(out array<H7EditorHero> heroes, optional bool ignorePrivileges);
function H7EditorArmy GetRandomDuelArmy() { return mRandomDuelArmy; }
function array<H7GeneralLoreEntry> GetGeneralLore() {return mGeneralLore;}
function array<H7EditorWarUnit> GetWarfareUnits() {return mWarUnits;}
function H7Faction GetRandomFaction() { return mRandomFaction; }
function H7EditorHero GetRandomHero() { return mRandomHero; }
function H7Faction GetFaction(int i) { return mFactions[i]; }

function ClearUsedGenericTownNames()
{
	mUsedGenericTownNames.Length = 0;
}

function H7Creature GetCreatureByIDString(string idString)
{
	local int i, j;
	local array<H7FactionCreatureData> lists;
	local H7FactionCreatureData list;


	GetCreatureLists(lists);
	ForEach lists(list)
	{
		for(j = 0; j < E_H7_CL_MAX; j++)
		{
			for(i = 0; i < list.CreatureList.Creatures[j].Creatures.Length; i++)
			{
				if(list.CreatureList.Creatures[j].Creatures[i].GetIDString() == idString)
				{
					return list.CreatureList.Creatures[j].Creatures[i];
				}
			}
		}
	}

	return none;
}

function string GetGenericTownNameByIndex( H7Faction faction, int nameIndex)
{
	local H7GenericTownNames factionTownName;

	// Get town names for the faction
	foreach mGenericTownNames(factionTownName)
	{
		if(factionTownName.GetFaction() == faction)
		{
			break;
		}
	}

	if(factionTownName != none)
	{
		return factionTownName.GetLocalizedTownName(nameIndex); 
	}
	
	return GetGenericTownName(faction, nameIndex);
}

function string GetGenericTownName(H7Faction faction, optional out int nameIndex)
{
	local H7GenericTownNames factionTownName;
	local array<string> factionTownNames;
	local array<string> availableTownNames;
	local string townName;
	local int factionTownIndex;
	local int townIndex;
	
	// Get town names for the faction
	foreach mGenericTownNames(factionTownName)
	{
		if(factionTownName.GetFaction() == faction)
		{
			factionTownNames = factionTownName.GetTownNames();
			break;
		}
	}

	foreach factionTownNames(townName)
	{
		if(mUsedGenericTownNames.Find(townName) < 0)
		{
			availableTownNames.AddItem(townName);
		}
	}

	// We ran out of unused names and have to make them available again
	if(availableTownNames.Length == 0)
	{
		availableTownNames = factionTownNames;

		foreach factionTownNames(townName)
		{
			if(mUsedGenericTownNames.Find(townName) >= 0)
			{
				mUsedGenericTownNames.RemoveItem(townName);
			}
		}
	}

	townIndex = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(availableTownNames.Length);
	mUsedGenericTownNames.AddItem(availableTownNames[townIndex]);
	factionTownIndex = factionTownNames.Find(availableTownNames[townIndex]);

	nameIndex = factionTownIndex;

	return factionTownName.GetLocalizedTownName(factionTownIndex);
}

event bool IsRewardEnabled( H7HeroItem item )
{
	if(class'H7PlayerProfile'.static.GetInstance() != none && class'H7PlayerProfile'.static.GetInstance().GetAchievementManager() != none && class'H7PlayerProfile'.static.GetInstance().GetAchievementManager().CanRewardBeUsed())
	{
		return class'H7PlayerProfile'.static.GetInstance().GetAchievementManager().GetStateReward_AP();
	}

	return false;
}

// only searches in the hall of hero/starthero pool and random heroes
function H7EditorHero GetHeroByArchetypeID(string heroAID) 
{
	local int i;
	local array<H7EditorHero> filteredHeroes, randomHeroes, duelHeroes, privilegeHeroes, exclusiveSkirmishHeroes;

	GetHeroes(filteredHeroes, true);
	GetRandomHeroes(randomHeroes, true);
	for(i = 0; i < filteredHeroes.Length; i++)
	{
		if(filteredHeroes[i].GetArchetypeID() == heroAID)
		{
			return filteredHeroes[i];
		}
	}

	GetRandomHeroes(randomHeroes, true);
	for(i = 0; i < randomHeroes.Length; i++)
	{
		if(randomHeroes[i].GetArchetypeID() == heroAID)
		{
			return randomHeroes[i];
		}
	}

	if(heroAID == mRandomHero.GetArchetypeID())
		return mRandomHero;

	GetDuelHeroes(duelHeroes, true);
	for(i = 0; i < duelHeroes.Length; i++)
	{
		if(duelHeroes[i].GetArchetypeID() == heroAID)
		{
			return duelHeroes[i];
		}
	}

	GetPrivilegHeroesDuel( privilegeHeroes, true );
	for(i = 0; i < privilegeHeroes.Length; i++)
	{
		if(privilegeHeroes[i].GetArchetypeID() == heroAID)
		{
			return privilegeHeroes[i];
		}
	}

	GetPrivilegHeroesSkirmish( privilegeHeroes, true );
	for(i = 0; i < privilegeHeroes.Length; i++)
	{
		if(privilegeHeroes[i].GetArchetypeID() == heroAID)
		{
			return privilegeHeroes[i];
		}
	}

	GetExclusiveHeroesSkirmish( exclusiveSkirmishHeroes, true );
	for(i = 0; i < exclusiveSkirmishHeroes.Length; i++)
	{
		if(exclusiveSkirmishHeroes[i].GetArchetypeID() == heroAID)
		{
			return exclusiveSkirmishHeroes[i];
		}
	}

	class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("Hero not found:"@heroAID,MD_QA_LOG);;
	return none;
}

native function array <H7HeroItem> GetItemList(ETier ItemTier, bool ForbiddedItems);

function GetHeropediaHeroes(out array<H7EditorHero> heroes)
{
	local int i;
	for(i = 0; i < mHeropediaHeroes.Length; i++)
	{
		heroes.AddItem(mHeropediaHeroes[i]);
	}
}

function H7Faction GetFactionByArchetypeID(string factionAID)
{
	local int i;
	local array<H7Faction> factions;
	if( GetRandomFaction().GetArchetypeID() == factionAID )
	{
		return GetRandomFaction();
	}
	GetFactions(factions, true);
	for(i = 0; i < factions.Length; i++)
	{
		if(factions[i].GetArchetypeID() == factionAID)
		{
			return factions[i];
		}
	}

	class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("Faction not found:"@factionAID,MD_QA_LOG);;
	return none;
}
function string GetHubMapName() { return mHubMapName; }

function H7CampaignDefinition GetCampaignByID(string campaignID,optional bool ignoreFilter=false)
{
	local H7CampaignDefinition campaign;
	local array<H7CampaignDefinition> campaigns;

	if(ignoreFilter)
	{
		campaigns = mCampaigns;
	}
	else
	{
		GetCampaigns(campaigns);
	}
	foreach campaigns(campaign)
	{
		if(string(campaign) == campaignID)
		{
			return campaign;
		}
	}
	;
	return none;
}

function H7CampaignDefinition GetCampaignByCouncilor(H7EditorHero councilor)
{
	local H7CampaignDefinition campaign;
	local array<H7CampaignDefinition> campaigns;
	GetCampaigns(campaigns);
	foreach campaigns(campaign)
	{
		if(campaign.GetCouncillor() == councilor)
		{
			return campaign;
		}
	}
	;
	return none;
}

function H7CampaignDefinition GetCampaignOfMap(string mapFileName)
{
	local H7CampaignDefinition campaign;
	local array<H7CampaignDefinition> campaigns;
	local string map;
	local array<string> maps;

	GetCampaigns(campaigns);
	foreach campaigns(campaign)
	{
		maps = campaign.GetMaps();
		foreach maps(map)
		{
			if(Caps(map) == Caps(mapFileName))
			{
				return campaign;
			}
		}
	}
	;
	return none;
}

function H7EditorArmy GetDuelArmy(int i,H7Faction faction)
{
	local array <H7EditorArmy> armyForFaction;

	armyForFaction = GetDuelArmies(faction);

	if(i>=0 && i < armyForFaction.Length)
	{
		return armyForFaction[i];
	}
	else
	{
		return none;
	}
}

function int GetDuelArmyIndex(H7EditorArmy army,H7Faction faction)
{
	local H7EditorArmy currentArmy;
	local array <H7EditorArmy> armyForFaction;
	local int i;

	armyForFaction = GetDuelArmies(faction);
	foreach armyForFaction(currentArmy,i)
	{
		if(currentArmy == army)
		{
			return i;
		}
	}
	;
	return INDEX_NONE;
}

function H7EditorArmy GetRandomArmy( H7Faction faction )
{
	local array<H7EditorArmy> duelArmies;
	local int roll;

	
	duelArmies = GetDuelArmies(faction);

	if( duelArmies.Length<=1)
		return GetRandomDuelArmy(); // none 

	roll = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomIntRange( 1 , duelArmies.Length );

	return duelArmies[roll];
}

function array <H7EditorArmy> GetDuelArmies(H7Faction faction)
{
	local H7EditorArmy currentArmy;
	local CreatureStackProperties currentCreatureStack;
	local array<H7EditorArmy> duelArmies;
	local array<CreatureStackProperties> creatureStacks;

	duelArmies.AddItem(GetRandomDuelArmy());

	foreach mDuelArmies(currentArmy)
	{
		creatureStacks = currentArmy.GetCreatureStackProperties();
		foreach creatureStacks(currentCreatureStack)
		{
			if( currentCreatureStack.Creature != none && currentCreatureStack.Creature.GetFaction() == faction )
			{
				duelArmies.AddItem(currentArmy);
				break;
			}
		}		
	}

	return duelArmies;
}

