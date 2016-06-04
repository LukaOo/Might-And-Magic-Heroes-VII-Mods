/*=============================================================================
 * H7RandomCampfire
 * 
 * 1x1 tile object as placeholder for a randomly composed Campfire
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
=============================================================================*/
class H7RandomCampfire extends H7RandomResource
	hideCategories(Editor,Resources)
	showcategories(Container)
	native
	placeable;

var(Developer) protected array<H7Resource> mCampfireResources<DisplayName="Campfire Common Resources">;

var(RareResources) protected array<H7Resource> mCampfireRareResources<DisplayName="Campfire Rare Resources">;
// Minimal this amount of rare resources will be granted if you are lucky
var(RareResources) int mMinimalRareBonus<DisplayName="Minimal Rare Bonus"|ClampMin=1>;
// Maximal this amount of rare resources will be granted if you are lucky
var(RareResources) int mMaximalRareBonus<DisplayName="Maximal Rare Bonus"|ClampMin=1>;
// Chance to get rare resources as well
var(RareResources) protected int mRareResourceChance<DisplayName="Rare Resource Chance %"|ClampMin=0|ClampMax=100>;

protected function HatchRandomResource()
{
	local int randomChance, resource;


	if( mCurrencyResource != none )
	{
		AddResource( mCurrencyResource, GetRandomGoldAmount() );
	}

	randomChance = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(100);
	if(randomChance <= mRareResourceChance && mCampfireRareResources.Length > 0)
	{
		resource = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(mCampfireRareResources.Length);
		if( mCampfireRareResources[resource] != none )
		{
			AddResource(mCampfireRareResources[resource], GetRandomRareAmount());
		}
	}
	else if (mCampfireResources.Length > 0)
	{
		resource = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(mCampfireResources.Length);
		if( mCampfireResources[resource] != none )
		{
			AddResource(mCampfireResources[resource], GetRandomAmount());
		}
	}

	SetIsChest( false );
	SetContainerResource( mContainerResource );
	SetUseContainerMesh( true );

	SetAiUtilityValue( mAiUtilityValue );

	UpdatePileMeshes( self );
}

function int GetRandomRareAmount()
{
	local int minn, maxx;

	minn = Max( 0, mMinimalRareBonus );
	maxx = Max( minn, mMaximalRareBonus );

	return class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomIntRange( minn, maxx + 1 );
}

