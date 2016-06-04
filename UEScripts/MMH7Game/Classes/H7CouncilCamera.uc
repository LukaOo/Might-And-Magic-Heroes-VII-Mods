//=============================================================================
// H7CouncilCamera
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CouncilCamera extends Camera
	dependson(H7StructsAndEnumsNative)
	dependson(H7CouncilGameInfo);

var protected H7CameraProperties mCameraProperties[ECameraMode.EnumCount];

// Used for restoring camera to state it was when matinee stopped playing
var protected Rotator mOriginalRotation;
var protected Vector mOriginalPosition;

var protected bool mMatineeActive;

function bool IsMatineeControlled()
{
	return mMatineeActive;
}

function ActivateMatineeTransform()
{
	SetLocation(mOriginalPosition);
	SetRotation(mOriginalRotation);
}

function PostBeginPlay()
{
	super.PostBeginPlay();

	
}

function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime) // TODO spams ScriptWarning: Divide by zero when min or max are equal to current
{
	local CameraActor camActor;

	camActor = CameraActor(OutVT.Target);

	if( camActor != None ) // Matinee
	{
		//super.UpdateViewTarget(OutVT, DeltaTime);

		mOriginalPosition = OutVT.POV.Location;
		mOriginalRotation = OutVT.POV.Rotation;

		// @TODO: Should also capture FOV of matinee camera

		camActor.GetCameraView(DeltaTime, OutVT.POV);
		SetFOV(camActor.FOVAngle);

		// Grab aspect ratio from the CameraActor.
		bConstrainAspectRatio	= bConstrainAspectRatio || camActor.bConstrainAspectRatio;
		OutVT.AspectRatio		= camActor.AspectRatio;

		// See if the CameraActor wants to override the PostProcess settings used.
		CamOverridePostProcessAlpha = camActor.CamOverridePostProcessAlpha;
		CamPostProcessSettings = camActor.CamOverridePostProcess;
	}
	else // Gameplay (Map)
	{
		
		// Place manual controlls for player (tilt, zoom, etc.)
	}


	mMatineeActive = camActor != none ? true : false;
}


function ResetToOriginal()
{

}

