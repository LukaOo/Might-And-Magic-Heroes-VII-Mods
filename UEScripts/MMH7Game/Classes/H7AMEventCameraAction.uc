//=============================================================================
// H7AMEventCameraAction
//
// Copyright 1998-2014 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7AMEventCameraAction extends H7CameraAction;

var() float mStartPitch<DisplayName=Start Pitch>;
var() float mEndPitch<DisplayName=End Pitch>;
var() float mStartYaw<DisplayName=Start Yaw>;
var() float mEndYaw<DisplayName=End Yaw>;
var() float mStartViewingDistance<DisplayName=Start Viewing Distance>;
var() float mEndViewingDistance<DisplayName=End Viewing Distance>;
var() float mStartFOV<DisplayName=Start FOV>;
var() float mEndFOV<DisplayName=End FOV>;
var() float mLerpDuration<DisplayName=Lerp In Duration>;
var() float mLerpOutDuration<DisplayName=Lerp Out Duration>;
var() float mAnimDuration<DisplayName=AnimDuration>;
var() bool mLerpToCameraStartPosition<DisplayName=Lerp In>;
var() bool mLerpToPreviousPosition<DisplayName=Lerp Out>;
var() bool mEaseInOutAnimation<DisplayName=Smooth Animation>;
var() bool mEaseInOutLerp<DisplayName=Smooth Lerp>;
var() bool mFlipYawToNearerSide<DisplayName=Flip Yaw to nearer side>;
var() bool mToggleCinimaticView<DisplayName=Toggle Cinematic View>;
var() bool mToggleHud<DisplayName=Toggle Hud>;
var() bool mFollowTarget<DisplayName=Follow Target>;

var Vector mStartTargetPos;
var Vector mEndTargetPos;
var Actor mStartTarget;
var Actor mEndTarget;
var bool mContinues;
var H7AMEventCameraAction mContinuingAction;
delegate OnMidAction();


function SetStartPitch(float value) {mStartPitch = value;}
function SetEndPitch(float value) {mEndPitch = value;}
function SetStartYaw(float value) {mStartYaw = value;}
function SetEndYaw(float value) {mEndYaw = value;}
function SetStartViewingDistance(float value) {mStartViewingDistance = value;}
function SetEndViewingDistance(float value) {mEndViewingDistance = value;}
function SetStartFOV(float value) {mStartFOV = value;}
function SetEndFOV(float value) {mEndFOV = value;}
function SetLerpDuration(float value) {mLerpDuration = value;}
function SetLerpOutDuration(float value) {mLerpOutDuration = value;}
function SetAnimDuration(float value) {mAnimDuration = value;}
function SetLerpToCameraStartPosition(bool value) {mLerpToCameraStartPosition = value;}
function SetLerpToPreviousPosition(bool value) {mLerpToPreviousPosition = value;}
function SetEaseInOutAnimation(bool value) {mEaseInOutAnimation = value;}
function SetEaseInOutLerp(bool value) {mEaseInOutLerp = value;}
function SetFlipYawToNearerSide(bool value) {mFlipYawToNearerSide = value;}
function SetToggleCinimaticView(bool value) {mToggleCinimaticView = value;}
function SetToggleHud(bool value) {mToggleHud = value;}
function SetFollowTarget(bool value) {mFollowTarget = value;}

function SetContinuingAction(H7AMEventCameraAction continuingAction) {mContinuingAction = continuingAction;}

function Init(Actor startTarget, Actor endTarget = none, bool continues = false, delegate<OnMidAction> actionCompletedFunction = none, optional delegate<OnActionCompleted> midActionFunction = none)
{
	super.BaseInit(mLerpDuration, actionCompletedFunction);
	OnMidAction = midActionFunction;
	if( class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().IsInTownScreen() )
	{
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().LeaveTownScreen();
	}

	mStartTarget = startTarget;
	mEndTarget = endTarget;

	if(mEndTarget == none)
	{
		mEndTarget = mStartTarget;
	}

	mStartTargetPos = mStartTarget.Location;
	mEndTargetPos = mEndTarget.Location;
	mContinues = continues;

	if(continues)
	{
		mLerpToPreviousPosition = false;
	}
}

function StartAction()
{
	local Rotator rot;
	local float temp;

	super.StartAction();

	if(mToggleCinimaticView)
	{
		class'H7PlayerController'.static.GetPlayerController().ToggleCinematicView( true );
	}

	if(mToggleHud)
	{
		class'H7PlayerController'.static.GetPlayerController().GetHud().HideHUD();
	}

	if(mFlipYawToNearerSide)
	{
		if((mCam.GetCurrentRotation().Yaw < (270 * DegToUnrRot) && mStartYaw > 270) || (mCam.GetCurrentRotation().Yaw > (270 * DegToUnrRot) && mStartYaw < 270))
		{
			temp = mStartYaw;
			mStartYaw = mEndYaw;
			mEndYaw = temp;
		}
	}

	if(!mLerpToCameraStartPosition)
	{
		mCam.SetTargetVRP(mStartTargetPos);
		mCam.SetCurrentVRP(mStartTargetPos);
		mCam.SetTargetViewingDistance(mStartViewingDistance);
		mCam.SetFOV(mStartFOV);

		rot.Pitch = DegToUnrRot * mStartViewingDistance;
		rot.Yaw = DegToUnrRot * mStartYaw;
		mCam.SetCurrentRotation(rot);
		mCam.SetTargetRotation(rot);
		GotoState('MainAnimation');
	}
}

function StopAction()
{
	local Rotator rot;

	super.StopAction();

	if(mToggleCinimaticView)
	{
		class'H7PlayerController'.static.GetPlayerController().ToggleCinematicView( false );
	}

	if(mToggleHud)
	{
		class'H7PlayerController'.static.GetPlayerController().GetHud().ShowHUD();
	}

	if(mContinues)
	{
		mCam.SetIsInCameraActionMode(true);
		mCam.LockCamera(true);

		rot.Pitch = DegToUnrRot * mEndPitch;
		rot.Yaw = DegToUnrRot * mEndYaw;

		mCam.SetTargetVRP(mEndTargetPos);
		mCam.SetCurrentVRP(mEndTargetPos);
		mCam.SetTargetViewingDistance(mEndViewingDistance);
		mCam.SetCurrentRotation(rot);
		mCam.SetTargetRotation(rot);
		mCam.SetFOV(mEndFOV);
	}
	else
	{
		RevertCamToInitialValues();
	}
}

function UpdatePositions()
{
	if(mFollowTarget)
	{
		mStartTargetPos = mStartTarget.Location;
		mEndTargetPos = mEndTarget.Location;
	}
}

auto state LerpToTarget
{
	function Update(float deltaTime)
	{
		local float percent;
		local Vector pos;
		local Rotator rot;

		super.Update(deltaTime);
		UpdatePositions();
		percent = GetTimePassedInPer();
		if(mEaseInOutLerp)
		{
			percent = FInterpEaseInOut(0, 1, percent, 2);
		}

		pos = VLerp(mInitialVRP, mStartTargetPos, percent);
		mCam.SetTargetVRP(pos);
		mCam.SetCurrentVRP(pos);

		rot.Pitch = Lerp(mInitialRotation.Pitch, mStartPitch * DegToUnrRot, percent);
		rot.Yaw = Lerp(mInitialRotation.Yaw, mStartYaw * DegToUnrRot, percent);
		mCam.SetCurrentRotation(rot);
		mCam.SetTargetRotation(rot);

		mCam.SetTargetViewingDistance( Lerp(mInitialViewingDistance, mStartViewingDistance, percent) );
		mCam.SetFOV( Lerp(mInitialFOV, mStartFOV, percent) );

		if(percent >= 1)
		{
			GotoState('MainAnimation');
		}
	}

	function bool IsActionFinished()
	{
		return false;
	}
}

state MainAnimation
{
	event BeginState(name previousStateName)
	{
		mDuration = mAnimDuration;
		ResetDuration();

		if(OnMidAction != none)
		{
			OnMidAction();
		}
		OnMidAction = none;

		if(mContinuingAction != none)
		{
			mInitialVRP = mContinuingAction.GetInitialVRP();
			mInitialRotation = mContinuingAction.GetInitialRotation();
			mInitialFOV = mContinuingAction.GetInitialFOV();
			mInitialViewingDistance = mContinuingAction.GetInitialViewingDistance();
		}
	}

	function Update(float deltaTime)
	{
		local float percent;
		local Rotator rot;
		local Vector pos;

		super.Update(deltaTime);
		UpdatePositions();
		percent = GetTimePassedInPer();
		if(mEaseInOutAnimation)
		{
			percent = FInterpEaseInOut(0, 1, percent, 2);
		}

		pos = VLerp(mStartTargetPos, mEndTargetPos, percent);
		mCam.SetTargetVRP(pos);
		mCam.SetCurrentVRP(pos);

		rot.Pitch = DegToUnrRot * Lerp(mStartPitch, mEndPitch, percent);
		rot.Yaw = DegToUnrRot * Lerp(mStartYaw, mEndYaw, percent);
		mCam.SetTargetRotation(rot);
		mCam.SetCurrentRotation(rot);

		mCam.SetTargetViewingDistance( Lerp(mStartViewingDistance, mEndViewingDistance, percent) );
		mCam.SetFOV( Lerp(mStartFOV, mEndFOV, percent) );

		if(percent >= 1 && mLerpToPreviousPosition)
		{
			GotoState('LerpToPreviousPosition');
		}
	}

	function bool IsActionFinished()
	{
		if(mLerpToPreviousPosition)
		{
			return false;
		}
		else
		{
			return super.IsActionFinished();
		}
	}
}

state LerpToPreviousPosition
{
	event BeginState(name previousStateName)
	{
		mDuration = mLerpOutDuration;
		ResetDuration();
	}

	function Update(float deltaTime)
	{
		local float percent;
		local Vector pos;
		local Rotator rot;

		super.Update(deltaTime);
		UpdatePositions();
		percent = GetTimePassedInPer();
		if(mEaseInOutLerp)
		{
			percent = FInterpEaseInOut(0, 1, percent, 2);
		}

		pos = VLerp(mEndTargetPos, mInitialVRP, percent);
		mCam.SetTargetVRP(pos);
		mCam.SetCurrentVRP(pos);

		rot.Pitch = Lerp(mEndPitch * DegToUnrRot, mInitialRotation.Pitch, percent);
		rot.Yaw = Lerp(mEndYaw * DegToUnrRot, mInitialRotation.Yaw, percent);
		mCam.SetCurrentRotation(rot);
		mCam.SetTargetRotation(rot);

		mCam.SetTargetViewingDistance( Lerp(mEndViewingDistance, mInitialViewingDistance, percent) );
		mCam.SetFOV( Lerp(mEndFOV, mInitialFOV, percent) );
	}
}

