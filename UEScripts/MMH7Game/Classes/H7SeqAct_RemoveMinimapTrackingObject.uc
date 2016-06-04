// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.

class H7SeqAct_RemoveMinimapTrackingObject extends SequenceAction
	implements(H7IAliasable, H7IActionable)
	native;

// The Quest Objective that tracks the Object
var(Properties) protected H7SeqAct_QuestObjective mObjective<DisplayName="Quest Objective">;
// The Minimap Tracking Object to remove
var(Properties) protected H7IQuestTarget mTrackingObject<DisplayName="Minimap Tracking Object">;

function Activated()
{
	if(mObjective != none && mTrackingObject != none && mObjective.IsActive())
	{
		mObjective.RemoveMinimapTrackingObject(mTrackingObject);
	}
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

