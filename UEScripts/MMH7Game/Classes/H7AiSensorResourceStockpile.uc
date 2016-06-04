//=============================================================================
// H7AiSensorResourceStockpile
//=============================================================================
// returns a value between [0,1] indicating if there is any resource with a 
// need. Its based on threshold values stored with H7Resource. If the value
// is zero we do not need anything.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorResourceStockpile extends H7AiSensorBase;

/// overrides ...

function float GetValue1( H7AiSensorParam param0  )
{
	local H7Player      thisPlayer;
	local H7ResourceSet resourceSet;
	local array <ResourceStockpile> resources;
	local ResourceStockpile resource;

	if( param0.GetPType() == SP_PLAYER )
	{
		thisPlayer=param0.GetPlayer();
		// bad parameter
		if(thisPlayer==None) return 0.0f;
		// get the current stock of the player
		resourceSet=thisPlayer.GetResourceSet();
		resources=resourceSet.GetAllResourcesAsArray();
		// find out the most abundant resource from them. It is based on simple threshold values.
		foreach resources(resource)
		{
			if( resource.Quantity > resource.Type.GetTradeThreshold(false) )
			{
				return 1.0f;
			}
		}
		// extra handling for gold as its not part of the above deal
		if( resourceSet.GetCurrency() < resourceSet.GetCurrencyResourceType().GetTradeThreshold(false) )
		{
			return 1.0f;
		}
	}
	// wrong parameter types
	return 0.0f;
}
