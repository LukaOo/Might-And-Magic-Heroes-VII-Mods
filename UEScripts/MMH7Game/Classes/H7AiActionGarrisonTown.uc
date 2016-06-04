//=============================================================================
// H7AiActionGarrisonTown
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionGarrisonTown extends H7AiActionBase;

var protected H7AiUtilityGarrisonScore mUGarrison;

function String DebugName()
{
	return "Garrison Town";
}


function Setup()
{
	mUGarrison = new class'H7AiUtilityGarrisonScore';
	mABID=AID_Guard;
}

/// override function(s)

function RunScoresAdv( H7AiAdventureSensors sensors, H7Unit currentUnit, out array<AiActionScore> scores, optional H7AdventureConfiguration cfg )
{
	local int               k;
	local AiActionScore     score;
	local H7AiSensorInputConst    sic;
	local array<float>      utOut;
	local H7AdventureHero   hero;
	local H7AiConfigCompound  actionCfg;
	local H7AiHeroAgCompound2  heroCfg;
	local float            tensionValue, aocMod;

	sic = sensors.GetSensorIConsts();

	score.action = Self;
	score.score = 0.0f;

	hero=H7AdventureHero(currentUnit);
	if(hero!=None)
	{
		switch(hero.GetAiRole())
		{
			case HRL_GENERAL:   actionCfg = cfg.mAiAdvMapConfig.mConfigGuarding.General; break;
			case HRL_MAIN:      actionCfg = cfg.mAiAdvMapConfig.mConfigGuarding.Main; break;
			case HRL_SECONDARY: actionCfg = cfg.mAiAdvMapConfig.mConfigGuarding.Secondary; break;
			case HRL_SCOUT:     actionCfg = cfg.mAiAdvMapConfig.mConfigGuarding.Scout; break;
			case HRL_SUPPORT:   actionCfg = cfg.mAiAdvMapConfig.mConfigGuarding.Support; break;
			case HRL_MULE:      actionCfg = cfg.mAiAdvMapConfig.mConfigGuarding.Mule; break;
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

	tensionValue = hero.GetAdventureArmy().GetAiTensionValue(AID_Guard);

	mUGarrison.mMovementEffortBias=actionCfg.MovementEffortBias;

	// for all player towns
	for( k = 0; k < sic.GetTownsNum(); k++ )
	{
		score.score = 0.0f;
		score.dbgString = "Action.GarrisonTown; " $  sic.GetTown(k) $ "; ";

		sic.SetTargetVisSite(sic.GetTown(k),true);
		sic.SetTargetCellAdv(sic.GetTown(k).GetEntranceCell());

		mUGarrison.UpdateInput();
		mUGarrison.UpdateOutput();
		utOut = mUGarrison.GetOutValues();
		if(utOut.Length>0)
		{
			aocMod=hero.GetPlayer().CalcAiAoCModifierFromTargetSite(actionCfg,sic.GetTargetVisSite());
			score.score = utOut[0] * heroCfg.Guard * aocMod;
		}
 
		score.dbgString = score.dbgString $ "heroCfg.Guard(" $ heroCfg.Guard $ ") aocMod(" $ aocMod $ ") ";

		if( score.score > actionCfg.Cutoff )
		{
			score.params = new () class'H7AiActionParam';
			score.params.Clear();
			score.params.SetVisSite( APID_1, sic.GetTargetVisSite( ) );
			score.tension = actionCfg.Tension.Base;

			score.dbgString = score.dbgString $ "actionCfg.Cutoff(" $ actionCfg.Cutoff $ ") " $ "actionCfg.Low-High(" $ actionCfg.Low $ ":" $ actionCfg.High $ ") " $ mUGarrison.dbgString;

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

		site = score.params.GetVisSite(APID_1);
		if( site != None )
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			return gridManager.DoGarrisonVisit( site.GetEntranceCell().GetLocation(), true, true );
		}
	}
	return false;
}
