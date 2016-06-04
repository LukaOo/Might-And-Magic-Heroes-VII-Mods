/*=============================================================================
 * H7RandomResource
 * 
 * 1x1 tile object as placeholder for a randomly composed ResourcePile
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
=============================================================================*/
class H7RandomResource extends H7ResourcePile
	implements(H7IRandomSpawnable)
	hideCategories(Editor,Container)
	native
	placeable;

var(Developer) array<H7Resource> mAllowedResources<DisplayName="Allowed Resources">;

// Minimal this amount of resources will be granted on picking this object. Not used for gold.
var(ResourceAmounts) int mMinimalBonus<DisplayName="Minimal Bonus"|ClampMin=1>;
// Maximal this amount of resources will be granted on picking this object. Not used for gold.
var(ResourceAmounts) int mMaximalBonus<DisplayName="Maximal Bonus"|ClampMin=1>;

var(Developer) int mGoldRoundValue<DisplayName="Pace"|ClampMin=0>;
// Minimal this amount of resources will be granted on picking this object. For gold only. One unit is 50.
var(Gold) int mMinimalGoldBonus<DisplayName="Minimal Gold Bonus">;
// Maximal this amount of resources will be granted on picking this object. For gold only. One unit is 50.
var(Gold) int mMaximalGoldBonus<DisplayName="Maximal Gold Bonus">;

var(AI) protected float mAiUtilityValue<DisplayName="AI Utility Value">;



var H7Resource mCurrencyResource;

function ERandomSiteFaction GetFactionType() { return E_H7_RSF_PLAYER; }

protected function InitCurrencyResource()
{
	local H7AdventureController advController;
	local H7Player player;

	advController = class'H7AdventureController'.static.GetInstance();

	if( advController != none )
	{
		player = advController.GetAnyActivePlayer(true);

		if( player != none )
		{
			mCurrencyResource = player.GetResourceSet().GetCurrencyResourceType();
		}
	}
}

function H7Resource GetRandomResource()
{
	local int idx;

	if( mAllowedResources.Length == 0 )
	{
		return none;
	}

	idx = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( mAllowedResources.Length );

	return mAllowedResources[idx];
}

function int GetRandomAmount()
{
	local int minn, maxx;

	minn = Max( 0, mMinimalBonus );
	maxx = Max( minn, mMaximalBonus );

	return class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomIntRange( minn, maxx + 1 );
}

function int GetRandomGoldAmount()
{
	local int minn, maxx, rnd;

	mGoldRoundValue = Max( 1, mGoldRoundValue );

	minn = Max( 0, mMinimalGoldBonus );
	maxx = Max( minn, mMaximalGoldBonus );

	minn = minn / ( mGoldRoundValue );
	maxx = maxx / ( mGoldRoundValue );

	rnd = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomIntRange( minn, maxx + 1 );

	rnd *= mGoldRoundValue ;

	return rnd;
}

protected function HatchRandomResource()
{
	local H7Resource randomResource;

	randomResource = GetRandomResource();
	SetIsChest( false );
	SetUseContainerMesh( false );

	if( randomResource != none )
	{
		AddResource( randomResource, randomResource.IsEqual( mCurrencyResource ) ? GetRandomGoldAmount() : GetRandomAmount() );
		mCustomTooltipKey = randomResource.GetCustomTooltipKey();
	}

	SetAiUtilityValue( mAiUtilityValue );
	UpdatePileMeshes( self );
}

protected function HatchResource()
{
	HatchRandomResource();
}

event HatchRandomSpawnable()
{
	InitCurrencyResource();
	HatchResource();
}

event DisposeShell() 
{

}

event H7Faction GetChosenFaction() { return none; }
function H7AreaOfControlSite GetSpawnedSite() { return none; }

function native SetRandomPlayerNumber( EPlayerNumber number );
function native SetFactionType( ERandomSiteFaction factionType );

native function UpdatePileMeshes( H7ResourcePile resourcePile );

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

