//=============================================================================
// H7SeqCon_DefeatAmountOfArmies
//
// 
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqCon_DefeatAmountOfArmies extends H7SeqCon_Player
	implements(H7IConditionable)
	native
	savegame;

/** Amount of armies to defeat */
var(Properties) protected int mArmyAmount<DisplayName="Amount of Armies to defeat"|ClampMin=0>;

var protected savegame int mPreviousAmount;

function protected bool IsConditionFulfilledForPlayer(H7Player player)
{
	local int amount;
	amount = player.GetDefeatedArmiesCount();

	// Condition already fulfilled
	if(mPreviousAmount == mArmyAmount)
	{
		return true;
	}
	
	if(amount > mPreviousAmount)
	{
		ConditionProgressed();
		mPreviousAmount = amount;
	}

	return amount >= mArmyAmount;
}

function protected InitProgress()
{
	mProgress = class'H7Loca'.static.LocalizeSave("DEFEATED_ARMIES_PROGRESS","H7ConditionProgress");
}

// interface H7IProgressable
function array<H7ConditionProgress> GetCurrentProgresses()
{
	local array<H7ConditionProgress> progresses;
	local H7ConditionProgress progress;
	local int current;

	current = class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetDefeatedArmiesCount();
	progress.CurrentProgress = Min(current, mArmyAmount);
	progress.MaximumProgress = mArmyAmount;
	progress.ProgressText = Repl(GetProgress(), "%maximum", int(progress.MaximumProgress));
	progress.ProgressText = Repl(progress.ProgressText, "%current", int(progress.CurrentProgress));
	progresses.AddItem(progress);

	return progresses;
}

function bool HasProgress() { return true; }

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

