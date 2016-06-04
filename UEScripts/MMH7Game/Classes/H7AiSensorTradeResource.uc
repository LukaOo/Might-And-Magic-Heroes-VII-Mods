//=============================================================================
// H7AiSensorTradeResource
//=============================================================================
// returns a value between [0,1] indicating if there is any resource with a 
// need. Its based on threshold values stored with H7Resource. If the value
// is zero we do not need anything.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorTradeResource extends H7AiSensorBase;

/// overrides ...

function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	local H7Player      thisPlayer;
	local array<H7Town> towns;
	local H7Town        town;
	local H7TownMarketplace marketPlace;
	local ResourceStockpile resourceCheck;
	local int totalNeed;

	resourceCheck.Type = None;
	resourceCheck.Quantity = 0;
	resourceCheck.Income = 0;

	if( param1.GetPType() == SP_RESOURCE )
	{
		resourceCheck=param1.GetResource();
	}

	if( param0.GetPType() == SP_PLAYER )
	{
		thisPlayer=param0.GetPlayer();
		// bad parameter
		if(thisPlayer==None) return 0.0f;
		// first we have to see if player is eligible to trading (has any marketplace build)
		towns=thisPlayer.GetTowns();
		if(towns.Length<=0) 
		{
			// no towns means no trading
			return 0.0f;
		}
		if( resourceCheck.Type == None )
		{
			// nothing to check against ?
			return 0.0f;
		}
		foreach towns(town)
		{
			if(town!=None)
			{
				// check if there is a marketplace
				marketPlace = H7TownMarketPlace(town.GetBuildingByType(class'H7TownMarketplace'));
				if(marketPlace!=None)
				{
					totalNeed = thisPlayer.GetAiNeedTownDev().GetResource(resourceCheck.Type) + thisPlayer.GetAiNeedRecruitment().GetResource(resourceCheck.Type);
					if( totalNeed > 0 )
					{
						if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
						if( totalNeed >= resourceCheck.Type.GetTradeThreshold(true) ) return 1.0f;
						return resourceCheck.Type.GetTradeThreshold(true) / totalNeed;
					}
				}
			}
		}
	}
	
	// wrong parameter types
	return 0.0f;
}
