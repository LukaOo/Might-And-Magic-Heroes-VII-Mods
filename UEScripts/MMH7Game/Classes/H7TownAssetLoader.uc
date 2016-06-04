//=============================================================================
// H7TownAssetLoader
//=============================================================================
// 
// class for distributing loading of townassets over several frames
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7TownAssetLoader extends Object;

var protected transient array<H7TownBuilding> mLoadingQueue;

static function H7TownAssetLoader GetInstance()
{
	return class'H7PlayerController'.static.GetPlayerController().GetTownAssetLoader();
}

function AddToLoadingQueue(H7TownBuilding building)
{
	mLoadingQueue.AddItem(building);
}

function ProcessQueue()
{
	if(mLoadingQueue.Length > 0)
	{
		if(!mLoadingQueue[0].HasTownAssetLoaded())
		{
			mLoadingQueue[0].GetTownAsset(); // leave it in queue to check townassets next frame
		}
		else
		{
			mLoadingQueue[0].GetTownAssets();
			mLoadingQueue.Remove(0,1);
		}
	}

	if(mLoadingQueue.Length > 0)
	{
		class'H7PlayerController'.static.GetPlayerController().GetHud().SetFrameTimer(2,ProcessQueue);
	}
}

function ProcessQueueNextFrame()
{
	class'H7PlayerController'.static.GetPlayerController().GetHud().SetFrameTimer(1,ProcessQueue);
}
