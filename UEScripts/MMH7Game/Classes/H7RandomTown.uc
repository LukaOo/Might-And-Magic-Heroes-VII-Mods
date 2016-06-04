/*=============================================================================
 * H7RandomTown
 * 
 * Town placeholder for skirmish maps
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * =============================================================================*/
class H7RandomTown extends H7Town
	hideCategories(Properties, Visuals, Upgrades, Audio, Collision, SiegeBuildings)
	implements(H7IRandomSpawnable)
	native
	placeable;

/** How to resolve the faction of this town. */
var(RandomTown) protected ERandomSiteFaction mFactionType<DisplayName="Faction">;
/** This Town will take the same faction as the selected Town/Fort. If that also takes its faction from another Town/Fort, the faction is chosen randomly. */
var(RandomTown) protected H7AreaOfControlSiteLord mSiteLord<DisplayName="Faction as Town/Fort"|EditCondition=mEditFactionSite>;
/** Factions that won't appear if Random Faction is selected  */
var(RandomTown) protected archetype array<H7Faction> mForbiddenFactions<DisplayName="Forbidden Factions">;

var private editoronly transient editconst bool mEditFactionSite;

var private editoronly MaterialInstanceConstant mPlayerColorMaterials[10];

var protected H7Town mSpawnedSite;
var protected H7Faction mChosenFaction;

function H7AreaOfControlSite GetSpawnedSite() { return mSpawnedSite; }
function ERandomSiteFaction GetFactionType() { return mFactionType; }

event H7Faction GetChosenFaction()
{
	mChosenFaction = class'H7GameUtility'.static.GetChosenFaction(mChosenFaction, mFactionType, mSiteOwner, mSiteLord, mForbiddenFactions);
	return mChosenFaction;
}

event DisposeShell()
{
	//Destroy();
}

native function OnTerrainChange(LandscapeLayerInfoObject newLayer, LandscapeProxy newLandscape);

function native SetRandomPlayerNumber( EPlayerNumber number );
function native SetFactionType( ERandomSiteFaction factionType );

event HatchRandomSpawnable()
{
	if(mChosenFaction != none)
	{
		HatchTown(mChosenFaction);
	}
	else
	{
		HatchTown(GetChosenFaction());
	}
	
}

function SetChoosenFaction(H7Faction faction) { mChosenFaction = faction; }

event HatchTown(H7Faction faction)
{
	local H7Town townTemplate;
	local H7AdventureMapCell cell;
	local EPlayerNumber siteOwner;
	local H7AdventureArmy garrisonArmy;
	local int aocIndex;
	local array<H7AreaOfControlSiteVassal> vassals;
	local RandomLordDefenseData defenseData;

	townTemplate = faction.GetStartTown();
	siteOwner = mSiteOwner;
	cell = GetEntranceCell();
	garrisonArmy = mEditorArmy;
	aocIndex = mAreaOfControlID;
	vassals = mVassals;
	defenseData = mDefenseData;


	TransferTownData( townTemplate ); // THIS OVERWRITES THE CURRENT INSTANCE WITH TEMPLATE DATA
	mEntranceCell = cell;
	mEditorArmy = garrisonArmy;
	mDefenseData = defenseData;

	mVassals = vassals;

	mAreaOfControlID = aocIndex;

	mSiteOwner = siteOwner;

	GetEntranceCell().SetVisitableSite( self );

	InitSiteOwner( mSiteOwner );

	if( GetEntranceCell().GetArmy() != none && GetEntranceCell().GetArmy().GetPlayerNumber() == mSiteOwner )
	{
		SetVisitingArmy( GetEntranceCell().GetArmy() );
		GetEntranceCell().GetArmy().SetVisitableSite( self );
	}

	faction.DelStartTown();
}

protected native function TransferTownData( H7Town town );

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

