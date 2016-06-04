//=============================================================================
// H7ZoomInCameraAction
//
// Copyright 1998-2014 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7ZoomInCameraAction extends H7CameraAction;

var() float mTargetFOV<DisplayName=Target FOV>;
var() float mTargetViewDistance<DisplayName=Target Viewing Distance>;
var() float mZoomDuration<DisplayName=Duration>;

var Vector mTargetPos;

function Init(Vector targetPos, delegate<OnActionCompleted> actionCompletedFunction = none)
{
	super.BaseInit(mZoomDuration, actionCompletedFunction);

	mTargetPos = targetPos; 
}

function StopAction()
{
	super.StopAction();
	class'H7CameraActionController'.static.GetInstance().SetCombatStartEffectStrength(0);

	// keep camera in action mode to not reset current position/angle till combat ends
	mCam.SetIsInCameraActionMode(true);
}

function Update(float deltaTime)
{
	local float percent, percentEase;

	super.Update(deltaTime);
	percent = GetTimePassedInPer();
	percentEase = FInterpEaseInOut(0, 1, percent, 2);

	class'H7CameraActionController'.static.GetInstance().SetCombatStartEffectStrength(FClamp(percent * 0.15f, 0, 0.1f));

	mCam.SetTargetVRP(VLerp( mInitialVRP, mTargetPos, percentEase ));
	mCam.SetCurrentVRP(mCam.GetTargetVRP());
	mCam.SetFOV(Lerp(mInitialFOV, mTargetFOV, percentEase));
	mCam.SetTargetViewingDistance(Lerp( mInitialViewingDistance, mTargetViewDistance, percentEase )); 
}

