//=============================================================================
// H7AiCombatMap
//=============================================================================
// The main entry point for ai processing in a combat map. The 'singelton' is 
// spawned by the CombatController on initialization
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiCombatMap extends Actor
	dependsOn(H7AiCombatSensors);

var protected H7AiCombatSensors     mSensors;

// Ai actions
var protected H7AiActionMoveCreatureStack       mActionMoveCreatureStack;
var protected H7AiActionAttackCreatureStack     mActionAttackCreatureStack;
var protected H7AiActionAttackHero              mActionAttackHero;
var protected H7AiActionWaitHero                mActionWaitHero;
var protected H7AiActionWaitCreature            mActionWaitCreature;
var protected H7AiActionRangeAttackCreatureStack    mActionRangeAttackCreatureStack;
var protected H7AiActionMoveAttackCreatureStack mActionMoveAttackCreatureStack;
var protected H7AiActionCastSpellHero           mActionCastSpellHero;
var protected H7AiActionDefend                  mActionDefend;
var protected H7AiActionUseAbilityCreature      mActionUseAbilityCreature;
var protected float                             mDeferTimer;
var protected int                               mThinkStep;
var protected array<AiActionScore>              mScores;

function H7AiCombatSensors GetSensors() { return mSensors; }

function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	mSensors = new class 'H7AiCombatSensors';
	mSensors.Setup();

	// actions
	mActionMoveCreatureStack = new class'H7AiActionMoveCreatureStack';
	mActionMoveCreatureStack.Setup();
	mActionAttackCreatureStack = new class'H7AiActionAttackCreatureStack';
	mActionAttackCreatureStack.Setup();
	mActionRangeAttackCreatureStack = new class'H7AiActionRangeAttackCreatureStack';
	mActionRangeAttackCreatureStack.Setup();
	mActionMoveAttackCreatureStack = new class'H7AiActionMoveAttackCreatureStack';
	mActionMoveAttackCreatureStack.Setup();
	mActionAttackHero = new class'H7AiActionAttackHero';
	mActionAttackHero.Setup();
	mActionWaitHero = new class'H7AiActionWaitHero';
	mActionWaitHero.Setup();
	mActionWaitCreature = new class'H7AiActionWaitCreature';
	mActionWaitCreature.Setup();
	mActionCastSpellHero = new class'H7AiActionCastSpellHero';
	mActionCastSpellHero.Setup();
	mActionUseAbilityCreature = new class'H7AiActionUseAbilityCreature';
	mActionUseAbilityCreature.Setup();
	mActionDefend = new class'H7AiActionDefend';
	mActionDefend.Setup();

}

delegate int ScoreSort(AiActionScore A, AiActionScore B) { return A.score < B.score ? -1 : 0; }

function DeferExecution( float seconds )
{
	mDeferTimer = seconds;
}

function ResetThink()
{
	mDeferTimer = 0.05f;
	mThinkStep = 0;
	mScores.Remove(0,mScores.Length);
}

function Think( H7Unit unit, float deltaTime )
{
	local int i,idx;
	local bool action_done,useHealAbility;
	local H7CombatMapGridController grid_ctrl;
	local array<H7CreatureStack> targetStacks,filterUnits;
	local H7CreatureStack targetUnit;
	local H7CombatObstacleObject obstacle;
	local array<H7CombatObstacleObject> obstacles;
	local array<H7IEffectTargetable> targetables, secondPrioTargets;
	local H7IEffectTargetable targetable;

	if( unit == None ) return;

	if( mDeferTimer  < 0.0f ) return;
	mDeferTimer -= deltaTime;
	if( mDeferTimer >= 0.0f ) return;

	grid_ctrl = class'H7CombatMapGridController'.static.GetInstance();

	if( mThinkStep == 0 )
	{ 
		grid_ctrl.RefreshThreatMap();
		grid_ctrl.RecalculateReachableCells();

		mSensors.UpdateConsts();

		mThinkStep = 1;
		mDeferTimer = 0.05f;
		mScores.Remove(0,mScores.Length);
		return;
	}
	
	if( unit.GetEntityType() == UNIT_CREATURESTACK )
	{
		if( mThinkStep == 1 )
		{
			mActionMoveCreatureStack.RunScores(mSensors,unit,mScores);
			mThinkStep = 2;
			mDeferTimer = 0.005f;
			return;
		}
		if( mThinkStep == 2 )
		{
			mActionAttackCreatureStack.RunScores(mSensors,unit,mScores);
			mThinkStep = 3;
			mDeferTimer = 0.005f;
			return;
		}
		if( mThinkStep == 3 )
		{
			mActionRangeAttackCreatureStack.RunScores(mSensors,unit,mScores);
			mThinkStep = 4;
			mDeferTimer = 0.005f;
			return;
		}
		if( mThinkStep == 4 )
		{
			mActionMoveAttackCreatureStack.RunScores(mSensors,unit,mScores);
			mThinkStep = 5;
			mDeferTimer = 0.005f;
			return;
		}
		if( mThinkStep == 5 )
		{
			mActionUseAbilityCreature.RunScores(mSensors,unit,mScores);
			mThinkStep = 6;
			mDeferTimer = 0.005f;
			return;
		}
		if( mThinkStep == 6 )
		{
			mActionDefend.RunScores(mSensors,unit,mScores);
			mThinkStep = 7;
			mDeferTimer = 0.005f;
			return;
		}
		if( mThinkStep == 7 )
		{
			mActionWaitCreature.RunScores(mSensors,unit,mScores);
			mThinkStep = 8;
			mDeferTimer = 0.005f;
			return;
		}

		if( mThinkStep == 8 )
		{
			mScores.Sort(ScoreSort);
			mThinkStep = 99;
			mDeferTimer = 0.005f;
			return;
		}

		if( mScores.Length >= 1 )
		{
			action_done = mScores[0].action.PerformAction(unit,mScores[0]);
			if( action_done == false )
			{
				if(unit.GetAbilityManager().GetAbility( unit.GetWaitAbility() ).CanCast()==true)
				{
					unit.Wait();
				}
				else
				{
					unit.Defend();
				}
			}
		}
		else
		{
			if(unit.GetAbilityManager().GetAbility( unit.GetWaitAbility() ).CanCast()==true)
			{
				unit.Wait();
			}
			else
			{
				unit.Defend();
			}
		}

		mSensors.ResetConsts();
		mThinkStep = 0;
	}
	else if( unit.GetEntityType() == UNIT_HERO )
	{
		if( mThinkStep == 1 )
		{
			if( !unit.IsWaiting() )
			{
				mActionWaitHero.RunScores(mSensors,unit,mScores);
			}
			mThinkStep = 2;
			mDeferTimer = 0.005f;
			return;
		}
		if( mThinkStep == 2 )
		{
			mActionAttackHero.RunScores(mSensors,unit,mScores);
			mThinkStep = 3;
			mDeferTimer = 0.005f;
			mActionCastSpellHero.Dubstep=0;
			return;
		}
		if( mThinkStep == 3 )
		{
			mActionCastSpellHero.RunScores(mSensors,unit,mScores);
			if(mActionCastSpellHero.Dubstep==-1)
			{
				mThinkStep = 4;
			}
			mDeferTimer = 0.005f;
			return;
		}

		if( mThinkStep == 4 )
		{
			mScores.Sort(ScoreSort);
			mThinkStep = 99;
			mDeferTimer = 0.005f;
			return;
		}

		if(mScores.Length>=1)
		{
			//idx = Rand(Min(mScores.Length,3));
			idx = Rand(Max(mScores.Length-1,1));

			action_done = mScores[idx].action.PerformAction(unit,mScores[idx]);
			if( action_done == false )
			{
				targetStacks = class'H7CombatController'.static.GetInstance().GetOpponentArmy( unit.GetCombatArmy() ).GetCreatureStacks();
				if( unit.IsRanged() )
				{
					unit.PrepareAbility( unit.GetRangedAttackAbility() );
				}
				else
				{
					unit.PrepareAbility( unit.GetMeleeAttackAbility() );
				}
				targetUnit = GetRandomCreatureStack( targetStacks );
				unit.GetPreparedAbility().SetTarget( targetUnit );
				class'H7CombatController'.static.GetInstance().SetActiveUnitCommand_UsePreparedAbility( targetUnit.GetCell() );
				
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				unit.Wait();
			}
		}
		else
		{
			targetStacks = class'H7CombatController'.static.GetInstance().GetOpponentArmy( unit.GetCombatArmy() ).GetCreatureStacks();
			if( unit.IsRanged() )
			{
				unit.PrepareAbility( unit.GetRangedAttackAbility() );
			}
			else
			{
				unit.PrepareAbility( unit.GetMeleeAttackAbility() );
			}
			targetUnit = GetRandomCreatureStack( targetStacks );
			unit.GetPreparedAbility().SetTarget( targetUnit );
			class'H7CombatController'.static.GetInstance().SetActiveUnitCommand_UsePreparedAbility( targetUnit.GetCell() );
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			unit.Wait();
		}

		mSensors.ResetConsts();
		mThinkStep = 0;
	}
	else if( unit.GetEntityType() == UNIT_WARUNIT )
	{
		// Prio Attack !!! 
		if( H7WarUnit( unit ).GetRangedAttackAbility() != none && H7WarUnit( unit ).GetAbilityManager().GetAbility( H7WarUnit( unit ).GetRangedAttackAbility() ).CanCast() ) 
		{
			
			if( H7WarUnit( unit ).GetWarUnitClass() == WCLASS_SIEGE )
			{
				obstacles = class'H7CombatMapGridController'.static.GetInstance().GetObstacles();

				// collect all possible targets
				foreach obstacles( obstacle )
				{
					if( obstacle.IsSiegeMachineTarget() && obstacle.GetLevel() != OL_DESTROYED && obstacle.IsDestructible() )
					{
						if( H7CombatMapWall(obstacle) != none || H7CombatMapGate( obstacle ) != none ) 
						{
							targetables.AddItem( obstacle );
						}
						else if ( H7CombatMapTower( obstacle) != none  )
						{
							secondPrioTargets.AddItem( obstacle );
						}
					}
				}
				// siege AI tries then to shoot at Towers
				if( targetables.Length == 0 ) 
				{
					targetables = secondPrioTargets;
				}
			}
			else 
			{
				targetables = unit.GetAbilityManager().GetAbility(  H7WarUnit( unit ).GetRangedAttackAbility() ).AICalculateAllPossibleTargets();
			}
			// support Unit also uses the RanagedAttackAbility of a WU, ( Designers choice ) 
			if (  unit.GetAbilityManager().GetAbility(H7WarUnit( unit ).GetRangedAttackAbility()).HasTag( TAG_HEAL )      ||
				  unit.GetAbilityManager().GetAbility(H7WarUnit( unit ).GetRangedAttackAbility()).HasTag( TAG_REPAIR )    || 
				  unit.GetAbilityManager().GetAbility(H7WarUnit( unit ).GetRangedAttackAbility()).HasTag( TAG_RESURRECT ) )
			{
				useHealAbility = true;

				foreach targetables( targetable ) 
				{
					if (targetable.isA('H7CreatureStack') &&  H7CreatureStack(targetable).GetTopCreatureHealth() < H7CreatureStack(targetable).GetHitPoints() )
					{
						filterUnits.AddItem( H7CreatureStack(targetable) );
					} 
				}

			}

			// no targets found
			if( targetables.Length > 0 )
			{
				// remove yourself, can happen because of Counter (Effect) target yourself 
				if (targetables.Find( unit ) != -1 )
				{
					targetables.RemoveItem( unit);
				}
				// found one so prepare yourself
				unit.PrepareAbility(  H7WarUnit( unit ).GetRangedAttackAbility() );
			}
		} 
		// this more or less only happens for Hybrid WUs
		else if ( H7WarUnit( unit ).GetSupportAbility() != none && unit.GetAbilityManager().GetAbility( H7WarUnit( unit ).GetSupportAbility() ).CanCast() )
		{
			targetables = unit.GetAbilityManager().GetAbility( H7WarUnit( unit ).GetSupportAbility()).AICalculateAllPossibleTargets();
					
			if (  unit.GetAbilityManager().GetAbility(H7WarUnit( unit ).GetSupportAbility()).HasTag( TAG_HEAL )      ||
				  unit.GetAbilityManager().GetAbility(H7WarUnit( unit ).GetSupportAbility()).HasTag( TAG_REPAIR )    || 
				  unit.GetAbilityManager().GetAbility(H7WarUnit( unit ).GetSupportAbility()).HasTag( TAG_RESURRECT ) )
						
			{
				useHealAbility = true;

				foreach targetables( targetable ) 
				{
					if (targetable.isA('H7CreatureStack') &&  H7CreatureStack(targetable).GetTopCreatureHealth() < H7CreatureStack(targetable).GetHitPoints() )
					{
						filterUnits.AddItem( H7CreatureStack(targetable) );
					} 
				}

			}
				
			if( targetables.Length > 0 )
			{
				// remove yourself, can happen because of Counter (Effect) target yourself 
				if (targetables.Find( unit ) != -1  )
				{
					targetables.RemoveItem( unit );
				}

				// found one so prepare yourself
				unit.PrepareAbility(  H7WarUnit( unit ).GetSupportAbility() );
			}
		}
		// we want to Wait or Skip if there are no targets
		if ( targetables.Length <= 0 || ( useHealAbility && filterUnits.Length <= 0 ))
		{
			if( unit.IsWaitTurn() || class'H7CombatController'.static.GetInstance().GetInitiativeQueue().IsLast(unit) )
			{
				unit.PrepareAbility(  H7WarUnit( unit ).GetSkipAbility() );
			}
			else 
			{
				unit.PrepareAbility(  H7WarUnit( unit ).GetWaitAbility() );
			}
		}
		else
		{  	if ( useHealAbility )
			{
				targetable = filterUnits[ FRand() * ( filterUnits.Length - 1 ) ];
			}
			else 
			{
				targetable = targetables[ FRand() * ( targetables.Length - 1 ) ];
			}

		}
				
		class'H7CombatController'.static.GetInstance().SetActiveUnitCommand_UsePreparedAbility( targetable );

		mSensors.ResetConsts();
		mThinkStep = 0;
	}
	else if( unit.GetEntityType() == UNIT_TOWER )
	{
		targetStacks = class'H7CombatController'.static.GetInstance().GetOpponentArmy( unit.GetCombatArmy() ).GetCreatureStacks();

		unit.PrepareAbility( unit.GetRangedAttackAbility() );
		
		targetUnit = GetRandomCreatureStack( targetStacks );

		class'H7CombatController'.static.GetInstance().SetActiveUnitCommand_UsePreparedAbility( targetUnit );

		mSensors.ResetConsts();
		mThinkStep = 0;
	}
	else
	{
		unit.Think();

		mSensors.ResetConsts();
		mThinkStep = 0;
	}

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	for(i=0;i<Min(mScores.Length,15);i++)
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	}

	mSensors.ResetConsts();
}

protected function H7CreatureStack GetRandomCreatureStack( array<H7CreatureStack> creatureStacks )
{
	local array<H7CreatureStack> cleanCreatureStacks;
	local H7CreatureStack currentCreatureStack;

	foreach creatureStacks( currentCreatureStack )
	{
		if( !currentCreatureStack.IsDead() )
		{
			cleanCreatureStacks.AddItem( currentCreatureStack );
		}
	}

	return cleanCreatureStacks[ FRand() * ( cleanCreatureStacks.Length - 1 ) ];
}

