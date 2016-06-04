//=============================================================================
// H7AbilityCastCameraAction
//
// Copyright 1998-2014 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7AbilityCastCameraAction extends H7CameraAction;

var(Caster) float mCasterStartYawOffset<DisplayName=Start Yaw Offset>;
var(Caster) float mCasterStartPitchOffset<DisplayName=Pitch Offset>;
var(Caster) float mCasterEndYawOffset<DisplayName=End Yaw Offset>;
var(Caster) float mCasterFOV<DisplayName=Field of View>;
var(Caster) float mCasterViewingDistance<DisplayName=Viewing Distance>;
var(Caster) float mCastDuration<DisplayName=Duration>;

var Rotator mBaseRotation;
var Vector mTargetPos;
var H7Unit mCaster;

var float mCurrentYawOffset;
var float mTargetYawOffset;
var float mCurrentPitchOffset;
var float mTargetPitchOffset;
var float mRandomOffsetDuration;
var float mRandomOffsetTimer;

function Init(H7Unit caster)
{
	super.BaseInit(mCastDuration, none);

	mCaster = caster;
}

function StartAction()
{
	super.StartAction();

	mTargetPos = mCaster.GetMeshCenter();
	mBaseRotation.Yaw = DegToUnrRot * mCasterStartYawOffset;
	mBaseRotation.Pitch = DegToUnrRot * mCasterStartPitchOffset;

	mCam.SetTargetVRP(mTargetPos);
	mCam.SetCurrentVRP(mTargetPos);
	mCam.SetFOV(mCasterFOV);
	mCam.SetTargetViewingDistance(mCasterViewingDistance);
	mCam.SetCurrentRotation(mBaseRotation);
	mCam.SetTargetRotation(mBaseRotation);

	//StartNewRandomOffset();
}

function StartNewRandomOffset()
{
	local float randomDegree, randomDistance;

	mCurrentPitchOffset = mTargetPitchOffset;
	mCurrentYawOffset = mTargetYawOffset;
	mRandomOffsetTimer = 0;
	mRandomOffsetDuration = FRand() * 0.25f + 0.5f;
	randomDegree = FRand() * PI * 2;
	randomDistance = FRand() * 0.25f + 0.25f;
	mTargetPitchOffset = Sin(randomDegree) * randomDistance;
	mTargetYawOffset = Cos(randomDegree) * randomDistance;
}

function StopAction()
{
	super.StopAction();

	RevertCamToInitialValues();
}

function Update(float deltaTime)
{
	//local float randomOffsetPercent;
	//local Rotator rot;

	super.Update(deltaTime);

	//mRandomOffsetTimer += deltaTime;
	//randomOffsetPercent = mRandomOffsetTimer / mRandomOffsetDuration;
	//randomOffsetPercent = FClamp(randomOffsetPercent, 0, 1);
	//randomOffsetPercent = FInterpEaseInOut(0, 1, randomOffsetPercent, 2);

	mBaseRotation.Yaw = Lerp(mCasterStartYawOffset, mCasterEndYawOffset, GetTimePassedInPer()) * DegToUnrRot;
	//rot = mBaseRotation;
	//rot.Yaw += DegToUnrRot * (mCurrentYawOffset + (mTargetYawOffset - mCurrentYawOffset) * randomOffsetPercent);
	//rot.Pitch += DegToUnrRot *(mCurrentPitchOffset + (mTargetPitchOffset - mCurrentPitchOffset) * randomOffsetPercent);

	mCam.SetCurrentRotation(mBaseRotation);
	mCam.SetTargetRotation(mBaseRotation);

	/*if(mRandomOffsetTimer >= mRandomOffsetDuration)
	{
		StartNewRandomOffset();
	}*/
}

