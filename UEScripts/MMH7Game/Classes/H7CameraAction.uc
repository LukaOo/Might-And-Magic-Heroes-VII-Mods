//=============================================================================
// H7CameraAction
//
// Manages events that occur on the adventure map that triggers the camera to move to a certain place
//
// Copyright 1998-2014 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7CameraAction extends Actor
	HideCategories(Movement,Display,Attachment,Collision,Physics,Advanced,Debug,Object,Mobile);

var float mDuration;
var float mTimer;
var H7Camera mCam;

var Vector mInitialVRP;
var float mInitialViewingDistance;
var Rotator mInitialRotation;
var float mInitialFOV;
var int mCurrentStep;
var int mMaxSteps;

function Vector GetInitialVRP() { return mInitialVRP; }
function float GetInitialViewingDistance() { return mInitialViewingDistance; }
function Rotator GetInitialRotation() { return mInitialRotation; }
function float GetInitialFOV() { return mInitialFOV; }

delegate OnActionCompleted();

function float GetTimePassedInPer()
{
	return mTimer / mDuration;
}

function BaseInit(float duration, delegate<OnActionCompleted> actionCompletedFunction)
{
	mMaxSteps = 1;
	mDuration = duration;
	mTimer = 0;

	mCam = class'H7Camera'.static.GetInstance();
	OnActionCompleted = actionCompletedFunction;
}

function bool IsActionFinished()
{
	return mTimer >= mDuration && mCurrentStep +1 >= mMaxSteps;
}

function SetDuration(float duration)
{
	mDuration = duration;
}

function float GetDuration()
{
	return mDuration;
}

function ResetDuration()
{
	mTimer = 0;
}

function StartAction()
{
	class'H7PlayerController'.static.GetPlayerController().SetCameraActionRunning(true);
	mCam.SetIsInCameraActionMode(true);
	mCam.LockCamera(true);

	mInitialVRP = mCam.GetCurrentVRP();
	mInitialViewingDistance = mCam.GetTargetViewingDistance();
	mInitialRotation = mCam.GetCurrentRotation();
	mInitialFOV = mCam.GetFOVAngle();
}

function StopAction()
{
	class'H7PlayerController'.static.GetPlayerController().SetCameraActionRunning(false);

	mCam.SetIsInCameraActionMode(false);
	mCam.LockCamera(false);
	class'H7CameraActionController'.static.GetInstance().ClearCurrentAction();
	if(OnActionCompleted != none)
	{
		OnActionCompleted();
	}
	OnActionCompleted = none;
}

protected function RevertCamToInitialValues()
{
	mCam.SetTargetVRP(mInitialVRP);
	mCam.SetCurrentVRP(mInitialVRP);
	mCam.SetTargetViewingDistance(mInitialViewingDistance);
	mCam.SetCurrentRotation(mInitialRotation);
	mCam.SetTargetRotation(mInitialRotation);
	mCam.SetFOV(mInitialFOV);
}

function Update(float deltaTime)
{
	mTimer += deltaTime;

	if(mTimer >= mDuration)
	{
		mTimer = mDuration;
	}
}
