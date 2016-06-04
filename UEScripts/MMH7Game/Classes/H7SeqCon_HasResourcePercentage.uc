// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.

class H7SeqCon_HasResourcePercentage extends H7SeqCon_Player
	implements(H7IConditionable)
	dependson(H7StructsAndEnumsNative)
	native
	savegame;

struct native H7ResourceAmount
{
	/** The type of resource */
	var() savegame archetype H7Resource Type<DisplayName="Resource">;
	/** The reference amount */
	var() savegame int Amount<DisplayName="Amount">;
};

/** Resources to check for */
var(Properties) protected array<H7ResourceAmount> mResources<DisplayName="Resources">;
/** How to compare */
var(Properties) savegame ECompareOp mOperation<DisplayName="Relation">;
/** Percentage to reach */
var(Properties) savegame int mPercent<Displayname="Required Percent"|UIMin=0|UIMax=100|ClampMin=0|ClampMax=100>;

var protected savegame int mPreviousTotalResourceAmount;
var protected savegame int mRequiredTotalResourceAmount;

function protected bool IsConditionFulfilledForPlayer(H7Player thePlayer)
{
	local H7ResourceAmount currentNeededResource;
	local int resourceIndex, resourceTotalAmount, requiredResourceAmount, currentResourceAmount;

	requiredResourceAmount = GetRequiredResourceAmount();

	// Condition already fulfilled
	if(Eval(mOperation, mPreviousTotalResourceAmount, requiredResourceAmount))
	{
		return true;
	}

	for(resourceIndex = 0; resourceIndex < mResources.Length; ++resourceIndex)
	{
		currentNeededResource = mResources[resourceIndex];
		currentResourceAmount = thePlayer.GetResourceSet().GetResource(currentNeededResource.Type);
		if(currentResourceAmount > 0)
		{

			resourceTotalAmount += currentResourceAmount;
		}
	}

	if(resourceTotalAmount != mPreviousTotalResourceAmount)
	{
		ConditionProgressed();
		mPreviousTotalResourceAmount = resourceTotalAmount;
	}

	return Eval(mOperation, resourceTotalAmount, requiredResourceAmount) && !class'H7WindowWeeklyCntl'.static.GetInstance().GetWindowWeeklyEffect().IsVisible();
}

function protected int GetRequiredResourceAmount()
{
	if(mRequiredTotalResourceAmount < 0)
	{
		InitRequiredResourceAmount();
	}
	return mRequiredTotalResourceAmount;
}

function InitRequiredResourceAmount()
{
	local H7ResourceAmount amount;
	local int absoluteTotalAmount;

	absoluteTotalAmount = 0;
	
	foreach mResources(amount)
	{
		absoluteTotalAmount += amount.Amount;
	}

	mRequiredTotalResourceAmount = Round((0.01) * mPercent * absoluteTotalAmount);
}

function protected InitProgress()
{
	mProgress = class'H7Loca'.static.LocalizeSave("HAS_RESOURCE_PERCENT_PROGRESS","H7ConditionProgress");
}

// interface H7IProgressable
function array<H7ConditionProgress> GetCurrentProgresses()
{
	local array<H7ConditionProgress> progresses;
	local H7ConditionProgress progress;
	local float percent;

	percent = 0.01*float(mPercent);

	progress.CurrentProgress = FMin(percent*(float(mPreviousTotalResourceAmount)/float(mRequiredTotalResourceAmount)), percent);
	progress.MaximumProgress = percent;
	progress.ProgressText = Repl(Repl(GetProgress(), "%current", class'H7GameUtility'.static.FloatToPercent(progress.CurrentProgress)),
		"%maximum", class'H7GameUtility'.static.FloatToPercent(progress.MaximumProgress));
	progresses.AddItem(progress);

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

