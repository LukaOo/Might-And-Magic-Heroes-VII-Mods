// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.

class H7SeqCon_QuestIs extends H7SeqCon_TimePassed
	implements(H7IConditionable)
	native;

// The quest whose status should be checked.
var(Properties) protected H7SeqAct_Quest_NewNode mQuest<DisplayName="Quest">;
// The quest status to check for.
var(Properties) protected EQuestOrObjectiveStatus mStatus<DisplayName="Status">;

function protected bool IsConditionFulfilled()
{
	if(mQuest == none)
	{
		return false;
	}
	else if(mStatus == QOS_ONGOING)
	{
		return !mQuest.IsStarted();
	}
	else if(mStatus == QOS_COMPLETED)
	{
		return (mQuest.GetQuestStatus() == QOS_COMPLETED);
	}
	else if(mStatus == QOS_FAILED)
	{
		return (mQuest.GetQuestStatus() == QOS_FAILED);
	}
	else if(mStatus == QOS_ACTIVATED)
	{
		return (mQuest.IsStarted() && (mQuest.GetQuestStatus() == QOS_ONGOING || mQuest.GetQuestStatus() == QOS_ACTIVATED));
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

