//=============================================================================
// H7SeqCon_ArmiesDefeated
//
// 
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqCon_ArmiesDefeated extends H7SeqCon_Condition
	implements(H7IConditionable, H7IProgressable)
	native
	savegame;

/** The armies that should be defeated */
var(Properties) protected array<H7AdventureArmy> mArmies<DisplayName="Armies to defeat">;

var protected transient string mProgress;
var protected savegame int mPreviousDefeatedArmies;

function protected bool IsConditionFulfilled()
{
	local int defeatedArmies;

	// Condition already fulfilled
	if(mPreviousDefeatedArmies == mArmies.Length)
	{
		return true;
	}

	defeatedArmies = GetDefeatedArmiesCount();

	if(defeatedArmies > mPreviousDefeatedArmies)
	{
		ConditionProgressed();
		mPreviousDefeatedArmies = defeatedArmies;
	}

	return defeatedArmies == mArmies.Length;
}

function protected int GetDefeatedArmiesCount()
{
	local H7AdventureArmy currentArmy;
	local int defeatedArmies;

	defeatedArmies = 0;

	foreach mArmies(currentArmy)
	{
		if(currentArmy.IsDead())
		{
			defeatedArmies++;
		}
	}

	return defeatedArmies;
}

function array<H7IQuestTarget> GetQuestTargets()
{
	local array<H7IQuestTarget> targets;
	local H7AdventureArmy army;
	foreach mArmies(army)
	{
		if(!army.IsDead())
		{
			targets.AddItem(army);
		}
	}
	return targets;
}

function protected string GetProgress()
{
	if(mProgress == "")
	{
		InitProgress();
	}
	return mProgress;
}

function protected InitProgress()
{
	mProgress = class'H7Loca'.static.LocalizeSave("ARMIES_DEFEATED_PROGRESS","H7ConditionProgress");
}

// interface H7IProgressable
function array<H7ConditionProgress> GetCurrentProgresses()
{
	local array<H7ConditionProgress> progresses;
	local H7ConditionProgress progress;
	local int currentCount;

	currentCount = GetDefeatedArmiesCount();

	progress.CurrentProgress = Min(currentCount, mArmies.Length);
	progress.MaximumProgress = mArmies.Length;
	progress.ProgressText = Repl(GetProgress(), "%current", int(progress.CurrentProgress));
	progress.ProgressText = Repl(progress.ProgressText, "%maximum", int(progress.MaximumProgress));
	progresses.AddItem(progress);

	return progresses;
}

function bool HasProgress() { return mArmies.Length > 0; }

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

