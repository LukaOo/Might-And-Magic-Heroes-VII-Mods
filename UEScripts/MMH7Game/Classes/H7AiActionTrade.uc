//=============================================================================
// H7AiActionTrade
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionTrade extends H7AiActionBase;

var protected H7AiUtilityTrade mUTrade;

function String DebugName()
{
	return "Perform Trade";
}

function Setup()
{
	mUTrade = new class'H7AiUtilityTrade';
	mABID=__AID_MAX;
}

function RunScoresTown( H7AiAdventureSensors sensors, H7AreaOfControlSiteLord currentControlSite, out array<AiActionScore> scores, optional H7AdventureConfiguration cfg )
{
	local AiActionScore             score;
	local H7AiSensorInputConst      sic;
	local array<float>              utOut;
	local int                       k;
	local H7Town                    town;
	local H7Town                    tmpTown;
	local array<H7Town>             towns;
	local H7TownMarketplace         marketPlace;

	sic = sensors.GetSensorIConsts();

	score.action = Self;
	score.score = 0.0f;

	// make sure we have a town as this is mandatory for trading resources
	town=H7Town(currentControlSite);
	if(town==None) 
	{
		return;
	}

	// check if there is a marketplace
	towns = town.GetPlayer().GetTowns();
	foreach towns( tmpTown )
	{
		marketPlace = H7TownMarketPlace(tmpTown.GetBuildingByType(class'H7TownMarketplace'));
		if( marketPlace != none )
		{
			break;
		}
	}
	if(marketPlace==None)
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		return;
	}

	sic.SetTargetVisSite(currentControlSite);
	sic.SetPlayer(currentControlSite.GetPlayer());

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	for(k=0;k<sic.GetResourcesNum();k++)
	{
		score.score = 0.0f;
		score.dbgString = "Action.Trade; " $ sic.GetResource(k).Type.GetName() $ "; ";

		sic.SetTargetResource(sic.GetResource(k));

		mUTrade.UpdateInput();
		mUTrade.UpdateOutput();
		utOut = mUTrade.GetOutValues();
		if(utOut[0]>0.0f)
		{
			score.score = utOut[0];
		}
		utOut.Remove(0,utOut.Length);

		if(score.score>0.0f)
		{
			score.params = new () class'H7AiActionParam';
			score.params.Clear();
			score.params.SetVisSite(APID_1,sic.GetTargetVisSite());
			score.params.SetPlayer(APID_2,sic.GetPlayer());
			score.params.SetResource(APID_3,sic.GetTargetResource());

			score.dbgString = score.dbgString $ mUTrade.dbgString;

			scores.AddItem(score);

		}
	}
}

function bool PerformActionTown( H7AreaOfControlSiteLord site, AiActionScore score )
{
	local H7Town town;
	local ResourceStockpile res;

	town = H7Town(score.params.GetVisSite(APID_1));
	res = score.params.GetResource(APID_3);
	if(town!=None)
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		return town.AiAutotradeResources(res.Type);
	}
	return false;
}
