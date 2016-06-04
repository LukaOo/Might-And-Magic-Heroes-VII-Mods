//=============================================================================
// H7InscriberPopupCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InscriberPopupCntl extends H7FlashMovieTownPopupCntl
	dependson(H7StructsAndEnumsNative);

var protected H7GFxInscriberPopup mInscriberPopUp;

var H7Inscriber mInscriber;
var H7AdventureHero mGarrisonHero;
var H7AdventureHero mVisitingHero;
var bool mToGarrisonHero;

static function H7InscriberPopupCntl GetInstance() { return class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetInscriberCntl(); }
function H7GFxInscriberPopup GetInscriberPopup() {return mInscriberPopup;}

function bool Initialize()
{
	;
	/*Super.Start();

	AdvanceDebug(0);

	mInscriberPopUp = H7GFxInscriberPopup(mRootMC.GetObject("aInscriberPopUp", class'H7GFxInscriberPopup'));
	mInscriberPopUp.SetVisibleSave(false);

	Super.Initialize();*/
	LinkToTownPopupContainer();
	return true;
}

function LoadComplete()
{
	mInscriberPopUp = H7GFxInscriberPopup(mRootMC.GetObject("aInscriberPopUp", class'H7GFxInscriberPopup'));
	mInscriberPopUp.SetVisibleSave(false);
}

function Update(H7Town town)
{
	mTown = town;
	mInscriber = H7Inscriber(town.GetBuildingByType(class'H7Inscriber'));
	if(town.GetGarrisonArmy().GetHero().IsHero())
		mGarrisonHero = town.GetGarrisonArmy().GetHero();
	else
		mGarrisonHero = none;

	if(town.GetVisitingArmy() != none)
		mVisitingHero = town.GetVisitingArmy().GetHero();
	else
		mVisitingHero = none;

	OpenPopup();
	mInscriberPopUp.Update(mGarrisonHero, mVisitingHero, mInscriber, false);
}

function GetHeroInventory(bool garrisonHero)
{
	if(garrisonHero)
		mInscriberPopUp.SetHeroInventory(mGarrisonHero);
	else
		mInscriberPopUp.SetHeroInventory(mVisitingHero);
}

function GetScrollCostByItemID(int itemID)
{
	mInscriberPopUp.SetScrollCost( mInscriber.GetScrollbyID(itemID).GetBuyPrice() );
}

function BuyScroll(int scrollID, bool toGarrisonHero)
{	
	local H7AdventureHero hero;
	local H7InstantCommandBuyScroll command;

	mToGarrisonHero = toGarrisonHero;

	if(toGarrisonHero)
		hero = mGarrisonHero;
	else
	 	hero = mVisitingHero;

	command = new class'H7InstantCommandBuyScroll';
	command.Init( hero, mTown, scrollID );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );	
}

function BuyScrollComplete(H7AdventureHero hero, H7HeroItem scrollToBuy)
{
	mInscriberPopUp.Update(mGarrisonHero, mVisitingHero, mInscriber, mToGarrisonHero);
	mInscriberPopUp.HighlightSlot(hero.GetInventory().GetItemPosByItem(scrollToBuy));
}

function ChangeItemPos(int itemID, int x, int y)
{
	if(mToGarrisonHero)
		mGarrisonHero.GetInventory().SetItemPos(itemID, x, y);
	else
		mVisitingHero.GetInventory().SetItemPos(itemID, x, y);
}


function H7GFxUIContainer GetPopup()
{
	return mInscriberPopUp;
}

