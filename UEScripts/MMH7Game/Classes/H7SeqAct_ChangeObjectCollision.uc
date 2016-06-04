/*=============================================================================
 * H7SeqAct_ToggleObjectCollision
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================*/

class H7SeqAct_ChangeObjectCollision extends SequenceAction
	implements(H7IRandomPropertyOwner)
	native
	savegame;

/** The object whose collision should change */
var(Properties) savegame H7EditorMapObject mTargetObject<DisplayName="Target object">;
/** Toggle between COLLIDE_BlockAll and COLLIDE_NoCollision */
var(Properties) bool mToggle<DisplayName="Toggle?">;
/** The game supports COLLIDE_BlockAll and COLLIDE_NoCollision */
var(Properties) ECollisionType mNewCollisionType<DisplayName="New collision type"|EditCondition=!mToggle>;

event Activated()
{
	if(mToggle)
	{
		if(mTargetObject.CollisionType == COLLIDE_BlockAll)
		{
			mTargetObject.SetCollisionType(COLLIDE_NoCollision);
		}
		else if(mTargetObject.CollisionType == COLLIDE_NoCollision)
		{
			mTargetObject.SetCollisionType(COLLIDE_BlockAll);
		}
	}
	else
	{
		mTargetObject.SetCollisionType(mNewCollisionType);
	}
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

