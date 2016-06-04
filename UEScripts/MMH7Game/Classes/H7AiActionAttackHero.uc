//=============================================================================
// H7AiActionAttackHero
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionAttackHero extends H7AiActionBase;

var protected H7AiUtilityKillScale mUtility1;

function String DebugName()
{
	return "Hero Attack";
}

function Setup()
{
	mUtility1 = new class'H7AiUtilityKillScale';
}

/// override function(s)

function RunScores( H7AiCombatSensors sensors, H7Unit currentUnit, out array<AiActionScore> scores )
{
	local int               k;
	local AiActionScore     score;
	local H7AiSensorInputConst    sic;
	local array<float>      utOut;
	local float             W;
	local H7CombatHero hero;

	sic = sensors.GetSensorIConsts();

	score.action = Self;
	score.score = 0.0f;
	
	hero=H7CombatHero(currentUnit);

	hero.PrepareDefaultAbility();

	// for all enemy creature stacks ...
	for( k = 0; k < sic.GetOppCreatureStackNum(); k++ )
	{
		score.params = new () class'H7AiActionParam';
		score.params.Clear();
		score.params.SetUnit( APID_1, sic.GetOppCreatureStack( k ) );

		sic.SetTargetCreatureStack(sic.GetOppCreatureStack(k));

		mUtility1.UpdateInput();
		mUtility1.UpdateOutput();
		utOut = mUtility1.GetOutValues();
		// this util has only one result ...
		if( utOut.Length >= 1 )
		{
			W = utOut[0];
		}
		utOut.Remove( 0, utOut.Length );

		score.score = W;
		if( score.score != 0.0f )
		{
			scores.AddItem( score );
		}
	}
}

function bool PerformAction( H7Unit unit, AiActionScore score )
{
	local H7CombatController ctrl;
	local H7CombatMapGridController grid_ctrl;
	local H7CombatHero hero;
	local H7Unit targetUnit;

	ctrl = class'H7CombatController'.static.GetInstance();
	grid_ctrl = class'H7CombatMapGridController'.static.GetInstance();

	hero=H7CombatHero(unit);

	if( hero != None && ctrl != None )
	{
		targetUnit = score.params.GetUnit(APID_1);

		hero.PrepareDefaultAbility();

		if( hero.GetPreparedAbility().CanCastOnTargetActor( targetUnit ) )
		{
			return grid_ctrl.DoAbility( H7CreatureStack(targetUnit).GetCell() );
		}
		return true;
	}
	return false;
}
