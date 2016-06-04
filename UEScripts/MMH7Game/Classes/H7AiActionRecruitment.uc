//=============================================================================
// H7AiActionRecruitment
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionRecruitment extends H7AiActionBase;

var protected H7AiUtilityRecruitmentScore mURecruitmentScore;

function String DebugName()
{
	return "Recruitment";
}

function Setup()
{
	mURecruitmentScore = new class'H7AiUtilityRecruitmentScore';
	mABID=__AID_MAX;
}

/// override function(s)

function RunScoresTown( H7AiAdventureSensors sensors, H7AreaOfControlSiteLord currentControlSite, out array<AiActionScore> scores, optional H7AdventureConfiguration cfg )
{
	local AiActionScore         score;
	local H7AiSensorInputConst  sic;
	local H7Town                town;
	local H7Fort                fort;
	local array<float>          utOut;

	sic = sensors.GetSensorIConsts();

	score.action = Self;
	score.score = 0.0f;

	town=H7Town(currentControlSite);
	fort=H7Fort(currentControlSite);
	if( town == none && fort == none ) return; // should never be called if site is not a town so ..

	sic.SetTargetVisSite(currentControlSite);

	mURecruitmentScore.UpdateInput();
	mURecruitmentScore.UpdateOutput();
	utOut = mURecruitmentScore.GetOutValues();
	if(utOut.Length>=1 && utOut[0]>0.0f)
	{
		score.params = new () class'H7AiActionParam';
		score.params.Clear();
		score.params.SetVisSite(APID_1,sic.GetTargetVisSite());
		score.score=utOut[0];
		scores.AddItem(score);
	}
}

function bool PerformActionTown( H7AreaOfControlSiteLord site, AiActionScore score )
{
	local H7Town town;
	local int cost;
	local array<H7Dwelling> dwellings;
	local H7Dwelling dwelling;
	local H7Fort fort;

	town = H7Town(score.params.GetVisSite(APID_1));
	fort = H7Fort(score.params.GetVisSite(APID_1));
	if(town!=None)
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

		// transfere (all) money from treasure chest
		cost=town.GetPlayer().GetAiSaveUpSpendingRecruitment().GetCurrency();
		town.GetPlayer().GetAiSaveUpSpendingRecruitment().ModifyCurrencySilent(-cost);
		town.GetPlayer().GetResourceSet().ModifyCurrencySilent(cost);		

		// do some clever recruiting here ....
		if( H7Town( site ) != none && H7Town( site ).GetCurrentCaravanTarget() != none )
		{
			H7Town( site ).AIRecruitAllFromTownIntoCaravan( H7Town( site ).GetCurrentCaravanTarget() );
		}
		else
		{
			town.AIRecruitAllFromTown();
		}

		dwellings=town.GetOutsideDwellings();
		foreach dwellings(dwelling)
		{
			town.AIRecruitAllFromDwelling(dwelling);	
		}

		return true;
	}
	else if(fort!=None)
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

		// transfere (all) money from treasure chest
		cost=fort.GetPlayer().GetAiSaveUpSpendingRecruitment().GetCurrency();
		fort.GetPlayer().GetAiSaveUpSpendingRecruitment().ModifyCurrencySilent(-cost);
		fort.GetPlayer().GetResourceSet().ModifyCurrencySilent(cost);		

		fort.AIRecruitAllFromTown();

		dwellings=fort.GetOutsideDwellings();
		foreach dwellings(dwelling)
		{
			fort.AIRecruitAllFromDwelling(dwelling);	
		}
	}
	return false;
}
