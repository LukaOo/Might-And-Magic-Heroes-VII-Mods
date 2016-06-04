//=============================================================================
// H7AiActionReinforce
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionReinforce extends H7AiActionBase;

var protected H7AiUtilityReinforceScore mUReinforce;

function String DebugName()
{
	return "Reinforce";
}

function Setup()
{
	mUReinforce = new class'H7AiUtilityReinforceScore';
	mABID=AID_Reinforce;
}

/// override function(s)

function RunScoresAdv( H7AiAdventureSensors sensors, H7Unit currentUnit, out array<AiActionScore> scores, optional H7AdventureConfiguration cfg )
{
	local int               k;
	local AiActionScore     score;
	local H7AiSensorInputConst    sic;
	local array<float>      utReinforce;
	local H7AdventureHero   hero;
	local H7AiConfigCompound  actionCfg;
	local H7AiHeroAgCompound2  heroCfg;
	local float            tensionValue, aocMod;

//	`LOG_AI("Action.Reinforce");

	sic = sensors.GetSensorIConsts();

	score.action = Self;
	score.score = 0.0f;

	hero=H7AdventureHero(currentUnit);
	if(hero!=None)
	{
		switch(hero.GetAiRole())
		{
			case HRL_GENERAL:   actionCfg = cfg.mAiAdvMapConfig.mConfigReinforce.General; break;
			case HRL_MAIN:      actionCfg = cfg.mAiAdvMapConfig.mConfigReinforce.Main; break;
			case HRL_SECONDARY: actionCfg = cfg.mAiAdvMapConfig.mConfigReinforce.Secondary; break;
			case HRL_SCOUT:     actionCfg = cfg.mAiAdvMapConfig.mConfigReinforce.Scout; break;
			case HRL_SUPPORT:   actionCfg = cfg.mAiAdvMapConfig.mConfigReinforce.Support; break;
			case HRL_MULE:      actionCfg = cfg.mAiAdvMapConfig.mConfigReinforce.Mule; break;
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

	tensionValue = hero.GetAdventureArmy().GetAiTensionValue(AID_Reinforce);

	mUReinforce.mMovementEffortBias=actionCfg.MovementEffortBias;
	mUReinforce.mReinforcementBias=actionCfg.ReinforcementBias;

	// for all player town targets via the army ...
	for( k = 0; k < sic.GetTownArmyNumAdv(); k++ )
	{
		if( sic.GetTownArmyAdv(k).GetCreatureAmountTotal() > 0  )
		{
//	`LOG_AI("HELLO TOWNARMY" @ sic.GetTownArmyAdv(k) @ "Strength" @ sic.GetTownArmyAdv(k).GetStrengthValue(true) );
			sic.SetTargetArmyAdv(sic.GetTownArmyAdv(k),false); // that sets internally the visitableSite to if its assigned
			if(sic.GetTargetVisSite()!=None)
			{
				sic.SetTargetCellAdv(sic.GetTargetVisSite().GetEntranceCell());
			}
			else if(sic.GetTownArmyAdv(k).GetVisitableSite()!=None)
			{
				sic.SetTargetCellAdv(sic.GetTownArmyAdv(k).GetVisitableSite().GetEntranceCell());
			}

			score.score = 0.0f;
			score.dbgString = "Action.Reinforce; " $ sic.GetTownArmyAdv(k) $ "; ";

			mUReinforce.UpdateInput();
			mUReinforce.UpdateOutput();
			utReinforce = mUReinforce.GetOutValues();
			if(utReinforce.Length>=1 && utReinforce[0]>0.0f) 
			{
				aocMod=hero.GetPlayer().CalcAiAoCModifierFromTargetSite(actionCfg,sic.GetTargetVisSite());
				score.score = utReinforce[0] * heroCfg.Reinforce * aocMod;

				if( sic.GetTownArmyAdv(k).GetHero().IsHero() == true )
				{
					score.score *= 0.25f;
				}
			}
			
			score.dbgString = score.dbgString $ "heroCfg.Reinforce(" $ heroCfg.Reinforce $ ") aocMod(" $ aocMod $ ") ";

			if( score.score > actionCfg.Cutoff )
			{
				score.params = new () class'H7AiActionParam';
				score.params.Clear();
				score.params.SetAdventureArmy( APID_1, sic.GetTargetArmyAdv() );
				score.params.SetVisSite( APID_2, sic.GetTargetVisSite( ) );
				score.tension = actionCfg.Tension.Base;

				score.dbgString = score.dbgString $ "actionCfg.Cutoff(" $ actionCfg.Cutoff $ ") " $ "actionCfg.Low-High(" $ actionCfg.Low $ ":" $ actionCfg.High $ ") " $ mUReinforce.dbgString;

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
	local H7AdventureGridManager gridManager;
	local H7VisitableSite site;
	local H7AdventureHero   hero;
	local H7HeroAbility spell;
	local H7Town town;
	local H7InstantCommandTeleportToTown command;

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	gridManager = class'H7AdventureGridManager'.static.GetInstance();

	if(unit!=None)
	{
		hero=H7AdventureHero(unit);
		if(hero!=None)
		{
		}

		site = score.params.GetVisSite(APID_2);
		town = H7Town( site );
		spell = hero.QuerySpellInstantRecall();
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		if( site!=None )
		{
			if( spell!=None && town!=None && 
				class'H7EffectPortalOfAsha'.static.GetClosestTown( hero ) == town )
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

				command = new class'H7InstantCommandTeleportToTown';
				command.Init(town, hero, spell.GetManaCost());
				class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);
				return gridManager.DoRecruitVisit( site.GetEntranceCell().GetLocation(), true );
			}
			else
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				return gridManager.DoRecruitVisit( site.GetEntranceCell().GetLocation(), true );
			}
		}
	}
	return false;
}
