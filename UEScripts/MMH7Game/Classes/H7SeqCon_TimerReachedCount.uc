//=============================================================================
// H7SeqCon_TimePassed
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqCon_TimerReachedCount extends H7SeqCon_Condition
	implements(H7IProgressable, H7IConditionable)
	native
	savegame;

// The timer to check
var (Properties) H7SeqAct_StartTimer mTimer<DisplayName="Timer">;
// The counter the timer should have
var(Properties) protected int mCount<DisplayName="Count">;

var protected transient string mProgress;

var protected savegame int mPreviousTimerCount;

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
	if(mTimer == none)
	{
		return;
	}
	if(mTimer.GetUnit() == CTU_DAYS)
	{
		mProgress = class'H7Loca'.static.LocalizeSave("TIME_PASSED_PROGRESS_DAYS","H7ConditionProgress");
	}
	else if(mTimer.GetUnit() == CTU_WEEKS)
	{
		mProgress = class'H7Loca'.static.LocalizeSave("TIME_PASSED_PROGRESS_WEEKS","H7ConditionProgress");
	}
}

function protected int GetTimerCount()
{
	return (mTimer == none || !mTimer.IsStarted()) ? 0 : mTimer.GetCount();
}

// interface H7IProgressable
function array<H7ConditionProgress> GetCurrentProgresses()
{
	local array<H7ConditionProgress> progresses;
	local H7ConditionProgress progress;

	progress.CurrentProgress = Min(GetTimerCount(), mCount);
	progress.MaximumProgress = mCount;
	progress.ProgressText = Repl(GetProgress(), "%current", int(progress.CurrentProgress));
	progress.ProgressText = Repl(progress.ProgressText, "%maximum", int(progress.MaximumProgress));

	progresses.AddItem(progress);

	return progresses;
}

function bool HasProgress() { return (mTimer != none); }

function protected bool HasOutputImpulse()
{
	local bool conditionFulfilled;

	conditionFulfilled = mNot ? !IsConditionFulfilled() : IsConditionFulfilled();

	if(conditionFulfilled && !class'H7WindowWeeklyCntl'.static.GetInstance().GetWindowWeeklyEffect().IsVisible())
	{
		return conditionFulfilled;
	}

	return false;
}

function protected bool IsConditionFulfilled()
{
	if(mTimer != none && mTimer.IsStarted())
	{
		// Condition already fulfilled
		if(mPreviousTimerCount >= mCount)
		{
			return true;
		}

		if(GetTimerCount() > mPreviousTimerCount)
		{
			ConditionProgressed();
			mPreviousTimerCount = GetTimerCount();
		}

		return GetTimerCount() >= mCount;
	}

	return false;
}

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

