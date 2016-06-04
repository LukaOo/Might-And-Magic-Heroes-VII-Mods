//=============================================================================
// H7SeqAct_FocusCamera
//=============================================================================
// Kismet action to focus the current game camera on a certain actor
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7SeqAct_FocusCamera extends SequenceAction
	implements(H7IAliasable, H7IActionable, H7IRandomPropertyOwner)
	native
	savegame;

enum EFocusCameraZoomValue
{
	EFocusCameraZoomValue_ValueMax<DisplayName="Max">,
	EFocusCameraZoomValue_ValueMin<DisplayName="Min">,
	EFocusCameraZoomValue_ValueDefault<DisplayName="Default">,
	EFocusCameraZoomValue_ValueCustom<DisplayName="Custom">
};

/** The camera moves with the target */
var(Properties) protected bool mFollowTarget<DisplayName="Follow target">;
/** Take camera control from player */
var(Properties) protected bool mLockCamera<DisplayName="Take camera control from player">;
/** The target of the camera */
var(Properties) protected savegame Actor mFocusActor<DisplayName="Camera target">;
/** When on, set zoom */
var(Developer) protected bool mZoom<DisplayName="Use Zoom">;
/** When on, set zoom to max */
var(Developer) protected EFocusCameraZoomValue mZoomValue<DisplayName="Zoom To" | EditCondition=mZoom>;
/** Custom zoom distance */
var(Developer) protected float mZoomCustomDistance<DisplayName="Zoom Custom Distance" | EditCondition=mZoom>;

event Activated()
{
	local H7Camera cam;
	cam = class'H7Camera'.static.GetInstance();

	if (mFocusActor != none)
	{
		cam.SetFocusActor( mFocusActor, -1, mFollowTarget, true );
		if(mLockCamera)
		{
			cam.LockCamera(true);
		}
	}

	if (mZoom)
	{
		switch(mZoomValue)
		{
		case EFocusCameraZoomValue_ValueMax:
			cam.SetTargetViewingDistance(cam.GetActiveProperties().ViewDistanceMaximum);
			break;
		case EFocusCameraZoomValue_ValueMin:
			cam.SetTargetViewingDistance(cam.GetActiveProperties().ViewDistanceMinimum);
			break;
		case EFocusCameraZoomValue_ValueDefault:
			cam.ResetCurrentViewingDistance();
			break;
		case EFocusCameraZoomValue_ValueCustom:
			cam.SetTargetViewingDistance(mZoomCustomDistance);
			break;
		}
	}
	else
	{
		cam.ResetCurrentViewingDistance();
	}
}

function UpdateRandomProperties(Object randomObject, Object hatchedObject)
{
	if(hatchedObject.IsA('Actor'))
	{
		if(mFocusActor == randomObject)
		{
			mFocusActor = Actor(hatchedObject);
		}
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

