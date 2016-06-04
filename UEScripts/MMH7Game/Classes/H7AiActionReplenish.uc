//=============================================================================
// H7AiActionReplenish
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionReplenish extends H7AiActionBase;

var protected H7AiUtilityReplenishScore mUReplenish;

function String DebugName()
{
	return "Replenish";
}


function Setup()
{
	mUReplenish = new class'H7AiUtilityReplenishScore';
	mABID=AID_Replenish;
}

/// override function(s)

function RunScoresAdv( H7AiAdventureSensors sensors, H7Unit currentUnit, out array<AiActionScore> scores, optional H7AdventureConfiguration cfg )
{
	local int               k;
	local AiActionScore     score;
	local H7AiSensorInputConst    sic;
	local array<float>      uReplenish;
	local H7AdventureHero   hero;
	local H7AiConfigCompound  actionCfg;
	local H7AiHeroAgCompound2  heroCfg;
	local H7VisitableSite   site;
	local float            tensionValue, aocMod;

	sic = sensors.GetSensorIConsts();

	score.action = Self;
	score.score = 0.0f;

	hero=H7AdventureHero(currentUnit);
	if(hero!=None)
	{
		switch(hero.GetAiRole())
		{
			case HRL_GENERAL:   actionCfg = cfg.mAiAdvMapConfig.mConfigReplenish.General; break;
			case HRL_MAIN:      actionCfg = cfg.mAiAdvMapConfig.mConfigReplenish.Main; break;
			case HRL_SECONDARY: actionCfg = cfg.mAiAdvMapConfig.mConfigReplenish.Secondary; break;
			case HRL_SCOUT:     actionCfg = cfg.mAiAdvMapConfig.mConfigReplenish.Scout; break;
			case HRL_SUPPORT:   actionCfg = cfg.mAiAdvMapConfig.mConfigReplenish.Support; break;
			case HRL_MULE:      actionCfg = cfg.mAiAdvMapConfig.mConfigReplenish.Mule; break;
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

	tensionValue = hero.GetAdventureArmy().GetAiTensionValue(AID_Replenish);

	mUReplenish.mMovementEffortBias=actionCfg.MovementEffortBias;

	// for all player towns
	for( k=0; k<sic.GetTownsNum(); k++ )
	{
		score.score = 0.0f;
		score.dbgString = "Action.Replenish; " $  sic.GetTown(k).GetName() $ "; ";

		sic.SetTargetVisSite(sic.GetTown(k),true);
		sic.SetTargetCellAdv(sic.GetTown(k).GetEntranceCell());

		mUReplenish.UpdateInput();
		mUReplenish.UpdateOutput();
		uReplenish = mUReplenish.GetOutValues();

		if(uReplenish.Length>0 && uReplenish[0]>0.0f)
		{
			aocMod=hero.GetPlayer().CalcAiAoCModifierFromTargetSite(actionCfg,sic.GetTargetVisSite());
			score.score = uReplenish[0] * heroCfg.Replenish * aocMod;
		}

		score.dbgString = score.dbgString $ "heroCfg.Replenish(" $ heroCfg.Replenish $ ") aocMod(" $ aocMod $ ") ";

		if( score.score > actionCfg.Cutoff )
		{
			score.params = new () class'H7AiActionParam';
			score.params.Clear();
			score.params.SetVisSite( APID_1, sic.GetTargetVisSite() );
			score.tension = actionCfg.Tension.Base;

			score.dbgString = score.dbgString $ "actionCfg.Cutoff(" $ actionCfg.Cutoff $ ") " $ "actionCfg.Low-High(" $ actionCfg.Low $ ":" $ actionCfg.High $ ") " $ mUReplenish.dbgString;

			if(score.score>1.0f) score.score=1.0f;
			score.score  = Lerp( actionCfg.Low, actionCfg.High, score.score );

			score.score *= tensionValue;
			score.dbgString = score.dbgString $ "Tension(" $ tensionValue $ ") FINAL SCORE:" $ score.score;

			scores.AddItem( score );
		}
	}
	// for all external dwellings (upgraded)
	for( k=0; k<sic.GetAoCSiteNum(); k++ )
	{
		site=sic.GetAoCSite(k);
		if(site!=None && site.IsA('H7Dwelling')==true)
		{
			if(H7Dwelling(site).IsUpgraded()==true)
			{
				score.score = 0.0f;
				score.dbgString = "Action.Replenish; " $  sic.GetAoCSite(k).GetName() $ "; ";

				sic.SetTargetVisSite(sic.GetAoCSite(k),true);
				sic.SetTargetCellAdv(sic.GetAoCSite(k).GetEntranceCell());

				mUReplenish.UpdateInput();
				mUReplenish.UpdateOutput();
				uReplenish = mUReplenish.GetOutValues();

				if(uReplenish.Length>0 && uReplenish[0]>0.0f)
				{
					aocMod=hero.GetPlayer().CalcAiAoCModifierFromTargetSite(actionCfg,sic.GetTargetVisSite());
					score.score = uReplenish[0] * heroCfg.Replenish * aocMod;
				}

				score.dbgString = score.dbgString $ "heroCfg.Replenish(" $ heroCfg.Replenish $ ") aocMod(" $ aocMod $ ") ";

				if( score.score > actionCfg.Cutoff )
				{
					score.params = new () class'H7AiActionParam';
					score.params.Clear();
					score.params.SetVisSite( APID_1, sic.GetTargetVisSite() );
					score.tension = actionCfg.Tension.Base;

					score.dbgString = score.dbgString $ "actionCfg.Cutoff(" $ actionCfg.Cutoff $ ") " $ "actionCfg.Low-High(" $ actionCfg.Low $ ":" $ actionCfg.High $ ") " $ mUReplenish.dbgString;

					if(score.score>1.0f) score.score=1.0f;
					score.score  = Lerp( actionCfg.Low, actionCfg.High, score.score );

					score.score *= tensionValue;
					score.dbgString = score.dbgString $ "Tension(" $ tensionValue $ ") FINAL SCORE:" $ score.score;

					scores.AddItem( score );
				}
			}
		}
	}
	// for all training sites
	for( k=0; k<sic.GetTrainingSiteNum(); k++ )
	{
		score.score = 0.0f;
		score.dbgString = "Action.Replenish; " $  sic.GetTrainingSite(k).GetName() $ "; ";

		sic.SetTargetVisSite(sic.GetTrainingSite(k),true);
		sic.SetTargetCellAdv(sic.GetTrainingSite(k).GetEntranceCell());

		mUReplenish.UpdateInput();
		mUReplenish.UpdateOutput();
		uReplenish = mUReplenish.GetOutValues();

		if(uReplenish.Length>0 && uReplenish[0]>0.0f)
		{
			aocMod=hero.GetPlayer().CalcAiAoCModifierFromTargetSite(actionCfg,sic.GetTargetVisSite());
			score.score = uReplenish[0] * heroCfg.Replenish * aocMod;
		}

		score.dbgString = score.dbgString $ "heroCfg.Replenish(" $ heroCfg.Replenish $ ") aocMod(" $ aocMod $ ") ";

		if( score.score > actionCfg.Cutoff )
		{
			score.params = new () class'H7AiActionParam';
			score.params.Clear();
			score.params.SetVisSite( APID_1, sic.GetTargetVisSite() );
			score.tension = actionCfg.Tension.Base;

			score.dbgString = score.dbgString $ "actionCfg.Cutoff(" $ actionCfg.Cutoff $ ") " $ "actionCfg.Low-High(" $ actionCfg.Low $ ":" $ actionCfg.High $ ") " $ mUReplenish.dbgString;

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
			HandlePreUpgradeVisit( site, hero.GetAdventureArmy() );
			return gridManager.DoUpgradeVisit(site,true,true);
		}
	}
	return false;
}

function HandlePreUpgradeVisit( H7VisitableSite site, H7AdventureArmy army )
{
	local H7Dwelling                    dwelling;
	local H7Town                        town;
	local H7TrainingGrounds             training;
	local array<H7BaseCreatureStack>    cstacks;
	local H7BaseCreatureStack           stack;
	local array<H7ResourceQuantity>     upgRes;
	local H7ResourceQuantity            upgResQ;
	local int                           numOfUpgCreatures;
	//local H7ResourceSet                 resourceSetClone;

	//resourceSetClone = new class'H7ResourceSet'( site.GetPlayer().GetResourceSet() );

    if( site.IsA('H7Town')==true )
	{
		town=H7Town(site);
		// go through all creature stacks
		cstacks=army.GetBaseCreatureStacks();
		foreach cstacks(stack)
		{
			if(stack!=None)
			{
				upgRes=town.GetUpgradeInfo(false,numOfUpgCreatures,stack);
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				if(stack.GetStackType().GetUpgradedCreature()!=None && town.HasRequiredDwelling(stack.GetStackType().GetUpgradedCreature())==true)
				{
					if( upgRes.Length > 0 && site.GetPlayer().GetResourceSet().CanSpendResources(upgRes) == true && numOfUpgCreatures == stack.GetStackSize() && !stack.IsLockedForUpgrade() )
					{
						if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
						stack.SetLockedForUpgrade( true );
						site.GetPlayer().GetResourceSet().SpendResources( upgRes );
						foreach upgRes( upgResQ )
						{
							if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
							army.GetAIReplenishStash().ModifyResource( upgResQ.Type, upgResQ.Quantity, false );
						}
					}
				}
			}
		}
	}
	else if( site.IsA('H7Dwelling')==true )
	{
		dwelling=H7Dwelling(site);
		// go through all creature stacks
		cstacks=army.GetBaseCreatureStacks();
		foreach cstacks(stack)
		{
			if(stack!=None)
			{
				upgRes=dwelling.GetUpgradeInfo(false,numOfUpgCreatures,stack);
				if(stack.GetStackType().GetUpgradedCreature()!=None && dwelling.CreatureIsInPool(stack.GetStackType().GetUpgradedCreature())==true)
				{
					if( upgRes.Length > 0 && site.GetPlayer().GetResourceSet().CanSpendResources(upgRes) == true && numOfUpgCreatures == stack.GetStackSize() && !stack.IsLockedForUpgrade() )
					{
						if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
						stack.SetLockedForUpgrade( true );
						site.GetPlayer().GetResourceSet().SpendResources( upgRes );
						foreach upgRes( upgResQ )
						{
							if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
							army.GetAIReplenishStash().ModifyResource( upgResQ.Type, upgResQ.Quantity, false );
						}
					}
				}
			}
		}
	}
	else if( site.IsA('H7TrainingGrounds')==true )
	{
		training=H7TrainingGrounds(site);
		// go through all creature stacks
		cstacks=army.GetBaseCreatureStacks();
		foreach cstacks(stack)
		{
			if(stack!=None)
			{
				upgRes=training.GetUpgradeInfo(false,numOfUpgCreatures,stack);
				if(stack.GetStackType().GetUpgradedCreature()!=None)
				{
					if( upgRes.Length>0 && site.GetPlayer().GetResourceSet().CanSpendResources(upgRes) == true && numOfUpgCreatures == stack.GetStackSize() && !stack.IsLockedForUpgrade() )
					{
						if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
						stack.SetLockedForUpgrade( true );
						site.GetPlayer().GetResourceSet().SpendResources( upgRes );
						foreach upgRes( upgResQ )
						{
							if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
							army.GetAIReplenishStash().ModifyResource( upgResQ.Type, upgResQ.Quantity, false );
						}
					}
				}
			}
		}
	}
}
