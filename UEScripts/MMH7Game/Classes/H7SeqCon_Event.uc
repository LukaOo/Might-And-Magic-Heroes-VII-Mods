//=============================================================================
// H7SeqCon_Event
//
// Class that reflects the game design concept of an event (which is different 
// from Kismet events, that represent the game design concept of a trigger).
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqCon_Event extends SequenceCondition
	implements(H7IAliasable)
	native
	savegame;

enum EEventExecution
{
	EE_ONCE<DisplayName=Once>,
	EE_MULTIPLE<DisplayName=Multiple>,
	EE_ALWAYS<DisplayName=Always>,
};

/** Name of the event, not shown ingame */
var(Properties) protected string mName<DisplayName="Name">;
/** On inactive, the trigger will not be checked (nor the conditions if there is no trigger) */
var(Properties) savegame protected EEventStatus mStatus<DisplayName="Status">;
/**  This is how often the event can be executed until it is deactivated for checking */
var(Properties) protected EEventExecution mExecute<DisplayName="Execute">;
/** Number of times the event can be executed */
var(Properties) protected int mMaxCount<DisplayName="Count"|ClampMin=2|EditCondition=mUseCount>;

var protected bool mUseCount;
var protected savegame int mCounter;

var private array<H7SeqCon_Condition> mConditions;

function EEventStatus GetStatus() { return mStatus; }
function private SetStatus(EEventStatus newStatus)
{
	if(newStatus != mStatus)
	{
		mStatus = newStatus;
		class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();
	}
}

event Activated()
{
	local bool checkConditions, fireActions;

	checkConditions = false;
	fireActions = false;

	if(mStatus == ES_INACTIVE)
	{
		if(IsActivated())
		{
			ActivateEvent();
		}
	}
	
	if (mStatus == ES_ACTIVE)
	{
		UpdateStatus();

		if(IsTriggered())
		{
			checkConditions = true;
		}

		if(AreConditionsFulFilled())
		{
			fireActions = true;
		}

		if(IsCounterReduced())
		{
			UpdateCounter();
			UpdateStatus();
		}

		if(IsDeactivated())
		{
			SetStatus(ES_INACTIVE);
		}
	}

	OutputLinks[0].bHasImpulse = checkConditions;
	OutputLinks[1].bHasImpulse = fireActions;
}

function bool IsActivated()
{
	return InputLinks[3].bHasImpulse;
}

function bool IsDeactivated()
{
	return InputLinks[4].bHasImpulse;
}

function bool IsTriggered()
{
	return InputLinks[0].bHasImpulse;
}

function bool IsCounterReduced()
{
	return InputLinks[2].bHasImpulse;
}

function ActivateEvent()
{
	SetStatus(ES_ACTIVE);
	if(mExecute == EE_MULTIPLE)
	{
		mCounter = 0;
	}
}

function bool AreConditionsFulFilled()
{
	return InputLinks[1].bHasImpulse;
}

function UpdateCounter()
{
	if(mExecute == EE_ONCE || mExecute == EE_MULTIPLE)
	{
		mCounter++;
	}
}

function UpdateStatus()
{
	if( (mExecute == EE_ONCE && mCounter == 1) || (mExecute == EE_MULTIPLE && mCounter == mMaxCount))
	{
		SetStatus(ES_INACTIVE);
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

native function array<H7SeqCon_Condition> GetConditions();

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
// (cpptext)
// (cpptext)
// (cpptext)

