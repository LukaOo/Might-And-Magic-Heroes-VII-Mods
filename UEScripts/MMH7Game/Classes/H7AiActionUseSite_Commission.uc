//=============================================================================
// H7AiActionUseSite_Commission
//=============================================================================
// Tax Collector
// Alchemist Lab
// Warehouse
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionUseSite_Commission extends H7AiActionBase;

var protected H7AiUtilityAttackTargetScore  mUAttackTarget;
var protected H7AiUtilitySiteAvailable      mUSiteAvailable;

function String DebugName()
{
	return "Use Site Commission";
}

function Setup()
{
	mUAttackTarget = new class'H7AiUtilityAttackTargetScore';
	mUSiteAvailable = new class'H7AiUtilitySiteAvailable';
	mABID=AID_UseSiteCommission;
}

/// override function(s)

function RunScoresAdv( H7AiAdventureSensors sensors, H7Unit currentUnit, out array<AiActionScore> scores, optional H7AdventureConfiguration cfg )
{
	local int               k;
	local AiActionScore     score;
	local H7AiSensorInputConst    sic;
	local array<float>      utAttackTarget;
	local array<float>      utSiteAvailable;
	local int               numSites;
	local H7AdventureHero   hero;
	local H7AiConfigCompound  actionCfg;
	local H7AiHeroAgCompound2  heroCfg;
	local float            tensionValue, aocMod;

//	`LOG_AI("Action.UseSite_Commission");

	sic = sensors.GetSensorIConsts();

	score.action = Self;
	score.score = 0.0f;
	
	hero=H7AdventureHero(currentUnit);
	if(hero!=None)
	{
		switch(hero.GetAiRole())
		{
			case HRL_GENERAL:   actionCfg = cfg.mAiAdvMapConfig.mConfigUseSiteCommission.General; break;
			case HRL_MAIN:      actionCfg = cfg.mAiAdvMapConfig.mConfigUseSiteCommission.Main; break;
			case HRL_SECONDARY: actionCfg = cfg.mAiAdvMapConfig.mConfigUseSiteCommission.Secondary; break;
			case HRL_SCOUT:     actionCfg = cfg.mAiAdvMapConfig.mConfigUseSiteCommission.Scout; break;
			case HRL_SUPPORT:   actionCfg = cfg.mAiAdvMapConfig.mConfigUseSiteCommission.Support; break;
			case HRL_MULE:      actionCfg = cfg.mAiAdvMapConfig.mConfigUseSiteCommission.Mule; break;
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

	tensionValue = hero.GetAdventureArmy().GetAiTensionValue(AID_UseSiteCommission);

	mUAttackTarget.mMovementEffortBias = actionCfg.MovementEffortBias;
	mUAttackTarget.mFightingEffortBias = actionCfg.FightingEffortBias;
	mUAttackTarget.mFightingEffortModifier = hero.GetPlayer().mDifficultyAIAggressivenessMultiplier;

	// for all site targets (that may have an defending army) and are below the not explored fow ...
	numSites=sic.GetCommissionSiteNum();
//	`LOG_AI("Num Commission Sites:" @ numSites );
	if(numSites>actionCfg.ProximityTargetLimit) numSites=actionCfg.ProximityTargetLimit;
	for( k = 0; k < numSites; k++ )
	{
		if( CheckIfSiteIsLocked( sic.GetCommissionSite(k), hero ) ) { continue; }
//		`LOG_AI("  Site" @ sic.GetCommissionSite(k) );
		score.score =0.0f;
		score.dbgString = "Action.UseSite_Commission; " $ sic.GetCommissionSite(k) $ "; ";

		sic.SetTargetVisSite(sic.GetCommissionSite(k)); // that sets internally the targetArmy to
		sic.SetTargetCellAdv(sic.GetCommissionSite(k).GetEntranceCell());

		mUSiteAvailable.UpdateInput();
		mUSiteAvailable.UpdateOutput();
		utSiteAvailable = mUSiteAvailable.GetOutValues();
//		`LOG_AI("  Available" @ ((utSiteAvailable[0] > 0.0f) ? "true" : "false") );
		if( utSiteAvailable.Length >= 1 && utSiteAvailable[0] > 0.0f )
		{
			mUAttackTarget.UpdateInput();
			mUAttackTarget.UpdateOutput();
			utAttackTarget = mUAttackTarget.GetOutValues();
			if( utAttackTarget.Length >= 1 && utAttackTarget[0] > 0.0f )
			{
				aocMod=hero.GetPlayer().CalcAiAoCModifierFromTargetSite(actionCfg,sic.GetTargetVisSite());
				score.score = utAttackTarget[0] * heroCfg.UseSiteCommission * aocMod;
			}

			score.dbgString = score.dbgString $ "heroCfg.UseSiteCommission(" $ heroCfg.UseSiteCommission $ ") aocMod(" $ aocMod $ ") ";

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

function bool PerformAction( H7Unit unit, AiActionScore score )
{
	local H7AdventureController ctrl;
	local H7AdventureGridManager gridManager;
	local H7AdventureArmy army;
	local H7VisitableSite site;
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
		if( army != None && army.HasUnits() && army.IsGarrisoned()==false )
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

function bool CheckIfSiteIsLocked( H7VisitableSite site, H7AdventureHero evaluationHero )
{
	local array<H7AdventureHero> heroes;
	local H7AdventureHero hero;

	heroes = evaluationHero.GetPlayer().GetHeroes();

	foreach heroes( hero )
	{
		if( !hero.IsDead() && hero.IsHero() && hero != evaluationHero && hero.GetAiLastScoreAction() != none )
		{
			if( hero.GetAiLastScoreAction().GetAdvActionID() == AID_UseSiteCommission && hero.GetAiLastScoreParam().GetVisSite( APID_2 ) == site )
			{
				return true;
			}
		}
	}
	return false;
}
