/*=============================================================================
 * H7SeqCon_HasPlunderedMines
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================*/

class H7SeqCon_HasPlunderedMines extends H7SeqCon_Player
	implements(H7IConditionable)
	native;

/** Mines that should be plundered. */
var(Properties) protected array<H7MinePlunderCounter> mMines<DisplayName="Plundered Mines">;

var protected savegame int mPreviousPlunderedMineCount;

function protected bool IsConditionFulfilledForPlayer(H7Player player)
{
	local array<H7MinePlunderCounter> plunderData;
	local H7MinePlunderCounter currentPlunderData;
	local H7MinePlunderCounter currentPlunderCounter;
	local int matches;

	plunderData = class'H7ScriptingController'.static.GetInstance().GetPlunderedMines();
	matches = 0;

	if( mPreviousPlunderedMineCount == mMines.Length )
	{
		return true; // already fulfilled
	}

	foreach mMines(currentPlunderCounter)
	{
		foreach plunderData(currentPlunderData)
		{
			if(currentPlunderData.PlayerID == player.GetPlayerNumber() && 
				currentPlunderData.Mine == currentPlunderCounter.Mine && 
				currentPlunderData.Counter >= currentPlunderCounter.Counter)
			{
				matches++;
				break;
			}
		}
	}

	if (matches > mPreviousPlunderedMineCount)
	{
		mPreviousPlunderedMineCount = matches;
		ConditionProgressed();
	}

	return matches == mMines.Length;
}

function protected InitProgress()
{
	mProgress = class'H7Loca'.static.LocalizeSave("PLUNDER_MINES_PROGRESS","H7ConditionProgress");
}

//H7IProgressable
function bool HasProgress() 
{
	return mMines.Length > 0;
}

//H7IProgressable
function array<H7ConditionProgress> GetCurrentProgresses() 
{
	local array<H7ConditionProgress> progresses;
	local H7ConditionProgress progress;
	if (mPreviousPlunderedMineCount != -1)
	{
		progress.CurrentProgress = Min(mPreviousPlunderedMineCount, mMines.Length);
		progress.MaximumProgress = mMines.Length;
		progress.ProgressText = Repl(GetProgress(), "%current", int(progress.CurrentProgress));
		progress.ProgressText = Repl(progress.ProgressText, "%maximum", int(progress.MaximumProgress));
		progresses.AddItem(progress);
	}

	return progresses;
}

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

