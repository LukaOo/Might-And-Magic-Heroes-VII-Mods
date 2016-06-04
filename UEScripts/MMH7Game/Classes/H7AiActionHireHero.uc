//=============================================================================
// H7AiActionHireHero
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionHireHero extends H7AiActionBase;

var protected H7AiUtilityTownArmyCount      mInUTownArmyCount;

function String DebugName()
{
	return "Hire Hero";
}

function Setup()
{
	mInUTownArmyCount = new class'H7AiUtilityTownArmyCount';
	mABID=__AID_MAX;
}

/// override function(s)

function RunScoresTown( H7AiAdventureSensors sensors, H7AreaOfControlSiteLord currentControlSite, out array<AiActionScore> scores, optional H7AdventureConfiguration cfg )
{
	local AiActionScore         score;
	local H7AiSensorInputConst  sic;
	local H7Town                town;
	local array<float>          utTownArmyCount;
	local int                   numHeroes, k;
	local RecruitHeroData       recruitData;
	local float                 maxHeroNum;
	local array<H7AdventureHero> playerHeroes;
	local H7AdventureHero       hero;
	local float                 scaleHeroes;

	sic = sensors.GetSensorIConsts();

	score.action = Self;
	score.score = 0.0f;

	town=H7Town(currentControlSite);
	if(town==None) return; // should never be called if site is not a town so ..

	sic.SetTargetVisSite(currentControlSite);

	maxHeroNum = sic.GetHireHeroLimit();
	numHeroes = 0;
	playerHeroes = sic.GetPlayer().GetHeroes();
	foreach playerHeroes(hero)
	{
		if(hero!=None && hero.IsHero()==true && hero.IsDead()==false)
		{
			numHeroes++;
		}
	}

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	if( numHeroes >= maxHeroNum )
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		// we already have more or equal the number of heroes we want
		return;
	}

	scaleHeroes = 1.0f - (float(numHeroes) / maxHeroNum);

	mInUTownArmyCount.UpdateInput();
	mInUTownArmyCount.UpdateOutput();
	utTownArmyCount = mInUTownArmyCount.GetOutValues();

	if(utTownArmyCount.Length>=1)
	{
		numHeroes=sic.GetRecruitHeroNum();
		for(k=0;k<numHeroes;k++)
		{
			recruitData=sic.GetRecruitHero(k);

			sic.SetTargetRecruitHero(sic.GetRecruitHero(k));

			score.score = 0.0f;
			score.dbgString = "Action.HireHero; " $ town.GetName() $ "-" $ recruitData.Army.GetHeroTemplate().GetName() $ "; ";

			if(recruitData.IsAvailable==true)
			{
				score.score = scaleHeroes * (1.0f-utTownArmyCount[0]);

				// increase score if hero is of players faction
				if(recruitData.Army.GetHeroTemplate().GetFaction()==sic.GetPlayer().GetFaction())
				{
					score.score *= 1.2f;
				}
				// increase score for 'old' heroes as they are probably better
				if(recruitData.IsNew==false)
				{
					score.score *= 1.5f;
				}

				// NEVER recruit a hero that you can't afford
				if( town.GetPlayer().AiCanSpendCurrencyHero(recruitData.Cost)==false )
				{
					score.score = 0.0f;
				}
			}

			if(score.score>0.0f)
			{
				score.params = new () class'H7AiActionParam';
				score.params.Clear();
				score.params.SetVisSite(APID_1,sic.GetTargetVisSite());
				score.params.SetRecruitHeroData(APID_2,sic.GetTargetRecruitHero());

				score.dbgString = score.dbgString $ "MH " $ maxHeroNum $ "HC " $ scaleHeroes $ " TA " $ (1.0f-utTownArmyCount[0]) $ "; ";

				scores.AddItem(score);
			}
		}
	}
}

function bool PerformActionTown( H7AreaOfControlSiteLord site, AiActionScore score )
{
	local H7Town town;
	local RecruitHeroData rhd;
	local int cost;

	town = H7Town(score.params.GetVisSite(APID_1));
	rhd = score.params.GetRecruitHeroData(APID_2);
	if(town!=None)
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

		// transfere (all) money from treasure chest
		cost=town.GetPlayer().GetAiSaveUpSpendingHero().GetCurrency();
		town.GetPlayer().GetAiSaveUpSpendingHero().ModifyCurrencySilent(-cost);
		town.GetPlayer().GetResourceSet().ModifyCurrencySilent(cost);
		
		return town.RecruitHero(rhd.Army.GetHero().GetID());

	}
	return false;
}
