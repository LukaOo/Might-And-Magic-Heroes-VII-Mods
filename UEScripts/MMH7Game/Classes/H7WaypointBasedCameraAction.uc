//=============================================================================
// H7WaypointBasedCameraAction
//
// Copyright 1998-2014 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7WaypointBasedCameraAction extends H7CameraAction;

/* To prevent the camera to go below the ground*/
var(CameraAction) const float CLAMP_HEIGHT_MIN<DisplayName=Minimum Camera Height>;

enum EInterpType 
{
	IT_LINEAR,
	IT_JUMP,
	IT_EASEIN,
	IT_EASEOUT,
	IT_EASEINOUT,
	IT_HOLD
};

struct H7CameraWaypoint
{
	var Vector      TargetPos;
	var Rotator     TargetRot;
	var float	    TargetViewDistance;
	var float       TargetFoV;
	var EInterpType InterpType;
	var float       Duration;

	var H7Unit      TargetUnit;
	var ECreatureAnimation  CreatureAnim;
	var EHeroAnimation      HeroAnim;
};

var protected array<H7CameraWaypoint> mWaypoints;
var protected int                     mWaypointIdx;

var protected float                   mStepTimer;

var protected bool                      mIsRunning;

function StartAction()
{
	super.StartAction();
}

/** 
 *  Let's the camera instantly jump to toWaypoint
 */
function JumpCameraTo(H7CameraWaypoint toWaypoint)
{
	mCam.SetTargetVRP( toWaypoint.TargetPos );
	mCam.SetTargetViewingDistance(toWaypoint.TargetViewDistance); 
	mCam.SetTargetRotation( toWaypoint.TargetRot );
	mCam.SetFOV( toWaypoint.TargetFoV );
		
	mCam.SetCurrentVRP(mCam.GetTargetVRP());
	mCam.SetCurrentRotation(mCam.GetTargetRotation());
}

function StopAction()
{
	super.StopAction();
	mCam.SetTargetVRP(mCam.GetDefaultGridCenter());
	mCam.SetCurrentVRP(mCam.GetDefaultGridCenter());
	mCam.SetTargetViewingDistance(mCam.AdjustCombatViewingDistance(mCam.GetActiveProperties().ViewingDistance));
	mCam.SetCurrentRotation(mCam.GetActiveProperties().Rotation);
	mCam.SetTargetRotation(mCam.GetActiveProperties().Rotation);
	mCam.SetFOV(mCam.GetActiveProperties().FieldOfView);
}

/** 
 *  Interpolates the camera's VRP between fromWaypoint and toWaypoint, using position, rotation and viewing-distance
 *  @param percent Amount of completion, therefore position between the waypoints
 *  @param fromWaypoint 
 *  @param toWaypoint if InterpType is IT_JUMP, it will jump
 */
function MoveCameraFromTo(float percent, H7CameraWaypoint fromWaypoint, H7CameraWaypoint toWaypoint)
{
	local Rotator tempRot;


	if( (toWaypoint.InterpType == IT_JUMP) )
	{
		JumpCameraTo(toWaypoint);
	}
	else
	{
		mCam.SetTargetVRP( VLerp( fromWaypoint.TargetPos , toWaypoint.TargetPos, percent ));
		mCam.SetTargetViewingDistance(Lerp( fromWaypoint.TargetViewDistance, toWaypoint.TargetViewDistance, percent ) ); 
			tempRot.Yaw     = Lerp( fromWaypoint.TargetRot.Yaw  , toWaypoint.TargetRot.Yaw  , percent );
			tempRot.Pitch   = Lerp( fromWaypoint.TargetRot.Pitch, toWaypoint.TargetRot.Pitch, percent );
			tempRot.Roll    = Lerp( fromWaypoint.TargetRot.Roll , toWaypoint.TargetRot.Roll , percent );
		mCam.SetTargetRotation( tempRot );
	}
		
	mCam.SetCurrentVRP(mCam.GetTargetVRP());
	mCam.SetCurrentRotation(mCam.GetTargetRotation());
}

/** 
 *  Adds a waypoint to the list of this CameraAction (appended to the end)
 */
function AddWaypoint(Vector targetPosition, Rotator targetRotation, float targetViewDist, float targetFoV, EInterpType interpType, float duration)
{
	local int k;

	k = mWaypoints.Length;
	mWaypoints.Add(1);

	mWaypoints[k].TargetPos          = targetPosition;
	mWaypoints[k].TargetRot          = targetRotation;
	mWaypoints[k].TargetViewDistance = targetViewDist;
	mWaypoints[k].TargetFoV          = targetFoV;
	mWaypoints[k].InterpType         = interpType;
	mWaypoints[k].TargetUnit         = none;
	mWaypoints[k].Duration           = duration;
}

/**
 * Adds a waypoint to the list of this CameraAction based on a CreatureStacks mesh-center-position and rotation (height is clamped to CLAMP_HEIGHT_MIN)
 */
function AddWaypointStack(H7CreatureStack stack, EInterpType interpType , optional int yaw = 0, optional int pitch = 0, optional int roll = 0,  optional Vector offset = Vect(0,0,0), optional int viewDist = 0, optional float FoV = 60.0f, optional ECreatureAnimation creatureAnim = CAN_MAX, optional float duration = 0)
{
	local Vector tempVect;
	local Rotator rot;
	local int k;

	k = mWaypoints.Length;
	mWaypoints.Add(1);

	if(stack.Location.Z + offset.Z >= CLAMP_HEIGHT_MIN)
	{
		mWaypoints[k].TargetPos          = stack.GetMeshCenter() + offset;
	}
	else
	{
		;
			tempVect.X = stack.GetMeshCenter().X + offset.X;
			tempVect.Y = stack.GetMeshCenter().Y + offset.Y;
			tempVect.Z = stack.Location.Z + CLAMP_HEIGHT_MIN;
		mWaypoints[k].TargetPos = tempVect;
	}

	rot.Pitch= class'H7Math'.static.ConvertDegreeToUnrealDegree(pitch); 
	rot.Yaw  = stack.Rotation.Yaw + class'H7Math'.static.ConvertDegreeToUnrealDegree((180 + yaw) % 360);
	rot.Roll = class'H7Math'.static.ConvertDegreeToUnrealDegree(roll);

	mWaypoints[k].TargetRot          = rot;
	mWaypoints[k].TargetViewDistance = viewDist;
	mWaypoints[k].TargetFoV          = FoV;
	mWaypoints[k].InterpType         = interpType;
	mWaypoints[k].TargetUnit         = stack;
	mWaypoints[k].CreatureAnim       = creatureAnim;
	mWaypoints[k].Duration           = duration;
}

/**
 * Adds a waypoint to the list of this CameraAction based on a Hero's mesh-center-position and rotation (height is clamped to CLAMP_HEIGHT_MIN)
 */
function AddWaypointHero(H7CombatHero hero, EInterpType interpType , optional int yaw = 0, optional int pitch = 0, optional int roll = 0,  optional Vector offset = Vect(0,0,0), optional int viewDist = 0,  optional float FoV = 60.0f, optional EHeroAnimation heroAnim = HA_MAX, optional float duration = 0 )
{
	local Vector tempVect;
	local Rotator rot;
	local int k;
	
	k = mWaypoints.Length;
	mWaypoints.Add(1);

	if((hero.GetMeshCenter().Z + offset.Z) - hero.Location.Z >= CLAMP_HEIGHT_MIN)
	{
		mWaypoints[k].TargetPos          = hero.GetMeshCenter() + offset;
	}
	else
	{
		//`log_cam("      PresentArmy (Hero) clamped height from"@hero.GetMeshCenter().Z + offset.Z - hero.Location.Z@"to"@CLAMP_HEIGHT_MIN);
			tempVect.X = hero.GetMeshCenter().X + offset.X;
			tempVect.Y = hero.GetMeshCenter().Y + offset.Y;
			tempVect.Z = hero.Location.Z + CLAMP_HEIGHT_MIN;
		mWaypoints[k].TargetPos = tempVect;
	}

	rot.Pitch= class'H7Math'.static.ConvertDegreeToUnrealDegree(pitch); 
	rot.Yaw  = hero.Rotation.Yaw + class'H7Math'.static.ConvertDegreeToUnrealDegree((180 + yaw) % 360);
	rot.Roll = class'H7Math'.static.ConvertDegreeToUnrealDegree(roll);

	mWaypoints[k].TargetRot          = rot;
	mWaypoints[k].TargetViewDistance = viewDist;
	mWaypoints[k].TargetFoV          = FoV;
	mWaypoints[k].InterpType         = interpType;
	mWaypoints[k].TargetUnit         = hero;
	mWaypoints[k].HeroAnim           = heroAnim;
	mWaypoints[k].Duration           = duration;
}

/** 
 *  Gives the time passed (in decimal percent to complection) since movement from one waypoint to another started
 *  @return 0.0f is start, >1.0f is complete
 */
function float GetTimePassedForStep()
{
	if(mWaypoints[mWaypointIdx].Duration > 0)
	{
		return (mStepTimer / mWaypoints[mWaypointIdx].Duration);
	}
	return 1.0f;
}

/** 
 *  Gives the percentage of the distance that is completed ( can be non-linear, thus is not the same as GetTimePassedForStep() )
 */
function float CalcInterpPercentForWP(int wpIdx, float timePassed)
{
	local float percent;

	switch (mWaypoints[wpIdx].InterpType)
	{
		case IT_LINEAR:
			percent = timePassed;
			break;
		case IT_JUMP:
			percent = 1.1f;
			break;
		case IT_EASEIN:
			percent = FInterpEaseIn(0, 1, timePassed, 2);
			break;
		case IT_EASEOUT:
			percent = FInterpEaseOut(0, 1, timePassed, 2);
			break;
		case IT_EASEINOUT:
			percent = FInterpEaseInOut(0, 1, timePassed, 2);
			break;
		case IT_HOLD:
			percent = timePassed;
			break;
		default:
			// DO LINEAR - nothing fancy, but if something is wrong, we'll atleast see it ... probably
			percent = timePassed;
			break;
	}

	return percent;
}
