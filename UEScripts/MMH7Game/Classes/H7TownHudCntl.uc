class H7TownHudCntl extends H7FlashMovieCntl;

var protected Texture2d mDummyTown;

var protected H7GFxMiddleHUD mMiddleHUD;
var protected H7GFxTownInfo mTownInfo;
var protected bool mIsActive;
var protected bool mIsInDwelling;
var protected bool mIsInFort;

var protected H7AreaOfControlSite mVisitingSite; // formerly mTown mLord mFort mDwelling
// deprecated shortcuts: OPTIONAL leave it?
var protected H7Town mTown;
var protected H7Fort mFort;
var protected H7Dwelling mDwelling;
var protected H7CustomNeutralDwelling mNeutralDwelling;

var protected H7TownAsset mZoomedInAsset;
var protected H7TownAsset mCurrentlyZoomingAsset;
var protected bool mNewBuildingToSpawn;
var protected bool mPreventTownscreenInView; // true when swapping from one popup to antoher popup without seeing townscreen

var protected Actor mCurrent3DTownScreen;

var protected bool mDismissArmy;
var protected int mDismissIndex;

var protected array<ParticleSystemComponent> mParticleSystems;
var protected array<Actor> mSpawnedActors;
var protected array<H7TownAsset> mSpawnedAssets;
var protected array<H7TownBuilding> mFadeInQueue;
var protected H7AdventureHero mPendingNewGovernor;
var protected bool mCaravanHighlight;
var protected H7BaseCreatureStack mDraggedStack;
var protected int mDraggedStackIndex;
var protected int mDraggedStackArmyNumber;
var protected bool mAllowHeroTransfer;

var protected bool mPendingPopupOpen;

var Actor mPrefabOwner;
var Prefab mPrefabGroup;

var float    posX, posY;
var rotator StartRotation;

var Vector mPreTownScreenCameraPos;

// for scripting
var protected H7PlayerEventParam mPlayerEventParam;

function H7GFxMiddleHUD GetMiddleHUD() { return mMiddleHUD; }
function H7GFxTownInfo GetTownInfo() { return mTownInfo; }

function H7TownAsset GetZoomedInAsset() { return mZoomedInAsset; }

static function H7TownHudCntl GetInstance() 
{ 
	if(class'H7PlayerController'.static.GetPlayerController().GetAdventureHud() == none) return none;
	return class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl(); 
}

function H7Town GetTown() { return mTown; }
function H7AreaOfControlSite GetSite() { return mVisitingSite; }
function H7BaseCreatureStack GetDraggedStack() {return mDraggedStack;}
function int GetDraggedStackIndex() {return mDraggedStackIndex;}
function int GetDraggedStackArmyNr(){return mDraggedStackArmyNumber;}

// TODO is there ever the state where mVisitingSite is set, but these bools are false? // if not -> delete them
function bool IsInTownScreen(){	return mIsActive;}
function bool IsInDwellingScreen(){	return mIsInDwelling;}
function bool IsInFortScreen(){	return mIsInFort;}
function bool IsInAnyScreen(){	return mIsActive || mIsInDwelling || mIsInFort || mVisitingSite != none;}

function bool Initialize() 
{
	;
	// Start playing the movie
    Super.Start();

	// Initialize all objects in the movie
    AdvanceDebug(0);

	mMiddleHUD = H7GFxMiddleHUD(mRootMC.GetObject("aTownHUD", class'H7GFxMiddleHUD'));
	mMiddleHUD.SetVisibleSave(false);

	mTownInfo = H7GFxTownInfo(mRootMC.GetObject("aTownInfo", class'H7GFxTownInfo'));
	mTownInfo.SetVisibleSave(false);

	mMiddleHUD.GetPosition(posX, posY);
	StartRotation = class'H7Camera'.static.GetInstance().Rotation;

	mPlayerEventParam = new class'H7PlayerEventParam';
	mAllowHeroTransfer = true;
	Super.Initialize();
	return true;
} 

// hero is currently visiting this site and the hud for this site is visible
function SetVisitingSite(H7AreaOfControlSite site)
{
	mVisitingSite = site;

	if(mVisitingSite == none)
	{
		mTown = none;
		mFort = none;
		mDwelling = none;
		mIsActive = false;
		mIsInFort = false;
		mIsInDwelling = false;
	}
	else
	{
		if(H7Town(mVisitingSite) != none) 
		{
			mTown = H7Town(mVisitingSite);
			mIsActive = true;
		}
		if(H7Fort(mVisitingSite) != none) 
		{
			mFort = H7Fort(mVisitingSite);
			mIsInFort = true;
		}
		if(H7Dwelling(mVisitingSite) != none) 
		{
			mDwelling = H7Dwelling(mVisitingSite);
			mIsInDwelling = true;
		}
		if(H7CustomNeutralDwelling(mVisitingSite) != none) 
		{
			mNeutralDwelling = H7CustomNeutralDwelling(mVisitingSite);
			mIsInDwelling = true;
		}
	}
}

function GotoTownScreen(H7Town town) // EnterTownScreen
{
	local H7AdventureController advCntl;
	local H7AdventureHud advenHud;
	local string faction;

	mFadeInQueue.Length = 0;

	class'H7CameraActionController'.static.GetInstance().CancelCurrentCameraAction();

	if( mPreTownScreenCameraPos == Vect( 0, 0, 0 ) )
	{
		mPreTownScreenCameraPos = class'H7Camera'.static.GetInstance().GetCurrentVRP();
	}

	faction = town.GetFaction().GetArchetypeID();
	class'H7SoundController'.static.GetInstance().UpdateMusicGameStateSwitch("TOWN_SCREEN", faction);
	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("ENTER_TOWN");

	class'H7LogSystemCntl'.static.GetInstance().GetBorderBlack().SetVisibleSave(true);

	advenHud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();
	
	advenHud.GetLogCntl().GetLog().SetVisibleSave(false);

	SetVisitingSite(town);
	class'H7Camera'.static.GetInstance().ClearFocusActor(); // stops the camera following of hero movement 
	
	// moves camera to the town
	advenHud.GetAdventureHudCntl().MinimapCameraShiftGrid(mTown.GetEntranceCell().mPosition.X,mTown.GetEntranceCell().mPosition.Y);
	advenHud.GetAdventureHudCntl().GetMinimap().ComputeMinimapFrustum();

	mTown.CreateEmptyGarrison();

	mMiddleHUD.SetVisibleSave(true);
	mMiddleHUD.SetDataFromTown(town, false);

	advCntl = class'H7AdventureController'.static.GetInstance();
	
	mTownInfo.SetVisibleSave(true);
	mTownInfo.SetData(town,advCntl.GetPlayerByNumber(town.GetPlayerNumber()).GetTowns());

	if(advCntl.GetSelectedArmy() != none && advCntl.GetSelectedArmy().GetHero() != none && advCntl.GetSelectedArmy().GetHero().HasPreparedAbility())
	{
		advCntl.GetSelectedArmy().GetHero().ResetPreparedAbility();
		class'H7PlayerController'.static.GetPlayerController().UnLoadCursorObject();
		class'H7PlayerController'.static.GetPlayerController().GetHud().GetSpellbookCntl().GetQuickBar().UnSelectSpell();
	}

	/////////////
	SpawnTownScreen(class'H7PlayerController'.static.GetPlayerController(), town.GetTownScreen());
	/////////////

	advenHud.GetAdventureHudCntl().GetTownList().SelectTown(town.GetID()); 
	advenHud.GetAdventureHudCntl().GetTownList().SetTownMode(true);
	
	// tell the GUI if it can send a caravan or not:
	class'H7TownHudCntl'.static.GetInstance().GetMiddleHUD().EnableCaravan(mTown.CanCreateCaravan());

	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateCameraMode(mIsActive);

	if(mTown.HasUncheckedCaravans())
	{
		mMiddleHUD.StartQuickSlotGlow(POPUP_CARAVAN, "TT_NEW_CARAVAN");
	}
	
	//multiplayer gui
	if(class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() || class'H7AdventureController'.static.GetInstance().IsHotSeat())
	{
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetMPTurnInfo().SwitchToFullScreen();
	}
	//ThievesGuild button glow
	//if(town.GetBuildingTemplateByType(class'H7Thi').IsBuilt)

	GotoAnyScreen();

	GetHUD().TriggerKismetNodeOpenPopup("aTownScreen");
	mAllowHeroTransfer = true;
}

function LeaveTownScreen(optional bool onlySwapping=false)
{
	local int popupID;
	local H7AdventureHudCntl advHUDCntl;

	if(mTown == none) 
	{
		return;
	}

	mTown.OnLeave();
	//mTown.DelFactionTownScreenRef(); // leave it so we can enter faster later

	SetVisitingSite(none);
	
	class'H7SoundController'.static.GetInstance().UpdateMusicGameStateSwitch("ADVENTURE_MAP");
	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("LEAVE_TOWN");
	
	// close any town popup that is open atm
	for( popupID=0; popupID<POPUP_MAX; popupID++ )
	{
		if(GetTownPopupCntlByID( popupID ) != none && GetTownPopupCntlByID(popupID).GetPopup().IsVisible())
		{
			GetTownPopupCntlByID( popupID ).ClosePopup();
		}
	}

	GetMiddleHUD().SetCaravanMode(false, false);
	mMiddleHud.Reset();
	mCaravanHighlight = false;

	
	////////////////
	UnSpawnTownScreen(onlySwapping);
	////////////////

	class'H7PlayerController'.static.GetPlayerController().SetIsPopupOpen(false);
	advHUDCntl = class'H7AdventureHudCntl'.static.GetInstance();
	advHUDCntl.GetCommandPanel().SetTownMode(false);
	if(!onlySwapping)
	{
		advHUDCntl.GetTownList().SelectTown(-1);
		advHUDCntl.GetTownList().SetTownMode(false);
	}
	mIsActive = false;
	advHUDCntl.GetMinimap().UpdateCameraMode(mIsActive);

	if( mTown != none )
	{
		advHUDCntl.MinimapCameraShiftGrid(mTown.GetEntranceCell().mPosition.X,mTown.GetEntranceCell().mPosition.Y);
		mTown.SetUncheckedCaravans(false);
	}
	
	
	class'H7LogSystemCntl'.static.GetInstance().GetLog().SetVisibleSave(true);
	//class'H7OverlaySystemCntl'.static.GetInstance().GetQALog().SetVisibleSave(true);
	class'H7Camera'.static.GetInstance().SetTargetVRP( mPreTownScreenCameraPos );
	mPreTownScreenCameraPos = Vect( 0, 0, 0 );

	class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();

	LeaveAnyScreen();

	// needs to be after LeaveAnyScreen():
	class'H7AdventureController'.static.GetInstance().UpdateHUD( class'H7AdventureController'.static.GetInstance().GetLocalPlayerHeroes( false ), class'H7AdventureController'.static.GetInstance().GetSelectedArmy() );

	//multiplayer gui
	if(class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() || class'H7AdventureController'.static.GetInstance().IsHotSeat())
	{
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetMPTurnInfo().SwitchToHUD();
	}

	GetHUD().TriggerKismetNodeClosePopup("aTownScreen");
	mAllowHeroTransfer = true;
}

function GoToDwellingScreen(H7Dwelling dwelling) // opendwelling
{
	local H7AdventureHud advenHud;
	
	if( mPreTownScreenCameraPos == Vect( 0, 0, 0 ) )
	{
		mPreTownScreenCameraPos = class'H7Camera'.static.GetInstance().GetCurrentVRP();
	}
	
	advenHud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();
	
	mMiddleHUD.SetDataFromDwelling(dwelling);
	mMiddleHUD.SetVisibleSave(true);
	mTownInfo.SetDataFromDwelling(dwelling);
	mTownInfo.SetVisibleSave(false);
	
	advenHud.GetAdventureHudCntl().GetTownList().SetVisibleSave(false);
	
	// open recruit window
	advenHud.GetTownPopupContainerCntl().SetExternalInterface(advenHud.GetTownRecruitmentCntl());
	advenHud.GetTownRecruitmentCntl().UpdateFromDwelling(dwelling);
	class'H7PlayerController'.static.GetPlayerController().GetHud().PopupWasOpened(class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownRecruitmentCntl());
	
	SetVisitingSite(dwelling);

	GotoAnyScreen();

	GetHUD().TriggerKismetNodeOpenPopup("aDwellingScreen");
}

function GoToNeutralDwellingScreen(H7Dwelling dwelling)
{
	local H7AdventureHud advenHud;

	if( mPreTownScreenCameraPos == Vect( 0, 0, 0 ) )
	{
		mPreTownScreenCameraPos = class'H7Camera'.static.GetInstance().GetCurrentVRP();
	}

	advenHud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();

	mMiddleHUD.SetDataFromDwelling(dwelling);
	mMiddleHUD.SetVisibleSave(true);
	mTownInfo.SetDataFromDwelling(dwelling);
	mTownInfo.SetVisibleSave(false);

	advenHud.GetAdventureHudCntl().GetTownList().SetVisibleSave(false);
	
	// open recruit popup
	advenHud.GetTownPopupContainerCntl().SetExternalInterface(advenHud.GetTownRecruitmentCntl());
	advenHud.GetTownRecruitmentCntl().UpdateFromNeutralDwelling(dwelling);
	class'H7PlayerController'.static.GetPlayerController().GetHud().PopupWasOpened(class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownRecruitmentCntl());
	
	SetVisitingSite(dwelling);

	GotoAnyScreen();

	GetHUD().TriggerKismetNodeOpenPopup("aDwellingScreen");
}

function LeaveDwellingScreen()
{
	local H7AdventureHud advenHud;
	advenHud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();

	SetVisitingSite(none);

	advenHud.GetTownRecruitmentCntl().ClosePopup();

	
	class'H7PlayerController'.static.GetPlayerController().GetHud().PopupWasClosed();
	
	
	class'H7Camera'.static.GetInstance().SetTargetVRP( mPreTownScreenCameraPos );
	mPreTownScreenCameraPos = Vect( 0, 0, 0 );

	LeaveAnyScreen();

	GetHUD().TriggerKismetNodeClosePopup("aDwellingScreen");
}

function GoToGarrisonScreen(H7Garrison garrison)
{
	local H7AdventureHud advenHud;

	if( mPreTownScreenCameraPos == Vect( 0, 0, 0 ) )
	{
		mPreTownScreenCameraPos = class'H7Camera'.static.GetInstance().GetCurrentVRP();
	}

	advenHud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();

	advenHud.GetTownPopupContainerCntl().SetExternalInterface(advenHud.GetGateGuardCntl());
	advenHud.GetGateGuardCntl().UpdateFromGarrison(garrison);

	
	mMiddleHUD.SetDataFromGarrison(garrison);
	mMiddleHUD.SetVisibleSave(true);
	//mTownInfo.SetDataFromDwelling(dwelling);
	mTownInfo.SetVisibleSave(false);

	advenHud.GetAdventureHudCntl().GetTownList().SetVisibleSave(false);
	
	SetVisitingSite(garrison);

	GotoAnyScreen();

	GetHUD().TriggerKismetNodeOpenPopup("aGarrisonScreen");
	mAllowHeroTransfer = true;
}

function LeaveGarrisonScreen()
{
	local H7AdventureHud advenHud;
	advenHud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();

	SetVisitingSite(none);

	advenHud.GetGateGuardCntl().ClosePopup();

	class'H7Camera'.static.GetInstance().SetTargetVRP( mPreTownScreenCameraPos );
	mPreTownScreenCameraPos = Vect( 0, 0, 0 );

	LeaveAnyScreen();

	class'H7AdventureController'.static.GetInstance().UpdateHUD( class'H7AdventureController'.static.GetInstance().GetLocalPlayerHeroes( false ), class'H7AdventureController'.static.GetInstance().GetSelectedArmy() );

	GetHUD().TriggerKismetNodeClosePopup("aGarrisonScreen");
	mAllowHeroTransfer = true;
}

function GoToFortScreen(H7Fort fort)
{
	local H7AdventureHud advenHud;

	if( mPreTownScreenCameraPos == Vect( 0, 0, 0 ) )
	{
		mPreTownScreenCameraPos = class'H7Camera'.static.GetInstance().GetCurrentVRP();
	}

	// hud changes
	advenHud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();
	
	GetHUD().BlockUnreal();

	mMiddleHUD.SetDataFromFort(fort);
	mMiddleHUD.SetVisibleSave(true);

	mTownInfo.SetVisibleSave(false);
	
	advenHud.GetAdventureHudCntl().GetTownList().SetVisibleSave(false);

	//multiplayer gui
	if(class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() || class'H7AdventureController'.static.GetInstance().IsHotSeat())
	{
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetMPTurnInfo().SwitchToFullScreen();
	}

	SetVisitingSite(fort);

	// open recruitment popup
	OpenTownPopup(POPUP_RECRUIT);
	//advenHud.GetTownPopupContainerCntl().SetExternalInterface(advenHud.GetTownRecruitmentCntl());
	//advenHud.GetTownRecruitmentCntl().UpdateFromLord(fort); // OpenPopup and PopupWasOpened is in here
	//class'H7PlayerController'.static.GetPlayerController().GetHud().PopupWasOpened(advenHud.GetTownRecruitmentCntl());
	//HighlightButton(POPUP_RECRUIT);

	GotoAnyScreen();

	GetHUD().TriggerKismetNodeOpenPopup("aFortScreen");
	mAllowHeroTransfer = true;
}

function LeaveFortScreen()
{
	local H7AdventureHud advenHud;
	advenHud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();

	GetHUD().UnblockUnreal();

	SetVisitingSite(none);

	advenHud.GetTownRecruitmentCntl().ClosePopup();
	
	class'H7Camera'.static.GetInstance().SetTargetVRP( mPreTownScreenCameraPos );
	mPreTownScreenCameraPos = Vect( 0, 0, 0 );

	LeaveAnyScreen();

	class'H7AdventureController'.static.GetInstance().UpdateHUD( class'H7AdventureController'.static.GetInstance().GetLocalPlayerHeroes( false ), class'H7AdventureController'.static.GetInstance().GetSelectedArmy() );

	//multiplayer gui
	if(class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() || class'H7AdventureController'.static.GetInstance().IsHotSeat())
	{
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetMPTurnInfo().SwitchToHUD();
	}

	GetHUD().TriggerKismetNodeClosePopup("aFortScreen");
	mAllowHeroTransfer = true;
}

// called from AdventureController.EndPlayerTurn(), in case player ends turn using hotkey
function Leave()
{
	if(mTown     != none) 
	{
		LeaveTownScreen();
	}
	else if(mFort     != none) 
	{
		LeaveFortScreen();
	}
	else if(mDwelling != none) 
	{
		LeaveDwellingScreen();
	}
	else if(mVisitingSite != none)
	{
		if(mVisitingSite.isa('H7Garrison'))
		{
			LeaveGarrisonScreen();
		}
	}
	mAllowHeroTransfer = true;
}

// common action for leaving town,fort,dwelling,site
// DO NOT CALL - call Leave(); instead
private function LeaveAnyScreen()
{
	mDraggedStack = none;
	mDraggedStackIndex = -1;
	mDraggedStackArmyNumber = -1;

	mFadeInQueue.Length = 0;

	mMiddleHUD.SetVisibleSave(false);
	mTownInfo.SetVisibleSave(false);
	class'H7LogSystemCntl'.static.GetInstance().GetBorderBlack().SetVisibleSave(false);

	class'H7AdventureHudCntl'.static.GetInstance().GetCommandPanel().SetTownMode(false);

	if( GetHUD().GetHUDMode() == HM_NORMAL )
	{
		class'H7AdventureHudCntl'.static.GetInstance().GetTownList().SetVisibleSave(true);
		class'H7AdventureHudCntl'.static.GetInstance().GetHeroHUD().SetVisibleSave(true);
		class'H7SpellbookCntl'.static.GetInstance().GetQuickBar().SetVisibleSave(true);
	}
	mAllowHeroTransfer = true;
}

// common action for entering town,fort,dwelling,site
private function GotoAnyScreen()
{
	class'H7AdventureHudCntl'.static.GetInstance().GetHeroHUD().SetVisibleSave(false);
	class'H7AdventureHudCntl'.static.GetInstance().GetCommandPanel().SetTownMode(true);

	GetHUD().GetSpellbookCntl().GetQuickBar().SetVisibleSave(false);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Popup Handling 
///////////////////////////////////////////////////////////////////////////////////////////////////

// quickbar button clicked in flash
function OpenPopup(int popupID)
{
	ToggleVisitTownBuilding(popupID);
}

// 3d-asset clicked in townscreen
function AssetClicked(H7TownAsset asset)
{
	local H7TownBuilding building;
	local ETownPopup popup;

	building = mTown.GetBuildingByAssetType(asset.GetType());
	
	if(building == none) return;

	popup = building.GetPopup();

	;

	ToggleVisitTownBuilding(popup,asset);
}

// also dehighlights all others
function HighlightButton(int popupID,optional bool val)
{
	mMiddleHUD.HighlightButton(popupID,val);
}

function ResetPendingPopupOpen()
{
	mPendingPopupOpen = false;
}

// Button pressed button clicked key pressed
// Zooms to a building / or out if already there 
// (!!!) not the real open popup -> see: ZoomInComplete or OpenTownPopup
function ToggleVisitTownBuilding(int popupID,optional H7TownAsset specificAsset) // or close
{
	local array<H7TownBuildingData> buildings;
	local H7TownBuildingData building;
	local ETownPopup popupEnum;

	popupEnum = ETownPopup(popupID);

	if(mFort != none)
	{
		if(!GetTownPopupCntlByID(popupID).GetPopup().IsVisible()) // no longer a toggle for forts as per design 2016-04-07
		{
			OpenTownPopup(popupEnum);
		}
		return;
	}

	if(!mMiddleHUD.CanPopup(popupEnum,mTown)) return; // OPTIONAL manually activate error-tooltip of corresponding button (for when hotkey used)

	if(mPendingPopupOpen) { ; return; }

	mPendingPopupOpen = true;
	GetHUD().SetFrameTimer(1,ResetPendingPopupOpen);

	// MID-ZOOM - check if already on the way to this (or another) 
	if(mCurrentlyZoomingAsset != none)
	{
		// Abort zoom
		mCurrentlyZoomingAsset.ClearTimer('ZoomInComplete');
		mCurrentlyZoomingAsset.ClearTimer('ZoomOutComplete');
		if(specificAsset != none && mCurrentlyZoomingAsset != specificAsset) // if same asset: toggle , else: reset
		{
			mCurrentlyZoomingAsset.SetZoomedIn(false);
		}
		if(mTown.GetBuildingByAssetType(mCurrentlyZoomingAsset.GetType()).GetPopup() != popupID) // if same popup: toggle , else: reset
		{
			mCurrentlyZoomingAsset.SetZoomedIn(false);
		}
		mCurrentlyZoomingAsset = none;
	}

	// I am at the building I want to go to -> zoom out
	if(GetTownPopupCntlByID(popupID).GetPopup().IsVisible() || (mZoomedInAsset != none && mTown.GetBuildingByAssetType(mZoomedInAsset.GetType()).GetPopup() == popupID))
	{
		// close it and zoom out
		ClosePopupByID(popupID);
		if(mZoomedInAsset != none)
		{
			mZoomedInAsset.SetZoomedIn(true);
			mZoomedInAsset.DoZoom(); // hopefully zooms out
			mZoomedInAsset = none;
		}
		HighlightButton(popupID,false);
		return;
	}
	// I am at another building -> prepare zoom over
	else if(mZoomedInAsset != none && mTown.GetBuildingByAssetType(mZoomedInAsset.GetType()).GetPopup() != popupID)
	{
		// close other popup
		mPreventTownscreenInView = true;
		ClosePopupByID(mTown.GetBuildingByAssetType(mZoomedInAsset.GetType()).GetPopup());
		mPreventTownscreenInView = false;
		// act like you are at default
		if(mZoomedInAsset != none)
		{
			mZoomedInAsset.SetZoomedIn(false);
			mZoomedInAsset = none;
		}
	}
	// I am at the asset less recruit window -> zoom to other buiding
	else if(GetTownPopupCntlByID(POPUP_RECRUIT).GetPopup().IsVisible() && popupEnum != POPUP_RECRUIT)
	{
		// close other popup
		mPreventTownscreenInView = true;
		ClosePopupByID(POPUP_RECRUIT);
		mPreventTownscreenInView = false;
		// act like you are at default
		if(mZoomedInAsset != none)
		{
			mZoomedInAsset.SetZoomedIn(false);
			mZoomedInAsset = none;
		}
	}
	else
	{
		// in case of SelectTownAndOpenTownHall, we need to close it before the other opens
		if(class'H7TownBuildingPopupCntl'.static.GetInstance().GetBuildingPopup().IsVisible())
		{
			ClosePopupByID(POPUP_BUILD);
		}
	}
	
	HighlightButton(popupID,true);

	if(specificAsset == none)
	{
		// find building responsible and zoom in/or out
		buildings = mTown.GetBuildings();
		foreach buildings(building)
		{
			if(building.Building.GetPopup() == popupID)
			{
				;
				specificAsset = GetTownAsset(building.Building.GetTownAsset());
				break;
			}
		}
		if(ETownPopup(popupID) == POPUP_RECRUIT && specificAsset == none)
		{
			OpenTownPopup(ETownPopup(popupID));
			return;
		}
		if(ETownPopup(popupID) == POPUP_CARAVAN && specificAsset == none)
		{
			OpenTownPopup(ETownPopup(popupID));
			return;
		}
		if(ETownPopup(popupID) == POPUP_BUILD && specificAsset == none) // townhall is there always anyway, but we need this because entire townscreen spawns 1 frame later
		{
			OpenTownPopup(ETownPopup(popupID));
			return;
		}
	}

	if(specificAsset != none) 
	{
		if(specificAsset.IsZoomedIn())
		{
			HighlightButton(popupID,false);
		}
		else
		{
			HighlightButton(popupID,true);
		}

		specificAsset.DoZoom(); // when finished calls: ZoomInComplete
	}
	else
	{
		// still not found, means is not in townscreen 
		// but could be build and pending to appear in the townscreen!
		if(mNewBuildingToSpawn)
		{
			if(IsInFadeInQueue(building.Building))
			{
				HighlightButton(popupID,true);
				OpenTownPopup(popupEnum);
				return;
			}
		}
		HighlightButton(popupID,false);
	}
}

function ZoomInStart(H7TownAsset asset)
{
	mCurrentlyZoomingAsset = asset;
}

function ZoomOutStart(H7TownAsset asset)
{
	mCurrentlyZoomingAsset = asset;
}

// Zoom finished, open popup for real // openpopup
function ZoomInComplete(H7TownAsset asset)
{
	// find building that has this asset
	//local array<H7TownBuildingData> buildings;
	//local H7TownBuildingData building;
	local H7TownBuilding building;
	local int popupID;
	local H7Player currentPlayer;
	
	mCurrentlyZoomingAsset = none;

	// ??? not sure what this is for
	if(mZoomedInAsset != none && mTown.GetBuildingByAssetType(mZoomedInAsset.GetType()).GetPopup() != mTown.GetBuildingByAssetType(asset.GetType()).GetPopup())
	{
		// close other popup
		ClosePopupByID(mTown.GetBuildingByAssetType(mZoomedInAsset.GetType()).GetPopup());
		mZoomedInAsset.SetZoomedIn(false);
		mZoomedInAsset = none;
	}

	mZoomedInAsset = asset;

	// find building responsible and see what popup it opens
	building = mTown.GetBuildingByAssetType(asset.GetType());
	if(building != none)
	{
		popupID = building.GetPopup();

		// Scripting
		currentPlayer = class'H7AdventureController'.static.GetInstance().GetLocalPlayer();
		class'H7ScriptingController'.static.GetInstance().UpdateBuildingVisit(H7TownBuilding(building.ObjectArchetype), mTown, currentPlayer.GetPlayerNumber());
		mPlayerEventParam.mTownbuilding = H7TownBuilding(building.ObjectArchetype);
		mPlayerEventParam.mEventPlayerNumber = currentPlayer.GetPlayerNumber();
		class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_PlayerVisitsTownBuilding', mPlayerEventParam, currentPlayer);
	}

	/*
	//buildings = mTown.GetBuildings();
	popupID = POPUP_NONE;
	foreach buildings(building)
	{
		if(building.Building.GetTownAsset() == none )
		{
			`warn(building.Building.GetName() @ "has no town asset");
			continue;
		}
		if(building.Building.GetTownAsset().GetType() == asset.GetType())
		{
			if(popupID != POPUP_NONE && popupID != building.Building.GetPopup()) `datawarn(asset @ asset.GetType() @ "wants to open" @ building.Building.GetPopup() @ "but somebody else wanted" @ popupID);
			popupID = building.Building.GetPopup();
		}
	}
	*/
	
	if(popupID == POPUP_NONE)
	{
		;
	}
	else
	{
		OpenTownPopup(ETownPopup(popupID));
	}
}

// for real!
function OpenTownPopup(ETownPopup popupID)
{
	local Vector2d newResFlash;
	local H7ContainerCntl pcCntl;

	if( mVisitingSite != none && !mMiddleHUD.CanPopup( popupID, mVisitingSite ) )
	{
		return;
	}
	
	// realign popup that will open
	newResFlash = class'H7PlayerController'.static.GetPlayerController().GetScreenResolution();
	newResFlash = GetTownPopupCntlByID(popupID).UnrealPixels2FlashPixels(newResFlash);
	GetTownPopupCntlByID(popupID).GetPopup().Realign(newResFlash.x,newResFlash.y);

	// open popup for real
	
	pcCntl = GetTownPopupCntlByID(popupID).GetContainer();
	if(pcCntl != none)
	{
		pcCntl.SetExternalInterface(GetTownPopupCntlByID(popupID));
	}
	else
	{
		;
	}

	mPreventTownscreenInView = true; // in case opening this, closes another, the closing should not trigger TownscreenInView

	if(H7FlashMovieTownPopupCntl( GetTownPopupCntlByID(popupID) ) != none && mTown != none)
	{
		H7FlashMovieTownPopupCntl( GetTownPopupCntlByID(popupID) ).Update(mTown); // should contain OpenPopup()
	}
	else if(H7TownRecruitmentPopupCntl( GetTownPopupCntlByID(popupID) ) != none && mFort != none)
	{
		H7TownRecruitmentPopupCntl( GetTownPopupCntlByID(popupID) ).UpdateFromLord(mFort); // should contain OpenPopup()
	}
	else if(H7TownCaravanPopupCntl( GetTownPopupCntlByID(popupID) ) != none && mFort != none)
	{
		H7TownCaravanPopupCntl( GetTownPopupCntlByID(popupID) ).UpdateFromLord(mFort);
	}
	else
	{
		H7MerchantPopUpCntl( GetTownPopupCntlByID(popupID) ).Update(mTown);
	}

	mPreventTownscreenInView = false;

	class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();

	HighlightButton(popupID,true);

	//class'H7PlayerController'.static.GetPlayerController().GetHud().TriggerKismetNodeOpenPopup(GetTownPopupCntlByID(popupID).GetPopup().GetFlashName());
}

function H7FlashMoviePopupCntl GetTownPopupCntlByID(int popupID)
{
	local H7Faction faction;
	
	if( mTown == none && mFort == none ) { return none; }

	if( mTown != none)
	{
		faction = mTown.GetFaction();
	}

	switch(popupID)
	{
		case POPUP_BUILD: return H7AdventureHud(GetHUD()).GetTownBuildingCntl();
		case POPUP_RECRUIT:return H7AdventureHud(GetHUD()).GetTownRecruitmentCntl();
		case POPUP_MARKETPLACE:return H7AdventureHud(GetHUD()).GetMarketPlaceCntl();
		case POPUP_HALLOFHEROS:return H7AdventureHud(GetHUD()).GetHallOfHerosCntl();
		case POPUP_MAGICGUILD:return H7AdventureHud(GetHUD()).GetMagicGuildCntl();
		case POPUP_TOWNGUARD:return H7AdventureHud(GetHUD()).GetTownGuardCntl();
		case POPUP_WARFARE:return H7AdventureHud(GetHUD()).GetTownWarfareCntl();
		case POPUP_THIEVES:return H7AdventureHud(GetHUD()).GetThievesGuildCntl();
		case POPUP_CARAVAN:return H7AdventureHud(GetHUD()).GetCaravanCntl();

		case POPUP_CUSTOM1:
				switch(faction)
				{
					case mMiddleHUD.mFactionAcademy:
					case mMiddleHUD.mFactionAcademy2:	
						return H7AdventureHud(GetHUD()).GetArtifactRecyclerCntl();
					case mMiddleHUD.mFactionNecro : return H7AdventureHud(GetHUD()).GetAltarOfSacrificeCntl();
					case mMiddleHUD.mFactionDungeon: return H7AdventureHud(GetHUD()).GetMerchantPopUpCntl();
				}				

		case POPUP_CUSTOM2: 
				switch(faction)
				{
					case mMiddleHUD.mFactionAcademy:
					case mMiddleHUD.mFactionAcademy2:
						return H7AdventureHud(GetHUD()).GetInscriberCntl();
				}
	
		default:
				;
				return none;
	}
}

// wrapper
function ClosePopupByID(int popupID)
{
	GetTownPopupCntlByID(popupID).ClosePopup();
}

// wrapper
function bool IsOpen(int popupID)
{
	return GetTownPopupCntlByID(popupID).GetPopup().IsVisible();
}

function TownPopupWasClosed(H7FlashMoviePopupCntl cntl)
{
	;
	if( mZoomedInAsset != none )
	{
		mZoomedInAsset.SetZoomedIn(true);
		mZoomedInAsset.DoZoom(); // Zooms out
		mZoomedInAsset = none;
	}

	HighlightButton(0,false);

	if(IsInTownScreen() && !mPreventTownscreenInView)
	{
		TownscreenIsInView();
		GetTownInfo().SetVisibleSave(true);
	}

	if((IsInFortScreen()) && !mPreventTownscreenInView)
	{
		// fort and outpost are in view -> they don't have a view / they don't have a popup open -> leave fort&outpost screen
		Leave();
	}

	//class'H7PlayerController'.static.GetPlayerController().GetHud().TriggerKismetNodeClosePopup(cntl.GetPopup().GetFlashName());
}

function ZoomOutAndBuild()
{
	local bool zoomEnabled;

	zoomEnabled = false; //HACK because no central place to get it (it's in 100 assets default params)

	mNewBuildingToSpawn = true;

	if(!zoomEnabled)
	{
		ZoomOutComplete(none);
	}
	else
	{
		if(mZoomedInAsset != none)
		{
			mZoomedInAsset.SetZoomedIn(true);
			mZoomedInAsset.DoZoom(); // Zooms out
			mZoomedInAsset = none;
		}
		else
		{
			;
		}
	}

	HighlightButton(0,false);
}

function ZoomOutComplete(H7TownAsset asset)
{
	mCurrentlyZoomingAsset = none;
	
	if(mNewBuildingToSpawn)
	{
		// postbuilding 4) Update Quickbar
		mMiddleHUD.SetupQuickBar(mTown);
		// TODO what about rest of hud, caravan,townguard
	}
}

// postbuilding 5) when viewing the scene again, after building
function TownscreenIsInView()
{
	if(mNewBuildingToSpawn)
	{
		// Update Townscreen
		UnSpawnTownScreen();
		SpawnTownScreen(class'H7PlayerController'.static.GetPlayerController(), mTown.GetTownScreen());
		mNewBuildingToSpawn = false;
	}
	GetHUD().TriggerKismetNodeOpenPopup("aTownScreen");
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Camera 3d gui fun test case DEPRECATED unused
///////////////////////////////////////////////////////////////////////////////////////////////////

function UpdatePos()
{
    local float yawRadian;
    local float pitchRadian;
    local matrix mYaw, mTranslate, mPitch, mFinal;
	local float Scale;

	
	Scale = 1.0;

    // Create identity matrix.
    mTranslate.XPlane.X = 1;
    mTranslate.YPlane.Y = 1;
    mTranslate.ZPlane.Z = 1;
    mTranslate.WPlane.W = 1;

    // Initialize all matrices to identity
    mYaw = mTranslate;
    mPitch = mTranslate;

	// Apply original translation
    mTranslate.WPlane.X = posX;
    mTranslate.WPlane.Y = posY;

	// compute rotation	
    yawRadian = -((16384 + ((class'H7Camera'.static.GetInstance().Rotation.Yaw /*- 5000*/) - StartRotation.Yaw)) & 65535) * (Pi/32768.0);
    yawRadian -= (3*1.57079633);

    pitchRadian = -((16384 + (class'H7Camera'.static.GetInstance().Rotation.Pitch - StartRotation.Pitch)) & 65535) * (Pi/32768.0);
    pitchRadian -= (3*1.57079633);

    // Rotate about the Y
    mYaw.XPlane.X = cos(yawRadian) * Scale;
    mYaw.XPlane.Z = -sin(yawRadian) * Scale;

    mYaw.ZPlane.X = sin(yawRadian) * Scale;
    mYaw.ZPlane.Z = cos(yawRadian) * Scale;

    // Rotate about the X
    mPitch.YPlane.Y = cos(pitchRadian) * Scale;
    mPitch.YPlane.Z = sin(pitchRadian) * Scale;

    mPitch.ZPlane.Y = -sin(pitchRadian) * Scale;
    mPitch.ZPlane.Z = cos(pitchRadian) * Scale;

    mFinal = mYaw * mPitch * mTranslate;

    mMiddleHUD.SetDisplayMatrix3D(mFinal);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Town selection
///////////////////////////////////////////////////////////////////////////////////////////////////

// hotkey
// or from flash town-info arrow browser
function SelectTown(int id)
{
	local array<H7Town> towns;
	local H7Town town;
	
	if(mTown.GetID() == id) return;

	towns = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetTowns();

	foreach towns(town)
	{
		if(town.GetID() == id)
		{
			SwitchTownScreen(town);
			return;
		}
	}
}

// switches from townscreen (if any) to townscreen of [town] while trying to keep the popup open (close & reopen the same popup)
function SwitchTownScreen(H7Town town)
{
	local ETownPopup popup;
	
	// the player cannot select a town when he has to retreat with an army
	if(  class'H7AdventurePlayerController'.static.GetAdventurePlayerController().GetRetreatingArmy() != none )
	{
		return;
	}

	if(IsInTownScreen())
	{
		popup = GetOpenTownPopup();
		if(popup != POPUP_NONE)
		{
			ClosePopupByID(popup);
		}
		LeaveTownScreen(true);
	}
	if(IsInAnyScreen())
	{
		Leave();
	}
	GotoTownScreen(town);
	if(popup != POPUP_NONE)
	{
		OpenTownPopup(popup);
	}
}

function UpdateAfterDestroy()
{
	class'H7AdventureController'.static.GetInstance().UpdateHUD();
	mTownInfo.SetData(mTown);
	mMiddleHUD.SetDataFromTown(mTown, true);
	UnSpawnTownScreen();
	SpawnTownScreen(class'H7PlayerController'.static.GetPlayerController(), mTown.GetTownScreen());
	mMiddleHUD.SetupQuickBar(mTown);
}

function ETownPopup GetOpenTownPopup()
{
	local int i;
	for(i=0;i<POPUP_MAX;i++)
	{
		if(GetTownPopupCntlByID(i).GetPopup().IsVisible())
		{
			return ETownPopup(i);
		}
	}
	return POPUP_NONE;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Drag'n'Drop & creature managment
///////////////////////////////////////////////////////////////////////////////////////////////////

function PutUnitOnCursorByBaseStack(H7BaseCreatureStack baseStack)
{
	local Rotator rot;
	local Texture2d icon;

	if(!mIsDragginUnit)
	{
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("DRAG");
		mIsDragginUnit = true;
	}

	icon = baseStack.GetStackType().GetIcon();

	GetHUD().SetSoftwareCursor(none,rot,,,icon);
}

function PutUnitOnCursorNew(int armyNr,int index)
{
	local Rotator rot;
	local Texture2d icon;

	;
	
	if(!mIsDragginUnit)
	{
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("DRAG");
		mIsDragginUnit = true;
	}
	
	if(index != -1)
	{
		// units
		if(armyNr == ARMY_NUMBER_VISIT)
		{
			icon = mVisitingSite.GetVisitingArmy().GetStackByIndex(index).GetStackType().GetIcon();
			mDraggedStack = mVisitingSite.GetVisitingArmy().GetStackByIndex(index);
			mDraggedStackIndex = index;
			mDraggedStackArmyNumber = armyNr;
		}
		else if(armyNr == ARMY_NUMBER_GARRISON)
		{
			icon = mVisitingSite.GetGarrisonArmy().GetStackByIndex(index).GetStackType().GetIcon();
			mDraggedStack = mVisitingSite.GetGarrisonArmy().GetStackByIndex(index);
			mDraggedStackIndex = index;
			mDraggedStackArmyNumber = armyNr;
		}
		else if(armyNr == ARMY_NUMBER_GOVERNORTOWNGUARD)
		{
			icon = mVisitingSite.GetGarrisonArmy().GetStackByIndex(index).GetStackType().GetIcon();
		}
		else if(armyNr == ARMY_NUMBER_CARAVAN)
		{
			icon = mVisitingSite.GetCaravanArmy().GetStackByIndex(index).GetStackType().GetIcon();
		}
		else
		{
			icon = mTown.GetArrivedCaravanByIndexReadOnly( armyNr-ARMY_NUMBER_CARAVAN-1 ).stacks[index].GetStackType().GetIcon();
		}
	}
	else
	{
		if(armyNr == ARMY_NUMBER_VISIT)
		{
			icon = mVisitingSite.GetVisitingArmy().GetHero().GetIcon();
		}
		else if(armyNr == ARMY_NUMBER_GARRISON)
		{
			icon = mVisitingSite.GetGarrisonArmy().GetHero().GetIcon();
		}
		else if(armyNr == ARMY_NUMBER_GOVERNORTOWNGUARD)
		{
			icon = mTown.GetGovernor().GetIcon();
		}
	}

	GetHUD().SetSoftwareCursor(none,rot,,,icon);
}

function SetDraggedSlotInUse()
{
	if(mDraggedStack == none) return;

	mMiddleHUD.SetDraggedSlotInUse(mDraggedStackIndex, mDraggedStackArmyNumber);
}

function RemoveUnitFromCursor()
{
	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("DROP");
	mIsDragginUnit = false;
	mDraggedStack = none;

	GetHUD().UnLoadCursorObject();
}

function SetDraggedSlotUnused()
{	
	mMiddleHud.SetDraggedSlotInUse();
}

function UpgradeCreature(int slotID, bool isVisitor, int count)
{
	;

	if(mVisitingSite.IsA('H7AreaOfControlSiteLord')) H7AreaOfControlSiteLord(mVisitingSite).UpgradeUnit(slotID, isVisitor, count);
	else if(mVisitingSite.IsA('H7Dwelling')) H7Dwelling(mVisitingSite).UpgradeUnit(slotID, isVisitor, count);

	if(	GetHud().GetCurrentContext().IsA('H7TownRecruitmentPopupCntl'))
		H7AdventureHud(GetHUD()).GetTownRecruitmentCntl().UpdateAfterModifyingArmy();
}

function DismissUnit(bool visitor,int index)
{
	;

	if(class'H7ReplicationInfo'.static.GetInstance().mIsTutorial) return;

	mDismissArmy = visitor;
	mDismissIndex = index;
	GetHUD().GetRequestPopupCntl().GetRequestPopup().YesNoPopup( class'H7Loca'.static.LocalizeSave("REALLY_DISMISS","H7General"),class'H7Loca'.static.LocalizeSave("DISMISS","H7General"),class'H7Loca'.static.LocalizeSave("CANCEL","H7General"),DismissConfirm,DismissCancel);
	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("CLICK_COMMAND_BUTTON");
}

function DismissConfirm()
{
	;
	if(mDismissArmy)
	{
		mVisitingSite.GetVisitingArmy().RemoveCreatureStackByIndex(mDismissIndex);
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("CLICK_COMMAND_BUTTON");
	}
	else
	{
		mVisitingSite.GetGarrisonArmy().RemoveCreatureStackByIndex(mDismissIndex);
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("CLICK_INACTIVE_COMMAND_BUTTON");
	}
	mMiddleHUD.StackDismissed();
   
	if(	GetHud().GetCurrentContext().IsA('H7TownRecruitmentPopupCntl'))
		H7AdventureHud(GetHUD()).GetTownRecruitmentCntl().UpdateAfterModifyingArmy();
}

function DismissCancel()
{
	// nothing
}

function SplitToUnknownTarget()
{
	
}

function RequestArmyMerge(int fromArmy,int toArmy)
{	
	;

	if( mVisitingSite != none )
	{
		mVisitingSite.MergeArmies( EArmyNumber( fromArmy ), EArmyNumber( toArmy ) );
	}
}

function CompleteMergeArmies(bool success)
{
	GetMiddleHUD().TransferResult( success );
	if(success) UpdateHUD();

	if( GetHUD().GetCurrentContext() != none )
	{
		if(GetHUD().GetCurrentContext().IsA('H7InscriberPopupCntl'))
			H7InscriberPopupCntl( GetHUD().GetCurrentContext() ).Update(mTown);

		if(GetHUD().GetCurrentContext().IsA('H7ArtifactRecyclerPopupCntl'))
			H7ArtifactRecyclerPopupCntl( GetHUD().GetCurrentContext() ).Update(mTown);

		if(GetHUD().GetCurrentContext().IsA('H7TownWarfarePopupCntl'))
			H7TownWarfarePopupCntl( GetHUD().GetCurrentContext() ).Update(mTown);

		if(	GetHud().GetCurrentContext().IsA('H7TownRecruitmentPopupCntl'))
			H7AdventureHud(GetHUD()).GetTownRecruitmentCntl().UpdateAfterModifyingArmy();
	}
}

function bool CanSwap()
{
	if(!mAllowHeroTransfer) return false;
	if(mVisitingSite.GetGarrisonArmy().GetHero() == none || !mVisitingSite.GetGarrisonArmy().GetHero().IsHero())
	{
		if(mVisitingSite.GetGarrisonArmy().HasCreature()) // block reason 1 - hero-less creature(s) in garrison
		{
			return false;
		}
		if(mVisitingSite.GetVisitingArmy().GetHero() == none || !mVisitingSite.GetVisitingArmy().GetHero().IsHero()) // block reason 2 - no heroes
		{
			return false;
		}
	}
	return true;
}

function RequestHeroTransfer(int fromArmy,int toArmy)
{	
	;
	if(!mAllowHeroTransfer)
	{
		;
		return;
	}

	if(toArmy == ARMY_NUMBER_GOVERNORTOWNGUARD)
	{
		AssignGovernor(fromArmy);
	}
	else
	{
		if(mVisitingSite != none && mVisitingSite.IsA('H7Dwelling'))
		{
			RemoveUnitFromCursor();
			mMiddleHUD.ResetDragAndDrop();
		}
		else if( mVisitingSite != none )
		{
			mVisitingSite.TransferHero( EArmyNumber( fromArmy ), EArmyNumber( toArmy ) );
		}
	}
	mAllowHeroTransfer = false;
	GetHUD().SetSelfMadeTimer(1, allowHeroTransfer);
}

function allowHeroTransfer()
{
	mAllowHeroTransfer = true;
}

function CompleteHeroTransfer(bool success)
{
	GetMiddleHUD().TransferResult( success );
	UpdateHUD();

	if( GetHUD().GetCurrentContext() != none )
	{
		if(GetHUD().GetCurrentContext().IsA('H7InscriberPopupCntl'))
			H7InscriberPopupCntl( GetHUD().GetCurrentContext() ).Update(mTown);

		if(GetHUD().GetCurrentContext().IsA('H7ArtifactRecyclerPopupCntl'))
			H7ArtifactRecyclerPopupCntl( GetHUD().GetCurrentContext() ).Update(mTown);

		if(GetHUD().GetCurrentContext().IsA('H7TownWarfarePopupCntl'))
			H7TownWarfarePopupCntl( GetHUD().GetCurrentContext() ).Update(mTown);

		if(	GetHud().GetCurrentContext().IsA('H7TownRecruitmentPopupCntl'))
			H7AdventureHud(GetHUD()).GetTownRecruitmentCntl().UpdateAfterModifyingArmy();
	}
}

function RequestTransfer(int fromArmy,int fromIndex,int toArmy,int toIndex,optional int splitAmount)
{
	local H7AdventureArmy altArmy;
	local ArrivedCaravan caravan;
			
	;

	// special case 1/2: hero transfer
	if(toIndex == -1 && fromIndex == -1) 
	{
		;
		RequestHeroTransfer(fromArmy,toArmy);
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetMinimap().UpdateVisibility();
	}
	// special case 2/2: split to unknown
	else if(toArmy == -1)
	{
		;

		// determine army, the stack splits to, in case own army is full
		if(fromArmy == ARMY_NUMBER_VISIT || fromArmy == ARMY_NUMBER_CARAVAN)
		{
			altArmy = GetArmy(ARMY_NUMBER_GARRISON);
		}
		else // splitting in garrison
		{
			if(mCaravanHighlight)
			{
				altArmy = GetArmy(ARMY_NUMBER_CARAVAN);
			}
			else
			{
				altArmy = GetArmy(ARMY_NUMBER_VISIT);
			}
		}

		class'H7AdventureArmy'.static.SplitCreatureStackToEmptySlot( GetArmy(fromArmy) , altArmy, fromIndex, splitAmount );		
	}
	// end of special cases (rest is army|stacks --> army|stacks)
	else 
	{
		; // targeted-(split_merge)/(split_move) not supported TODO 
		// army -> stacks (townguard reinforcements)
		if(toArmy == ARMY_NUMBER_GOVERNORTOWNGUARD)
		{
			; // TODO
		}
		// stacks -> army (caravan unload)
		else if(fromArmy > ARMY_NUMBER_CARAVAN)
		{
			;
			caravan = H7AreaOfControlSiteLord(mVisitingSite).GetArrivedCaravanByIndexReadOnly(fromArmy-ARMY_NUMBER_CARAVAN-1);

			RequestTransferCaravanData(caravan,fromIndex,toArmy,toIndex,splitAmount);
			UpdateHUD();
		}
		// army -> army
		else
		{
			;
			if(GetArmy(toArmy) == none)
				GetMiddleHUD().TransferResult(false);
			else
				class'H7EditorArmy'.static.TransferCreatureStacksByArmy( GetArmy(fromArmy), GetArmy(fromArmy) , GetArmy(toArmy) , fromIndex , toIndex , splitAmount, true );
		}
	}
}

function CompleteTransfer(bool success, int targetIndex, H7AdventureArmy altArmy, bool transfer)
{
	if(transfer)
	{
		GetMiddleHUD().TransferResult(success);
	}
	else
	{
		GetMiddleHUD().TransferResult(success,GetArmyNumber(altArmy),targetIndex);
		GetMiddleHUD().UpdateUpgradeButtons(mVisitingSite);
	}

	UpdateHUD();

	if(	GetHud().GetCurrentContext() != none && GetHud().GetCurrentContext().IsA('H7TownRecruitmentPopupCntl'))
	{
		H7AdventureHud(GetHUD()).GetTownRecruitmentCntl().UpdateAfterModifyingArmy();
	}
}

// split currently not supported TODO
function RequestTransferCaravanData( ArrivedCaravan caravan, int fromIndex, int toArmy, int toIndex,optional int splitAmount)
{
	local array<H7BaseCreatureStack> sourceStacks,targetStacks;
	local H7AdventureArmy targetArmy;
	local bool success;

	;

	sourceStacks = caravan.stacks;

	targetArmy = GetArmy(toArmy);

	if(targetArmy == none) 
	{
		;
		return;
	}

	targetStacks = targetArmy.GetBaseCreatureStacks();

	success = class'H7BaseCreatureStack'.static.TransferCreatureStacksByArray(sourceStacks,targetStacks,fromIndex,toIndex);

	if(success)
	{
		targetArmy.SetBaseCreatureStacks(targetStacks);
		targetArmy.CreateCreatureStackProperies();
		
		caravan.stacks = sourceStacks;
		if( H7AreaOfControlSiteLord(mVisitingSite) != none )
		{
			H7AreaOfControlSiteLord(mVisitingSite).SetArrivedCaravanStacks(caravan.index,caravan.stacks);

			if(H7AreaOfControlSiteLord(mVisitingSite).IsCaravanEmpty(caravan.index))
			{
				H7AreaOfControlSiteLord(mVisitingSite).DeleteCaravan(caravan.index);
			}
		
			GetMiddleHUD().TransferResult(true);
			class'H7TownCaravanPopupCntl'.static.GetInstance().UpdateFromLord(H7AreaOfControlSiteLord(mVisitingSite));
		}
	}
}

function int GetArmyNumber(H7AdventureArmy army)
{
	if(army == mVisitingSite.GetVisitingArmy()) return ARMY_NUMBER_VISIT;
	if(army == mVisitingSite.GetGarrisonArmy()) return ARMY_NUMBER_GARRISON;
	if(army == mVisitingSite.GetCaravanArmy()) return ARMY_NUMBER_CARAVAN;
	
	return INDEX_NONE;
}

function H7AdventureArmy GetArmy(int number)
{
	switch(number)
	{
		case ARMY_NUMBER_VISIT:return mVisitingSite.GetVisitingArmy();
		case ARMY_NUMBER_GARRISON:return mVisitingSite.GetGarrisonArmy();
		case ARMY_NUMBER_CARAVAN:return mVisitingSite.GetCaravanArmy();
	}
	;
	return none;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// HUD
///////////////////////////////////////////////////////////////////////////////////////////////////

function UpdateHUD()
{
	//if(mTown != none) mMiddleHUD.SetDataFromTown(mTown);
	//if(mFort != none ) mMiddleHUD.SetDataFromFort(mFort);
	//if(mDwelling != none) mMiddleHUD.SetDataFromDwelling(mDwelling);
	
	if(mVisitingSite != none)
	{
		if(H7Town(mVisitingSite) != none) mMiddleHUD.SetDataFromTown(H7Town(mVisitingSite));
		if(H7Fort(mVisitingSite) != none) mMiddleHUD.SetDataFromFort(H7Fort(mVisitingSite));
		if(H7Dwelling(mVisitingSite) != none) mMiddleHUD.SetDataFromDwelling(H7Dwelling(mVisitingSite));
		if(H7Garrison(mVisitingSite) != none) mMiddleHUD.SetDataFromGarrison(H7Garrison(mVisitingSite));
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Governor
///////////////////////////////////////////////////////////////////////////////////////////////////

function AssignGovernor(int fromArmy)
{
	local H7AdventureHero newGovernor;
	local String confirmMessage;
	local array<H7Town> towns;
	local H7Town town;

	;
	if(fromArmy == ARMY_NUMBER_GARRISON)
	{
		newGovernor = mTown.GetGarrisonArmy().GetHero();
	}
	else if(fromArmy == ARMY_NUMBER_VISIT)
	{
		newGovernor = mTown.GetVisitingArmy().GetHero();
	}

	if(newGovernor == none || !newGovernor.IsHero())
	{
		;
		return;
	}

	;

	// Check if Hero has any Governor related abilities/buffs etc.
	if(!newGovernor.HasGovernorEffect())
	{
		GetHUD().GetRequestPopupCntl().GetRequestPopup().OKPopup(Repl(class'H7Loca'.static.LocalizeSave("GOVERNOR_WRONG","H7Town"), "%h", newGovernor.GetName()), "OK");
		GetMiddleHUD().TransferResult(false);
		return;
	}
	
	// confirm
	class'H7PlayerController'.static.GetPlayerController().UnLoadCursorObject();
	
	confirmMessage = Repl(Repl(class'H7Loca'.static.LocalizeSave("GOVERNOR_CONFIRM","H7Town"),"%h",newGovernor.GetName()),"%t",mTown.GetName());

	if(mTown.GetGovernor() != none)
	{
		if(mTown.GetGovernor().GetID() == newGovernor.GetID())
		{
			GetHUD().GetRequestPopupCntl().GetRequestPopup().OKPopup(Repl(Repl(class'H7Loca'.static.LocalizeSave("GOVERNOR_ALREADY","H7Town"),"%h",newGovernor.GetName()),"%t",mTown.GetName()),"OK",OnGovernorCancel);
			GetMiddleHUD().TransferResult(false);
			return;
		}
		
		confirmMessage = confirmMessage $ "\n\n" $ Repl(Repl(class'H7Loca'.static.LocalizeSave("GOVERNOR_OVERWRITE","H7Town"),"%h",mTown.GetGovernor().GetName()),"%t",mTown.GetName());
	}

	// loop to all cities:
	towns = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber(mTown.GetPlayerNumber()).GetTowns();
	foreach towns(town)
	{
		if(town.GetGovernor() != none)
		{
			;
			if(town.GetGovernor().GetID() == newGovernor.GetID())
			{
				confirmMessage = confirmMessage $ "\n\n" $ Repl(Repl(class'H7Loca'.static.LocalizeSave("GOVERNOR_CANCEL","H7Town"),"%h",town.GetGovernor().GetName()),"%t",town.GetName());
			}
		}
	}

	mPendingNewGovernor = newGovernor;

	GetHUD().GetRequestPopupCntl().GetRequestPopup().YesNoPopup(confirmMessage,"CONFIRM","CANCEL",OnGovernorConfirm,OnGovernorCancel);
}

function OnGovernorConfirm()
{
	local array<H7Town> towns;
	local H7Town town;

	// loop to all cities and remove hero
	towns = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber(mTown.GetPlayerNumber()).GetTowns();
	foreach towns(town)
	{
		if(town.GetGovernor() != none && town.GetGovernor().GetID() == mPendingNewGovernor.GetID())
		{
			town.SetGovernor(none);
		}
	}

	// add to this city
	mTown.SetGovernor(mPendingNewGovernor);
}

function GovernorConfirmComplete()
{
	GetMiddleHUD().TransferResult(true);

	// effects
	GetMiddleHUD().BuildGovernorTooltip(mPendingNewGovernor);
}

function OnGovernorCancel()
{
	GetMiddleHUD().TransferResult(false);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// 
///////////////////////////////////////////////////////////////////////////////////////////////////

function H7TownAsset GetTownAsset(H7TownAsset townAssetArchetype)
{
	local H7TownAsset asset;
	foreach mSpawnedAssets(asset)
	{
		if(asset.GetType() == townAssetArchetype.GetType())
		{
			return asset;
		}
	}
	return none;
}

function RecruitHero( int heroId )
{
	;

	mTown.RecruitHero( heroId );
}

function RecruitHeroComplete(int heroID)
{
	local H7AdventureArmy recruitedArmy;

	recruitedArmy = class'H7AdventureController'.static.GetInstance().GetArmyByHeroID(heroID);
	if(!recruitedArmy.IsGarrisoned())
	{
		class'H7AdventureController'.static.GetInstance().SelectArmy(recruitedArmy,true);
	}

	// update GUI to show garrison army, visitor army, player resources and player armies
	mMiddleHUD.SetDataFromTown(mTown);
	class'H7AdventureController'.static.GetInstance().UpdateHUD();
	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("BUY_HERO");
}

//========================================================================
// Spawns a TownScreen offside the map (above)
//========================================================================
function SpawnTownScreen(Actor PrefabOwner, Prefab PrefabGroup)
{
	mPrefabOwner = PrefabOwner;
	mPrefabGroup = PrefabGroup;

	// Set Camera to use "Town"-Mode
	class'H7Camera'.static.GetInstance().UseCameraTown( mTown.GetTownCameraProperties() ); // this sets camera location to late so next frame is generated wrong
	// lock the camera in townscreen to prevent panning...
	class'H7Camera'.static.GetInstance().LockCamera(true);

	GetHUD().SetFrameTimer(0,SpawnTownScreenForReal);
}

function SpawnTownScreenForReal()
{
	local int i, j;
	local Object prefabObject;
	local Vector spawnLocation,drawscale;
	local Actor spawnActor, spawnMeshActor;
	local EmitterSpawnable spawnEmitter;
	local H7TownScreenLight spawnSpotLight;
	local LightFunction spawnLightFn;
	local H7CameraProperties activeProperties;
	local DynamicSMActor_Spawnable spawnableMeshActor;
	local StaticMeshActor prefabActor;
	local H7TownAsset prefabAsset,archetypeAsset,spawnedAsset;
	local H7TownBuilding building;
	local Actor PrefabOwner;
	local Prefab PrefabGroup;

	if(mTown == none) return; // town was already left before the delayed townscreen could spawn, don't spawn anymore

	PrefabOwner = mPrefabOwner;
	PrefabGroup = mPrefabGroup;

	mPrefabOwner = none;
	mPrefabGroup = none;

	;
	
	activeProperties = class'H7Camera'.static.GetInstance().GetActiveProperties();

	//Use CameraProperties (Town) to determine localization of offside townscreen
	spawnLocation.X = activeProperties.PanXOffset;
	spawnLocation.Y = activeProperties.PanYOffset;
	spawnLocation.Z = activeProperties.PanZOffset;
	;
	
	for (i = 0; i < prefabGroup.PrefabArchetypes.Length; i++)
	{
		//`log_dui("prefabObject" @ i @ "/" @ prefabGroup.PrefabArchetypes.Length);
		prefabObject = prefabGroup.PrefabArchetypes[i];
		if (StaticMeshActor(prefabObject) != none || DynamicSMActor(prefabObject) != none)
		{
			// if we're the first static mesh in the prefab, create the actor
			if ( !prefabObject.IsA('H7TownAsset') )
			{
				;
				spawnMeshActor = class'H7PlayerController'.static.GetPlayerController().Spawn(class'DynamicSMActor_Spawnable', prefabOwner, , spawnLocation + Actor(prefabObject).Location, Actor(prefabObject).Rotation);
				spawnableMeshActor = DynamicSMActor_Spawnable( spawnMeshActor );
				prefabActor = StaticMeshActor(prefabObject);
				spawnMeshActor.bWorldGeometry = true;
				
				spawnableMeshActor.SetDrawScale     ( prefabActor.DrawScale );
				spawnableMeshActor.SetDrawScale3D   ( prefabActor.DrawScale3D );
				spawnableMeshActor.SetCollisionType ( COLLIDE_NoCollision );

				spawnableMeshActor.StaticMeshComponent.SetStaticMesh		( prefabActor.StaticMeshComponent.StaticMesh );
				spawnableMeshActor.StaticMeshComponent.SetTranslation		( prefabActor.StaticMeshComponent.Translation );
				spawnableMeshActor.StaticMeshComponent.SetRotation			( prefabActor.StaticMeshComponent.Rotation );
				spawnableMeshActor.StaticMeshComponent.SetScale				( prefabActor.StaticMeshComponent.Scale );
				spawnableMeshActor.StaticMeshComponent.SetScale3D			( prefabActor.StaticMeshComponent.Scale3D );
				spawnableMeshActor.StaticMeshComponent.SetLightingChannels  ( prefabActor.StaticMeshComponent.LightingChannels );
				
				spawnableMeshActor.StaticMeshComponent.TranslucencySortPriority = prefabActor.StaticMeshComponent.TranslucencySortPriority;

				for ( j = 0; j < prefabActor.StaticMeshComponent.Materials.Length; ++j )
				{
					spawnableMeshActor.StaticMeshComponent.SetMaterial( j, prefabActor.StaticMeshComponent.Materials[j] );
				}
				mSpawnedActors.AddItem( spawnMeshActor );
			}
			else
			{
				prefabAsset = H7TownAsset(prefabObject);
				;
				
				// find any first random match building that is responsible for my slot...
				building = mTown.GetBuildingByPrefabAsset(prefabAsset);
				
				if(building != none)
				{
					;
					
					// I spawn copy of me or my best version in the runtime-townscreen
					archetypeAsset = mTown.GetBestAssetForSlot(building,prefabAsset);
					
					;
					
					// spawn that slot and fill it with the correct material
					spawnMeshActor = class'H7PlayerController'.static.GetPlayerController().Spawn(
							class'H7TownAsset',prefabOwner, ,spawnLocation + prefabAsset.Location,prefabAsset.Rotation,archetypeAsset
						);
					spawnedAsset = H7TownAsset(spawnMeshActor);

					// sometimes the scale is in archetype, sometimes in prefab-instance, get it right in any case
					drawscale.X = FMax( prefabAsset.DrawScale3D.X , archetypeAsset.DrawScale3D.X );
					drawscale.Y = FMax( prefabAsset.DrawScale3D.Y , archetypeAsset.DrawScale3D.Y );
					drawscale.Z = FMax( prefabAsset.DrawScale3D.Z , archetypeAsset.DrawScale3D.Z );
					spawnedAsset.SetDrawScale3D( drawscale );

					spawnedAsset.init();
					spawnMeshActor.bWorldGeometry = true;
					mSpawnedAssets.AddItem( spawnedAsset );

					if(IsInFadeInQueue(building))
					{
						GetHUD().SetFrameTimer(1,spawnedAsset.StartFadeIn);
					}
				}
			}
		}
		else if (Emitter(prefabObject) != none)
		{
			spawnEmitter = prefabOwner.Spawn(
				class'EmitterSpawnable', prefabOwner, , spawnLocation + Actor(prefabObject).Location, Actor(prefabObject).Rotation, 
				EmitterSpawnable(prefabObject), true
			);
			spawnEmitter.SetDrawScale(Emitter(prefabObject).DrawScale);
			spawnEmitter.SetDrawScale3D(Emitter(prefabObject).DrawScale3D);
			spawnEmitter.SetTemplate(Emitter(prefabObject).ParticleSystemComponent.Template);
			spawnEmitter.ParticleSystemComponent.InstanceParameters = Emitter(prefabObject).ParticleSystemComponent.InstanceParameters;
			mSpawnedActors.AddItem( spawnEmitter );
		}
		else if (SpotLight(prefabObject) != none)
		{
			spawnSpotLight = prefabOwner.Spawn(class'H7TownScreenLight', prefabOwner, , spawnLocation + Actor(prefabObject).Location, Actor(prefabObject).Rotation, H7TownScreenLight(prefabObject), true);
			spawnSpotLight.LightComponent.SetLightProperties(SpotLight(prefabObject).LightComponent.Brightness, SpotLight(prefabObject).LightComponent.LightColor);
			PointLightComponent(spawnSpotLight.LightComponent).Radius = PointLightComponent(SpotLight(prefabObject).LightComponent).Radius;
			PointLightComponent(spawnSpotLight.LightComponent).FalloffExponent = PointLightComponent(SpotLight(prefabObject).LightComponent).FalloffExponent;
			SpotLightComponent(spawnSpotLight.LightComponent).InnerConeAngle = SpotLightComponent(SpotLight(prefabObject).LightComponent).InnerConeAngle;
			SpotLightComponent(spawnSpotLight.LightComponent).OuterConeAngle = SpotLightComponent(SpotLight(prefabObject).LightComponent).OuterConeAngle;
			spawnLightFn = new() LightFunction'H7FX_TownScreensWeather.Materials.LF_CloudShadows'.Class(LightFunction'H7FX_TownScreensWeather.Materials.LF_CloudShadows');
			if (spawnLightFn != None)
			{
				spawnSpotLight.LightComponent.SetLightProperties(,, spawnLightFn);
			}
			spawnSpotLight.LightComponent.UpdateColorAndBrightness();
			mSpawnedActors.AddItem( spawnSpotLight );
		}
		else if (H7Creature(prefabObject) != none)
		{
			//`log_gui("There's some H7Creature!");
			spawnActor = prefabOwner.Spawn(class'H7Creature', prefabOwner, , spawnLocation + Actor(prefabObject).Location, H7Creature(prefabObject).Rotation, H7Creature(prefabObject));
			H7Creature(spawnActor).GetSkeletalMesh().SetScale3D( H7Creature(prefabObject).GetSkeletalMesh().Scale3D);
			mSpawnedActors.AddItem( H7Creature(spawnActor) );
		}
		else if(H7EditorWarUnit(prefabObject) != none )
		{
			spawnActor = prefabOwner.Spawn(class'H7EditorWarUnit', prefabOwner, , spawnLocation + Actor(prefabObject).Location, H7EditorWarUnit(prefabObject).Rotation, H7EditorWarUnit(prefabObject));
			//H7EditorWarUnit(spawnActor).GetSkeletalMesh().SetScale3D( H7EditorWarUnit(prefabObject).GetSkeletalMesh().Scale3D);
			mSpawnedActors.AddItem( H7EditorWarUnit(spawnActor) );
		}
		else 
		{
			;
		}
	}
	if(mCurrent3DTownScreen != None)
	{
		mCurrent3DTownScreen.Destroy();
	}
	mCurrent3DTownScreen = spawnMeshActor;

	class'H7EngineUtility'.static.ForceReattachAllComponents(mSpawnedActors);
}

function AddToFadeInQueue(H7TownBuilding building)
{
	mFadeInQueue.AddItem(building);
}

function bool IsInFadeInQueue(H7TownBuilding building)
{
	return mFadeInQueue.Find(building) != INDEX_NONE;
}

//Obviously resets the camera, deletes the spawned town, creatures and other assets
function UnSpawnTownScreen(optional bool onlySwapping=false)
{
	local int i;

	if(mCurrent3DTownScreen.Destroy())
	{
		;	
	}

	if(!onlySwapping)
	{
		class'H7Camera'.static.GetInstance().UseCameraAdventure(); // ~ LockCamera(false) // this Reset() camera which causes wrong location to be set
	}

	for( i = 0; i < mSpawnedActors.Length; ++i )
	{
		mSpawnedActors[i].Destroy();
	}
	for( i = 0; i < mSpawnedAssets.Length; ++i )
	{
		mSpawnedAssets[i].Destroy();
	}
	for( i = 0; i < mParticleSystems.Length; ++i )
	{
		mParticleSystems[i].SetActive( false );
	}

	
	mSpawnedAssets.Length = 0;
	mSpawnedActors.Length = 0;
	mParticleSystems.Length = 0;
}

// flash toggled that caravan<->visit army and informs unreal
function SetCaravanHighlight(bool active)
{
	mCaravanHighlight = active;
	if(!H7AdventureHud(GetHUD()).GetTownRecruitmentCntl().GetRecruitmentPopup().IsVisible()) return;
	if(mTown!=none) H7AdventureHud(GetHUD()).GetTownRecruitmentCntl().UpdateFromLord(mTown);
	if(mFort!=none) H7AdventureHud(GetHUD()).GetTownRecruitmentCntl().UpdateFromLord(mFort);
}

function bool IsCaravanHighlight()
{
	return mCaravanHighlight;
}

