//=============================================================================
// H7AiUtilityTrade
//=============================================================================
// ...
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityTrade extends H7AiUtilityCombiner;

var H7AiUtilityTradeResource        mInUTradeResource;
var H7AiUtilityResourceStockpile    mInUResourceStockpile;

var String dbgString;

/// overrides ...

function UpdateInput()
{
	local array<float> tradeResources;
	local array<float> resourceStock;
	local float util;

//	`LOG_AI("Utility.Trade");

	if( mInUTradeResource == None ) { mInUTradeResource = new class 'H7AiUtilityTradeResource'; }
	if( mInUResourceStockpile == None ) { mInUResourceStockpile = new class 'H7AiUtilityResourceStockpile'; }

	mInValues.Remove(0,mInValues.Length);

	// need for target set resource
	mInUTradeResource.UpdateInput();
	mInUTradeResource.UpdateOutput();
	tradeResources = mInUTradeResource.GetOutValues();
	
	if( tradeResources.Length <= 0 ) return;

	// most abundant resource to trade with
	mInUResourceStockpile.UpdateInput();
	mInUResourceStockpile.UpdateOutput();
	resourceStock = mInUResourceStockpile.GetOutValues();

	if( resourceStock.Length <= 0 ) return;

	util=tradeResources[0]*resourceStock[0];
	mInValues.AddItem(util);

	dbgString = "Trade(" $ util $ ";TR(" $ tradeResources[0] $ ");RS(" $ resourceStock[0] $ ")) ";

//	`LOG_AI("  TR"@tradeResources[0]@"RS"@resourceStock[0]);
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

