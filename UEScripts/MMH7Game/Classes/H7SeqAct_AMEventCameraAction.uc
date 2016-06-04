//=============================================================================
// H7SeqAct_AMEventCameraAction
//=============================================================================
// Kismet Action to start an H7AMEventCameraAction
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqAct_AMEventCameraAction extends SeqAct_Latent
	implements(H7IRandomPropertyOwner)
	native
	hidecategories(SequenceAction)
	savegame;

var(CameraAction) H7AMEventCameraAction mAMEventArchetype<DisplayName=AMEvent Camera Action>;
var(CameraAction) savegame Actor mStartTarget<DisplayName=Start Target>;
var(CameraAction) savegame Actor mEndTarget<DisplayName="End Target (optional)">;
var(CameraAction) bool mContinues<DisplayName=Continues with another CameraAction>;

// If this is true, Cutscene mode will be enabled and for time-frame of this node gameSpeed will by 100%
var(CameraAction) bool mEnableCutsceneMode<DisplayName=Should enable cutscene?>;

var(CameraAction) bool mLerpToCameraStartPosition<DisplayName=Lerp In>;
var(CameraAction) bool mLerpToPreviousPosition<DisplayName="Lerp Out">;
var(CameraAction) float mAnimDuration<DisplayName=AnimDuration>;
var(CameraAction) float mLerpDuration<DisplayName=Lerp In Duration>;
var(CameraAction) float mLerpOutDuration<DisplayName="Lerp Out Duration">;
var(CameraAction) bool mToggleCinimaticView<DisplayName=Toggle Cinematic View>;
var(CameraAction) bool mToggleHud<DisplayName=Toggle Hud>;
var(CameraAction) bool mFollowTarget<DisplayName=Follow Target>;

var(CameraAction) bool mOverrideArchetypeSettings<DisplayName="Override Archetype Settings">;
var(CameraAction) float mStartPitch<DisplayName=Start Pitch | EditCondition=mOverrideArchetypeSettings>;
var(CameraAction) float mEndPitch<DisplayName=End Pitch | EditCondition=mOverrideArchetypeSettings>;
var(CameraAction) float mStartYaw<DisplayName=Start Yaw | EditCondition=mOverrideArchetypeSettings>;
var(CameraAction) float mEndYaw<DisplayName=End Yaw | EditCondition=mOverrideArchetypeSettings>;
var(CameraAction) float mStartViewingDistance<DisplayName=Start Viewing Distance | EditCondition=mOverrideArchetypeSettings>;
var(CameraAction) float mEndViewingDistance<DisplayName=End Viewing Distance | EditCondition=mOverrideArchetypeSettings>;
var(CameraAction) float mStartFOV<DisplayName=Start FOV | EditCondition=mOverrideArchetypeSettings>;
var(CameraAction) float mEndFOV<DisplayName=End FOV | EditCondition=mOverrideArchetypeSettings>;
var(CameraAction) bool mEaseInOutAnimation<DisplayName=Smooth Animation | EditCondition=mOverrideArchetypeSettings>;
var(CameraAction) bool mEaseInOutLerp<DisplayName=Smooth Lerp | EditCondition=mOverrideArchetypeSettings>;
var(CameraAction) bool mFlipYawToNearerSide<DisplayName=Flip Yaw to nearer side | EditCondition=mOverrideArchetypeSettings>;


var protected bool mActionCompleted;
var protected H7CameraAction mAction;

event Activated()
{
	local H7AMEventCameraAction action;
	local H7CameraActionController cameraActionController;

	;

	if(mStartTarget != none)
	{
		mActionCompleted = false;
		
		cameraActionController = class'H7CameraActionController'.static.GetInstance();
		action = cameraActionController.Spawn(class'H7AMEventCameraAction', cameraActionController,,,,mAMEventArchetype,true);

		action.SetAnimDuration(mAnimDuration);
		action.SetLerpDuration(mLerpDuration);
		action.SetLerpOutDuration(mLerpOutDuration);
		action.SetLerpToCameraStartPosition(mLerpToCameraStartPosition);
		action.SetLerpToPreviousPosition(mLerpToPreviousPosition);
		action.SetToggleCinimaticView(mToggleCinimaticView);
		action.SetToggleHud(mToggleHud);
		action.SetFollowTarget(mFollowTarget);

		if(mOverrideArchetypeSettings)
		{
			action.SetStartPitch(mStartPitch);
			action.SetEndPitch(mEndPitch);
			action.SetStartYaw(mStartYaw);
			action.SetEndYaw(mEndYaw);
			action.SetStartViewingDistance(mStartViewingDistance);
			action.SetEndViewingDistance(mEndViewingDistance);
			action.SetStartFOV(mStartFOV);
			action.SetEndFOV(mEndFOV);
			action.SetEaseInOutAnimation(mEaseInOutAnimation);
			action.SetEaseInOutLerp(mEaseInOutLerp);
			action.SetFlipYawToNearerSide(mFlipYawToNearerSide);
		}

		class'H7CameraActionController'.static.GetInstance().StartSpawnedAMEventAction(action, mStartTarget, mEndTarget, mContinues, OnActionCompleted);
		mAction = class'H7CameraActionController'.static.GetInstance().GetCurrentAction();

		if(class'H7ReplicationInfo'.static.GetInstance() != none && mEnableCutsceneMode)
		{
			class'H7ReplicationInfo'.static.GetInstance().SetCutsceneMode(true);
		}
	}
	else
	{
		mActionCompleted  = true;
		mAction = none;
	}
}

event Cancel()
{
	if(class'H7CameraActionController'.static.GetInstance().GetCurrentAction() == mAction)
	{
		class'H7CameraActionController'.static.GetInstance().CancelCurrentCameraAction();
		mActionCompleted = true;
		mAction = none;

		if(class'H7ReplicationInfo'.static.GetInstance() != none && mEnableCutsceneMode)
		{
			class'H7ReplicationInfo'.static.GetInstance().SetCutsceneMode(false);
		}

	}
}

function OnActionCompleted()
{
	mActionCompleted = true;
	mAction = none;

	if(class'H7ReplicationInfo'.static.GetInstance() != none && mEnableCutsceneMode)
	{
		class'H7ReplicationInfo'.static.GetInstance().SetCutsceneMode(false);
	}
}

function UpdateRandomProperties(Object randomObject, Object hatchedObject)
{
	if(hatchedObject.IsA('Actor'))
	{
		if(mStartTarget == randomObject)
		{
			mStartTarget = Actor(hatchedObject);
		}

		if(mEndTarget == randomObject)
		{
			mEndTarget = Actor(hatchedObject);
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

