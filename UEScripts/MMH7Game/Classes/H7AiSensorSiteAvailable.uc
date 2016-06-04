//=============================================================================
// H7AiSensorSiteAvailable
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorSiteAvailable extends H7AiSensorBase;

/// overrides ...

function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	local H7AdventureHero           hero;
	local H7Unit                    unit;
	local H7VisitableSite           site;

//	`LOG_AI("Sensor.SiteAvailable");

	if( param0.GetPType() == SP_UNIT )
	{
		unit=param0.GetUnit();
		if(unit==None || unit.GetEntityType()!=UNIT_HERO)
		{
			// wrong unit types
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			return 0.0f;
		}
		hero=H7AdventureHero(unit);
	}
	if( param1.GetPType() == SP_VISSITE )
	{
		site=param1.GetVisSite();
		if(site==None)
		{
			// bad parameter
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			return 0.0f;
		}
	}
	
	if( site.GetAiOnIgnore()==true )
	{
		return 0.0f;
	}

	if( site.IsA('H7PermanentBonusSite') )
	{
		if( H7PermanentBonusSite(site).HasVisited(hero) == false &&
			H7PermanentBonusSite(site).CanAffordIt(hero) == true )
		{
			return 1.0f;
		}
	}
	else if( site.IsA('H7BuffSite') )
	{
		if( H7BuffSite( site ).HasAllBuffsFromHere( hero ) == false )
		{
			return 1.0f;
		}
	}
	else if( site.IsA('H7Mine') )
	{
		if( H7Mine(site).CanBePlunderedByPlayer(hero.GetPlayer()) ||
			H7Mine(site).GetPlayerNumber()==PN_NEUTRAL_PLAYER ||
			(H7Mine(site).GetLord()!=None && H7Mine(site).GetLord().GetPlayerNumber()==PN_NEUTRAL_PLAYER && hero.GetPlayer().IsPlayerAllied(H7Mine(site).GetPlayer())==false ) ||
			H7Mine(site).GetPlayer()==hero.GetPlayer() )
		{
			return 1.0f;
		}
	}
	else if( site.IsA('H7CustomNeutralDwelling') ) 
	{
		if( H7CustomNeutralDwelling(site).WillBenefitFromVisit(hero) == true )
		{
			return 1.0f;
		}
	}
	else if( site.IsA('H7Dwelling') )
	{
		return 1.0f;
	}
	else if( site.IsA('H7Town') )
	{
		return 1.0f;
	}
	else if( site.IsA('H7Fort') )
	{
		if( H7Fort(site).IsRuined() == false )
		{
			return 1.0f;
		}
		else if( H7Fort(site).CanAffordRebuild(hero.GetPlayer()) == true )
		{
			return 1.0f;
		}
		else if( H7Fort(site).GetPlayerNumber()==PN_NEUTRAL_PLAYER ||
				 H7Fort(site).GetPlayer()==hero.GetPlayer() )
		{
			return 1.0f;
		}
	}
	else if( site.IsA('H7Observatory') )
	{
		if( H7Observatory(site).GetHeadquarters()==None )
		{
			if( H7Observatory(site).IsRevealed(hero.GetPlayer().GetPlayerNumber()) == false )
			{
				return 1.0f;
			}
		}
	}
	else if( site.IsA('H7ObservatoryHQ') )
	{
		if( H7ObservatoryHQ(site).IsRevealed(hero.GetPlayer().GetPlayerNumber()) == false &&
			H7ObservatoryHQ(site).CanAffordIt(hero.GetPlayer()) == true )
		{
			return 1.0f;
		}
	}
	else if( site.IsA('H7ArcaneLibrary') )
	{
		if( H7ArcaneLibrary(site).WillBenefitFromVisit(hero) == true )
		{
			return 1.0f;
		}
	}
	else if( site.IsA('H7ArcaneAcademy') )
	{
		if( H7ArcaneAcademy(site).WillBenefitFromVisit(hero) == true )
		{
			return 1.0f;
		}
	}
	else if( site.IsA('H7SchoolOfWar') )
	{
		if( H7SchoolOfWar(site).WillBenefitFromVisit(hero) == true )
		{
			return 1.0f;
		}
	}
	else if( site.IsA('H7BlindBrotherMonastery') )
	{
		if( H7BlindBrotherMonastery(site).HasVisited(hero) == false && hero.GetPlayer().GetResourceSet().CanSpendResource( H7BlindBrotherMonastery(site).GetCost() ) )
		{
			return 1.0f;
		}
	}
	else if( site.IsA('H7ResourceDepot') )
	{
		if( H7ResourceDepot(site).CanBeVisited() == true )
		{
			return 1.0f;
		}
	}
	else if( site.IsA('H7Merchant') ) // todo: impl check
	{
		//if( H7Merchant(site).
	}
	else if( site.IsA('H7TradingPost') ) // todo: impl check
	{
		//if( H7TradingPost(site).
		return 0.0f;
	}
	else if( site.IsA('H7Shipyard') ) // todo: impl check
	{
		if( H7Shipyard(site).WillBenefitFromVisit(hero) == true )
		{
			return 1.0f;
		}
	}
	else if( site.IsA('H7BattleSite') )
	{
		if( H7BattleSite(site).HasVisited(hero) == false && H7BattleSite(site).IsLooted() == false )
		{
			return 1.0f;
		}
	}
	else if( site.IsA('H7Keymaster') )
	{
		if( H7Keymaster(site).HasVisited(hero.GetPlayer()) == false )
		{
			return 1.0f;
		}
	}
	else if( site.IsA('H7KeymasterGate') )
	{
		if( H7KeymasterGate(site).CanUnlock(hero.GetPlayer()) == true && H7KeymasterGate(site).CanPass(hero.GetPlayer()) == false )
		{
			return 1.0f;
		}
	}
	else if( site.IsA('H7DestructibleObjectManipulator') )
	{
		if( H7DestructibleObjectManipulator(site).CanBeRepaired(hero) == true )
		{
			return 1.0f;
		}
	}
	else if( site.IsA('H7Garrison') )
	{
		return 1.0f;
	}
	else if( site.IsA('H7Obelisk') )
	{
		if( H7Obelisk(site).HasVisited(hero.GetPlayer()) == false )
		{
			return 1.0f;
		}
	}
	else if( site.IsA('H7Shelter') )
	{
		if( H7Shelter(site).IsUnoccupied()==true )
		{
			return 1.0f;
		}
	}

	return 0.0f;
}
