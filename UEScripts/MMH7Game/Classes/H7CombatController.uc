//=============================================================================
// H7CombatController
//=============================================================================
// 
// 
// ----------------------------------------------------------------------------
// States:
// ----------------------------------------------------------------------------
// #Beginning:		initial default state
// #Tactics:		precombat state to deploy the troops on the combat grid if
//					one or both of the commanding heroes have the 'Tactics' 
//					ability.
// #Combat:			state handling the turns during combat until one army is
//					defeated or one of the heroes flees or surrenders.
// #CombatEpilog:	state between #Combat and #EndOfCombat to show dialogue
// #EndOfCombat:	post-state to show the battle's summary
//=============================================================================
// Copyright 1998-2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CombatController extends H7BaseGameController
	dependson(H7Creature)
	hidecategories(Object,Attachment,Collision,Physics,Advanced,Debug,Mobile,Movement,Display)
	native;

const TACTICS_PHASE_TIMER = 60;

var(Armies) protected archetype string mArmyAttackerDefaultSetup<DisplayName=Attacking Army Template>; 
var(Armies) protected archetype string mArmyDefenderDefaultSetup<DisplayName=Attacking Army Template>; 

var(Players) protected archetype H7Player mPlayerAttackerTemplate<DisplayName=Attacking Player Template>;
var(Players) protected archetype H7Player mPlayerDefenderTemplate<DisplayName=Defending Player Template>;

var(Combat) protected bool mIsNavalCombat;

var(CombatConfiguration) protected archetype H7CombatConfiguration mCombatConfiguration<DisplayName=Combat Configuration>;
var(CombatConfiguration) protected archetype H7AdventureConfiguration mAventureConfigurationDuels<DisplayName=Adventure Configuration|Tooltip=This config will be used if values from the adventure configuration are necessary for combat (like Arcane Knowledge), so they can be used in Duels>;

var protected H7CombatArmy					mArmyDefender;
var protected H7CombatArmy					mArmyAttacker;
var protected H7InitiativeQueue				mInitiativeQueue;
var protected H7GameProcessor				mGameProcessor;
var protected H7CombatMapGridController		mGridController;
var protected H7AiCombatMap					mAI;
var protected int							mTurnCounter;
var protected H7CombatMapCursor				mCursor;
var protected H7Unit						mActiveUnit;
var protected bool							mPlacingAttackerDone;
var protected bool							mPlacingDefenderDone;
var protected array<H7Unit>					mAttackBuffer; // remembers for this turn who can be attacked by the mActiveUnit
var protected array<H7Unit>					mNoAttackBuffer; // remembers for this turn who can not be attacked by the mActiveUnit
var protected bool							mIsSomeoneDying; // fairly obvious
var protected bool							mIsLastStackDying; // fairly obvious, too
var protected bool                          mLastUnitWasHero;
var protected bool                          mCheckEndCombatImmediately;
var protected float                         mBadMoraleTime;
var protected float                         mCurrentTimeBadMorale;
var protected bool                          mSkipTurnCommand;
var protected float                         mGameSpeed;

var protected bool							mTacticsStartable;
var protected H7CoverManager				mCoverManager;

var protected H7CameraActionController		mCameraActionTemplate;

var protected H7HeroEventParam				mHeroEventParam;

var protected string                        mHeroWithDisableFleeSurrender; // stores the name of the hero with the disable flee surrender ability
var protected string                        mDisableFleeSurrenderArtifact; // stores the name of the item with the disable flee surrender ability

var transient protected int					mResultXPWinner;
var transient protected int					mResultXPLoser;
var transient protected H7CombatArmy		mResultArmy;
var transient protected bool				mResultWin;

var protected float							mCurrentTurnTimeLeft;
var protected array<H7AbilityTrackingData>  mAbilityTrackingData;
var protected string                        mUniqueGameName;
var private transient string                mTurnNameInst;
var protected bool                          mForceEndTurnAfterAnim;

var protected bool                          mAnyDidSurrender;

var protected int mNumberOfRoundsInFightsTotal;
var protected int mNumberOfRoundsInFightsAutoCombat;

//=============================================================================
// Getters and Query functions
//=============================================================================
function float                          GetGameSpeed()                              { return mGameSpeed; }
function H7CombatMapCursor				GetCursor()									{ if(mCursor == none) scripttrace(); return mCursor; }
function H7InitiativeQueue				GetInitiativeQueue()						{ return mInitiativeQueue; }
function int							GetCurrentTurn()							{ return mTurnCounter; }
function H7CombatArmy					GetActiveArmy()								{ if(mActiveUnit != none) return mActiveUnit.IsAttacker() ? mArmyAttacker : mArmyDefender; else return GetCurrentlyDeployingArmy(); }
function H7CombatArmy					GetOpponentArmy( H7CombatArmy army )		{ return army == mArmyAttacker ? mArmyDefender : mArmyAttacker; }
function H7CombatArmy					GetArmyDefender()							{ return mArmyDefender; }
function H7CombatArmy					GetArmyAttacker()							{ return mArmyAttacker; }
function H7CombatConfiguration			GetCombatConfiguration()					{ return mCombatConfiguration; }
function H7CombatMapGridController		GetGridController()							{ return mGridController; }
function H7AiCombatMap					GetAI()										{ return mAI; }
function H7CoverManager					GetCoverManager()							{ return mCoverManager; }
function H7Unit							GetActiveUnit()								{ return mActiveUnit; }
function bool							HasEnoughCurrencyForSurrender()				{ return GetActiveArmy().GetPlayer().GetResourceSet().GetCurrency() >= GetActiveArmy().GetSurrenderPrice(); }
function bool							IsInTacticsPhase()							{ return IsInState( 'Tactics' ); }
function bool							IsInNonCombatPhase()						{ return !IsInState( 'Combat' ); }
function bool                           IsSomeoneDying()							{ return mIsSomeoneDying; }
function                                SetSomeoneDying( bool isDying )				{ mIsSomeoneDying = isDying; }
function bool							IsEndOfCombat()								{ return IsInState( 'EndOfCombat' ); }
function string                         GetDisableFleeSurrenderArtifact()			{ return mDisableFleeSurrenderArtifact; }
function string                         GetHeroWithDisableFleeSurrender()			{ return mHeroWithDisableFleeSurrender; }
function                                StartBadMoraleDelay( optional float time = -1.f, optional bool doSkipTurnCommand = false )
{
	if( mCurrentTimeBadMorale >= mBadMoraleTime )
	{
		if( time < 0.f ) mBadMoraleTime = mCombatConfiguration.mBadMoraleWaitTime;
		else mBadMoraleTime = time;
		mSkipTurnCommand = doSkipTurnCommand;
		mCurrentTimeBadMorale = 0.f;
	}
}
function string GetTurnName()
{
	if(Len(mTurnNameInst) == 0)
	{
		mTurnNameInst = class'H7Loca'.static.LocalizeField("H7Combat", "MMH7Game", "TURN", "TURN");
	}
	return mTurnNameInst;
}


// there is only one combat controller per level
static function H7CombatController GetInstance() { return class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetCombatController(); }

function bool IsLocalPlayerSpectator()
{
	return H7PlayerReplicationInfo( GetALocalPlayerController().PlayerReplicationInfo ).GetCombatPlayerType() == COMBATPT_SPECTATOR;
}

function H7CombatMapCell GetCellByID( int cellID )
{
	local array<GridColumns> gridCols;
	local GridColumns gridCol;
	local H7CombatMapCell cell;

	gridCols = mGridController.GetCombatGrid().GetGridArray();
	foreach gridCols( gridCol )
	{
		foreach gridCol.Row( cell )
		{
			if( cell.GetID() == cellID )
			{
				return cell;
			}
		}
	}
}

function bool CanRangeAttack( H7IEffectTargetable target ) { return false; }	        // is overridden in states
function bool IsFleePossible(optional out string blockReason) { return false; }			// is overridden in states
function bool IsSurrenderPossible(optional out string blockReason) { return false; }	// is overridden in states
function SetTacticPhaseFinishedMP( bool isDefender ){}							        // is overridden in states
function RaiseEventOnArray(array<H7IEffectTargetable> units, ETrigger event ){}         // is overridden in states
function SetActiveUnitHero(){}													        // is overridden in states
function SetPreviousActiveUnit(){}												        // is overridden in states
function bool AllowCurrentUnitAction(){}						                        // is overridden in states
function bool ArtifactAllowsFleeSurrender() { return false; }	                        // is overridden in states

function bool AllAnimationsDone() { return true; }                                      // is overridden in states

function H7Player GetPlayerByNumber( EPlayerNumber playerNumber)
{
	if( mArmyAttacker.GetPlayerNumber() == playerNumber )
	{
		return mArmyAttacker.GetPlayer();
	}
	else if( mArmyDefender.GetPlayerNumber() == playerNumber )
	{
		return mArmyDefender.GetPlayer();
	}
	return none;
}

// used by the OoS checker
function int GetTotalHealth()
{
	return mArmyAttacker.GetTotalHealth() + mArmyDefender.GetTotalHealth();
}

function SetGameSpeed( float newSpeed )
{
	mGameSpeed = newSpeed;
}

//=============================================================================
// Initialization
//=============================================================================

function PostBeginPlay()
{
	super.PostBeginPlay();

	class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().SetCombatController( self );

	class'H7ReplicationInfo'.static.PrintLogMessage("h7CombatController -> PostBeginPlay", 0);;
	// I am either in an editor level where a designer placed a grid(controller) or I am in a unit test level where nothing exists
	mGridController = class'H7CombatMapGridController'.static.GetInstance();
	mGameProcessor = class'H7ReplicationInfo'.static.GetInstance().GetGameProcessor();

	mHeroEventParam = new class'H7HeroEventParam';

	if(mGridController != none)
	{
		class'H7ReplicationInfo'.static.PrintLogMessage("h7CombatController -> mGridController", 0);;
		mPlacingAttackerDone = false;
		mPlacingDefenderDone = false;

		mGridController.SetCombatController(self);

		mCursor = new class'H7CombatMapCursor'();
		mCursor.Setup(self, mGridController);
		InitFCT();
		InitCameraActionController();
		Spawn(class'H7CombatMapStatusBarController', self);
		Spawn(class'H7CreatureStackPlateController', self);

		
		// Init the players and armies
		if ( IsCombatComingFromAdventureMap() )
		{ 
			InitPlayerAndArmy();
		}
		else                      
		{ 
			InitTemplatePlayersAndArmies(); 
		}
		
		InitCombatAI();

		mCoverManager = Spawn( class'H7CoverManager', self );

		mGridController.InitCellsForObstaclePlacement();
		mGridController.UpdateObstacles();
		mGridController.PlaceRandomObstacles();

		mGridController.UpdateSiegeMapDecoration();

	}
	else
	{
		;
	}
	//Reactivate Sound Channels after Loading Screen 
	class'H7SoundController'.static.GetInstance().EnableSoundChannel(true);
	class'H7SoundController'.static.GetInstance().EnableAmbientChannel(true);
	class'H7TransitionData'.static.GetInstance().SetIsMainMenu(false);

	SetTimer(1.0f, false, 'ApplyGameModeGfxSettings');
	SetTimer(1.0f, false, 'ApplyOutline');
}
//TODO: Use it
function LoadSummonableCreatureVisuals()
{
	local array<H7BaseAbility> abilities;
	local H7BaseAbility ability;
	local array<H7Effect> effects;
	local H7Effect effect;
	local H7IEffectDelegate delegate;
	local H7Creature creature;
	local array<H7Creature> summonables;

	abilities = mArmyAttacker.GetHero().GetAbilities();
	
	foreach abilities( ability )
	{
		effects = ability.GetEffectsOfType( 'H7EffectSpecial' );
		foreach effects( effect )
		{
			delegate = H7EffectSpecial( effect ).GetFunctionProvider();
			if( H7EffectSpecialSummonCreatureStack( delegate ) != none )
			{
				foreach H7EffectSpecialSummonCreatureStack( delegate ).mCreaturePool( creature )
				{
					if( summonables.Find( creature ) == INDEX_NONE )
					{
						summonables.AddItem( creature );
					}
				}
			}
		}
	}

	foreach summonables( creature )
	{
		creature.GetVisuals();
	}
}

// attempt to merge all common operations of BeginState and ActivateNextUnit
// called by BeginState for first unit
// called by ActivateNextUnit for all other units
function DoNewUnitHudUpdates() // dohudchanges
{
	local H7Message message;
	local H7CombatHud combatHUD;
	local H7PlayerController playerCntl;
	local H7MessageSystem msgSys;

	if( !IsInState( 'Combat' ) ) { return; }

	combatHUD = class'H7CombatHud'.static.GetInstance();
	playerCntl = class'H7PlayerController'.static.GetPlayerController();
	msgSys = class'H7MessageSystem'.static.GetInstance();

	//mAI.AllowThink();ombatmap
	combatHUD.GetCombatHudCntl().SetCreatureAbilityData(GetActiveUnit());
		
	if(GetActiveUnit().GetCombatArmy().GetPlayer().GetPlayerType() == PLAYER_HUMAN && 
		GetActiveUnit().GetCombatArmy().GetPlayer().IsControlledByAI())
	{
		combatHUD.GetCombatHudCntl().GetCombatMenu().ActivateFxOnAutoCombatButton(true, false); // TODO true if not look ugly anymore
	}
	else
	{
		combatHUD.GetCombatHudCntl().GetCombatMenu().ActivateFxOnAutoCombatButton(false);
	}
	
	if(mActiveUnit.GetCombatArmy().GetHero() != none)
	{
		playerCntl.GetHud().GetSpellbookCntl().SetHero(mActiveUnit.GetCombatArmy().GetHero());
		playerCntl.GetHud().GetSpellbookCntl().GetQuickBar().SetData(mActiveUnit.GetCombatArmy().GetHero(),true);
	}
	else if(H7EditorHero(mActiveUnit) != none)
	{
		playerCntl.GetHud().GetSpellbookCntl().SetHero(H7EditorHero(mActiveUnit));
		playerCntl.GetHud().GetSpellbookCntl().GetQuickBar().SetData(H7EditorHero(mActiveUnit),true);
	}
	else
	{
		playerCntl.GetHud().GetSpellbookCntl().GetQuickBar().SetVisibleSave(false);
	}

	// either I acted the hero, then I delete my own message
	// or I skipped the hero, then I delete the message of the other player
	msgSys.DeleteMessagesFrom( GetArmyDefender().GetHero() , MD_SIDE_BAR );
	msgSys.DeleteMessagesFrom( GetArmyAttacker().GetHero() , MD_SIDE_BAR );

								// this is used as "if is !in_tutorial"
	if(!class'H7ReplicationInfo'.static.GetInstance().mIsTutorial && mInitiativeQueue.IsLastUnitOfPlayer(mActiveUnit) && mInitiativeQueue.IsAWaitingUnit(mActiveUnit.GetCombatArmy().GetHero()) && mActiveUnit.GetPlayer().IsControlledByLocalPlayer() )
	{
		message = msgSys.GetMessageTemplates().mLastHeroChance.CreateMessageBasedOnMe();
		message.settings.referenceObject = mActiveUnit.GetCombatArmy().GetHero();

		msgSys.SendMessage(message);
	}
}

function ApplyGameModeGfxSettings()
{
	if (class'H7PlayerController'.static.GetPlayerController() == None)
	{
		SetTimer(1.0f, false, 'ApplyGameModeGfxSettings');
		return;
	}

	class'H7PlayerController'.static.GetPlayerController().ApplyGameModeGfxSettings(true);
}

function ApplyOutline()
{
	if (class'H7PlayerController'.static.GetPlayerController() == None)
	{
		SetTimer(1.0f, false, 'ApplyOutline');
		return;
	}

	class'H7ReplicationInfo'.static.GetInstance().GetPostprocessManager().ApplyGameTypeEffect(true);
}

private function CameraActionIntroduceHero()
{
	if (class'H7CameraActionController'.static.GetInstance() == none || class'H7PlayerController'.static.GetPlayerController().IsFlythroughRunning() )
	{
		SetTimer(0.1f, false, 'CameraActionIntroduceHero');
		return;
	}
	// No abortions... we can continue

	class'H7CameraActionController'.static.GetInstance().StartIntroduceHero(CameraActionPresentArmy);	
}

private function CameraActionPresentArmy()
{
	if (class'H7CameraActionController'.static.GetInstance() == none || class'H7PlayerController'.static.GetPlayerController().IsFlythroughRunning() )
	{	
		SetTimer(0.1f, false, 'CameraActionPresentArmy');
		return;
	}
	// No abortions... we can continue

	if(mGridController.IsSiegeMap() && mGridController.GetSiegeTownData().WallAndGateLevel > 0)
	{
		DonePresentArmy();
	}
	else
	{
		class'H7CameraActionController'.static.GetInstance().StartPresentArmy(DonePresentArmy);
	}
}

private function DonePresentArmy()
{
	GotoState('Combat');
}

protected function InitFCT()
{
	if( class'H7FCTController'.static.GetInstance() == none )
	{
		Spawn(class'H7FCTController', self);
	}
}

protected function InitCombatAI()
{
	mAI = Spawn(class'H7AiCombatMap', self);
}

function InitCameraActionController()
{
	if( class'H7CameraActionController'.static.GetInstance() == none )
	{
		Spawn(class'H7CameraActionController', self,,,, mCameraActionTemplate ,true);
	}
}

function InitTemplatePlayersAndArmies()
{
	local H7Player attackerPlayer, defenderPlayer;
	local H7EditorArmy attackerArmy, defenderArmy;
	local H7TransitionData transitionData;
	local array<PlayerLobbySelectedSettings> playerList;
	local PlayerLobbySelectedSettings attackerSettings, defenderSettings;
	local array<H7EditorHero> randomHeroes;
	local array<H7EditorHero> allHeroes;
	local array<H7EditorHero> factionHeroes;
	local H7EditorHero currentHero, randomHero;
	local array<H7Faction> factions;
	local bool isDuel;
	local int currentMana;
	local H7GameData gameData;

	transitionData = class'H7TransitionData'.static.GetInstance();
	gameData = class'H7GameData'.static.GetInstance();
	
	// creating the players
	attackerPlayer = Spawn(class'H7Player',self,'name',,,mPlayerAttackerTemplate);
	attackerPlayer.SetPlayerNumber( 1 );

	defenderPlayer = Spawn(class'H7Player',self,'name',,,mPlayerDefenderTemplate);
	defenderPlayer.SetPlayerNumber( 2 );
	
	// creating the armies
	if( transitionData.UseMe() )
	{
		isDuel = true;
		playerList = transitionData.GetPlayersSettings();
		
		if( playerList.Length < 2 )
		{
			;
			return;
		}

		attackerSettings = playerList[0].mPosition != 2 ? playerList[0] : playerList[1];
		defenderSettings = playerList[0].mPosition == 2 ? playerList[0] : playerList[1];

		if(WorldInfo.GRI.IsMultiplayerGame())
		{
			attackerPlayer.SetName( attackerSettings.mName );
			defenderPlayer.SetName( defenderSettings.mName );
		}
		else
		{
			attackerPlayer.SetName( class'H7Loca'.static.LocalizeSave("DUEL_POSITION_1","H7DuelSetup") );
			defenderPlayer.SetName( class'H7Loca'.static.LocalizeSave("DUEL_POSITION_2","H7DuelSetup") );
		}

		attackerPlayer.SetPlayerColor( attackerSettings.mColor );
		defenderPlayer.SetPlayerColor( defenderSettings.mColor );

		gamedata.GetFactions( factions );
		if(gamedata.GetRandomDuelArmy() == attackerSettings.mArmy)
		{
			if( attackerSettings.mFaction == gamedata.GetRandomFaction() )
			{
				attackerSettings.mFaction = factions[ class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( factions.Length ) ];
			}
			attackerSettings.mArmy = gamedata.GetRandomArmy( attackerSettings.mFaction );
		}
		if(gamedata.GetRandomDuelArmy() == defenderSettings.mArmy)
		{
			if( defenderSettings.mFaction == gamedata.GetRandomFaction() )
			{
				defenderSettings.mFaction = factions[ class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( factions.Length ) ];
			}
			defenderSettings.mArmy = gamedata.GetRandomArmy(defenderSettings.mFaction );
		}

		// calculating the random heroes
		gamedata.GetRandomHeroes( randomHeroes );
		gamedata.GetDuelHeroes(allHeroes);
		// check if the attacker player chose a random hero
		if( attackerSettings.mStartHero == gamedata.GetRandomHero() )
		{
			foreach randomHeroes( randomHero )
			{
				if( randomHero.GetFaction() == attackerSettings.mFaction )
				{
					attackerSettings.mStartHero = randomHero;
					break;
				}
			}
		}

		if( defenderSettings.mStartHero == gamedata.GetRandomHero() )
		{
			foreach randomHeroes( randomHero )
			{
				if( randomHero.GetFaction() == defenderSettings.mFaction )
				{
					defenderSettings.mStartHero = randomHero;
					break;
				}
			}
		}

		if( randomHeroes.Find( attackerSettings.mStartHero ) != INDEX_NONE )
		{
			ForEach allHeroes( currentHero )
			{
				if( currentHero.GetFaction() == attackerSettings.mStartHero.GetFaction() )
				{
					factionHeroes.AddItem( currentHero );
				}
			}

			attackerSettings.mStartHero = factionHeroes[class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(factionHeroes.Length)];
		}
		// check if the defender player chose a random hero
		if( randomHeroes.Find( defenderSettings.mStartHero ) != INDEX_NONE )
		{
			factionHeroes.Length = 0;
			ForEach allHeroes( currentHero )
			{
				if( currentHero.GetFaction() == defenderSettings.mStartHero.GetFaction() )
				{
					factionHeroes.AddItem( currentHero );
				}
			}

			defenderSettings.mStartHero = factionHeroes[class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(factionHeroes.Length)];
		}
		
		// Save random into the player so after restart he gets same setup
		transitionData.SetPlayerArmySettings(0, attackerSettings.mFaction, attackerSettings.mStartHero, attackerSettings.mArmy);
		transitionData.SetPlayerArmySettings(1, defenderSettings.mFaction, defenderSettings.mStartHero, defenderSettings.mArmy);

		attackerArmy = Spawn(class'H7EditorArmy', Self , , , , attackerSettings.mArmy );
		attackerArmy.SetHeroTemplate( attackerSettings.mStartHero );
		if( attackerSettings.mSlotState == EPlayerSlotState_AI )
		{
			attackerPlayer.SetPlayerType( PLAYER_AI );
		}
		else
		{
			attackerPlayer.SetPlayerType( PLAYER_HUMAN );
		}
		defenderArmy = Spawn(class'H7EditorArmy', Self , , , , defenderSettings.mArmy );
		defenderArmy.SetHeroTemplate( defenderSettings.mStartHero );
		if( defenderSettings.mSlotState == EPlayerSlotState_AI )
		{
			defenderPlayer.SetPlayerType( PLAYER_AI );
		}
		else
		{
			defenderPlayer.SetPlayerType( PLAYER_HUMAN );
		}
		attackerPlayer.SetFaction( attackerArmy.GetHeroTemplate().GetFaction() );
		defenderPlayer.SetFaction( defenderArmy.GetHeroTemplate().GetFaction() );

		
		/// TRACKING
		TrackingMapStart();

		transitionData.SetUseMe( false );
	}
	else
	{
		attackerArmy = Spawn(class'H7EditorArmy', Self , , , , H7EditorArmy( DynamicLoadObject(mArmyAttackerDefaultSetup, class'H7EditorArmy') ));
		defenderArmy = Spawn(class'H7EditorArmy', Self , , , , H7EditorArmy( DynamicLoadObject(mArmyDefenderDefaultSetup, class'H7EditorArmy') ));
	}
    
	mArmyAttacker = attackerArmy.CreateCombatArmy();
	mArmyDefender = defenderArmy.CreateCombatArmy();

	attackerArmy.Destroy();
	defenderArmy.Destroy();

	// assigning the army to the player
	mArmyAttacker.SetPlayer( attackerPlayer );
	mArmyDefender.SetPlayer( defenderPlayer );
	
	mArmyAttacker.SetIsAttacker( true );
	mArmyDefender.SetIsAttacker( false );

	mPlacingAttackerDone = mArmyAttacker.AutoplaceUnits();
	mPlacingDefenderDone = mArmyDefender.AutoplaceUnits();
	
	if( isDuel ) 
	{
		// max mana since its a Duel
		mArmyAttacker.GetHero().ClearStatCache();
		currentMana = mArmyAttacker.GetHero().GetMaxMana();
		mArmyAttacker.GetHero().SetCurrentMana( currentMana );
		mArmyDefender.GetHero().ClearStatCache();
		currentMana = mArmyDefender.GetHero().GetMaxMana();
		mArmyDefender.GetHero().SetCurrentMana( currentMana );
	}

	if( isDuel )
	{
		if(class'H7PlayerProfile'.static.GetInstance() != none && class'H7PlayerProfile'.static.GetInstance().GetAchievementManager() != none)
		{
			if(class'H7PlayerProfile'.static.GetInstance().GetAchievementManager().GetStateReward_PM() && class'H7PlayerProfile'.static.GetInstance().GetAchievementManager().CanRewardBeUsed() )
			{
				class'H7PlayerController'.static.GetPlayerController().SetPixellated(true);
			}
		}
	}

	mTacticsStartable = true;
	CheckStartable();
}

function CheckStartable()
{
	local array<H7CreatureStack> unitList;
	local H7CreatureStack stack;
	local bool canStart;
	local int deployedStacks;

	if( !mPlacingAttackerDone && ShouldTakeCareOfArmy(mArmyAttacker) )
	{
		unitList = mArmyAttacker.GetCreatureStacks();
	}
	else if( !mPlacingDefenderDone && ShouldTakeCareOfArmy(mArmyDefender) )
	{
		unitList = mArmyDefender.GetCreatureStacks();
	}
	else
	{
		// placing done
		canStart = true;
	}

	foreach unitList(stack) 
	{
		if( stack.IsVisible() )
		{
			deployedStacks++;
		}
	}

	if(deployedStacks > 0) canStart = true;
	
	if(deployedStacks >= GetMaxDeployNumber())
	{
		class'H7CombatHudCntl'.static.GetInstance().GetDeploymentBar().SetMaxDeployed(true);
	}
	else
	{
		class'H7CombatHudCntl'.static.GetInstance().GetDeploymentBar().SetMaxDeployed(false);
	}

	if(canStart != mTacticsStartable) // only send to flash if a change happened
	{
		class'H7CombatHudCntl'.static.GetInstance().GetCombatMenu().SetStartable(canStart);
		mTacticsStartable = canStart;
	}
}

public function bool IsBadMoraleDelayRunning()
{
	return mCurrentTimeBadMorale < mBadMoraleTime;
}

function int GetMaxDeployNumber()
{
	if( !mPlacingAttackerDone && ShouldTakeCareOfArmy(mArmyAttacker) )
	{
		return mArmyAttacker.GetHero().GetMaxDeploymentNumber();
	}
	else if (!mPlacingDefenderDone && ShouldTakeCareOfArmy(mArmyDefender))
	{
		return mArmyDefender.GetHero().GetMaxDeploymentNumber();
	}

	return 7;
}

function int GetLocalGuardSlots()
{
	local H7AreaOfControlSite site;

	if ( !mPlacingAttackerDone && ShouldTakeCareOfArmy(mArmyAttacker) ) 
	{
		return 0;
	}

	if (!mPlacingDefenderDone && ShouldTakeCareOfArmy(mArmyDefender))
	{
		if( class'H7AdventureController'.static.GetInstance() != none )
		{
			site = class'H7AdventureController'.static.GetInstance().GetBeforeBattleArea();
		
			if( H7Town(site) != none )
			{
				return H7Town(site).GetLocalGuardSlots();
			}
			if( H7Fort(site) != none )
			{
				//return H7Fort(site).GetLocalGuardSlots(); // TODO activate if exits and design checked
				return mCombatConfiguration.GetDefaultLocGuardSlots();
			}
			if( H7Garrison(site) != none )
			{
				//return H7Garrison(site).GetLocalGuardSlots(); // TODO activate if exits and design checked
				return mCombatConfiguration.GetDefaultLocGuardSlots();
			}
		}
		return 0;
	}
}

/**
 * Initialize Players and Armies given from the adventuremap
 **/
function InitPlayerAndArmy()
{
	local H7AdventureController advCntl;
	
	advCntl = class'H7AdventureController'.static.GetInstance();

	mArmyAttacker = CreateCombatArmyUsingAdventureArmy( advCntl.GetArmyAttacker(), true );
	mArmyDefender = CreateCombatArmyUsingAdventureArmy( advCntl.GetArmyDefender(), false );
	advCntl.SetArmyAttackerCombat( mArmyAttacker );
	advCntl.SetArmyDefenderCombat( mArmyDefender );

	// place the units
	if (mArmyDefender.mIsAmbush)
	{
		mPlacingAttackerDone = mArmyAttacker.AutoplaceUnitsAmbush();
		mPlacingDefenderDone = mArmyDefender.AutoplaceUnitsAmbush();
		// bools will be set to false again later for humans (to go into tactics phase)
	}
	else
	{
		mPlacingAttackerDone = mArmyAttacker.AutoplaceUnits();
		mPlacingDefenderDone = mArmyDefender.AutoplaceUnits();
		// bools will be set to false again later for humans (to go into tactics phase)
	}
	mTacticsStartable = true;
	CheckStartable();
}

protected function H7CombatArmy CreateCombatArmyUsingAdventureArmy( H7AdventureArmy army, bool isAttacker )
{
	local H7CombatArmy combatArmy;

	army.GetHero().SetArmy( army ); // important crosslink because sometimes we only have the HeroObject
	combatArmy = Spawn( class'H7CombatArmy', self );
	combatArmy.SetHeroTemplate( army.GetHeroTemplate() );
	combatArmy.SetBaseCreatureStacks( army.GetBaseCreatureStacks() );
	combatArmy.mIsAmbush = army.mIsAmbush;
	combatArmy.SetWarUnitTemplates( army.GetWarUnitTemplates() );
	combatArmy.SetAdventureHero( army.GetHero() );

	combatArmy.SetDeployment( army.GetDeployment() );
	if( army.GetDeployment() != none )
	{
		;
	}
	combatArmy.SetPlayer( army.GetPlayer() );
	combatArmy.SetIsAttacker( isAttacker );

	return combatArmy;
}

function bool IsCombatComingFromAdventureMap()
{
	return class'H7AdventureController'.static.GetInstance() != none;
}

function InitInitiativeQueue(optional bool firstRound)
{
	if( IsCombatComingFromAdventureMap() )
	{
		class'H7AdventureController'.static.GetInstance().IncrementTrackingRoundCounter();
		if( mArmyAttacker.GetPlayer().IsControlledByAI() && mArmyAttacker.GetPlayer().GetPlayerType() == PLAYER_HUMAN || mArmyDefender.GetPlayer().IsControlledByAI() && mArmyDefender.GetPlayer().GetPlayerType() == PLAYER_HUMAN )
		{
			class'H7AdventureController'.static.GetInstance().IncrementTrackingRoundCounterAutoCombat();
		}
	}
	else
	{
		mNumberOfRoundsInFightsTotal++;
		if( mArmyAttacker.GetPlayer().IsControlledByAI() && mArmyAttacker.GetPlayer().GetPlayerType() == PLAYER_HUMAN || mArmyDefender.GetPlayer().IsControlledByAI() && mArmyDefender.GetPlayer().GetPlayerType() == PLAYER_HUMAN )
		{
			mNumberOfRoundsInFightsAutoCombat++;
		}
	}

	if( firstRound )
	{
		mInitiativeQueue = new () class'H7InitiativeQueue';

		// fill queue with defender
		InitInsertArmyInInitiativeQueue( mArmyDefender, false );

		// fill queue with attacker
		InitInsertArmyInInitiativeQueue( mArmyAttacker, true );
	}

	mInitiativeQueue.InitializeQueue();
	mInitiativeQueue.Sort(false);
	mInitiativeQueue.SetHeroesFirst(mArmyAttacker.GetHero(), mArmyDefender.GetHero() );
	mActiveUnit = mInitiativeQueue.GetActiveUnit();
}

protected function InitInsertArmyInInitiativeQueue( H7CombatArmy army, bool isAttacker )
{
	local array<H7CreatureStack> ArmyCreatureStacks;
	local array<H7WarUnit> ArmyWarUnits;
	local array<H7TowerUnit> ArmyTowerUnits;
	local int i;

	ArmyCreatureStacks = army.GetDeployedCreatureStacks();
	ArmyWarUnits = army.GetWarUnits();
	ArmyTowerUnits = army.GetTowers();

	
	for( i=0; i<ArmyCreatureStacks.Length; i++ ) 
	{
		mInitiativeQueue.AddUnit( ArmyCreatureStacks[i], false );
	}
	for( i=0; i<ArmyWarUnits.Length; i++ ) 
	{
		mInitiativeQueue.AddUnit( ArmyWarUnits[i], false );
	}
	for( i=0; i<ArmyTowerUnits.Length; i++ ) 
	{
		mInitiativeQueue.AddUnit( ArmyTowerUnits[i], false );
	}
}

function array<H7StackDeployment> GetStackDeployments()
{
	local array<H7StackDeployment> unitList;

	unitList = GetCurrentlyDeployingArmy().GetDeployment().GetDeploymentData().StackDeployments;
	return unitList;
}

function array<H7CreatureStack> GetUnitsForDeployment()
{
	local array<H7CreatureStack> unitList;

	unitList = GetCurrentlyDeployingArmy().GetCreatureStacks();
	return unitList;
}

function H7CombatArmy GetCurrentlyDeployingArmy()
{
	if( !mPlacingAttackerDone && (!WorldInfo.GRI.IsMultiplayerGame() || mArmyAttacker.IsOwnedByPlayerMP()) )
	{
		return mArmyAttacker;
	}
	else if( !mPlacingDefenderDone && (!WorldInfo.GRI.IsMultiplayerGame() || mArmyDefender.IsOwnedByPlayerMP()) ) 
	{
		return mArmyDefender;
	}

	return none;
}


native function GetAllTargetable( out array<H7IEffectTargetable> outTargets );

// Tactics
// caused by flash
function PutUnitOnBar(int id)
{
	local H7CreatureStack spawnedStack;
	local array<H7BaseCreatureStack> baseStacks;
	local H7BaseCreatureStack baseStack;
	
	;

	baseStacks = GetCurrentlyDeployingArmy().GetBaseCreatureStacks();
	baseStack = baseStacks[id];
	;

	spawnedStack = baseStack.mSpawnedStackOnMap;
	;

	mGridController.TacticsReleaseUnit( true );
	spawnedStack.RemoveStackFromGrid();
}
// caused by flash
function PutUnitOnCursor(int id)
{
	local H7CreatureStack spawnedStack;
	local array<H7BaseCreatureStack> baseStacks;
	local H7BaseCreatureStack baseStack;
	
	;

	baseStacks = GetCurrentlyDeployingArmy().GetBaseCreatureStacks();
	baseStack = baseStacks[id];
	;

	spawnedStack = baseStack.mSpawnedStackOnMap;
	;

	mGridController.TacticsPickUnit(spawnedStack);
}

protected function InitializeAurasOnEnterCell()
{
	local array<H7CreatureStack> army;
	local H7CreatureStack creature;
	local H7EventContainerStruct container;
	

	army = mArmyAttacker.GetCreatureStacks();
	foreach army(creature)
	{
		container.TargetableTargets.Length = 0;
		container.TargetableTargets.AddItem( creature );
		container.Targetable = creature;
		creature.TriggerEvents( ON_ENTER_CELL, false, container );
	}

	army = mArmyDefender.GetCreatureStacks();
	foreach army(creature)
	{
		container.TargetableTargets.Length = 0;
		container.TargetableTargets.AddItem( creature );
		container.Targetable = creature;
		creature.TriggerEvents( ON_ENTER_CELL, false, container);
	}
}

//=============================================================================
// Actions
//=============================================================================

function SetActiveUnitCommand_SkipTurn( bool doMPSynchronization )
{
	if( mActiveUnit == None )
	{
		;
		return;
	}
	
	if(mCommandQueue.CanEnqueue())
	{
		mCommandQueue.Enqueue( class'H7Command'.static.CreateCommand( mActiveUnit, UC_SKIP_TURN,,,,, doMPSynchronization) );
	}
}

function SetActiveUnitCommand_Move( array<H7CombatMapCell> path, bool isMoveAttack = false )
{
	local ECommandTag commandTag;

	if( mActiveUnit == None )
	{
		;
		return;
	}
	if( mActiveUnit.GetEntityType() != UNIT_CREATURESTACK )
	{
		;
		return;
	}

	if(isMoveAttack)
	{
		commandTag = ACTION_MOVE_ATTACK;
	}
	else
	{
		commandTag = ACTION_MOVE;
	}
	
	if(mCommandQueue.CanEnqueue())
	{
		mCommandQueue.Enqueue( class'H7Command'.static.CreateCommand( mActiveUnit, UC_MOVE, commandTag , mActiveUnit.GetPreparedAbility(),,path ) );
	}
}

function SetActiveUnitCommand_MoveAttack( array<H7CombatMapCell> path, H7IEffectTargetable target )
{
	if( mActiveUnit == None )
	{
		;
		return;
	}

	if( mActiveUnit.GetEntityType() != UNIT_CREATURESTACK )
	{
		;
		return;
	}
	
	if( path.Length > 0 )
	{
		mCommandQueue.Enqueue( class'H7Command'.static.CreateCommand( mActiveUnit, UC_MOVE, ACTION_MOVE_ATTACK, mActiveUnit.GetPreparedAbility(), target, path ) );
	}

	if(mCommandQueue.CanEnqueue())
	{
		mCommandQueue.Enqueue( class'H7Command'.static.CreateCommand( mActiveUnit, UC_ABILITY, ACTION_MELEE_ATTACK, mActiveUnit.GetPreparedAbility(), target ) );
	}
}

function SetActiveUnitCommand_Flee( )
{
	local H7InstantCommandFleeOrSurrender command;

	class'H7CombatPlayerController'.static.GetCombatPlayerController().CancelSpellOnMouse();
	if(GetActiveArmy().GetHero()!=None) GetActiveArmy().GetHero().ResetPreparedAbility();

	command = new class'H7InstantCommandFleeOrSurrender';
	command.Init( true );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);
}

function SetActiveUnitCommand_FleeComplete( )
{
	local int XPWinner, XPLoser;

	if( IsFleePossible() )
	{
		XPWinner = GetActiveArmy().GetKilledCreaturesXP();
		XPLoser = GetOpponentArmy( GetActiveArmy() ).GetKilledCreaturesXP();
		GetActiveArmy().KillRemainingStacks();
		GetOpponentArmy( GetActiveArmy() ).DoVictory();
		GetOpponentArmy( GetActiveArmy() ).GetCombatHero().TriggerEvents( ON_BATTLE_XP_GAIN, false );
		XPWinner = GetOpponentArmy( GetActiveArmy() ).GetCombatHero().AddXp( XPWinner );	//	Give EXP to enemy hero
		GetActiveArmy().GetCombatHero().TriggerEvents( ON_BATTLE_XP_GAIN, false );
		XPLoser = GetActiveArmy().GetCombatHero().AddXp( XPLoser ); // Give EXP to my hero
		
		
		EndBattle();
		
		if( WorldInfo.GRI.IsMultiplayerGame() && !GetActiveArmy().IsOwnedByPlayerMP() )
		{
			class'H7CombatHud'.static.GetInstance().PrepareVictoryOrDefeatScreen( GetOpponentArmy( GetActiveArmy() ), true, XPWinner, XPLoser, true );
		}
		else
		{
			class'H7CombatHud'.static.GetInstance().PrepareFleeOrSurrenderScreen( GetActiveArmy(), true, XPWinner, XPLoser );
		}
	}
	else
	{
		;
	}
}

function SetActiveUnitCommand_Surrender()
{
	local H7InstantCommandFleeOrSurrender command;

	class'H7CombatPlayerController'.static.GetCombatPlayerController().CancelSpellOnMouse();
	if(GetActiveArmy().GetHero()!=None) GetActiveArmy().GetHero().ResetPreparedAbility();

	command = new class'H7InstantCommandFleeOrSurrender';
	command.Init( false );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);
}

function SetActiveUnitCommand_SurrenderComplete()
{
	local int XPWinner, XPLoser, gold;

	if( IsSurrenderPossible() && HasEnoughCurrencyForSurrender() )
	{
		mAnyDidSurrender = true; // mark battle as "anyone surrendered" so the loser doesn't get his army killed

		XPWinner = GetActiveArmy().GetKilledCreaturesXP();
		GetOpponentArmy( GetActiveArmy() ).GetCombatHero().TriggerEvents( ON_BATTLE_XP_GAIN, false );
		XPWinner = GetOpponentArmy( GetActiveArmy() ).GetCombatHero().AddXp( XPWinner );	//	Give EXP to enemy hero
		XPLoser = GetOpponentArmy( GetActiveArmy() ).GetKilledCreaturesXP();
		GetActiveArmy().GetCombatHero().TriggerEvents(ON_BATTLE_XP_GAIN, false );
		XPLoser = GetActiveArmy().GetCombatHero().AddXp( XPLoser ); // Give EXP to my hero

		// Give Currency (Gold) to enemy player
		gold = GetActiveArmy().GetSurrenderPrice();
		GetOpponentArmy( GetActiveArmy() ).GetPlayer().GetResourceSet().ModifyCurrency( gold );
		GetOpponentArmy( GetActiveArmy() ).DoVictory();
		GetActiveArmy().GetPlayer().GetResourceSet().ModifyCurrency( -gold );
		EndBattle();

		if( WorldInfo.GRI.IsMultiplayerGame() && !GetActiveArmy().IsOwnedByPlayerMP() )
		{
			class'H7CombatHud'.static.GetInstance().PrepareVictoryOrDefeatScreen( GetOpponentArmy( GetActiveArmy() ), true, XPWinner, XPLoser, false, gold );
		}
		else
		{
			class'H7CombatHud'.static.GetInstance().PrepareFleeOrSurrenderScreen( GetActiveArmy(), false, XPWinner, XPLoser, gold );
		}
	}
	else
	{
		;
	}	
}

function bool IsPlayerParticipatingInCombat(H7Player pl)
{
	return mArmyAttacker.GetPlayer() == pl || mArmyDefender.GetPlayer() == pl;
}

function LoseCombat()
{
	local int XPWinner, XPLoser;

	XPWinner = GetActiveArmy().GetKilledCreaturesXP();
	XPLoser = GetOpponentArmy( GetActiveArmy() ).GetKilledCreaturesXP();
	GetActiveArmy().KillRemainingStacks();
	GetOpponentArmy( GetActiveArmy() ).DoVictory();
	GetOpponentArmy( GetActiveArmy() ).GetCombatHero().TriggerEvents( ON_BATTLE_XP_GAIN, false );
	GetActiveArmy().GetCombatHero().TriggerEvents( ON_BATTLE_XP_GAIN, false );
	XPWinner = GetOpponentArmy( GetActiveArmy() ).GetCombatHero().AddXp( XPWinner );	//	Give EXP to enemy hero
	XPLoser = GetActiveArmy().GetCombatHero().AddXp( XPLoser ); // Give EXP to my hero

	EndBattle();
		
	if( WorldInfo.GRI.IsMultiplayerGame() && !GetActiveArmy().IsOwnedByPlayerMP() )
	{
		class'H7CombatHud'.static.GetInstance().PrepareVictoryOrDefeatScreen( GetOpponentArmy( GetActiveArmy() ), true, XPWinner, XPLoser, true );
	}
	else
	{
		class'H7CombatHud'.static.GetInstance().PrepareFleeOrSurrenderScreen( GetActiveArmy(), true, XPWinner, XPLoser );
	}
}

function WinCombat()
{
	local int XPWinner, XPLoser;
	
	GetOpponentArmy( GetActiveArmy() ).KillRemainingStacks();
	
	XPWinner = GetOpponentArmy( GetActiveArmy() ).GetKilledCreaturesXP();
	XPLoser = GetActiveArmy().GetKilledCreaturesXP();
	
	GetActiveArmy().DoVictory();
	GetActiveArmy().GetCombatHero().TriggerEvents( ON_BATTLE_XP_GAIN, false );
	GetOpponentArmy( GetActiveArmy() ).GetCombatHero().TriggerEvents( ON_BATTLE_XP_GAIN, false );
	XPWinner = GetActiveArmy().GetCombatHero().AddXp( XPWinner ); // Give EXP to my hero
	XPLoser = GetOpponentArmy( GetActiveArmy() ).GetCombatHero().AddXp( XPLoser );	//	Give EXP to enemy hero
	
	EndBattle();

	// show victory screen if it is singleplayer and the winner is human or if it is multiplayer and the winner is owned by the player
	if( (!WorldInfo.GRI.IsMultiplayerGame() && GetActiveArmy().GetPlayer().GetPlayerType() == PLAYER_HUMAN) || (WorldInfo.GRI.IsMultiplayerGame() && GetActiveArmy().IsOwnedByPlayerMP()) )
	{
		class'H7CombatHud'.static.GetInstance().PrepareVictoryOrDefeatScreen( GetActiveArmy(), true, XPWinner, XPLoser );
	}
	else
	{
		class'H7CombatHud'.static.GetInstance().PrepareVictoryOrDefeatScreen( GetOpponentArmy( GetActiveArmy() ), false, XPWinner, XPLoser );
	}
}

// the hero took the turn of the creature that got the current turn to do a normal attack or cast a spell
function bool IsHeroInCreatureTurn()
{
	return mActiveUnit.IsA( 'H7CombatHero' ) && mInitiativeQueue.GetActiveUnit(true) != GetActiveUnit();
}

// the hero can do an action in the creature turn
function bool CanHeroDoActionInCreatureTurn()
{
	if( mActiveUnit.IsA( 'H7CombatHero' ) )
	{
		return false;
	}

	if(!mActiveUnit.GetCombatArmy().GetHero().IsHero()) // is dummy critter hero
	{
		return false;
	}

	if(!mInitiativeQueue.IsARemainingUnit( mActiveUnit.GetCombatArmy().GetHero() ) )
	{
		return false;
	}

	if(!mActiveUnit.CanMakeAction())
	{
		return false;
	}

	if(!mActiveUnit.GetPlayer().IsControlledByLocalPlayer())
	{
		return false;
	}

	return true;
}

function SetActiveUnit( H7Unit unit ) { mActiveUnit = unit; }

// issue commands to active unit (overridden in states)
function bool SetActiveUnitCommand_PrepareAbility(H7BaseAbility ability) {}
function SetActiveUnitCommand_UsePreparedAbility( H7IEffectTargetable target, optional EDirection direction = EDirection_MAX, optional H7CombatMapCell trueHitCell, optional ECommandTag commandTagOverride = ACTION_MAX ) {}

//=============================================================================
// Turn handling
//=============================================================================

function SkipTurn()
{
	mActiveUnit.SetSkipTurn( true );
	FinishActiveUnitTurn();
}

// overriden in states	
function NextPlayer(){} 
// overriden in states
protected function  bool FinishActiveUnitTurn(optional bool triggerUnitEndTurn = true){}
// overriden in states
function TravelBack(){}

function CalculateInputAllowed( optional bool waitForAnimIfNecessary = true )
{
	class'H7PlayerController'.static.GetPlayerController().SetIsUnrealInputAllowed( false );
}

function EndBattle(optional bool isRestarting = false)
{
	local H7AdventureArmy victoriousArmy;
	local H7AdventureController adventureControl;
	local H7EventContainerStruct empty;

	adventureControl = class'H7AdventureController'.static.GetInstance();

	class'H7PlayerController'.static.GetPlayerController().SetIsUnrealInputAllowed( false );

	// close the unit info windows
	class'H7PlayerController'.static.GetPlayerController().GetCombatMapHud().GetUnitInfoCntl().GetUnitInfoDefender().Hide();
	class'H7PlayerController'.static.GetPlayerController().GetCombatMapHud().GetUnitInfoCntl().GetUnitInfoAttacker().Hide();

	// delete hero messages in case there is one
	class'H7MessageSystem'.static.GetInstance().DeleteMessagesFrom( GetArmyDefender().GetHero() , MD_SIDE_BAR );
	class'H7MessageSystem'.static.GetInstance().DeleteMessagesFrom( GetArmyAttacker().GetHero() , MD_SIDE_BAR );

	// trigger event so we can put sequences in kismet before victory screen
	if(IsCombatComingFromAdventureMap())
	{
		RaiseEventOnArmiesStacks( ON_COMBAT_END, mArmyAttacker, false );
		RaiseEventOnArmiesStacks( ON_COMBAT_END, mArmyDefender, false );
		mArmyAttacker.GetHero().TriggerEvents( ON_COMBAT_END, false, empty );
		mArmyDefender.GetHero().TriggerEvents( ON_COMBAT_END, false, empty );

		if(!isRestarting)
		{
			victoriousArmy = mArmyAttacker.WonBattle() ? adventureControl.GetArmyAttacker() : adventureControl.GetArmyDefender();
			mHeroEventParam.mEventHeroTemplate = adventureControl.GetArmyAttacker().GetHeroTemplateSource();
			mHeroEventParam.mEventPlayerNumber = adventureControl.GetArmyAttacker().GetPlayerNumber();
			mHeroEventParam.mEventEnemyPlayerNumber = adventureControl.GetArmyDefender().GetPlayerNumber();
			mHeroEventParam.mEventTargetArmy = adventureControl.GetArmyDefender();
			mHeroEventParam.mCombatMapName = class'H7ReplicationInfo'.static.GetInstance().GetCurrentMapName();
			mHeroEventParam.mEventVictoriousArmy = victoriousArmy;
		
			class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_CombatMapEnd', mHeroEventParam, victoriousArmy);
		}
	}
	else 
	{
		/// TRACKING DUEL 
		TrackingMapEnd("MAPEND");
	}

	mArmyAttacker.CleanAllUnitsAbilitiesAfterCombat();
	mArmyDefender.CleanAllUnitsAbilitiesAfterCombat();

	mGameProcessor.ClearResults();
	mCommandQueue.Clear();

	mCheckEndCombatImmediately = false;
	GotoState('CombatEpilog');
}


function string GetCurrentGameMode()
{
	if( WorldInfo.GRI.IsMultiplayerGame() )
	{
		if(  class'H7ReplicationInfo'.static.GetInstance().IsLAN() )
		{
			return "LAN";
		}

		return "MULTIPLAYER";
	}
	else if(  GetArmyDefender().GetPlayer().IsControlledByLocalPlayer() && GetArmyAttacker().GetPlayer().IsControlledByLocalPlayer() )
	{
		return "HOTSEAT";
	}
	else
	{
		return "SINGLEPLAYER";
	}
}

function RefreshAllUnits()
{
	local bool combatContinues;

	combatContinues = mArmyAttacker.RefreshAllUnits();
	combatContinues = combatContinues && mArmyDefender.RefreshAllUnits();
	mGridController.GetCombatGrid().ResetAttackPositionCache();
	mGridController.SetDecalDirty( true );

	if(!combatContinues)
	{
		mIsLastStackDying = true;
		mCheckEndCombatImmediately = true;
	}
}

function TeleportSpellWasCanceled()
{
	mArmyAttacker.TeleportSpellWasCanceled();
	mArmyDefender.TeleportSpellWasCanceled();
}

function DestroyAllStackGhosts()
{
	mArmyAttacker.DestroyStackGhosts();
	mArmyDefender.DestroyStackGhosts();
}

native function RaiseEvent( ETrigger trigger, optional bool simulate=false, optional H7CombatArmy army, optional H7EventContainerStruct container );

native function RaiseEventOnArmiesStacks( ETrigger trigger, H7CombatArmy army,optional bool simulate = false, optional H7EventContainerStruct container );

native function RaiseEventOnArmiesTowers( ETrigger trigger, H7CombatArmy army, optional bool simulate = false, optional H7EventContainerStruct container );

native function RaiseEventOnArmiesWarUnits( ETrigger dasTrigger, H7CombatArmy army, optional bool simulate = false, optional H7EventContainerStruct container );


// only used for multiplayer, so combat is in sync
function StartCombat()
{
	if(WorldInfo.GRI.IsMultiplayerGame())
	{
		class'H7CombatHudCntl'.static.GetInstance().SetWaitingForPlayers( false );
	}

	if( class'H7ReplicationInfo'.static.GetInstance().IsMultiplayerGame()
		&& class'H7AdventureController'.static.GetInstance() != none
		&& class'H7AdventureController'.static.GetInstance().GetLocalPlayer() != mArmyAttacker.GetPlayer()
		&& class'H7AdventureController'.static.GetInstance().GetLocalPlayer() != mArmyDefender.GetPlayer()
		&& !class'H7AdventureController'.static.GetInstance().IsSpectatorMode())
	{
		class'H7SpectatorHUDCntl'.static.GetInstance().Update();
		class'H7LogSystemCntl'.static.GetInstance().GetLog().SetVisibleSave(false);
	}

	mCommandQueue.Clear();
	class'H7ReplicationInfo'.static.GetInstance().ResetCombatUnitTurnCounter();
	// if the combat is not an ambush, check if any army requests manual setup (triggered by commanding heroes tactics ability)
	
	if( ( !mPlacingAttackerDone || !mPlacingDefenderDone  ) && !mArmyDefender.mIsAmbush )
	{
		GotoState('Tactics');
	}
	else
	{
		GotoState('PrePresentHeroArmy');
	}
}

function ResetCurrentTurnTimer()
{
	local ETimerCombat timer;

	timer = TIMER_COMBAT_NONE;

	if( class'H7AdventureController'.static.GetInstance() != none )
	{
		timer = class'H7AdventureController'.static.GetInstance().GetGameSettings().mTimerCombat;
	}
	else
	{
		timer = class'H7TransitionData'.static.GetInstance().GetGameSettings().mTimerCombat;
	}
		
	switch( timer )
	{
		case TIMER_COMBAT_NONE: mCurrentTurnTimeLeft = -1.f; break;
		case TIMER_COMBAT_10_SECONDS: mCurrentTurnTimeLeft = 10.f; break;
		case TIMER_COMBAT_15_SECONDS: mCurrentTurnTimeLeft = 15.f; break;
		case TIMER_COMBAT_20_SECONDS: mCurrentTurnTimeLeft = 20.f; break;
		case TIMER_COMBAT_30_SECONDS: mCurrentTurnTimeLeft = 30.f; break;
		case TIMER_COMBAT_60_SECONDS: mCurrentTurnTimeLeft = 60.f; break;
	}

	//mCurrentTurnTimeLeft = 15.f; // TODO: REMOVE AFTER TEST
	if( mCurrentTurnTimeLeft != -1.f )
	{
		class'H7CombatHudCntl'.static.GetInstance().GetTimer().SetTimerMax( mCurrentTurnTimeLeft );
	}
	else
	{
		class'H7CombatHudCntl'.static.GetInstance().GetTimer().ShowTimer(false);
	}
}

function ResetTimerForTactics()
{
	mCurrentTurnTimeLeft = TACTICS_PHASE_TIMER;
	class'H7CombatHudCntl'.static.GetInstance().GetTimer().SetTimerMax( mCurrentTurnTimeLeft );
}

function UpdateCurrentTurnTimer( float elapsedTime )
{
	local int previousSecond, currentSecond;
	local bool commandRunning;
	local H7BaseAbility skipTurnAbility;

	if( ( mCurrentTurnTimeLeft != -1.f && mCurrentTurnTimeLeft != 0.f ) || mForceEndTurnAfterAnim )
	{
		previousSecond = mCurrentTurnTimeLeft;
		mCurrentTurnTimeLeft -= elapsedTime;
		currentSecond = mCurrentTurnTimeLeft;

		if( currentSecond != previousSecond )
		{
			class'H7CombatHudCntl'.static.GetInstance().GetTimer().SetCurrentTimeLeft( mCurrentTurnTimeLeft );
		}
		
		if( mCurrentTurnTimeLeft <= 0.f )
		{
			if(IsInTacticsPhase())
			{
				NextPlayer();
				ResetCurrentTurnTimer();
			}
			else
			{
				commandRunning = class'H7BaseGameController'.static.GetBaseInstance().GetCommandQueue().IsCommandRunning();
				mCurrentTurnTimeLeft = 0.f;
				if( GetActiveUnit().GetPlayer().IsControlledByLocalPlayer() && !commandRunning )
				{
					mForceEndTurnAfterAnim = false;
					class'H7CombatPlayerController'.static.GetCombatPlayerController().CancelSpellOnMouse();
					skipTurnAbility = GetActiveUnit().GetSkipTurnAbility();
					if(GetActiveUnit().CanDefend())
					{
						GetActiveUnit().Defend();
					}
					else if(skipTurnAbility != none)
					{
						GetActiveUnit().PrepareAbility(  skipTurnAbility );
						class'H7CombatController'.static.GetInstance().SetActiveUnitCommand_UsePreparedAbility( none );
					}
				}
				else if( commandRunning )
				{
					// in case some command is still running or an animation is playing: force end turn as soon as
					// the dude is done! else the timer will be at 0.0f and the turn duration becomes infinite
					mForceEndTurnAfterAnim = true;
				}
			}
		}
	}
}


function AddAbilityTrackingData( H7AbilityTrackingData data )
{
	local int index;
	index = mAbilityTrackingData.Find( 'AbilityName', data.AbilityName );
	if( index == INDEX_NONE )
	{
		data.NumberOfCasts = 1;
		mAbilityTrackingData.AddItem( data );
		index = mAbilityTrackingData.Length - 1;
	}
	else
	{
		mAbilityTrackingData[ index ].NumberOfCasts = mAbilityTrackingData[ index ].NumberOfCasts + 1;
		//mAbilityTrackingData[ index ].CasterName = mAbilityTrackingData[ index ].CasterName @ data.CasterName;
	}
	;
}

function array<H7AbilityTrackingData> GetAbilityTrackingData()
{
	return mAbilityTrackingData;
}

function TrackingGameModeEnd()
{   
	OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).PushEvent("UTT_GAMEMODE_STOP","DUEL."$GetCurrentGameMode(), new class'JsonObject'()  );	
}

function TrackingMapStart()
{
		local JsonObject obj;
		local int p1,p2, year,month,day,hours,minutes,seconds,dayoftheweek,mseconds;
		local array<PlayerLobbySelectedSettings> playerList;
		local string mapstring;

		playerList = class'H7TransitionData'.static.GetInstance().GetPlayersSettings();
		
		mapstring = class'H7TransitionData'.static.GetInstance().GetMapSettings().mMapFileName; 
		p1 = int(playerList[0].mPosition);
		p2 = int(playerList[1].mPosition);

		obj = new class'JsonObject'();
		obj.SetIntValue("mapOrderId",class'H7PlayerProfile'.static.GetInstance().GetNumOfMapStarts() );
		obj.SetStringValue("mapID", mapstring );
		
		obj.SetStringValue("player"$p1$"Faction",  playerList[0].mFaction.GetArchetypeID() );
		obj.SetStringValue("player"$p2$"Faction",  playerList[1].mFaction.GetArchetypeID() );
		obj.SetStringValue("player"$p1$"SlotType", string(  playerList[0].mSlotState ));
		obj.SetStringValue("player"$p2$"SlotType", string(  playerList[1].mSlotState ));

		if( playerList[0].mSlotState == EPlayerSlotState_AI )
		{
			obj.SetStringValue("player"$p1$"AIDifficulty", string(  playerList[0].mAIDifficulty) );
		}
		else
		{
			obj.SetStringValue("player"$p1$"AIDifficulty", "N/A" );
		}

		if( playerList[1].mSlotState == EPlayerSlotState_AI )
		{
			obj.SetStringValue("player"$p2$"AIDifficulty", string( playerList[1].mAIDifficulty) );

		}
		else
		{
			obj.SetStringValue("player"$p2$"AIDifficulty", "N/A" );
		}
		
		obj.SetIntValue("player"$p1$"Team", -1);
		obj.SetIntValue("player"$p2$"Team", -1);	
		
		
		obj.SetStringValue("mapDifficulty",     "N/A"  );
		obj.SetBoolValue("isHost",  class'H7PlayerController'.static.GetPlayerController().IsServer() );
		
		class'H7PlayerController'.static.GetPlayerController().GetSystemTime(year,month,dayoftheweek,day,hours,minutes,seconds,mseconds);

		
		mUniqueGameName = class'OnlineSubsystem'.static.UniqueNetIdToString( OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).LoggedInPlayerId ) $ "_" $year$month$day$hours$minutes$seconds;
		
		obj.SetStringValue("uniqueGameName", mUniqueGameName );
		
		OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).PushEvent("UTT_MAP_START", mapstring, obj );
}

function SendTrackingCombatDataDuel()
{
	local JsonObject obj;
	obj = new class'JsonObject'() ;
	obj.SetIntValue("nbFights", 1);
	obj.SetIntValue("nbFightsManual", 1);
	obj.SetIntValue("nbRounds", mNumberOfRoundsInFightsTotal);
	obj.SetIntValue("nbRoundsAutoCombat", mNumberOfRoundsInFightsAutoCombat);
	obj.SetIntValue("playerPosition", GetLocalPlayer().GetPlayerNumber() );
	OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).PushEvent("UTT_COMBAT_RECAP","combats.recap", obj );
	;
}

function TrackingMapEnd(string reason)
{
	local int p1,p2;
	local JsonObject obj;
	local bool player1Won,player2Won;
	local array<PlayerLobbySelectedSettings> playerList;
	local string mapstring;
	
	// sending duel data
	if( class'H7AdventureController'.static.GetInstance() == none )
	{
		SendTrackingCombatDataDuel();
	}

	playerList = class'H7TransitionData'.static.GetInstance().GetPlayersSettings();
	mapstring = class'H7TransitionData'.static.GetInstance().GetMapSettings().mMapFileName; 
	
	p1 = int(playerList[0].mPosition);
	p2 = int(playerList[1].mPosition);

	SendTrackingSpellUsed();
    
	if ( playerList[0].mPosition != 2 ) 
    {
		player1Won = GetArmyAttacker().WonBattle();
    }
	else 
	{
		Player1Won = GetArmyDefender().WonBattle();
	}
 
	if ( playerList[1].mPosition != 2 ) 
    {
		player2Won = GetArmyAttacker().WonBattle();
    }
	else 
	{
		player2Won = GetArmyDefender().WonBattle();
	}


	obj = new class'JsonObject'() ;
	obj.SetIntValue("mapOrderId", class'H7PlayerProfile'.static.GetInstance().GetNumOfMapStarts() );
	obj.SetStringValue("mapID", mapstring);
		
	obj.SetStringValue("player"$p1$"Faction",  playerList[0].mFaction.GetArchetypeID() );
	obj.SetStringValue("player"$p2$"Faction",  playerList[1].mFaction.GetArchetypeID() );
	obj.SetStringValue("player"$p1$"SlotType", string(  playerList[0].mSlotState ));
	obj.SetStringValue("player"$p2$"SlotType", string(  playerList[1].mSlotState ));

	obj.SetBoolValue("player"$p1$"HasWon", player1Won );
	obj.SetBoolValue("player"$p2$"HasWon", player2Won );
	obj.SetIntValue("player"$p1$"Team", -1);
	obj.SetIntValue("player"$p2$"Team", -1);

	obj.SetStringValue("endReason",         reason);
	obj.SetStringValue("mapDifficulty",     "N/A"  );
	obj.SetIntValue("nbTurns",              -1 );

	obj.SetIntValue("playTime",             class'H7PlayerProfile'.static.GetInstance().GetDuelMapTimeMin() );
    class'H7PlayerProfile'.static.GetInstance().ResetDuelTimers();

	obj.SetIntValue("nbMapLaunchUntilCompletion",-1 );      
	obj.SetBoolValue("isHost",              class'H7PlayerController'.static.GetPlayerController().IsServer() );
	obj.SetStringValue("uniqueGameName",    mUniqueGameName);

	OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).PushEvent("UTT_MAP_STOP",mapstring, obj );
}

function SendTrackingSpellUsed()
{
	local array<H7AbilityTrackingData> trackingData;
	local H7AbilityTrackingData data;
	local JsonObject obj;
	local H7Player player; 

	trackingData = GetAbilityTrackingData();
	player =   GetArmyDefender().GetPlayer().IsControlledByLocalPlayer()? GetArmyDefender().GetPlayer(): GetArmyAttacker().GetPlayer();
	foreach trackingData( data )
	{
			obj = new class'JsonObject'();
			obj.SetIntValue("playerPosition",   player.GetPlayerNumber() );
			obj.SetStringValue("playerFaction", player.GetFaction().GetArchetypeID() );
			obj.SetStringValue( "spellId",		data.AbilityName );
			obj.SetStringValue( "spellName",    data.AbilityName );
			obj.SetIntValue( "nbUses",			data.NumberOfCasts );
			OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).PushEvent("UTT_SPELL_USED","spell.used", obj );
	}

	mAbilityTrackingData.Length = 0;
	
}

function H7Player GetLocalPlayer()
{
	if( mArmyAttacker.GetPlayer().IsControlledByLocalPlayer() )
	{
		return mArmyAttacker.GetPlayer();
	}
	else
	{
		return mArmyDefender.GetPlayer();
	}
}

function bool ShouldTakeCareOfArmy(H7CombatArmy army)
{
	return !WorldInfo.GRI.IsMultiplayerGame() 
		|| army.IsOwnedByPlayerMP() 
		|| (army.GetPlayer().IsControlledByAI() && !army.GetPlayer().IsNeutralPlayer());
}

function VictoryCamEnded() {} // overwritten in state

//=============================================================================
// States:
//=============================================================================

// # intitial state
auto state Beginning
{
	event BeginState(name previousStateName)
	{
		local H7ReplicationInfo repInfo;
		local H7LobbyDataGameSettings gameSettings;

		StartCombatMusic();

		// there are settings in: 1) transtion data 2) adv controller and 3) replication info 
		// so this is a little confusing

		gameSettings = class'H7TransitionData'.static.GetInstance().GetGameSettings();

		// activate tactics phase for humans!
		if( mArmyAttacker.GetPlayer().GetPlayerType() == PLAYER_HUMAN ) mPlacingAttackerDone=false;
		if( mArmyDefender.GetPlayer().GetPlayerType() == PLAYER_HUMAN ) mPlacingDefenderDone=false;

		// deactivate tactics phase if debug option checked, or if supress tactics is set through kismet / script
		if(class'H7OptionsManager'.static.GetInstance().GetSettingBool("SKIP_TACTICS") ||
			class'H7ReplicationInfo'.static.GetInstance().mSupressTactics)
		{
			mPlacingAttackerDone=true;
			mPlacingDefenderDone=true;
		}

		repInfo = class'H7ReplicationInfo'.static.GetInstance();
		if( class'H7AdventureController'.static.GetInstance() != none ) // COMBAT FROM ADV - transition combat start
		{
			if( repInfo.IsMultiplayerGame() ) // multiplayer
			{
				class'H7ReplicationInfo'.static.PrintLogMessage("SETTING COMBATSPEED" @ class'H7AdventureController'.static.GetInstance().GetGameSettings().mGameSpeedCombat, 0);;
				repInfo.ModifyGameSpeedMPCombat( class'H7AdventureController'.static.GetInstance().GetGameSettings().mGameSpeedCombat );
			}
			else // singleplayer
			{
				// nothing needed here apparently, no idea where it switches from adv speed to combat speed
			}
		}
		else if( class'H7AdventureController'.static.GetInstance() == none ) // DUEL - standalone combat start
		{
			if( repInfo.IsMultiplayerGame() ) // multiplayer duel
			{
				class'H7ReplicationInfo'.static.PrintLogMessage("SETTING COMBATSPEED" @ gameSettings.mGameSpeedCombat, 0);;
				repInfo.ModifyGameSpeedMPCombat( gameSettings.mGameSpeedCombat );
			}
			else // singleplayer duel
			{
				repInfo.ModifyGameSpeedCombat( gameSettings.mGameSpeedCombat );
			}
		}
		
		if( WorldInfo.GRI.IsMultiplayerGame() )
		{
			class'H7ReplicationInfo'.static.GetInstance().GetMpCommandManager().CleanDamageApplyQueue();
		}

		;
		class'H7PlayerController'.static.GetPlayerController().SetInLoadingScreen( false );

		class'H7ScriptingController'.static.TriggerEvent(class'H7SeqEvent_MapLoaded', 0);
		class'H7Camera'.static.GetInstance().UseCameraCombat();
		class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().ResetInitiativeInfo();
		class'H7CombatHudCntl'.static.GetInstance().GetCombatMenu().SetTurnCounter(1);
		H7PlayerReplicationInfo( class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController().PlayerReplicationInfo ).SetIsInCombatMap( true );
		class'H7ReplicationInfo'.static.GetInstance().SetTeleportTargetID(-1);

		mAnyDidSurrender = false;
		
		TryToStart();
	}

	event Tick(float deltaTime)
	{
		super.Tick(deltaTime);

		//`log_gui("Beginning tick");
		if( class'H7PlayerController'.static.GetPlayerController().GetHud().IsLoaded() )
		{
			TryToStart();
		}
		else
		{
			//`log_gui("Beginning state waiting for hud");
		}
	}

	protected function TryToStart()
	{
		local array<PlayerReplicationInfo> PRIarray;
		local PlayerReplicationInfo PRI;

		if(WorldInfo.GRI.IsMultiplayerGame())
		{
			if(!class'H7PlayerController'.static.GetPlayerController().IsServer())
			{
				return;
			}

			PRIarray = class'H7ReplicationInfo'.static.GetInstance().PRIArray;
			foreach PRIarray( PRI )
			{
				if( !H7PlayerReplicationInfo(PRI).IsInCombatMap() )
				{
					return;
				}
			}

			class'H7CombatPlayerController'.static.GetCombatPlayerController().SendCombatStart();
	
			if( class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager() != none )
			{
				class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager().OnStartNormalCombat();
			}

			// the server is alone, lets finish this game
			if( PRIarray.Length == 1 )
			{
				SetTimer( 2.0f, false, nameof(MPAutoWin) );
			}
		}

		StartCombat();
	}

	protected function StartCombatMusic()
	{
		local H7SoundController soundController;

		soundController = class'H7SoundController'.static.GetInstance();
		//Enable Sound after Loading
		soundController.EnableSoundChannel(true);
		soundController.EnableAmbientChannel(true);

		if(!class'H7TransitionData'.static.GetInstance().GetIsReplayCombat())
		{
			soundController.UpdateMusicGameStateSwitch("COMBAT_MAP");
		}
	}

	event EndState(name nextStateName)
	{
		;
	}
}

protected function MPAutoWin()
{
	WinCombat();
}

state Tactics
{
	event BeginState(name previousStateName)
	{
		local bool bIamAttacker; //indicates whether the local player is attacker
		bIamAttacker = ( WorldInfo.GRI.IsMultiplayerGame() && mArmyAttacker.IsOwnedByPlayerMP() )
			|| (mArmyAttacker.GetPlayer().GetPlayerType() == PLAYER_HUMAN);

		;

		mArmyAttacker.EnsureBaseStackSlotExistence(mArmyAttacker.GetHero().GetMaxDeploymentNumber());
		mArmyDefender.EnsureBaseStackSlotExistence(mArmyDefender.GetHero().GetMaxDeploymentNumber());

		class'H7Camera'.static.GetInstance().UseCameraDeployment();
		// enable combat GUI, to see something when coming from adventuremap:
		class'H7PlayerController'.static.GetPlayerController().GetCombatMapHud().GetCombatHudCntl().GetHeroPanel().SetVisibleSave(true);
		class'H7PlayerController'.static.GetPlayerController().GetCombatMapHud().GetCombatHudCntl().GetCombatMenu().SetVisibleSave(true);
		//Enable Sound after Loading
		class'H7SoundController'.static.GetInstance().EnableSoundChannel(true);
		class'H7SoundController'.static.GetInstance().EnableAmbientChannel(true);
		//Start only a new one, if its a new combat
		if(!class'H7TransitionData'.static.GetInstance().GetIsReplayCombat())
		{
			//When this is triggered, the next combat without travel back to AM or MainMenu must be a replay combat
			class'H7TransitionData'.static.GetInstance().SetIsReplayCombat(true);
		}

		// hide loading screen combatloadingscreen
		class'Engine'.static.StopMovie(true);

		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("MSG_TACTICS_BEGIN");

		mArmyAttacker.HideStacks();
		mArmyDefender.HideStacks();

		if( WorldInfo.GRI.IsMultiplayerGame() )
		{
			ResetTimerForTactics();
			if(mArmyAttacker.IsOwnedByPlayerMP() )
			{
				// I am attacker
				if(!mPlacingAttackerDone)
				{
					OnPlaceUnits( true );
				}
				else if(!mPlacingDefenderDone)
				{
					class'H7CombatHudCntl'.static.GetInstance().SetTacticsWaiting(true);
				}
			}
			else if(!mArmyAttacker.GetPlayer().IsNeutralPlayer() && mArmyAttacker.GetPlayer().IsControlledByAI())
			{
				OnPlaceUnitsAI(true);
				FinishAttackerTacticsPhase();
			}
				 			
			if(mArmyDefender.IsOwnedByPlayerMP() )
			{
				// I am defender
				if(!mPlacingDefenderDone)
				{
					OnPlaceUnits( false );
				}
				else if(!mPlacingAttackerDone)
				{
					class'H7CombatHudCntl'.static.GetInstance().SetTacticsWaiting(true);
				}
			}
		}
		else
		{
			if( !mPlacingAttackerDone ) 
			{
				if( mArmyAttacker.GetPlayer().GetPlayerType() == PLAYER_HUMAN )
				{
					OnPlaceUnits( true );
				}
				else
				{
					OnPlaceUnitsAI(true);
					NextPlayer();
				}
			}
			else if( !mPlacingDefenderDone ) 
			{
				if( mArmyDefender.GetPlayer().GetPlayerType() == PLAYER_HUMAN )
				{
					OnPlaceUnits( false );
				}
				else
				{
					OnPlaceUnitsAI(false);
					NextPlayer();
				}
			}
		}
		mGridController.GetDecal().UpdateGridDataRendering();
		mGridController.GetDecal().SetHidden(false);

		//trigger H7SeqEvent_CombatDeploymentPhaseStart
		class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_CombatDeploymentPhaseStart', none, 
			(bIamAttacker ? mArmyAttacker : mArmyDefender));
	}

	event EndState(name nextStateName)
	{
		if( mArmyAttacker.GetPlayer().GetPlayerType() == PLAYER_AI )
		{
			mArmyAttacker.UpdateCreaturesDeployedState(true);
		}
		else if( mArmyDefender.GetPlayer().GetPlayerType() == PLAYER_AI )
		{
			mArmyDefender.UpdateCreaturesDeployedState(true);
		}

		mGridController.GetDecal().SetHidden( !class'H7GUIGeneralProperties'.static.GetInstance().mCombatGridVisible );

		;
	}

	function OnPlaceUnits( bool isAttackingArmy )
	{
		local int numRowsTactics;

		// raise menu and allow interactivity ....
		class'H7PlayerController'.static.GetPlayerController().SetIsUnrealInputAllowed( true );

		mArmyDefender.ShowStacks();
		mArmyAttacker.ShowStacks();
		
		// hide others army 
		if( isAttackingArmy ) 
		{
			mArmyAttacker.ShowStacks();
			mArmyDefender.HideStacks();
			numRowsTactics = mArmyAttacker.GetCombatHero().GetMaxDeploymentRow();
		}
		else
		{
			mArmyAttacker.HideStacks();
			mArmyDefender.ShowStacks();
			numRowsTactics =  mArmyDefender.GetCombatHero().GetMaxDeploymentRow();
		}

		// hide initiative bar and init deployment bar
		class'H7CombatHudCntl'.static.GetInstance().ShowTacticsGUI();

		// set valid grid-column(s)
		mGridController.BeginTactics( isAttackingArmy, numRowsTactics );

		// go ...
		CheckStartable();
	}

	function OnPlaceUnitsAI( bool isAttackingArmy )
	{
		local int numRowsTactics;

		class'H7PlayerController'.static.GetPlayerController().SetIsUnrealInputAllowed( false );

		mArmyDefender.ShowStacks();
		mArmyAttacker.ShowStacks();
		
		// hide others army (unless we have strategist skill)
		if( isAttackingArmy ) 
		{
			mArmyAttacker.ShowStacks();
			mArmyDefender.ShowStacks();
			numRowsTactics = 2 ; // mArmyAttacker.GetCombatHero().GetAbilityManager().GetNumRowsTactics();
		}
		else
		{
		
			mArmyAttacker.ShowStacks();
			mArmyDefender.ShowStacks();
			numRowsTactics = 2 ; // mArmyDefender.GetCombatHero().GetAbilityManager().GetNumRowsTactics();
		}

		// hide initiative bar and deployment bar
		class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().SetVisibleSave(false);
		class'H7CombatHudCntl'.static.GetInstance().GetCreatureAbilityButtonPanel().SetVisibleSave(false);
		class'H7CombatHudCntl'.static.GetInstance().GetDeploymentBar().SetVisibleSave(false);
		// set valid grid-column(s)
		mGridController.BeginTactics( isAttackingArmy, numRowsTactics );
		// go ...
		CheckStartable();
	}

	// Only for Multiplayer
	function SetTacticPhaseFinishedMP( bool isDefender )
	{
		if( isDefender )
		{
			mPlacingDefenderDone = true;
		}
		else
		{
			mPlacingAttackerDone = true;
		}

		if( mPlacingAttackerDone && mPlacingDefenderDone )
		{
			GotoState('PrePresentHeroArmy');
		}
	}

	function NextPlayer()
	{
		;
		if( !mTacticsStartable )
		{
			;
			return;
		}
				
		// attacking player is ready to start ...
		if( !mPlacingAttackerDone && (!WorldInfo.GRI.IsMultiplayerGame() || mArmyAttacker.IsOwnedByPlayerMP()) )
		{
			class'H7PlayerController'.static.GetPlayerController().SetIsUnrealInputAllowed( !WorldInfo.GRI.IsMultiplayerGame() );
			class'H7CombatPlayerController'.static.GetCombatPlayerController().SendTacticsPhaseFinished( false, mArmyAttacker );
			if(WorldInfo.GRI.IsMultiplayerGame() || (!mPlacingDefenderDone && mArmyDefender.GetPlayer().IsControlledByAI() ) ) class'H7CombatHudCntl'.static.GetInstance().SetTacticsWaiting(true);
			FinishAttackerTacticsPhase();

		}
		// ... defending player too
		else if( !mPlacingDefenderDone && (!WorldInfo.GRI.IsMultiplayerGame() || mArmyDefender.IsOwnedByPlayerMP()) )
		{
			class'H7PlayerController'.static.GetPlayerController().SetIsUnrealInputAllowed( !WorldInfo.GRI.IsMultiplayerGame() );
			class'H7CombatPlayerController'.static.GetCombatPlayerController().SendTacticsPhaseFinished( true, mArmyDefender );
			if(WorldInfo.GRI.IsMultiplayerGame() || (!mPlacingAttackerDone && mArmyAttacker.GetPlayer().IsControlledByAI() ) ) class'H7CombatHudCntl'.static.GetInstance().SetTacticsWaiting(true);
			FinishDefenderTacticsPhase();
		}

		if( mPlacingAttackerDone && mPlacingDefenderDone )
		{
			GotoState('PrePresentHeroArmy');
		}
	}

	protected function FinishAttackerTacticsPhase()
	{
		if( ShouldTakeCareOfArmy(mArmyAttacker) )
		{
			mArmyAttacker.UpdateCreaturesDeployedState();
			mArmyAttacker.SaveTacticsDeployment();
		}

		mPlacingAttackerDone = true;
		//Change the deployment camera for the next player
		class'H7Camera'.static.GetInstance().UseCameraDeployment();
			
		if( !WorldInfo.GRI.IsMultiplayerGame() && !mPlacingDefenderDone && mArmyDefender.GetPlayer().GetPlayerType() == PLAYER_HUMAN )
		{
			OnPlaceUnits( false );
		}
		mGridController.GetDecal().UpdateGridDataRendering();
	}

	protected function FinishDefenderTacticsPhase()
	{
		if( !WorldInfo.GRI.IsMultiplayerGame() || mArmyDefender.IsOwnedByPlayerMP() )
		{
			mArmyDefender.UpdateCreaturesDeployedState();
			mArmyDefender.SaveTacticsDeployment();
		}
		mPlacingDefenderDone = true;
		mGridController.GetDecal().UpdateGridDataRendering();
	}

	event tick(float deltaTime)
	{
		if( WorldInfo.GRI.IsMultiplayerGame() )
		{
			class'H7ReplicationInfo'.static.GetInstance().GetMpCommandManager().Update();
			UpdateCurrentTurnTimer( deltaTime );
		}
	}

	function CalculateInputAllowed( optional bool waitForAnimIfNecessary = true )
	{
		local H7CombatArmy deployingArmy;
		// only allow input to the right player in multiplayer
		
		if(mActiveUnit != none)
		{
			if( WorldInfo.GRI.IsMultiplayerGame() )
			{
				class'H7PlayerController'.static.GetPlayerController().SetIsUnrealInputAllowed( mActiveUnit != none && mActiveUnit.GetCombatArmy().IsOwnedByPlayerMP() && !mActiveUnit.IsControlledByAI() );
			}
			else
			{
				class'H7PlayerController'.static.GetPlayerController().SetIsUnrealInputAllowed( !mActiveUnit.IsControlledByAI() );
			}
		}
		else
		{
			deployingArmy = GetCurrentlyDeployingArmy();
			if(deployingArmy != none && class'H7AdventureController'.static.GetInstance() != none)
			{
				class'H7PlayerController'.static.GetPlayerController().SetIsUnrealInputAllowed( deployingArmy.GetPlayer() == class'H7AdventureController'.static.GetInstance().GetLocalPlayer() );
			}
			else
			{
				;
				class'H7PlayerController'.static.GetPlayerController().SetIsUnrealInputAllowed( true );
			}
		}
	}

}

state PrePresentHeroArmy
{
	event BeginState(name previousStateName)
	{
		local H7AdventureController adventureControl;

		;

		adventureControl = class'H7AdventureController'.static.GetInstance();

		// hide loading screen combatloadingscreen
		class'Engine'.static.StopMovie(true);

		if (IsCombatComingFromAdventureMap())
		{
			mHeroEventParam.mEventHeroTemplate = adventureControl.GetArmyAttacker().GetHeroTemplateSource();
			mHeroEventParam.mEventPlayerNumber = adventureControl.GetArmyAttacker().GetPlayerNumber();
			mHeroEventParam.mEventEnemyPlayerNumber = adventureControl.GetArmyDefender().GetPlayerNumber();
			mHeroEventParam.mEventTargetArmy = adventureControl.GetArmyDefender();
			mHeroEventParam.mCombatMapName = class'H7ReplicationInfo'.static.GetInstance().GetCurrentMapName();

			class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_CombatMapStarted', mHeroEventParam, 
					adventureControl.GetArmyAttacker(), 1 /* Before cool cam */);
		}
	}

	event Tick(float deltaTime)
	{
		super.Tick(deltaTime);

		if(!IsCombatComingFromAdventureMap() || !class'H7ScriptingController'.static.GetInstance().IsCombatPaused())
		{
			GotoState('PresentHeroArmy');
		}
	}
}

state PresentHeroArmy
{
	event BeginState(name previousStateName)
	{
		local H7AdventureController advCntl;
		;		// set camera mode
		
		class'H7SoundController'.static.GetInstance().EnableSoundChannel(true);
		class'H7SoundController'.static.GetInstance().EnableAmbientChannel(true);
		class'H7Camera'.static.GetInstance().EnableAudioListener(true); 
		class'H7Camera'.static.GetInstance().UseCameraCombat();

		;

		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage( class'H7Loca'.static.LocalizeSave("MSG_START_COMBAT","H7Message") ,MD_LOG);

		RaiseEvent( ON_COMBAT_START );
		mGridController.RaiseEventOnObstacles( ON_COMBAT_START );

		mTurnCounter = 1;
		class'H7CombatHudCntl'.static.GetInstance().GetCombatMenu().SetTurnCounter(mTurnCounter);

		InitInitiativeQueue(true);
			
		// let the grid controller change its state to combat
		mGridController.BeginCombat();

		// show armies & update health (in case of ability "Vitality")
		mArmyAttacker.ShowStacks(true);
		mArmyDefender.ShowStacks(true);

		mArmyAttacker.UpdatedAlliesAndEnemies();
		mArmyDefender.UpdatedAlliesAndEnemies();

		advCntl = class'H7AdventureController'.static.GetInstance();

		if( advCntl != none &&
			( mArmyAttacker.GetHero() != none && mArmyAttacker.GetHero().IsHero() && advCntl.GetArmyAttacker().HasShip() ||
			mArmyDefender.GetHero() != none && mArmyDefender.GetHero().IsHero() && advCntl.GetArmyDefender().HasShip() ) ||
			mIsNavalCombat ||
			mGridController.IsShip() ) // duel maps on ships!
		{
			RaiseEventOnArmiesStacks( ON_EMBARK, mArmyAttacker , false );
			RaiseEventOnArmiesWarUnits( ON_EMBARK, mArmyAttacker, false );
			RaiseEventOnArmiesStacks( ON_EMBARK, mArmyDefender , false );
			RaiseEventOnArmiesWarUnits( ON_EMBARK, mArmyDefender, false );
		}

		// tell the GUI to change
		class'H7CombatHudCntl'.static.GetInstance().CombatBegin();

		//class'H7PlayerController'.static.GetPlayerController().GetHud().CloseAllWindows();
		class'H7PlayerController'.static.GetPlayerController().GetCombatMapHud().SetCombatHudVisible(true);
		
		if(!mArmyDefender.mIsAmbush)
		{
			if(mArmyDefender.GetHero() != none && mArmyDefender.GetHero().IsHero())
			{
				CameraActionIntroduceHero();
			}
			else
			{
				CameraActionPresentArmy();
			}
		}
		else
		{
			GotoState('Combat');
		}
	}
}

state Combat
{
	event BeginState(name previousStateName)
	{
		local H7AdventureController adventureControl;

		;		// set camera mode

		adventureControl = class'H7AdventureController'.static.GetInstance();

		class'H7SoundController'.static.GetInstance().EnableSoundChannel(true);
		class'H7SoundController'.static.GetInstance().EnableAmbientChannel(true);

		if (IsCombatComingFromAdventureMap())
		{
			mHeroEventParam.mEventHeroTemplate = adventureControl.GetArmyAttacker().GetHeroTemplateSource();
			mHeroEventParam.mEventPlayerNumber = adventureControl.GetArmyAttacker().GetPlayerNumber();
			mHeroEventParam.mEventEnemyPlayerNumber = adventureControl.GetArmyDefender().GetPlayerNumber();
			mHeroEventParam.mEventTargetArmy = adventureControl.GetArmyDefender();
			mHeroEventParam.mCombatMapName = class'H7ReplicationInfo'.static.GetInstance().GetCurrentMapName();
			
			class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_CombatMapStarted', mHeroEventParam, 
				adventureControl.GetArmyAttacker(), 0 /* After cool cam */);
		}

		mIsLastStackDying = false;
		mLastUnitWasHero = false;
		mBadMoraleTime = mCombatConfiguration.mBadMoraleWaitTime;
		mCurrentTimeBadMorale = mBadMoraleTime;

		InitializeAurasOnEnterCell();

		ActivateNextUnit( true );

		// reset drawing
		mGridController.UpdateCellSelectionTypes();
		mGridController.GetDecal().UpdateGridDataRendering();
		mGridController.GetDecal().SetHidden( !class'H7GUIGeneralProperties'.static.GetInstance().mCombatGridVisible );

		class'H7CombatHudCntl'.static.GetInstance().UpdateFleeSurrenderButton();

		GetArmyDefender().CalculateInitialTotalLife();
		GetArmyAttacker().CalculateInitialTotalLife();

		
	}

	event EndState(name nextStateName)
	{
		;

		// hide initiative bar & combat menu
		//if( nextStateName != 'BattleStart' )
		//{
		class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().SetVisibleSave(false);
		class'H7CombatHudCntl'.static.GetInstance().GetCreatureAbilityButtonPanel().SetVisibleSave(false);
		class'H7CombatHudCntl'.static.GetInstance().GetCombatMenu().SetVisibleSave(false);
		class'H7CombatHud'.static.GetInstance().GetSpellbookCntl().GetQuickBar().SetVisibleSave(false);
		//}
	}

	event Tick(float deltaTime)
	{
		local H7CreatureStack creatureStack;
		local array<H7CreatureStack> armyCreatures;
		local bool waitForAnim;
		local bool isActiveDying;
		local bool combatOfLocalPlayer;

		super.Tick(deltaTime);

		if( class'H7SpectatorHUDCntl'.static.GetInstance().GetPopup().IsVisible() )
		{
			class'H7SpectatorHUDCntl'.static.GetInstance().UpdateProgress( Max( GetArmyAttacker().GetPercentTotalLife(true), GetArmyDefender().GetPercentTotalLife(true) ) );
		}

		if( ShouldTick() )
		{
			UpdateCurrentTurnTimer( deltaTime );

			if( !IsBadMoraleDelayOver( deltaTime ) ) return;

			waitForAnim = class'H7OptionsManager'.static.GetInstance().GetSettingBool("GAMEPLAY_WAITS_FOR_ANIM");

			if( WorldInfo.GRI.IsMultiplayerGame() )
			{
				class'H7ReplicationInfo'.static.GetInstance().GetMpCommandManager().Update();
			}

			if( mActiveUnit.IsControlledByAI() && !mCommandQueue.IsCommandRunning() && mActiveUnit.CanMakeAction() && !IsSomeoneDying() )
			{
				if( WorldInfo.GRI.IsMultiplayerGame() )
				{
					combatOfLocalPlayer = mArmyAttacker.GetPlayer().IsControlledByLocalPlayer() || mArmyDefender.GetPlayer().IsControlledByLocalPlayer();
					if( mActiveUnit.GetCombatArmy().GetPlayer().GetPlayerType() == PLAYER_AI && combatOfLocalPlayer )
					{
						// mulitplayer: only the local can execute the code of the AI player (neutral army or AI player)
						mAI.Think( mActiveUnit, deltaTime );
					}
					else if( mActiveUnit.GetCombatArmy().IsOwnedByPlayerMP() )
					{
						// mulitplayer: only the player that owns the unit can execute the code of the AI in case that the unit uses AI (example: catapult)
						mAI.Think( mActiveUnit, deltaTime );
					}
				}
				else
				{
					// single player
					mAI.Think( mActiveUnit, deltaTime );
				}
			}

			mIsSomeoneDying = false;
			armyCreatures = mArmyAttacker.GetCreatureStacks();
			foreach armyCreatures( creatureStack ) 
			{
				if( creatureStack.GetCreature().GetAnimControl().IsDying() )
				{
					mIsSomeoneDying = true;
					break;
				}
			}
			armyCreatures = mArmyDefender.GetCreatureStacks();
			foreach armyCreatures( creatureStack ) 
			{
				if( creatureStack.GetCreature().GetAnimControl().IsDying() )
				{
					mIsSomeoneDying = true;
					break;
				}
			}

			creatureStack = H7CreatureStack( mActiveUnit );
			if( creatureStack != none )
			{
				if( creatureStack.GetCreature().GetAnimControl().IsDying() )
				{
					isActiveDying = true;
				}
			}
			if( isActiveDying ) 
			{
				return;
			}

			mCommandQueue.UpdateCommand();
			if( mIsSomeoneDying || !IsInState('Combat') )
			{
				return;
			}

			// update unit command and select next unit if command has finished
			if( WorldInfo.GRI.IsMultiplayerGame() && class'H7ReplicationInfo'.static.GetInstance().GetMpCommandManager().IsExpiredApplyDamageEndTurn() )
			{
				class'H7ReplicationInfo'.static.PrintLogMessage("IsExpiredApplyDamageEndTurn FORCING END TURN", 0);;
				CheckEndBattle();
				FinishActiveUnitTurn();
			}
			else if( ( ( !mActiveUnit.CanMakeAction() && IsBadMoraleDelayOver( deltaTime ) ) || mActiveUnit.IsWaiting() ) && mCommandQueue.IsReadyToEndTurn() )
			{
				if( waitForAnim || mIsLastStackDying || mInitiativeQueue.IsLastUnitOfTurn() )
				{
					if(IsAllAnimationFinished())
					{
						CheckEndBattle();
						FinishActiveUnitTurn();
					}
				}
				else
				{
					CheckEndBattle();
					FinishActiveUnitTurn();
				}
			}

			if(mCheckEndCombatImmediately)
			{
				class'H7PlayerController'.static.GetPlayerController().SetIsUnrealInputAllowed( false );

				if(H7CreatureStack( mActiveUnit ) != none)
				{
					H7CreatureStack( mActiveUnit ).HideStackFX();
					H7CreatureStack( mActiveUnit ).HideSlotFX(H7CreatureStack( mActiveUnit ).GetCell());
				}

				if( waitForAnim || mIsLastStackDying || mInitiativeQueue.IsLastUnitOfTurn() )
				{
					if( IsAllAnimationFinished())
					{
						CheckEndBattle();
					}
				}
				else
				{
					CheckEndBattle();
				}
			}
		}
	}

	protected function bool IsBadMoraleDelayOver(float deltaTime)
	{
		if( mCurrentTimeBadMorale >= mBadMoraleTime ) return true;

		mCurrentTimeBadMorale += deltaTime;

		if( mCurrentTimeBadMorale >= mBadMoraleTime )
		{
			if( mSkipTurnCommand )
			{
				mSkipTurnCommand = false;
				SetActiveUnitCommand_SkipTurn( false );
			}
			else
			{
				class'H7ReplicationInfo'.static.PrintLogMessage("Unit has bad morale:" @ mActiveUnit, 0);;
				ActivateNextUnit( false );
			}
		}

		return false;
	}

	function bool AllAnimationsDone()
	{
		local bool commandQueueState;

		// check if command queue has a command still running or a bunch of queued commands
		commandQueueState = mCommandQueue.IsEmpty() && !mCommandQueue.IsCommandRunning();

		// wait for anim option is true or the last stack of one of the armies is dying -> wait
		if( class'H7OptionsManager'.static.GetInstance().GetSettingBool("GAMEPLAY_WAITS_FOR_ANIM") || mIsLastStackDying )
		{
			return IsAllAnimationFinished() && commandQueueState;
		}

		return commandQueueState;
	}

	protected function bool IsAllAnimationFinished()
	{
		local array<H7Unit> allUnits;
		local H7Unit unit;
		local H7CreatureStack stack;
		local H7CombatHero hero;
		
		// check if everybody is idle, and has no effects:
		allUnits = mInitiativeQueue.GetActiveList();
		foreach allUnits(unit)
		{
			stack = H7CreatureStack(unit);
			if(stack != none && !stack.IsDead())
			{
				if(!stack.GetCreature().GetAnimControl().IsIdlingOrDefending()) return false;

			}
			// TODO what about warfare units?
			hero = H7CombatHero(unit);
			if(hero != none && hero.IsHero())
			{
				if(hero.GetAnimControl().IsPlayingAnim()) return false;
			}
		}

		// also check coolcams:
		if(class'H7CameraActionController'.static.GetInstance() != none && class'H7CameraActionController'.static.GetInstance().GetCurrentAction() != none)
		{
			return false;
		}		
		return true;
	}

	protected function bool ShouldTick()
	{
		return ((mActiveUnit != None) && (!IsCombatComingFromAdventureMap() || !class'H7ScriptingController'.static.GetInstance().IsCombatPaused()));
	}

	/**
	 * Checks if one of the Armies is defeated
	 * Perform win or lose behavior
	 **/
	protected function CheckEndBattle()
	{
		local int XPWinner, XPLoser;
		local H7CombatArmy victoriousArmy, defeatedArmy;
		local bool combatOfLocalPlayer;

		if( GetActiveArmy().AreAllCreaturesDead() )
		{
			victoriousArmy = GetOpponentArmy( GetActiveArmy() );
			defeatedArmy = GetActiveArmy();
		}
		else if( GetOpponentArmy( GetActiveArmy() ).AreAllCreaturesDead() )
		{
			victoriousArmy = GetActiveArmy();
			defeatedArmy = GetOpponentArmy( GetActiveArmy() );
		}
		
		if( victoriousArmy != none )
		{
			// sending the end turn
			if( WorldInfo.GRI.IsMultiplayerGame() )
			{
				combatOfLocalPlayer = mArmyAttacker.GetPlayer().IsControlledByLocalPlayer() || mArmyDefender.GetPlayer().IsControlledByLocalPlayer();
				 // the local player has the turn
				if( GetActiveUnit().GetPlayer().IsControlledByLocalPlayer() ||
				( GetActiveUnit().GetPlayer().GetPlayerType() == PLAYER_AI && combatOfLocalPlayer ) )
				{
					// send end turn
					class'H7CombatPlayerController'.static.GetCombatPlayerController().SendDamageApply( -1, -1, class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetCounter() );
				}
			}

			XPWinner = defeatedArmy.GetKilledCreaturesXP();
			XPLoser = victoriousArmy.GetKilledCreaturesXP();
			victoriousArmy.GetCombatHero().TriggerEvents( ON_BATTLE_XP_GAIN, false );
			XPWinner = victoriousArmy.GetCombatHero().AddXp( XPWinner );	//	Give EXP to player hero
			victoriousArmy.DoVictory();
			defeatedArmy.GetCombatHero().TriggerEvents( ON_BATTLE_XP_GAIN, false );
			XPLoser = defeatedArmy.GetCombatHero().AddXp( XPLoser ); // Give EXP to enemy hero

			if(defeatedArmy.GetAdventureHero() != none && defeatedArmy.GetAdventureHero().IsHero() && defeatedArmy.GetAdventureHero().GetAdventureArmy().HasShip())
			{
				RaiseEventOnArmiesStacks(ON_DISEMBARK, defeatedArmy, false);
				RaiseEventOnArmiesWarUnits(ON_DISEMBARK, defeatedArmy, false);
				RaiseEventOnArmiesStacks(ON_DISEMBARK, victoriousArmy, false);
				RaiseEventOnArmiesWarUnits(ON_DISEMBARK, victoriousArmy, false);
			}

			if (class'H7AdventureController'.static.GetInstance() != none && !class'H7AdventureController'.static.GetInstance().IsAutomatedTestingAIEnabled())
			{
				victoriousArmy.GetPlayer().SetControlledByAI( false );
				defeatedArmy.GetPlayer().SetControlledByAI( false );
			}
			EndBattle();

			// show victory sceen if it is singleplayer and the winner is human or if it is multiplayer and the winner is owned by the player
			mResultXPWinner = XPWinner;
			mResultXPLoser = XPLoser;
			
			if( (!WorldInfo.GRI.IsMultiplayerGame() && victoriousArmy.GetPlayer().GetPlayerType() == PLAYER_HUMAN) || (WorldInfo.GRI.IsMultiplayerGame() && victoriousArmy.IsOwnedByPlayerMP()) )
			{
				mResultWin = true;
				mResultArmy = victoriousArmy;
			}
			else
			{
				mResultWin = false;
				mResultArmy = defeatedArmy;
			}
		}
	}

	protected function ActivateNextUnit( bool isFirstTurn )
	{
		local H7Message message;
		local array<H7Unit> allUnits;
		local string turnName;
		local int i;
		local bool isNewTurn;
		local H7CombatArmy enemyArmyOfNewTurn;

		;

		ResetCurrentTurnTimer();

		if( mActiveUnit != None )
		{
			// unit is dead => remove it from initiative queue
			if( mActiveUnit.IsDead() )
			{
				GetInitiativeQueue().RemoveUnit(mActiveUnit);
				mActiveUnit = None;
			}
		}

		if( mInitiativeQueue != None )
		{
			if( !isFirstTurn && mInitiativeQueue.NeedNextTurn()  ) // new turn
			{
				isNewTurn = true;
				RaiseEvent( ON_COMBAT_TURN_END );
				mGridController.RaiseEventOnObstacles( ON_COMBAT_TURN_END );
				GetGridController().GetAuraManager().TriggerEvents( ON_COMBAT_TURN_END, false );

				++mTurnCounter;
				
				turnName = Repl(GetTurnName(), "%number", mTurnCounter);
				class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().DisplayTurnAnimation(turnName);
				class'H7CombatHudCntl'.static.GetInstance().GetCombatMenu().SetTurnCounter(mTurnCounter);

				message = new class'H7Message';
				message.text = "MSG_TURN_BEGIN"; 
				message.AddRepl("%number",String(mTurnCounter));
				message.destination = MD_LOG;
				class'H7MessageSystem'.static.GetInstance().SendMessage(message);

				InitInitiativeQueue();

				allUnits = mInitiativeQueue.GetInitiativeQueue();
				for( i=0; i<allUnits.Length; ++i)
				{
					if( allUnits[i] == none )
						continue;
					allUnits[i].SetWaitClick(false);
					allUnits[i].SetWaiting(false);
					allUnits[i].ResetTurnCount();
				}
				
				RaiseEvent(ON_COMBAT_TURN_START);
				mGridController.RaiseEventOnObstacles( ON_COMBAT_TURN_START );
				GetGridController().GetAuraManager().TriggerEvents( ON_COMBAT_TURN_START, false );

				mInitiativeQueue.CheckMarkedForSkipTurnUnits();
				
			}
			else if(isFirstTurn)
			{
				class'H7ReplicationInfo'.static.GetInstance().IncUnitActionsCounter();
			}

			// take unit from initiative queue
			
			mActiveUnit = mInitiativeQueue.GetActiveUnit(false);

			//Trigger H7SeqEvent_CombatTurn
			if (isFirstTurn || isNewTurn)
			{
				mHeroEventParam.mEventHeroTemplate = none;
				mHeroEventParam.mEventPlayerNumber = mActiveUnit.GetPlayer().GetPlayerNumber();
				enemyArmyOfNewTurn = (mArmyDefender.GetPlayerNumber() == mHeroEventParam.mEventPlayerNumber) ? mArmyAttacker : mArmyDefender;
				mHeroEventParam.mEventEnemyPlayerNumber = enemyArmyOfNewTurn.GetPlayerNumber();
				mHeroEventParam.mEventTargetArmy = enemyArmyOfNewTurn.GetAdventureHero().GetAdventureArmy();
				mHeroEventParam.mCombatMapName = class'H7ReplicationInfo'.static.GetInstance().GetCurrentMapName();
				mHeroEventParam.mCombatCurrentTurn = mTurnCounter;
				class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_CombatTurn', mHeroEventParam, mActiveUnit.GetArmy());
			}

			// update initiative queue unit data
			if(mActiveUnit.IsA('H7CreatureStack') || mInitiativeQueue.GetActiveUnit(true) == mActiveUnit || isFirstTurn)
			{
				//if(isNewTurn) SetTimer(2,false,nameof(SetInitiativeInfoDelayed));
				//else 
				class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().SetInitiativeInfo();
			}
			else
			{
				;
			}
		}
		else
		{
			mActiveUnit = None;
		}

		// propagate new turn event to unit and grid controller
		if( mActiveUnit != None )
		{
			// double check dead/dying unit (i hope this shit fixes stuff)
			if( mActiveUnit.IsDead() || 
				H7CreatureStack( mActiveUnit ) != none && H7CreatureStack( mActiveUnit ).GetCreature().GetAnimControl().IsDying() )
			{
				GetInitiativeQueue().RemoveUnit(mActiveUnit);
				mActiveUnit = None;
				mActiveUnit = mInitiativeQueue.GetActiveUnit(false);
			}

			mActiveUnit.SetTriggerStartTurnEvents(!mLastUnitWasHero);  //TODO: Check if we even still need this?
			mActiveUnit.BeginTurn();
			mLastUnitWasHero = false;
			DoNewUnitHudUpdates();
			CalculateInputAllowed();
			CalculateGridAllowed();

			// the AI likes to play to with his hero
			if( mActiveUnit.GetPlayer().IsControlledByAI() &&
				mActiveUnit.GetCombatArmy().GetHero().IsHero()==true &&
				mActiveUnit.GetEntityType()==UNIT_CREATURESTACK &&
				mInitiativeQueue.IsARemainingUnit(mActiveUnit.GetCombatArmy().GetHero()) == true )
			{
				SetActiveUnitHero();
			}
		}
	}

	function bool CheckEndOfCombatDirty()
	{
		return false;
	}

	function SetInitiativeInfoDelayed()
	{
		class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().SetInitiativeInfo();
	}

	function RaiseEventOnArray(array<H7IEffectTargetable> units , ETrigger event )
	{
		local int i;
		local bool sim;
		sim = false;

		for( i=0; i<units.Length; ++i)
		{
			if( units[i] == none )
				continue;
			
			units[i].TriggerEvents( event, sim );
		}
	}

	// most expensive function in the game (100ms spikes) 20ms GUI 20ms AI 20ms Pathfinder ...
	protected function bool FinishActiveUnitTurn(optional bool triggerUnitEndTurn = true) 
	{
		local bool unitIsSelected;
		local bool MoreActions;
		local bool combatOfLocalPlayer;
		
		;
		class'H7ReplicationInfo'.static.PrintLogMessage("FinishActiveUnitTurn BEGIN" @ mActiveUnit, 0);;
		
		if( mActiveUnit == None )
		{
			;
			return true;
		}

		if( mActiveUnit.IsA( 'H7CreatureStack' ) && H7CreatureStack( mActiveUnit ).HasDelayedCommand() && !H7CreatureStack( mActiveUnit ).IsDead() )
		{
			H7CreatureStack( mActiveUnit ).StartDelayedCommand();
			return false;
		}

		// updating damages that were not applied
		if( WorldInfo.GRI.IsMultiplayerGame() && !mActiveUnit.HasBadMoral() )
		{
			combatOfLocalPlayer = mArmyAttacker.GetPlayer().IsControlledByLocalPlayer() || mArmyDefender.GetPlayer().IsControlledByLocalPlayer();
			// the local player has the turn
			if( GetActiveUnit().GetPlayer().IsControlledByLocalPlayer() ||
				( GetActiveUnit().GetPlayer().GetPlayerType() == PLAYER_AI && combatOfLocalPlayer ) )
			{
				// send end turn
				class'H7CombatPlayerController'.static.GetCombatPlayerController().SendDamageApply( -1, -1, class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetCounter() );
			}
			else // the local player doesnt have the turn
			{
				// check if the damage was really applied
				if( !class'H7ReplicationInfo'.static.GetInstance().GetMpCommandManager().UpdateApplyDamageEndTurn() )
				{
					class'H7ReplicationInfo'.static.PrintLogMessage("-->FinishActiveUnitTurn not executed correctly because we dont have yet the end turn of the player that owns the turn", 0);;
					return false;
				}
			}
		}

		if( mActiveUnit.IsDead() )
		{
			mActiveUnit.GetBuffManager().RemoveBuffsFromDeadOwner();
		}
	
		// we made an action for this creature
		mActiveUnit.EndAction();

		// checks if active unit is waiting
		if( !mActiveUnit.IsWaiting() )
		{
			mInitiativeQueue.Acted(mActiveUnit);

			// Check for GOOD MORAL
			mActiveUnit.BeforeEndTurn();
			MoreActions =  mActiveUnit.CanMakeAction();
			if( MoreActions )
			{
				// current unit can continue ... (because got good moral or something else)
				mGridController.RecalculateReachableCells();       // reselect all cells
				mActiveUnit.BeginAction();                              // start over again
				ResetCurrentTurnTimer();
			}
			else
			{
				mInitiativeQueue.RemoveFromCurrentTurn( mActiveUnit );
			}
		}
			

		// if unit has no actions left or is waiting
		if( !MoreActions )
		{
			// in case of good moral
			MoreActions = mActiveUnit.CanMakeAction();
			if( MoreActions && mActiveUnit.IsAdditionalTurn() && !mActiveUnit.IsDead() )
			{
				CalculateInputAllowed( false );
				mActiveUnit.BeginAction();  // good morale
				class'H7ReplicationInfo'.static.GetInstance().IncCombatUnitTurnCounter();
				class'H7ReplicationInfo'.static.PrintLogMessage("FinishActiveUnitTurn END GoodMoral" @ mActiveUnit, 0);;
				return false;
			}

			// Dont EndTurn if you have waiting action left
			if ( !mActiveUnit.IsWaiting() || mActiveUnit.IsWaitTurn() )
			{
				// Not Waiting but no actions left
				mActiveUnit.SetAdditionalTurn( false );                 // No additional Turn /  H7Unit:mIsAdditionalTurn = false 
				mActiveUnit.ResetTurnCount();                           // set the default values for Attack & Move Turn counter

				// end current unit's turn (resets its prepared abilities, applied buffs, etc.)
				// This raises an ON_UNIT_TURN_END aswell
				mActiveUnit.EndTurn();
				triggerUnitEndTurn = false; // don't trigger event again
			}	

			// clear combat map cells and buffers ...
			mGridController.ResetSelectedAndReachableCells();
			mAttackBuffer.Remove(0, mAttackBuffer.Length);
			mNoAttackBuffer.Remove(0, mNoAttackBuffer.Length); 

		

			if( mActiveUnit.IsA( 'H7CombatHero' ))
			{
				SetPreviousActiveUnit();
				ResetCurrentTurnTimer();
			}
			else
			{
				// activate next unit
				// mActiveUnit changes here
				if( mCurrentTimeBadMorale >= mBadMoraleTime )
				{
					class'H7ReplicationInfo'.static.GetInstance().IncCombatUnitTurnCounter();
					ActivateNextUnit( false );
				}
				else
				{
					return false;
				}
			}
			unitIsSelected = true;             //  <--- only ture when new unit got picked

			// new unit also has no turn counter left, this could happen if a unit gets stunned                   
			if( !mActiveUnit.CanMakeAction() )
			{
				// Reset MoveTurn and Attack Turn to infinit
				// End Turn of current unit because we dont have any turns left
				// finish and try to get a new Unit or end the turn !!!
				mActiveUnit.ClearTurns();
				if( triggerUnitEndTurn ) { mActiveUnit.TriggerEvents( ON_UNIT_TURN_END, false ); }
				FinishActiveUnitTurn(false); // recursive call
			}
		}
		else // same unit continues to be active (double turn)
		{
			// but GUI needs to be refreshed anyway
			;
			class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().SetInitiativeInfo();
			DoNewUnitHudUpdates();
		}


		// if not selected, select current active unit
		if(!unitIsSelected)
		{
			mGridController.SelectUnit( mActiveUnit, true ); 
		}

		// Notify active unit changed ---- why for both armies ? 
		mArmyAttacker.TurnChanged();
		mArmyDefender.TurnChanged();
	
		CalculateGridAllowed();
		CalculateInputAllowed();
		mGridController.RecalculateReachableCells();
		
		;
		class'H7ReplicationInfo'.static.PrintLogMessage("FinishActiveUnitTurn END" @ mActiveUnit, 0);;

		return MoreActions;
	}
	
	

	/**
	 * check if its a multiplayer to not show the grid cell highlighting 
	 * if its not your turn
	 * */
	function CalculateGridAllowed()
	{
		if( WorldInfo.GRI.IsMultiplayerGame() && !mActiveUnit.GetCombatArmy().IsOwnedByPlayerMP() )
		{
			mGridController.ResetSelectedAndReachableCells();
		}
	}

	function CalculateInputAllowed( optional bool waitForAnimIfNecessary = true )
	{
		local bool animDone;

		if( class'H7OptionsManager'.static.GetInstance().GetSettingBool("GAMEPLAY_WAITS_FOR_ANIM") && waitForAnimIfNecessary )
			animDone = IsAllAnimationFinished();
		else
			animDone = true;
		
		if(IsBadMoraleDelayRunning())
		{
			class'H7PlayerController'.static.GetPlayerController().SetIsUnrealInputAllowed( false );
		}
		// only allow input to the right player in multiplayer
		else if( WorldInfo.GRI.IsMultiplayerGame() )
		{
			class'H7PlayerController'.static.GetPlayerController().SetIsUnrealInputAllowed( mActiveUnit.GetCombatArmy().IsOwnedByPlayerMP() && !mActiveUnit.IsControlledByAI() && mCommandQueue.IsEmpty() && animDone );
		}
		else
		{
			class'H7PlayerController'.static.GetPlayerController().SetIsUnrealInputAllowed( !mActiveUnit.IsControlledByAI() && mCommandQueue.IsEmpty() && animDone );
		}

		if( mActiveUnit.IsA( 'H7WarUnit' ) && /*class'H7OptionsManager'.static.GetInstance().GetSettingBool("GAMEPLAY_WAITS_FOR_ANIM") &&*/ AllAnimationsDone() )
			mActiveUnit.PrepareDefaultAbility();

		// decide if unit belongs to ai controlled player or not
		if( mActiveUnit.IsControlledByAI() )
		{
			mAI.DeferExecution( 1.5f );
		}
	}

	function bool CanRangeAttack( H7IEffectTargetable target )
	{
		local array<H7CombatMapCell> dummyArray;
		dummyArray.Length = 0;
		if( mActiveUnit.GetEntityType() == UNIT_WARUNIT || mActiveUnit.GetEntityType() == UNIT_TOWER )
		{
			return mActiveUnit.GetPreparedAbility().CanCastOnTargetActor( target );
		}
		if( H7CreatureStack( mActiveUnit ).IsRanged() && !mGridController.GetCombatGrid().HasAdjacentCreature( mActiveUnit, none, true, dummyArray ) )	// is not blocked by an enemy unit
		{
			// ammo check
			if( H7CreatureStack( mActiveUnit ).UsesAmmo() && H7CreatureStack( mActiveUnit ).GetAmmo() <= 0 )
			{
				return false;
			}
			else
			{
				return mActiveUnit.GetPreparedAbility().CanCastOnTargetActor( target );
			}
		}

		return false;
	}
	
	function bool HasCreatureOnPlace( H7Unit target ) 
	{
		local H7CombatMapCell cell; 
		local array<H7CombatMapCell> cells;
		cell = GetGridController().GetCell( GetGridController().GetCellLocation(  target.GetGridPosition() ) );
		cells = cell.GetMaster2ndLayer().GetMergedCells2ndLayer();

		foreach cells( cell ) 
		{
			if( cell.GetMaster().HasCreatureStack() ) 
				return true;
		}

		return false;
	}

	// master function for flee, don't call the other 3
	function bool IsFleePossible(optional out string blockReason) 
	{
		local bool mechanicAllowsFlee,kismetAllowsFlee, artifactAllowsFlee;
		blockReason = "PU_FLEE_DISABLED";

		// always can flee in duel
		if(class'H7AdventureController'.static.GetInstance() == none && class'H7ReplicationInfo'.static.GetInstance().IsCombatMap())
		{
			return true;
		}

		mechanicAllowsFlee = MechanicAllowsFleeSurrender( true , blockReason );
		artifactAllowsFlee = ArtifactAllowsFleeSurrender();
		if(!artifactAllowsFlee)
		{
			blockReason = class'H7Loca'.static.LocalizeSave("PU_ARTIFACT_DISABLE_FLEE","H7PopUp");
			blockReason = Repl(blockReason, "%item", GetDisableFleeSurrenderArtifact());
			blockReason = Repl(blockReason, "%hero", GetHeroWithDisableFleeSurrender());
		}
		kismetAllowsFlee = class'H7AdventureController'.static.GetInstance() == none || class'H7AdventureController'.static.GetInstance().KismetAllowsFlee();
		// grid (combat map) allows?                    // kismet (adv map) allows? // game mechanics allows?
		return mGridController.GetCombatGrid().GridAllowsFlee() && kismetAllowsFlee && mechanicAllowsFlee && artifactAllowsFlee;
	}

	// master function for surrender, don't call the other 4
	function bool IsSurrenderPossible(optional out string blockReason)
	{
		local bool mechanicAllowsSurrender,kismetAllowsSurrender, artifactAllowsSurrender;
		blockReason = "PU_SURRENDER_DISABLED"; // general block reason, unless overwritten by specific reason later 
		mechanicAllowsSurrender = MechanicAllowsFleeSurrender( false , blockReason );
		artifactAllowsSurrender = ArtifactAllowsFleeSurrender();
		if(!artifactAllowsSurrender)
		{
			blockReason = class'H7Loca'.static.LocalizeSave("PU_ARTIFACT_DISABLE_SURRENDER","H7PopUp");
			blockReason = Repl(blockReason, "%item", GetDisableFleeSurrenderArtifact());
			blockReason = Repl(blockReason, "%hero", GetHeroWithDisableFleeSurrender());
		}
		kismetAllowsSurrender = class'H7AdventureController'.static.GetInstance() == none || class'H7AdventureController'.static.GetInstance().KismetAllowsFlee();
		// grid (combat map) allows?                        // kismet (adv map) allows? // game mechanics allows?
		return mGridController.GetCombatGrid().GridAllowsSurrender() && kismetAllowsSurrender && mechanicAllowsSurrender && artifactAllowsSurrender;
	}

	// for active army
	function bool MechanicAllowsFleeSurrender(bool flee, optional out string blockReason)
	{
		local H7AdventureController adventureController;
		adventureController = class'H7AdventureController'.static.GetInstance();
		if( adventureController == none ) { return false; }
		
		if(mGridController.IsSiegeMap() && !GetActiveArmy().IsAttacker())
		{
			blockReason = "PU_NO_FLEESURRENDER_TOWNDEF";
			return false;
		}
		
		if( !flee)
		{
			// logically you could surrender your hero-less army to an opponent hero, but this never happens in the game flow (except in seige-defense, which exits above)
			if(GetActiveArmy().IsAttacker() && !mArmyDefender.GetHero().IsHero() 
				|| !GetActiveArmy().IsAttacker() && !mArmyAttacker.GetHero().IsHero() )
			{
				blockReason = "PU_NO_SURRENDER_NEUTRAL";
				return false;
			}
		}

		return (adventureController.GetArmyAttacker().CanFleeOrSurrender() && adventureController.GetArmyDefender().CanFleeOrSurrender());
	}

	function bool ArtifactAllowsFleeSurrender()
	{
		local array <H7BaseAbility> heroAbilities;
		local H7BaseAbility ability;
		local array <H7AdventureHero> combatHeroes;
		local int i;
		
		if( class'H7AdventureController'.static.GetInstance() != none )
		{
			combatHeroes.AddItem(class'H7AdventureController'.static.GetInstance().GetArmyAttacker().GetHero());
			combatHeroes.AddItem(class'H7AdventureController'.static.GetInstance().GetArmyDefender().GetHero());
		}
		else
		{
			if( mArmyAttacker.GetAdventureHero() != none )
			{
				combatHeroes.AddItem(mArmyAttacker.GetAdventureHero());
			}
			if( mArmyDefender.GetAdventureHero() != none )
			{
				combatHeroes.AddItem(mArmyDefender.GetAdventureHero());
			}
		}

		//Checks the hero abilities for the disable flee surrender attribute
		for(i=0; i<combatHeroes.Length; i++)
		{
			heroAbilities = combatHeroes[i].GetAbilities();
			foreach heroAbilities(ability)
			{
				if(ability.GetDisableFleeSurrender())
				{
					StoreDisableFleeSurrenderOrigin(combatHeroes[i]);
					return false;
				}	
			}
		}

		return true;
	}

	function StoreDisableFleeSurrenderOrigin( H7AdventureHero hero )
	{
		local H7AdventureHero localHero;
		local array <H7HeroItem> heroEquipment;
		local H7HeroItem item;
		local array <H7BaseAbility> itemAbilities;
		local H7BaseAbility ability;

		localHero = hero;
		
		mHeroWithDisableFleeSurrender = localHero.GetName();
		localHero.GetEquipment().GetItemsAsArray(heroEquipment);

		foreach heroEquipment(item)
		{
			itemAbilities = item.GetImprintedAbilities();
			if(itemAbilities.Length > 0)
			{
				foreach itemAbilities(ability)
				{
					if(ability.GetDisableFleeSurrender())
					{
						mDisableFleeSurrenderArtifact = item.GetName();
					}
				}
			}
		}
	}

	function bool SetActiveUnitCommand_PrepareAbility( H7BaseAbility ability ) 
	{
		;
		if( mActiveUnit == None )
		{
			;
			return false;
		}
	
		if(ability.GetTargetType() == NO_TARGET)
		{
			mActiveUnit.PrepareAbility(ability);
			RefreshAllUnits();
			SetActiveUnitCommand_UsePreparedAbility(none);
			return false;
		}
		else
		{
			mActiveUnit.PrepareAbility(ability);
			RefreshAllUnits();
			return true;
		}
	}

	function SetActiveUnitCommand_UsePreparedAbility( H7IEffectTargetable target, optional EDirection direction = EDirection_MAX, optional H7CombatMapCell trueHitCell, optional ECommandTag commandTagOverride = ACTION_MAX ) 
	{
		local ECommandTag commandTag;
		if( mActiveUnit == None )
		{
			;
			return;
		}
		if( mActiveUnit.IsDefaultAttackActive() )
		{
			commandTag = mActiveUnit.GetPreparedAbility().IsEqual( mActiveUnit.GetMeleeAttackAbility() ) ? ACTION_MELEE_ATTACK : ACTION_RANGE_ATTACK;
		}
		else
		{
			commandTag = ACTION_ABILITY;
		}
		if( commandTagOverride != ACTION_MAX )
			commandTag = commandTagOverride;
		mCommandQueue.Enqueue( class'H7Command'.static.CreateCommand( mActiveUnit, UC_ABILITY,  commandTag, mActiveUnit.GetPreparedAbility(), target,,,direction,,,, trueHitCell ) );
	}

	// set as active unit the hero of the current active unit
	// used for the new initiative system, the hero (if he didnt do anything in the current turn) can do an action in the turn of the creature
	function SetActiveUnitHero() // heroswitchhero control from creature to hero
	{
		if( mActiveUnit.IsA( 'H7CombatHero' ) )
		{
			;
			return;
		}
		if( !mInitiativeQueue.IsARemainingUnit( mActiveUnit.GetCombatArmy().GetHero() ) )
		{
			;
			return;
		}

		// clear combat map cells and buffers ...
		mGridController.ResetSelectedAndReachableCells();
		mAttackBuffer.Remove(0,mAttackBuffer.Length);
		mNoAttackBuffer.Remove(0,mNoAttackBuffer.Length);

		class'H7CombatHudCntl'.static.GetInstance().DeselectSlot(mActiveUnit.GetID());

		mActiveUnit = mActiveUnit.GetCombatArmy().GetHero();
		mInitiativeQueue.SetOverrideActiveUnitWithHero( mActiveUnit );
		mGridController.SelectUnit(mActiveUnit,true);
		mActiveUnit.BeginTurn();
		CalculateInputAllowed();
		CalculateGridAllowed();
		RefreshAllUnits();
		mLastUnitWasHero = true;

		class'H7CombatHudCntl'.static.GetInstance().SelectSlot(mActiveUnit.GetID());

		// prepare spellbook&quickbar
		class'H7PlayerController'.static.GetPlayerController().GetHud().GetSpellbookCntl().SetHero(H7EditorHero(mActiveUnit));
		class'H7PlayerController'.static.GetPlayerController().GetHud().GetSpellbookCntl().GetQuickBar().SetData(H7EditorHero(mActiveUnit),true);
		class'H7PlayerController'.static.GetPlayerController().GetCombatMapHud().GetCombatHudCntl().GetCreatureAbilityButtonPanel().SelectAbilityButton(-1);
		
	}

	// set back the previous active unit before was replaced by the hero in SetActiveUnitHero
	// used for the new initiative system, the hero (if he didnt do anything in the current turn) can do an action in the turn of the creature
	function SetPreviousActiveUnit()
	{
		local H7Unit previousUnit;

		previousUnit = mActiveUnit;
		mInitiativeQueue.SetOverrideActiveUnitWithHero(none);

		if( mActiveUnit == mInitiativeQueue.GetActiveUnit() )
		{
			;
			return;
		}
		if( !mActiveUnit.IsA( 'H7CombatHero' ) )
		{
			;
			return;
		}

		// clear combat map cells and buffers ...
		mGridController.ResetSelectedAndReachableCells();
		mAttackBuffer.Remove(0,mAttackBuffer.Length);
		mNoAttackBuffer.Remove(0,mNoAttackBuffer.Length);

		// check if the previous unit is still the one that should act now
		// (useful in case of "Haste" and (probably) killed creatures)
		//mInitiativeQueue.CheckAndSetActiveUnit();

		class'H7CombatHudCntl'.static.GetInstance().DeselectSlot(mActiveUnit.GetID());

		H7CombatHero( mActiveUnit ).SetCurrentPreviewAbility( none );

		
		mActiveUnit = mInitiativeQueue.GetActiveUnit();

		// this never happens unless:
		// 1. you have only one stack left
		// 2. stack is the last dude in the ini queue
		// 3. you cast time stasis on it
		// (if you remove this, no one is happy and the combat breaks)
		if( mActiveUnit == none )
		{
			ActivateNextUnit(false);
		}

		// in case the hero did some initiative stuff, check if the active dude needs to prepare an ability
		if( !mActiveUnit.HasPreparedAbility() || mActiveUnit.IsRanged() )
		{
			mActiveUnit.PrepareDefaultAbility();
		}

		if( H7CreatureStack( mActiveUnit ) != none &&
			( mActiveUnit.GetPreparedAbility().IsEqual( H7CreatureStack( mActiveUnit ).GetCreature().GetDefendAbility() )
			|| mActiveUnit.GetPreparedAbility().IsEqual( H7CreatureStack( mActiveUnit ).GetCreature().GetWaitAbility() ) ) )
		{
			mActiveUnit.PrepareDefaultAbility();
		}

		mGridController.SelectUnit(mActiveUnit,true);
		mLastUnitWasHero = false;
		CalculateInputAllowed();
		CalculateGridAllowed();
		RefreshAllUnits();

		// update creature data if the active unit has changed (Time Control) to avoid carrying over the active abilities of the previous one
		if( mActiveUnit != previousUnit )
		{
			class'H7CombatHud'.static.GetInstance().GetCombatHudCntl().SetCreatureAbilityData(mActiveUnit);
		}

		class'H7CombatHudCntl'.static.GetInstance().SelectSlot(mActiveUnit.GetID());
		class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().SetInitiativeInfo();
		class'H7CombatHud'.static.GetInstance().GetSpellbookCntl().GetQuickBar().Update();
	}

	function bool AllowCurrentUnitAction()
	{
		local array<H7Message> messages;

		if(mActiveUnit.IsA('H7CreatureStack'))
		{
			// If there is a last-hero message with active block timer, prevent action
			messages = class'H7MessageSystem'.static.GetInstance().GetMessagesWithActiveAction(MA_BLOCK_UNIT_ACTION);
			if(messages.Length > 0)
			{
				class'H7MessageSystem'.static.GetInstance().BlinkMessages(messages);
				messages[0].settings.action = MA_NONE; // message loses block after blocking once
				return false;
			}
		}

		return true;
	}
}

// this is a waiting state that waits until the post-combat dialog is finished, and then goes to VictoryCam
state CombatEpilog 
{
	event BeginState(name previousStateName)
	{
		;
	}
	
	event EndState(name nextStateName)
	{
		;
	}

	event Tick(float deltaTime)
	{
		super.Tick(deltaTime);

		if(!IsCombatComingFromAdventureMap() || !class'H7ScriptingController'.static.GetInstance().IsCombatPaused())
		{
			if( mResultArmy != none )
			{
				class'H7CombatHud'.static.GetInstance().PrepareVictoryOrDefeatScreen( mResultArmy, mResultWin, mResultXPWinner, mResultXPLoser );
			}
			mGridController.ResetSelectedAndReachableCells();
			mActiveUnit.EndTurn();
	
			if( class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager() != none )
			{
				class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager().OnEndNormalCombat();
			}

			mCheckEndCombatImmediately = false;
			GotoState('PlayingVictoryCam');
		}
	}
}

// this is the state active while VictoryCam is playing and is responsible for start and end of VictoryCam
// - if VictoryCam is disabled this state will be instant
state PlayingVictoryCam
{
	event BeginState(name previousStateName)
	{
		;
		class'H7CameraActionController'.static.GetInstance().StartArmyVictory(VictoryCamEnded);
	}

	event EndState(name nextStateName)
	{
		;
	}
	
	function VictoryCamEnded()
	{
		class'H7CombatHud'.static.GetInstance().ShowPreparedScreen();
		GotoState('EndOfCombat');
	}
}

state EndOfCombat
{
	event BeginState(name previousStateName)
	{
		;

		// AI Automated test build.
		if (class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().IsAutomatedTestingAIEnabled())
		{
			// Close the end of combat popup which will handle the merge by calling BtnCancelClicked() and then call TravelBack() of this state
			class'H7PlayerController'.static.GetPlayerController().GetHud().GetCombatPopUpCntl().ClosePopup();

		}
	}
	
	event EndState(name nextStateName)
	{
		;
	}

	/**
	 * - called by gui after gui popup closed
	 * Travel back to adventuremap or main menu
	 * Updates all Heroes and Armies 
	 * Switch state to EndCombat in the CombatMapInfo
	 * */
	function TravelBack()
	{
		local H7AdventureArmy victoriousArmy, defeatArmy;
		local H7AdventureController advCntl;

		class'H7TransitionData'.static.GetInstance().SetIsReplayCombat(false);

		if(class'H7SpectatorHUDCntl'.static.GetInstance().GetPopup().IsVisible())
		{
			class'H7SpectatorHUDCntl'.static.GetInstance().ClosePopup();
			class'H7LogSystemCntl'.static.GetInstance().GetLog().SetVisibleSave(true);
		}

		if( IsCombatComingFromAdventureMap() )
		{
			advCntl = class'H7AdventureController'.static.GetInstance();
			if ( mArmyAttacker.WonBattle() )
			{
				victoriousArmy = advCntl.GetArmyAttacker();
				defeatArmy = advCntl.GetArmyDefender();
			}
			else
			{
				victoriousArmy = advCntl.GetArmyDefender();
				defeatArmy = advCntl.GetArmyAttacker();
			}

			if( advCntl.GetCurrentBattleSite() != none && mArmyAttacker.WonBattle() )
			{
				advCntl.GetCurrentBattleSite().OnAccept( victoriousArmy.GetHero() );
			}
			
			advCntl.DoBackToAdventureFromCombat(victoriousArmy, defeatArmy, !mAnyDidSurrender);
			
			if( mGridController.IsSiegeMap() )
			{
				mGridController.DeleteTownDataRef();
			}
		}
		else
		{
			TrackingGameModeEnd();
			H7ReplicationInfo( WorldInfo.GRI).ReturnToMainMenuNoPC();
		}

		mArmyAttacker.GetHero().GetInventory().DeleteUsedConsumables();
		mArmyDefender.GetHero().GetInventory().DeleteUsedConsumables();

		//Remove the SlotID at the end of the combat, so the deployment is not mixed up
		mArmyAttacker.RemoveDeadCreatureStackDeploymentSlotID();
		mArmyDefender.RemoveDeadCreatureStackDeploymentSlotID();

		mArmyAttacker.Destroy();
		mArmyDefender.Destroy();
	}
}

