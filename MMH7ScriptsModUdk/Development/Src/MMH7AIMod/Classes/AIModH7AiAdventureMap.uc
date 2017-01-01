//=============================================================================
// H7AiAdventureMap
//=============================================================================
// The main entry point for ai processing in an adventure map. The 'singleton' 
// is spawned by the AdventureController on initialization
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class AIModH7AiAdventureMap extends Actor
	dependsOn(H7AiAdventureSensors);

var protected H7AiAdventureSensors              mSensors;
var protected float                             mDeferTimer;
var protected H7AiActionAttackTargetArmy        mActionAttackTargetArmy;
var protected H7AiActionAttackTargetBorderArmy  mActionAttackTargetBorderArmy;
var protected H7AiActionAttackTargetAoC         mActionAttackTargetAoC;
var protected H7AiActionDestroyTargetMine       mActionDestroyTargetMine;
var protected H7AiActionAttackTargetCity        mActionAttackTargetCity;
var protected H7AiActionAttackTargetEnemy       mActionAttackTargetEnemy;
var protected H7AiActionReinforce               mActionReinforce;
var protected H7AiActionDevelopTownBuilding     mActionDevelopTownBuilding;
var protected H7AiActionRecruitment             mActionRecruitment;
var protected H7AiActionTrade                   mActionTrade;
var protected H7AiActionGarrisonTown            mActionGarrisonTown;
var protected H7AiActionHireHero                mActionHireHero;
var protected H7AiActionExplore                 mActionExplore;
var protected H7AiActionRepairTarget            mActionRepair;
var protected H7AiActionUseSite                 mActionUseSite;
var protected H7AiActionUseSite_Boost           mActionUseSiteBoost;
var protected H7AiActionUseSite_Commission      mActionUseSiteCommission;
var protected H7AiActionUseSite_Exercise        mActionUseSiteExercise;
var protected H7AiActionUseSite_Observe         mActionUseSiteObserve;
var protected H7AiActionUseSite_Teleporter      mActionUseSiteTeleporter;
var protected H7AiActionUseSite_Shop            mActionUseSiteShop;
var protected H7AiActionUseSite_Study           mActionUseSiteStudy;
var protected H7AiActionUseSite_Keymaster       mActionUseSiteKeymaster;
var protected H7AiActionUseSite_Obelisk         mActionUseSiteObelisk;
var protected H7AiActionRetrieveTearOfAsha      mActionRetrieveTearOfAsha;
var protected H7AiActionPlunder                 mActionPlunder;
var protected H7AiActionPickup                  mActionPickup;
var protected H7AiActionGather                  mActionGather;
var protected H7AiActionFlee                    mActionFlee;
var protected H7AiActionChillAroundTown         mActionChill;
var protected H7AiActionCongregate              mActionCongregate;
var protected H7AiActionUpgradeCreatures        mActionUpgradeCreature;
var protected H7AiActionReplenish               mActionReplenish;
var protected int                               mThinkStep;
var protected int                               mRecruitStep;
var protected array<AiActionScore>              mScores;

var protected float mTimeSinceLastThink;

function float GetTimeSinceLastThink()
{
	return mTimeSinceLastThink;
}

function ResetTimeSinceLastThink()
{
	mTimeSinceLastThink = 0.0f;
}

// Ai actions

function int GetRecruitStep() { return mRecruitStep; }
function SetRecruitStep( int v ) { mRecruitStep = v; }

function H7AiAdventureSensors GetSensors() { return mSensors; }

function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	mSensors = new class 'H7AiAdventureSensors';
	mSensors.Setup();

	// actions
	mActionAttackTargetArmy = new class'H7AiActionAttackTargetArmy';
	mActionAttackTargetArmy.Setup();
	mActionAttackTargetBorderArmy = new class'H7AiActionAttackTargetBorderArmy';
	mActionAttackTargetBorderArmy.Setup();
	mActionAttackTargetAoC = new class'H7AiActionAttackTargetAoC';
	mActionAttackTargetAoC.Setup();
	mActionDestroyTargetMine = new class'H7AiActionDestroyTargetMine';
	mActionDestroyTargetMine.Setup();
	mActionAttackTargetCity = new class'H7AiActionAttackTargetCity';
	mActionAttackTargetCity.Setup();
	mActionAttackTargetEnemy = new class'H7AiActionAttackTargetEnemy';
	mActionAttackTargetEnemy.Setup();
	mActionReinforce = new class'H7AiActionReinforce';
	mActionReinforce.Setup();
	mActionDevelopTownBuilding = new class'H7AiActionDevelopTownBuilding';
	mActionDevelopTownBuilding.Setup();
	mActionRecruitment = new class'H7AiActionRecruitment';
	mActionRecruitment.Setup();
	mActionTrade = new class'H7AiActionTrade';
	mActionTrade.Setup();
	mActionGarrisonTown = new class'H7AiActionGarrisonTown';
	mActionGarrisonTown.Setup();
	mActionHireHero = new class'H7AiActionHireHero';
	mActionHireHero.Setup();
	mActionExplore = new class'H7AiActionExplore';
	mActionExplore.Setup();
	mActionRepair = new class'H7AiActionRepairTarget';
	mActionRepair.Setup();
	mActionUseSite = new class'H7AiActionUseSite';
	mActionUseSite.Setup();
	mActionUseSiteBoost = new class'H7AiActionUseSite_Boost';
	mActionUseSiteBoost.Setup();
	mActionUseSiteCommission = new class'H7AiActionUseSite_Commission';
	mActionUseSiteCommission.Setup();
	mActionUseSiteExercise = new class'H7AiActionUseSite_Exercise';
	mActionUseSiteExercise.Setup();
	mActionUseSiteObserve = new class'H7AiActionUseSite_Observe';
	mActionUseSiteObserve.Setup();
	mActionUseSiteTeleporter = new class'H7AiActionUseSite_Teleporter';
	mActionUseSiteTeleporter.Setup();
	mActionUseSiteShop = new class'H7AiActionUseSite_Shop';
	mActionUseSiteShop.Setup();
	mActionUseSiteStudy = new class'H7AiActionUseSite_Study';
	mActionUseSiteStudy.Setup();
	mActionUseSiteKeymaster = new class'H7AiActionUseSite_Keymaster';
	mActionUseSiteKeymaster.Setup();
	mActionUseSiteObelisk = new class'H7AiActionUseSite_Obelisk';
	mActionUseSiteObelisk.Setup();
	mActionRetrieveTearOfAsha = new class'H7AiActionRetrieveTearOfAsha';
	mActionRetrieveTearOfAsha.Setup();
	mActionPlunder = new class'H7AiActionPlunder';
	mActionPlunder.Setup();
	mActionPickup = new class'H7AiActionPickup';
	mActionPickup.Setup();
	mActionGather = new class'H7AiActionGather';
	mActionGather.Setup();
	mActionFlee = new class'H7AiActionFlee';
	mActionFlee.Setup();
	mActionChill = new class'H7AiActionChillAroundTown';
	mActionChill.Setup();
	mActionCongregate = new class'H7AiActionCongregate';
	mActionCongregate.Setup();
	mActionUpgradeCreature = new class 'H7AiActionUpgradeCreatures';
	mActionUpgradeCreature.Setup();
	mActionReplenish = new class 'H7AiActionReplenish';
	mActionReplenish.Setup();
}

delegate int ScoreSort(AiActionScore A, AiActionScore B) { return A.score < B.score ? -1 : 0; }

// master function deciding if AI is doing anything
function bool IsAiEnabled()
{
	return class'H7PlayerController'.static.GetPlayerController().IsServer();
}

function DeferExecution( float seconds )
{
	mDeferTimer = seconds;
}

function DeferExecutionMore(){
}

function ResetThink()
{
	mDeferTimer = 0.00001f;
	mThinkStep = 0;
	mScores.Remove(0,mScores.Length);
}

function ThinkBig( H7Player dasPlayer )
{
	local array<H7AdventureArmy> armies, myArmies, reachableArmies, allReachableArmies;
	local array<H7VisitableSite> reachableSites, allReachableSites;
	local H7VisitableSite site;
	local array<float> reachableArmiesDistance, reachableSitesDistance;
	local H7AdventureArmy army;
	local array<H7AdventureObject> advObjects;
	local H7AdventureObject advObj;
	local int i;
	local H7FOWController fowCntl;
	local H7AreaOfControlSiteVassal vassal;
	local H7AreaOfControlSiteLord lord, closestLord;
	local float myPower;
	local array<H7AreaOfControlSiteLord> victimLords, hiddenLords;
	local array<H7AreaOfControlSiteVassal> liberatableSites;
	local H7AiObjectivePair objective;
	local float minSiteDistance;
	local H7AdventureController advCntl;
	local H7AdventureArmy scoutArmy;
	local float pathCost, minPathCost;
	local array<H7AdventureArmy> scouts;

	dasPlayer.CheckExploreObjectives();

	advCntl = class'H7AdventureController'.static.GetInstance();

	advCntl.GetArmiesCurrentlyOnMap( armies );
	advObjects = advCntl.GetAdvObjectList();

	for( i = advObjects.Length - 1; i >= 0; --i )
	{
		advObj = advObjects[i];
		if( H7VisitableSite( advObj ) != none )
		{
			fowCntl = H7VisitableSite( advObj ).GetEntranceCell().GetGridOwner().GetFOWController();
			if( !fowCntl.CheckExploredTile( dasPlayer.GetPlayerNumber(), H7VisitableSite( advObj ).GetEntranceCell().GetGridPosition() ) )
			{
				advObjects.RemoveItem( advObj );
				if( H7AreaOfControlSiteLord( advObj ) != none && H7AreaOfControlSiteLord( advObj ).GetPlayer() != dasPlayer )
				{
					hiddenLords.AddItem( H7AreaOfControlSiteLord( advObj ) );
				}
			}
		}
	}

	for( i = armies.Length - 1; i >= 0; --i )
	{
		army = armies[i];
		fowCntl = army.GetCell().GetGridOwner().GetFOWController();
		if( !fowCntl.CheckExploredTile( dasPlayer.GetPlayerNumber(), army.GetCell().GetGridPosition() ) )
		{
			armies.RemoveItem( army );
		}
	}

	myArmies = advCntl.GetPlayerArmies( dasPlayer, true );
	class'H7AdventureArmy'.static.SortArmyListByStrength( myArmies );

	foreach myArmies( army )
	{
		class'H7AdventureGridManager'.static.GetInstance().GetPathfinder().GetReachableSitesAndArmies( army.GetCell(), army.GetPlayer(), army.HasShip(), reachableSites, reachableArmies, reachableSitesDistance, reachableArmiesDistance, false );
		foreach reachableSites( site )
		{
			if( allReachableSites.Find( site ) == INDEX_NONE )
			{
				allReachableSites.AddItem( site );
			}
		}
		foreach reachableArmies( army )
		{
			if( allReachableArmies.Find( army ) == INDEX_NONE )
			{
				allReachableArmies.AddItem( army );
			}
		}
		if( army.GetHero().GetAiRole() == HRL_MULE || army.GetHero().GetAiRole() == HRL_SCOUT || army.GetHero().GetAiRole() == HRL_SUPPORT )
		{
			scouts.AddItem( army );
		}
	}

	myPower = dasPlayer.CalculatePlayerPower();
	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	foreach allReachableSites( site )
	{
		vassal = H7AreaOfControlSiteVassal( site );
		if( vassal != none && H7CustomNeutralDwelling( vassal ) == none && H7AreaOfControlBuffSite( vassal ) == none )
		{
			if( vassal.GetLord().GetPlayer() == dasPlayer && vassal.GetPlayer() != dasPlayer )
			{
				// we need to capture this
				liberatableSites.AddItem( vassal );
			}
		}

		lord = H7AreaOfControlSiteLord( site );
	 	
		if( lord != none )
		{
			if( lord.GetPlayer() != dasPlayer && myPower > lord.GetPlayer().CalculatePlayerPower() )
			{
				// we want this
				victimLords.AddItem( lord );
			}
		}
	}

	// no possible lords to be conquered? Fix that shit and scout some
	closestLord = none;
	if( victimLords.Length == 0 && scouts.Length > 0 )
	{
		scoutArmy = scouts[ class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( scouts.Length ) ];
		class'H7AdventureGridManager'.static.GetInstance().GetPathfinder().GetReachableSitesAndArmies( scoutArmy.GetCell(), scoutArmy.GetPlayer(), scoutArmy.HasShip(), reachableSites, reachableArmies, reachableSitesDistance, reachableArmiesDistance, true );
		minPathCost = class'H7AdventureMapPathfinder'.const.INFINITE;
		foreach hiddenLords( lord )
		{
			if( lord.GetPlayer() == dasPlayer || 
				reachableSites.Find( lord ) == INDEX_NONE )
			{
				continue;
			}
			
			pathCost = reachableSitesDistance[reachableSites.Find( lord )];

			if( pathCost < minPathCost )
			{
				closestLord = lord;
				minPathCost = pathCost;
			}
		}

		if( closestLord != none && dasPlayer.IsObjectiveTargetFree( closestLord ) )
		{
			objective.Subordinate = scoutArmy;
			objective.Target = closestLord;
			objective.ActionType = AID_Explore;
			dasPlayer.AddObjective( objective );
		}
	}
	
	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	foreach liberatableSites( vassal )
	{
		if( !dasPlayer.IsObjectiveTargetFree( vassal ) )
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			continue;
		}

		// clear temp data
		minSiteDistance = class'H7AdventureMapPathfinder'.const.INFINITE;
		objective.Subordinate = none;
		objective.Target = none;
		armies.Length = 0;
		
		// check all my armies who can attack this site
		foreach myArmies( army )
		{
			
			if( ( vassal.GetGuardingArmy() == none || advCntl.GetAPRLevel( army, vassal.GetGuardingArmy() ) < APR_MODEST ) &&
				army.IsSiteReachable( vassal ) )
			{
				// add candidates to capture this shit
				
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				armies.AddItem( army );
			}
		}
		
		// get the closest army to the objective
		objective.Target = vassal;
		objective.ActionType = AID_AttackAoC;
		foreach armies( army )
		{
			if( army.GetReachableSiteDistance( vassal ) < minSiteDistance && dasPlayer.IsSubordinateFree( army ) )
			{
				minSiteDistance = army.GetReachableSiteDistance( vassal );
				objective.Subordinate = army;
			}
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		}

		// this check should not be necessary but you never know - only add an objective if we have determined a target and subordinate
		if( objective.Subordinate != none )
		{
			dasPlayer.AddObjective( objective );
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		}
	}

	liberatableSites = liberatableSites;
	victimLords = victimLords;

	
}

function Obey( H7AdventureArmy army )
{
	local array<H7AiObjectivePair> objectives;
	local bool success;
	local H7AdventureGridManager gridManager;

	success = success;
	gridManager = class'H7AdventureGridManager'.static.GetInstance();

	objectives = army.GetPlayer().GetObjectivesBySubordinate( army );
	switch( objectives[0].ActionType )
	{
		case AID_AttackAoC:
			if( H7AreaOfControlSite( objectives[0].Target ) != none )
			{
				if( H7AreaOfControlSite( objectives[0].Target ).GetGuardingArmy() != none )
				{
					success = gridManager.DoAttackArmy( H7AreaOfControlSite( objectives[0].Target ).Location,  true, true );
				}
				else
				{
					success = gridManager.DoVisit( H7AreaOfControlSite( objectives[0].Target ), true, true );
				}
			}
			
			break;
		case AID_Explore:
			if( H7Teleporter( objectives[0].Target ) != none )
			{
				gridManager.DoExplore( class'H7AiActionChillAroundTown'.static.GetRandomCellAroundMapObject( objectives[0].Target ), true, true, true );
			}
			else
			{
				gridManager.DoExplore( class'H7AiActionChillAroundTown'.static.GetRandomCellAroundMapObject( objectives[0].Target ), true, true );
			}
	}
	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
}

//native function UpdateAiVisibility();

function Think( H7Unit unit, float deltaTime )
{
	local H7AdventureController ctrl;
	local H7AdventureConfiguration advConfig;
	
	local int i, j;
	local bool action_done;

//	`LOG_AI("Think :" @ unit @ "Step" @ mThinkStep @ "Timer" @ mDeferTimer );
	if(!IsAiEnabled()) return;
	if( unit == None ) return;

	if( mDeferTimer  < 0.0f ) return;
	mDeferTimer -= deltaTime;
	if( mDeferTimer >= 0.0f ) return;

	ResetTimeSinceLastThink();

//	`LOG_AI("Think :" @ unit @ "Step" @ mThinkStep);

	ctrl = class'H7AdventureController'.static.GetInstance();
	advConfig = ctrl.GetConfig();

	

	if( mThinkStep == 0 )
	{ 
		mSensors.GetSensorIConsts().SetTargetTown(None);
		if( mSensors.GetSensorIConsts().mCalcStep != INDEX_NONE )
		{
			mSensors.UpdateConsts(false);
			mDeferTimer = 0.0001f;
			return;
		}
		else
		{
			mSensors.GetSensorIConsts().ResetCalcStep();
		}
		mThinkStep = 1;
		mScores.Remove(0,mScores.Length);
		//ThinkBig( unit.GetPlayer() );
		mDeferTimer = 0.00001f;
		return;
	}

	if( unit.GetEntityType() == UNIT_HERO )
	{
		if( unit.GetPlayer().DoesSubordinateHaveObjectives( unit.GetAdventureArmy() ) )
		{
			//Obey( unit.GetAdventureArmy() );
			DeferExecution( 0.00001f );
			mSensors.ResetConsts();
			mThinkStep = 0;
			ctrl.FinishHeroTurn();
			return;
		}

		if( mThinkStep == 1 )
		{
			mActionAttackTargetArmy.RunScoresAdv(mSensors,unit,mScores,advConfig);
			mThinkStep = 111;
			mDeferTimer = 0.00001f;
			return;
		}
		if( mThinkStep == 111 )
		{
			mActionAttackTargetBorderArmy.RunScoresAdv(mSensors,unit,mScores,advConfig);
			mThinkStep = 2;
			//mDeferTimer = 0.00001f;
			//return;
		}
		if( mThinkStep == 2 )
		{
			mActionAttackTargetAoC.RunScoresAdv(mSensors,unit,mScores,advConfig);
			if( class'H7AdventureController'.static.GetInstance().GetMapInfo().IsMineDestructionAllowed() )
			{
				mThinkStep = 21;
			}
			else
			{
				mThinkStep = 3;
			}
			mDeferTimer = 0.00001f;
			return;
		}
		if( mThinkStep == 21 )
		{
			mActionDestroyTargetMine.RunScoresAdv(mSensors,unit,mScores,advConfig);
			mThinkStep = 3;
			//mDeferTimer = 0.00001f;
			//return;
		}
		if( mThinkStep == 3 )
		{
			mActionAttackTargetCity.RunScoresAdv(mSensors,unit,mScores,advConfig);
			mThinkStep = 31;
			//mDeferTimer = 0.00001f;
			//return;
		}
		if( mThinkStep == 31 )
		{
			mActionAttackTargetEnemy.RunScoresAdv(mSensors,unit,mScores,advConfig);
			mThinkStep = 4;
			//mDeferTimer = 0.00001f;
			//return;
		}
		if( mThinkStep == 4 )
		{
			mActionRepair.RunScoresAdv(mSensors,unit,mScores,advConfig);
			mThinkStep=5;
			//mDeferTimer = 0.00001f;
			//return;
		}
		if( mThinkStep == 5 )
		{
			mActionReinforce.RunScoresAdv(mSensors,unit,mScores,advConfig);
			mThinkStep = 6;
			mDeferTimer = 0.00001f;
			return;
		}

		if( mThinkStep == 6 )
		{
			mActionGarrisonTown.RunScoresAdv(mSensors,unit,mScores,advConfig);
			mThinkStep = 7;
			//mDeferTimer = 0.00001f;
			//return;
		}

		if( mThinkStep == 7 )
		{
			mActionExplore.RunScoresAdv(mSensors,unit,mScores,advConfig);
			mThinkStep = 8;
			mDeferTimer = 0.00001f;
			return;
		}

		if( mThinkStep == 8 )
		{
			mActionUseSiteBoost.RunScoresAdv(mSensors,unit,mScores,advConfig);
			mThinkStep = 81;
			mDeferTimer = 0.00001f;
			return;
		}
		if( mThinkStep == 81 )
		{
			mActionUseSiteCommission.RunScoresAdv(mSensors,unit,mScores,advConfig);
			mThinkStep = 82;
			//mDeferTimer = 0.00001f;
			//return;
		}
		if( mThinkStep == 82 )
		{
			mActionUseSiteExercise.RunScoresAdv(mSensors,unit,mScores,advConfig);
			mThinkStep = 83;
			//mDeferTimer = 0.00001f;
			//return;
		}
		if( mThinkStep == 83 )
		{
			mActionUseSiteObserve.RunScoresAdv(mSensors,unit,mScores,advConfig);
			mThinkStep = 84;
			//mDeferTimer = 0.00001f;
			//return;
		}
		if( mThinkStep == 84 )
		{
			mActionUseSiteShop.RunScoresAdv(mSensors,unit,mScores,advConfig);
			mThinkStep = 85;
			//mDeferTimer = 0.00001f;
			//return;
		}
		if( mThinkStep == 85 )
		{
			mActionUseSiteStudy.RunScoresAdv(mSensors,unit,mScores,advConfig);
			mThinkStep = 86;
			//mDeferTimer = 0.00001f;
			//return;
		}
		if( mThinkStep == 86 )
		{
			mActionUseSiteKeymaster.RunScoresAdv(mSensors,unit,mScores,advConfig);
			mThinkStep = 87;
			//mDeferTimer = 0.00001f;
			//return;
		}
		if( mThinkStep == 87 )
		{
			mActionUseSiteObelisk.RunScoresAdv(mSensors,unit,mScores,advConfig);
			mThinkStep = 88;
			//mDeferTimer = 0.00001f;
			//return;
		}
		if( mThinkStep == 88 )
		{
			mActionRetrieveTearOfAsha.RunScoresAdv(mSensors,unit,mScores,advConfig);
			mThinkStep = 89;
			//mDeferTimer = 0.00001f;
			//return;
		}
		if( mThinkStep == 89 )
		{
			mActionUseSiteTeleporter.RunScoresAdv(mSensors,unit,mScores,advConfig);
			mThinkStep = 9;
			//mDeferTimer = 0.00001f;
			//return;
		}
		if( mThinkStep == 9 )
		{
			mActionPlunder.RunScoresAdv(mSensors,unit,mScores,advConfig);
			mThinkStep = 10;
			//mDeferTimer = 0.00001f;
			//return;
		}

		if( mThinkStep == 10 )
		{
			mActionPickup.RunScoresAdv(mSensors,unit,mScores,advConfig);
			mThinkStep = 11;
			mDeferTimer = 0.00001f;
			return;
		}

		if( mThinkStep == 11 )
		{
			mActionFlee.RunScoresAdv(mSensors,unit,mScores,advConfig);
			if( unit.GetAdventureArmy().IsAITradeDisabled() )
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				mThinkStep = 13;
			}
			else
			{
				mThinkStep = 12;
			}
			//mDeferTimer = 0.00001f;
			//return;
		}

		if( mThinkStep == 12 )
		{
			mActionCongregate.RunScoresAdv(mSensors,unit,mScores,advConfig);
			mThinkStep = 13;
			//mDeferTimer = 0.00001f;
			//return;
		}

		if( mThinkStep == 13 )
		{
			mActionChill.RunScoresAdv(mSensors,unit,mScores,advConfig);
			mThinkStep = 14;
			//mDeferTimer = 0.00001f;
			//return;
		}

		if( mThinkStep == 14 )
		{ 
			mActionReplenish.RunScoresAdv(mSensors,unit,mScores,advConfig);
			mThinkStep = 15;
			//mDeferTimer = 0.00001f;
			//return;
		}

		if( mThinkStep == 15 )
		{
			mActionGather.RunScoresAdv(mSensors,unit,mScores,advConfig);
			mThinkStep = 16;
			//mDeferTimer = 0.00001f;
			//return;
		}

		if( mThinkStep == 16 )
		{
			mActionTrade.RunScoresAdv(mSensors,unit,mScores,advConfig);
			mThinkStep = 17;
			mDeferTimer = 0.00001f;
			return;
		}

		if( mThinkStep == 17 )
		{
			// compare all scores with last score
			for(i=0;i<mScores.Length;i++)
			{
				if( H7AdventureHero(unit).GetAiLastScoreAction()!=None && H7AdventureHero(unit).GetAiLastScoreAction().mABID==mScores[i].action.mABID && mScores[i].action.mABID!=AID_Chill)
				{
					if( H7AdventureHero(unit).GetAiLastScoreParam()!=None && H7AdventureHero(unit).GetAiLastScoreParam().Compare(mScores[i].params)==true )
					{
						mScores[i].dbgString = mScores[i].dbgString $ " *BOOST*";
						mScores[i].score += 0.5f;
					}
				}
			}

			mScores.Sort(ScoreSort);
			mThinkStep = 99;
			//mDeferTimer = 0.00001f;
			//return;
		}



		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		for(i=0;i<Min(mScores.Length,20);i++)
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		}

		action_done=false;

		if( mScores.Length >= 1 )
		{
			for( j = 0; j < mScores.Length; ++j )
			{
				action_done = mScores[j].action.PerformAction(unit,mScores[j]);
				//unit.GetPlayer().IncrementActionCounter( mScores[j].action.mABID );

				i = j;
				if( action_done )
				{
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				}
				else
				{
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				}
				break;
			}

			if( action_done == false )
			{
				H7AdventureHero(unit).SetAiLastScoreActionCounter( 0 );
				H7AdventureHero(unit).SetFinishedCurrentTurn(true);

				H7AdventureHero(unit).SetAiLastScoreAction(mScores[i].action);
				H7AdventureHero(unit).SetAiLastScoreParam(mScores[i].params);

				if(class'H7AdventureController'.static.GetInstance().GetCommandQueue().GetQueueLength() == 0 && !class'H7AdventureController'.static.GetInstance().GetCommandQueue().IsCommandRunning())
				{
					ctrl.FinishHeroTurn();
				}
			}
			else
			{
				if( H7AdventureHero(unit).GetAiLastScoreAction() != none && mScores[i].action.Class == H7AdventureHero(unit).GetAiLastScoreAction().Class )
				{
					H7AdventureHero(unit).SetAiLastScoreActionCounter( H7AdventureHero(unit).GetAiLastScoreActionCounter() + 1 );
				}
				else
				{
					H7AdventureHero(unit).SetAiLastScoreActionCounter( 0 );
				}

				if( H7AdventureHero(unit).GetAiLastScoreActionCounter() >= 10 )
				{
					;
					H7AdventureHero(unit).SetAiLastScoreActionCounter( 0 );
					H7AdventureHero(unit).SetFinishedCurrentTurn(true);
					ctrl.FinishHeroTurn();
				}
			
				H7AdventureHero(unit).SetAiLastScoreAction(mScores[i].action);
				H7AdventureHero(unit).SetAiLastScoreParam(mScores[i].params);
			

				if( H7AdventureHero(unit).GetAiLastScoreActionCounter() > 0 )
				{
					H7AdventureHero(unit).SetAiLastScoreParam( none );
				}
			}
		}
		else
		{
			H7AdventureHero(unit).SetAiLastScoreActionCounter( 0 );
			H7AdventureHero(unit).SetFinishedCurrentTurn(true);

			H7AdventureHero(unit).SetAiLastScoreAction(none);
			H7AdventureHero(unit).SetAiLastScoreParam(none);
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			ctrl.FinishHeroTurn();

		}
		DeferExecution( 0.00001f );
		mSensors.ResetConsts();
	}

	mThinkStep = 0;

}

function ThinkTown( H7AreaOfControlSiteLord site, optional bool calcHeroRecruit = true )
{
	local H7Town town, caravanSource;
	local int i;
	local H7AdventureController ctrl;
	local H7AdventureConfiguration advConfig;
	local H7Player ply;
	local int gold,budget;
	local array<H7Town> caravanSources;
	local array<H7RecruitmentInfo> recruitmentInfo;
	local H7RecruitmentInfo tmpInfo;
	local H7Fort fort;
	local bool hasHeroes;

	if(!IsAiEnabled()) return;
	if( site == None ) return;
	town=H7Town(site);
	fort=H7Fort(site);
	if( town == none && fort == none ) return;

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	if( town != none && town.GetAiHibernationState() == true ) 
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		return;
	}

	ctrl = class'H7AdventureController'.static.GetInstance();
	advConfig = ctrl.GetConfig();

	hasHeroes = site.GetPlayer().GetAmountOfHeroes() > 0;

	if( town != none )
	{

		ply=town.GetPlayer();

		mSensors.GetSensorIConsts().SetTargetTown(town);
		mSensors.UpdateConsts(true);

		// stach away some tresure
		if(town.GetAiIsMain()==true)
		{
			// we want to get a second hero ASAP
			if( class'H7AdventureController'.static.GetInstance().GetTurns() == 1 )
			{
				gold = ply.GetResourceSet().GetCurrency();
				budget = class'H7AdventureController'.static.GetInstance().GetConfig().mBaseNewHeroCost;
		//		`LOG_AI(":" @ gold @ "%" @ advConfig.mAiAdvMapConfig.mConfigHireHeroSpending @ "=>" @ budget);
				if( (ply.GetAiSaveUpSpendingHero().GetCurrency() + budget) > advConfig.mAiAdvMapConfig.mConfigHireHeroSpendingMaxCurrency )
				{
					budget = advConfig.mAiAdvMapConfig.mConfigHireHeroSpendingMaxCurrency - ply.GetAiSaveUpSpendingHero().GetCurrency();
				}
				if(budget>0)
				{
					ply.GetAiSaveUpSpendingHero().ModifyCurrencySilent(budget);
					ply.GetResourceSet().ModifyCurrencySilent(-budget);
				}
			}

			if( hasHeroes ) // if I don't have heroes, don't spend money on recruitment and buildings, get a hero first
			{
				gold = ply.GetResourceSet().GetCurrency();
				budget = int(float(gold) * (advConfig.mAiAdvMapConfig.mConfigRecruitSpending / 100.0f));
		//		`LOG_AI(":" @ gold @ "%" @ advConfig.mAiAdvMapConfig.mConfigRecruitSpending @ "=>" @ budget);
				if( (ply.GetAiSaveUpSpendingRecruitment().GetCurrency() + budget) > advConfig.mAiAdvMapConfig.mConfigRecruitSpendingMaxCurrency )
				{
					budget = advConfig.mAiAdvMapConfig.mConfigRecruitSpendingMaxCurrency - ply.GetAiSaveUpSpendingRecruitment().GetCurrency();
				}
				if(budget>0)
				{
					ply.GetAiSaveUpSpendingRecruitment().ModifyCurrencySilent(budget);
					ply.GetResourceSet().ModifyCurrencySilent(-budget);
				}

				gold = ply.GetResourceSet().GetCurrency();
				budget = int(float(gold) * (advConfig.mAiAdvMapConfig.mConfigDevelopmentSpending / 100.0f));
		//		`LOG_AI(":" @ gold @ "%" @ advConfig.mAiAdvMapConfig.mConfigDevelopmentSpending @ "=>" @ budget);
				if( (ply.GetAiSaveUpSpendingTownDev().GetCurrency() + budget) > advConfig.mAiAdvMapConfig.mConfigDevelopmentSpendingMaxCurrency )
				{
					budget = advConfig.mAiAdvMapConfig.mConfigDevelopmentSpendingMaxCurrency - ply.GetAiSaveUpSpendingTownDev().GetCurrency();
				}
				if(budget>0)
				{
					ply.GetAiSaveUpSpendingTownDev().ModifyCurrencySilent(budget);
					ply.GetResourceSet().ModifyCurrencySilent(-budget);
				}
			}

			gold = ply.GetResourceSet().GetCurrency();
			if( hasHeroes )
			{
				budget = int(float(gold) * (advConfig.mAiAdvMapConfig.mConfigHireHeroSpending / 100.0f));
			}
			else
			{
				budget = gold;
			}

	//		`LOG_AI(":" @ gold @ "%" @ advConfig.mAiAdvMapConfig.mConfigHireHeroSpending @ "=>" @ budget);
			if( (ply.GetAiSaveUpSpendingHero().GetCurrency() + budget) > advConfig.mAiAdvMapConfig.mConfigHireHeroSpendingMaxCurrency )
			{
				budget = advConfig.mAiAdvMapConfig.mConfigHireHeroSpendingMaxCurrency - ply.GetAiSaveUpSpendingHero().GetCurrency();
			}
			if(budget>0)
			{
				ply.GetAiSaveUpSpendingHero().ModifyCurrencySilent(budget);
				ply.GetResourceSet().ModifyCurrencySilent(-budget);
			}
			//
			//`LOG_AI("General Treasure :" @ ply.GetResourceSet().GetCurrency());
			//`LOG_AI("Hire Hero Treasure :" @ ply.GetAiSaveUpSpendingHero().GetCurrency());
			//`LOG_AI("Recruitment Treasure :" @ ply.GetAiSaveUpSpendingRecruitment().GetCurrency());
			//`LOG_AI("Town Dev Treasure :" @ ply.GetAiSaveUpSpendingTownDev().GetCurrency());
		}

		// Hire Hero
		// =========
		if(town.GetAiEnableHireHeroes()==true && calcHeroRecruit)
		{
			mScores.Remove(0,mScores.Length);
			mActionHireHero.RunScoresTown(mSensors,site,mScores,advConfig);
			mScores.Sort(ScoreSort);

			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			for(i=0;i<Min(mScores.Length,10);i++) {
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			}

			if( mScores.Length >= 1 && mScores[0].score>0.0f )
			{
				mScores[0].action.PerformActionTown(site,mScores[0]);
			}
		}
		// Develop Town
		// ============
		if(town.GetAiEnableDevelopTown()==true) 
		{
			if( town.GetVisitingArmy() != none && town.GetVisitingArmy().GetHero().HasTearOfAsha() || town.GetGarrisonArmy() != none && town.GetGarrisonArmy().GetHero().HasTearOfAsha() )
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			}
			else
			{
				mScores.Remove(0,mScores.Length);
				mActionDevelopTownBuilding.RunScoresTown(mSensors,site,mScores,advConfig);
				mScores.Sort(ScoreSort);
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				for(i=0;i<Min(mScores.Length,10);i++) {
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				}
				if( mScores.Length >= 1 && mScores[0].score>0.0f)
				{
					mScores[0].action.PerformActionTown(site,mScores[0]);
				}
			}
		}
		// Upgrade Creatures
		// =================
		mScores.Remove(0,mScores.Length);
		mActionUpgradeCreature.RunScoresTown(mSensors,site,mScores,advConfig);
		mScores.Sort(ScoreSort);
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		for(i=0;i<Min(mScores.Length,10);i++) {
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		}
		if( mScores.Length >= 1 )
		{
			mScores[0].action.PerformActionTown(site,mScores[0]);
		}
		// Recruitment
		// ===========
		town.RequestUnloadCaravans();
	
		if( town.GetCurrentCaravanTarget() == none && town.GetAiEnableRecruitment()==true && ( mRecruitStep % advConfig.mAiAdvMapConfig.mConfigRecruitmentInterval == 0 || town.GetAiThreatLevel() > 0 ) )
		{
			mScores.Remove(0,mScores.Length);
			mActionRecruitment.RunScoresTown(mSensors,site,mScores,advConfig);
			mScores.Sort(ScoreSort);

			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			for(i=0;i<Min(mScores.Length,10);i++) {
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			}
			if( mScores.Length >= 1 && mScores[0].score>0.0f)
			{
				mScores[0].action.PerformActionTown(site,mScores[0]);
			}
		}

		recruitmentInfo = town.GetRecruitAllData();
		foreach recruitmentInfo( tmpInfo )
		{
			town.GetPlayer().AiModifyNeedForRecruitment( tmpInfo.Costs );
		}

		caravanSources = town.GetCurrentCaravanSources();
		if( caravanSources.Length > 0 )
		{
			foreach caravanSources( caravanSource )
			{
				mScores.Remove( 0, mScores.Length );
				mActionRecruitment.RunScoresTown( mSensors, caravanSource, mScores, advConfig );
				mScores.Sort(ScoreSort);
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				for(i=0;i<Min(mScores.Length,10);i++) 
				{
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				}
				if( mScores.Length >= 1 && mScores[0].score>0.0f)
				{
					mScores[0].action.PerformActionTown( caravanSource, mScores[0] );
				}
			}
		}
		// Trading
		// =======
		if(town.GetAiEnableTrade()==true)
		{
			mScores.Remove(0,mScores.Length);
			mActionTrade.RunScoresTown(mSensors,site,mScores,advConfig);
			mScores.Sort(ScoreSort);
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			for(i=0;i<Min(mScores.Length,10);i++) {
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			}
			for(i=0;i<mScores.Length;i++) 
			{
				if(mScores[i].score>0.0f)
				{
					mScores[i].action.PerformActionTown(site,mScores[i]);
				}
			}
		}

		AutoassignGovernorFromGarrison(town);
		ReassignHeroRoles(ply);
		town.SetAiDone( true );
		mSensors.ResetConsts();
	}
	else if( fort != none )
	{
		mScores.Remove(0,mScores.Length);
		mActionRecruitment.RunScoresTown(mSensors,fort,mScores,advConfig);
		mScores.Sort(ScoreSort);

		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		for(i=0;i<Min(mScores.Length,10);i++) {
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		}
		if( mScores.Length >= 1 && mScores[0].score>0.0f)
		{
			mScores[0].action.PerformActionTown(fort,mScores[0]);
		}
	}
}

function AutoassignGovernorFromGarrison( H7Town town )
{
	local H7AdventureHero garrisonHero;

	if(town==None)
	{
		return;
	}

	// set governor from current garrison army if it has a free spot
	if(town.GetGovernor()==None)
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		if( town.GetGarrisonArmy()!=None )
		{
			garrisonHero=town.GetGarrisonArmy().GetHero();
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			if( garrisonHero!=None && garrisonHero.IsHero()==false && garrisonHero.HasGovernorEffect() )
			{
				if( town.GetGovernor()==None )
				{
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
					town.SetGovernor(garrisonHero);
					// we set the town as hometown for the hero
					//garrisonHero.SetAiHomeSite(town);
					//garrisonHero.SetAiHomeRadius(40.0f); // gridcells
				}
			}
		}
	}
}

// returns true if either skilllevel has been increased or new ability has been learned
function bool LevelUpHero( H7AdventureHero hero )
{
	local H7RndSkillManager rndSkillManager;
	local H7HeroAbility     rndAbility, pickedAbility;
	local H7Skill           rndSkill, pickedSkill;
	local H7Skill           skill;
	local array<H7Skill>    pickedSkills, preferredSkills;
	local array<H7HeroAbility> pickedAbilities, preferredAbilities;
	local H7InstantCommandLearnAbility commandLA;
	local H7InstantCommandIncreaseSkill commandIS;
	local int               rndNumber;

	if(hero!=none)
	{
		rndSkillManager=hero.GetSkillManager().GetRndSkillManager();
		rndSkillManager.GenerateNewBatch();
		pickedSkills = rndSkillManager.GetPickedSkills();
		pickedAbilities = rndSkillManager.GetPickedAbilities();

		foreach pickedSkills( rndSkill )
		{
			if( hero.GetSkillManager().GetSkillBySkillType( rndSkill.GetSkillType() ).GetCurrentSkillRank() >= SR_NOVICE )
			{
				pickedSkill = rndSkill;
				break;
			}
			if( rndSkill.GetSchool() == MIGHT && hero.IsMightHero() || rndSkill.GetSchool() != MIGHT && hero.IsMagicHero() )
			{
				preferredSkills.AddItem( rndSkill );
			}
		}
		foreach pickedAbilities( rndAbility )
		{
			if( hero.GetSkillManager().GetSkillBySkillType( rndAbility.GetSkillType() ).GetCurrentSkillRank() >= SR_NOVICE )
			{
				preferredAbilities.AddItem( rndAbility );
			}
		}

		pickedAbility = none;
		foreach preferredAbilities( rndAbility )
		{
			if( pickedAbility == none || hero.GetSkillManager().GetSkillBySkillType( rndAbility.GetSkillType() ).GetCurrentSkillRank() > hero.GetSkillManager().GetSkillBySkillType( pickedAbility.GetSkillType() ).GetCurrentSkillRank() )
			{
				pickedAbility = rndAbility;
			}
		}

		
		if( pickedAbility == none && pickedAbilities.Length > 0 )
		{
			pickedAbility = pickedAbilities[ Rand( pickedAbilities.Length ) ];
		}
		if( pickedSkill == none && pickedSkills.Length > 0 )
		{
			if( preferredSkills.Length > 0 )
			{
				pickedSkill = preferredSkills[ Rand( preferredSkills.Length ) ];
			}
			else
			{
				pickedSkill = pickedSkills[ Rand( pickedSkills.Length ) ];
			}
		}

		rndNumber=Rand(100);

		if(pickedSkill!=None && rndNumber<50)
		{
			commandIS = new class'H7InstantCommandIncreaseSkill';
			commandIS.Init( hero, pickedSkill.GetID(), false, false );
			class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( commandIS );
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			return true;
		}
		if(pickedAbility!=none)
		{
			skill = hero.GetSkillManager().GetSkillBySkillType(pickedAbility.GetSkillType());
		
			commandLA = new class'H7InstantCommandLearnAbility';
			commandLA.Init( hero, skill.GetID(), pickedAbility.GetArchetypeID() );
			class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( commandLA );
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			return true;
		}
	}
	return false;
}

function LevelUpHeroes( H7Player player )
{
	local array<H7AdventureHero> heroes;
	local H7AdventureHero hero;
	local int numPoints;
	
	if(!IsAiEnabled()) return;
//	`LOG_AI("LevelUpHeroes() for player" @ player.GetName() );

	if(player!=none)
	{
		heroes=player.GetHeroes();
		foreach heroes(hero)
		{
			if(hero!=none)
			{
				numPoints=hero.GetSkillPoints();
				while(numPoints>0)
				{
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
					if( LevelUpHero(hero)==false )
					{
						// we force remove excess skillpoints
						hero.SetSkillPoints(0);
						break;
					}
					numPoints--;
				}
			}
		}
	}
}

function bool CheckDiscoveryThreshold( H7Player player, float threshold )
{
	local H7AdventureMapCell            acell;
	local int                           c,totalCount,discoveryCount;
	local H7AiSensorInputConst          sic;
	local H7AdventureMapGridController  gridCtrl;
	local H7FOWController               fogCtrl;
	local int                           plyNumber;
	local int                           absThreshold;

	sic=mSensors.GetSensorIConsts();

	discoveryCount=0;
	plyNumber=player.GetPlayerNumber();

	totalCount = sic.GetCellNumAdv();
	
	absThreshold = int( float(totalCount) * threshold / 100.0f + 0.5f );

	for(c=0;c<totalCount;c++)
	{
		acell=sic.GetCellAdv(c);
		if(acell==None) continue;
		gridCtrl=acell.GetGridOwner();
		if(gridCtrl==None) continue;
		fogCtrl=gridCtrl.GetFOWController();
		if(fogCtrl==None) continue;
		if( fogCtrl.CheckExploredTile( plyNumber, acell.GetCellPosition() ) == true )
		{
			discoveryCount++;
		}
	}

//	`LOG_AI("CheckDiscoveryThreshold() threshold:" @ threshold @ "DC" @ discoveryCount @ "TH" @ absThreshold @ "TC" @ totalCount );

	if(discoveryCount<absThreshold)
	{
//		`LOG_AI("  ==> false" );
		return false;
	}
	
//	`LOG_AI("  ==> true" );
	return true;
}

// at all times we need one hero that has the role as MAIN. Preferable the one with the biggest army
// there must be only one hero with the role MAIN and SECONDARY
function ReassignHeroRoles( H7Player player )
{
	local array<H7AdventureHero> heroes, aliveHeroes, mules;
	local array<H7Town> towns, caravanTargets;
	local array<int> mainCandidateIdxs;
	local array<int> secondaryCandidateIdxs;
	local H7AdventureHero hero;
	local float strongestArmyPower;
	local float strongestArmyPower2;
	local int strongestArmyIdx, strongestArmyIdx2, mainArmyIdx, secondaryArmyIdx, idx, prio;
	local bool isMainHeroPresent, isSecondaryHeroPresent;
	local int support_or_scout, aliveNum, mainCandidateIdx, muleCount, i;
	local bool scoutThresholdReached;
	local H7AdventureController ctrl;
	local H7AdventureConfiguration advConfig;
	local bool needSecondary;

	strongestArmyPower2 = strongestArmyPower2;

	if(!IsAiEnabled()) return;

	ctrl = class'H7AdventureController'.static.GetInstance();
	advConfig = ctrl.GetConfig();

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	if(player!=none)
	{
		scoutThresholdReached=CheckDiscoveryThreshold(player,advConfig.mAiAdvMapConfig.mConfigDiscoveryScoutingThreshold);

		heroes=player.GetHeroes();
		towns=player.GetTowns();
		needSecondary = towns.Length > 1;
		isMainHeroPresent=false;
		isSecondaryHeroPresent=false;
		strongestArmyPower=0.0f;
		strongestArmyPower2=0.0f;
		strongestArmyIdx=INDEX_NONE;
		strongestArmyIdx2=INDEX_NONE;
		mainArmyIdx=INDEX_NONE;
		secondaryArmyIdx=INDEX_NONE;
		support_or_scout=0;
		aliveNum=0;
		prio = 1000;

		foreach heroes(hero,idx)
		{
			if( hero.IsHero() && !hero.IsDead() )
			{
				hero.RecalculateAggressiveness();
				aliveHeroes.AddItem( hero );

				if( hero.GetLevel() > strongestArmyPower )
				{
					strongestArmyIdx2 = strongestArmyIdx;
					strongestArmyPower2 = strongestArmyPower;
					strongestArmyPower = hero.GetLevel();
					strongestArmyIdx = idx;
				}
				if( hero.GetLevel() > strongestArmyPower2 && strongestArmyIdx != idx )
				{
					strongestArmyPower2 = hero.GetLevel();
					strongestArmyIdx2 = idx;
				}

				if( hero.GetAiRole() == HRL_MAIN || hero.GetAiRole() == HRL_GENERAL )
				{
					isMainHeroPresent = true;
					mainArmyIdx = idx;
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
					mainCandidateIdxs.AddItem( mainArmyIdx );
				}
				else if( hero.GetAiRole() == HRL_SECONDARY && needSecondary )
				{
					isSecondaryHeroPresent = true;
					secondaryArmyIdx = idx;
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
					secondaryCandidateIdxs.AddItem( secondaryArmyIdx );
				}
				
				++aliveNum;
			}
		}

		if( aliveHeroes.Length == 0 ) { return; } // all dead
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

		if( isSecondaryHeroPresent && !isMainHeroPresent ) // secondary -> main
		{
			mainArmyIdx = secondaryArmyIdx;
			isMainHeroPresent = true;
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			secondaryArmyIdx = INDEX_NONE;
			isSecondaryHeroPresent = false;
		}
		else // best level -> main
		{
			if( mainCandidateIdxs.Length > 0 )
			{
				foreach mainCandidateIdxs( mainCandidateIdx )
				{
					if( heroes[mainCandidateIdx].GetAiRolePriority() != 0 && heroes[mainCandidateIdx].GetAiRolePriority() < prio )
					{
						prio = heroes[mainCandidateIdx].GetAiRolePriority();
						heroes[mainCandidateIdx].SetAiRole( HRL_SUPPORT );
						mainArmyIdx = mainCandidateIdx;
					}
				}
				heroes[mainArmyIdx].SetAiRole( HRL_MAIN );
			}
			else
			{
				mainArmyIdx = strongestArmyIdx;
				isMainHeroPresent = true;
			}
		}
		
		if( aliveNum > 1 )
		{
			if( heroes[mainArmyIdx].GetAiRole() != HRL_MAIN && heroes[mainArmyIdx].GetAiRolePriority() == 0 )
			{
				player.IncrementAIMainCounter();
				heroes[mainArmyIdx].SetAiRolePriority( player.GetAIMainCounter() );
			}

			heroes[mainArmyIdx].SetAiRole( HRL_MAIN );
			//heroes[mainArmyIdx].SetAiAggressivness(HAG_HOSTILE);
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		}
		else
		{
			heroes[mainArmyIdx].SetAiRole( HRL_GENERAL );
			//heroes[mainArmyIdx].SetAiAggressivness(HAG_HOSTILE);
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		}

		heroes[mainArmyIdx].SetAiHomeSite( player.GetAiCapitol() );
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

		if( needSecondary ) // we have more than 1 town
		{
			if( isSecondaryHeroPresent && secondaryArmyIdx != mainArmyIdx && secondaryArmyIdx == strongestArmyIdx2 ) // restore previous
			{
				heroes[secondaryArmyIdx].SetAiRole( HRL_SECONDARY );
				//heroes[secondaryArmyIdx].SetAiAggressivness(HAG_HOSTILE);
				heroes[secondaryArmyIdx].SetAiHomeSite( player.GetAiCapitol() );
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				foreach secondaryCandidateIdxs( idx )
				{
					if( idx == secondaryArmyIdx )
					{
						continue;
					}
					heroes[idx].SetAiRole( HRL_SUPPORT );
					//heroes[idx].SetAiAggressivness(HAG_BALANCED);
					heroes[idx].SetAiHomeSite( none );
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				}
			}
			else
			{
				if( secondaryArmyIdx != INDEX_NONE )
				{
					heroes[secondaryArmyIdx].SetAiRole( HRL_SUPPORT );
					//heroes[secondaryArmyIdx].SetAiAggressivness(HAG_BALANCED);
					heroes[secondaryArmyIdx].SetAiHomeSite( none);
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				}

				if( mainArmyIdx != strongestArmyIdx ) // technically should never happen - main should always be strongest
				{
					heroes[strongestArmyIdx].SetAiRole( HRL_SECONDARY );
					//heroes[strongestArmyIdx].SetAiAggressivness(HAG_HOSTILE);
					heroes[strongestArmyIdx].SetAiHomeSite( player.GetAiCapitol() );
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				}
				else if( strongestArmyIdx2 != INDEX_NONE ) // 2nd strongest hero as secondary
				{
					heroes[strongestArmyIdx2].SetAiRole( HRL_SECONDARY );
					//heroes[strongestArmyIdx2].SetAiAggressivness(HAG_HOSTILE);
					heroes[strongestArmyIdx2].SetAiHomeSite( player.GetAiCapitol() );
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

					foreach secondaryCandidateIdxs( idx )
					{
						if( idx == strongestArmyIdx2 || idx == secondaryArmyIdx )
						{
							continue;
						}
						heroes[idx].SetAiRole( HRL_SUPPORT );
						//heroes[idx].SetAiAggressivness( HAG_BALANCED );
						heroes[idx].SetAiHomeSite( none );
						if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
					}
				}
			}
		}
		else
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		}

		foreach aliveHeroes( hero )
		{
			if( hero.GetAiRole() == HRL_MULE )
			{
				
				//muledTowns.AddItem( H7Town( hero.GetAiHomeSite() ) );
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			}
		}
		caravanTargets = player.GetCaravanTargets();

		foreach aliveHeroes( hero )
		{
			if( hero.GetAiRole() != HRL_MAIN && hero.GetAiRole() != HRL_SECONDARY && hero.GetAiRole() != HRL_GENERAL )
			{
				if( caravanTargets.Length > 0 && caravanTargets.Length * 2 > muleCount )
				{
					if( caravanTargets.Find( hero.GetAiHomeSite() ) != INDEX_NONE )
					{
						if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
						// keep it
					}
					else
					{
						hero.SetAiRole( HRL_MULE );
						//hero.SetAiAggressivness(HAG_CONTAINED);
						//hero.SetAiHomeSite( towns[0] );
						++muleCount;
						mules.AddItem( hero );
						//`LOG_AI("-!-Assign role MULE to"@hero.GetName()@"for town"@hero.GetAiHomeSite().GetName());
					}
				}
				else
				{
					if( hero.GetAiRole() != HRL_MULE )
					{
						if( scoutThresholdReached )
						{
							hero.SetAiRole( HRL_SUPPORT );
							//hero.SetAiAggressivness(HAG_BALANCED);
							if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
						}
						else
						{
							if( support_or_scout % 2 == 0 )
							{
								hero.SetAiRole( HRL_SCOUT );
								//hero.SetAiAggressivness(HAG_SHEEP);
								if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
							}
							else
							{
								hero.SetAiRole( HRL_SUPPORT );
								//hero.SetAiAggressivness(HAG_BALANCED);
								if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
							}
							++support_or_scout;
						}
						hero.SetAiHomeSite( none );
					}
				}
			}
		}
		
		foreach mules( hero, i )
		{
			if( caravanTargets.Length > 0 )
			{
				if( caravanTargets.Length > 1 )
				{
					hero.SetAiHomeSite( caravanTargets[ i % 2 ] );
				}
				else
				{
					hero.SetAiHomeSite( caravanTargets[0] );
				}
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			}
			else
			{
				hero.SetAiHomeSite( player.GetAiCapitol() );
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			}
			
		}
	}
}

function SearchReplaceEquipment( H7AdventureHero hero, EItemType itype )
{
	local H7HeroEquipment equip;
	local H7Inventory inventory;
	local H7HeroItem currentItem, inventoryItem, bestItem;
	local float currentItemScore, inventoryItemScore, bestItemScore;
	local array<H7HeroItem> invItems;
	local int inventoryIdx;

	if(hero==None) return;

	equip = hero.GetEquipment();
	inventory = hero.GetInventory();

	if(equip!=None && inventory!=None)
	{
		switch(iType)
		{
			case ITYPE_HELMET: currentItem=equip.GetHelmet(); break;
			case ITYPE_WEAPON: currentItem=equip.GetWeapon(); break;
			case ITYPE_CHEST_ARMOR: currentItem=equip.GetChestArmor(); break;
			case ITYPE_GLOVES: currentItem=equip.GetGloves(); break;
			case ITYPE_SHOES: currentItem=equip.GetShoes(); break;
			case ITYPE_NECKLACE: currentItem=equip.GetNecklace(); break;
			case ITYPE_RING: currentItem=equip.GetRing1(); break;
			case ITYPE_CAPE: currentItem=equip.GetCape(); break;
			default: currentItem=None;
		}

		currentItemScore=0.0f;
		if(currentItem!=None)
		{
			if(hero.IsMightHero()==true)
			{
				currentItemScore=currentItem.GetPowerValueMight();
			}
			else
			{
				currentItemScore=currentItem.GetPowerValueMagic();
			}
		}

		bestItem=currentItem;
		bestItemScore=currentItemScore;

		// search items
		invItems = inventory.GetItems();

		foreach invItems(inventoryItem,inventoryIdx)
		{
			if(inventoryItem.GetType()==itype)
			{
				inventoryItemScore=0.0f;
				if(!inventoryItem.CheckRestricted(hero))
				{
					if(hero.IsMightHero()==true)
					{
						inventoryItemScore=inventoryItem.GetPowerValueMight();
					}
					else
					{
						inventoryItemScore=inventoryItem.GetPowerValueMagic();
					}
				}
				// we have a better than current ?
				if(inventoryItemScore>bestItemScore)
				{
					bestItem=inventoryItem;
					bestItemScore=inventoryItemScore;
				}
			}
		}

		// we found a better replacement for the slot
		if(bestItem!=None && bestItem!=currentItem)
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			if(currentItem!=None)
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				equip.RemoveItem(currentItem);
				inventory.AddItemToInventory(currentItem);
			}
			if(bestItem!=None)
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				equip.SetItem(bestItem);
				inventory.RemoveItem(bestItem);
			}
		}
	}
}

function AutoequipHero( H7AdventureHero hero )
{
	SearchReplaceEquipment(hero,ITYPE_HELMET);
	SearchReplaceEquipment(hero,ITYPE_WEAPON);
	SearchReplaceEquipment(hero,ITYPE_CHEST_ARMOR);
	SearchReplaceEquipment(hero,ITYPE_GLOVES);
	SearchReplaceEquipment(hero,ITYPE_SHOES);
	SearchReplaceEquipment(hero,ITYPE_NECKLACE);
	SearchReplaceEquipment(hero,ITYPE_RING);
	SearchReplaceEquipment(hero,ITYPE_CAPE);
}

function AutoequipHeroes( H7Player player )
{
	local array<H7AdventureHero> heroes;
	local H7AdventureHero hero;

	if(!IsAiEnabled()) return;
//	`LOG_AI("AutoequipHeroes() for player" @ player.GetName() );

	if(player!=none)
	{
		heroes=player.GetHeroes();
		foreach heroes(hero)
		{
//			`LOG_AI("Autoequip Hero" @ hero.GetName() );
			AutoequipHero(hero);
		}
	}	
}

function MergeArmyCreatureStacks( H7Player player )
{
	local array<H7AdventureHero> heroes;
	local array<H7AdventureArmy> armies;
	local H7AdventureHero hero;
	local H7AdventureArmy army;

	if(!IsAiEnabled()) return;
//	`LOG_AI("MergeArmyCreatureStacks() for player" @ player.GetName() );

	if(player!=none)
	{
		// for all heroes running around ...
		heroes=player.GetHeroes();
		foreach heroes(hero)
		{
			army=hero.GetAdventureArmy();
			if(army!=None)
			{
				army.PackStacks();
			}
		}
		// for all garrisoned armies ...
		armies=player.GetArmies();
		foreach armies(army)
		{
			if(army!=None && army.IsGarrisoned()==true)
			{
				army.PackStacks();
			}
		}
	}
}

function UpdateTensionParameters( H7Player player )
{
	local array<H7AdventureHero> heroes;
	local H7AdventureHero hero;
	local H7AdventureArmy army;
	local EHeroAiRole   aiRole;
	local H7AdventureConfiguration advConfig;
	local int k;
	local H7AiActionConfig  actionCfg;
	local H7AiTensionParameter tension;

	if(!IsAiEnabled()) return;
//	`LOG_AI("UpdateTensionParameters() for player" @ player.GetName() );

	advConfig = class'H7AdventureController'.static.GetInstance().GetConfig();

	if(player!=none)
	{
		heroes=player.GetHeroes();
		foreach heroes(hero)
		{
			aiRole=hero.GetAiRole();
			army=hero.GetAdventureArmy();
			if(army!=None)
			{
				for(k=0;k<__AID_MAX;k++)
				{
					switch(k)
					{
						case AID_AttackAoC:         actionCfg=advConfig.mAiAdvMapConfig.mConfigAttackAoC; break;
						case AID_DestroyMine:       actionCfg=advConfig.mAiAdvMapConfig.mConfigDestroyMine; break;
						case AID_AttackArmy:        actionCfg=advConfig.mAiAdvMapConfig.mConfigAttackArmy; break;
						case AID_AttackBorderArmy:  actionCfg=advConfig.mAiAdvMapConfig.mConfigAttackBorderArmy; break;
						case AID_AttackCity:        actionCfg=advConfig.mAiAdvMapConfig.mConfigAttackCity; break;
						case AID_AttackEnemy:       actionCfg=advConfig.mAiAdvMapConfig.mConfigAttackEnemy; break;
						case AID_Plunder:           actionCfg=advConfig.mAiAdvMapConfig.mConfigPlunder; break;
						case AID_Explore:           actionCfg=advConfig.mAiAdvMapConfig.mConfigExplore; break;
						case AID_Repair:            actionCfg=advConfig.mAiAdvMapConfig.mConfigRepair; break;
						case AID_Pickup:            actionCfg=advConfig.mAiAdvMapConfig.mConfigPickup; break;
						case AID_Gather:            actionCfg=advConfig.mAiAdvMapConfig.mConfigGather; break;
						case AID_Guard:             actionCfg=advConfig.mAiAdvMapConfig.mConfigGuarding; break;
						case AID_Reinforce:         actionCfg=advConfig.mAiAdvMapConfig.mConfigReinforce; break;
						case AID_Flee:              actionCfg=advConfig.mAiAdvMapConfig.mConfigFlee; break;
						case AID_Chill:             actionCfg=advConfig.mAiAdvMapConfig.mConfigChill; break;
						case AID_UseSite:           actionCfg=advConfig.mAiAdvMapConfig.mConfigUseSite; break;
						case AID_Congregate:        actionCfg=advConfig.mAiAdvMapConfig.mConfigCongregate; break;
						case AID_UseSiteBoost:      actionCfg=advConfig.mAiAdvMapConfig.mConfigUseSiteBoost; break;
						case AID_UseSiteCommission: actionCfg=advConfig.mAiAdvMapConfig.mConfigUseSiteCommission; break;
						case AID_UseSiteExercise:   actionCfg=advConfig.mAiAdvMapConfig.mConfigUseSiteExercise; break;
						case AID_UseSiteObserve:    actionCfg=advConfig.mAiAdvMapConfig.mConfigUseSiteObserve; break;
						case AID_UseSiteTeleporter: actionCfg=advConfig.mAiAdvMapConfig.mConfigUseSiteTeleporter; break;
						case AID_UseSiteShop:       actionCfg=advConfig.mAiAdvMapConfig.mConfigUseSiteShop; break;
						case AID_UseSiteStudy:      actionCfg=advConfig.mAiAdvMapConfig.mConfigUseSiteStudy; break;
						case AID_UseSiteKeymaster:  actionCfg=advConfig.mAiAdvMapConfig.mConfigUseSiteKeymaster; break;
						case AID_Replenish:         actionCfg=advConfig.mAiAdvMapConfig.mConfigReplenish; break;
						default:					actionCfg=advConfig.mAiAdvMapConfig.mConfigAttackArmy;
					}

					switch(aiRole)
					{
						case HRL_GENERAL:   tension=actionCfg.General.Tension; break;
						case HRL_MAIN:      tension=actionCfg.Main.Tension; break;
						case HRL_SECONDARY: tension=actionCfg.Secondary.Tension; break;
						case HRL_SUPPORT:   tension=actionCfg.Support.Tension; break;
						case HRL_SCOUT:     tension=actionCfg.Scout.Tension; break;
						case HRL_MULE:      tension=actionCfg.Mule.Tension; break;
					}

					army.ModAiTensionValue(EAdvActionID(k),tension);
				}
			}
		}
	}
}

function TickAITimeBetweenThink( float deltaTime )
{
	mTimeSinceLastThink += deltaTime;
}

