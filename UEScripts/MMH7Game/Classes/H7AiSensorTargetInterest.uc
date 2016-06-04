//=============================================================================
// H7AiSensorTargetInterest
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorTargetInterest extends H7AiSensorBase;

protected function float GetSiteValue(H7VisitableSite site)
{
	//local array<H7Resource>     resources;
	//local H7Resource            res;
	//local array<H7HeroItem>     items;
	//local H7HeroItem            item;
	//local string                resIdent;
	local float                 val;
//	local int                   level;
	
	val=0.0f;

	if( site.IsA('H7ResourcePile')==true )
	{
		// TODO: factor in demand
		//resources=H7ResourcePile(site).GetResources();
		//foreach resources(res)
		//{
		//	if(res!=None)
		//	{
		//		resIdent=Caps(res.GetTypeIdentifier());
		//		     if(resIdent=="GOLD")           val+=0.7f;
		//		else if(resIdent=="WOOD")           val+=0.8f;
		//		else if(resIdent=="ORE")            val+=0.85f;
		//		else if(resIdent=="CRYSTAL")        val+=0.9f;
		//		else if(resIdent=="DRAGONSTEEL")    val+=0.9f;
		//		else if(resIdent=="MERCURY")        val+=0.9f;
		//		else if(resIdent=="SHADOWSTEEL")    val+=0.9f;
		//		else if(resIdent=="STARSILVER")     val+=0.9f;
		//		else if(resIdent=="SULFUR")         val+=0.9f;
		//		else val+=1.0f;
		//	}
		//}
		//if(resources.Length>0) val/=resources.Length;
		return site.GetAiBaseUtility();
	}
	if( site.IsA('H7ItemPile')==true )
	{
		//items=H7ItemPile(site).GetItems();
		//foreach items(item)
		//{
		//	if(item!=None)
		//	{
		//		// power values range from 0 to 1
		//		val = val + 0.5f + ((item.GetPowerValueMagic() + item.GetPowerValueMight()) * 0.25f);
		//	}
		//}
		//if(items.Length>0) val/=items.Length;
		return site.GetAiBaseUtility();
	}
	if( site.IsA('H7Dwelling')==true )
	{
		val = site.GetAiBaseUtility();
		if( H7Dwelling(site).IsUpgraded()==true )
		{
			val*=1.5f;
			if(val>1.0f) val=1.0f;
		}
		return val;
	}
	if( site.IsA('H7Town')==true )
	{
		val = site.GetAiBaseUtility();
		//level=H7Town(site).GetLevel();
		//     if(level<=3) val*=0.7f;
		//else if(level<=6) val*=0.8f;
		//else if(level<=9) val*=0.9f;
		return val;
	}
	if( site.IsA('H7Fort')==true )
	{
		val = site.GetAiBaseUtility();
		return val;
	}
	if( site.IsA('H7Garrison')==true )
	{
		val = site.GetAiBaseUtility();
		return val;
	}
	if( site.IsA('H7Mine')==true )
	{
		// TODO: factor in demand
		//res=H7Mine(site).GetResource();
		//if(res!=None)
		//{
		//	resIdent=Caps(res.GetTypeIdentifier());
		//		 if(resIdent=="GOLD")           val=0.7f;
		//	else if(resIdent=="WOOD")           val=0.8f;
		//	else if(resIdent=="ORE")            val=0.85f;
		//	else if(resIdent=="CRYSTAL")        val=0.9f;
		//	else if(resIdent=="DRAGONSTEEL")    val=0.9f;
		//	else if(resIdent=="MERCURY")        val=0.9f;
		//	else if(resIdent=="SHADOWSTEEL")    val=0.9f;
		//	else if(resIdent=="STARSILVER")     val=0.9f;
		//	else if(resIdent=="SULFUR")         val=0.9f;
		//	else val=0.6f;
		//}

		return site.GetAiBaseUtility();
	}

	return site.GetAiBaseUtility();
}

/// overrides ...

function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1  )
{
	local H7AdventureArmy army;
	local H7VisitableSite site;
	local float uVal;

//	`LOG_AI("Sensor.TargetInterest");

	uVal = 0.0f;

	if( param0.GetPType() == SP_ADVENTUREARMY )
	{
		army = param0.GetAdventureArmy();
		if(army!=None) 
		{
			if( army.GetPlayerNumber() != PN_NEUTRAL_PLAYER )
			{
				uVal = 2.0f;
			}
			else
			{
				uVal = 1.0f;
			}

//			`LOG_AI("  #1 Army" @ uVal );
			return uVal;
		}
	}
	if( param0.GetPType() == SP_VISSITE )
	{
		site = param0.GetVisSite();
		if(site!=None)
		{
			uVal=GetSiteValue(site);
//			`LOG_AI("  #1 Site" @ uVal );
			return uVal;
		}
	}

	if( param1.GetPType() == SP_ADVENTUREARMY )
	{
		army = param1.GetAdventureArmy();
		if(army!=None)
		{
			if( army.GetPlayerNumber() != PN_NEUTRAL_PLAYER )
			{
				uVal = 2.0f;
			}
			else
			{
				uVal = 1.0f;
			}
//			`LOG_AI("  #2 Army" @ uVal );
			return uVal;
		}
	}
	if( param1.GetPType() == SP_VISSITE )
	{
		site = param1.GetVisSite();
		if(site!=None)
		{
			uVal=GetSiteValue(site);
//			`LOG_AI("  #2 Site" @ uVal );
			return uVal;
		}
	}

	return uVal;
}
