/*=============================================================================
 * H7RandomFort
 * 
 * Fort placeholder for skirmish maps
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * =============================================================================*/
class H7RandomFort extends H7Fort
	hideCategories(Properties, Visuals, Audio, Destruction, Rebuilding, Resources)
	implements(H7IRandomSpawnable)
	native
	placeable;

/** How to resolve the faction of this fort. */
var(RandomFort) protected ERandomSiteFaction mFactionType<DisplayName="Faction">;
/** This Fort will take the same faction as the selected Town/Fort. If that also takes its faction from another Town/Fort, the faction is chosen randomly. */
var(RandomFort) protected H7AreaOfControlSiteLord mSiteLord<DisplayName="Faction as Town/Fort"|EditCondition=mEditFactionSite>;
/** Factions that won't appear if Random Faction is selected  */
var(RandomFort) protected archetype array<H7Faction> mForbiddenFactions<DisplayName="Forbidden Factions">;

var private editoronly transient editconst bool mEditFactionSite;

var private editoronly MaterialInstanceConstant mPlayerColorMaterials[10];

var protected H7Fort mSpawnedSite;
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

function native SetRandomPlayerNumber( EPlayerNumber number );
function native SetFactionType( ERandomSiteFaction factionType );

event HatchRandomSpawnable()
{
	HatchFort(GetChosenFaction());
}

protected event HatchFort(H7Faction faction)
{
	local H7Fort fortTemplate;
	local Vector loc;
	local Rotator rot;
	local H7Faction factionBuffer;
	local EPlayerNumber siteOwner;
	local array<H7AreaOfControlSiteVassal> vassals;
	local H7AdventureMapCell entranceCell;
	local int aocIndex;
	local H7AdventureArmy garrisonArmy;
	local RandomLordDefenseData defenseData;

	loc = Location;
	rot = Rotation;
	factionBuffer = mChosenFaction;
	siteOwner = mSiteOwner;
	vassals = mVassals;
	entranceCell = GetEntranceCell();
	fortTemplate = faction.GetStartFort();
	aocIndex = mAreaOfControlID;
	defenseData = mDefenseData;

	garrisonArmy = mEditorArmy;
	TransferFortData( fortTemplate ); // THIS OVERWRITES THE CURRENT INSTANCE WITH TEMPLATE DATA
	mEditorArmy = garrisonArmy;
	mDefenseData = defenseData;

	SetLocation( loc );
	SetRotation( rot );
	mChosenFaction = factionBuffer;
	mSiteOwner = siteOwner;
	mVassals = vassals;
	mAreaOfControlID = aocIndex;
	
	mEntranceCell = entranceCell;
	GetEntranceCell().SetVisitableSite( self );

	InitSiteOwner( mSiteOwner );
	if( GetEntranceCell().GetArmy() != none && GetEntranceCell().GetArmy().GetPlayerNumber() == mSiteOwner )
	{
		SetVisitingArmy( GetEntranceCell().GetArmy() );
	}

	faction.DelStartFort();
}

protected native function TransferFortData( H7Fort fort );

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
// (cpptext)

