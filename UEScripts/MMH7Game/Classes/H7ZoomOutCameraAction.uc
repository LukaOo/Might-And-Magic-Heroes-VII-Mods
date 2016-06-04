//=============================================================================
// H7ZoomOutCameraAction
//
// Copyright 1998-2014 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7ZoomOutCameraAction extends H7CameraAction;

var() float mZoomDuration<DisplayName=Duration>;
var() float mStartViewingDistance<DisplayName=Start Viewing Distance>;
var() float mStartFOV<DisplayName=Start FOV>;
var() float mStartDelay<DisplayName=Start Delay>;

var float mTargetViewDistance;
var float mTargetFOV;

function Init(bool toGridCenter, float targetViewDistance, float targetFOV, delegate<OnActionCompleted> actionCompletedFunction = none)
{
	super.BaseInit(mZoomDuration, actionCompletedFunction);

	mTargetViewDistance = targetViewDistance;
	mTargetFOV = targetFOV;

	if(targetViewDistance <= 0)
	{
		mTargetViewDistance = mCam.CalculateInitialViewingDistance();
	}

	if(targetFOV <= 0)
	{
		mTargetFOV = mCam.GetActiveProperties().FieldOfView;
	}
}

function StopAction()
{
	super.StopAction();
	mCam.SetTargetViewingDistance(mTargetViewDistance);
}

function Update(float deltaTime)
{
	if(mStartDelay > 0)
	{
		mStartDelay -= deltaTime;
	}
	else
	{
		super.Update(deltaTime);

		mCam.SetTargetViewingDistance(FInterpEaseOut( mCam.GetTargetViewingDistance(), mTargetViewDistance, GetTimePassedInPer(), 1 ));
	}
}

