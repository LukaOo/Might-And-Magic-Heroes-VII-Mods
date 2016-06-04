//=============================================================================
// H7CombatPlayerController
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CombatPlayerController extends H7PlayerController
	config(Game)
	native;

// maximum number of int params for instant commands. !Defined twice!
const INSTANT_COMMAND_MAX_INT_PARAMS = 8;
// maximum number of int params for normal commands.
const NORMAL_COMMAND_MAX_INT_PARAMS = 15;
// maximum length of a path, Multiplayer
const MP_MAX_PATH_LENGTH = 25;
// maximum length of an extended path, Multiplayer
const MP_MAX_EXT_PATH_LENGTH = 100;
// maximum number of units that can be targeted by an ability, Multplayer
const MP_MAX_TARGET_UNITS = 16;
// maximum number of units that an army can have, the first element stores the current number of units, 1 (num units) + 8 units
const MP_MAX_ARMY_UNITS = 15;

var protected bool mIgnoreAddToSimTurnQueue;
var protected float mLastTimeSynchedUpArmies;

simulated function NotifyHostMigrationStarted()
{
	class'H7ReplicationInfo'.static.PrintLogMessage("Host Migration Started...", 0);;
}

/**
 * gets the PlayerController to see what buttons are pressed atm
 */
static function H7CombatPlayerController GetCombatPlayerController()
{
	local H7CombatPlayerController MyPlayerController;
	local WorldInfo MyWorld;

	MyWorld = class'WorldInfo'.static.GetWorldInfo();
	if (MyWorld != None)
	{
		MyPlayerController = H7CombatPlayerController(MyWorld.GetALocalPlayerController());
	}
	return MyPlayerController;
}

exec function LeftMouseDown()
{
	if( IsInputAllowed() && WorldInfo.GRI.bMatchHasBegun && !WorldInfo.GRI.bMatchIsOver 
		&& class'H7CombatController'.static.GetInstance() != none
		&& class'H7CombatController'.static.GetInstance().GetCommandQueue().GetQueueLength() == 0 
		&& !class'H7CombatController'.static.GetInstance().GetCommandQueue().IsCommandRunning() )
	{
		;
		// combat and tactics go both here but will do different things with the current unit under the cursor
		//      currentUnit in combat = selected/active unit
		//      currentUnit in tactics = unit under cursor
		class'H7CombatMapGridController'.static.GetInstance().DoCurrentUnitAction();
	}
}


exec function ReleaseLeftMouse() 
{
	if( IsInputAllowed() && WorldInfo.GRI.bMatchHasBegun && !WorldInfo.GRI.bMatchIsOver )
	{
		class'H7CombatMapGridController'.static.GetInstance().TacticsReleaseUnit();
	}

	//GetHud().SetRightClickThisFrame(true);
	//GetHud().SetRightMouseDown(false);
}

// rightclick right click

exec function RightMouseDown()
{
	GetHud().SetRightClickThisFrame(true);
	GetHud().SetRightMouseDown(true); // read every frame by tooltip

	MouseRotationAllowed = true;

	//Reset teleport target
	if(class'H7CombatController'.static.GetInstance().GetActiveUnit().GetPreparedAbility().IsTeleportSpell() && !class'H7BaseGameController'.static.GetBaseInstance().GetCommandQueue().IsCommandRunning())
	{
		class'H7ReplicationInfo'.static.GetInstance().SetTeleportTargetID( -1 );
	}
}

exec function ReleaseRightMouse()
{
	local H7Unit unit;
	local H7CombatHero hero; 
	local H7WarUnit warunit;
	local H7CombatObstacleObject obstacle;
	local Vector hitLocation;
	local H7IEffectTargetable target;

	GetHud().SetRightClickThisFrame(true);
	GetHud().SetRightMouseDown(false);

	if(GetHud().GetOptionsMenuCntl().GetOptionsMenu().IsVisible()) return;
	if(GetHud().GetCurrentContext().IsBlockingUnreal()) return;

	if( WorldInfo.GRI.bMatchHasBegun && !WorldInfo.GRI.bMatchIsOver )
	{
		if( GetHud().GetPlayTime() - class'H7CombatHudCntl'.static.GetInstance().GetDamageTooltipSystem().GetExtendDelayTimeMS() > GetHud().GetRightMouseDownSince() )
		{
			// extended tooltip is showing, do nothing on release
			return;
		}

		if( IsMouseOverHUD() )
		{
			// I am over the unitinfo window, or other gui, should not trigger rightclick on 3d world units
			return;
		}

		// Creature info window
		// dont use the optimization because breaks some tooltip, just leave this like it is (optimization on ReleaseRightMouse is not needed)
		target = class'H7CombatMapGridController'.static.GetInstance().GetMouseOverTarget( hitLocation );
		if( H7CombatMapCell( target ) != none )
			target = H7CombatMapCell( target ).GetUnit();
		else
			unit = H7Unit( target );
		if( unit != none )
		{
			GetCombatMapHud().GetUnitInfoCntl().ShowUnitInfo( unit );
			return;
		}
		// Hero info window
		hero = H7CombatHero( target );
		if( hero != none )
		{
			GetCombatMapHud().GetUnitInfoCntl().ShowUnitInfo( hero );
			return;
		}
		// warunit info window
		warunit = H7WarUnit( target );
		if( warunit != none )
		{
			GetCombatMapHud().GetUnitInfoCntl().ShowUnitInfo( warunit );
			return;
		}

		// Obstacle info window
		obstacle = H7CombatObstacleObject(target);
		if( obstacle != none ) 
		{
			if( obstacle.IsA('H7CombatMapTower') )
			{
				GetCombatMapHud().GetUnitInfoCntl().ShowUnitInfo( H7CombatMapTower(obstacle).GetTowerUnit() );
				return;
			}
			else if( obstacle.IsA('H7CombatMapWall') || obstacle.IsA('H7CombatMapGate') )
			{
				GetCombatMapHud().GetUnitInfoCntl().ShowObstacleInfo(obstacle);
				return;
			}
		}
		// no object was under the mouse, no info window was opened

		//GetHud().GetSpellbookCntl().SetActive(false); // right click closes spellbook (this was ever designed??)
		CancelSpellOnMouse();
	}
}

function CancelSpellOnMouse()
{
	local H7Unit activeUnit;

	if( class'H7BaseGameController'.static.GetBaseInstance().GetCommandQueue().IsCommandRunning() )
		return;

	//cancel spell on mouse
	activeUnit = class'H7CombatController'.static.GetInstance().GetActiveUnit();
	if(!activeUnit.GetPlayer().IsControlledByLocalPlayer())
	{
		return;
	}

	if( activeUnit.HasPreparedAbility() && !activeUnit.IsDefaultAttackActive() )
	{
		activeUnit.ResetPreparedAbility();
		GetHud().GetSpellbookCntl().GetQuickBar().UnSelectSpell();
		GetHud().GetSpellbookCntl().RemoveSpellFromCursor();
			
		if( class'H7CombatController'.static.GetInstance().GetActiveArmy().GetPlayer().IsControlledByLocalPlayer() )
		{
			class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("REMOVE_SPELL_ICON");
		}

		class'H7PlayerController'.static.GetPlayerController().GetCombatMapHud().GetCombatHudCntl().GetInitiativeList().SelectSpellbookButton(false);
	}
		
	// set back the previous creature when the hero took the creature's turn
	if( class'H7CombatController'.static.GetInstance().IsHeroInCreatureTurn() )
	{
		class'H7CombatController'.static.GetInstance().SetPreviousActiveUnit();
		class'H7PlayerController'.static.GetPlayerController().GetCombatMapHud().GetCombatHudCntl().GetInitiativeList().SelectAttackButton(false);
	}
	else // hero alone or creature alone
	{
		activeUnit = class'H7CombatController'.static.GetInstance().GetActiveUnit();
		if(activeUnit.IsA('H7EditorHero'))
			class'H7PlayerController'.static.GetPlayerController().GetCombatMapHud().GetCombatHudCntl().GetInitiativeList().SelectAttackButton(true);
		else
			class'H7PlayerController'.static.GetPlayerController().GetCombatMapHud().GetCombatHudCntl().GetCreatureAbilityButtonPanel().SelectAbilityButton(-1);
	}
}

exec function ContinueContextOrChat()
{
	if(GetHud().GetLogCntl().GetLog().IsVisible())
	{
		GetHud().GetLogCntl().GetLog().ActivateChatInput();
	}
}

exec function DoDefend() // or skip
{
	if(GetHud().IsFocusOnInput()) return;

	// don't defend while on an Adventure Map or during another player's turn
	if(class'H7ReplicationInfo'.static.GetInstance().IsCombatMap()
		&& !GetCombatMapHud().GetCombatHudCntl().IsWaitingForOtherPlayer()
		&& class'H7CombatController'.static.GetInstance().GetActiveUnit().HasFullAction()
		&& !class'H7CombatController'.static.GetInstance().GetCommandQueue().IsCommandRunning()
		&& class'H7CombatController'.static.GetInstance().AllowCurrentUnitAction())
	{
		if(class'H7CombatController'.static.GetInstance().GetActiveUnit().GetEntityType() == UNIT_WARUNIT)
		{
			H7WarUnit(class'H7CombatController'.static.GetInstance().GetActiveUnit()).DoSkip();
		}
		else
		{
		class'H7CombatController'.static.GetInstance().GetActiveUnit().Defend();
	}
}
}

exec function DoWait()
{
	if(GetHud().IsFocusOnInput()) return;

	// only wait...
	if(class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() // ... when in combat
		&& GetCombatMapHud() != none && GetCombatMapHud().GetCombatHudCntl() != none // and we actually have a goddamn hud 
		&& !GetCombatMapHud().GetCombatHudCntl().IsWaitingForOtherPlayer() // ... when it's your turn
		&& class'H7CombatController'.static.GetInstance().GetActiveUnit().HasFullAction() // if the creature has both an attack and movement point
		&& !class'H7CombatController'.static.GetInstance().GetActiveUnit().HasWaitClicked() // ... if the creature didn't wait already this turn
		&& !class'H7CombatController'.static.GetInstance().GetCommandQueue().IsCommandRunning() // ... if the creature doesn't do another action already
		&& !class'H7CombatController'.static.GetInstance().GetActiveUnit().IsMoralTurn() // ... during normal turns, NOT moral turns
		&& class'H7CombatController'.static.GetInstance().AllowCurrentUnitAction())
	{
		class'H7CombatController'.static.GetInstance().GetActiveUnit().Wait();
	}
}

exec function OpenSpellBook()
{
	local bool isOpen;

	if(GetHud().IsFocusOnInput()) return;
	// is the current map a combat map? if yes, open the spellbook here
	// if not, let H7AdventurePlayerController handle it
	if(class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() && GetHud() != none)
	{
		isOpen = (H7SpellbookCntl( GetHud().GetCurrentContext()) != none );
		GetHud().CloseCurrentPopup();
		if(!isOpen)
		{
			// just call the button function which does all the checks for other players etc.
			GetCombatMapHud().GetCombatHudCntl().SpellbookButtonClickNoParams();
		}
	}
}

exec function ToggleMenu() // it's really: Cancel current window/action, Escape
{
	local H7Unit activeUnit;

	;

	if(class'H7CameraActionController'.static.GetInstance().CanCancelCurrentCameraAction())
	{
		class'H7CameraActionController'.static.GetInstance().CancelCurrentCameraAction();
		return;
	}

	if(GetHUD().GetPauseMenuCntl().IsOpen() && GetHUD().GetPauseMenuCntl().CustomDifficultyPopUpOpen())
	{
		GetHUD().GetPauseMenuCntl().CloseCustomDifficultyPopUp();
		return;
	}

	if(class'H7ReplicationInfo'.static.GetInstance().IsCombatMap())
	{
		// is spectator mode
		if(H7CombatHUD(GetHUD()).GetSpectatorHUDCntl().GetPopup().IsVisible())
		{   
			if(GetHUD().GetOptionsMenuCntl().GetPopup().IsVisible())
			{
				GetHUD().GetOptionsMenuCntl().ClosePopup();
				return;
			}
			if(!GetHUD().GetPauseMenuCntl().GetPopup().IsVisible())
				GetHud().GetPauseMenuCntl().OpenPopup();
			else
				GetHUD().GetPauseMenuCntl().ClosePopup();
			return;
		}
		
		if( GetHud().IsFocusOnInput() )
		{
			GetHud().LoseFocusOnInput();
			return;
		}

		activeUnit = class'H7CombatController'.static.GetInstance().GetActiveUnit();
		if(activeUnit != none && !class'H7BaseGameController'.static.GetBaseInstance().GetCommandQueue().IsCommandRunning()
			&& ( (activeUnit.HasPreparedAbility() && (!activeUnit.IsDefaultAttackActive() || activeUnit.GetEntityType() == UNIT_HERO))
			|| GetHud().GetSpellbookCntl().HasSpellOnCursor()))
		{
			// cancel ability
			activeUnit.ResetPreparedAbility();
			// remove spell from cursor
			GetHud().GetSpellbookCntl().GetQuickBar().UnSelectSpell();
			GetHud().GetSpellbookCntl().RemoveSpellFromCursor();
			class'H7PlayerController'.static.GetPlayerController().GetCombatMapHud().GetCombatHudCntl().GetInitiativeList().SelectSpellbookButton(false);

			if( class'H7CombatController'.static.GetInstance().GetActiveArmy().GetPlayer().IsControlledByLocalPlayer() )
			{
				class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("REMOVE_SPELL_ICON");
			}

			// set back the previous creature when the hero took the creature's turn
			if( class'H7CombatController'.static.GetInstance().IsHeroInCreatureTurn() )
			{
				class'H7CombatController'.static.GetInstance().SetPreviousActiveUnit();
				class'H7PlayerController'.static.GetPlayerController().GetCombatMapHud().GetCombatHudCntl().GetInitiativeList().SelectAttackButton(false);
			}
			else // hero alone or creature alone
			{
				activeUnit = class'H7CombatController'.static.GetInstance().GetActiveUnit();
				if(activeUnit.IsA('H7EditorHero'))
					class'H7PlayerController'.static.GetPlayerController().GetCombatMapHud().GetCombatHudCntl().GetInitiativeList().SelectAttackButton(true);
				else
					class'H7PlayerController'.static.GetPlayerController().GetCombatMapHud().GetCombatHudCntl().GetCreatureAbilityButtonPanel().SelectAbilityButton(-1);
			}
		}
		else if(H7combatHud(GetHud()).GetUnitInfoCntl().GetObstacleInfo().IsVisible())
		{
			H7combatHud(GetHud()).GetUnitInfoCntl().GetObstacleInfo().Hide();
		}
		else if(H7combatHud(GetHud()).GetUnitInfoCntl().GetUnitInfoDefender().IsVisible())
		{
			H7combatHud(GetHud()).GetUnitInfoCntl().GetUnitInfoDefender().Hide();
		}
		else if(H7combatHud(GetHud()).GetUnitInfoCntl().GetUnitInfoAttacker().IsVisible())
		{
			H7combatHud(GetHud()).GetUnitInfoCntl().GetUnitInfoAttacker().Hide();
		}
		else
		{
			if(!class'H7PlayerController'.static.GetPlayerController().GetHud().CloseCurrentPopup())
			{
				class'H7PlayerController'.static.GetPlayerController().GetHud().GetPauseMenuCntl().OpenPopup();
			}
		}
	}

	ConsoleCommand("CANCELMATINEE");
}

exec function ToggleCreatureHpBars()
{
	local bool isVisible;

	if(GetHud().IsFocusOnInput()) return;

	if(class'H7ReplicationInfo'.static.GetInstance().IsCombatMap())
	{
		isVisible = class'H7OverlaySystemCntl'.static.GetInstance().GetStatusBarSystem().IsCurrentlyVisibleHealtBars();
		class'H7OverlaySystemCntl'.static.GetInstance().GetStatusBarSystem().SetSystemVisible(!isVisible);
	}
}

exec function SelectHeroDefaultAttack()
{
	if(GetHud().IsFocusOnInput()) return;

	if(class'H7ReplicationInfo'.static.GetInstance().IsCombatMap()
		&& !GetCombatMapHud().GetCombatHudCntl().IsWaitingForOtherPlayer()
		&& class'H7CombatController'.static.GetInstance().GetActiveUnit().CanMakeAction()
		&& !class'H7CombatController'.static.GetInstance().GetCommandQueue().IsCommandRunning()
		//&& class'H7CombatController'.static.GetInstance().AllowCurrentUnitAction() // causes HOMMVII-6523
		)
	{
		class'H7CombatHudCntl'.static.GetInstance().HeroAttackToggle();
	}
}

exec function PresentArmy()
{
	class'H7CameraActionController'.static.GetInstance().StartPresentArmy();
}

exec function ArmyVictoryCameraAction()
{
	class'H7CameraActionController'.static.GetInstance().StartArmyVictory();
}

exec function IntroduceHero()
{
	class'H7CameraActionController'.static.GetInstance().StartIntroduceHero();
}

exec function FadeToWhite(int duration)
{
	class'H7CameraActionController'.static.GetInstance().FadeToWhite(duration);
}

exec function FadeToBlack(int duration)
{
	class'H7CameraActionController'.static.GetInstance().FadeToBlack(duration);
}

exec function FadeFromBlack(int duration)
{
	class'H7CameraActionController'.static.GetInstance().FadeFromBlack(duration);
}

exec function FadeFromWhite(int duration)
{
	class'H7CameraActionController'.static.GetInstance().FadeFromWhite(duration);
}

// THIRD BOOL
// - called with false when unreal actions start (flying,moving,fighting,...) and when flash actions start (popup was open) 
// - called with true when unreal actions end (flying,moving,fighting,...) and when flash actions end (popup was closed) 
function SetIsUnrealInputAllowed(bool isAllowed)
{
	if(!class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap())
	{
		GetCombatMapHud().GetCombatHudCntl().SetMyTurn( isAllowed );
	}
	super.SetIsUnrealInputAllowed( isAllowed );
}

//////////////////////////////////////
// MULTIPLAYER
//////////////////////////////////////

reliable client function SendPreInitStartCombat()
{
	class'H7ReplicationInfo'.static.GetInstance().CreateSynchRNG();
	class'H7ReplicationInfo'.static.PrintLogMessage("SendPreInitStartCombat" @ self, 0);;
}

reliable client function SendInitStartCombat()
{
	class'H7ReplicationInfo'.static.GetInstance().CreateCombatController();
	class'H7ReplicationInfo'.static.PrintLogMessage("SendInitStartCombat" @ self, 0);;
}

reliable client native event SendRefillRNGPool( int synchSeed );

reliable server function HostIsReady()
{
	GetPlayerReplicationInfo().SetHostReady();
}

function bool IsSimTurnAIPlaying()
{
	if(class'H7AdventureController'.static.GetInstance() == none)
	{
		return false;
	}

	return class'H7AdventureController'.static.GetInstance().IsSimTurnOfAI();
}

function bool IsSimTurnCommandMode()
{
	return class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() && !IsSimTurnAIPlaying();
}

function SendPlayCommand( int unitActionCounter, int unitTurnCounter, EUnitCommand commandType, H7ICaster source, H7BaseAbility ability, H7IEffectTargetable target, int teleportTarget, array<H7BaseCell> path, 
	ECommandTag commandTag, EDirection direction, bool replaceFakeAttacker, bool insertHead, int currentPlayer, H7CombatMapCell trueHitCell, optional bool ignoreAddToSimTurnQueue, optional bool doOOSCheck = true, optional int movementPoints )
{
	local int i;
	local int convertedPath[MP_MAX_PATH_LENGTH];
	local int convertedExtPath[MP_MAX_EXT_PATH_LENGTH];
	local int parameters[NORMAL_COMMAND_MAX_INT_PARAMS];
	
	if( (!IsSimTurnCommandMode() || ignoreAddToSimTurnQueue) && doOOSCheck)
	{
		CheckOutOfSynch();
	}

	if( IsSimTurnCommandMode() )
	{
		// we need to know the original cell of target in SimTurn
		if( commandType == UC_MEET )
		{
			path.AddItem( H7AdventureHero( target ).GetAdventureArmy().GetCell() );
		}
	}

	// creating the array of parameters
	parameters[0] = unitActionCounter;
	parameters[1] = commandType;
	parameters[2] = source.GetID();
	parameters[3] = ability != none ? ability.GetID() : -1;
	parameters[4] = target != none ? target.GetID() : -1;
	parameters[5] = commandTag;
	parameters[6] = direction;
	parameters[7] = int(replaceFakeAttacker);
	parameters[8] = int(insertHead);
	parameters[9] = unitTurnCounter;
	parameters[10] = teleportTarget;
	parameters[11] = currentPlayer;
	parameters[12] = trueHitCell != none ? trueHitCell.GetID() : -1;
	parameters[13] = int(doOOSCheck);
	parameters[14] = movementPoints;

	mIgnoreAddToSimTurnQueue = ignoreAddToSimTurnQueue;
	
	// we will call a different RPC depending of the path length
	if( path.Length == 0 )
	{
		ServerPlayUnitCommand( parameters );
	}
	else if( path.Length < MP_MAX_PATH_LENGTH )
	{
		// convert path
		convertedPath[0] = path.Length; // first element contains the length
		for( i=1; i<=path.Length; ++i )
		{
			convertedPath[i] = path[i-1].GetID();
		}
		ServerPlayUnitCommandWithPath( parameters, convertedPath );
	}
	else if( path.Length < MP_MAX_EXT_PATH_LENGTH )
	{
		// convert path
		convertedExtPath[0] = path.Length; // first element contains the length
		for( i=1; i<=path.Length; ++i )
		{
			convertedExtPath[i] = path[i-1].GetID();
		}
		ServerPlayUnitCommandWithExtPath( parameters, convertedExtPath );
	}
	else
	{
		;
	}

	mIgnoreAddToSimTurnQueue = false; // we use a member variable so we avoid to pass a new parameter to the RPC (mIgnoreAddToSimTurnQueue is only used in the server )

	class'H7ReplicationInfo'.static.PrintLogMessage("SendPlayCommand" @ "UAC:" @ unitActionCounter @ "Cmd:" @ commandType @ int(commandType) @ "Src:" @ source @ "Ability:" @ parameters[3] @ "(" @ ability != none ? ability.GetName() : "" @ ")"
		@ "Target:" @ target @ "PathLength:" @ path.Length @ "Tag:" @ commandTag @ "Dir:" @ direction @ "RFA:" @ replaceFakeAttacker @ "IH:" @ insertHead, 0);;
}

reliable server function ServerPlayUnitCommand( int parameters[NORMAL_COMMAND_MAX_INT_PARAMS] )
{
	local H7CombatPlayerController currentPlayerController;

	if( IsSimTurnCommandMode() && !mIgnoreAddToSimTurnQueue )
	{
		class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager().SetNextAddCommandPlayerController( self );
		// call this function only for server player controller
		GetCombatPlayerController().ClientPlayUnitCommand( parameters );
	}
	else
	{
		// broadcast the function to the rest of players
		ForEach WorldInfo.AllControllers( class'H7CombatPlayerController', currentPlayerController )
		{
			if( currentPlayerController != self || IsSimTurnCommandMode() )
			{
				currentPlayerController.ClientPlayUnitCommand( parameters );
			}
		}
	}
	//`LOG_MP( "ServerPlayUnitCommand" @ "UAC:" @ parameters[0] @ "Cmd:" @ EUnitCommand(parameters[1]) @ "Src:" @ parameters[2] @ "Ability:" @ parameters[3] @ "Target:" @ parameters[4] 
	//	@ "Tag:" @ parameters[5] @ "Dir:" @ parameters[6] @ "RFA:" @ parameters[7] @ "IH:" @ parameters[8] @ "IgnoreAddToSimTurnQueue:" @ mIgnoreAddToSimTurnQueue );
}

reliable server function ServerPlayUnitCommandWithPath( int parameters[NORMAL_COMMAND_MAX_INT_PARAMS], int path[MP_MAX_PATH_LENGTH] )
{
	local H7CombatPlayerController currentPlayerController;

	if( IsSimTurnCommandMode() && !mIgnoreAddToSimTurnQueue )
	{
		class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager().SetNextAddCommandPlayerController( self );
		// call this function only for server player controller
		GetCombatPlayerController().ClientPlayUnitCommandWithPath( parameters, path );
	}
	else
	{
		// broadcast the function to the rest of players
		ForEach WorldInfo.AllControllers( class'H7CombatPlayerController', currentPlayerController )
		{
			if( currentPlayerController != self || IsSimTurnCommandMode() )
			{
				currentPlayerController.ClientPlayUnitCommandWithPath( parameters, path );
			}
		}
	}
	//`LOG_MP( "ServerPlayUnitCommandWithPath" @ "UAC:" @ parameters[0] @ "Cmd:" @ EUnitCommand(parameters[1]) @ "Src:" @ parameters[2] @ "Ability:" @ parameters[3] @ "Target:" @ parameters[4] 
	//	@ "PathLength:" @ path[0] @ "Tag:" @ parameters[5] @ "Dir:" @ parameters[6] @ "RFA:" @ parameters[7] @ "IH:" @ parameters[8] @ "IgnoreAddToSimTurnQueue:" @ mIgnoreAddToSimTurnQueue );
}

reliable server function ServerPlayUnitCommandWithExtPath( int parameters[NORMAL_COMMAND_MAX_INT_PARAMS], int path[MP_MAX_EXT_PATH_LENGTH] )
{
	local H7CombatPlayerController currentPlayerController;

	if( IsSimTurnCommandMode() && !mIgnoreAddToSimTurnQueue )
	{
		class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager().SetNextAddCommandPlayerController( self );
		// call this function only for server player controller
		GetCombatPlayerController().ClientPlayUnitCommandWithExtPath( parameters, path );
	}
	else
	{
		// broadcast the function to the rest of players
		ForEach WorldInfo.AllControllers( class'H7CombatPlayerController', currentPlayerController )
		{
			if( currentPlayerController != self || IsSimTurnCommandMode() )
			{
				currentPlayerController.ClientPlayUnitCommandWithExtPath( parameters, path );
			}
		}
	}
	//`LOG_MP( "ServerPlayUnitCommandWithExtPath" @ "UAC:" @ parameters[0] @ "Cmd:" @ EUnitCommand(parameters[1]) @ "Src:" @ parameters[2] @ "Ability:" @ parameters[3] @ "Target:" @ parameters[4] 
	//	@ "PathLength:" @ path[0] @ "Tag:" @ parameters[5] @ "Dir:" @ parameters[6] @ "RFA:" @ parameters[7] @ "IH:" @ parameters[8] @ "IgnoreAddToSimTurnQueue:" @ mIgnoreAddToSimTurnQueue );
}

reliable client function ClientPlayUnitCommand( int parameters[NORMAL_COMMAND_MAX_INT_PARAMS] )
{
	ClientPlayUnitCommandConvertedPath( parameters );
}

reliable client function ClientPlayUnitCommandWithPath( int parameters[NORMAL_COMMAND_MAX_INT_PARAMS], int path[MP_MAX_PATH_LENGTH] )
{
	local array<H7BaseCell> convertedPath;
	local int pathLength, i;
	local H7IEventManagingObject eventManageable;

	// convert path
	pathLength = path[0]; // first element contains the length
	for( i=1; i<=pathLength; ++i )
	{
		eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( path[i] );
		convertedPath.AddItem(H7BaseCell(eventManageable));
	}

	ClientPlayUnitCommandConvertedPath( parameters, convertedPath );
}

reliable client function ClientPlayUnitCommandWithExtPath( int parameters[NORMAL_COMMAND_MAX_INT_PARAMS], int path[MP_MAX_EXT_PATH_LENGTH] )
{
	local array<H7BaseCell> convertedPath;
	local int pathLength, i;
	local H7IEventManagingObject eventManageable;

	// convert path
	pathLength = path[0]; // first element contains the length
	for( i=1; i<=pathLength; ++i )
	{
		eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( path[i] );
		convertedPath.AddItem(H7BaseCell(eventManageable));
	}

	ClientPlayUnitCommandConvertedPath( parameters, convertedPath );
}

function ClientPlayUnitCommandConvertedPath( int parameters[NORMAL_COMMAND_MAX_INT_PARAMS], optional array<H7BaseCell> convertedPath )
{
	local H7IEffectTargetable target;
	local H7ICaster source;
	local H7IEventManagingObject eventManageable;
	local H7BaseAbility ability;
	local H7CombatMapCell trueHitCell;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( parameters[2] );
	source = H7ICaster( eventManageable );

	if( parameters[4] != -1 )
	{
		eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( parameters[4] );
		target = H7IEffectTargetable( eventManageable );
	}

	ability = parameters[3] != -1 ? source.GetAbilityManager().GetAbilityByID( parameters[3] ) : none;
		
	if( parameters[12] != -1 )
	{
		eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( parameters[12] );
		trueHitCell = H7CombatMapCell( eventManageable );
	}

	if( IsServer() && IsSimTurnCommandMode() && !mIgnoreAddToSimTurnQueue )
	{
		class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager().AddCommand( parameters[0], EUnitCommand(parameters[1]), ECommandTag(parameters[5]), source, 
			target, parameters[10], convertedPath, ability, EDirection(parameters[6]), bool(parameters[7]), bool(parameters[8]),trueHitCell, bool(parameters[13]), parameters[14] );
	}
	else
	{
		class'H7ReplicationInfo'.static.GetInstance().GetMpCommandManager().AddCommand( parameters[0], parameters[9], EUnitCommand(parameters[1]), ECommandTag(parameters[5]), source, 
			target, parameters[10], convertedPath, parameters[11], ability, EDirection(parameters[6]), bool(parameters[7]), bool(parameters[8]), trueHitCell, bool(parameters[13]), parameters[14] );
	}

	//`LOG_MP( "ClientPlayUnitCommand" @ "UAC:" @ parameters[0] @ "Cmd:" @ EUnitCommand(parameters[1]) @ "Src:" @ parameters[2] @ "Ability:" @ parameters[3] @ "Target:" @ parameters[4] 
	//	@ "PathLength:" @ convertedPath.Length @ "Tag:" @ parameters[5] @ "Dir:" @ parameters[6] @ "RFA:" @ parameters[7] @ "IH:" @ parameters[8] @ "IgnoreAddToSimTurnQueue:" @ mIgnoreAddToSimTurnQueue );
}

function SendGameWentOOS(string msg, EOOSType oosType)
{
	ServerGameWentOOS(msg, oosType);
}

reliable server function ServerGameWentOOS(string msg, EOOSType oosType)
{
	local H7CombatPlayerController currentPlayerController;
	local H7ReplicationInfo repInfo;
	local H7AdventureArmy army;
	local array<H7AdventureArmy> armies;
	local array<H7BaseCreatureStack> stacks;
	local int stackSizes[7];
	local string stackIDStrings;
	local int i;

	repInfo = class'H7ReplicationInfo'.static.GetInstance();

	// broadcast the function to the rest of players
	ForEach WorldInfo.AllControllers( class'H7CombatPlayerController', currentPlayerController )
	{
		if( currentPlayerController != self )
		{
			currentPlayerController.ClientGameWentOOS(msg, oosType);
		}

		if(repInfo.IsAdventureMap() )
		{
			if( oosType == OOS_RNG_COUNTER || oosType == OOS_ID_COUNTER)
			{
				ClientSynchUp(repInfo.GetUnitActionsCounter(), repInfo.GetSynchRNG().GetCounter(), repInfo.GetIdCounter());
			}
			else if( oosType == OOS_UNIT_COUNT )
			{
				if(class'WorldInfo'.static.GetWorldInfo().RealTimeSeconds > mLastTimeSynchedUpArmies + 5)
				{
					armies = class'H7AdventureController'.static.GetInstance().GetArmies();
					foreach armies(army)
					{
						stacks = army.GetBaseCreatureStacks();
						stackIDStrings = "";

						for(i=0; i<7; i++)
						{
							if(i != 0)
							{
								stackIDStrings = stackIDStrings$";";
							}

							if(stacks.Length > i && stacks[i] != none)
							{
								stackSizes[i] = stacks[i].GetStackSize();
								
								stackIDStrings = stackIDStrings$stacks[i].GetStackType().GetIDString();
							}
							else
							{
								stackSizes[i] = 0;
							}
						}

						ClientSynchUpArmy(army.GetHero().GetID(), stackIDStrings, stackSizes);
					}

					mLastTimeSynchedUpArmies = class'WorldInfo'.static.GetWorldInfo().RealTimeSeconds;
				}
			}
		}
	}
}

reliable client function ClientGameWentOOS(string msg, EOOSType oosType)
{
	class'H7ReplicationInfo'.static.GetInstance().GetMpCommandManager().GameWentOOS(msg, oosType, false);
}

reliable client function ClientSynchUp(int unitActionCounter, int rngCounter, int idCounter)
{
	class'H7ReplicationInfo'.static.GetInstance().GetMpCommandManager().AddSynchUpData(unitActionCounter, rngCounter, idCounter);
}

reliable client function ClientSynchUpArmy(int heroId, string stackIDStrings, int stackCounts[7])
{
	local H7IEventManagingObject eventManageable;
	local H7AdventureArmy army;
	local array<H7BaseCreatureStack> stacks;
	local int i;
	local array<string> stackIDStringsArray;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable(heroId);

	if(eventManageable != none)
	{
		army = H7AdventureHero(eventManageable).GetAdventureArmy();
		stacks = army.GetBaseCreatureStacks();

		stackIDStringsArray = SplitString(stackIDStrings, ";", false);
		for(i=0; i<7; i++)
		{
			if(stackCounts[i] != 0)
			{
				if(stacks[i] == none)
				{
					stacks[i] = new class'H7BaseCreatureStack';
				}
				stacks[i].SetStackType(class'H7TransitionData'.static.GetInstance().GetGameData().GetCreatureByIDString(stackIDStringsArray[i]));
				stacks[i].SetStackSize(stackCounts[i], true);
			}
			else
			{
				stacks[i] = none;
			}
		}

		army.SetBaseCreatureStacks(stacks);
	}
	else
	{
		class'H7ReplicationInfo'.static.PrintLogMessage("ClientSynchUpArmy: Didn't find hero with the id"@heroId@"!!", 0);;
	}
}

function SendCombatStart()
{
	local H7CombatPlayerController currentPlayerController;

	ForEach WorldInfo.AllControllers( class'H7CombatPlayerController', currentPlayerController )
	{
		if( currentPlayerController != self )
		{
			currentPlayerController.ClientCombatStart();
		}
	}
}

reliable client function ClientCombatStart()
{
	class'H7CombatController'.static.GetInstance().StartCombat();
}

// isDefender = true -> defender; false -> attacker
function SendTacticsPhaseFinished( bool isDefender, H7CombatArmy army )
{
	local MPUnitsPos unitsPos[MP_MAX_ARMY_UNITS];
	local array<H7CreatureStack> creatureStacks;
	local int i;

	creatureStacks = army.GetCreatureStacks();
	unitsPos[0].UnitId = creatureStacks.length;
	for( i=1; i<=creatureStacks.Length; ++i )
	{
		if( creatureStacks[i-1] != none )
		{
			unitsPos[i].UnitId = creatureStacks[i-1].GetID();
			unitsPos[i].UnitPos = creatureStacks[i-1].GetGridPosition();
		}
		else
		{
			unitsPos[i].UnitId = -1;
		}
	}

	ServerTacticsPhaseFinished( isDefender, unitsPos );

	class'H7ReplicationInfo'.static.PrintLogMessage("SendTacticsPhaseFinished" @ Role @ "IsDefender:" @ isDefender @ "unitsPos length:" @ unitsPos[0].UnitId @ "FirstUnit" @ unitsPos[1].UnitId @ unitsPos[1].UnitPos.X @ unitsPos[1].UnitPos.Y, 0);;
}

reliable server function ServerTacticsPhaseFinished( bool isDefender, MPUnitsPos unitsPos[MP_MAX_ARMY_UNITS] )
{
	local H7CombatPlayerController currentPlayerController;

	// broadcast the function to the rest of players
	ForEach WorldInfo.AllControllers( class'H7CombatPlayerController', currentPlayerController )
	{
		if( currentPlayerController != self )
		{
			currentPlayerController.ClientTacticsPhaseFinished( isDefender, unitsPos );
		}
	}
	class'H7ReplicationInfo'.static.PrintLogMessage("ServerTacticsPhaseFinished" @ "isDefender:" @ isDefender @ "unitsPos length:" @ unitsPos[0].UnitId @ "FirstUnit" @ unitsPos[1].UnitId @ unitsPos[1].UnitPos.X @ unitsPos[1].UnitPos.Y, 0);;
}

reliable client function ClientTacticsPhaseFinished( bool isDefender, MPUnitsPos unitsPos[MP_MAX_ARMY_UNITS] )
{
	local int numUnits, i;
	local H7CreatureStack currentCreature;
	local H7IEventManagingObject eventManageable;

	numUnits = unitsPos[0].UnitId; // first element contains the length
	if( numUnits > 0 )
	{
		for( i=1; i<=numUnits; ++i )
		{
			if( unitsPos[i].UnitId != -1 )
			{
				eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( unitsPos[i].UnitId );
				currentCreature = H7CreatureStack( eventManageable );
				if( unitsPos[i].UnitPos.X != -1 )
				{
					currentCreature.GetBaseCreatureStack().SetDeployed(true);
					class'H7CombatMapGridController'.static.GetInstance().PlaceCreature( unitsPos[i].UnitPos, currentCreature );
					currentCreature.Hide(); // after the new pos is set, we hide it
				}
				else
				{
					currentCreature.GetBaseCreatureStack().SetDeployed(false);
					currentCreature.RemoveStackFromGrid();
				}
			}
		}
	}

	if( isDefender )
	{
		class'H7CombatController'.static.GetInstance().GetArmyDefender().UpdateCreaturesDeployedState();
	}
	else
	{
		class'H7CombatController'.static.GetInstance().GetArmyAttacker().UpdateCreaturesDeployedState();
	}
		
	class'H7CombatController'.static.GetInstance().SetTacticPhaseFinishedMP( isDefender );

	class'H7ReplicationInfo'.static.PrintLogMessage("ClientTacticsPhaseFinished" @ "isDefender:" @ isDefender @ "unitsPos length:" @ unitsPos[0].UnitId @ "FirstUnit" @ unitsPos[1].UnitId @ unitsPos[1].UnitPos.X @ unitsPos[1].UnitPos.Y, 0);;
}

function SendInstantCommand( MPInstantCommand command, optional bool ignoreAddToSimTurnQueue )
{
	mIgnoreAddToSimTurnQueue = ignoreAddToSimTurnQueue;
	ServerInstantCommand(command.Type, command.UnitActionsCounter, command.StringParameter, command.CurrentPlayer, command.IntParameters);
	mIgnoreAddToSimTurnQueue = false;

	class'H7ReplicationInfo'.static.PrintLogMessage("SendInstantCommand UAC:" @ command.UnitActionsCounter @ "Cmd:" @ command.Type @ Role @ "Player" @ command.CurrentPlayer, 0);;
}

reliable server function ServerInstantCommand( EInstantCommandType instantCommandType, int unitActionCounter, string stringParam, int currentPlayer, int intParams[INSTANT_COMMAND_MAX_INT_PARAMS])
{
	local H7CombatPlayerController currentPlayerController;
	local bool isTactics; // commands in tactics mode are not instantly executed

	if( IsSimTurnCommandMode() && !mIgnoreAddToSimTurnQueue )
	{
		class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager().SetNextAddCommandPlayerController( self );
		// call this function only for server player controller
		GetCombatPlayerController().ClientInstantCommand( instantCommandType, unitActionCounter, stringParam, currentPlayer, intParams );
	}
	else
	{
		isTactics = class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() && class'H7CombatController'.static.GetInstance().IsInState('Tactics');
		// broadcast the function to the rest of players (inclusive the server itself)
		ForEach WorldInfo.AllControllers( class'H7CombatPlayerController', currentPlayerController )
		{
			if( currentPlayerController != self || IsSimTurnCommandMode() || isTactics )
			{
				currentPlayerController.ClientInstantCommand( instantCommandType, unitActionCounter, stringParam, currentPlayer, intParams );
			}
		}
	}
	//`LOG_MP( self @ "ServerInstantCommand2" @ unitActionCounter @ instantCommandType );
}

reliable client function ClientInstantCommand( EInstantCommandType instantCommandType, int unitActionCounter, string stringParam, int currentPlayer, int intParams[INSTANT_COMMAND_MAX_INT_PARAMS] )
{
	local MPInstantCommand instantCommand;
	local int i;

	instantCommand.Type = instantCommandType;
	instantCommand.UnitActionsCounter = unitActionCounter;
	instantCommand.StringParameter = stringParam;
	instantCommand.CurrentPlayer = currentPlayer;

	for(i=0; i<INSTANT_COMMAND_MAX_INT_PARAMS; i++)
	{
		instantCommand.IntParameters[i] = intParams[i];
	}

	if( IsServer() && IsSimTurnCommandMode() && !mIgnoreAddToSimTurnQueue )
	{
		class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager().AddInstantCommand( instantCommand );
	}
	else
	{
		class'H7ReplicationInfo'.static.GetInstance().GetMpCommandManager().AddInstantCommand( instantCommand );
	}

	//`LOG_MP( self @ "ClientInstantCommand" @ unitActionCounter @ instantCommandType );
}

public function SendPlayerDisconnected(int disconnectedPlayerNum)
{
	ServerPlayerDisconnected(disconnectedPlayerNum);
}

reliable server function ServerPlayerDisconnected(int disconnectedPlayerNum)
{
	local H7CombatPlayerController currentPlayerController;

	ForEach WorldInfo.AllControllers( class'H7CombatPlayerController', currentPlayerController )
	{
		currentPlayerController.ClientPlayerDisconnected(disconnectedPlayerNum);
	}
}

reliable client function ClientPlayerDisconnected(int disconnectedPlayerNum)
{
	local H7Player losingPlayer;

	if( class'H7AdventureController'.static.GetInstance() != none )
	{
		losingPlayer = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber(EPlayerNumber(disconnectedPlayerNum));
		losingPlayer.LoseGame();
	}
	else if( class'H7CombatController'.static.GetInstance() != none ) // duel
	{
		losingPlayer = class'H7CombatController'.static.GetInstance().GetPlayerByNumber(EPlayerNumber(disconnectedPlayerNum));
		losingPlayer.LoseGame();
	}
}

// GetInstantCommandUnitActionCounter
protected function int GetICUAC()
{
	local int unitActionCounter;

	unitActionCounter = class'H7ReplicationInfo'.static.GetInstance().GetUnitActionsCounter();
	return unitActionCounter;
}

function CheckOutOfSynch()
{
	local H7ReplicationInfo replInfo;

	replInfo = class'H7ReplicationInfo'.static.GetInstance();
	ServerCheckOutOfSynch( replInfo.GetUnitActionsCounter(), replInfo.GetSynchRNG().GetCounter(), replInfo.GetIdCounter(), class'H7CombatController'.static.GetInstance().GetTotalHealth(), 0, true );
}

reliable server function ServerCheckOutOfSynch( int unitActionCounter, int synchRNG, int idCounter, int unitsCount, int resCount, bool isCombat )
{
	local H7CombatPlayerController currentPlayerController;

	// broadcast the function to the rest of players (inclusive the server itself)
	ForEach WorldInfo.AllControllers( class'H7CombatPlayerController', currentPlayerController )
	{
		if( currentPlayerController != self )
		{
			currentPlayerController.ClientCheckOutOfSynch( unitActionCounter, synchRNG, idCounter, unitsCount, resCount, isCombat );
		}
	}
}

reliable client function ClientCheckOutOfSynch( int unitActionCounter, int synchRNG, int idCounter, int unitsCount, int resCount, bool isCombat )
{
	class'H7ReplicationInfo'.static.GetInstance().GetMpCommandManager().AddOutOfSynchData( unitActionCounter, synchRNG, idCounter, unitsCount, resCount, isCombat );
}

// SimTurn command was cancelled in the server
reliable client function ClientCommandCancelled( ESimTurnCommandCancelledReason reason )
{
	if( reason == STCCR_PATH_CHANGED )
	{
		GetHUD().GetRequestPopupCntl().GetRequestPopup().OKPopup( "PU_MULTIPLAYER_PATH_CHANGED", "OK", none );
	}
	else if( reason == STCCR_ALREADY_LOOTED )
	{
		GetHUD().GetRequestPopupCntl().GetRequestPopup().OKPopup( "PU_MULTIPLAYER_ALREADY_LOOTED", "OK", none );
	}
	else if( reason == STCCR_ARMY_IN_DIFFERENT_CELL )
	{
		GetHUD().GetRequestPopupCntl().GetRequestPopup().OKPopup( "PU_MULTIPLAYER_ARMY_MOVED", "OK", none );
	}
	SetIsUnrealInputAllowed( true );
	class'H7PlayerController'.static.GetPlayerController().SetCommandRequested(false);
	class'H7ReplicationInfo'.static.PrintLogMessage("Command cancelled reason:" @ reason, 0);;
}


function SendDamageApply( int creatureStackId, int stackSize, int topCreatureHealth )
{
	ServerDamageApply( creatureStackId, stackSize, topCreatureHealth );

	class'H7ReplicationInfo'.static.PrintLogMessage("SendDamageApply" @ Role @ "creatureStackId:" @ creatureStackId @ "stackSize:" @ stackSize @ "topCreatureHealth" @ topCreatureHealth, 0);;
}

reliable server function ServerDamageApply( int creatureStackId, int stackSize, int topCreatureHealth )
{
	local H7CombatPlayerController currentPlayerController;

	// broadcast the function to the rest of players
	ForEach WorldInfo.AllControllers( class'H7CombatPlayerController', currentPlayerController )
	{
		if( currentPlayerController != self )
		{
			currentPlayerController.ClientDamageApply( creatureStackId, stackSize, topCreatureHealth );
		}
	}
	class'H7ReplicationInfo'.static.PrintLogMessage("ServerDamageApply" @ "creatureStackId:" @ creatureStackId @ "stackSize:" @ stackSize @ "topCreatureHealth" @ topCreatureHealth, 0);;
}

reliable client function ClientDamageApply( int creatureStackId, int stackSize, int topCreatureHealth )
{
	class'H7ReplicationInfo'.static.GetInstance().GetMpCommandManager().AddDamageApply( creatureStackId, stackSize, topCreatureHealth );
	class'H7ReplicationInfo'.static.PrintLogMessage("ClientDamageApply" @ "creatureStackId:" @ creatureStackId @ "stackSize:" @ stackSize @ "topCreatureHealth" @ topCreatureHealth, 0);;
}
