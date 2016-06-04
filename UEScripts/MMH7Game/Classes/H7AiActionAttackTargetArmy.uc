//=============================================================================
// H7AiActionAttackTargetArmy
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionAttackTargetArmy extends H7AiActionBase;

var protected H7AiUtilityAttackTargetScore mUAttackTarget;

function String DebugName()
{
	return "Attack Target Army";
}

function Setup()
{
	mUAttackTarget = new class'H7AiUtilityAttackTargetScore';
	mABID=AID_AttackArmy;
}

/// override function(s)

function RunScoresAdv( H7AiAdventureSensors sensors, H7Unit currentUnit, out array<AiActionScore> scores, optional H7AdventureConfiguration cfg )
{
	local int               k;
	local AiActionScore     score;
	local H7AiSensorInputConst    sic;
	local array<float>      utOut;
	local int               numArmies;
	local H7AdventureHero   hero;
	local H7AiConfigCompound  actionCfg;
	local H7AiHeroAgCompound  heroCfg;
	local float             tensionValue, aocMod;

//	`LOG_AI("Action.AttackTargetBorderArmy");

	sic = sensors.GetSensorIConsts();

	score.action = Self;
	score.score = 0.0f;
	
	hero=H7AdventureHero(currentUnit);
	if(hero!=None)
	{
		switch(hero.GetAiRole())
		{
			case HRL_GENERAL:   actionCfg = cfg.mAiAdvMapConfig.mConfigAttackArmy.General; break;
			case HRL_MAIN:      actionCfg = cfg.mAiAdvMapConfig.mConfigAttackArmy.Main; break;
			case HRL_SECONDARY: actionCfg = cfg.mAiAdvMapConfig.mConfigAttackArmy.Secondary; break;
			case HRL_SCOUT:     actionCfg = cfg.mAiAdvMapConfig.mConfigAttackArmy.Scout; break;
			case HRL_SUPPORT:   actionCfg = cfg.mAiAdvMapConfig.mConfigAttackArmy.Support; break;
			case HRL_MULE:      actionCfg = cfg.mAiAdvMapConfig.mConfigAttackArmy.Mule; break;
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

	tensionValue = hero.GetAdventureArmy().GetAiTensionValue(AID_AttackArmy);

	// for all army targets ...
	numArmies=sic.GetNeutralArmyNumAdv();
//	`LOG_AI("Num Armies:" @ numArmies );
	if(numArmies>actionCfg.ProximityTargetLimit) numArmies=actionCfg.ProximityTargetLimit;
	for( k = 0; k < numArmies; k++ )
	{
		if( sic.GetNeutralArmyAdv(k).GetPlayerNumber() == PN_NEUTRAL_PLAYER && sic.GetNeutralArmyAdv(k).IsGarrisoned()==false )
		{
			//if( sic.GetNeutralArmyAdv(k).GetHero().IsHero() == true )
			//{
			//	`LOG_AI("  Army" @ sic.GetNeutralArmyAdv(k) @ "Hero" @ sic.GetNeutralArmyAdv(k).GetHero().GetName() @ "Player" @ sic.GetNeutralArmyAdv(k).GetPlayerNumber()  @ "Strength" @ sic.GetNeutralArmyAdv(k).GetStrengthValue(true) );
			//}
			//else
			//{
			//	`LOG_AI("  Army" @ sic.GetNeutralArmyAdv(k) @ "Player" @ sic.GetNeutralArmyAdv(k).GetPlayerNumber() @ "Strength" @ sic.GetNeutralArmyAdv(k).GetStrengthValue(false) );
			//}

			score.score = 0.0f;
			score.dbgString = "Action.AttackTargetArmy; " $ sic.GetNeutralArmyAdv(k) $ "; ";

			sic.SetTargetVisSite(None,true);
			sic.SetTargetArmyAdv(sic.GetNeutralArmyAdv(k),false);
			sic.SetTargetCellAdv(sic.GetNeutralArmyAdv(k).GetCell());
			if(sic.GetTargetVisSite()==None && sic.GetNeutralArmyAdv(k).GetAiIsBorderControl()==false)
			{
				aocMod=0.0f;

				mUAttackTarget.mMovementEffortBias = actionCfg.MovementEffortBias;
				mUAttackTarget.mFightingEffortBias = actionCfg.FightingEffortBias;
				mUAttackTarget.mFightingEffortModifier = hero.GetPlayer().mDifficultyAIAggressivenessMultiplier;

				mUAttackTarget.UpdateInput();
				mUAttackTarget.UpdateOutput();
				utOut = mUAttackTarget.GetOutValues();
				if( utOut.Length >= 1 )
				{
					aocMod=hero.GetPlayer().CalcAiAoCModifierFromTargetArmy(actionCfg,sic.GetNeutralArmyAdv(k));
					score.score = utOut[0] * heroCfg.AttackArmy * aocMod;
				}

				score.dbgString = score.dbgString $ "heroCfg.AttackArmy(" $ heroCfg.AttackArmy $ ") aocMod(" $ aocMod $ ") ";

				if( score.score > actionCfg.Cutoff )
				{
					score.params = new () class'H7AiActionParam';
					score.params.Clear();
					score.params.SetAdventureArmy( APID_1, sic.GetTargetArmyAdv() );
					score.params.SetVisSite( APID_2, sic.GetTargetVisSite( ) );
					score.tension = actionCfg.Tension.Base;

					score.dbgString = score.dbgString $ "actionCfg.Cutoff(" $ actionCfg.Cutoff $ ") " $ "actionCfg.Low-High(" $ actionCfg.Low $ ":" $ actionCfg.High $ ") " $ mUAttackTarget.dbgString;

					if(score.score>1.0f) score.score=1.0f;
					score.score  = Lerp( actionCfg.Low, actionCfg.High, score.score );

					score.score *= tensionValue;

					score.dbgString = score.dbgString $ "Tension(" $ tensionValue $ ") FINAL SCORE:" $ score.score;

					scores.AddItem( score );
				}
			}
		}
	}
}

function bool PerformAction( H7Unit unit, AiActionScore score )
{
	local H7AdventureController ctrl;
	local H7AdventureGridManager gridManager;
	local H7AdventureArmy army;
	local H7AdventureHero   hero;

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
		if( army != None )
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			return gridManager.DoAttackArmy( army.Location, true, true );
		}
	}
	return false;
}
