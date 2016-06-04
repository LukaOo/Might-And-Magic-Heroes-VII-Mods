//=============================================================================
// H7ArtifactRecyclerPopupCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7ArtifactRecyclerPopupCntl extends H7FlashMovieTownPopupCntl
	dependson(H7StructsAndEnumsNative);

var protected H7GFxArtifactRecyclerPopup mRecyclerPopUp;

var H7ArtifactRecyclingTable valueTable;
var H7AdventureHero mGarrisonHero;
var H7AdventureHero mVisitingHero;
var H7HeroItem mItemToRecycle;

static function H7ArtifactRecyclerPopupCntl GetInstance() { return class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetArtifactRecyclerCntl(); }
function H7GFxArtifactRecyclerPopup GetArtifactRecyclerPopup() {return mRecyclerPopup;}

function bool Initialize()
{
	;
	/*Super.Start();
	
	AdvanceDebug(0);

	mRecyclerPopUp = H7GFxArtifactRecyclerPopup(mRootMC.GetObject("aRecyclerPopUp", class'H7GFxArtifactRecyclerPopup'));
	mRecyclerPopUp.SetVisibleSave(false);

	Super.Initialize();*/
	LinkToTownPopupContainer();
	return true;
}

function LoadComplete()
{
	mRecyclerPopUp = H7GFxArtifactRecyclerPopup(mRootMC.GetObject("aRecyclerPopUp", class'H7GFxArtifactRecyclerPopup'));
	mRecyclerPopUp.SetVisibleSave(false);
}

function Update(H7Town town)
{
	if(town.GetGarrisonArmy().GetHero().IsHero())
		mGarrisonHero = town.GetGarrisonArmy().GetHero();
	else
		mGarrisonHero = none;

	if(town.GetVisitingArmy() != none)
		mVisitingHero = town.GetVisitingArmy().GetHero();
	else
		mVisitingHero = none;

	mTown = town;
	valueTable = H7ArtifactRecycler(town.GetBuildingByType(class'H7ArtifactRecycler')).GetRecyclingTable();

	OpenPopup();
	mRecyclerPopUp.Update(mGarrisonHero, mVisitingHero, town.GetBuildingByType(class'H7ArtifactRecycler').GetName());
}

function GetHeroInventory(bool garrisonHero)
{
	if(garrisonHero)
		mRecyclerPopUp.SetHeroInventory(mGarrisonHero);
	else
		mRecyclerPopUp.SetHeroInventory(mVisitingHero);
}

function GetResGainByItemID(int itemID)
{
	local array<H7ResourceQuantity> recycleValues;
	local float multiplier;

	multiplier = 1;

	if(mGarrisonHero != none)
		mItemToRecycle = mGarrisonHero.GetInventory().GetItemByID(itemID);

	if(mItemToRecycle == none && mVisitingHero != none)
		mItemToRecycle = mVisitingHero.GetInventory().GetItemByID(itemID);

	if(mItemToRecycle == none)
	{
		;
		return;
	}

	recycleValues = valueTable.GetRecycleValueByType(mItemToRecycle.GetType());
	multiplier = valueTable.GetMultiplierByTier(mItemToRecycle.GetTier());

	mRecyclerPopUp.SetRecycleValues(recycleValues, multiplier);
	mItemToRecycle = none;
}

function RecycleItem(int itemID)
{
	local H7InstantCommandRecycleArtifact command;

	;

	command = new class'H7InstantCommandRecycleArtifact';
	command.Init( mTown, itemId );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
	
	mItemToRecycle = none;
}

function RecycleItemComplete(H7AdventureHero hero)
{
	mRecyclerPopUp.SetHeroInventory(hero);
}

function H7GFxUIContainer GetPopup()
{
	return mRecyclerPopUp;
}


