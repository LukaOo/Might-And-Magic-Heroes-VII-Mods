//=============================================================================
// H7AiActionAttackTargetAoC
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionAttackTargetAoC extends H7AiActionBase;

var protected H7AiUtilityAttackTargetScore  mUAttackTarget;
var protected H7AiUtilitySiteAvailable  mUSiteAvailable;

function String DebugName()
{
	return "Attack Target AoC";
}

function Setup()
{
	mUAttackTarget = new class'H7AiUtilityAttackTargetScore';
	mUSiteAvailable = new class'H7AiUtilitySiteAvailable';
	mABID=AID_AttackAoC;
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
	local H7AiHeroAgCompound  heroCfg;
	local H7VisitableSite       site;
	local H7AreaOfControlSiteVassal aocSiteVassal;
	local H7AreaOfControlSiteLord   aocSiteLord;
	local bool             suppressSite;
	local float            tensionValue, aocMod;

//	`LOG_AI("Action.AttackTargetAoC");

	sic = sensors.GetSensorIConsts();

	score.action = Self;
	score.score = 0.0f;
	
	hero=H7AdventureHero(currentUnit);
	if(hero!=None)
	{
		switch(hero.GetAiRole())
		{
			case HRL_GENERAL:   actionCfg = cfg.mAiAdvMapConfig.mConfigAttackAoC.General; break;
			case HRL_MAIN:      actionCfg = cfg.mAiAdvMapConfig.mConfigAttackAoC.Main; break;
			case HRL_SECONDARY: actionCfg = cfg.mAiAdvMapConfig.mConfigAttackAoC.Secondary; break;
			case HRL_SCOUT:     actionCfg = cfg.mAiAdvMapConfig.mConfigAttackAoC.Scout; break;
			case HRL_SUPPORT:   actionCfg = cfg.mAiAdvMapConfig.mConfigAttackAoC.Support; break;
			case HRL_MULE:      actionCfg = cfg.mAiAdvMapConfig.mConfigAttackAoC.Mule; break;
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

	tensionValue = hero.GetAdventureArmy().GetAiTensionValue(AID_AttackAoC);

	mUAttackTarget.mMovementEffortBias = actionCfg.MovementEffortBias;
	mUAttackTarget.mFightingEffortBias = actionCfg.FightingEffortBias;
	mUAttackTarget.mFightingEffortModifier = hero.GetPlayer().mDifficultyAIAggressivenessMultiplier;

	// for all site targets (that may have an defending army) ...
	numSites=sic.GetOppAoCSiteNum();
//	`LOG_AI("Num Sites:" @ numSites );
	for( k=0; k<numSites; k++ )
	{
		suppressSite=false;
		site=sic.GetOppAoCSite(k);
		if( CheckIfSiteIsLocked( site, hero ) ) { continue; }
//		`LOG_AI("  Site" @ sic.GetOppAoCSite(k) @ sic.GetOppAoCSite(k).GetName() @ site.GetPlayer().GetPlayerNumber() );

		if( site.IsA('H7Dwelling')==true || site.IsA('H7Mine')==true /*|| site.IsA('H7Garrison')==true*/ )
		{
			if( currentUnit.GetPlayer().IsPlayerAllied(site.GetPlayer())==false && currentUnit.GetPlayer() != site.GetPlayer() || site.GetPlayer().GetPlayerNumber()==PN_NEUTRAL_PLAYER )
			{
				aocSiteVassal=H7AreaOfControlSiteVassal(site);
				if(aocSiteVassal!=None)
				{
					aocSiteLord=aocSiteVassal.GetLord();
					if(aocSiteLord!=None)
					{
						if( site.IsA('H7Dwelling')==true || site.IsA('H7Mine')==true )
						{
							if( aocSiteLord.GetPlayer().GetPlayerNumber()!=PN_NEUTRAL_PLAYER &&
//								currentUnit.GetPlayer().IsPlayerAllied(aocSiteLord.GetPlayer())==false &&
								currentUnit.GetPlayer()!=aocSiteLord.GetPlayer() )
							{
								// cancel out neutral buildings that are in enemy controlled AoC
								suppressSite=true;
	//							`LOG_AI("AoC suppressed because of enemy controlled (flag-and-plunder)" @ aocSiteVassal.GetName() @ aocSiteVassal.GetPlayerNumber() @ aocSiteLord.GetName() @ aocSiteLord.GetPlayerNumber() );
							}
						}
					}
				}

				score.score =0.0f;
				score.dbgString = "Action.AttackTargetAoC; " $ sic.GetOppAoCSite(k) $ "; ";

				sic.SetTargetVisSite(sic.GetOppAoCSite(k),false);
				sic.SetTargetCellAdv(sic.GetOppAoCSite(k).GetEntranceCell());

				if( suppressSite==false )
				{
					aocMod=0.0f;

					mUSiteAvailable.UpdateInput();
					mUSiteAvailable.UpdateOutput();
					utSiteAvailable = mUSiteAvailable.GetOutValues();

					mUAttackTarget.UpdateInput();
					mUAttackTarget.UpdateOutput();
					utAttackTarget = mUAttackTarget.GetOutValues();
					if( utAttackTarget.Length >= 1 && utAttackTarget[0] > 0.0f )
					{
						aocMod=hero.GetPlayer().CalcAiAoCModifierFromTargetSite(actionCfg,sic.GetOppAoCSite(k));
						score.score = utAttackTarget[0] * utSiteAvailable[0] * heroCfg.AttackAoC * aocMod;
					}

					score.dbgString = score.dbgString $ "heroCfg.AttackAoC(" $ heroCfg.AttackAoC $ ") aocMod(" $ aocMod $ ") ";

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
}

function bool PerformAction( H7Unit unit, AiActionScore score )
{
	local H7AdventureController ctrl;
	local H7AdventureGridManager gridManager;
	local H7AdventureArmy army;
	local H7VisitableSite site;
	local H7AdventureHero   hero;

//	`LOG_AI("Action.AttackTargetAoC");

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

function bool CheckIfSiteIsLocked( H7VisitableSite site, H7AdventureHero evaluationHero )
{
	local array<H7AdventureHero> heroes;
	local H7AdventureHero hero;

	heroes = evaluationHero.GetPlayer().GetHeroes();

	foreach heroes( hero )
	{
		if( !hero.IsDead() && hero.IsHero() && hero != evaluationHero && hero.GetAiLastScoreAction() != none )
		{
			if( hero.GetAiLastScoreAction().GetAdvActionID() == AID_AttackAoC && hero.GetAiLastScoreParam().GetVisSite( APID_2 ) == site )
			{
				return true;
			}
		}
	}
	return false;
}
