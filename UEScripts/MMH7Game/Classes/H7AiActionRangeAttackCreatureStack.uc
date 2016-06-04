//=============================================================================
// H7AiActionRangeAttackCreatureStack
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionRangeAttackCreatureStack extends H7AiActionBase;

var protected H7AiUtilityRangeCasualityCount    mInUCasualityCount;
var protected H7AiUtilityRangeCreatureDamage    mInUCreatureDamage;

function String DebugName()
{
	return "Range Attack";
}

function Setup()
{
	mInUCasualityCount = new class'H7AiUtilityRangeCasualityCount';
	mInUCreatureDamage = new class'H7AiUtilityRangeCreatureDamage';
}

/// override function(s)

function RunScores( H7AiCombatSensors sensors, H7Unit currentUnit, out array<AiActionScore> scores )
{
	local int               k;
	local AiActionScore     score;
	local H7AiSensorInputConst    sic;
	local array<float>      casualityCount;
	local array<float>      creatureDamage;
	local float             coUtil;
	local H7BaseAbility     rangeAttackAbilityTemplate;
	local H7BaseAbility     rangeAttackAbility;
	local H7CreatureStack   cstack;
	local H7CombatArmy      otherArmy;
	local array<H7CreatureStack> otherCreatures;
	local H7CreatureStack   creature;
	local H7CombatMapGridController   grid_ctrl;

	sic = sensors.GetSensorIConsts();

	grid_ctrl = class'H7CombatMapGridController'.static.GetInstance();

	score.action = Self;
	score.score = 0.0f;

	// prepare the default range attack ability for attacking unit
	rangeAttackAbilityTemplate = currentUnit.GetRangedAttackAbility();
	if(rangeAttackAbilityTemplate==None) return;
	rangeAttackAbility = currentUnit.GetAbilityManager().GetAbility( rangeAttackAbilityTemplate );
	if(rangeAttackAbility==None) return;
	currentUnit.GetAbilityManager().PrepareAbility( rangeAttackAbility );

	cstack=H7CreatureStack(currentUnit);
	if(cstack==None) return; // ?!

	// double check creature is real
	if(cstack.IsDead()==true || cstack.IsVisible()==false || cstack.IsOffGrid()==true)
	{
		return;
	}

	// check if this creature actually can range attack
	if(cstack.CanRangeAttack()==false)
	{
		return;
	}

	if( cstack.GetAttackCount()<=0 )
	{
		return;
	}

	// check if creature is suppressed (skipping any range attack)
	otherArmy = sic.GetOppArmy();
	otherArmy.GetSurvivingCreatureStacks( otherCreatures );
	foreach otherCreatures( creature )
	{
		if( grid_ctrl.IsTargetInMeleeRange(cstack,creature)==true )
		{
			return;
		}
	}

	// for all enemy creatures ...
	for(k=0;k<sic.GetOppCreatureStackNum();k++)
	{
		score.dbgString = "Action.RangeAttack; " $ rangeAttackAbility @ rangeAttackAbility.GetName() $ "; Target " $ sic.GetOppCreatureStack(k).GetName() $ "; ";

		sic.SetTargetCreatureStack(sic.GetOppCreatureStack(k));

		mInUCasualityCount.UpdateInput();
		mInUCasualityCount.UpdateOutput();
		casualityCount = mInUCasualityCount.GetOutValues();

		mInUCreatureDamage.UpdateInput();
		mInUCreatureDamage.UpdateOutput();
		creatureDamage = mInUCreatureDamage.GetOutValues();

		if(casualityCount.Length>=1 && creatureDamage.Length>=1)
		{
			if(sic.GetOppCreatureStack(k).IsRanged()==true)
			{
				coUtil=casualityCount[0]*creatureDamage[0] * 1.25f;
			}
			else
			{
				coUtil=casualityCount[0]*creatureDamage[0];
			}
			if(coUtil>0.0f)
			{
				score.params = new () class'H7AiActionParam';
				score.params.Clear();
				score.params.SetUnit(APID_1,sic.GetOppCreatureStack(k));
				score.score = coUtil + 0.1f;
				scores.AddItem(score);

				score.dbgString = score.dbgString $ "CC(" $ casualityCount[0] $ ") CD(" $ creatureDamage[0] $ "); ";
			}
		}

	}
}

function bool PerformAction( H7Unit unit, AiActionScore score )
{
	local H7CombatController ctrl;
	local H7CombatMapGridController grid_ctrl;
	local H7BaseAbility rangeAttackAbilityTemplate;
	local H7BaseAbility rangeAttackAbility;

	local H7Unit targetUnit;

	ctrl = class'H7CombatController'.static.GetInstance();
	grid_ctrl = class'H7CombatMapGridController'.static.GetInstance();

	if( unit != None && ctrl != None )
	{
		targetUnit = score.params.GetUnit(APID_1);

		// prepare the range attack ...
		rangeAttackAbilityTemplate = unit.GetRangedAttackAbility();
		if( rangeAttackAbilityTemplate == None ) return false;
		rangeAttackAbility = unit.GetAbilityManager().GetAbility( rangeAttackAbilityTemplate );
		unit.GetAbilityManager().PrepareAbility( rangeAttackAbility );

		if( unit.GetPreparedAbility().CanCastOnTargetActor( targetUnit ) )
		{
			return grid_ctrl.DoAbility( H7CreatureStack(targetUnit).GetCell() );
		}
	}
	return false;
}
