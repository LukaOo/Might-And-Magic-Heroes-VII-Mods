//=============================================================================
// H7MarketPlacePopupCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7MarketPlacePopupCntl extends H7FlashMovieTownPopupCntl;

var protected H7GFxMarketPlacePopup mMarketPlacePopup;
var protected H7TradingPost mTradingPost;

static function H7MarketPlacePopupCntl GetInstance() { return class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetMarketPlaceCntl(); }
function H7GFxMarketPlacePopup GetMarketPlacePopup() {return mMarketplacePopup;}

function TestCall()
{
	;
}

function bool Initialize()
{
	
	;

	LinkToTownPopupContainer();

	/*Super.Start();
	AdvanceDebug(0);
	mMarketPlacePopup = H7GFxMarketPlacePopup(mRootMC.GetObject("aMarketPlacePopup", class'H7GFxMarketPlacePopup'));
	mMarketPlacePopup.SetVisibleSave(false);
	Super.Initialize();*/


	return true;
}

function LoadComplete()
{
	mMarketPlacePopup = H7GFxMarketPlacePopup(mRootMC.GetObject("aMarketPlacePopup", class'H7GFxMarketPlacePopup'));
	mMarketPlacePopup.SetVisibleSave(false);
	;

}

function UpdateWithCurrentTownOrTradingPost()
{
	;
	if(mTown !=none)
	{
		Update(mTown);
		//update creature upgrade buttons
		H7AdventureHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetTownHudCntl().GetMiddleHUD().SetDataFromTown(mTown, true);
		return;
	}
	if(mTradingPost != none)
	{
		UpdateFromTradingPost(mTradingPost);
		return;
	}

	;
}

function Update(H7Town pTown)
{
	mContainer.SetExternalInterface(self);
	mTown = pTown;
	mMarketPlacePopup.Update(mTown);
	if(GetHUD().GetCurrentContext() != self) OpenPopup();
}

function UpdateFromTradingPost(H7TradingPost post)
{
	mContainer.SetExternalInterface(self);
	mMarketPlacePopup.Update(none, post);
	mTradingPost = post;

	H7AdventureHud( GetHud() ).BlockFlashBelow(H7AdventureHud( GetHud() ).GetTownPopupContainerCntl());
	H7AdventureHud( GetHud() ).GetAdventureHudCntl().GetCommandPanel().SetTownMode(true);
	H7AdventureHud( GetHud() ).GetAdventureHudCntl().GetCommandPanel().SetRelevantPopupOpen(true);
	H7AdventureHud( GetHud() ).GetAdventureHudCntl().DisableHeroHUDMiniMapTownList();
	
	if(GetHUD().GetCurrentContext() != self) OpenPopup();
}

function Trade(string resourceToSell, int amountToSell, string resourceToBuy, int amountToBuy)
{
	local H7Player thePlayer;
	local H7InstantCommandTransferResource command;

	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("MARKET_TRADE");
	;
	thePlayer = class'H7AdventureController'.static.GetInstance().GetLocalPlayer();

	command = new class'H7InstantCommandTransferResource';
	command.Init(thePlayer, thePlayer, resourceToSell, resourceToBuy, amountToSell, amountToBuy);
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function Transfer(String resName, int resAmount, int receivingPlayerNumber)
{
	local H7Resource res;
	local array<H7Player> players; 
	local H7InstantCommandTransferResource command;

	res = mTown.GetPlayer().GetResourceSet().GetResourceByName(resName);
	players = class'H7AdventureController'.static.GetInstance().GetPlayers();

	if(!players[receivingPlayerNumber].GetResourceSet().HasResourceInSet(res))
	{
		;
		return;
	}

	command = new class'H7InstantCommandTransferResource';
	command.Init(mTown.GetPlayer(), players[receivingPlayerNumber], resName, resName, resAmount, resAmount);
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function ClosePopUp()
{
	if(mTradingPost != none)
	{
		H7AdventureHud( GetHud() ).UnblockAllFlashMovies();
		H7AdventureHud( GetHud() ).GetAdventureHudCntl().GetCommandPanel().SetTownMode(false);
		H7AdventureHud( GetHud() ).GetAdventureHudCntl().GetCommandPanel().SetRelevantPopupOpen(false);
		H7AdventureHud( GetHud() ).GetAdventureHudCntl().EnableHeroHUDMiniMapTownList();
	}
	mTradingPost = none;
	mTown = none;
	super.ClosePopup();
}

function Closed()
{
	if(mTradingPost != none)
	{
		H7AdventureHud( GetHud() ).UnblockAllFlashMovies();
		H7AdventureHud( GetHud() ).GetAdventureHudCntl().GetCommandPanel().SetTownMode(false);
		H7AdventureHud( GetHud() ).GetAdventureHudCntl().GetCommandPanel().SetRelevantPopupOpen(false);
		H7AdventureHud( GetHud() ).GetAdventureHudCntl().EnableHeroHUDMiniMapTownList();
	}
	mTradingPost = none;
	mTown = none;

	ClosePopup();
}


function H7GFxUIContainer GetPopup()
{
	return mMarketPlacePopup;
}

