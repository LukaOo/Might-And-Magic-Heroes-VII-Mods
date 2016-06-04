//=============================================================================
// H7ResourceSet
//=============================================================================
//
// Modifiable resource set which includes currency and regular resource
// definitions, alongside their quantities.
// 
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7ResourceSet extends Object
	hidecategories(Object)
	dependson(H7Resource, H7StructsAndEnumsNative)
	savegame
	native;

var(General) protected String mName<DisplayName=Name>;

/** List holding the regular resources */
var(Resources) protected savegame array<ResourceStockpile>	mResources<DisplayName=Resources>;
/** Currency resource (e.g. Gold/Coins/Jelly Beans/etc.) */
var(Resources) protected savegame ResourceStockpile			mCurrencyResource<DisplayName=Currency Resource (e.g. Gold)>;

var savegame array<H7ResourceGatherData>	mResourcesGathered;
var savegame H7Player						mPlayer;

function String GetName()							{ return mName; }
function int GetCurrency()							{ return mCurrencyResource.Quantity; }
function String GetCurrencyResource()				{ return mCurrencyResource.Type.GetName(); }
function String GetCurrencyIDString()               { return mCurrencyResource.Type.GetIDString(); }
function H7Resource GetCurrencyResourceType()		{ return mCurrencyResource.Type;}
function SetPlayer(H7Player player)                 { mPlayer = player; }
function H7Player GetPlayer()                       { return mPlayer; }

/** Applies a modifier for all resource values as chosen by the difficulty setting **/
function ApplyDifficultyMultiplier()
{
	local float multiplier;
	local int i;

	if( class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
	{
		return;
	}
	else
	{
		if( mPlayer.IsControlledByAI() )
		{
			multiplier = mPlayer.mDifficultyAIStartResourcesMultiplier;
		}
		else
		{
			multiplier = class'H7AdventureController'.static.GetInstance().mDifficultyPlayerStartResourcesMultiplier;
		}

	}

	for( i = 0; i < mResources.Length; ++i )
	{
		mResources[i].Quantity *= multiplier;
	}
	mCurrencyResource.Quantity *= multiplier;
}

/**
 * sorts mResources by gui priority
 * should only be called when creating a new resourceSet
 */
function SortByGUIPriority()
{
	mResources.Sort( ResourceCompareGUI );
}

function SpendResources( array<H7ResourceQuantity> resources, optional bool updateGUI = true, optional bool doMultiplayerSynchro = false )
{
	local H7ResourceQuantity cost;
	local H7InstantCommandIncreaseResource command;

	foreach resources( cost )
	{
		;
		if( cost.Quantity > GetResource( cost.Type ) )
		{
			ScriptTrace();
			;
		}

		if( doMultiplayerSynchro && class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() )
		{
			command = new class'H7InstantCommandIncreaseResource';
			command.Init(mPlayer, cost.Type.GetIDString(), -cost.Quantity);
			class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);
		}
		else
		{
			ModifyResource( cost.Type, -cost.Quantity, updateGUI );
		}
	}
	if( updateGUI && class'H7AdventureController'.static.GetInstance().GetCurrentPlayer() == mPlayer)
	{
		class'H7AdventureHudCntl'.static.GetInstance().GetTopBar().UpdateAllResourceAmountsAndIcons( GetAllResourcesAsArray() );
	}
}

native function bool CanSpendResources( array<H7ResourceQuantity> resources );

/**
 * Returns how often the provided resourcesQuantity can be spend
 */
function int CanSpendResourcesTimes(array<H7ResourceQuantity> resources)
{
	local H7ResourceQuantity cost;
	local int times, currentTimes;

	times = 0;

	foreach resources(cost)
	{
		currentTimes = FFloor(GetResource(cost.Type) / cost.Quantity);
		if(currentTimes == 0) return 0; //if we cant spend the resource even once we can alreay return a 0
		if(times == 0) times = currentTimes;
		else if(currentTimes < times) times = currentTimes;
	}
	return times;
}

function bool CanSpendResource( H7ResourceQuantity cost )
{
	if( cost.Quantity > GetResource( cost.Type ) )
	{
			;
			return false;
	}
	return true;
}

/**
 * Get how much of a resource is left by resource
 * 
 * @param resource       resource
 * 
 * */
native function int GetResource( H7Resource resource );

function H7Resource GetResourceByAID(string aid)
{
	local int i; 
	for( i = 0; i < mResources.Length; ++i ) 
	{  
		if( mResources[i].Type.GetIDString() == aid)
		{
			return mResources[i].Type; 
		}
	}
	if(mCurrencyResource.Type.GetIDString() == aid) return mCurrencyResource.Type;
	;
	return none;
}

/**
 * Get resource income by resource
 * 
 * @param resource  the actual resource
 * 
 * */
function int GetIncome( H7Resource resource )
{  
	local int i; 
	for( i = 0; i < mResources.Length; ++i ) 
	{  
		if( mResources[i].Type.IsEqual( resource ) )
		{
			return mResources[i].Income; 
		}
	} 
	if( resource.IsEqual( mCurrencyResource.Type ) )
	{
		return mCurrencyResource.Income;
	}
	;
	return 0;
}

/** Clears income from previous turn (all resources)
 */
function ClearPreviousIncome()
{
	local int i; 
	
	for( i = 0; i < mResources.Length; ++i ) 
	{
		mResources[i].Income = 0;
	}

	mCurrencyResource.Income = 0;
}

/**
 * Set resource income referenced by name to zero
 * 
 * @param resName       Name of the resource
 * 
 * */
function ClearIncome( H7Resource resName )
{  
	local int i; 
	
	for( i = 0; i < mResources.Length; ++i ) 
	{  
		if( mResources[i].Type == resName)
		{
			mResources[i].Income = 0;
		}
	}
	if( resName == mCurrencyResource.Type )
	{
		mCurrencyResource.Income = 0;
	}
}

function ClearQuantity( H7Resource resName )
{  
	local int i; 
	
	for( i = 0; i < mResources.Length; ++i ) 
	{  
		if( mResources[i].Type == resName)
		{
			mResources[i].Quantity = 0;
		}
	}
	if( resName == mCurrencyResource.Type )
	{
		mCurrencyResource.Quantity = 0;
	}
}

function SetCurrencySilent(int amount)
{
	mCurrencyResource.Quantity = amount;
	mPlayer.UpdateTownInfoIcons();
}

function ModifyCurrencySilent(int modAmount)
{
	mCurrencyResource.Quantity += modAmount;
	mPlayer.UpdateTownInfoIcons();
}

function ModifyCurrency(int modAmount, optional bool updateGUI = false)
{
	mCurrencyResource.Quantity += modAmount;
	LogGatheredResource( GetCurrencyResourceType(), modAmount, true );
	if( class'H7AdventureController'.static.GetInstance().GetCurrentPlayer() == mPlayer)
	{
		if( updateGUI )
		{
			class'H7AdventureHudCntl'.static.GetInstance().GetTopBar().TweenResourceAmountAndIcon(mResources.Length, mCurrencyResource.Type.GetIconPath(), mCurrencyResource.Type.GetName(), mCurrencyResource.Quantity);
		}
		mPlayer.UpdateTownInfoIcons();
	}
}

/**
 * Modify a given resource, by name, by a specific amount.
 * IMPORTANT: Use MINUS at modAmount when you want to subtract!
 * 
 * @param resName       Name of the resource
 * @param modAmount     The amount of resources to add or subtract
 * 
 * */
function ModifyResource( H7Resource resource, int modAmount, optional bool updateGUI = true )
{
	local int i; 
	for( i = 0; i < mResources.Length; ++i ) 
	{  
		if( mResources[i].Type.IsEqual( resource ) )
		{
			mResources[i].Quantity += modAmount;
			if(updateGUI && class'H7AdventureController'.static.GetInstance().GetCurrentPlayer() == mPlayer)
			{
				class'H7AdventureHudCntl'.static.GetInstance().GetTopBar().TweenResourceAmountAndIcon(i, mResources[i].Type.GetIconPath(), resource.GetName(), mResources[i].Quantity);
			}
		}
	}
	if( resource.IsEqual( mCurrencyResource.Type ) )
	{
		mCurrencyResource.Quantity += modAmount;
		if(updateGUI && class'H7AdventureController'.static.GetInstance().GetCurrentPlayer() == mPlayer)
		{
			class'H7AdventureHudCntl'.static.GetInstance().GetTopBar().TweenResourceAmountAndIcon(mResources.Length, mCurrencyResource.Type.GetIconPath(), mCurrencyResource.Type.GetName(), mCurrencyResource.Quantity);
		}
	}

	if( class'H7AdventureController'.static.GetInstance().GetCurrentPlayer() == mPlayer )
	{
		mPlayer.UpdateTownInfoIcons();
	}
	LogGatheredResource( resource, modAmount );

	class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();
}

function SetResource( H7Resource resource, int amount, optional bool updateGUI = true )
{
	local int i; 
	for( i = 0; i < mResources.Length; ++i ) 
	{  
		if( mResources[i].Type.IsEqual( resource ) )
		{
			mResources[i].Quantity = amount;
			if(updateGUI && class'H7AdventureController'.static.GetInstance().GetCurrentPlayer() == mPlayer)
			{
				class'H7AdventureHudCntl'.static.GetInstance().GetTopBar().TweenResourceAmountAndIcon(i, mResources[i].Type.GetIconPath(), resource.GetName(), mResources[i].Quantity);
			}
		}
	}
	if( resource.IsEqual( mCurrencyResource.Type ) )
	{
		mCurrencyResource.Quantity = amount;
		if(updateGUI && class'H7AdventureController'.static.GetInstance().GetCurrentPlayer() == mPlayer)
		{
			class'H7AdventureHudCntl'.static.GetInstance().GetTopBar().TweenResourceAmountAndIcon(mResources.Length, mCurrencyResource.Type.GetIconPath(), mCurrencyResource.Type.GetName(), mCurrencyResource.Quantity);
		}
	}

	if( class'H7AdventureController'.static.GetInstance().GetCurrentPlayer() == mPlayer )
	{
		mPlayer.UpdateTownInfoIcons();
	}
}

/**
 * Modify a given resource income, by name, by a specific amount.
 * IMPORTANT: Use MINUS at modAmount when you want to subtract!
 * 
 * @param resource      The resource to be modified
 * @param modAmount     The amount of income to add or subtract
 * 
 * */
native function ModifyIncome( H7Resource resource, int modAmount );

event ModifiedIncome(H7Resource resource)
{
	local H7AdventureController advController;
	advController = class'H7AdventureController'.static.GetInstance();

	if(GetPlayer().IsControlledByLocalPlayer() && !advController.GetCurrentPlayer().IsControlledByAI())
		H7AdventureHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetAdventureHudCntl().GetTopBar().UpdateResourceIncome(resource.GetName(), GetIncome(resource));
}

function LogGatheredResource( H7Resource resource, int modAmount, optional bool currency )
{
	local int i,j;
	local H7ResourceGatherData gatherData;
	local bool gathered;

	// check if it's currency by name
	if( !currency )
	{
		currency = mCurrencyResource.Type.IsEqual( resource );
	}

	if( modAmount > 0 )
	{
		if( !currency )
		{
			for( i = 0; i < mResources.Length; ++i ) 
			{  
				if( mResources[i].Type.IsEqual( resource ))
				{
					if( mResourcesGathered.Length == 0 )
					{
						gatherData.resource = mResources[i].Type;
						gatherData.amount = modAmount;
						mResourcesGathered.AddItem( gatherData );
					}
					else
					{
						for( j = 0; j < mResourcesGathered.Length; j++ )
						{
							if( mResourcesGathered[j].resource.IsEqual( resource ) )
							{
								mResourcesGathered[j].amount += modAmount;
								gathered = true;
							}
						}
						if( !gathered )
						{
							gatherData.resource = mResources[i].Type;
							gatherData.amount = modAmount;
							mResourcesGathered.AddItem( gatherData );
							gathered = false;
						}
					}
				}
			}
		}
		else
		{
			if( mResourcesGathered.Length == 0 )
			{
				gatherData.resource = mCurrencyResource.Type;
				gatherData.amount = modAmount;
				mResourcesGathered.AddItem( gatherData );
			}
			else
			{
				for( j = 0; j < mResourcesGathered.Length; ++j )
				{
					if( mResourcesGathered[j].resource.IsEqual( resource ) )
					{
						mResourcesGathered[j].amount += modAmount;
						gathered = true;
					}
				}
				if( !gathered )
				{
					gatherData.resource = mCurrencyResource.Type;
					gatherData.amount = modAmount;
					mResourcesGathered.AddItem( gatherData );
					gathered = false;
				}
			}
		}
	}
}

function PrintDebugStockpileForAI()
{
	local ResourceStockpile stockpile;
	if( !class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog )
	{
		return;
	}
	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	foreach mResources( stockpile )
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	}
}

function H7Resource GetResourceByName( String resourceName ) 
{
	local int i;

	for( i = 0; i < mResources.Length; ++i )
	{
		if( mResources[i].Type.GetName() == resourceName )
		{
			return mResources[i].Type;
		}
	}
	if(mCurrencyResource.Type.GetName() == resourceName) return mCurrencyResource.Type;
	return none;
}

function H7Resource GetResourceByIDString( String resourceName ) 
{
	local int i;

	for( i = 0; i < mResources.Length; ++i )
	{
		if( mResources[i].Type.GetIDString() == resourceName )
		{
			return mResources[i].Type;
		}
	}
	if(mCurrencyResource.Type.GetIDString() == resourceName) return mCurrencyResource.Type;
	return none;
}

function H7Resource GetResourceByResourceTypeIdentifier( String resourceName ) 
{
	local int i;

	for( i = 0; i < mResources.Length; ++i )
	{
		if( mResources[i].Type.GetTypeIdentifier() == resourceName )
		{
			return mResources[i].Type;
		}
	}
	if(mCurrencyResource.Type.GetTypeIdentifier() == resourceName) return mCurrencyResource.Type;
	return none;
}

function array<H7ResourceGatherData> GetGatheredResources() { return mResourcesGathered; }

// returns the resources array and currency resource combined
event array<ResourceStockpile> GetAllResourcesAsArray()
{
	local array<ResourceStockpile> allResourcesArray;
	local int i;
	for( i = 0; i < mResources.Length; ++i)
	{
		allResourcesArray.AddItem( mResources[i] );
	}	
	// The last resource in the array must be the currency!
	allResourcesArray.AddItem( mCurrencyResource );
	allResourcesArray.Sort( ResourceCompareGUI );
	return allResourcesArray;
}

function int ResourceCompareGUI( ResourceStockpile a, ResourceStockpile b )
{
	if( a.Type.GetGUIPriority() > b.Type.GetGUIPriority() ) return -1;
	if( a.Type.GetGUIPriority() < b.Type.GetGUIPriority() ) return 1;
	return 0;
}

/**
 * Returns the resources array. NOTE: Does not include currency resource!
 */
function array<ResourceStockpile> GetResources()
{
	return mResources;
}

function array<int> GetAllResourceAmounts()
{
	local array<int> allResourceAmountsArray;
	local int i;
	for( i = 0; i < mResources.Length; ++i)
	{
		allResourceAmountsArray.AddItem(mResources[i].Quantity);
	}
	
	allResourceAmountsArray.AddItem(mCurrencyResource.Quantity);
	return allResourceAmountsArray;
}

/**
 * Handles the income of the resource pool, increasing
 * the current quantity of the resource by a specific
 * amount determined by the income
 *  
 */
function HandleIncome( bool updateGUI )
{
	local int i;
	local float aiMultiplier;

	aiMultiplier = mPlayer.mDifficultyAIResourceIncomeMultiplier;
	for( i = 0; i < mResources.Length; ++i)
	{
		;
		ModifyResource( mResources[i].Type, mPlayer.IsControlledByAI() ? int( mResources[i].Income * aiMultiplier ) : mResources[i].Income, updateGUI );
		;
	}
	;
	ModifyCurrency( mPlayer.IsControlledByAI() ? int( mCurrencyResource.Income * aiMultiplier ) : mCurrencyResource.Income );
	;

}

function SetResources( array<ResourceStockpile> stockpiles )
{
	mCurrencyResource = stockpiles[ stockpiles.Length - 1 ];
	stockpiles.Remove( stockpiles.Length - 1, 1 );
	mResources = stockpiles;
}

function SetGatheredResources( array<H7ResourceGatherData> gatheredResources )
{
	mResourcesGathered = gatheredResources;
}

function bool HasResourceInSet( H7Resource resource )
{
	local int i;

	for( i = 0; i < mResources.Length; ++i )
	{
		if( resource.IsEqual( mResources[i].Type ) )
		{
			return true;
		}
	}

	// check currency
	if( mCurrencyResource.Type.IsEqual( resource ) )
	{
		return true;
	}

	return false;
}

function static bool TradeResourceWithPlayer( H7Player sourcePlayer, H7Player targetPlayer, H7Resource resource, int amount )
{
	local int tradeAmount;
	local H7ResourceSet sourceResourceSet, targetResourceSet;

	sourceResourceSet = sourcePlayer.GetResourceSet();
	targetResourceSet = targetPlayer.GetResourceSet();

	if( sourceResourceSet == none || targetResourceSet == none ) return false;

	if( !sourceResourceSet.HasResourceInSet( resource ) || !targetResourceSet.HasResourceInSet( resource ) )
	{
		return false; // one of the players does not have the resource in his resource set
	}

	tradeAmount = sourceResourceSet.GetResource( resource );

	tradeAmount = FClamp( amount, 0, tradeAmount ); // can not trade more than currently in stock

	if( tradeAmount <= 0 ) return false; // nothing there to trade with

	if( sourceResourceSet.IsCurrencyResource( resource ) )
	{
		sourceResourceSet.ModifyCurrency( -tradeAmount, true );
	}
	else
	{
		sourceResourceSet.ModifyResource( resource, -tradeAmount, true );
	}

	if( targetResourceSet.IsCurrencyResource( resource ) )
	{
		targetResourceSet.ModifyCurrency( tradeAmount, false );
	}
	else
	{
		targetResourceSet.ModifyResource( resource, tradeAmount, false );
	}

	return true;
}

function static TradeResourcesWithPlayer( H7Player sourcePlayer, H7Player targetPlayer, array<H7ResourceQuantity> resources )
{
	local int i;
	local array<int> failIndexes;

	for( i = 0; i < resources.Length; ++i )
	{
		if( !class'H7ResourceSet'.static.TradeResourceWithPlayer( sourcePlayer, targetPlayer, resources[i].Type, resources[i].Quantity ) )
		{
			failIndexes.AddItem(i);
		}
	}

	for( i = 0; i < failIndexes.Length; ++i )
	{
		;
	}
}

function bool IsCurrencyResource( H7Resource resource )
{
	return resource.IsEqual( mCurrencyResource.Type );
}

function Texture2D GetIconByStr(string str)
{
	local int i;

	if(Caps(mCurrencyResource.Type.GetTypeIdentifier()) == Caps(str))
	{
		return mCurrencyResource.Type.GetIcon();
	}
	for( i = 0; i < mResources.Length; ++i )
	{
		if( Caps(mResources[i].Type.GetTypeIdentifier()) == Caps(str) )
		{
			return mResources[i].Type.GetIcon();
		}
	}
	return none;
}

