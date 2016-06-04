/*=============================================================================
 * H7ScriptingController
 * ============================================================================
 * Controls kismet scripts
 * ============================================================================
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================*/
class H7ScriptingController extends Actor
	dependsOn(H7SeqEvent)
	native
	savegame;

// Army tracking
var protected savegame array<H7CreatureCounter> mCreatureLosses;
var protected savegame array<H7ArmyStrengthParams> mArmyStrengthLosses;

// Visit Town Building tracking
var protected savegame array<H7TownBuildingVisitData> mVisitedBuildings;

// Visit Sites tracking
var protected savegame array<H7SiteVisitData> mVisitedSites;

// Army collection tracking
var protected array<H7SeqCon_HasCollectedArmies> mCollectArmyConditions;

// Plunder tracking
var protected savegame array<H7MinePlunderCounter> mPlunderedMines;

// Random object references
var protected array<H7IRandomPropertyOwner> mRandomPropertyOwners;

// Combat
var protected transient bool mIsCombatPaused;
var protected transient int mLastCombatLosses;

// NPC scenes
var protected transient EHUDMode mPreviousHudMode;

// Timers
var protected savegame array<H7SeqAct_StartTimer> mActiveTimers;

// Overrides
var protected savegame array<H7TownDwellingOverride> mTownDwellingOverrides;

function array<H7CreatureCounter> GetCreatureLosses() { return mCreatureLosses; }
function array<H7ArmyStrengthParams> GetArmyStrengthLosses() { return mArmyStrengthLosses; }
function array<H7TownBuildingVisitData> GetVisitedBuildings() { return mVisitedBuildings; }
function array<H7SiteVisitData> GetVisitedSites() { return  mVisitedSites; }
function array<H7MinePlunderCounter> GetPlunderedMines() { return mPlunderedMines; }
function SetLastCombatLosses(int totalLosses) { self.mLastCombatLosses = totalLosses; }
function int GetLastCombatLosses() { return mLastCombatLosses ; }
function bool IsCombatPaused() { return mIsCombatPaused; }

function PauseCombat() { mIsCombatPaused = true; }
function ResumeCombat() { mIsCombatPaused = false; }

function EHUDMode GetPreviousHUDMode() { return mPreviousHudMode; }
function SetPreviousHUDMode(EHUDMode mode) { mPreviousHudMode = mode; }

function RegisterTimer(H7SeqAct_StartTimer timer)
{
	mActiveTimers.AddItem(timer);
}

function UnregisterTimer(H7SeqAct_StartTimer timer)
{
	mActiveTimers.RemoveItem(timer);
}

// there is only one scripting controller per map
static function H7ScriptingController GetInstance()
{
	return class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetScriptingController();
}

//	Helps objects to trigger events
static function bool TriggerEvent(class<SequenceEvent> eventClass, optional int activateIndex = -1)
{
	local H7ScriptingController instance;
	instance = GetInstance();
	if(instance != none)
	{
		return instance.TriggerGlobalEventClass(eventClass, instance, activateIndex);
	}
	return false;
}

native static function TriggerEventParam(class<H7SeqEvent> eventClass, H7EventParam param, Actor eventInstigator, optional int activateIndex = -1);

function UpdateAfterCombatLosses(array<H7CreatureCounter> defeatedCreatures, EPlayerNumber playerID, H7EditorHero defeatedHero = none)
{
	UpdateCreatureLosses(defeatedCreatures);
	UpdateArmyStrengthLosses(defeatedCreatures, playerID, defeatedHero);
}

function protected UpdateCreatureLosses(array<H7CreatureCounter> defeatedCreatures)
{
	local int i, amount;
	local bool updatedCreature;
	local array<H7CreatureCounter> lostCreatures;
	local H7CreatureCounter creatureLoss;
	local H7Creature lostCreature;
	local EPlayerNumber playerID;
	local EPlayerNumber enemyID;

	lostCreatures = defeatedCreatures;

	foreach lostCreatures(creatureLoss)
	{
		amount = creatureLoss.Counter;
		lostCreature = creatureLoss.Creature;
		playerID = creatureLoss.PlayerID;
		enemyID = creatureLoss.EnemyID;

		if(lostCreature != none && amount > 0)
		{
			updatedCreature = false;

			for ( i = 0; i < mCreatureLosses.Length; i++)
			{
				creatureLoss = mCreatureLosses[i];
				if(creatureLoss.creature == lostCreature && creatureLoss.PlayerID == playerID && creatureLoss.EnemyID == enemyID)
				{
					mCreatureLosses[i].Counter += amount;
					updatedCreature = true;
				}
			}

			if(!updatedCreature)
			{
				creatureLoss.Counter = amount;
				creatureLoss.Creature = lostCreature;
				creatureLoss.PlayerID = playerID;
				creatureLoss.EnemyID = enemyID;
				mCreatureLosses.AddItem(creatureLoss);
			}
		}
		
	}
}

function protected UpdateArmyStrengthLosses(array<H7CreatureCounter> defeatedCreatures, EPlayerNumber playerID, H7EditorHero defeatedHero)
{
	local array<H7CreatureCounter> lostCreatures;
	local H7CreatureCounter creatureLoss;
	local H7ArmyStrengthParams armyStrengthLoss;
	local H7StackStrengthParams stackStrengthLoss;
	local H7Creature creature;
	local int amount;

	lostCreatures = defeatedCreatures;
	
	armyStrengthLoss.PlayerID = playerID;
	armyStrengthLoss.HeroLevel = (defeatedHero == none) ? 0 : defeatedHero.GetLevel();
	armyStrengthLoss.HeroFaction = (defeatedHero == none) ? none : defeatedHero.GetFaction();

	foreach lostCreatures(creatureLoss)
	{
		creature = creatureLoss.Creature;
		amount = creatureLoss.Counter;
		if(creature != none && amount > 0)
		{
			stackStrengthLoss.CreaturePower = creature.GetCreaturePower();
			stackStrengthLoss.Faction = creature.GetFaction();
			stackStrengthLoss.IsUpgrade = creature.IsUpgradeVersion();
			stackStrengthLoss.StackSize = amount;
			armyStrengthLoss.StackStrengths.AddItem(stackStrengthLoss);
		}
	}

	mArmyStrengthLosses.AddItem(armyStrengthLoss);
}

function UpdateBuildingVisit(H7TownBuilding visitedBuilding, H7Town visitedTown, EPlayerNumber visitingPlayer)
{
	local H7TownBuildingVisitData currentVisitData;

	foreach mVisitedBuildings(currentVisitData)
	{
		if(currentVisitData.Building == visitedBuilding && currentVisitData.PlayerID == visitingPlayer &&
			currentVisitData.Town == visitedTown)
		{
			return; // Already stored
		}
	}

	currentVisitData.Building = visitedBuilding;
	currentVisitData.Town = visitedTown;
	currentVisitData.PlayerID = visitingPlayer;
	mVisitedBuildings.AddItem(currentVisitData);
}

function UpdateSiteVisit(H7VisitableSite visitedSite, EPlayerNumber visitingPlayer)
{
	local H7SiteVisitData currentVisitData;

	foreach mVisitedSites(currentVisitData)
	{
		if (currentVisitData.Site == visitedSite && currentVisitData.PlayerID == visitingPlayer)
		{
			return; // Already stored
		}
	}

	currentVisitData.Site = visitedSite;
	currentVisitData.PlayerID = visitingPlayer;
	mVisitedSites.AddItem(currentVisitData);
}

function UpdateMinePlunder(H7Mine plunderedMine, EPlayerNumber plunderingPlayer)
{
	local H7MinePlunderCounter newPlunderData;
	local int i;

	for (i = 0; i < mPlunderedMines.Length; ++i)
	{
		if(mPlunderedMines[i].Mine == plunderedMine && mPlunderedMines[i].PlayerID == plunderingPlayer)
		{
			mPlunderedMines[i].Counter++;
			return;
		}
	}

	newPlunderData.Mine = plunderedMine;
	newPlunderData.PlayerID = plunderingPlayer;
	mPlunderedMines.AddItem(newPlunderData);
}

function UpdateCollectedArmies(EPlayerNumber playerID, H7AdventureArmy army)
{
	local H7SeqCon_HasCollectedArmies condition;

	foreach mCollectArmyConditions(condition)
	{
		condition.UpdateCollectedArmies(playerID, army);
	}
}

function UpdateRandomProperties(Object randomObject, Object hatchedObject)
{
	local H7IRandomPropertyOwner current;
	
	foreach	mRandomPropertyOwners(current)
	{
		current.UpdateRandomProperties(randomObject, hatchedObject);
	}
}

function PostBeginPlay()
{
	super.PostBeginPlay();

	class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().SetScriptingController( self );
	
	if( !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
	{
		InitConditions();
	}
}

function UpdateTurn(EH7SeqCondUpdateTurnPeriod period)
{
	local array<H7Player> players;
	local H7Player playerr;

	local array<H7SeqCon_Condition> winConditions;
	local array<H7SeqCon_Condition> loseConditions;
	local array<H7SeqAct_Quest_NewNode> newQuests;
	local H7SeqAct_Quest_NewNode newQuest;
	local bool updatedEventConditions;
	local array<H7SeqCon_Event> activeEvents;
	local H7SeqCon_Event activeEvent;
	local array<H7SeqCon_Condition> eventConditions;
	local array<H7SeqAct_QuestObjective> objectives;
	local H7SeqAct_QuestObjective objective;

	players = class'H7AdventureController'.static.GetInstance().GetPlayers();

	updatedEventConditions = false;

	foreach players( playerr )
	{
		if( playerr.GetQuestController() == none )
		{
			continue;
		}

		newQuests = playerr.GetQuestController().GetActiveQuestNodes();
		foreach newQuests( newQuest )
		{
			objectives = newQuest.GetCurrentObjectives();
			foreach objectives(objective)
			{
				winConditions = objective.GetWinConditions();
				UpdateConditions(winConditions, period);

				loseConditions = objective.GetLoseConditions();
				UpdateConditions(loseConditions, period);
			}
		}

		if(!updatedEventConditions)
		{
			activeEvents = playerr.GetQuestController().GetActiveEvents();
			foreach activeEvents( activeEvent )
			{
				eventConditions = activeEvent.GetConditions();
				UpdateConditions(eventConditions, period);
			}
			updatedEventConditions = true;
		}
	}

	UpdateTimers(period);
}

function UpdateConditions(array<H7SeqCon_Condition> inConditions, EH7SeqCondUpdateTurnPeriod period)
{
	local array<H7SeqCon_Condition> conditions;
	local H7SeqCon_Condition condition;

	conditions = inConditions;

	foreach conditions( condition )
	{
		if(period == EH7SeqCondUpdateTurnPeriod_Week)
		{
			condition.UpdateWeek();
		}
		else if(period == EH7SeqCondUpdateTurnPeriod_Day)
		{
			condition.UpdateDay();
		}
	}
}

function UpdateTimers(EH7SeqCondUpdateTurnPeriod period)
{
	local H7SeqAct_StartTimer timer;

	foreach mActiveTimers(timer)
	{
		if(period == EH7SeqCondUpdateTurnPeriod_Week)
		{
			timer.UpdateWeek();
		}
		else if(period == EH7SeqCondUpdateTurnPeriod_Day)
		{
			timer.UpdateDay();
		}
	}
}

native function InitConditions();

event PostSerialize()
{
	InitConditions();
}

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

function AddTownDwellingOverride(H7TownDwellingOverride dwellingOverride)
{
	local H7TownDwellingOverride existingOverride;
	if(!IsTownDwellingOverrideValid(dwellingOverride))
	{
		return; // Invalid item
	}

	existingOverride = GetTownDwellingOverride(dwellingOverride.TargetTown, dwellingOverride.TargetDwelling);
	if(existingOverride.TargetTown != none && existingOverride.TargetDwelling != none)
	{
		return; // Invalid item
	}
	else
	{
		mTownDwellingOverrides.AddItem(dwellingOverride);
	}
}

function H7TownDwellingOverride GetTownDwellingOverride(H7Town town, H7TownDwelling dwelling)
{
	local int i;
	local H7TownDwellingOverride result;

	if(town == none || dwelling == none)
	{
		return result;
	}

	for(i = 0; i < mTownDwellingOverrides.Length; ++i)
	{
		if(mTownDwellingOverrides[i].TargetTown == town && mTownDwellingOverrides[i].TargetDwelling == dwelling)
		{
			if(Len(mTownDwellingOverrides[i].IconPath) > 0 && mTownDwellingOverrides[i].Icon == none)
			{
				mTownDwellingOverrides[i].Icon = Texture2D(DynamicLoadObject(mTownDwellingOverrides[i].IconPath, class'Texture2D'));
			}
			result = mTownDwellingOverrides[i];
			break;
		}
	}

	return result;
}

function bool IsTownDwellingOverrideValid(H7TownDwellingOverride dwellingOverride)
{
	return (dwellingOverride.TargetTown != none && dwellingOverride.TargetDwelling != none);
}

