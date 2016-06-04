//=============================================================================
// H7SeqCon_GatherResources
//
// 
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqCon_GatherResources extends H7SeqCon_Player
	implements(H7IConditionable)
	dependson(H7StructsAndEnumsNative)
	native
	savegame;

/** How the required amount is compared */
var(Properties) protected ECompareOp mCompairOp<DisplayName="Amount should be">;
/** Resources to hold */
var(Properties) protected array<H7ResourceQuantity> mResources<DisplayName="Resources">;

var protected savegame array<int> mPreviousResourceAmounts;

var protectedwrite savegame bool mIsCompleted;
var protectedwrite savegame bool mIsFailed;

function SetCompleted( bool val )   { mIsCompleted = val; }
function SetFailed( bool val )      { mIsFailed = val; }

function protected bool IsConditionFulfilledForPlayer(H7Player player)
{
	local H7ResourceQuantity currentNeededResource;
	local int resourceIndex, currentResourceAmount;
	local bool hasEnoughResourceAmount;

	hasEnoughResourceAmount = true;

	if(mPreviousResourceAmounts.Length != mResources.Length)
	{
		for(resourceIndex = 0; resourceIndex < mResources.Length; ++resourceIndex)
		{
			mPreviousResourceAmounts.AddItem(0);
		}
	}

	for(resourceIndex = 0; resourceIndex < mResources.Length; ++resourceIndex)
	{
		currentNeededResource = mResources[resourceIndex];
		currentResourceAmount = player.GetResourceSet().GetResource(currentNeededResource.Type);

		if(currentResourceAmount != mPreviousResourceAmounts[resourceIndex])
		{
			if(!HasRequiredResourceAmount(mPreviousResourceAmounts[resourceIndex], currentNeededResource.Quantity))
			{
				ConditionProgressed(resourceIndex);
			}
			mPreviousResourceAmounts[resourceIndex] = currentResourceAmount;
		}

		if (hasEnoughResourceAmount && !HasRequiredResourceAmount(currentResourceAmount, currentNeededResource.Quantity))
		{
			hasEnoughResourceAmount = false;
		}
	}

	return hasEnoughResourceAmount && !class'H7WindowWeeklyCntl'.static.GetInstance().GetWindowWeeklyEffect().IsVisible();
}

function protected bool HasRequiredResourceAmount(int current, int required)
{
	return Eval(mCompairOp, current, required);
}

function protected InitProgress()
{
	mProgress = class'H7Loca'.static.LocalizeSave("GATHER_RESOURCES_PROGRESS","H7ConditionProgress");
}

// interface H7IProgressable
function array<H7ConditionProgress> GetCurrentProgresses()
{
	local H7ResourceQuantity currentNeededResource;
	local array<H7ConditionProgress> progresses;
	local H7ConditionProgress progress;
	local int current;

	foreach mResources(currentNeededResource)
	{
		current = class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetResourceSet().GetResource(currentNeededResource.Type);
		if( mIsCompleted )
		{
			progress.CurrentProgress = currentNeededResource.Quantity;
		}
		else if( mIsFailed )
		{
			progress.CurrentProgress = 0;
		}
		else
		{
			progress.CurrentProgress = Clamp( Min(current, currentNeededResource.Quantity), 0, currentNeededResource.Quantity );
		}
		progress.MaximumProgress = currentNeededResource.Quantity;
		progress.ProgressText = Repl(Repl(Repl(GetProgress(), "%current", int(progress.CurrentProgress)), "%maximum", int(progress.MaximumProgress)),
			"%resource", currentNeededResource.Type.GetName());
		progresses.AddItem(progress);
	}

	return progresses;
}

function bool HasProgress() { return mResources.Length > 0; }

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

