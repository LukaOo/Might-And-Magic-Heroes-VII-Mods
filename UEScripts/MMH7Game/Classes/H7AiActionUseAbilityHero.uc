//=============================================================================
// H7AiActionUseAbilityHero
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionUseAbilityHero extends H7AiActionBase;

var protected H7AiUtilityCanMoveAttack      mUtility1;
var protected H7AiUtilityCanCastSpellHero   mUtility2;
var protected H7AiUtilityCanRangeAttack     mUtility3;

function Setup()
{
	mUtility1 = new class'H7AiUtilityCanMoveAttack';
	mUtility2 = new class'H7AiUtilityCanCastSpellHero';
	mUtility3 = new class'H7AiUtilityCanRangeAttack';
}

/// override function(s)

function RunScores( H7AiCombatSensors sensors, H7Unit currentUnit, out array<AiActionScore> scores )
{
	local int               k;
	local AiActionScore     score;
	local array<AiActionScore>     tmpScores;
	local H7AiSensorInputConst    sic;
	local array<float>      utOut;
	local float             W, V;

	sic = sensors.GetSensorIConsts();

	score.action = Self;
	score.score = 0.0f;
	
	// check if we can cast spells
	mUtility2.UpdateInput();
	mUtility2.UpdateOutput();
	utOut = mUtility2.GetOutValues();
	if( utOut.Length >= 1 )
	{
		V = utOut[0];
	}
	utOut.Remove(0,utOut.Length);
	if( V == 0.0f ) 
	{
		return;
	}
	
	// for all friendly? creature stacks ...
	for( k = 0; k < sic.GetCreatureStackNum(); k++ )
	{
		score.params = new () class'H7AiActionParam';
		score.params.Clear();
		score.params.SetUnit( APID_1, sic.GetCreatureStack( k ) );

		sic.SetTargetCreatureStack(sic.GetCreatureStack(k));

		mUtility1.UpdateInput();
		mUtility1.UpdateOutput();
		utOut = mUtility1.GetOutValues();
		// this util has only one result ...
		if( utOut.Length >= 1 )
		{
			W = utOut[0];
		}
		utOut.Remove( 0, utOut.Length );

		score.score = (V-W);
		tmpScores.AddItem( score );
	}
	foreach tmpScores( score )
	{
		if( score.score == 1.0f )
		{
			scores.AddItem( score );
			break;
		}
	}

	// for all enemy creature stacks ...
	for( k = 0; k < sic.GetOppCreatureStackNum(); k++ )
	{
		score.params = new () class'H7AiActionParam';
		score.params.Clear();
		score.params.SetUnit( APID_1, sic.GetOppCreatureStack( k ) );

		mUtility3.UpdateInput();
		mUtility3.UpdateOutput();
		utOut = mUtility3.GetOutValues();
		// this util has only one result ...
		if( utOut.Length >= 1 )
		{
			W = utOut[0];
		}
		utOut.Remove( 0, utOut.Length );

		score.score = W;
		if( score.score == 1.0f )
		{
			scores.AddItem( score );
			break;
		}
	}
}

function bool PerformAction( H7Unit unit, AiActionScore score )
{
	local H7CombatController ctrl;
	local array<H7BaseAbility> abilities;
	local H7BaseAbility ability;
	local H7CombatMapGridController grid_ctrl;

	ctrl = class'H7CombatController'.static.GetInstance();
	grid_ctrl = class'H7CombatMapGridController'.static.GetInstance();

	if( unit != None && ctrl != None )
	{
		unit.GetAbilityManager().GetAbilities( abilities );
		foreach abilities( ability )
		{
			unit.PrepareAbility( ability );
			ctrl.SetActiveUnitCommand_UsePreparedAbility( grid_ctrl.GetCombatGrid().GetCellByIntPoint( score.params.GetUnit( APID_1 ).GetGridPosition() ) );
			return true;
		}
	}
	return false;
}
