// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.

class H7SeqAct_StartTimer extends SequenceAction
	implements(H7IAliasable, H7IActionable)
	savegame
	native;

/** The name of this timer */
var(Properties) protected string mName<DisplayName="Timer name">;
/** The amount of time until this timer expires */
var(Properties) protected int mTimeAmount<DisplayName="Amount of Time">;
/** The time unit used */
var(Properties) protected EConditionTimeUnit mUnit<DisplayName="Time Unit">;

var protected savegame int mCounter;
var protected savegame bool mIsStarted;
var protected transient H7TimerEventParam mTimerEventParam;

function int GetCount()
{
	return mCounter;
}

function bool IsStarted()
{
	return mIsStarted;
}

function EConditionTimeUnit GetUnit()
{
	return mUnit;
}

event Activated()
{
	mTimerEventParam = new class'H7TimerEventParam';
	mIsStarted = true;
	class'H7ScriptingController'.static.GetInstance().RegisterTimer(self);
}

function UpdateWeek()
{
	if(mUnit == CTU_WEEKS)
	{
		 UpdateCounter();
	}
}

function UpdateDay()
{
	if(mUnit == CTU_DAYS)
	{
		UpdateCounter();
	}
}

function protected UpdateCounter()
{
	local H7ScriptingController scriptingController;
	if(mIsStarted && mCounter < mTimeAmount)
	{
		++mCounter;

		if(mCounter == mTimeAmount)
		{
			scriptingController = class'H7ScriptingController'.static.GetInstance();
			mIsStarted = false;
			mTimerEventParam.mStartTimer = self;

			scriptingController.TriggerEventParam(class'H7SeqEvent_TimerExpired', mTimerEventParam, scriptingController);
			scriptingController.UnregisterTimer(self);
		}
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

event PostSerialize()
{
	mTimerEventParam = new class'H7TimerEventParam';
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

