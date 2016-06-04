//=============================================================================
// H7AiActionExplore
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionExplore extends H7AiActionBase;

var protected H7AiUtilityExplore            mUExplore;
var protected H7AiUtilityTeleportInterest   mUTeleportInterest;

function String DebugName()
{
	return "Explore";
}

function Setup()
{
	mUExplore = new class'H7AiUtilityExplore';
	mUTeleportInterest = new class'H7AiUtilityTeleportInterest';
	mABID=AID_Explore;
}

/// override function(s)

function RunScoresAdv( H7AiAdventureSensors sensors, H7Unit currentUnit, out array<AiActionScore> scores, optional H7AdventureConfiguration cfg )
{
	local int               k;
	local AiActionScore     score;
	local H7AiSensorInputConst    sic;
	local array<float>      utExplore;
	local int               numSites,numTeleporters, numArmies;
	local H7AdventureHero   hero;
	local H7AiConfigCompound  actionCfg;
	local H7AiHeroAgCompound2  heroCfg;
	local float            tensionValue, aocMod;

//	`LOG_AI("Action.Explore");

	sic = sensors.GetSensorIConsts();

	score.action = Self;
	score.score = 0.0f;
	
	hero=H7AdventureHero(currentUnit);
	if(hero!=None)
	{
		switch(hero.GetAiRole())
		{
			case HRL_GENERAL:   actionCfg = cfg.mAiAdvMapConfig.mConfigExplore.General; break;
			case HRL_MAIN:      actionCfg = cfg.mAiAdvMapConfig.mConfigExplore.Main; break;
			case HRL_SECONDARY: actionCfg = cfg.mAiAdvMapConfig.mConfigExplore.Secondary; break;
			case HRL_SCOUT:     actionCfg = cfg.mAiAdvMapConfig.mConfigExplore.Scout; break;
			case HRL_SUPPORT:   actionCfg = cfg.mAiAdvMapConfig.mConfigExplore.Support; break;
			case HRL_MULE:      actionCfg = cfg.mAiAdvMapConfig.mConfigExplore.Mule; break;
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

	tensionValue = hero.GetAdventureArmy().GetAiTensionValue(AID_Explore);

	mUExplore.mMovementEffortBias = actionCfg.MovementEffortBias;
	mUExplore.mFightingEffortBias = actionCfg.FightingEffortBias;

	sic.SetTargetVisSite(None);
	sic.SetTargetArmyAdv(None);
	sic.SetTargetTeleporter(None);

	// for all site targets (that may have an defending army) and are below the not explored fow ...
	numSites=sic.GetHiddenVisSiteNum();
//	`LOG_AI("Num Hidden Sites:" @ numSites );
	if(numSites>actionCfg.ProximityTargetLimit) numSites=actionCfg.ProximityTargetLimit;
	for( k = 0; k < numSites; k++ )
	{
//		`LOG_AI("  Site" @ sic.GetHiddenVisSite(k) @ sic.GetHiddenVisSite(k).GetName() );
		if( sic.GetHiddenVisSite(k).IsA('H7Teleporter')==true ) continue;

		score.score =0.0f;
		score.dbgString = "Action.Explore; " $  sic.GetHiddenVisSite(k) $ "; ";

		sic.SetTargetVisSite(sic.GetHiddenVisSite(k)); // that sets internally the targetArmy to
		sic.SetTargetCellAdv(sic.GetHiddenVisSite(k).GetEntranceCell());

		mUExplore.UpdateInput();
		mUExplore.UpdateOutput();
		utExplore = mUExplore.GetOutValues();
		if(utExplore.Length>=1 && utExplore[0]>0.0f)
		{
			aocMod=hero.GetPlayer().CalcAiAoCModifierFromTargetSite(actionCfg,sic.GetTargetVisSite());
			score.score = utExplore[0] * heroCfg.Explore * aocMod;
		}

		score.dbgString = score.dbgString $ "heroCfg.Explore(" $ heroCfg.Explore $ ") aocMod(" $ aocMod $ ") ";

		if( score.score > actionCfg.Cutoff )
		{
			score.params = new () class'H7AiActionParam';
			score.params.Clear();
			score.params.SetAdventureArmy( APID_1, sic.GetTargetArmyAdv() );
			score.params.SetVisSite( APID_2, sic.GetTargetVisSite( ) );
			score.tension = actionCfg.Tension.Base;

			score.dbgString = score.dbgString $ "actionCfg.Cutoff(" $ actionCfg.Cutoff $ ") " $ "actionCfg.Low-High(" $ actionCfg.Low $ ":" $ actionCfg.High $ ") ";

			if(score.score>1.0f) score.score=1.0f;
			score.score  = Lerp( actionCfg.Low, actionCfg.High, score.score );

			score.score *= tensionValue;
			score.dbgString = score.dbgString $ "Tension(" $ tensionValue $ ") FINAL SCORE:" $ score.score;

			scores.AddItem( score );
		}
	}

	sic.SetTargetVisSite(None);
	sic.SetTargetArmyAdv(None);
	sic.SetTargetTeleporter(None);

	// for all teleporter targets (that may have an defending army) and are below the not explored fow ...
	numTeleporters=sic.GetHiddenTeleportersNum();
//	`LOG_AI("Num Hidden Teleporters:" @ numTeleporters );
	if(numTeleporters>actionCfg.ProximityTargetLimit) numTeleporters=actionCfg.ProximityTargetLimit;
	for( k = 0; k < numTeleporters; k++ )
	{
//		`LOG_AI("  Teleporter" @ sic.GetHiddenTeleporter(k) );
		score.score =0.0f;
		score.dbgString = "Action.Explore; " $  sic.GetHiddenTeleporter(k) $ "; ";

		sic.SetTargetTeleporter(sic.GetHiddenTeleporter(k));
		sic.SetTargetCellAdv(sic.GetHiddenTeleporter(k).GetEntranceCell());

		mUTeleportInterest.UpdateInput();
		mUTeleportInterest.UpdateOutput();
		utExplore = mUTeleportInterest.GetOutValues();
		if(utExplore.Length>=1 && utExplore[0]>0.0f)
		{
			aocMod=hero.GetPlayer().CalcAiAoCModifierFromTargetSite(actionCfg,sic.GetHiddenTeleporter(k));
			score.score = utExplore[0] * heroCfg.Explore * aocMod;
		}

		score.dbgString = score.dbgString $ "heroCfg.Explore(" $ heroCfg.Explore $ ") aocMod(" $ aocMod $ ") ";

		if( score.score > actionCfg.Cutoff )
		{
			score.params = new () class'H7AiActionParam';
			score.params.Clear();
			score.params.SetAdventureArmy( APID_1, sic.GetTargetArmyAdv() );
			score.params.SetTeleporter( APID_3, sic.GetTargetTeleporter( ) );
			score.tension = actionCfg.Tension.Base;

			score.dbgString = score.dbgString $ "actionCfg.Cutoff(" $ actionCfg.Cutoff $ ") " $ "actionCfg.Low-High(" $ actionCfg.Low $ ":" $ actionCfg.High $ ") ";

			if(score.score>1.0f) score.score=1.0f;
			score.score  = Lerp( actionCfg.Low, actionCfg.High, score.score );

			score.score *= tensionValue;
			score.dbgString = score.dbgString $ "Tension(" $ tensionValue $ ") FINAL SCORE:" $ score.score;

			scores.AddItem( score );
		}
	}

	// for all hidden armies (border guards)
	numArmies=sic.GetHiddenArmyAdvNum();
	if(numArmies>actionCfg.ProximityTargetLimit) numArmies=actionCfg.ProximityTargetLimit;
	for( k=0; k<numArmies; k++ )
	{
		score.score =0.0f;
		score.dbgString = "Action.Explore; " $  sic.GetHiddenTeleporter(k) $ "; ";

		sic.SetTargetArmyAdv(sic.GetHiddenArmyAdv(k),false);
		if(sic.GetHiddenArmyAdv(k).GetGarrisonedSite()==None)
			sic.SetTargetCellAdv(sic.GetHiddenArmyAdv(k).GetCell());
		else
			sic.SetTargetCellAdv(sic.GetHiddenArmyAdv(k).GetGarrisonedSite().GetEntranceCell());

		mUExplore.UpdateInput();
		mUExplore.UpdateOutput();
		utExplore = mUExplore.GetOutValues();
		if(utExplore.Length>=1 && utExplore[0]>0.0f)
		{
			aocMod=hero.GetPlayer().CalcAiAoCModifierFromTargetArmy(actionCfg,sic.GetTargetArmyAdv());
			score.score = utExplore[0] * heroCfg.Explore * aocMod;
		}

		score.dbgString = score.dbgString $ "heroCfg.Explore(" $ heroCfg.Explore $ ") aocMod(" $ aocMod $ ") ";

		if( score.score > actionCfg.Cutoff )
		{
			score.params = new () class'H7AiActionParam';
			score.params.Clear();
			score.params.SetAdventureArmy( APID_1, sic.GetTargetArmyAdv() );
			score.params.SetVisSite( APID_2, sic.GetTargetVisSite() );
			score.tension = actionCfg.Tension.Base;

			score.dbgString = score.dbgString $ "actionCfg.Cutoff(" $ actionCfg.Cutoff $ ") " $ "actionCfg.Low-High(" $ actionCfg.Low $ ":" $ actionCfg.High $ ") ";

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
	local H7AdventureArmy army;
	local H7VisitableSite site;
	local H7Teleporter teleporter;
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
		teleporter = score.params.GetTeleporter(APID_3);
		if( army != None )
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			return gridManager.DoExplore( army.GetCell(),  true, true );
		}
		if( site != None )
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			return gridManager.DoExplore( site.GetEntranceCell(), true, true );
		}
		if( teleporter != None )
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			return gridManager.DoExplore( teleporter.GetEntranceCell(), true, true, true );
		}
	}
	return false;
}
