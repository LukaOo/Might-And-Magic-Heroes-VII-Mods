//=============================================================================
// H7AiActionAttackTargetEnemy
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionAttackTargetEnemy extends H7AiActionBase;

var protected H7AiUtilityAttackTargetScore mUAttackTarget;

function String DebugName()
{
	return "Attack Target Enemy";
}

function Setup()
{
	mUAttackTarget = new class'H7AiUtilityAttackTargetScore';
	mABID=AID_AttackEnemy;
}

/// override function(s)

function RunScoresAdv( H7AiAdventureSensors sensors, H7Unit currentUnit, out array<AiActionScore> scores, optional H7AdventureConfiguration cfg )
{
	local int                   k;
	local AiActionScore         score;
	local H7AiSensorInputConst  sic;
	local array<float>          utOut;
	local int                   numArmies;
	local H7AdventureHero       hero;
	local H7AiConfigCompound    actionCfg;
	local H7AiHeroAgCompound    heroCfg;
	local float                 tensionValue, aocMod;
	local H7Town                town;
	local array<H7BaseCreatureStack> emptyStacks;
	local array<H7AdventureMapCell> path;
	local array<float> pathCosts;
	local float pathCost, totalPathCost, powerBalanceValue;
	//local int walkableCells;

	emptyStacks = emptyStacks; // full retard unrealscript

//	`LOG_AI("Action.AttackTargetEnemy");

	sic = sensors.GetSensorIConsts();

	score.action = Self;
	score.score = 0.0f;
	
	hero=H7AdventureHero(currentUnit);
	if(hero!=None)
	{
		switch(hero.GetAiRole())
		{
			case HRL_GENERAL:   actionCfg = cfg.mAiAdvMapConfig.mConfigAttackEnemy.General; break;
			case HRL_MAIN:      actionCfg = cfg.mAiAdvMapConfig.mConfigAttackEnemy.Main; break;
			case HRL_SECONDARY: actionCfg = cfg.mAiAdvMapConfig.mConfigAttackEnemy.Secondary; break;
			case HRL_SCOUT:     actionCfg = cfg.mAiAdvMapConfig.mConfigAttackEnemy.Scout; break;
			case HRL_SUPPORT:   actionCfg = cfg.mAiAdvMapConfig.mConfigAttackEnemy.Support; break;
			case HRL_MULE:      actionCfg = cfg.mAiAdvMapConfig.mConfigAttackEnemy.Mule; break;
		}

		switch(hero.GetAiAggressivness())
		{
			case HAG_SHEEP:     heroCfg = cfg.mAiAdvMapConfig.mConfigHeroes.Sheep; break;
			case HAG_CONTAINED: heroCfg = cfg.mAiAdvMapConfig.mConfigHeroes.Contained; break;
			case HAG_BALANCED:  heroCfg = cfg.mAiAdvMapConfig.mConfigHeroes.Balanced; break;
			case HAG_HOSTILE:   heroCfg = cfg.mAiAdvMapConfig.mConfigHeroes.Hostile; break;
			case HAG_NEFARIOUS: heroCfg = cfg.mAiAdvMapConfig.mConfigHeroes.Nefarious; break;
		}
	}

	tensionValue = hero.GetAdventureArmy().GetAiTensionValue(AID_AttackEnemy);

	mUAttackTarget.mMovementEffortBias = actionCfg.MovementEffortBias;
	mUAttackTarget.mFightingEffortBias = actionCfg.FightingEffortBias;
	mUAttackTarget.mFightingEffortModifier = hero.GetPlayer().mDifficultyAIAggressivenessMultiplier;

	// for all army targets ...
	numArmies=sic.GetArmyNumAdv();
//	`LOG_AI("Num Armies:" @ numArmies );
	if(numArmies>actionCfg.ProximityTargetLimit) numArmies=actionCfg.ProximityTargetLimit;
	for( k = 0; k < numArmies; k++ )
	{
		if( sic.GetOtherArmyAdv(k).GetPlayerNumber()!=PN_NEUTRAL_PLAYER &&
			hero.GetPlayer().IsPlayerHostile(sic.GetOtherArmyAdv(k).GetPlayer())==true &&
			hero.GetPlayer() != sic.GetOtherArmyAdv(k).GetPlayer() &&
			( sic.GetOtherArmyAdv(k).IsGarrisoned()==false || sic.GetOtherArmyAdv(k).IsGarrisonedButOutside()==true ) )
		{
			if( sic.GetOtherArmyAdv(k).GetHero().IsHero() == true )
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			}
			else
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			}

			score.score = 0.0f;
			score.dbgString = "Action.AttackTargetEnemy; " $ sic.GetOtherArmyAdv(k) $ "; ";

			sic.SetTargetArmyAdv(sic.GetOtherArmyAdv(k),false);
			sic.SetTargetCellAdv(sic.GetOtherArmyAdv(k).GetCell());

			mUAttackTarget.UpdateInput();
			mUAttackTarget.UpdateOutput();
			utOut = mUAttackTarget.GetOutValues();
			if( utOut.Length >= 1 )
			{
				aocMod=hero.GetPlayer().CalcAiAoCModifierFromTargetArmy(actionCfg,sic.GetOtherArmyAdv(k));
				score.score = utOut[0] * heroCfg.AttackEnemy * aocMod;
			}

			score.dbgString = score.dbgString $ "heroCfg.AttackArmy(" $ heroCfg.AttackEnemy $ ") aocMod(" $ aocMod $ ") ";

			if( score.score > actionCfg.Cutoff )
			{
				score.params = new () class'H7AiActionParam';
				score.params.Clear();
				score.params.SetAdventureArmy( APID_1, sic.GetTargetArmyAdv() );
				score.params.SetVisSite( APID_2, sic.GetTargetVisSite( ) );
				score.tension = actionCfg.Tension.Base;

				score.dbgString = score.dbgString $ "actionCfg.Cutoff(" $ actionCfg.Cutoff $ ") " $ "actionCfg.Low-High(" $ actionCfg.Low $ ":" $ actionCfg.High $ ") " $ mUAttackTarget.dbgString;

				if(score.score>1.0f) score.score=1.0f;

				town = H7Town( sic.GetOtherArmyAdv(k).GetGarrisonedSite() );

				// ultra experimental - try to force a fight on a nearby enemy
				if( score.score > 0.0f &&
					hero.GetAdventureArmy().GetStrengthValue( true ) > 0 && 
					sic.GetOtherArmyAdv(k).GetStrengthValue( true, town != none ? town.GetLocalGuardAsBaseCreatureStacks() : emptyStacks ) > 0 &&
					hero.GetAdventureArmy().GetStrengthValue( true ) / sic.GetOtherArmyAdv(k).GetStrengthValue( true, town != none ? town.GetLocalGuardAsBaseCreatureStacks() : emptyStacks ) > 1.05f )
				{
					path = class'H7AdventureGridManager'.static.GetInstance().GetPathfinder().FindPath( hero.GetCell(), sic.GetOtherArmyAdv( k ).GetCell(), hero.GetPlayer(), hero.GetAdventureArmy().HasShip(), true );
					pathCosts = class'H7AdventureGridManager'.static.GetInstance().GetPathfinder().GetPathCosts( path, hero.GetCell(), hero.GetMovementPoints() );
					foreach pathCosts( pathCost )
					{
						totalPathCost += pathCost;
					}

					if( totalPathCost <= hero.GetMovementPoints() )
					{
						score.score = 2.0f;
						score.dbgString = score.dbgString @ "*KILLSWITCH*";
					}
				}
				// ultra experimental end

				


				score.score  = Lerp( actionCfg.Low, actionCfg.High, score.score );

				score.score *= tensionValue;

				if( hero.GetPlayer().GetAiPowerBalance() > 0.5f )
				{
					powerBalanceValue = ( 0.5f + hero.GetPlayer().GetAiPowerBalance() );
					score.score *= powerBalanceValue;
					score.dbgString = score.dbgString $ "GeneralPB(" $ powerBalanceValue $ ")";
				}

				if( hero.GetPlayer().GetAiPowerBalance() > sic.GetOtherArmyAdv(k).GetPlayer().GetAiPowerBalance() )
				{
					powerBalanceValue = ( 1.0f + ( hero.GetPlayer().GetAiPowerBalance() - sic.GetOtherArmyAdv(k).GetPlayer().GetAiPowerBalance() ) );
					score.score *= powerBalanceValue;
					score.dbgString = score.dbgString $ "RelativePB(" $ powerBalanceValue $ ")";
				}

				score.dbgString = score.dbgString $ "Tension(" $ tensionValue $ ") FINAL SCORE:" $ score.score;
				

				scores.AddItem( score );
			}
			//`LOG_AI("AttackTargetEnemy for Hans"@score.dbgString);
		}
	}
}

function bool PerformAction( H7Unit unit, AiActionScore score )
{
	local H7AdventureController ctrl;
	local H7AdventureGridManager gridManager;
	local H7AdventureArmy army;
	local H7AdventureHero   hero;
	local H7VisitableSite site;

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	ctrl = class'H7AdventureController'.static.GetInstance();
	gridManager = class'H7AdventureGridManager'.static.GetInstance();

	if( unit != None && ctrl != None )
	{
		hero=H7AdventureHero(unit);
		if(hero!=None)
		{
		}

		army = score.params.GetAdventureArmy(APID_1);
		site = score.params.GetVisSite(APID_2);
		if( army != None && army.IsGarrisoned()==false )
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			return gridManager.DoAttackArmy( army.Location,  true, true );
		}
		if( site != None )
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			return gridManager.DoVisit( site, true, true );
		}
	}
	return false;
}


