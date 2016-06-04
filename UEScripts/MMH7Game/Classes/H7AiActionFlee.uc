//=============================================================================
// H7AiActionFlee
//=============================================================================
// score flee when 
//    enemy hero can reach the hero within one turn
//    EnemyStrength > HeroStrength
// to town that is
//    next closest
//    not threatened higher than threshold
// else to main hero when not already in his vicinity
// advanced: objects that can be reached by a stronger hero are not scored
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionFlee extends H7AiActionBase;

var protected H7AiUtilityFleeScore          mUFleeScore;

function String DebugName()
{
	return "Flee";
}

function Setup()
{
	mUFleeScore = new class'H7AiUtilityFleeScore';
	mABID=AID_Flee;
}

/// override function(s)

function RunScoresAdv( H7AiAdventureSensors sensors, H7Unit currentUnit, out array<AiActionScore> scores, optional H7AdventureConfiguration cfg )
{
	local int               k,l;
	local AiActionScore     score;
	local H7AiSensorInputConst    sic;
	local array<float>      utFlee;
	local int               numArmies;
	local int               numTowns, numAoC, numHeroes; //, numShelter;
	local H7AdventureHero   hero, targetHero;
	local H7AdventureArmy   army;
	local H7Town            town;
	local H7VisitableSite   site;
	local H7AiConfigCompound  actionCfg;
	local H7AiHeroAgCompound2  heroCfg;
	local float            tensionValue, aocMod;

//	`LOG_AI("Action.Flee");

	sic = sensors.GetSensorIConsts();

	score.action = Self;
	score.score = 0.0f;
	
	hero=H7AdventureHero(currentUnit);
	if(hero!=None)
	{
		switch(hero.GetAiRole())
		{
			case HRL_GENERAL:   actionCfg = cfg.mAiAdvMapConfig.mConfigFlee.General; break;
			case HRL_MAIN:      actionCfg = cfg.mAiAdvMapConfig.mConfigFlee.Main; break;
			case HRL_SECONDARY: actionCfg = cfg.mAiAdvMapConfig.mConfigFlee.Secondary; break;
			case HRL_SCOUT:     actionCfg = cfg.mAiAdvMapConfig.mConfigFlee.Scout; break;
			case HRL_SUPPORT:   actionCfg = cfg.mAiAdvMapConfig.mConfigFlee.Support; break;
			case HRL_MULE:      actionCfg = cfg.mAiAdvMapConfig.mConfigFlee.Mule; break;
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

	// look for recall spell and set it
	sic.SetUseHeroAbility(hero.QuerySpellInstantRecall());

	tensionValue = hero.GetAdventureArmy().GetAiTensionValue(AID_Flee);

	mUFleeScore.mMovementEffortBias=actionCfg.MovementEffortBias;
	mUFleeScore.mFightingEffortBias=actionCfg.FightingEffortBias;

	// for all enemy player armies
	numArmies=sic.GetArmyNumAdv();
	numTowns=sic.GetTownsNum();
	numAoC=sic.GetAoCSiteNum();
	//numShelter=sic.GetShelterSiteNum();
	numHeroes=sic.GetOwnHeroesNum();
	if(numArmies>actionCfg.ProximityTargetLimit) numArmies=actionCfg.ProximityTargetLimit;
	for(k=0;k<numArmies;k++)
	{
		army=sic.GetOtherArmyAdv(k);
		if(army!=None && army.GetPlayerNumber()!=PN_NEUTRAL_PLAYER && !army.IsAllyOf(currentUnit.GetPlayer()) && army.GetHero()!=None && army.GetHero().IsHero()==true &&
		   army.HasUnits()==true)
		{
			// for all owned towns
			for(l=0;l<numTowns;l++)
			{
				town=sic.GetTown(l);

				score.score =0.0f;
				score.dbgString = "Action.Flee; " $  army $ "- (town)" $ town.GetName() $ "; ";

				sic.SetTargetArmyAdv(army,true);
				sic.SetTargetVisSite(town,true);
				sic.SetTargetTown(town);
				sic.SetTargetCellAdv(town.GetEntranceCell());

				mUFleeScore.checkForSite=true;
				mUFleeScore.UpdateInput();
				mUFleeScore.UpdateOutput();
				utFlee = mUFleeScore.GetOutValues();
				if(utFlee.Length>=1 && utFlee[0]>0.0f)
				{
					aocMod=hero.GetPlayer().CalcAiAoCModifierFromTargetSite(actionCfg,sic.GetTargetVisSite());
					score.score = utFlee[0] * heroCfg.Flee * aocMod;
				}

				score.dbgString = score.dbgString $ "heroCfg.Flee(" $ heroCfg.Flee $ ") aocMod(" $ aocMod $ ") ";

				if(score.score > actionCfg.Cutoff)
				{
					score.params = new () class'H7AiActionParam';
					score.params.Clear();
					score.params.SetAdventureArmy( APID_1, sic.GetTargetArmyAdv() );
					score.params.SetVisSite( APID_2, sic.GetTargetVisSite( ) );
					if( mUFleeScore.usedRecall==true )
					{
						score.params.SetAbility( APID_3, sic.GetUseHeroAbility() );
						score.dbgString = score.dbgString $ "(recall) ";
					}

					score.tension = actionCfg.Tension.Base;

					score.dbgString = score.dbgString $ "actionCfg.Cutoff(" $ actionCfg.Cutoff $ ") " $ "actionCfg.Low-High(" $ actionCfg.Low $ ":" $ actionCfg.High $ ") " $ mUFleeScore.dbgString;

					if(score.score>1.0f) score.score=1.0f;
					score.score  = Lerp( actionCfg.Low, actionCfg.High, score.score );

					score.score *= tensionValue;
					score.dbgString = score.dbgString $ "Tension(" $ tensionValue $ ") FINAL SCORE:" $ score.score;

					scores.AddItem( score );
				}
			}
			// for all forts
			for(l=0;l<numAoC;l++)
			{
				site=sic.GetAoCSite(l);
				if(site==None || site.IsA('H7Fort')==false)
				{
					continue;
				}

				score.score =0.0f;
				score.dbgString = "Action.Flee; " $  army $ "- (fort)" $ H7Fort(site).GetName() $ "; ";

				sic.SetTargetArmyAdv(army,true);
				sic.SetTargetVisSite(site,true);
				sic.SetTargetCellAdv(site.GetEntranceCell());

				mUFleeScore.checkForSite=true;
				mUFleeScore.UpdateInput();
				mUFleeScore.UpdateOutput();
				utFlee = mUFleeScore.GetOutValues();
				if(utFlee.Length>=1 && utFlee[0]>0.0f)
				{
					aocMod=hero.GetPlayer().CalcAiAoCModifierFromTargetSite(actionCfg,sic.GetTargetVisSite());
					score.score = utFlee[0] * heroCfg.Flee * aocMod;
				}

				score.dbgString = score.dbgString $ "heroCfg.Flee(" $ heroCfg.Flee $ ") aocMod(" $ aocMod $ ") ";

				if(score.score > actionCfg.Cutoff)
				{
					score.params = new () class'H7AiActionParam';
					score.params.Clear();
					score.params.SetAdventureArmy( APID_1, sic.GetTargetArmyAdv() );
					score.params.SetVisSite( APID_2, sic.GetTargetVisSite( ) );
					if( mUFleeScore.usedRecall==true )
					{
						score.params.SetAbility( APID_3, sic.GetUseHeroAbility() );
						score.dbgString = score.dbgString $ "(recall) ";
					}

					score.tension = actionCfg.Tension.Base;

					score.dbgString = score.dbgString $ "actionCfg.Cutoff(" $ actionCfg.Cutoff $ ") " $ "actionCfg.Low-High(" $ actionCfg.Low $ ":" $ actionCfg.High $ ") " $ mUFleeScore.dbgString;

					if(score.score>1.0f) score.score=1.0f;
					score.score  = Lerp( actionCfg.Low, actionCfg.High, score.score );

					score.score *= tensionValue;
					score.dbgString = score.dbgString $ "Tension(" $ tensionValue $ ") FINAL SCORE:" $ score.score;

					scores.AddItem( score );
				}
			}
			// for all shelters if we have a town
			/* DISABLED FOR NOW DUE TO 'BUGS'
			if(sic.GetTownsNum()>=1)
			{
				for(l=0;l<numShelter;l++)
				{
					site=sic.GetShelterSite(l);

					score.score =0.0f;
					score.dbgString = "Action.Flee; " $  army $ "- (shelter)" $ H7Shelter(site).GetName() $ "; ";

					sic.SetTargetArmyAdv(army,true);
					sic.SetTargetVisSite(site,true);
					sic.SetTargetCellAdv(site.GetEntranceCell());

					mUFleeScore.checkForSite=true;
					mUFleeScore.UpdateInput();
					mUFleeScore.UpdateOutput();
					utFlee = mUFleeScore.GetOutValues();
					if(utFlee.Length>=1 && utFlee[0]>0.0f)
					{
						aocMod=hero.GetPlayer().CalcAiAoCModifierFromTargetSite(actionCfg,sic.GetTargetVisSite());
						score.score = utFlee[0] * heroCfg.Flee * aocMod;
					}

					score.dbgString = score.dbgString $ "heroCfg.Flee(" $ heroCfg.Flee $ ") aocMod(" $ aocMod $ ") ";

					if(score.score > actionCfg.Cutoff)
					{
						score.params = new () class'H7AiActionParam';
						score.params.Clear();
						score.params.SetAdventureArmy( APID_1, sic.GetTargetArmyAdv() );
						score.params.SetVisSite( APID_2, sic.GetTargetVisSite( ) );
						if( mUFleeScore.usedRecall==true )
						{
							score.params.SetAbility( APID_3, sic.GetUseHeroAbility() );
							score.dbgString = score.dbgString $ "(recall) ";
						}

						score.tension = actionCfg.Tension.Base;

						score.dbgString = score.dbgString $ "actionCfg.Cutoff(" $ actionCfg.Cutoff $ ") " $ "actionCfg.Low-High(" $ actionCfg.Low $ ":" $ actionCfg.High $ ") " $ mUFleeScore.dbgString;

						if(score.score>1.0f) score.score=1.0f;
						score.score  = Lerp( actionCfg.Low, actionCfg.High, score.score );

						score.score *= tensionValue;
						score.dbgString = score.dbgString $ "Tension(" $ tensionValue $ ") FINAL SCORE:" $ score.score;

						scores.AddItem( score );
					}
				}
			}
			*/
			// for main hero
			for(l=0;l<numHeroes;l++)
			{
				targetHero=sic.GetOwnHeroes(l);
				if(targetHero==None || (targetHero.GetAiRole()!=HRL_MAIN && targetHero.GetAiRole()!=HRL_GENERAL && targetHero.GetAiRole()!=HRL_SECONDARY) || targetHero==hero || targetHero.GetAdventureArmy().IsGarrisoned()==true )
				{
					continue;
				}

				score.score =0.0f;
				score.dbgString = "Action.Flee; " $ army $ "- (hero)" $ targetHero.GetName() $ "; ";

				sic.SetTargetArmyAdv(army,true);
				sic.SetTargetVisSite(None,true);
				sic.SetTargetCellAdv(army.GetCell());
				
				mUFleeScore.checkForSite=false;
				mUFleeScore.UpdateInput();
				mUFleeScore.UpdateOutput();
				utFlee = mUFleeScore.GetOutValues();
				if(utFlee.Length>=1 && utFlee[0]>0.0f)
				{
					aocMod=hero.GetPlayer().CalcAiAoCModifierFromTargetArmy(actionCfg,sic.GetTargetArmyAdv());
					score.score = utFlee[0] * heroCfg.Flee * aocMod;
				}

				score.dbgString = score.dbgString $ "heroCfg.Flee(" $ heroCfg.Flee $ ") aocMod(" $ aocMod $ ") ";

				if(score.score > actionCfg.Cutoff)
				{
					score.params = new () class'H7AiActionParam';
					score.params.Clear();
					score.params.SetAdventureArmy( APID_1, sic.GetTargetArmyAdv() );
					score.params.SetVisSite( APID_2, sic.GetTargetVisSite( ) );
					if( mUFleeScore.usedRecall==true )
					{
						score.params.SetAbility( APID_3, sic.GetUseHeroAbility() );
						score.dbgString = score.dbgString $ "(recall) ";
					}

					score.tension = actionCfg.Tension.Base;

					score.dbgString = score.dbgString $ "actionCfg.Cutoff(" $ actionCfg.Cutoff $ ") " $ "actionCfg.Low-High(" $ actionCfg.Low $ ":" $ actionCfg.High $ ") " $ mUFleeScore.dbgString;

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
	local H7VisitableSite site;
	local H7HeroAbility spell;
	local H7InstantCommandTeleportToTown command;
	local H7AdventureHero   hero;
	local H7Town town;
	local H7Fort fort;
	local H7Shelter shelter;

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	ctrl = class'H7AdventureController'.static.GetInstance();
	gridManager = class'H7AdventureGridManager'.static.GetInstance();

	if( unit != None && ctrl != None )
	{
		hero=H7AdventureHero(unit);
		if(hero!=None)
		{
		}

		site = score.params.GetVisSite(APID_2);
		town = H7Town(site);
		fort = H7Fort(site);
		shelter = H7Shelter(site);
		spell = H7HeroAbility(score.params.GetAbility(APID_3));
		if(site!=None)
		{
			if( spell!=None && town!=None && 
				town.IsBuildingBuiltByClass(class'H7TownPortal') && 
				town.GetEntranceCell().GetArmy() == none && 
				town.GetEntranceCell().GetGridOwner() == hero.GetAdventureArmy().GetCell().GetGridOwner() )
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

				command = new class'H7InstantCommandTeleportToTown';
				command.Init(town, hero, spell.GetManaCost());
				class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);
				if( hero.GetAdventureArmy().GetCell() == site.GetEntranceCell() )
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				if( town!=None )
				{
					if( town.GetGarrisonArmy()==None || (town.GetGarrisonArmy().GetHero()!=None && town.GetGarrisonArmy().GetHero().IsHero()==false) )
					{
						if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
						return gridManager.DoGarrisonVisit( town.GetEntranceCell().GetLocation(), true, true );
					}
					else
					{
						if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
						return gridManager.DoVisit( town, true, true );
					}
				}
				else if( fort!=None )
				{
					if( fort.GetGarrisonArmy()==None || (fort.GetGarrisonArmy().GetHero()!=None && fort.GetGarrisonArmy().GetHero().IsHero()==false) )
					{
						if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
						return gridManager.DoGarrisonVisit( fort.GetEntranceCell().GetLocation(), true, true );
					}
					else
					{
						if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
						return gridManager.DoVisit( fort, true, true );
					}
				}
				else if( shelter!=None )
				{
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
					return gridManager.DoVisit( shelter, true, true );
				}
			}
		}
	}
	return false;
}
