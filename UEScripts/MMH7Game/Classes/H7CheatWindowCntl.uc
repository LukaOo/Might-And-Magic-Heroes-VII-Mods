//=============================================================================
// H7CheatWindowCntl OPTIONAL rename it and all related files to popup
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CheatWindowCntl extends H7FlashMovieBlockPopupCntl;

const CHEAT_STAT_INCREASE = 5;

var protected String mCurrentMap;

var protected H7GFxCheatWindow mCheatWindow;
var protected GFxCLIKWidget mTeleportButton;
var protected GFxCLIKWidget mCLoseButton;
var protected GFxCLIKWidget mBtnWin;
var protected GFxCLIKWidget mBtnLose;

var protected H7GFxUIContainer mHeroStatsCheat;
var protected GFxCLIKWidget mBtnIncStat1;
var protected GFxCLIKWidget mBtnDecStat1;
		
var protected GFxCLIKWidget mBtnIncStat2;
var protected GFxCLIKWidget mBtnDecStat2;
		
var protected GFxCLIKWidget mBtnIncStat3;
var protected GFxCLIKWidget mBtnDecStat3;
		
var protected GFxCLIKWidget mBtnIncStat4;
var protected GFxCLIKWidget mBtnDecStat4;
		
var protected GFxCLIKWidget mBtnIncStat5;
var protected GFxCLIKWidget mBtnDecStat5;
		
var protected GFxCLIKWidget mBtnIncStat6;
var protected GFxCLIKWidget mBtnDecStat6;
		
var protected GFxCLIKWidget mBtnIncStat7;
var protected GFxCLIKWidget mBtnDecStat7;
		
var protected GFxCLIKWidget mBtnIncStat8;
var protected GFxCLIKWidget mBtnDecStat8;

var protected GFxCLIKWidget mBtnIncStat9;
var protected GFxCLIKWidget mBtnDecStat9;

function    H7GFxCheatWindow      GetCheatWindow() {return mCheatWindow; }
function    H7GFxUIContainer      GetPopup() { return mCheatWindow; }

function bool Initialize() 
{
	;
	// Start playing the movie
    Super.Start();
	// Initialize all objects in the movie
    AdvanceDebug(0);

	mCheatWindow = H7GFxCheatWindow(mRootMC.GetObject("aCheatWindow", class'H7GFxCheatWindow'));
	mCheatWindow.SetVisibleSave(false);
	
	mTeleportButton = GFxCLIKWidget(mCheatWindow.GetObject("mBtnTeleport", class'GFxCLIKWidget'));
	mTeleportButton.AddEventListener('CLIK_click', TeleportButtonClick);

	mBtnWin = GFxCLIKWidget(mCheatWindow.GetObject("mBtnWin", class'GFxCLIKWidget'));
	mBtnWin.AddEventListener('CLIK_click', BtnWinClicked);

	mBtnLose = GFxCLIKWidget(mCheatWindow.GetObject("mBtnLose", class'GFxCLIKWidget'));
	mBtnLose.AddEventListener('CLIK_click', BtnLoseClicked);
	
	mHeroStatsCheat = H7GFxUIContainer(mCheatWindow.getObject("mHeroStatsCheat", class'H7GFxUIContainer'));
	
	mBtnIncStat1 = GFxCLIKWidget(mHeroStatsCheat.GetObject("mBtnIncStat1", class'GFxCLIKWidget'));
	mBtnIncStat1.AddEventListener('CLIK_click', BtnIncDmgClicked);
	mBtnDecStat1 = GFxCLIKWidget(mHeroStatsCheat.GetObject("mBtnDecStat1", class'GFxCLIKWidget'));
	mBtnDecStat1.AddEventListener('CLIK_click', BtnDecDmgClicked);
	
	mBtnIncStat2 = GFxCLIKWidget(mHeroStatsCheat.GetObject("mBtnIncStat2", class'GFxCLIKWidget'));
	mBtnIncStat2.AddEventListener('CLIK_click', BtnIncAttClicked);
	mBtnDecStat2 = GFxCLIKWidget(mHeroStatsCheat.GetObject("mBtnDecStat2", class'GFxCLIKWidget'));
	mBtnDecStat2.AddEventListener('CLIK_click', BtnDecAttClicked);

	mBtnIncStat3 = GFxCLIKWidget(mHeroStatsCheat.GetObject("mBtnIncStat3", class'GFxCLIKWidget'));
	mBtnIncStat3.AddEventListener('CLIK_click', BtnIncDefClicked);
	mBtnDecStat3 = GFxCLIKWidget(mHeroStatsCheat.GetObject("mBtnDecStat3", class'GFxCLIKWidget'));
	mBtnDecStat3.AddEventListener('CLIK_click', BtnDecDefClicked);

	mBtnIncStat4 = GFxCLIKWidget(mHeroStatsCheat.GetObject("mBtnIncStat4", class'GFxCLIKWidget'));
	mBtnIncStat4.AddEventListener('CLIK_click', BtnIncLuckClicked);
	mBtnDecStat4 = GFxCLIKWidget(mHeroStatsCheat.GetObject("mBtnDecStat4", class'GFxCLIKWidget'));
	mBtnDecStat4.AddEventListener('CLIK_click', BtnDecLuckClicked);

	mBtnIncStat5 = GFxCLIKWidget(mHeroStatsCheat.GetObject("mBtnIncStat5", class'GFxCLIKWidget'));
	mBtnIncStat5.AddEventListener('CLIK_click', BtnIncMoralClicked);
	mBtnDecStat5 = GFxCLIKWidget(mHeroStatsCheat.GetObject("mBtnDecStat5", class'GFxCLIKWidget'));
	mBtnDecStat5.AddEventListener('CLIK_click', BtnDecMoralClicked);

	mBtnIncStat6 = GFxCLIKWidget(mHeroStatsCheat.GetObject("mBtnIncStat6", class'GFxCLIKWidget'));
	mBtnIncStat6.AddEventListener('CLIK_click', BtnIncMoveClicked);
	mBtnDecStat6 = GFxCLIKWidget(mHeroStatsCheat.GetObject("mBtnDecStat6", class'GFxCLIKWidget'));
	mBtnDecStat6.AddEventListener('CLIK_click', BtnDecMoveClicked);

	mBtnIncStat7 = GFxCLIKWidget(mHeroStatsCheat.GetObject("mBtnIncStat7", class'GFxCLIKWidget'));
	mBtnIncStat7.AddEventListener('CLIK_click', BtnIncMagicClicked);
	mBtnDecStat7 = GFxCLIKWidget(mHeroStatsCheat.GetObject("mBtnDecStat7", class'GFxCLIKWidget'));
	mBtnDecStat7.AddEventListener('CLIK_click', BtnDecMagicClicked);
	
	mBtnIncStat8 = GFxCLIKWidget(mHeroStatsCheat.GetObject("mBtnIncStat8", class'GFxCLIKWidget'));
	mBtnIncStat8.AddEventListener('CLIK_click', BtnIncSpiritClicked);
	mBtnDecStat8 = GFxCLIKWidget(mHeroStatsCheat.GetObject("mBtnDecStat8", class'GFxCLIKWidget'));
	mBtnDecStat8.AddEventListener('CLIK_click', BtnDecSpiritClicked);

	mBtnIncStat9 = GFxCLIKWidget(mHeroStatsCheat.GetObject("mBtnIncStat9", class'GFxCLIKWidget'));
	mBtnIncStat9.AddEventListener('CLIK_click', BtnIncIniClicked);
	mBtnDecStat9 = GFxCLIKWidget(mHeroStatsCheat.GetObject("mBtnDecStat9", class'GFxCLIKWidget'));
	mBtnDecStat9.AddEventListener('CLIK_click', BtnDecIniClicked);

	Super.Initialize();
	return true;
}

function SetData(String map)
{
	mCurrentMap = map;
	
	mCheatWindow.Update(map);
	class'H7PlayerController'.static.GetPlayerController().SetPause(true);
	
	OpenPopup();
}

function ClosePopup()
{
	class'H7PlayerController'.static.GetPlayerController().SetPause(false);
	SetPriority(0);
	super.ClosePopup();
}

function Closed()
{
	;
	ClosePopup();
}

function BtnWinClicked(EventData data)
{
	local H7InstantCommandCheatWinLose command;
	
	;
	ClosePopup();
	class'H7PlayerController'.static.GetPlayerController().SetPause(false);

	command = new class'H7InstantCommandCheatWinLose';
	command.Init(class'H7AdventureController'.static.GetInstance().GetLocalPlayer(), true);
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);
}

function BtnLoseClicked(EventData data)
{
	local H7InstantCommandCheatWinLose command;

	;
	ClosePopup();
	class'H7PlayerController'.static.GetPlayerController().SetPause(false);

	command = new class'H7InstantCommandCheatWinLose';
	command.Init(class'H7AdventureController'.static.GetInstance().GetLocalPlayer(), false);
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);
}

function ChangeStat(EStat stat, int incValue)
{
	local H7Unit unit;
	local H7InstantCommandCheatStatChange command;
	local int newValue;

	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		unit = class'H7CombatController'.static.GetInstance().GetActiveUnit();
	}
	else
	{
		unit = class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero();
	}

	newValue = unit.GetBaseStatByID(stat) + incValue;

	;
	command = new class'H7InstantCommandCheatStatChange';
	command.Init(unit, stat, newValue);
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);
}

function BtnIncAttClicked(EventData data)
{
	ChangeStat(STAT_ATTACK, CHEAT_STAT_INCREASE);
}

function BtnDecAttClicked(EventData data)
{
	ChangeStat(STAT_ATTACK, -CHEAT_STAT_INCREASE);
}

function BtnIncMagicClicked(EventData data)
{
	ChangeStat(STAT_MAGIC, CHEAT_STAT_INCREASE);
}

function BtnDecMagicClicked(EventData data)
{
	ChangeStat(STAT_MAGIC, -CHEAT_STAT_INCREASE);
}

function BtnIncSpiritClicked(EventData data)
{
	ChangeStat(STAT_SPIRIT, CHEAT_STAT_INCREASE);
}

function BtnDecSpiritClicked(EventData data)
{
	ChangeStat(STAT_SPIRIT, -CHEAT_STAT_INCREASE);
}

function BtnIncDefClicked(EventData data)
{
	ChangeStat(STAT_DEFENSE, CHEAT_STAT_INCREASE);
}

function BtnDecDefClicked(EventData data)
{
	ChangeStat(STAT_DEFENSE, -CHEAT_STAT_INCREASE);
}

function BtnIncDmgClicked(EventData data)
{
	ChangeStat(STAT_MIN_DAMAGE, CHEAT_STAT_INCREASE);
	ChangeStat(STAT_MAX_DAMAGE, CHEAT_STAT_INCREASE);
}
function BtnDecDmgClicked(EventData data)
{
	ChangeStat(STAT_MIN_DAMAGE, -CHEAT_STAT_INCREASE);
	ChangeStat(STAT_MAX_DAMAGE, -CHEAT_STAT_INCREASE);
}

function BtnIncMoralClicked(EventData data)
{
	ChangeStat(STAT_MORALE_LEADERSHIP, CHEAT_STAT_INCREASE);
}

function BtnDecMoralClicked(EventData data)
{
	ChangeStat(STAT_MORALE_LEADERSHIP, -CHEAT_STAT_INCREASE);
}

function BtnIncIniClicked(EventData data)
{
	ChangeStat(STAT_INITIATIVE, CHEAT_STAT_INCREASE);
}

function BtnDecIniClicked(EventData data)
{
	ChangeStat(STAT_INITIATIVE, -CHEAT_STAT_INCREASE);
}

function BtnIncMoveClicked(EventData data)
{
	ChangeStat(STAT_MAX_MOVEMENT, CHEAT_STAT_INCREASE);
}

function BtnDecMoveClicked(EventData data)
{
	ChangeStat(STAT_MAX_MOVEMENT, -CHEAT_STAT_INCREASE);
}

function BtnIncLuckClicked(EventData data)
{
	ChangeStat(STAT_LUCK_DESTINY, CHEAT_STAT_INCREASE);
}

function BtnDecLuckClicked(EventData data)
{
	ChangeStat(STAT_LUCK_DESTINY, -CHEAT_STAT_INCREASE);
}

function TeleportButtonClick(EventData data)
{
	ClosePopup();

	;
	class'H7PlayerController'.static.GetPlayerController().SetPause(false);
	class'H7AdventureGridManager'.static.GetInstance().SetTeleportPhase(true);
}

static function Teleport( Vector vec )
{
	local H7AdventureArmy currentArmy;
	local H7AdventureGridManager gridManager;
	local H7AdventureMapCell pointingCell;
	local H7InstantCommandCheatTeleport command;

	gridManager = class'H7AdventureGridManager'.static.GetInstance();
	currentArmy = class'H7AdventureController'.static.GetInstance().GetSelectedArmy();

	pointingCell = gridManager.GetCellByWorldLocation( vec );

	;

	command = new class'H7InstantCommandCheatTeleport';
	command.Init( currentArmy.GetHero(), pointingCell );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);
}

static function bool TeleportHero(H7AdventureHero currentHero, H7AdventureMapCell cell)
{
	local H7AdventureArmy army;
	local int numOfWalkableCells;
	local H7AdventureGridManager gridManager;
	local array<float> pathCosts;
	local array<H7AdventureMapCell> path;

	gridManager = class'H7AdventureGridManager'.static.GetInstance();
	army = currentHero.GetAdventureArmy();

	if( cell != none )
	{
		if( !cell.IsBlocked() )
		{
			army.SetCell( cell );
			// set new path and show preview
			path = currentHero.GetCurrentPath();
			if( path.Length > 0 )
			{
				currentHero.SetCurrentPath( gridManager.GetPathfinder().GetPath( cell, path[path.Length-1], currentHero.GetPlayer(), currentHero.GetAdventureArmy().HasShip() ) );
				pathCosts = gridManager.GetPathfinder().GetPathCosts( currentHero.GetCurrentPath(), army.GetCell(), currentHero.GetCurrentMovementPoints(), numOfWalkableCells );
				gridManager.GetPathPreviewer().ShowPreview( currentHero.GetCurrentPath(), numOfWalkableCells, currentHero.GetCurrentMovementPoints(), currentHero.GetMovementPoints(), pathCosts );
			}
			class'H7Camera'.static.GetInstance().SetFocusActor( currentHero, army.GetPlayerNumber(), true );	
			gridManager.SetTeleportPhase( false );
			return true;
		}
	}

	return false;
}

// TODO all consolecommands here are dangerous, because compiler does not warn if function does not exist, why not call directly?

function ToggleFogOfWar(bool b)
{
	class'H7PlayerController'.static.GetPlayerController().ConsoleCommand("togglefog");
	;
}

function AddXP(int xp)
{
	class'H7PlayerController'.static.GetPlayerController().ConsoleCommand("AddXp "$xp);
	;
}

function UnlimitedMovement(bool isSelected)
{
	class'H7PlayerController'.static.GetPlayerController().ConsoleCommand("UnlimitedMovement "$isSelected);
	;
}

function UnlimitedMana(bool isSelected)
{
	class'H7PlayerController'.static.GetPlayerController().ConsoleCommand("UnlimitedMana "$isSelected);
	;
}

function UnlimitedBuilding(bool isSelected)
{
	class'H7PlayerController'.static.GetPlayerController().ConsoleCommand("UnlimitedBuilding "$isSelected);
	;
}

function TurnOverPopup(bool isSelected)
{
	class'H7PlayerController'.static.GetPlayerController().ConsoleCommand("TurnOverPopup "$isSelected);
	;
}

function AddResources(int addAmount)
{
	class'H7PlayerController'.static.GetPlayerController().ConsoleCommand("AddResourcesToLocalPlayer "$addAmount);
}

function BuildAllBuildings()
{
	class'H7PlayerController'.static.GetPlayerController().ConsoleCommand("BuildAllBuildings");
	;
}

function SkillUp(int skillID)
{
	local H7EditorHero hero;

	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		hero = class'H7CombatController'.static.GetInstance().GetActiveArmy().GetHero();
	}
	else
	{
		hero = class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero();
	}

	hero.GetSkillManager().IncreaseSkillRank( skillID, true, true );

	;
	mCheatWindow.Update(mCurrentMap);
}

function AbilityUp(int skillID,String abilityID)
{
	local H7EditorHero hero;

	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		hero = class'H7CombatController'.static.GetInstance().GetActiveArmy().GetHero();
	}
	else
	{
		hero = class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero();
	}

	hero.GetSkillManager().LearnAbilityfromSkillByID(skillID,abilityID);
	;

	mCheatWindow.Update(mCurrentMap);
}

function SkillOverwrite( int oldSkillID, String newSkillAID )
{
	local H7EditorHero hero;

	;

	// hero
	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		hero = class'H7CombatController'.static.GetInstance().GetActiveArmy().GetHero();
	}
	else
	{
		hero = class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero();
	}

	hero.GetSkillManager().OverwriteSkill( oldSkillID, newSkillAID );

	;
	mCheatWindow.Update(mCurrentMap);
}

function bool OpenPopup()
{
	SetPriority(50);
	return super.OpenPopup();
}

