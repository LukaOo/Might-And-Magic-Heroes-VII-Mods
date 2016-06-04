//=============================================================================
// H7ThievesGuildPopupCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7ThievesGuildPopupCntl extends H7FlashMovieTownPopupCntl;

var protected H7GfxThievesGuildPopup mThievesGuildPopup;
var protected H7GFxArmyRow mArmyRow;
var protected H7GFxWarfareUnitRow mWarfareUnitRow;
var protected H7GFxUIContainer mHeroInfo;
var protected bool mHeroInfoOpen;
var protected H7DenOfThieves mDen;
var protected H7AdventureHero clickedHero;

static function H7ThievesGuildPopupCntl GetInstance()   { return class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetThievesGuildCntl(); }
function H7GFxThievesGuildPopup GetThievesGuildPopup()  { return mThievesGuildPopup;}
function SetDenOfThieves( H7DenOfThieves site )         { mDen = site; }
function bool IsHeroInfoOpen()                          { return mHeroInfoOpen; }

function bool Initialize()
{
	;
	LinkToTownPopupContainer();

	/*Super.Start();

	AdvanceDebug(0);

	mThievesGuildPopup = H7GFxThievesGuildPopup(mRootMC.GetObject("aThievesGuildPopup", class'H7GFxThievesGuildPopup'));
	mArmyRow = H7GFxArmyRow(mThievesGuildPopup.GetObject("mBestHeroPopup", class'GFxObject').GetObject("aArmyRow", class'H7GFxArmyRow'));
	mWarfareUnitRow = H7GFxWarfareUnitRow(mThievesGuildPopup.GetObject("mBestHeroPopup", class'GFxObject').GetObject("aWarfareRow", class'H7GFxWarfareUnitRow'));
	mThievesGuildPopup.SetVisibleSave(false);

	Super.Initialize();*/
	return true;
}

function LoadComplete()
{
	mThievesGuildPopup = H7GFxThievesGuildPopup(mRootMC.GetObject("aThievesGuildPopup", class'H7GFxThievesGuildPopup'));
	mHeroInfo = H7GFxUIContainer(mThievesGuildPopup.GetObject("mBestHeroPopup", class'H7GFxUIContainer').GetObject("mHeroInfo", class'H7GFxUIContainer'));
	mArmyRow = H7GFxArmyRow(mThievesGuildPopup.GetObject("mBestHeroPopup", class'GFxObject').GetObject("aArmyRow", class'H7GFxArmyRow'));
	mWarfareUnitRow = H7GFxWarfareUnitRow(mThievesGuildPopup.GetObject("mBestHeroPopup", class'GFxObject').GetObject("aWarfareRow", class'H7GFxWarfareUnitRow'));
	mThievesGuildPopup.SetVisibleSave(false);
}

function Update(H7Town pTown)
{
	mTown = pTown;
	OpenPopup();
	
	mThievesGuildPopup.Update(none, false);
}

function UpdateFromDenOfThieves(H7DenOfThieves den)
{
	mDen = den;
	OpenPopUp();
	mThievesGuildPopup.Update(den, false);

	H7AdventureHud( GetHud() ).GetAdventureHudCntl().GetCommandPanel().SetTownMode(true);
}

function ClickedHeroSlot(int playerID)
{
	local H7AdventureArmy army;
	;
	army = class'H7AdventureController'.static.GetInstance().GetPlayerByID(playerID).GetBestHero().GetAdventureArmy();

	mArmyRow.Update(army);
	mWarfareUnitRow.Update(army);
	clickedHero = army.GetHero();

	mThievesGuildPopup.UpdateBestHeroWindow(army);
	mHeroInfoOpen = true;
}

function GetStatModSourceList(String statStr,int unrealID)
{
	local EStat stat;
	local array<H7StatModSource> mods;
	local int i;

	;

	for(i=0;i<=STAT_MAX;i++)
	{
		stat = EStat(i);
		if(String(stat) == statStr)
		{
			break;
		}
	}

	// special redirects
	if(statStr == "DAMAGE") stat = STAT_MIN_DAMAGE; 
	if(statStr == "STAT_MOVEMENT_TYPE") stat = STAT_MAX_MOVEMENT;

	if(stat == STAT_MAX)
	{
		;
		return;
	}

	;

	mods = clickedHero.GetStatModSourceList(stat);

	mHeroInfo.SetStatModSourceList(mods);
}

function SendSpy(int playerID, string infoType)
{
	local H7Player player;
	local Array<H7ResourceQuantity> costAsArray;
	local H7ResourceQuantity cost;
	player = class'H7AdventureController'.static.GetInstance().GetCurrentPlayer();
	player.GetThievesGuildManager().SendSpy(playerID, infoType);
	
	cost.Type = player.GetResourceSet().GetCurrencyResourceType();
	cost.Quantity = class'H7AdventureController'.static.GetInstance().GetConfig().mCostPerInformation;

	costAsArray.AddItem(cost);
	player.GetResourceSet().SpendResources(costAsArray, true, true);

	mThievesGuildPopup.UpdatePlayerMoney(player.GetResourceSet().GetCurrency());

	if(mDen != none)
	{
		player.GetThievesGuildManager().RevealInstantLastInfoRequested(playerID, infoType);
		mThievesGuildPopup.Reset();
		mDen.SpyUsed();
		mThievesGuildPopup.Update(mDen, true);
	}
	
	//update creature upgrade buttons
	if(mTown != none)
		H7AdventureHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetTownHudCntl().GetMiddleHUD().SetDataFromTown(mTown, true);
}

function HeroInfoClosed()
{
	mHeroInfoOpen = false;
}

function CloseHeroInfo()
{
	mThievesGuildPopup.CloseHeroInfo();
}

function BtnPlunderClicked(int playerID)
{
	local H7Player plunderedPlayer, plunderingPlayer;
	local H7InstantCommandThievesGuildPlunder command;

	plunderingPlayer = class'H7AdventureController'.static.GetInstance().GetCurrentPlayer();
	plunderedPlayer = class'H7AdventureController'.static.GetInstance().GetPlayerByID(playerID);
	
	;

	command = new class'H7InstantCommandThievesGuildPlunder';
	command.Init( plunderingPlayer, plunderedPlayer );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function BtnSabotageClicked(int playerID)
{
	local H7Player sabotagedPlayer, sabotagingPlayer;
	local H7InstantCommandSabotage command;

	sabotagingPlayer = class'H7AdventureController'.static.GetInstance().GetCurrentPlayer();
	sabotagedPlayer = class'H7AdventureController'.static.GetInstance().GetPlayerByID(playerID);
	
	;

	command = new class'H7InstantCommandSabotage';
	command.Init( sabotagingPlayer, sabotagedPlayer );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function Closed()
{
	mTown = none;
	ClosePopup();
}

function ClosePopup()
{
	;
	if(mDen != none)
	{
		H7AdventureHud( GetHud() ).GetAdventureHudCntl().GetCommandPanel().SetTownMode(false);
		mDen.OnLeave();
		mDen = none;
	}
	mHeroInfoOpen = false;
	mThievesGuildPopup.Reset();
	
	super.ClosePopup();
}

function H7GFxUIContainer GetPopup()
{
	return mThievesGuildPopup;
}

