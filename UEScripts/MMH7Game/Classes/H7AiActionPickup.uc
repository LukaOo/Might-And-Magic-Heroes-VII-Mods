//=============================================================================
// H7AiActionPickup
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionPickup extends H7AiActionBase;

var protected H7AiUtilityAttackTargetScore mUAttackTarget;

function String DebugName()
{
	return "Pickup";
}

function Setup()
{
	mUAttackTarget = new class'H7AiUtilityAttackTargetScore';
	mABID=AID_Pickup;
}

/// override function(s)

function RunScoresAdv( H7AiAdventureSensors sensors, H7Unit currentUnit, out array<AiActionScore> scores, optional H7AdventureConfiguration cfg )
{
	local int               k;
	local AiActionScore     score;
	local H7AiSensorInputConst    sic;
	local array<float>      utTargetScore;
	local int               numSites;
	local H7AdventureHero   hero;
	local H7AiConfigCompound  actionCfg;
	local H7AiHeroAgCompound2  heroCfg;
	local float            tensionValue, aocMod;

//	`LOG_AI("Action.Pickup");

	sic = sensors.GetSensorIConsts();

	score.action = Self;
	score.score = 0.0f;
	
	hero=H7AdventureHero(currentUnit);
	if(hero!=None)
	{
		switch(hero.GetAiRole())
		{
			case HRL_GENERAL:   actionCfg = cfg.mAiAdvMapConfig.mConfigPickup.General; break;
			case HRL_MAIN:      actionCfg = cfg.mAiAdvMapConfig.mConfigPickup.Main; break;
			case HRL_SECONDARY: actionCfg = cfg.mAiAdvMapConfig.mConfigPickup.Secondary; break;
			case HRL_SCOUT:     actionCfg = cfg.mAiAdvMapConfig.mConfigPickup.Scout; break;
			case HRL_SUPPORT:   actionCfg = cfg.mAiAdvMapConfig.mConfigPickup.Support; break;
			case HRL_MULE:      actionCfg = cfg.mAiAdvMapConfig.mConfigPickup.Mule; break;
		}

		switch(hero.GetAiControlType())
		{
			case HCT_STANDARD:  heroCfg = cfg.mAiAdvMapConfig.mConfigHeroes2.Standard; break;
			case HCT_EXPLORER:  heroCfg = cfg.mAiAdvMapConfig.mConfigHeroes2.Explorer; break;
			case HCT_GATHERER:  heroCfg = cfg.mAiAdvMapConfig.mConfigHeroes2.Gatherer; break;
			case HCT_HOMEGUARD: heroCfg = cfg.mAiAdvMapConfig.mConfigHeroes2.Homeguard; break;
			case HCT_GENERAL:   heroCfg = cfg.mAiAdvMapConfig.mConfigHeroes2.General; break;
		}
	}

	tensionValue = hero.GetAdventureArmy().GetAiTensionValue(AID_Pickup);

	mUAttackTarget.mMovementEffortBias = actionCfg.MovementEffortBias;
	mUAttackTarget.mFightingEffortBias = actionCfg.FightingEffortBias;
	mUAttackTarget.mFightingEffortModifier = hero.GetPlayer().mDifficultyAIAggressivenessMultiplier;

	// for all site targets (that may have an defending army) and are below the not explored fow ...
	numSites=sic.GetCollectiblesNum();
//	`LOG_AI("Num Sites:" @ numSites );
	if(numSites>actionCfg.ProximityTargetLimit) numSites=actionCfg.ProximityTargetLimit;
	for( k = 0; k < numSites; k++ )
	{
		if( !sic.GetCollectibles(k).IsA('H7ResourcePile') || CheckIfSiteIsLocked( sic.GetCollectibles(k), hero ) ) continue;

//		`LOG_AI("  Site" @ sic.GetCollectibles(k) @ sic.GetCollectibles(k).GetName() );
		score.score =0.0f;
		score.dbgString = "Action.Pickup; " $  sic.GetCollectibles(k) $ "; ";

		sic.SetTargetVisSite(sic.GetCollectibles(k),false); // that sets internally the targetArmy to
		sic.SetTargetCellAdv(sic.GetCollectibles(k).GetEntranceCell());

		mUAttackTarget.UpdateInput();
		mUAttackTarget.UpdateOutput();
		utTargetScore = mUAttackTarget.GetOutValues();

		if(utTargetScore.Length>0)
		{
			aocMod=hero.GetPlayer().CalcAiAoCModifierFromTargetSite(actionCfg,sic.GetTargetVisSite());
			score.score = utTargetScore[0] * heroCfg.Pickup * aocMod;
		}

		score.dbgString = score.dbgString $ "heroCfg.Pickup(" $ heroCfg.Pickup $ ") aocMod(" $ aocMod $ ") ";

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

function bool PerformAction( H7Unit unit, AiActionScore score )
{
	local H7AdventureController ctrl;
	local H7AdventureGridManager gridManager;
	local H7VisitableSite site;
	local H7AdventureArmy army;
	local bool success;
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
		site = score.params.GetVisSite(APID_2);
		if( army != None )
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			return gridManager.DoAttackArmy( army.Location,  true, true );
		}
		if( site != None )
		{
			success = gridManager.DoVisit( site, true, true );
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			return success;
		}
	}
	return false;
}

function bool CheckIfSiteIsLocked( H7VisitableSite site, H7AdventureHero evaluationHero )
{
	local array<H7AdventureHero> heroes;
	local H7AdventureHero hero;

	heroes = evaluationHero.GetPlayer().GetHeroes();

	foreach heroes( hero )
	{
		if( !hero.IsDead() && hero.IsHero() && hero != evaluationHero && hero.GetAiLastScoreAction() != none)
		{
			if( hero.GetAiLastScoreAction().GetAdvActionID() == AID_Pickup && hero.GetAiLastScoreParam().GetVisSite( APID_2 ) == site )
			{
				return true;
			}
		}
	}
	return false;
}
