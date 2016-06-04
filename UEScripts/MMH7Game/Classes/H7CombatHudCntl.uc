//=============================================================================
// H7CombatHudCntl
//
// controls the battlemap_hud.swf
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CombatHudCntl extends H7FlashMovieCntl
	dependson(H7StructsAndEnumsNative);

// -- MAIN HUD --

// hud elements
var protected H7GFxInitiativeList         mInitiativeList;
var protected H7GFxCreatureAbilityButtonPanel mCreatureAbilityButtonPanel;
var protected H7GFxCombatMenu             mCombatMenu;
var protected H7GFxDamageTooltipSystem    mDamageTooltipSystem;
var protected H7GFxDeploymentBar          mDeploymentBar;
var protected H7GFxUIContainer            mHeroPanel;
var protected H7GFxTacticsBanner          mTacticsBanner;
var protected H7GFxSimTurnInfo            mTimer;

// initiative unit menu
var protected GFxCLIKWidget WaitButtonHero;
var protected GFxCLIKWidget SpellbookButton;
var protected GFxCLIKWidget HeroAttackButton;

// combat menu
var protected GFxCLIKWidget ChangeCombatButton;
var protected GFxCLIKWidget AutoButton;
var protected GFxClikWidget PauseMenuButton;
var protected GFxClikwidget CheatWindowButton;
// debug command panel
var protected GFxCLIKWidget BtnPlay;
var protected GFxCLIKWidget BtnFastForward;
var protected GFxCLIKWidget BtnFastForward2;
var protected GFxObject mSpeedControls;

// state
var protected bool mBeginCombatOnInit; // In case Combat begins before hud is initialized, remember
var protected bool mIsWaitingForOtherPlayer;
var protected bool mAutoDeployDoneThisFrame;
var protected H7Unit mPrevUnit;

// CreatureAbilityButtons
var protected array<H7BaseAbility> mAbilities;
var protected H7Unit mUnit;
var protected bool mNoAbilityReset;

// Properties
static function H7CombatHudCntl GetInstance() { return class'H7PlayerController'.static.GetPlayerController().GetCombatMapHud().GetCombatHudCntl(); }

function	H7GFxInitiativeList		    GetInitiativeList()         { 	return mInitiativeList; }

function    H7GFxCombatMenu             GetCombatMenu()             {   return mCombatMenu; }
function    H7GFxUIContainer            GetHeroPanel()              {   return mHeroPanel; }
function    H7GFxDamageTooltipSystem    GetDamageTooltipSystem()    {   return mDamageTooltipSystem; }
function    H7GFxTacticsBanner          GetTacticsBanner()          {   return mTacticsBanner; }

function    H7GFxDeploymentBar          GetDeploymentBar()          {   return mDeploymentBar; } 
function    H7GFxCreatureAbilityButtonPanel GetCreatureAbilityButtonPanel() { return mCreatureAbilityButtonPanel;}
function    H7GFxSimTurnInfo            GetTimer()                  {   return mTimer; }
function    bool                        IsWaitingForOtherPlayer()   {   return mIsWaitingForOtherPlayer; }

// Called when the UI is opened to start the movie
function bool Initialize() 
{
	//SetTimingMode(TM_Game); // no visible difference 

	class'H7PlayerController'.static.GetPlayerController().ResetHUDOverCounter();
	;
	// Start playing the movie
    Super.Start();
	// Initialize all objects in the movie
    AdvanceDebug(0); 

	mInitiativeList = H7GFxInitiativeList(mRootMC.GetObject("aUnitMenu", class'H7GFxInitiativeList'));
	mInitiativeList.SetVisibleSave(false);

	mCombatMenu = H7GFxCombatMenu(mRootMC.GetObject("aCombatMenu", class'H7GFxCombatMenu'));
	if(mBeginCombatOnInit) // OPTIONAL CHECK if hack still needed
	{
		mCombatMenu.CombatBegin();
	}
	
	mHeroPanel = H7GFxUIContainer(mRootMC.GetObject("aHeroPanel", class'H7GFxUIContainer'));

	mCreatureAbilityButtonPanel = H7GFxCreatureAbilityButtonPanel(mRootMC.GetObject("aCreatureAbilityButtonPanel", class'H7GFxCreatureAbilityButtonPanel'));
	
	mDamageTooltipSystem = H7GFxDamageTooltipSystem(mRootMC.GetObject("aDamageTooltipSystem",class'H7GFxDamageTooltipSystem'));
	

	// tactics

	mTacticsBanner = H7GFxTacticsBanner( mRootMC.GetObject( "aTacticsBanner", class'H7GFxTacticsBanner' )); 
	mTacticsBanner.SetVisibleSave(false);

	mDeploymentBar = H7GFxDeploymentBar( mRootMC.GetObject( "aDeploymentBar", class'H7GFxDeploymentBar' )); 
	mDeploymentBar.SetVisibleSave(false);

	// Combat

	ChangeCombatButton = GFxCLIKWidget(mHeroPanel.GetObject("mChangeCombatButton", class'GFxCLIKWidget'));
	ChangeCombatButton.AddEventListener('CLIK_click', ChangeCombatButtonClick);
	
	AutoButton = GFxCLIKWidget(mHeroPanel.GetObject("mAutoButton", class'GFxCLIKWidget'));
	AutoButton.AddEventListener('CLIK_click', AutoButtonClick);

	mTimer = H7GFxSimTurnInfo(mRootMC.GetObject("aMPTimer", class'H7GFxSimTurnInfo'));

	// Options&Cheat

	PauseMenuButton = GFxCLIKWidget(mHeroPanel.GetObject("mPauseMenuButton", class'GFxCLIKWidget'));
	PauseMenuButton.AddEventListener('CLIK_click', PauseMenuButtonClick);

	CheatWindowButton = GFxCLIKWidget(mHeroPanel.GetObject("mCheatWindowButton", class'GFxCLIKWidget'));
	CheatWindowButton.AddEventListener('CLIK_click', CheatWindowButtonClick);
	CheatWindowButton.SetVisible(class'H7OptionsManager'.static.GetInstance().GetSettingBool("SHOW_DEBUG_CHEATS"));

	mSpeedControls = mHeroPanel.GetObject("mSpeedControls");
	mSpeedControls.SetVisible(class'H7OptionsManager'.static.GetInstance().GetSettingBool("SHOW_DEBUG_CONTROLS"));

	BtnPlay = GFxCLIKWidget(mSpeedControls.GetObject("mBtnPlay", class'GFxCLIKWidget'));
	BtnPlay.AddEventListener('CLIK_click', BtnPlayClick);
	
	BtnFastForward = GFxCLIKWidget(mSpeedControls.GetObject("mBtnFastForward", class'GFxCLIKWidget'));
	BtnFastForward.AddEventListener('CLIK_click', BtnFastForwardClick);

	BtnFastForward2 = GFxCLIKWidget(mSpeedControls.GetObject("mBtnFastForward2", class'GFxCLIKWidget'));
	BtnFastForward2.AddEventListener('CLIK_click', BtnFastForward2Click);
	
	//SetViewScaleMode(SM_NoScale);

	Super.Initialize();
    
	return true;
}

function BlockInputTemporary() // for when it starts and receives x click events
{
	mInitiativeList.BlockInputTemporary();
	mHeroPanel.BlockInputTemporary(true);
	mCombatMenu.BlockInputTemporary(true);
}

function SetCombatHudCntlVisible(bool visible)
{
	mInitiativeList.SetVisibleSave(visible);
	mCreatureAbilityButtonPanel.SetVisibleSave(visible);
	mCombatMenu.SetVisibleSave(visible);
	mHeroPanel.SetVisibleSave(visible);
	if(mTimer.IsActive()) mTimer.SetVisibleSave(visible);
	
	if(!visible) // hide it when hud is off, but don't show it when hud is on, will turn itself on independantly
	{
		mDeploymentBar.SetVisibleSave(visible); // if I cheat win in tactics phase deploymentbar needs to be hidden
	}
}


/////////////////////////////////////////////////////////////////////////////////////////////////// 
// Deployment Bar ///////////////////////////////////////////////////////////////////////////////// 
/////////////////////////////////////////////////////////////////////////////////////////////////// 

function UnitDroppedOnBar(int id)
{
	;

	class'H7CombatController'.static.GetInstance().PutUnitOnBar(id);
}

function RemoveUnitFromCursor()
{
	GetHUD().UnLoadCursorObject();
}

function UnitPickedFromBar(int id)
{
	;

	if(id < 0) return;

	class'H7CombatController'.static.GetInstance().PutUnitOnCursor(id);
}

/////////////////////////////////////////////////////////////////////////////////////////////////// 
// Initiative Bar ///////////////////////////////////////////////////////////////////////////////// 
/////////////////////////////////////////////////////////////////////////////////////////////////// 

function UnitOver(int id) // overunit
{
	local H7Unit unit;
	local H7CreatureStack stack; 
	local H7IEventManagingObject targetable;

	if(id < 0) return;

	// If the player controller does not know yet, that mouse is over hud, we need to tell it, so that it does not trigger after this function and ruins our UnitOver cursor
	if(!mPlayerController.IsMouseOverHUD())
	{
		mPlayerController.HUDSubElementMouseOverBeforeHudMouseOver();
	}

	if(class'H7CombatController'.static.GetInstance().IsInTacticsPhase())
	{
		// convert index-id to unit
		unit = class'H7CombatController'.static.GetInstance().GetCurrentlyDeployingArmy().GetStackBySourceSlotId(id);
	}
	else
	{
		// convert unit-id to unit
		targetable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( id );
		unit = H7Unit( targetable );
	}

	class'H7CombatMapGridController'.static.GetInstance().ShowHUDUnitOverEffects(unit);
	
	if( unit != none )
	{
		if( unit.GetEntityType() == UNIT_CREATURESTACK )
		{
			stack = H7CreatureStack( unit );
			stack.HighlightStack();
		}
		else if( unit.GetEntityType() == UNIT_WARUNIT )
		{
			H7WarUnit( unit ).HighlightWarfareUnit();
		}
	}
}

function UnitOut(int id)
{
	local H7Unit unit;
	local H7CreatureStack stack; 
	local H7IEventManagingObject targetable;

	if(id < 0) return;

	if(class'H7CombatController'.static.GetInstance().IsInTacticsPhase())
	{
		// convert index-id to unit
		unit = class'H7CombatController'.static.GetInstance().GetCurrentlyDeployingArmy().GetStackBySourceSlotId(id);
	}
	else
	{
		// convert unit-id to unit
		targetable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( id );
		unit = H7Unit( targetable );
	}

	unit.ClearTimer();

	class'H7CombatMapGridController'.static.GetInstance().ShowHUDUnitOverEffects( none );
	
	// do we cursor-exit the unit to the game or to another HUD element?
	class'H7CombatController'.static.GetInstance().GetCursor().ShowNormalHUDCursor(); // we assume to another hud element, if not, frame-game code will overwrite it 1 frame later
	
	if( unit != none )
	{
		if( unit.GetEntityType() == UNIT_CREATURESTACK )
		{
			stack = H7CreatureStack( unit );
			stack.DehighlightStack();
		}
		else if( unit.GetEntityType() == UNIT_WARUNIT )
		{
			H7WarUnit( unit ).DeHighlightWarfareUnit();
		}
	}

}

function UnitUp( int id )
{
	local H7Unit unit;
	local H7IEventManagingObject targetable;

	;

	if( id != -1 )
	{
		targetable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( id );
		unit = H7Unit( targetable );
		if( unit != none )
		{
			unit.ClearTimer();
		}
	}

	// switch back from extended to normal
	class'H7CombatHudCntl'.static.GetInstance().GetDamageTooltipSystem().SwitchToAppropiateState();
}

function UnitDown( int id ) // mouse down (left or right) ; right -> show extend tooltip (loader)
{
	local H7Unit unit;
	local H7IEventManagingObject targetable;

	;
	if(GetHUD().IsRightClickThisFrame()) // right click down
	{
		targetable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( id );
		unit = H7Unit( targetable );

		class'H7CombatHudCntl'.static.GetInstance().GetDamageTooltipSystem().ShowExtentedTooltip(); // starts progress bar

		// then after 500ms I need to send the result again to the tooltip:
		unit.SetTimer(float(class'H7CombatHudCntl'.static.GetInstance().GetDamageTooltipSystem().GetExtendDelayTimeMS()) / 1000.0f,false,'UnitDownLong',self);
	}
}

function UnitDownLong()
{
	;

	// switch from normal to extended
	class'H7CombatHudCntl'.static.GetInstance().GetDamageTooltipSystem().SwitchToAppropiateState();
}

function UnitClick( int id )
{
	local H7Unit unit;
	local H7CreatureStack stack; 
	local H7IEventManagingObject targetable;
	
	;

	if(id < 0) return;

	targetable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( id );
	unit = H7Unit( targetable );
	if(!GetHUD().IsRightClickThisFrame()) // left click/release
	{
		if( unit != none && !mIsWaitingForOtherPlayer)
		{
			if( unit.GetEntityType() == UNIT_CREATURESTACK )
			{
				stack = H7CreatureStack( unit );
				class'H7CombatMapGridController'.static.GetInstance().DoAbility( stack.GetCell() );
				
			}
			else if( unit.GetEntityType() == UNIT_WARUNIT )
			{
				class'H7CombatMapGridController'.static.GetInstance().DoAbility( class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid().GetCellByIntPoint( unit.GetGridPosition() ) );
			}
			HideAbilityPreview("UnitClick");
		}
	}
	else // right click/release
	{
		if( GetHUD().GetPlayTime() - class'H7CombatHudCntl'.static.GetInstance().GetDamageTooltipSystem().GetExtendDelayTimeMS() > GetHUD().GetRightMouseDownSince() )
		{
			// extended tooltip is showing, do nothing on release
			return;
		}
		mPlayerController.GetCombatMapHud().GetUnitInfoCntl().ShowUnitInfo( unit );
	}
}

function UnitUpdateBuffs( int id)
{
	local H7Unit unit;
	local H7IEventManagingObject targetable;

	targetable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( id );
	unit = H7Unit( targetable );

	GetInitiativeList().UpdateBuffs(unit,true);
}

// hover hightlight (white portrait glow)
function HightlightSlots( int unitId )
{
	//`log_dui("HightlightSlot unitID" @ unitId);
	GetInitiativeList().SetHightLight( unitId );
	if(class'H7CombatController'.static.GetInstance().IsInTacticsPhase())
	{
		GetDeploymentBar().SetHighlight( GetStackIndexByID(unitId) );
	}
}
function DehighlightSlots ( int unitId ) 
{
	//`log_dui("DehighlightSlots unitID" @ unitId);
	GetInitiativeList().SetDehightLight( unitId );
	if(class'H7CombatController'.static.GetInstance().IsInTacticsPhase())
	{
		GetDeploymentBar().SetDehighlight( GetStackIndexByID(unitId) );
	}
}

function int GetStackIndexByID( int unitId )
{
	local H7Unit unit;
	local H7CreatureStack stack; 
	local H7IEventManagingObject targetable;
	local int index;
	// get stack by unitId:
	targetable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( unitId );
	unit = H7Unit( targetable );
	stack = H7CreatureStack(unit);
	// get index by stack
	index = class'H7CombatController'.static.GetInstance().GetCurrentlyDeployingArmy().GetCreatureStackIndex(stack);
	return index;
}

// select hightlight (stained glass glow (hero has nothing))
function SelectSlot( int unitId )
{
	if(mIsWaitingForOtherPlayer) return;
	//`log_dui("SelectSlot" @ unitId);
	GetInitiativeList().SetSelect( unitId );
}
function DeselectSlot ( int unitId ) 
{
	//`log_dui("DeselectSlot" @ unitId);
	GetInitiativeList().SetDeselect( unitId ); 
}
/////////////////////////////////////////////////////////////////////////////////////////////////// 
// State Transistions ///////////////////////////////////////////////////////////////////////////// 
/////////////////////////////////////////////////////////////////////////////////////////////////// 

function StartAdvance()
{
	BlockInputTemporary();
	super.StartAdvance();
}

function CombatBegin()
{
	;
	// show initiative bar & HUD
	StartAdvance();
	GetInitiativeList().SetVisibleSave(true);
	GetDeploymentBar().SetVisibleSave(false);
	// change combat menu buttons
	if(mCombatMenu == none)
	{
		// not init yet?
		mBeginCombatOnInit = true;
	}
	else
	{
		mCombatMenu.CombatBegin();
	}
	SetTacticsWaiting(false);
	mTacticsBanner.SetVisibleSave(false);

	UpdateFleeSurrenderButton();
	GetCombatMenu().ActivateFxOnAutoCombatButton(false);
}

function UpdateFleeSurrenderButton()
{
	mCombatMenu.SetBtnFleeSurrenderEnabled(class'H7CombatController'.static.GetInstance().IsSurrenderPossible()||class'H7CombatController'.static.GetInstance().IsFleePossible());
}

function ShowTacticsGUI() // TacticsBegin
{
	;
	StartAdvance();
	GetInitiativeList().SetVisibleSave(false);
	GetCreatureAbilityButtonPanel().SetVisibleSave(false);
	GetCombatMenu().TacticsBegin();
	GetDeploymentBar().SetVisibleSave(true);
	GetDeploymentBar().InitBar();
	GetCombatMenu().ActivateFxOnAutoCombatButton(false);

	InitTacticsBanner(class'H7Loca'.static.LocalizeSave("TACTICS_BANNER_HEADER","H7Combat"),class'H7Loca'.static.LocalizeSave("TACTICS_BANNER_TEXT","H7Combat"));
	mTacticsBanner.SetVisibleSave(true);
}

private function InitTacticsBanner(String header,String text)
{
	mTacticsBanner.ActionScriptVoid("Update");
}
// StartUnitCommand 0 CommandStop 1 EndAction 1 ActivateNextUnit 0/1 FinishActiveUnitTurn 0/1
function SetMyTurn(bool myTurn)
{
	//`log_dui("SetMyTurn" @ myTurn);
	if(!myTurn)
	{
		// disabled buttons
		mIsWaitingForOtherPlayer = true;

		// disable the surrender window so that you can not click it in other peoples turn
		class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().Finish();

		mInitiativeList.EnableTurn(false); 
		mCombatMenu.EnableTurn(false);
		mCreatureAbilityButtonPanel.EnableTurn(false);
		
		if(GetHUD().GetSpellbookCntl().GetPopup().IsVisible())
			GetHUD().GetSpellbookCntl().ClosePopup();

		mDamageTooltipSystem.ShowTooltip(false); // in case timer is finished while I hover something
	}
	else
	{
		// enable buttons
		mIsWaitingForOtherPlayer = false;

		mInitiativeList.EnableTurn(true);
		mCombatMenu.EnableTurn(true);
		mCreatureAbilityButtonPanel.EnableTurn(true);

		if(class'H7CombatController'.static.GetInstance().GetStateName() != 'Tactics')
		{
			UpdateFleeSurrenderButton();
		}
	}
}

// I already have placed or have no tactics skill, but the other player is still placing
function SetTacticsWaiting(bool waiting)
{
	if(waiting)
	{
		GetHUD().GetRequestPopupCntl().GetRequestPopup().NoChoicePopup( class'H7Loca'.static.LocalizeSave("PU_WAIT_TACTICS","H7PopUp") );
		mDeploymentBar.SetVisibleSave(false);
	}
	else
	{
		GetHUD().GetRequestPopupCntl().GetRequestPopup().Finish();
	}
}

// I am waiting for the other players to finish the loading of the map
function SetWaitingForPlayers(bool waiting)
{
	if( waiting )
	{
		GetHUD().GetRequestPopupCntl().GetRequestPopup().NoChoicePopup( class'H7Loca'.static.LocalizeSave("PU_WAIT_LOADING","H7PopUp") );
		mDeploymentBar.SetVisibleSave(false);
	}
	else
	{
		GetHUD().GetRequestPopupCntl().GetRequestPopup().Finish();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////// 
// Hero Actions ///////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////// 

// not used atm
function SpellbookButtonClick(EventData data)
{ 
	SpellbookButtonClickNoParams();
}

// Open spell book function without parameters 
// (since the spell book does not need the EventData from the button).
// Used by hotkey (see H7CombatPlayerController)
function SpellbookButtonClickNoParams()
{
	local H7Unit currentUnit; 

	if(mIsWaitingForOtherPlayer) return;

	//always close UnitInfoWindow by default
	//dont know if this is supposed to happen so i commented it out @ robert
    if(GetHUD().GetCurrentContext() != none && GetHUD().GetCurrentContext().IsA('H7SpellbookCntl'))
	{
		GetHUD().CloseCurrentPopup();
		return;
	}

	currentUnit = class'H7CombatController'.static.GetInstance().GetActiveUnit();
	if( currentUnit.GetEntityType() == UNIT_HERO )
	{
		;
		GetHUD().GetSpellbookCntl().SetData(H7EditorHero(currentUnit));
		GetInitiativeList().SelectSpellbookButton();
	}
	else if( class'H7CombatController'.static.GetInstance().CanHeroDoActionInCreatureTurn() )
	{
		;
		currentUnit = class'H7CombatController'.static.GetInstance().GetActiveUnit().GetCombatArmy().GetHero();
		GetHUD().GetSpellbookCntl().SetData( H7EditorHero(currentUnit) );
		GetInitiativeList().SelectSpellbookButton();
	}
}
     
function HeroAttackButtonClick(EventData data) // keybind: SelectHeroDefaultAttack()
{
	HeroAttackToggle();
}

function HeroAttackToggle()
{
	;
		
	if(mIsWaitingForOtherPlayer) return;

	;
		
	if(GetHUD().GetCurrentContext() != none && GetHUD().GetCurrentContext().IsA('H7SpellbookCntl'))
	{
		GetHud().CloseCurrentPopup();
	}

	if(class'H7CombatController'.static.GetInstance().IsHeroInCreatureTurn()
		&& class'H7CombatController'.static.GetInstance().GetActiveUnit().IsDefaultAttackActive())
	{
		class'H7CombatController'.static.GetInstance().SetPreviousActiveUnit();
		GetInitiativeList().SelectAttackButton(false);
		return;
	}


	// switch control to hero
	if(class'H7CombatController'.static.GetInstance().CanHeroDoActionInCreatureTurn())
	{
		// unprepare active creature ability and unselect button if necessary
		if(!class'H7CombatController'.static.GetInstance().GetActiveUnit().IsDefaultAttackActive())
		{
			class'H7CombatController'.static.GetInstance().GetActiveUnit().ResetPreparedAbility();
			GetCreatureAbilityButtonPanel().SelectAbilityButton(-1);
		}

		;
		class'H7CombatController'.static.GetInstance().SetActiveUnitHero();

		GetInitiativeList().SelectAttackButton();
	}
}

function WaitButtonClick(EventData data) // keybind: DoWait()
{
	if(mIsWaitingForOtherPlayer) return;

	if( class'H7CombatController'.static.GetInstance().GetActiveUnit().GetEntityType() == UNIT_HERO 
		&& !class'H7CombatController'.static.GetInstance().GetActiveUnit().HasWaitClicked() )
	{
		class'H7CombatController'.static.GetInstance().GetActiveUnit().Wait();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////// 
// Global Actions /////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////// 

function ChangeCombatButtonClick(EventData data)
{
	local H7CombatController combatController;
	local H7BaseCreatureStack baseStack;
	
	; // leave this log, bukarest QA needs to trigger it for HOMMVII-4708 // thank you for you understanding

	if(mIsWaitingForOtherPlayer) return;

	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("ENGAGE_COMBAT");

	combatController = class'H7CombatController'.static.GetInstance();
	if( combatController.IsInTacticsPhase() )
	{
		// pressed the button while having creature on the mouse?
		if(combatController.GetGridController().GetSelectedStack() != none )
		{
			baseStack = combatController.GetCurrentlyDeployingArmy().GetBaseStackBySpawnedStack(combatController.GetGridController().GetSelectedStack());
			// having creature from map on mouse -> put back to map
			if(combatController.GetGridController().GetSelectedStack().IsVisible())
			{
				// things that happens on pickup from map needs to be reverted
				baseStack.SetDeployed(true);
				mDeploymentBar.MarkAsDeployed(combatController.GetCurrentlyDeployingArmy().GetBaseCreatureStackIndex(baseStack)); // will clear mUnitOnMouse for flash
			}
			else // having creature from bar on mouse -> put back to bar
			{
				// things that happens on pickup from bar needs to be reverted
				mDeploymentBar.MarkAsUnDeployed(combatController.GetCurrentlyDeployingArmy().GetBaseCreatureStackIndex(baseStack)); // will clear mUnitOnMouse for flash
			}
			// things that happens on pickup need to be reverted
			mDeploymentBar.ClearSelection(); // will clear the stained glass effect on the slot
			RemoveUnitFromCursor();
			combatController.GetGridController().SelectUnit(none,false);
		}



		combatController.NextPlayer();
	}
	else
	{
		OpenFleeSurrenderPopup();
	}
}

function OpenFleeSurrenderPopup()
{
	local H7ResourceQuantity cost;
	local array<H7ResourceQuantity> costArray;
	local string popUpMessage,blockReason;

	if(mIsWaitingForOtherPlayer) return;

	if(!class'H7CombatController'.static.GetInstance().IsSurrenderPossible() && !class'H7CombatController'.static.GetInstance().IsFleePossible())
	{
		UpdateFleeSurrenderButton();
		return;
	}

	if(class'H7AdventureController'.static.GetInstance() == none && class'H7ReplicationInfo'.static.GetInstance().IsCombatMap())
	{
		// DUEL
		class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().YesNoPopup(
			"PU_DUEL_FLEE","YES","NO",FleeFromCombatClick,none
		);
		return;
	}

	cost.Type = class'H7CombatController'.static.GetInstance().GetActiveArmy().GetPlayer().GetResourceSet().GetCurrencyResourceType();
	cost.Quantity = class'H7CombatController'.static.GetInstance().GetActiveArmy().GetSurrenderPrice();
	costArray.AddItem(cost);

	class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().YesNoCostPopup(
		"PU_SURRENDER_OR_FLEE","PU_SURRENDER","PU_FLEE",SurrenderFromCombatClick,FleeFromCombatClick,costArray,true
	);

	if(!class'H7CombatController'.static.GetInstance().IsSurrenderPossible(blockReason))
	{
		class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().SetYesButtonState(false,blockReason);
	}

	if(!class'H7CombatController'.static.GetInstance().IsFleePossible())
	{
		if(class'H7CombatController'.static.GetInstance().ArtifactAllowsFleeSurrender())
		{
			class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().SetNoButtonState(false,"PU_FLEE_DISABLED");
		}
		else
		{
			popUpMessage = class'H7Loca'.static.LocalizeSave("PU_ARTIFACT_DISABLE_FLEE","H7PopUp");
			popUpMessage = Repl(popUpMessage, "%item", class'H7CombatController'.static.GetInstance().GetDisableFleeSurrenderArtifact());
			popUpMessage = Repl(popUpMessage, "%hero", class'H7CombatController'.static.GetInstance().GetHeroWithDisableFleeSurrender());

			class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().SetNoButtonState(false, popUpMessage);
		}
	}
}


function FleeFromCombatClick()
{
	local H7CombatController combatController;

	if(mIsWaitingForOtherPlayer) return;

	combatController = class'H7CombatController'.static.GetInstance();
	combatController.SetActiveUnitCommand_Flee();
	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("FLEE_SURRENDER_SELECTED");
}

function SurrenderFromCombatClick()
{
	local H7CombatController combatController;

	if(mIsWaitingForOtherPlayer) return;

	combatController = class'H7CombatController'.static.GetInstance();
	combatController.SetActiveUnitCommand_Surrender();
	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("FLEE_SURRENDER_SELECTED");
}

function ResetAutoDeployDoneThisFrame()
{
	mAutoDeployDoneThisFrame = false;
}

function AutoButtonClick(EventData data)
{
	local H7CombatController combatController;
	
	; // leave this log, bukarest QA needs to trigger it for HOMMVII-4708 // thank you for you understanding
	
	combatController = class'H7CombatController'.static.GetInstance();

	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("CLICK_TEXT_BUTTON");

	if(combatController.IsInTacticsPhase())
	{
		if(mAutoDeployDoneThisFrame) return;
		
		mAutoDeployDoneThisFrame = true;
		GetHUD().SetFrameTimer(1,ResetAutoDeployDoneThisFrame);

		// auto deploy
		;
		combatController.GetCurrentlyDeployingArmy().AutodeployCreatures();
		combatController.CheckStartable();
		GetDeploymentBar().InitBar();
	}
	else
	{
		// auto combat
		if(CanAutoCombat())
		{
			AutoCombatToggle();
		}
		
	}	
}

protected function H7Player GetAutoCombatPlayer()
{
	local H7CombatController combatController;
	local H7Player thePlayer, attackingPlayer, defendingPlayer;
	
	combatController = class'H7CombatController'.static.GetInstance();

	attackingPlayer = combatController.GetArmyAttacker().GetPlayer();
	defendingPlayer = combatController.GetArmyDefender().GetPlayer();

    if( class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() )
	{
		// multiplayer
		if(H7PlayerReplicationInfo( combatController.GetALocalPlayerController().PlayerReplicationInfo ).GetCombatPlayerType() == COMBATPT_SPECTATOR)
		{
			;
			return none;
		}
		else
		{
			;
			thePlayer = H7PlayerReplicationInfo( combatController.GetALocalPlayerController().PlayerReplicationInfo ).GetPlayer();
		}
	}
	else if( defendingPlayer.GetPlayerType() == PLAYER_AI && attackingPlayer.GetPlayerType() == PLAYER_HUMAN  )
	{
		thePlayer = attackingPlayer;
	}
	else if( attackingPlayer.GetPlayerType() == PLAYER_AI && defendingPlayer.GetPlayerType() == PLAYER_HUMAN )
	{
		thePlayer = defendingPlayer;
	}
	else 
	{
		// hotseat
		;
		thePlayer = combatController.GetActiveArmy().GetPlayer();
	}

	return thePlayer;
}

function bool CanAutoDeploy()
{
	return true;
}

function bool CanAutoCombat()
{
	local bool canAutoCombat;
	local H7CombatController combatController;
	local H7Player attackingPlayer, defendingPlayer;
	
	combatController = class'H7CombatController'.static.GetInstance();

	attackingPlayer = combatController.GetArmyAttacker().GetPlayer();
	defendingPlayer = combatController.GetArmyDefender().GetPlayer();

	canAutoCombat = true;

	// We cannot auto-combat in PvP fights
	if( defendingPlayer.GetPlayerType() == PLAYER_HUMAN && attackingPlayer.GetPlayerType() == PLAYER_HUMAN  )
	{
		canAutoCombat = false;
	}

	// You are spectator, please sit down and watch!
	if( class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() )
	{
		// multiplayer
		if(H7PlayerReplicationInfo( combatController.GetALocalPlayerController().PlayerReplicationInfo ).GetCombatPlayerType() == COMBATPT_SPECTATOR)
		{
			;
			return false;
		}
	}

	return canAutoCombat;
}

function AutoCombatToggle()
{
	local H7Player thePlayer;

	thePlayer = GetAutoCombatPlayer();

	if(thePlayer == none) return;
	if(class'H7CombatController'.static.GetInstance().GetStateName() != 'Combat') return;
	if(!thePlayer.IsControlledByAI())
	{
		
		class'H7PlayerController'.static.GetPlayerController().SetPause(true);
		// is disabled, enable it (if confirmed)
		class'H7Loca'.static.LocalizeSave("PU_ABORT_ACTION","H7PopUp");
		class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().YesNoPopup( 
			class'H7Loca'.static.LocalizeSave("PU_ENABLE_AUTOCOMBAT","H7PopUp"),
			class'H7Loca'.static.LocalizeSave("PU_YES","H7PopUp"),
			class'H7Loca'.static.LocalizeSave("PU_NO","H7PopUp"),
			EnableAutoCombat, 
			QuitPopUpAutoCombat);
		return;
	}
	else
	{
		// is enabled, diable it
		SetAutoCombat(false);
	}
}

function QuitPopUpAutoCombat()
{
	class'H7PlayerController'.static.GetPlayerController().SetPause(false);
}

function EnableAutoCombat()
{
	class'H7PlayerController'.static.GetPlayerController().SetPause(false);
	SetAutoCombat(true);
}

function SetAutoCombat(bool val)
{
	local H7Player thePlayer;
	local H7InstantCommandSetAutoCombat command;
	
	thePlayer = GetAutoCombatPlayer();

	if(thePlayer == none) 
	{
		;
		return;
	}

	command = new class'H7InstantCommandSetAutoCombat';
	command.Init(val, thePlayer);
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);
}

function PauseMenuButtonClick(EventData data)
{
	; // leave this log, bukarest QA needs to trigger it for HOMMVII-4708 // thank you for you understanding

	class'H7PlayerController'.static.GetPlayerController().GetHud().GetPauseMenuCntl().OpenPopup();
	//class'H7CombatHud'.static.GetInstance().GetOptionsMenuCntl().OpenPopup();
}

function CheatWindowButtonClick(EventData data)
{
	if(mIsWaitingForOtherPlayer) return;

	GetHUD().GetCheatWindowCntl().SetData("CombatMap");
}

function BtnPlayClick (EventData data)
{
	class'H7PlayerController'.static.GetPlayerController().ConsoleCommand("slomo 1");
}

function BtnFastForwardClick (EventData data)
{
	class'H7PlayerController'.static.GetPlayerController().ConsoleCommand("slomo 10");
}

function BtnFastForward2Click (EventData data)
{
	class'H7PlayerController'.static.GetPlayerController().ConsoleCommand("slomo 20");
}

/////////////////////////////////////////////////////////////////////////////////////////////////// 
// Ability Tooltip on Mouse when Hovering Targets /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////// 

function ShowAbilityPreview( H7CombatResult result )
{
	if(mIsWaitingForOtherPlayer) return;

	UpdateAbilityPreviewPosition();

	mDamageTooltipSystem.ShowAbilityPreview(result);
}

function UpdateAbilityPreviewPosition()
{
	local Vector2D pos;

	pos = UnrealPixels2FlashPixels(mPlayerController.GetMousePosition());
	mDamageTooltipSystem.SetPosition(pos.X+150,pos.Y+40); // OPTIONAL invetigate offset, or switch to actor based tt

	// and turn it visible without updateing():
	mDamageTooltipSystem.ShowTooltip();
}

function HideAbilityPreview(optional string RequestingFunction)
{
	mDamageTooltipSystem.ShowTooltip(false);
}


/////////////////////////////////////////////////////////////////////////////////////////////////// 
// CreatureAbilityButtonPanel ///////////////////////////////////////////////////////////////////// 
/////////////////////////////////////////////////////////////////////////////////////////////////// 

function SetCreatureAbilityData(H7Unit unit)
{
	if(H7CombatHero(unit) != none)
	{
		;
		return;
	}

	SetCreatureAbilities(unit);
	
	mCreatureAbilityButtonPanel.SetData(mAbilities,mPrevUnit == unit);
	mPrevUnit = unit;
}

private function SetCreatureAbilities(H7unit unit)
{
	local array<H7BaseAbility>  abilities;
	local H7BaseAbility         ability;

	if(H7CombatHero(unit) != none)
	{
		;
		return;
	}

	mAbilities.Remove(0, mAbilities.Length);
	unit.GetAbilityManager().GetAbilities( abilities );

	foreach abilities(ability)
	{
		// We don't want in the CreatureAbilityButtonPanel: Passives, StandardMelee, StandardRanged
		if(ability.IsPassive())                                                                                                 continue;
		if(unit.GetMeleeAttackAbility()             != none     && ability.IsEqual(unit.GetMeleeAttackAbility()))               continue;
		if(unit.GetRangedAttackAbility()            != none     && ability.IsEqual(unit.GetRangedAttackAbility()))              continue;
		
		mAbilities.AddItem(ability);
	}
	
	mUnit = unit;
	mAbilities.Sort(AbilityCompare);
}

function int AbilityCompare(H7BaseAbility a,H7BaseAbility b) // to sort wait and defend to be first
{
	if(mUnit != none && b.IsEqual(mUnit.GetWaitAbility())) return -1;
	if(mUnit != none && H7CreatureStack(mUnit) != none && b.IsEqual(H7CreatureStack(mUnit).GetDefendAbility()) && !a.IsEqual(mUnit.GetWaitAbility())) return -1;
	return 0;
}

// defend and wait are now in here
function BtnAbilityClicked(int btnNumber)
{
	local bool success;
	
	;
	if(mIsWaitingForOtherPlayer) return;
	if(!class'H7CombatController'.static.GetInstance().AllowCurrentUnitAction())
	{
		;
		return;
	}

	if(class'H7CombatController'.static.GetInstance().GetInitiativeQueue().GetActiveUnit().GetPreparedAbility().IsEqual(mAbilities[btnNumber]) && !mNoAbilityReset )
	{
		class'H7CombatController'.static.GetInstance().GetInitiativeQueue().GetActiveUnit().ResetPreparedAbility();
		GetCreatureAbilityButtonPanel().SelectAbilityButton(-1);
		return;
	}

	if(mAbilities[btnNumber].CanCast())
	{

		// BugFix: In case we press the creature ability button when its a hero turn.
		if ( class'H7CombatController'.static.GetInstance().IsHeroInCreatureTurn() )
		{
			class'H7CombatController'.static.GetInstance().GetInitiativeQueue().GetActiveUnit(true).ResetPreparedAbility();
			class'H7CombatController'.static.GetInstance().SetPreviousActiveUnit();
		}
		else if( !mNoAbilityReset )
		{
			class'H7CombatController'.static.GetInstance().GetInitiativeQueue().GetActiveUnit().ResetPreparedAbility();
		}

		mNoAbilityReset = false;
		success = class'H7CombatController'.static.GetInstance().SetActiveUnitCommand_PrepareAbility( mAbilities[btnNumber] );

		if(success)
		{
			GetCreatureAbilityButtonPanel().SelectAbilityButton(mAbilities[btnNumber].GetID());
		}
	}
	else
	{
		; 
	}
}

function HighlightButtonFor( H7BaseAbility ability, optional bool noReset = false )
{
	local int idx;

	mNoAbilityReset = noReset;

	//idx = mAbilities.Find( ability );
	for( idx = 0; idx < mAbilities.Length; ++idx )
	{
		if( mAbilities[idx].IsEqual( ability ) )
		{
			break;
		}
	}

	if( idx != -1 && idx < mAbilities.Length )
	{
		BtnAbilityClicked( idx );
	}
}

// to hide the panel when combat ends
function HideCreatureAbilityButtons()
{
	mCreatureAbilityButtonPanel.SetVisibleSave(false);
}

function ShowCreatureAbilityButtons()
{
	mCreatureAbilityButtonPanel.SetVisibleSave(true);
}


////////////////////////////////////////////////////////////////////////////////////////////////
// Unit info ///////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

function GetStatModSourceList(String statStr,int unrealID)
{
	local H7Unit unit;
	local EStat stat;
	local array<H7StatModSource> mods;
	local H7GFxUnitInfo window;
	local int i;

	;
	
	if(H7CombatHud(GetHUD()).GetUnitInfoCntl().GetUnitInfoAttacker().GetCurrentlyDisplayedUnit() != none && H7CombatHud(GetHUD()).GetUnitInfoCntl().GetUnitInfoAttacker().GetCurrentlyDisplayedUnit().GetID() == unrealID)
	{
		window = H7CombatHud(GetHUD()).GetUnitInfoCntl().GetUnitInfoAttacker();
	}
	else if(H7CombatHud(GetHUD()).GetUnitInfoCntl().GetUnitInfoDefender().GetCurrentlyDisplayedUnit() != none && H7CombatHud(GetHUD()).GetUnitInfoCntl().GetUnitInfoDefender().GetCurrentlyDisplayedUnit().GetID() == unrealID)
	{
		window = H7CombatHud(GetHUD()).GetUnitInfoCntl().GetUnitInfoDefender();
	}
	else
	{
		;
		return;
	}

	unit = window.GetCurrentlyDisplayedUnit();

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

	mods = unit.GetStatModSourceList(stat);

	window.SetStatModSourceList(mods);
}

// via flash button - closed UnitInfo window
function Closed(String infoWindowName)
{
	if(infoWindowName == "aUnitInfoAttacker")
	{   
		H7CombatHud(GetHUD()).GetUnitInfoCntl().GetUnitInfoAttacker().Hide();
	}
	else if(infoWindowName == "aUnitInfoDefender")
	{
		H7CombatHud(GetHUD()).GetUnitInfoCntl().GetUnitInfoDefender().Hide();
	}
	else if(infoWindowName == "aObstacleInfo")
	{
		H7CombatHud(GetHUD()).GetUnitInfoCntl().GetObstacleInfo().Hide();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////
// Drag&Drop&Split for tactics /////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

// all right we have 3 data structures that need to be in sync
// drag&drop&split works on (1) mBaseCreatureStacks
// once they are changed:
// (2) Deployment is deleted and recreated from scratch based on the new mBaseCreatureStacks
// (3) mCreatureStacks have to be changed to by in sync with mBaseCreatureStacks
// then the (4) GUI is destroyed and recreated as well based on (2) Deployment

function RequestTransfer(int fromArmy,int fromIndex,int toArmy,int toIndex,optional int splitAmount) 
{
	local H7CombatArmy army;
	
	if(!class'H7CombatController'.static.GetInstance().IsInTacticsPhase()) return;
	// army counts as one combined-army with fromArmy=toArmy=1, so we have to use index to distinguish army from localguard
	if(fromIndex < 9 && toIndex >= 9) return; // transfer from army to guard not allowed
	if(fromIndex >= 9 && toIndex < 9) return; // transfer from guard to army not allowed
	if(fromArmy == toArmy && fromIndex == toIndex) return; // transfer from to same slot not allowed
	if(toIndex >= 9 || fromIndex >= 9) return; // any transfer from, to and within and split guard not allowed // TODO re-enable when fixed

	army = class'H7CombatController'.static.GetInstance().GetCurrentlyDeployingArmy();

	// index defines slot number, can be -1 if units are being split, because then there is no dropSlot set
	if( toIndex != -1 )
	{
		class'H7EditorArmy'.static.TransferCreatureStacksByArmy(army, army,army,fromIndex,toIndex,splitAmount);
	}
	else
	{
		class'H7EditorArmy'.static.SplitCreatureStackToEmptySlot( army, army, fromIndex, splitAmount );
	}

	// a creature was selected while it was on the mouse, but now it is no longer selected
	class'H7CombatMapGridController'.static.GetInstance().TacticsReleaseUnit(true);
}

function CompleteTransfer(bool success, bool transfer)
{
	;

	// (4) GUI is destroyed and recreated
	mDeploymentBar.InitBar(); // displays "Deployment"

	// (5) remove icon from cursor, because flash does not do it, because InitBar() deletes the drag slot
	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("DROP");
	GetHUD().UnLoadCursorObject();

}



