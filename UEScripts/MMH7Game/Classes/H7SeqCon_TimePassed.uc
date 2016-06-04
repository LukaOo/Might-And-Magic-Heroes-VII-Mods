//=============================================================================
// H7SeqCon_TimePassed
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqCon_TimePassed extends H7SeqCon_Condition
	implements(H7IProgressable)
	abstract
	native
	savegame;

/** Condition must stay fullfilled over the given time */
var(Properties) protected bool mUseTimer<DisplayName="Use Timer">;
/** The amount of time the condition must stay fullfilled */
var(Properties) protected int mTimeAmount<DisplayName="Amount of Time"|EditCondition=mUseTimer>;
/** The time unit used */
var(Properties) protected EConditionTimeUnit mUnit<DisplayName="Time Unit"|EditCondition=mUseTimer>;

var protected transient string mProgress;

var protected savegame int mCounter;

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
	if(mUnit == CTU_DAYS)
	{
		mProgress = class'H7Loca'.static.LocalizeSave("TIME_PASSED_PROGRESS_DAYS","H7ConditionProgress");
	}
	else if(mUnit == CTU_WEEKS)
	{
		mProgress = class'H7Loca'.static.LocalizeSave("TIME_PASSED_PROGRESS_WEEKS","H7ConditionProgress");
	}
}

// interface H7IProgressable
function array<H7ConditionProgress> GetCurrentProgresses()
{
	local array<H7ConditionProgress> progresses;
	local H7ConditionProgress progress;

	progress.CurrentProgress = Min(mCounter, mTimeAmount);
	progress.MaximumProgress = mTimeAmount;
	progress.ProgressText = Repl(GetProgress(), "%current", int(progress.CurrentProgress));
	progress.ProgressText = Repl(progress.ProgressText, "%maximum", int(progress.MaximumProgress));

	progresses.AddItem(progress);

	return progresses;
}

function bool HasProgress() { return mUseTimer; }

function protected bool HasOutputImpulse()
{
	local bool conditionFulfilled;

	conditionFulfilled = mNot ? !IsConditionFulfilled() : IsConditionFulfilled();

	if(conditionFulfilled && HasTimePassed() && !class'H7WindowWeeklyCntl'.static.GetInstance().GetWindowWeeklyEffect().IsVisible())
	{
		return conditionFulfilled && HasTimePassed();
	}

	return false;
}

function UpdateWeek()
{
	if(mUseTimer && (mUnit == CTU_WEEKS))
	{
		 UpdateCounter();
	}
}

function UpdateDay()
{
	if(mUseTimer && (mUnit == CTU_DAYS))
	{
		UpdateCounter();
	}
}

function protected UpdateCounter()
{
	local bool conditionFulfilled;
	conditionFulfilled = mNot ? !IsConditionFulfilled() : IsConditionFulfilled();

	if(conditionFulfilled)
	{
		mCounter++;
		if(mCounter <= mTimeAmount)
		{
			ConditionProgressed();
		}
	}
	else
	{
		mCounter = 0;	//	Reset counter
	}
}

function protected bool HasTimePassed()
{
	return ((mCounter >= mTimeAmount) || !mUseTimer);
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

