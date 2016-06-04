/*=============================================================================
 * H7SeqAct_ToggleObjectVisibility
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================*/

class H7SeqAct_ChangeObjectVisibility extends SequenceAction
	implements(H7IRandomPropertyOwner)
	native
	savegame;

/** The object that should be hidden or shown */
var(Properties) savegame H7EditorMapObject mTargetObject<DisplayName="Target object">;
/** Toggle between show and hide */
var(Properties) bool mToggle<DisplayName="Toggle?">;
/** Show or hide object */
var(Properties) bool mShow<DisplayName="Show object?"|EditCondition=!mToggle>;

event Activated()
{
	if(mToggle)
	{
		mTargetObject.ToggleVisibility();
	}
	else
	{
		mTargetObject.SetVisibility(mShow);
	}
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

function UpdateRandomProperties(Object randomObject, Object hatchedObject)
{
	if(hatchedObject.IsA('H7EditorMapObject'))
	{
		if(mTargetObject == randomObject)
		{
			mTargetObject = H7EditorMapObject(hatchedObject);
		}
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

