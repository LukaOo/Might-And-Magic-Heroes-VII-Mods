//=============================================================================
// H7AiActionAttackTargetCity
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionAttackTargetCity extends H7AiActionBase;

var protected H7AiUtilityAttackTargetScore  mUAttackTarget;
var protected H7AiUtilitySuicideAttackTargetScore mUSuicideAttackTarget;
var protected H7AiUtilitySiteAvailable  mUSiteAvailable;

function String DebugName()
{
	return "Attack Target City";
}

function Setup()
{
	mUAttackTarget = new class'H7AiUtilityAttackTargetScore';
	mUSuicideAttackTarget = new class'H7AiUtilitySuicideAttackTargetScore';
	mUSiteAvailable = new class'H7AiUtilitySiteAvailable';
	mABID=AID_AttackCity;
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
	local bool             boostTownTargets, crusadeTarget;
	local float            tensionValue, aocMod, powerBalanceValue;
	local array<H7AdventureArmy> myArmies, myRealArmies;
	local H7AdventureArmy myArmy;
	local array<H7VisitableSite> reachableSites;
	local int reachableIndex;

//	`LOG_AI("Action.AttackTargetCity");

	sic = sensors.GetSensorIConsts();

	score.action = Self;
	score.score = 0.0f;
	
	hero=H7AdventureHero(currentUnit);
	if(hero!=None)
	{
		switch(hero.GetAiRole())
		{
			case HRL_GENERAL:   actionCfg = cfg.mAiAdvMapConfig.mConfigAttackCity.General; break;
			case HRL_MAIN:      actionCfg = cfg.mAiAdvMapConfig.mConfigAttackCity.Main; break;
			case HRL_SECONDARY: actionCfg = cfg.mAiAdvMapConfig.mConfigAttackCity.Secondary; break;
			case HRL_SCOUT:     actionCfg = cfg.mAiAdvMapConfig.mConfigAttackCity.Scout; break;
			case HRL_SUPPORT:   actionCfg = cfg.mAiAdvMapConfig.mConfigAttackCity.Support; break;
			case HRL_MULE:      actionCfg = cfg.mAiAdvMapConfig.mConfigAttackCity.Mule; break;
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

	myArmies = hero.GetPlayer().GetArmies();

	foreach myArmies( myArmy )
	{
		if( myArmy.GetHero().IsHero() && !myArmy.IsGarrisoned() )
		{
			myRealArmies.AddItem( myArmy );
		}
	}
	
	mUAttackTarget.mMovementEffortBias = actionCfg.MovementEffortBias;
	mUAttackTarget.mFightingEffortBias = actionCfg.FightingEffortBias;
	mUAttackTarget.mFightingEffortModifier = hero.GetPlayer().mDifficultyAIAggressivenessMultiplier;
	mUSuicideAttackTarget.mMovementEffortBias = actionCfg.MovementEffortBias;
	mUSuicideAttackTarget.mFightingEffortBias = actionCfg.FightingEffortBias;

	// for all site targets (that may have an defending army) ...
	numSites=sic.GetOppAoCSiteNum();
	//	`LOG_AI("Num Sites:" @ numSites );
	for( k = 0; k < numSites; k++ )
	{
		site=sic.GetOppAoCSite(k);
		foreach myRealArmies( myArmy )
		{
			reachableSites = myArmy.GetReachableSites();
			reachableIndex = reachableSites.Find( site );
			if( reachableIndex != INDEX_NONE )
			{
				
			}
		}

//		`LOG_AI("  Site" @ sic.GetOppAoCSite(k) @ sic.GetOppAoCSite(k).GetName() @ site.GetPlayer().GetPlayerNumber() );

		crusadeTarget=false;
		if( site.IsA('H7Town') == true || site.IsA('H7Fort') == true )
		{
			if( site.IsA('H7Town')==true)
			{
				crusadeTarget=H7Town(site).GetAiIsCrusadeTarget();
				boostTownTargets = sic.GetTownsNum()>=1 ? false : true;
			}

			if( currentUnit.GetPlayer().IsPlayerAllied(site.GetPlayer())==false && site.GetPlayer() != currentUnit.GetPlayer() || site.GetPlayer().GetPlayerNumber() == PN_NEUTRAL_PLAYER )
			{
				score.score =0.0f;
				score.dbgString = "Action.AttackTargetCity; " $ sic.GetOppAoCSite(k) $ "; ";

				sic.SetTargetVisSite(sic.GetOppAoCSite(k),false); // that sets internally the targetArmy to. If set we already covered the scoring by attack target army
				sic.SetTargetCellAdv(sic.GetOppAoCSite(k).GetEntranceCell());

				mUSiteAvailable.UpdateInput();
				mUSiteAvailable.UpdateOutput();
				utSiteAvailable = mUSiteAvailable.GetOutValues();

				if(crusadeTarget==false && boostTownTargets==false)
				{
					mUAttackTarget.UpdateInput();
					mUAttackTarget.UpdateOutput();
					utAttackTarget = mUAttackTarget.GetOutValues();

					tensionValue = hero.GetAdventureArmy().GetAiTensionValue(AID_AttackCity);
				}
				else // for this cases we just like to know if we can get there or not and if we have at least a skeleton army available
				{
					mUSuicideAttackTarget.UpdateInput();
					mUSuicideAttackTarget.UpdateOutput();
					utAttackTarget = mUSuicideAttackTarget.GetOutValues();

					tensionValue = 5.0f;

					score.dbgString = score.dbgString $ " *SUICIDE* ";
				}

				if(utAttackTarget.Length>0 && utSiteAvailable[0]>0 )
				{
					//utAttackTarget[0] /= fightingEffort[0];

					

					//utAttackTarget[0] *= fightingEffort[0];
					
					aocMod=hero.GetPlayer().CalcAiAoCModifierFromTargetSite(actionCfg,sic.GetTargetVisSite());
					score.score = utAttackTarget[0] * utSiteAvailable[0] * heroCfg.AttackCity * aocMod;
				}
				else
				{
					score.score = 0.0f;
				}

				score.dbgString = score.dbgString $ "heroCfg.AttackCity(" $ heroCfg.AttackCity $ ") aocMod(" $ aocMod $ ") ";

				if( score.score > actionCfg.Cutoff )
				{
					score.params = new () class'H7AiActionParam';
					score.params.Clear();
					score.params.SetAdventureArmy( APID_1, sic.GetTargetArmyAdv() );
					score.params.SetVisSite( APID_2, sic.GetTargetVisSite( ) );
					score.tension = actionCfg.Tension.Base;

					if(crusadeTarget==false && boostTownTargets==false)
						score.dbgString = score.dbgString $ "actionCfg.Cutoff(" $ actionCfg.Cutoff $ ") " $ "actionCfg.Low-High(" $ actionCfg.Low $ ":" $ actionCfg.High $ ") " $ mUAttackTarget.dbgString;
					else
						score.dbgString = score.dbgString $ "actionCfg.Cutoff(" $ actionCfg.Cutoff $ ") " $ "actionCfg.Low-High(" $ actionCfg.Low $ ":" $ actionCfg.High $ ") " $ mUSuicideAttackTarget.dbgString;



					if(score.score>1.0f) score.score=1.0f;
					score.score  = Lerp( actionCfg.Low, actionCfg.High, score.score );
					score.score *= tensionValue;

					if( hero.GetPlayer().GetAiPowerBalance() > 0.5f )
					{
						powerBalanceValue = ( 0.5f + hero.GetPlayer().GetAiPowerBalance() );
						score.score *= powerBalanceValue;
						score.dbgString = score.dbgString $ "GeneralPB(" $ powerBalanceValue $ ") ";
					}

					if( hero.GetPlayer().GetAiPowerBalance() > site.GetPlayer().GetAiPowerBalance() && !site.GetPlayer().IsNeutralPlayer() )
					{
						powerBalanceValue = ( 1.0f + ( hero.GetPlayer().GetAiPowerBalance() - site.GetPlayer().GetAiPowerBalance() ) );
						score.score *= powerBalanceValue;
						score.dbgString = score.dbgString $ "RelativePB(" $ powerBalanceValue $ ") ";
					}


					score.dbgString = score.dbgString $ "Tension(" $ tensionValue $ ") FINAL SCORE:" $ score.score;

					scores.AddItem( score );
				}
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
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

//	`LOG_AI("Action.AttackTargetCity");

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
