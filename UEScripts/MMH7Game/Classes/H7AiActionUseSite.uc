//=============================================================================
// H7AiActionUseSite
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionUseSite extends H7AiActionBase;

var protected H7AiUtilityAttackTargetScore  mUAttackTarget;
var protected H7AiUtilitySiteAvailable      mUSiteAvailable;

function String DebugName()
{
	return "Use Site";
}

function Setup()
{
	mUAttackTarget = new class'H7AiUtilityAttackTargetScore';
	mUSiteAvailable = new class'H7AiUtilitySiteAvailable';
	mABID=AID_UseSite;
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

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	sic = sensors.GetSensorIConsts();

	score.action = Self;
	score.score = 0.0f;

	hero=H7AdventureHero(currentUnit);
	if(hero!=None)
	{
		switch(hero.GetAiRole())
		{
			case HRL_GENERAL:   actionCfg = cfg.mAiAdvMapConfig.mConfigUseSite.General; break;
			case HRL_MAIN:      actionCfg = cfg.mAiAdvMapConfig.mConfigUseSite.Main; break;
			case HRL_SECONDARY: actionCfg = cfg.mAiAdvMapConfig.mConfigUseSite.Secondary; break;
			case HRL_SCOUT:     actionCfg = cfg.mAiAdvMapConfig.mConfigUseSite.Scout; break;
			case HRL_SUPPORT:   actionCfg = cfg.mAiAdvMapConfig.mConfigUseSite.Support; break;
			case HRL_MULE:      actionCfg = cfg.mAiAdvMapConfig.mConfigUseSite.Mule; break;
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

	tensionValue = hero.GetAdventureArmy().GetAiTensionValue(AID_UseSite);

	mUAttackTarget.mMovementEffortBias = actionCfg.MovementEffortBias;
	mUAttackTarget.mFightingEffortBias = actionCfg.FightingEffortBias;
	mUAttackTarget.mFightingEffortModifier = hero.GetPlayer().mDifficultyAIAggressivenessMultiplier;

	// for all site targets (that may have an defending army) and are below the not explored fow ...
	numSites=sic.GetBuffSiteNum();
//	`LOG_AI("Num Buff Sites:" @ numSites );
	if(numSites>10) numSites=10;
	for( k = 0; k < numSites; k++ )
	{
//		`LOG_AI("  Site" @ sic.GetBuffSite(k) );
		score.score =0.0f;

		sic.SetTargetVisSite(sic.GetBuffSite(k)); // that sets internally the targetArmy to
		sic.SetTargetCellAdv(sic.GetBuffSite(k).GetEntranceCell());

		mUSiteAvailable.UpdateInput();
		mUSiteAvailable.UpdateOutput();
		utSiteAvailable = mUSiteAvailable.GetOutValues();
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		if( utSiteAvailable.Length >= 1 && utSiteAvailable[0] > 0.0f )
		{
			mUAttackTarget.UpdateInput();
			mUAttackTarget.UpdateOutput();
			utAttackTarget = mUAttackTarget.GetOutValues();
			if( utAttackTarget.Length >= 1 && utAttackTarget[0] > 0.0f )
			{
				aocMod=hero.GetPlayer().CalcAiAoCModifierFromTargetSite(actionCfg,sic.GetTargetVisSite());
				score.score = utAttackTarget[0] * heroCfg.UseSite * aocMod;
			}

			if( score.score > actionCfg.Cutoff )
			{
				score.params = new () class'H7AiActionParam';
				score.params.Clear();
				score.params.SetAdventureArmy( APID_1, sic.GetTargetArmyAdv() );
				score.params.SetVisSite( APID_2, sic.GetTargetVisSite( ) );
				score.tension = actionCfg.Tension.Base;
	
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
		if( army != None && army.HasUnits() )
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
