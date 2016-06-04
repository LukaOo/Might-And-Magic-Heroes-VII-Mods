/*=============================================================================
 * H7SeqCon_HasCollectedArmies
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================*/

class H7SeqCon_HasCollectedArmies extends H7SeqCon_Player
	implements(H7IConditionable)
	native
	savegame;

/** The armies that should be collected. */
var(Properties) protected array<H7AdventureArmy> mArmiesToCollect<DisplayName="Armies to collect">;

var protected savegame array<EPlayerNumber> mCollectors;
var protected savegame int mPreviousMatches;

function protected bool IsConditionFulfilledForPlayer(H7Player thePlayer)
{
	local int matches;

	// Condition already fulfilled
	if(mPreviousMatches == mArmiesToCollect.Length)
	{
		return true;
	}

	matches = GetMatches(thePlayer);

	if(matches > mPreviousMatches)
	{
		ConditionProgressed();
		mPreviousMatches = matches;
	}

	return (matches == mArmiesToCollect.Length);
}

function int GetMatches(H7Player thePlayer)
{
	local EPlayerNumber collector;
	local int matches;

	matches = 0;
	foreach mCollectors(collector)
	{
		if(collector == thePlayer.GetPlayerNumber())
		{
			++matches;
		}
	}
	return matches;
}

function UpdateCollectedArmies(EPlayerNumber playerID, H7AdventureArmy army)
{
	if(mArmiesToCollect.Find(army) >= 0)
	{
		mCollectors.AddItem(playerID);
	}
}

function protected InitProgress()
{
	mProgress = class'H7Loca'.static.LocalizeSave("COLLECTED_ARMIES_PROGRESS","H7ConditionProgress");
}

// interface H7IProgressable
function array<H7ConditionProgress> GetCurrentProgresses()
{
	local array<H7ConditionProgress> progresses;
	local H7ConditionProgress progress;
	local int current;

	current = GetMatches(class'H7AdventureController'.static.GetInstance().GetCurrentPlayer());
	progress.CurrentProgress = Min(current, mArmiesToCollect.Length);
	progress.MaximumProgress = mArmiesToCollect.Length;
	progress.ProgressText = Repl(GetProgress(), "%current", int(progress.CurrentProgress));
	progress.ProgressText = Repl(progress.ProgressText, "%maximum", int(progress.MaximumProgress));
	progresses.AddItem(progress);

	return progresses;
}

function bool HasProgress() { return true; }

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

