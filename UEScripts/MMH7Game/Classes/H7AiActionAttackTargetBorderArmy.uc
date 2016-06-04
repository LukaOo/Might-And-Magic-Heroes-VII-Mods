//=============================================================================
// H7AiActionAttackTargetBorderArmy
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionAttackTargetBorderArmy extends H7AiActionBase;

var protected H7AiUtilityAttackTargetScore mUAttackTarget;

function String DebugName()
{
	return "Attack Target Border Army";
}

function Setup()
{
	mUAttackTarget = new class'H7AiUtilityAttackTargetScore';
	mABID=AID_AttackBorderArmy;
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
	local bool              isGarrison;
	local H7AdventureArmy   tgtArmy;

//	`LOG_AI("Action.AttackTargetArmy");

	sic = sensors.GetSensorIConsts();

	score.action = Self;
	score.score = 0.0f;
	
	hero=H7AdventureHero(currentUnit);
	if(hero!=None)
	{
		switch(hero.GetAiRole())
		{
			case HRL_GENERAL:   actionCfg = cfg.mAiAdvMapConfig.mConfigAttackBorderArmy.General; break;
			case HRL_MAIN:      actionCfg = cfg.mAiAdvMapConfig.mConfigAttackBorderArmy.Main; break;
			case HRL_SECONDARY: actionCfg = cfg.mAiAdvMapConfig.mConfigAttackBorderArmy.Secondary; break;
			case HRL_SCOUT:     actionCfg = cfg.mAiAdvMapConfig.mConfigAttackBorderArmy.Scout; break;
			case HRL_SUPPORT:   actionCfg = cfg.mAiAdvMapConfig.mConfigAttackBorderArmy.Support; break;
			case HRL_MULE:      actionCfg = cfg.mAiAdvMapConfig.mConfigAttackBorderArmy.Mule; break;
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

	tensionValue = hero.GetAdventureArmy().GetAiTensionValue(AID_AttackBorderArmy);

	// for all army targets ...
	numArmies=sic.GetBorderArmyNumAdv();
//	`LOG_AI("Num Armies:" @ numArmies );
	if(numArmies>actionCfg.ProximityTargetLimit) numArmies=actionCfg.ProximityTargetLimit;
	for(k=0; k<numArmies; k++)
	{
		tgtArmy=sic.GetBorderArmyAdv(k);

		isGarrison = tgtArmy.IsGarrisoned() && H7Garrison( tgtArmy.GetGarrisonedSite() ) != none;
		if( (tgtArmy.GetPlayerNumber()==PN_NEUTRAL_PLAYER || hero.GetPlayer().IsPlayerAllied(tgtArmy.GetPlayer())==false && hero.GetPlayer() != tgtArmy.GetPlayer() ) &&
			(tgtArmy.IsGarrisoned()==false || isGarrison ) )
		{
			if( tgtArmy.GetHero().IsHero() == true )
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			}
			else
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			}

			score.score = 0.0f;
			score.dbgString = "Action.AttackTargetBorderArmy; " $ sic.GetBorderArmyAdv(k) $ "; ";

			sic.SetTargetArmyAdv(tgtArmy);
			if(sic.GetTargetVisSite()==None && isGarrison==true) // it is a rejected site! (stay-in-aoc)
			{
				sic.SetTargetVisSite(H7Garrison(tgtArmy.GetGarrisonedSite()),true);
			}
			
			if(sic.GetTargetVisSite()==None)
			{
				sic.SetTargetCellAdv(tgtArmy.GetCell());
			}
			else
			{
				sic.SetTargetCellAdv(sic.GetTargetVisSite().GetEntranceCell());
			}

			if(tgtArmy.GetAiIsBorderControl()==true || isGarrison )
			{
				mUAttackTarget.mMovementEffortBias = actionCfg.MovementEffortBias;
				mUAttackTarget.mFightingEffortBias = actionCfg.FightingEffortBias;
				mUAttackTarget.mFightingEffortModifier = hero.GetPlayer().mDifficultyAIAggressivenessMultiplier;

				mUAttackTarget.UpdateInput();
				mUAttackTarget.UpdateOutput();
				utOut = mUAttackTarget.GetOutValues();
				if( utOut.Length >= 1 )
				{
					aocMod=hero.GetPlayer().CalcAiAoCModifierFromTargetArmy(actionCfg,tgtArmy);
					score.score = utOut[0] * heroCfg.AttackBorderArmy * aocMod;
				}

				score.dbgString = score.dbgString $ "heroCfg.AttackBorderArmy(" $ heroCfg.AttackBorderArmy $ ") aocMod(" $ aocMod $ ") ";

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
				//`LOG_AI("AttackTargetBorderArmy for Hans"@score.dbgString);
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
			if( army.IsGarrisoned() )
			{
				return gridManager.DoVisit( army.GetGarrisonedSite(), true, true );
			}
			else
			{
				return gridManager.DoAttackArmy( army.Location, true, true );
			}
		}
	}
	return false;
}
