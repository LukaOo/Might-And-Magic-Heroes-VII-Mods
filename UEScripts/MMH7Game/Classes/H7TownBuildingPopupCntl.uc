class H7TownBuildingPopupCntl extends H7FlashMovieTownPopupCntl;

var protected H7GFxTownBuildingPopup mBuildingPopup;
var protected bool mUpdateAfterBuildingPending;
var protected bool mIsConfirmPopupVisible;

static function H7TownBuildingPopupCntl GetInstance() { return class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownBuildingCntl(); }

function H7GFxTownBuildingPopup GetBuildingPopup()  { return mBuildingPopup; }
function H7GFxUIContainer       GetPopup()          { return mBuildingPopup; }

function bool Initialize()
{
	;
	
	LinkToTownPopupContainer();

	// for memory tracking reasons temp. outside
	//Super.Start();
	//AdvanceDebug(0);
	//LoadComplete();
	//Super.Initialize();

	return true;
}

function LoadComplete()
{
	mBuildingPopup = H7GFxTownBuildingPopup(mRootMC.GetObject("aTownBuildingPopup", class'H7GFxTownBuildingPopup'));
	mBuildingPopup.SetVisibleSave(false);
}

function InitWindowKeyBinds()
{
	CreatePopupKeybind('Enter',"BuildConfirm",BuildConfirm,'SpaceBar');

	super.InitWindowKeyBinds();
}

function Update(H7Town currentTown)
{
	mTown = currentTown;
	
	mBuildingPopup.SetData(mTown);
	mBuildingPopup.SetTownLevel(mTown.GetLevel());

	OpenPopup();
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// BUILD
///////////////////////////////////////////////////////////////////////////////////////////////////

function SetConfirmPopupVisible(bool val)
{
	mIsConfirmPopupVisible = val;

	if(val)
	{
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("CLICK_COMMAND_BUTTON");
	}
}

function BuildConfirm()
{
	if(mIsConfirmPopupVisible)
	{
		mBuildingPopup.ActionScriptVoid("ExecuteBuild"); // flash calls BuildBuilding
	}
}

function bool BuildBuilding(string buildingName)
{
	if(GetHUD().IsRightClickThisFrame() || GetHUD().IsRightMouseDown()) return false;
	
	;
	return mTown.BuildBuilding(buildingName);
}

// postbuilding 1) Update Building Popup after building
function BuildBuilingComplete()
{
	mUpdateAfterBuildingPending = true;
	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("CREATE_BUILDING");
	mBuildingPopup.UpdateAfterBuilding(mTown); // flash calls: BuildBuildingPopupAnimationFinished
}

// postbuilding 2) flash plays slot animations and level animations

// postbuilding 3) Update Town HUD after building
// postbuilding 4) Update Townscreen (ZoomOutAndBuild()) and Quickbar
function BuildBuildingPopupAnimationFinished()
{
	local array<H7TownBuildingData> buildings;
	
	;

	mUpdateAfterBuildingPending = false;

	if( H7AdventureHud(GetHUD()).GetCurrentContext() == self)
	{
		mBuildingPopup.SetData(mTown);
		//ClosePopup();
	}

	if( H7AdventureHud(GetHUD()).GetTownHudCntl().IsInTownScreen())
	{
		H7AdventureHud(GetHUD()).GetTownHudCntl().ZoomOutAndBuild(); // --> postbuilding 4)
		class'H7AdventureController'.static.GetInstance().UpdateHUD(,class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetLastSelectedArmy());
		H7AdventureHud(GetHUD()).GetTownHudCntl().GetTownInfo().SetData(mTown);
		H7AdventureHud(GetHUD()).GetTownHudCntl().GetMiddleHUD().SetDataFromTown(mTown, true);
	}

	// find out which building was built to make quick bar buttons glow
	buildings = mTown.GetBuildings();
	switch (buildings[buildings.Length -1].Building.GetPopup())
	{
		case POPUP_RECRUIT :    class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().GetMiddleHUD().StartQuickSlotGlow(buildings[buildings.Length -1].Building.GetPopup(), class'H7Loca'.static.LocalizeSave("NEW_UNITS","H7Town"));				 
								break;
		case POPUP_MAGICGUILD : class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().GetMiddleHUD().StartQuickSlotGlow(buildings[buildings.Length-1].Building.GetPopup(), class'H7Loca'.static.LocalizeSave("NEW_SPELLS","H7Town"));
								class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetMagicGuildCntl().GetMagicGuildPopup().NewSpellsByUpgrade();
								break;
		case POPUP_MARKETPLACE: class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().GetMiddleHUD().StartQuickSlotGlow(buildings[buildings.Length-1].Building.GetPopup(), class'H7Loca'.static.LocalizeSave("TRADING_AND_CARAVANS","H7Town"));
								break;
		case POPUP_WARFARE   :  class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().GetMiddleHUD().StartQuickSlotGlow(buildings[buildings.Length-1].Building.GetPopup(), class'H7Loca'.static.LocalizeSave("NEW_WARFAREUNITS","H7Town"));
								break;						
								// TODO more
	}   
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// DESTROY
///////////////////////////////////////////////////////////////////////////////////////////////////

function DestroyLevel()
{
	class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().YesNoPopup("PU_DESTORY_CONFIRM","YES","NO",OnDestroyConfirm,none);
}

function OnDestroyConfirm()
{
	if( mTown != none )
	{
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("DESTROY_BUILDING_LEVEL");
		mTown.DestroyBuildingsOfLevel( mTown.GetHighestBuildingLevel());
	}
}

function DestroyLevelComplete()
{
	if( mTown != none )
	{
		Update( mTown );

		class'H7TownHudCntl'.static.GetInstance().UpdateAfterDestroy();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// MISC
///////////////////////////////////////////////////////////////////////////////////////////////////

function SaveGUIConfig(string guiConfig)
{
	;
	;

	if(mTown != none)
	{
		mTown.GetFaction().SetTownBuildTreeLayout(guiConfig);
	}
	else
	{
		;
		scripttrace();
	}
}

function ClosePopup()
{
	if(mIsConfirmPopupVisible)
	{
		mBuildingPopup.CloseConfirmPopup();

		return;
	}

	if(mUpdateAfterBuildingPending)
	{
		BuildBuildingPopupAnimationFinished();
	}

	super.ClosePopup();
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Heropedia
///////////////////////////////////////////////////////////////////////////////////////////////////

function OpenCreatureInfo(string creatureArchetypeName)
{
	class'H7HeropediaCntl'.static.GetInstance().OpenHeropediaWithCreature(creatureArchetypeName);
}

