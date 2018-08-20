//=============================================================================
// H7AiCombatMap
//=============================================================================
// The main entry point for ai processing in a combat map. The 'singelton' is 
// spawned by the CombatController on initialization
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class AIModH7AiCombatMap extends Actor
	dependsOn(H7AiCombatSensors);

var protected H7AiCombatSensors     mSensors;

// Ai actions
var protected H7AiActionMoveCreatureStack       mActionMoveCreatureStack;
var protected H7AiActionMoveRune                mActionMoveRune;
var protected H7AiActionAttackCreatureStack     mActionAttackCreatureStack;
var protected H7AiActionAttackHero              mActionAttackHero;
var protected H7AiActionWaitHero                mActionWaitHero;
var protected H7AiActionWaitCreature            mActionWaitCreature;
var protected H7AiActionRangeAttackCreatureStack    mActionRangeAttackCreatureStack;
var protected H7AiActionMoveAttackCreatureStack mActionMoveAttackCreatureStack;
var protected H7AiActionActivateRune            mActionActivateRune;
var protected H7AiActionCastSpellHero           mActionCastSpellHero;
var protected H7AiActionDefend                  mActionDefend;
var protected H7AiActionUseAbilityCreature      mActionUseAbilityCreature;
var protected H7AiActionFleeSurrenderCombat     mActionFleeSurrenderCombat;
var protected float                             mDeferTimer;
var protected int                               mThinkStep;
var protected int                               mDubStep;
var protected array<H7AiSpellEvaluation>        mEvaluations;
var protected array<AiActionScore>              mScores;

var protected int                               mOptimalCalcIndex;
var protected H7IEffectTargetable               mOptimalBestTarget;
var protected float                             mOptimalBestDamage;
var protected bool                              mOptimalBestDone;


var protected array<H7AiCombatInstruction>      mInstructions;

function H7AiCombatSensors GetSensors() { return mSensors; }

function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	mSensors = new class 'H7AiCombatSensors';
	mSensors.Setup();

	// actions
	mActionMoveCreatureStack = new class'H7AiActionMoveCreatureStack';
	mActionMoveCreatureStack.Setup();
	mActionMoveRune = new class'H7AiActionMoveRune';
	mActionMoveRune.Setup();
	mActionAttackCreatureStack = new class'H7AiActionAttackCreatureStack';
	mActionAttackCreatureStack.Setup();
	mActionRangeAttackCreatureStack = new class'H7AiActionRangeAttackCreatureStack';
	mActionRangeAttackCreatureStack.Setup();
	mActionMoveAttackCreatureStack = new class'H7AiActionMoveAttackCreatureStack';
	mActionMoveAttackCreatureStack.Setup();
	mActionActivateRune = new class'H7AiActionActivateRune';
	mActionActivateRune.Setup();
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
	mActionFleeSurrenderCombat = new class'H7AiActionFleeSurrenderCombat';
	mActionFleeSurrenderCombat.Setup();
}

delegate int ScoreSort(AiActionScore A, AiActionScore B) 
{ 
	return A.score < B.score ? -1 : 0; 
}

function DeferExecution( float seconds )
{
	mDeferTimer = seconds;
}

function ResetThink()
{
	mDeferTimer = 0.000001f;
	mThinkStep = 0;
	mScores.Remove(0,mScores.Length);
}



//function H7AiCombatInstruction ThinkBig( H7Unit currentUnit )
//{
//	local H7CombatArmy myArmy, opponentArmy;
//	local H7CombatController combatController;
//	local array<H7CreatureStack> opponentStacks, myStacks, opponentRangedStacks, opponentRangedStacksUnsuppressed, opponentMeleeStacks, opponentChosenSuppressionStacks, myRangedStacks, potentialSuppressors;
//	local H7CreatureStack stack, dangerStack, opponentStack, defenderStack;
//	local float highestDamagePotential, damagePotential;
//	local H7CombatResult result;
//	local array<H7IEffectTargetable> defenders;
//	local int i, diff, totalKills, topCHealth, resultSize;
//	local float damageTotal;
//	local array<H7CombatMapCell> path, reachableCells, cells;
//	local float pathCost;
//	local array<H7AiCombatInstructionEvaluation> evaluations, deadliestEvaluations;
//	local H7AiCombatInstructionEvaluation evaluation, deadliestEvaluation, backupDeadliestEvaluation;
//	local H7CombatMapCell attackHitCell, cell, safestCell;
//	local H7AiCombatInstruction instruction;
//	local EDirection dir;
//	local bool foundAssaultInstruction;

//	potentialSuppressors = potentialSuppressors;
//	path = path;
//	pathCost = pathCost;
//	myRangedStacks = myRangedStacks;

//	if( currentUnit.GetEntityType() != UNIT_CREATURESTACK )
//	{
//		return instruction;
//	}

//	combatController = class'H7CombatController'.static.GetInstance();

//	myArmy = combatController.GetActiveArmy();
//	opponentArmy = combatController.GetOpponentArmy( myArmy );
	
//	opponentArmy.GetSurvivingCreatureStacks( opponentStacks );

//	foreach opponentStacks( opponentStack )
//	{
//		damagePotential = opponentStack.GetDamagePotential( opponentStack.GetStackSize() );
//		if( damagePotential > highestDamagePotential )
//		{
//			highestDamagePotential = damagePotential;
//			dangerStack = opponentStack;
//		}
//		if( opponentStack.IsRanged() )
//		{
//			opponentRangedStacks.AddItem( opponentStack );
//			if( opponentStack.CanRangeAttack() )
//			{
//				opponentRangedStacksUnsuppressed.AddItem( opponentStack );
//			}
//		}
//		else
//		{
//			opponentMeleeStacks.AddItem( opponentStack );
//		}
	
//		`LOG_AI("I spy with my little eye"@opponentStack.GetStackSize()@opponentStack.GetName());
//	}
//	`LOG_AI("The most dangerous stack is"@dangerStack.GetName());

//	myArmy.GetSurvivingCreatureStacks( myStacks );

//	foreach myStacks( stack )
//	{
//		if( stack.IsRanged() && stack.CanRangeAttack() )
//		{
//			myRangedStacks.AddItem( stack );
//		}
//	}

//	foreach myStacks( stack )
//	{
//		evaluation.Subordinate = stack;
//		if( !stack.IsRanged() )
//		{
//			stack.GetPathfinder().SetIgnoreCreaturePassability( true );
//		}
//		`LOG_AI("My stack of"@stack.GetStackSize()@stack.GetName()@"have a toughness value of"@stack.GetToughness()@"and damage potential of"@stack.GetDamagePotential());
//		foreach opponentStacks( opponentStack )
//		{
//			stack.PrepareDefaultAbility();
//			attackHitCell = none;
//			dir = stack.IsRanged() ? EDirection_MAX : class'H7AiActionMoveAttackCreatureStack'.static.GetBestDirectionToAttack( stack, opponentStack, attackHitCell );
//			result = stack.GetPreparedAbility().Activate( opponentStack, true, dir );
//			defenders = result.GetDefenders();
//			damageTotal = 0;
//			totalKills = 0;

//			for( i = 0; i < defenders.Length; ++i )
//			{
//				defenderStack = H7CreatureStack( defenders[i] );
//				if( defenderStack == none )
//				{
//					continue;
//				}
				
//				result.GetDamage( i );
//				defenderStack.GetDamageResult( result.GetDamageHigh( i ), result.DidMiss( i ), topCHealth, resultSize );

//				diff = defenderStack.GetStackSize() - resultSize;
//				totalKills += diff;
//				if( diff > 0 )
//				{
//					damageTotal += defenderStack.GetDamagePotential( diff );
//					damageTotal += defenderStack.GetDamagePotential( 1 ) * ( 1.0f - float( topCHealth ) / float( defenderStack.GetHitPoints() ) ); //fractions count, too
//				}
//				else
//				{
//					damageTotal += defenderStack.GetDamagePotential( 1 ) * ( 1.0f - float( defenderStack.GetTopCreatureHealth() - topCHealth ) / float( defenderStack.GetHitPoints() ) ); //fractions count, too
//				}
//			}
//			evaluation.KillCount = diff;
//			evaluation.DamagePotentialReduction = damageTotal;
//			evaluation.Target = opponentStack;
//			evaluation.TurnsToReach = FCeil(pathCost/float(stack.GetMovementPoints()));
//			evaluation.SubordinateIniQueuePosition = combatController.GetInitiativeQueue().GetIndexForUnit( stack );
//			evaluation.TargetActsAfterSubordinate = combatController.GetInitiativeQueue().GetIndexForUnit( stack ) < combatController.GetInitiativeQueue().GetIndexForUnit( opponentStack );
//			evaluation.HitCell = attackHitCell;
//			evaluation.Path = path;
//			evaluation.AttackDir = dir;
//			`LOG_AI("If"@stack.GetStackSize()@stack.GetName()@"would attack"@opponentStack.GetStackSize()@opponentStack.GetName()@"then they would inflict"@damageTotal@"damage potential loss to the enemy and kill"@totalKills@"units in total."@stack.IsRanged() ? ("Stack is ranged.") : ("It would take"@pathCost@"movepoints or"@FCeil(pathCost/float(stack.GetMovementPoints()))@"turns to reach.")@"My queue position is"@evaluation.SubordinateIniQueuePosition);
//			evaluations.AddItem( evaluation );
//		}

//		if( !stack.IsRanged() )
//		{
//			stack.GetPathfinder().SetIgnoreCreaturePassability( false );
//		}
//	}


//	foreach opponentStacks( opponentStack )
//	{
//		if( opponentStack.IsRanged() )
//		{
//			instruction.InstructionType = CIT_ENGAGE;
//			foreach myStacks( stack )
//			{
//				if( !stack.IsRanged() )
//				{
//					combatController.GetGridController().GetCombatGrid().GetAllAttackPositionsAgainst( opponentStack, stack, cells );
//					if( cells.Length > 0 )
//					{
//						potentialSuppressors.AddItem( stack );
//						//continue;
//					}
//				}
//			}
//		}
//	}

//	foreach myStacks( stack )
//	{
//		deadliestEvaluation.DamagePotentialReduction = INDEX_NONE; // reset
//		deadliestEvaluation.TargetActsAfterSubordinate = false; // reset
//		foundAssaultInstruction = false;
//		foreach evaluations( evaluation )
//		{
//			if( evaluation.Subordinate == stack && 
//				evaluation.DamagePotentialReduction > deadliestEvaluation.DamagePotentialReduction )
//			{
//				if( !evaluation.Subordinate.IsRanged() )
//				{
//					combatController.GetGridController().GetCombatGrid().GetAllAttackPositionsAgainst( evaluation.Target, evaluation.Subordinate, cells );
//					if( cells.Length == 0 )
//					{
//						continue;
//					}
//				}
//				if( opponentChosenSuppressionStacks.Find( evaluation.Target ) != INDEX_NONE && !stack.IsRanged() )
//				{
//					//continue;
//				}

//				if( evaluation.TargetActsAfterSubordinate )
//				{
//					deadliestEvaluation = evaluation;
//				}
//				else
//				{
//					backupDeadliestEvaluation = evaluation;
//				}
//				foundAssaultInstruction = true;
//			}
//		}

//		if( deadliestEvaluation.DamagePotentialReduction == INDEX_NONE )
//		{
//			`LOG_AI("BACKUP: My stack of"@backupDeadliestEvaluation.Subordinate.GetStackSize()@backupDeadliestEvaluation.Subordinate.GetName()@"should try to attack"@backupDeadliestEvaluation.Target.GetName()@"for"@backupDeadliestEvaluation.DamagePotentialReduction@"damage potential reduction in"@backupDeadliestEvaluation.TurnsToReach@"turns.");
//			deadliestEvaluations.AddItem( backupDeadliestEvaluation );
//		}
//		else
//		{
//			`LOG_AI("My stack of"@deadliestEvaluation.Subordinate.GetStackSize()@deadliestEvaluation.Subordinate.GetName()@"should try to attack"@deadliestEvaluation.Target.GetName()@"for"@deadliestEvaluation.DamagePotentialReduction@"damage potential reduction in"@deadliestEvaluation.TurnsToReach@"turns.");
//			deadliestEvaluations.AddItem( deadliestEvaluation );
//		}

//		if( !deadliestEvaluations[deadliestEvaluations.Length-1].Subordinate.IsRanged() )
//		{
//			opponentChosenSuppressionStacks.AddItem( deadliestEvaluations[deadliestEvaluations.Length-1].Target );
//		}

//		if( stack == currentUnit )
//		{
//			if( foundAssaultInstruction && ( deadliestEvaluations[deadliestEvaluations.Length-1].TurnsToReach == 1 || stack.IsRanged() ) )
//			{
//				instruction.InstructionType = CIT_ASSAULT;
//				instruction.Evaluation = deadliestEvaluations[deadliestEvaluations.Length-1];
//			}
//			else
//			{
//				instruction.InstructionType = CIT_ENGAGE;
//				instruction.Evaluation = deadliestEvaluations[deadliestEvaluations.Length-1];

//				FlushPersistentDebugLines();
//				instruction.Evaluation.Subordinate.GetPathfinder().GetReachableCells( instruction.Evaluation.Subordinate.GetMovementPoints(), reachableCells );
				
//				safestCell = none;
//				foreach reachableCells( cell )
//				{
//					if( safestCell == none || safestCell.GetOpportunity() < cell.GetOpportunity() )
//						//VSize( safestCell.GetOriginalLocation() - instruction.Evaluation.Target.GetCell().GetOriginalLocation() ) > VSize( cell.GetOriginalLocation() - instruction.Evaluation.Target.GetCell().GetOriginalLocation() ) )
//					{
//						safestCell = cell;
//					}
//					DrawDebugSphere( cell.GetOriginalLocation(), 100, 6, 0, 0, 255 * cell.GetThreat(), true );
//					`LOG_AI("cell thing"@cell.GetThreat()@cell.GetName());
//				}
//				DrawDebugSphere( safestCell.GetOriginalLocation(), 100, 6, 255, 0, 0, true );
//				instruction.Evaluation.HitCell = safestCell;
//			}
//		}
//		`LOG_AI("Instructing"@instruction.Evaluation.Subordinate.GetName()@"to"@instruction.InstructionType@"enemy"@instruction.Evaluation.Target.GetName()@reachableCells.Length);
//	}

//	//foreach opponentRangedStacks( stack )
//	//{
//	//	deadliestEvaluation.DamagePotentialReduction = INDEX_NONE; // reset
//	//	deadliestEvaluation.TargetActsAfterSubordinate = false; // reset
//	//	foreach evaluations( evaluation )
//	//	{
//	//		if( evaluation.Target == stack && 
//	//			evaluation.TurnsToReach < deadliestEvaluation.TurnsToReach )
//	//		{
//	//			if( opponentChosenSuppressionStacks.Find( evaluation.Target ) != INDEX_NONE && !evaluation.Subordinate.IsRanged() )
//	//			{
//	//				continue;
//	//			}

//	//			if( evaluation.TargetActsAfterSubordinate )
//	//			{
//	//				deadliestEvaluation = evaluation;
//	//			}
//	//			else
//	//			{
//	//				backupDeadliestEvaluation = evaluation;
//	//			}
//	//		}
//	//	}
//	//	if( deadliestEvaluation.DamagePotentialReduction == INDEX_NONE )
//	//	{
//	//		`LOG_AI("BACKUP: My stack of"@backupDeadliestEvaluation.Subordinate.GetStackSize()@backupDeadliestEvaluation.Subordinate.GetName()@"should try to attack"@backupDeadliestEvaluation.Target.GetName()@"for"@backupDeadliestEvaluation.DamagePotentialReduction@"damage potential reduction in"@backupDeadliestEvaluation.TurnsToReach@"turns.");
//	//		deadliestEvaluations.AddItem( backupDeadliestEvaluation );
//	//	}
//	//	else
//	//	{
//	//		`LOG_AI("My stack of"@deadliestEvaluation.Subordinate.GetStackSize()@deadliestEvaluation.Subordinate.GetName()@"should try to attack"@deadliestEvaluation.Target.GetName()@"for"@deadliestEvaluation.DamagePotentialReduction@"damage potential reduction in"@deadliestEvaluation.TurnsToReach@"turns.");
//	//		deadliestEvaluations.AddItem( deadliestEvaluation );
//	//	}

//	//	if( !deadliestEvaluations[deadliestEvaluations.Length-1].Subordinate.IsRanged() )
//	//	{
//	//		opponentChosenSuppressionStacks.AddItem( deadliestEvaluations[deadliestEvaluations.Length-1].Target );
//	//	}
//	//}

//	opponentRangedStacks = opponentRangedStacks;
//	opponentRangedStacksUnsuppressed = opponentRangedStacksUnsuppressed;
//	opponentMeleeStacks = opponentMeleeStacks;
//	evaluations = evaluations;
//	evaluation = evaluation;
//	damageTotal = damageTotal;
//	totalKills = totalKills;
//	dangerStack = dangerStack;
//	backupDeadliestEvaluation = backupDeadliestEvaluation;
//	deadliestEvaluation = deadliestEvaluation;
//	deadliestEvaluations = deadliestEvaluations;

//	return instruction;
//}

function ThinkBig( H7Unit currentUnit )
{
	local H7CombatController combatController;
	local array<H7CreatureStack> opponentStacks, myStacks, opponentRangedStacks, opponentRangedStacksUnsuppressed, opponentMeleeStacks, myRangedStacks, potentialSuppressors;
	local H7CreatureStack stack, dangerStack, opponentStack, defenderStack;
	local H7CombatResult result;
	local array<H7IEffectTargetable> defenders;
	local int i, diff, totalKills, topCHealth, resultSize;
	local float damageTotal, toughnessTotal;
	local array<H7CombatMapCell> path, cells;
	local float pathCost;
	local array<H7AiCombatInstructionEvaluation> evaluations, deadliestEvaluations, movementEvaluations, suppressEvaluations;
	local H7AiCombatInstructionEvaluation evaluation, deadliestEvaluation, backupDeadliestEvaluation;
	local H7CombatMapCell attackHitCell, cell, mostOpportuneCell;
	local H7AiCombatInstruction instruction;
	local array<H7AiCombatInstruction> instructions;
	local EDirection dir;
	local bool isGoodTimeToWait;

	local float stackDanger;
	local array<H7CreatureStack> mostDangerousStacks;
	local H7CreatureStack mostDangerousStack;

	potentialSuppressors = potentialSuppressors;
	path = path;
	pathCost = pathCost;
	myRangedStacks = myRangedStacks;
	opponentRangedStacks = opponentRangedStacks;
	opponentRangedStacksUnsuppressed = opponentRangedStacksUnsuppressed;
	opponentMeleeStacks = opponentMeleeStacks;
	evaluations = evaluations;
	evaluation = evaluation;
	damageTotal = damageTotal;
	toughnessTotal = toughnessTotal;
	totalKills = totalKills;
	dangerStack = dangerStack;
	backupDeadliestEvaluation = backupDeadliestEvaluation;
	deadliestEvaluation = deadliestEvaluation;
	deadliestEvaluations = deadliestEvaluations;
	suppressEvaluations = suppressEvaluations;
	mostDangerousStack = mostDangerousStack;
	mostDangerousStacks = mostDangerousStacks;

	combatController = class'H7CombatController'.static.GetInstance();

	currentUnit.GetCombatArmy().GetSurvivingCreatureStacks( myStacks );
	combatController.GetOpponentArmy( currentUnit.GetCombatArmy() ).GetSurvivingCreatureStacks( opponentStacks );

	foreach opponentStacks( opponentStack )
	{
		if( opponentStack.GetDamagePotential() + opponentStack.GetToughness() > stackDanger )
		{
			stackDanger = opponentStack.GetDamagePotential() + opponentStack.GetToughness();
			if( stackDanger > combatController.GetOpponentArmy( currentUnit.GetCombatArmy() ).GetArmyDamagePool() * 0.15f )
			{
				mostDangerousStacks.AddItem( opponentStack );
			}
			mostDangerousStack = opponentStack;
		}
	}


	//FlushPersistentDebugLines();
	foreach myStacks( stack )
	{
		if( !stack.IsRanged() )
		{
			stack.GetPathfinder().GetReachableCells( stack.GetMovementPoints(), cells );
			mostOpportuneCell = none;
			//foreach cells( cell )
			//{
			//	if( mostOpportuneCell == none || mostOpportuneCell.GetOpportunity() < cell.GetOpportunity() )
			//	{
			//		mostOpportuneCell = cell;
			//	}
			//}
			foreach cells( cell )
			{
				if( mostOpportuneCell == none || mostOpportuneCell.GetRelevance() < cell.GetRelevance() )
				{
					mostOpportuneCell = cell;
				}
			}
			stack.GetPathfinder().GetPath( mostOpportuneCell.GetGridPosition(), path );

			evaluation.AttackDir = EDirection_MAX;
			evaluation.DamagePotentialReduction = 0;
			evaluation.HitCell = mostOpportuneCell;
			evaluation.KillCount = 0;
			evaluation.Path = path;
			evaluation.Subordinate = stack;
			evaluation.Target = none;
			evaluation.TargetActsAfterSubordinate = true;
			evaluation.TurnsToReach = 1;
			movementEvaluations.AddItem( evaluation );
		}

		foreach opponentStacks( opponentStack )
		{
			if( !stack.IsRanged() || stack.IsRanged() && !stack.CanRangeAttack() )
			{
				combatController.GetGridController().GetCombatGrid().GetAllAttackPositionsAgainst( opponentStack, stack, cells );
			}

			if( cells.Length > 0 || stack.IsRanged() && stack.CanRangeAttack() ) 
			{
				stack.PrepareDefaultAbility();
				attackHitCell = none;
				dir = stack.IsRanged() ? EDirection_MAX : class'H7AiActionMoveAttackCreatureStack'.static.GetBestDirectionToAttack( stack, opponentStack, attackHitCell );
				result = stack.GetPreparedAbility().Activate( opponentStack, true, dir );
				defenders = result.GetDefenders();
				damageTotal = 0;
				toughnessTotal = 0;
				totalKills = 0;

				for( i = 0; i < defenders.Length; ++i )
				{
					defenderStack = H7CreatureStack( defenders[i] );
					if( defenderStack == none )
					{
						continue;
					}
				
					result.GetDamage( i );
					defenderStack.GetDamageResult( result.GetDamageHigh( i ), result.DidMiss( i ), topCHealth, resultSize );

					diff = defenderStack.GetStackSize() - resultSize;
					totalKills += diff;
					if( diff > 0 )
					{
						damageTotal += ( defenderStack.GetDamagePotential( diff ) + defenderStack.GetToughness( diff ) ) / 2;
						damageTotal += ( defenderStack.GetDamagePotential( 1 ) * ( 1.0f - float( topCHealth ) / float( defenderStack.GetHitPoints() ) ) + defenderStack.GetToughness( 1 ) * ( 1.0f - float( topCHealth ) / float( defenderStack.GetHitPoints() ) ) ) / 2; //fractions count, too
						toughnessTotal += defenderStack.GetToughness( diff );
						toughnessTotal += ( defenderStack.GetToughness( 1 ) * ( 1.0f - float( topCHealth ) / float( defenderStack.GetHitPoints() ) ) ); //fractions count, too
					}
					else
					{
						damageTotal += ( defenderStack.GetDamagePotential( 1 ) * ( 1.0f - float( defenderStack.GetTopCreatureHealth() - topCHealth ) / float( defenderStack.GetHitPoints() ) ) + defenderStack.GetToughness( 1 ) * ( 1.0f - float( defenderStack.GetTopCreatureHealth() - topCHealth ) / float( defenderStack.GetHitPoints() ) ) ) / 2; //fractions count, too
						toughnessTotal += ( defenderStack.GetToughness( 1 ) * ( 1.0f - float( topCHealth ) / float( defenderStack.GetHitPoints() ) ) ); //fractions count, too
					}
					if( !stack.IsRanged() && defenderStack.IsRanged() && defenderStack.CanRangeAttack() )
					{
						damageTotal *= 2.0f;
					}
				}
				evaluation.KillCount = diff;
				evaluation.DamagePotentialReduction = damageTotal;
				evaluation.Target = opponentStack;
				evaluation.TurnsToReach = FCeil(pathCost/float(stack.GetMovementPoints()));
				evaluation.SubordinateIniQueuePosition = combatController.GetInitiativeQueue().GetIndexForUnit( stack );
				evaluation.TargetActsAfterSubordinate = combatController.GetInitiativeQueue().GetIndexForUnit( stack ) < combatController.GetInitiativeQueue().GetIndexForUnit( opponentStack );
				evaluation.HitCell = attackHitCell;
				evaluation.Path = path;
				evaluation.AttackDir = dir;
				evaluation.Subordinate = stack;
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				evaluations.AddItem( evaluation );
			}
		}
	}

	foreach myStacks( stack )
	{
		deadliestEvaluation.DamagePotentialReduction = INDEX_NONE; // reset
		backupDeadliestEvaluation.DamagePotentialReduction = INDEX_NONE;
		deadliestEvaluation.TargetActsAfterSubordinate = false; // reset
		foreach evaluations( evaluation )
		{
			if( evaluation.Subordinate == stack && 
				evaluation.DamagePotentialReduction > deadliestEvaluation.DamagePotentialReduction )
			{
				if( evaluation.TargetActsAfterSubordinate )
				{
					deadliestEvaluation = evaluation;
				}
				else
				{
					backupDeadliestEvaluation = evaluation;
				}
			}
		}

		if( deadliestEvaluation.DamagePotentialReduction == INDEX_NONE )
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			deadliestEvaluations.AddItem( backupDeadliestEvaluation );
			deadliestEvaluation = backupDeadliestEvaluation;
		}
		else
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			deadliestEvaluations.AddItem( deadliestEvaluation );
		}

		isGoodTimeToWait = class'H7AiSensorGoodTimeToWait'.static.IsGoodTimeToWait( stack );

		if( isGoodTimeToWait )
		{
			instruction.InstructionType = CIT_WAIT;
			instruction.InstructionOwner = stack;
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		}
		else if( deadliestEvaluation.DamagePotentialReduction != INDEX_NONE )
		{
			instruction.InstructionType = CIT_ASSAULT;
			instruction.Evaluation = deadliestEvaluations[deadliestEvaluations.Length-1];
			instruction.InstructionOwner = instruction.Evaluation.Subordinate;
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		}
		else
		{
			instruction.InstructionType = CIT_ENGAGE;
			instruction.Evaluation = movementEvaluations[movementEvaluations.Find( 'Subordinate', stack )];
			instruction.InstructionOwner = instruction.Evaluation.Subordinate;
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		}
		instructions.AddItem( instruction );
	}
	if( mInstructions.Length == 0 )
	{
		mInstructions = instructions;
	}
	else
	{
		foreach myStacks( stack )
		{
			foreach mInstructions( instruction )
			{
				if( instruction.Evaluation.Subordinate == stack )
				{
					if( instruction.InstructionType == CIT_ASSAULT )
					{
						if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
					}
					else
					{
						if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
					}
					break;
				}
			}
			foreach instructions( instruction )
			{
				if( instruction.Evaluation.Subordinate == stack )
				{
					if( instruction.InstructionType == CIT_ASSAULT )
					{
						if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
					}
					else
					{
						if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
					}
					break;
				}
			}
		}

		mInstructions = instructions;
	}
}

function Think( H7Unit unit, float deltaTime )
{
	local int i;
	local bool action_done,useHealAbility;
	local H7CombatMapGridController grid_ctrl;
	local H7CombatController combatController;
	local array<H7CreatureStack> targetStacks,filterUnits;
	local H7CreatureStack targetUnit;
	local H7CombatObstacleObject obstacle;
	local array<H7CombatObstacleObject> obstacles;
	local array<H7IEffectTargetable> targetables, secondPrioTargets;
	local H7IEffectTargetable targetable;
	//local array<H7HeroAbility> spells;
	//local float bestDamage;
	//local AiActionScore score;
	//local H7AiSpellEvaluation spellEvaluation;
	//local H7AiCombatInstruction instruction;
	//local array<H7CombatMapCell> cells;

	if( unit == None ) return;

	mDeferTimer -= deltaTime;
	if( mDeferTimer >= 0.0f ) return;

	grid_ctrl = class'H7CombatMapGridController'.static.GetInstance();
	combatController = class'H7CombatController'.static.GetInstance();

	if( mThinkStep == 0 )
	{ 
		grid_ctrl.RefreshThreatMap();
		grid_ctrl.RecalculateReachableCells();

		mSensors.UpdateConsts();

		mThinkStep = 1;
		mDeferTimer = 0.000001f;
		mScores.Remove(0,mScores.Length);
		//ThinkBig( unit );

		//if( H7CreatureStack( unit ) != none )
		//{
		//	instruction = mInstructions[mInstructions.Find( 'InstructionOwner', H7CreatureStack( unit ) )]; 
		//}
		
		//instruction=instruction;
		//if( instruction.InstructionType != CIT_MAX && H7CreatureStack( unit ) != none )
		//{
		//	switch( instruction.InstructionType )
		//	{
		//		case CIT_ASSAULT:
		//			grid_ctrl.DoAbility( instruction.Evaluation.Target.GetCell(), instruction.Evaluation.AttackDir );
		//			break;
		//		case CIT_ENGAGE:
		//			cells.AddItem( instruction.Evaluation.HitCell );
		//			grid_ctrl.StartUnitMovement( instruction.Evaluation.HitCell, cells, instruction.Evaluation.Path );
		//			break;
		//		case CIT_WAIT:
		//			unit.Wait();
		//			break;
		//	}
		//	mSensors.ResetConsts();
		//	mThinkStep = 0;
		//}
		return;
	}

	
	if( unit.GetEntityType() == UNIT_CREATURESTACK )
	{
		if( mThinkStep == 1 )
		{
			mActionMoveCreatureStack.RunScores(mSensors,unit,mScores);
			mThinkStep = 2;
			mDeferTimer = 0.0000001f;
			return;
		}
		if( mThinkStep == 2 )
		{
			mActionAttackCreatureStack.RunScores(mSensors,unit,mScores);
			mThinkStep = 3;
			mDeferTimer = 0.0000001f;
			return;
		}
		if( mThinkStep == 3 )
		{
			mActionRangeAttackCreatureStack.RunScores(mSensors,unit,mScores);
			mThinkStep = 4;
			mDeferTimer = 0.0000001f;
			return;
		}
		if( mThinkStep == 4 )
		{
			mActionMoveAttackCreatureStack.RunScores(mSensors,unit,mScores);
			mThinkStep = 5;
			mDeferTimer = 0.0000001f;
			return;
		}
		if( mThinkStep == 5 )
		{
			mActionUseAbilityCreature.RunScores(mSensors,unit,mScores);
			mThinkStep = 6;
			mDeferTimer = 0.0000001f;
			return;
		}
		if( mThinkStep == 6 )
		{
			mActionDefend.RunScores(mSensors,unit,mScores);
			mThinkStep = 7;
			mDeferTimer = 0.0000001f;
			return;
		}
		if( mThinkStep == 7 )
		{
			mActionWaitCreature.RunScores(mSensors,unit,mScores);
			mThinkStep = 8;
			mDeferTimer = 0.0000001f;
			return;
		}
		if( mThinkStep == 8 )
		{
			mActionFleeSurrenderCombat.RunScores(mSensors,unit,mScores);
			mThinkStep = 9;
			mDeferTimer = 0.0000001f;
			return;
		}
		if( mThinkStep == 9 )
		{
			mScores.Sort(ScoreSort);
			mThinkStep = 99;
			mDeferTimer = 0.0000001f;
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
			mDeferTimer = 0.0000001f;
			return;
		}
		if( mThinkStep == 2 )
		{
			mActionAttackHero.RunScores(mSensors,unit,mScores);
			mThinkStep = 3;
			mDeferTimer = 0.0000001f;
			mActionCastSpellHero.Dubstep=0;
			mEvaluations.Length = 0;
			mDubStep = 0;
			mOptimalBestDone = false;
			mOptimalCalcIndex = 0;
			mOptimalBestDamage = 0;
			mOptimalBestTarget = none;

			return;
		}
		if( mThinkStep == 3 )
		{
			mActionCastSpellHero.RunScores(mSensors,unit,mScores); // old

			if( mActionCastSpellHero.Dubstep == INDEX_NONE )
			{
				mThinkStep = 4;
			}
			//H7CombatHero( unit ).GetSpells( spells );
			
			//if( spells.Length > 0 )
			//{
			//	if( mDubStep < spells.Length )
			//	{
			//		GetOptimalTarget( spells[mDubStep], H7CombatHero( unit ), bestDamage );
					
					
			//		if( mOptimalBestDone )
			//		{
			//			if( mOptimalBestTarget != none )
			//			{
			//				spellEvaluation.Damage = mOptimalBestDamage;
			//				spellEvaluation.Spell = spells[mDubStep];
			//				spellEvaluation.Target = mOptimalBestTarget;
			//				mEvaluations.AddItem( spellEvaluation );
			//			}

			//			++mDubStep;

			//			mOptimalBestDone = false;
			//			mOptimalCalcIndex = 0;
			//			mOptimalBestDamage = 0;
			//			mOptimalBestTarget = none;
			//		}
			//	}
			//}
			
			//if( mDubStep >= spells.Length )
			//{
			//	if( mEvaluations.Length > 0 )
			//	{
			//		mEvaluations.Sort( SortEvaluations );
			//		for( i = mEvaluations.Length-1; i >= 0; --i )
			//		{
			//			if( mEvaluations[i].Damage <= 0 )
			//			{
			//				mEvaluations.Remove( i, 1 );
			//			}
			//		}

			//		if( mEvaluations.Length == 0 )
			//		{
			//			mThinkStep = 4;
			//		}
			//		else
			//		{
			//			spellEvaluation = mEvaluations[Rand(Min(3, mEvaluations.Length))];

			//			score.params = new () class'H7AiActionParam';
			//			score.params.Clear();
			//			score.action = mActionCastSpellHero;
			//			score.params.SetUnit( APID_1, H7Unit( spellEvaluation.Target ) );
			//			score.params.SetAbility( APID_2, spellEvaluation.Spell );
			//			score.score = spellEvaluation.Damage;

			//			mScores.AddItem( score );
					
			//			mThinkStep = 4;
			//		}
			//	}
			//	else
			//	{
			//		mActionCastSpellHero.RunScores(mSensors,unit,mScores); // old
			//		if( mActionCastSpellHero.Dubstep == INDEX_NONE )
			//		{
			//			mThinkStep = 4;
			//		}
			//	}
			//}
			mDeferTimer = 0.0000001f;
			return;
		}

		if( mThinkStep == 4 )
		{
			mScores.Sort(ScoreSort);
			mThinkStep = 99;
			mDeferTimer = 0.0000001f;
			return;
		}

		if(mScores.Length>=1)
		{
			//idx = Rand(Min(mScores.Length,3));
			//idx = Rand(Max(mScores.Length-1,1));
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			for( i = 0; i < mScores.Length; ++i )
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			}
			action_done = mScores[0].action.PerformAction(unit,mScores[0]);
			if( action_done == false )
			{
				targetStacks = combatController.GetOpponentArmy( unit.GetCombatArmy() ).GetCreatureStacks();
				if( unit.IsRanged() )
				{
					unit.PrepareAbility( unit.GetRangedAttackAbility() );
				}
				else
				{
					unit.PrepareAbility( unit.GetMeleeAttackAbility() );
				}
				targetUnit = GetRandomCreatureStack( targetStacks, unit.GetPreparedAbility() );
				unit.GetPreparedAbility().SetTarget( targetUnit );
				combatController.SetActiveUnitCommand_UsePreparedAbility( targetUnit.GetCell() );
				
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				unit.Wait();
			}
		}
		else
		{
			targetStacks = combatController.GetOpponentArmy( unit.GetCombatArmy() ).GetCreatureStacks();
			if( unit.IsRanged() )
			{
				unit.PrepareAbility( unit.GetRangedAttackAbility() );
			}
			else
			{
				unit.PrepareAbility( unit.GetMeleeAttackAbility() );
			}
			targetUnit = GetRandomCreatureStack( targetStacks, unit.GetPreparedAbility() );
			unit.GetPreparedAbility().SetTarget( targetUnit );
			combatController.SetActiveUnitCommand_UsePreparedAbility( targetUnit.GetCell() );
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
			if (  unit.GetAbilityManager().GetAbility(H7WarUnit( unit ).GetRangedAttackAbility()).HasTag( TAG_HEAL )                ||
				  unit.GetAbilityManager().GetAbility(H7WarUnit( unit ).GetRangedAttackAbility()).HasTag( TAG_REPAIR )              || 
				  unit.GetAbilityManager().GetAbility(H7WarUnit( unit ).GetRangedAttackAbility()).HasTag( TAG_REPAIR_RESURRECT )	|| 
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
					
			if (  unit.GetAbilityManager().GetAbility(H7WarUnit( unit ).GetSupportAbility()).HasTag( TAG_HEAL )                ||
				  unit.GetAbilityManager().GetAbility(H7WarUnit( unit ).GetSupportAbility()).HasTag( TAG_REPAIR )              || 
				  unit.GetAbilityManager().GetAbility(H7WarUnit( unit ).GetSupportAbility()).HasTag( TAG_REPAIR_RESURRECT )    || 
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
			if( unit.IsWaitTurn() || combatController.GetInitiativeQueue().IsLast(unit) )
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
				
		combatController.SetActiveUnitCommand_UsePreparedAbility( targetable );

		mSensors.ResetConsts();
		mThinkStep = 0;
	}
	else if( unit.GetEntityType() == UNIT_TOWER )
	{
		targetStacks = combatController.GetOpponentArmy( unit.GetCombatArmy() ).GetCreatureStacks();

		unit.PrepareAbility( unit.GetRangedAttackAbility() );
		
		targetUnit = GetRandomCreatureStack( targetStacks, unit.GetPreparedAbility() );

		if( targetUnit == none )
		{
			combatController.SetActiveUnitCommand_SkipTurn( false );
		}
		else
		{
			combatController.SetActiveUnitCommand_UsePreparedAbility( targetUnit );
		}

		mSensors.ResetConsts();
		mThinkStep = 0;
	}
	else if( unit.GetEntityType() == UNIT_RUNEUNIT )
	{
		mActionMoveRune.RunScores( mSensors, unit, mScores );

		mActionActivateRune.RunScores( mSensors, unit, mScores );

		mScores.Sort( ScoreSort );
		if(mScores.Length>=1)
		{
			action_done = mScores[0].action.PerformAction(unit,mScores[0]);
		}
		else
		{
			H7RuneUnit( unit ).DoSkip();
		}
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

delegate int SortEvaluations(H7AiSpellEvaluation A, H7AiSpellEvaluation B) 
{ 
	return int(A.Damage) < int(B.Damage) ? -1 : 0; 
}



function H7IEffectTargetable GetOptimalTarget( H7HeroAbility spell, H7CombatHero hero, out float bestDamage )
{
	local EAbilityTarget targetType;
	local H7CombatArmy oppArmy;
	local array<H7CreatureStack> stacks;
	local H7CreatureStack stack;
	local float damageTotalEnemy, damageTotalFriendly;
	local bool friendly;
	local H7CombatMapGridController gridController;
	local int creatureCount, x, y, k, bestEffect;
	local H7CombatMapCell cell;
	local array<IntPoint> pos;
	local array<int> size;

	local int                       dx2, dy2;
	local array<int>                id;




	gridController = class'H7CombatMapGridController'.static.GetInstance();
	
	bestDamage = 0;

	if( hero.GetCurrentMana() < spell.GetManaCost() )
	{
		mOptimalBestDone = true;
		return none;
	}

	hero.PrepareAbility( spell );
	oppArmy = class'H7CombatController'.static.GetInstance().GetOpponentArmy( hero.GetCombatArmy() );
	friendly = !spell.HasNegativeEffect();
	if( friendly )
	{
		hero.GetCombatArmy().GetSurvivingCreatureStacks( stacks );
	}
	else
	{
		oppArmy.GetSurvivingCreatureStacks( stacks );
	}

	targetType = spell.GetTargetType();

	switch( targetType )
	{
		case NO_TARGET:  
			if( spell.GetDamageEffect( spell.GetCaster() ) != none || spell.IsDamageFilter() )
			{
				class'H7AiSensorSpellMultiDamage'.static.GetDamageTotalValue( spell, stacks[0], none, damageTotalEnemy, damageTotalFriendly );
			}
			else if( spell.GetBuffEffect( spell.GetCaster() ) != none )
			{
				class'H7AiSensorSpellTargetCheck'.static.GetTotalEffectValue( true, spell, stacks[0], none, damageTotalEnemy );
			}
			if( damageTotalFriendly == 0 || damageTotalEnemy > 5 * damageTotalFriendly )
			{
				mOptimalBestTarget = stacks[0];
				mOptimalBestDamage = damageTotalEnemy;
			}
			mOptimalBestDone = true;
			break;
		case TARGET_TSUNAMI:   
		case TARGET_SINGLE:              
		case TARGET_AREA:                
		case TARGET_LINE:                
		case TARGET_SWEEP:               
		case TARGET_CONE:                
		case TARGET_CUSTOM_SHAPE:        
		case TARGET_ELLIPSE: 
		case TARGET_SUNBURST:        
		case TARGET_DOUBLE_LINE:     
			if( spell.GetDamageEffect( spell.GetCaster()  ) != none || spell.IsDamageFilter() )
			{
				class'H7AiSensorSpellMultiDamage'.static.GetDamageTotalValue( spell, stacks[mOptimalCalcIndex], none, damageTotalEnemy, damageTotalFriendly );
			}
			else if( spell.GetBuffEffect( spell.GetCaster() ) != none )
			{
				if( spell.GetTargetArea().X > 0 && spell.GetTargetArea().Y > 0 )
				{
					dx2=(spell.GetTargetArea().X-1)/2;
					dy2=(spell.GetTargetArea().Y-1)/2;
					foreach stacks(stack)
					{
						if(stack!=None && stack.IsDead()==false && stack.IsOffGrid()==false && stack.IsVisible()==true)
						{
							pos.AddItem(stack.GetGridPosition());
							size.AddItem(stack.GetUnitBaseSizeInt()-1);
						}
					}

					for(x=0;x<gridController.GetGridSizeX();x++)
					{
						for(y=0;y<gridController.GetGridSizeY();y++)
						{
							creatureCount=0;
							for(k=0;k<pos.Length;k++)
							{
								// check if creature base overlaps with spell area
								if( x > (pos[k].X + size[k]) ) continue;
								if( (x + spell.GetTargetArea().X) < pos[k].X ) continue;
								if( y > (pos[k].Y + size[k]) ) continue;
								if( (y + spell.GetTargetArea().Y) < pos[k].Y ) continue;

								if(id.Find(k)==INDEX_NONE)
								{
									id.AddItem(k);
									creatureCount++;
								}
							}
							id.Remove(0,id.Length);
							if( creatureCount > 0 )
							{
								class'H7AiSensorSpellTargetCheck'.static.GetTotalEffectValue( friendly, spell, none, gridController.GetCombatGrid().GetCellByPos(x+dx2,y+dy2), damageTotalEnemy );
								if( damageTotalEnemy > bestEffect )
								{
									cell = gridController.GetCombatGrid().GetCellByPos(x+dx2,y+dy2);
									bestEffect = damageTotalEnemy;
								}
							}
						}
					}
					mOptimalCalcIndex = stacks.Length;
					class'H7AiSensorSpellTargetCheck'.static.GetTotalEffectValue( friendly, spell, none, cell, damageTotalEnemy );
				}
				else
				{
					class'H7AiSensorSpellTargetCheck'.static.GetTotalEffectValue( friendly, spell, stacks[mOptimalCalcIndex], none, damageTotalEnemy );
				}
			}
			
			if( damageTotalFriendly == 0 || damageTotalEnemy > 5 * damageTotalFriendly )
			{
				if( mOptimalBestDamage <= 0 || damageTotalEnemy > mOptimalBestDamage )
				{
					mOptimalBestDamage = damageTotalEnemy;
					mOptimalBestTarget = stacks[mOptimalCalcIndex];
				}
			}

			++mOptimalCalcIndex;
			if( mOptimalCalcIndex >= stacks.Length )
			{
				mOptimalBestDone = true;
			}
			break;
	}
	
	bestDamage = mOptimalBestDamage;
	return mOptimalBestTarget;
}

protected function H7CreatureStack GetRandomCreatureStack( array<H7CreatureStack> creatureStacks, H7BaseAbility ability )
{
	local array<H7CreatureStack> cleanCreatureStacks;
	local H7CreatureStack currentCreatureStack;

	foreach creatureStacks( currentCreatureStack )
	{
		if( !currentCreatureStack.IsDead() && ability.CanCastOnTargetActor( currentCreatureStack ) )
		{
			cleanCreatureStacks.AddItem( currentCreatureStack );
		}
	}

	return cleanCreatureStacks[ FRand() * ( cleanCreatureStacks.Length - 1 ) ];
}

