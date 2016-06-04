/*=============================================================================
 * H7RandomDwelling
 * 
 * Dwelling placeholder for skirmish maps
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * =============================================================================*/
class H7RandomDwelling extends H7Dwelling
	hideCategories(Visuals, Audio, Dwelling)
	implements(H7IRandomSpawnable)
	native
	placeable;

/** Select any player that determines the faction of the Dwelling. */
var(RandomDwelling) protected EPlayerNumber mFactionPlayer<DisplayName="Faction Player"|EditCondition=mEditFactionPlayer>;
/** How to resolve the faction of this Dwelling. */
var(RandomDwelling) protected ERandomSiteFaction mFactionType<DisplayName="Faction">;
/** This Dwelling will take the same faction as the selected Town/Fort. If that also takes its faction from another Town/Fort, the faction is chosen randomly. */
var(RandomDwelling) protected H7AreaOfControlSiteLord mSiteLord<DisplayName="Faction as Town/Fort"|EditCondition=mEditFactionSite>;
/** The type of this Dwelling. */
var(RandomDwelling) protected EH7RandomDwellingType mDwellingType<DisplayName="Type">;
/** The level of this Dwelling. */
var(RandomDwelling) protected EH7RandomDwellingLevel mDwellingLevel<DisplayName="Level">;
/** Factions that won't appear if Random Faction is selected  */
var(RandomDwelling) protected archetype array<H7Faction> mForbiddenFactions<DisplayName="Forbidden Factions">;

var private editoronly transient editconst bool mEditFactionPlayer;
var private editoronly transient editconst bool mEditFactionSite;

var private editoronly MaterialInstanceConstant mPlayerColorMaterials[10];

var protected H7Dwelling mSpawnedSite;
var protected H7Faction mChosenFaction;
var protected savegame EH7ChampionDwellingChoice mChampionChoice;

function H7AreaOfControlSite GetSpawnedSite() { return mSpawnedSite; }
function ERandomSiteFaction GetFactionType() { return mFactionType; }

event H7Faction GetChosenFaction()
{
	mChosenFaction = class'H7GameUtility'.static.GetChosenFaction(mChosenFaction, mFactionType, mSiteOwner, mSiteLord, mForbiddenFactions);
	return mChosenFaction;
}

event EH7ChampionDwellingChoice GetChosenChampionDwelling()
{
	if(mChampionChoice == E_H7_CDC_NONE)
	{
		mChampionChoice = EH7ChampionDwellingChoice(class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomIntRange(1, 3));
	}

	return mChampionChoice;
}

event DisposeShell()
{
	//Destroy();
}

native function OnTerrainChange(LandscapeLayerInfoObject newLayer, LandscapeProxy newLandscape);

function native SetRandomPlayerNumber( EPlayerNumber number );
function native SetFactionType( ERandomSiteFaction factionType );

protected native function TransferDwellingData( H7Dwelling dwelling );

event HatchRandomSpawnable()
{
	HatchDwelling(GetChosenFaction());
}

event HatchDwelling(H7Faction faction)
{
	local H7Dwelling dwellingTemplate;
	local EH7RandomDwellingType dwellingType;
	local EH7RandomDwellingLevel dwellingLevel;
	local EH7ChampionDwellingChoice championChoice;
	local array<H7ResourceQuantity> upgradeCost;

	local Vector loc;
	local Rotator rot;
	local EPlayerNumber siteOwner;
	local H7AreaOfControlSiteLord lord;
	local H7AdventureMapCell entranceCell;

	local array <H7DwellingCreatureData> overrideCreaturePool;

	overrideCreaturePool = mCreaturePool;
	loc = Location;
	rot = Rotation;
	siteOwner = mSiteOwner;
	lord = mLord;
	upgradeCost = mUpgradeCost;

	dwellingType = (mDwellingType == E_H7_RDT_ANY) ? EH7RandomDwellingType(class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(2)) : mDwellingType;
	dwellingLevel = (mDwellingLevel == E_H7_RDL_ANY) ? EH7RandomDwellingLevel(class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(1)) : mDwellingLevel;
	championChoice = (dwellingType == E_H7_RDT_CHAMPION) ? GetChosenChampionDwelling() : E_H7_CDC_NONE;
	dwellingTemplate = faction.GetStartDwelling(dwellingType, championChoice);

	entranceCell = GetEntranceCell();

	TransferDwellingData( dwellingTemplate );

	if(overrideCreaturePool.Length > 0)
	{
		SetCreaturePool(overrideCreaturePool);
	}

	SetHidden( false );

	SetLocation( loc );
	SetRotation( rot );
	mSiteOwner = siteOwner;
	mLord = lord;
	mUpgradeCost = upgradeCost;

	mEntranceCell = entranceCell;
	GetEntranceCell().SetVisitableSite( self );

	InitSiteOwner( mSiteOwner );
	InitIsUpgraded( dwellingLevel == E_H7_RDL_UPGRADE );

	faction.DelStartDwelling(dwellingType, championChoice);
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

