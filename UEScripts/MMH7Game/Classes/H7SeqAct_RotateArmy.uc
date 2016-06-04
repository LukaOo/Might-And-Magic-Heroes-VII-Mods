/*=============================================================================
 * H7SeqAct_RotateArmy
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ===========================================================================*/

class H7SeqAct_RotateArmy extends H7SeqAct_LatentArmyAction
	native;

/** Rotate instantly without animation. */
var(Properties) protected bool mInstant<DisplayName="Instant">;

/** The direction the spawned army should look into. Only available when Look at is set to none. */
var(Rotation) protected EDirection mTargetDirection<DisplayName="Direction"|EditCondition=mUseDirection>;
/** The object the spawned army should look at. */
var(Rotation) protected H7EditorMapObject mTargetObject<DisplayName="Look at">;

var private transient bool mUseDirection;

function bool IsInstant() { return mInstant; }

function rotator GetTargetRotation()
{
	local rotator targetRotation;

	targetRotation = GetTargetArmy().Rotation;

	if(mUseDirection || mTargetObject == none)
	{
		targetRotation.Yaw = class'H7GameUtility'.static.DirectionToOpposingAngle(mTargetDirection);
	}
	else
	{
		targetRotation.Yaw = (rotator(mTargetObject.Location - GetTargetArmy().Location)).Yaw;
	}

	return targetRotation;
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
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

