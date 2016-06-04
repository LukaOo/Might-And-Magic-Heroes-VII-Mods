/*=============================================================================
 * H7RandomTreasureChest
 * 
 * 1x1 tile object as placeholder for a randomly composed TreasureChest
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
=============================================================================*/
class H7RandomTreasureChest extends H7RandomResource
	hideCategories(Editor,Amounts,Resources,Gold)
	showcategories(Container)
	native
	placeable;

struct native H7TreasureChestRewards
{
	var() int GoldAmount<DisplayName="Gold Amount"|ClampMin=0>;
	var() int XPAmount<DisplayName="XP Amount"|ClampMin=0>;
};

var(Developer) array<H7TreasureChestRewards> mChestRewards<DisplayName="Treasure Chest rewards">;

protected function H7TreasureChestRewards GetRandomReward()
{
	local H7TreasureChestRewards rewards;
	local int idx;

	if( mChestRewards.Length > 0 )
	{
		idx = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( mChestRewards.Length );
		return mChestRewards[idx];
	}

	return rewards;
}

protected function HatchRandomResource()
{
	local H7TreasureChestRewards randomChestReward;

	SetContainerResource( mContainerResource );
	SetUseContainerMesh( true );

	randomChestReward = GetRandomReward();

	SetXP( randomChestReward.XPAmount );
	AddResource( mCurrencyResource, randomChestReward.GoldAmount );

	SetIsChest( true );

	SetAiUtilityValue( mAiUtilityValue );
	UpdatePileMeshes( self );
}
