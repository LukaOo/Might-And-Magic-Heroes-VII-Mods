//=============================================================================
// H7IntroduceHeroCameraAction
//
// Copyright 1998-2014 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7IntroduceHeroCameraAction extends H7WaypointBasedCameraAction;

var(CameraAction) const float HERO_DISTANCE<DisplayName=ViewDistance on Heroes>;

var(CameraAction) const Vector HERO_OFFSET_START<DisplayName=Hero Position Offset Start>;
var(CameraAction) const float CAM_PITCH_HERO_START<DisplayName=Hero Pitch Start>;
var(CameraAction) const float CAM_ROLL_HERO_START<DisplayName=Hero Roll Start>;
var(CameraAction) const float CAM_YAW_HERO_START<DisplayName=Hero Yaw Start>;
var(CameraAction) const float CAM_FOV_HERO_START<DisplayName=Hero FOV Start>;

var(CameraAction) const Vector HERO_OFFSET_END<DisplayName=Hero Position Offset End>;
var(CameraAction) const float CAM_PITCH_HERO_END<DisplayName=Hero Pitch End>;
var(CameraAction) const float CAM_ROLL_HERO_END<DisplayName=Hero Roll End>;
var(CameraAction) const float CAM_YAW_HERO_END<DisplayName=Hero Yaw End>;
var(CameraAction) const float CAM_FOV_HERO_END<DisplayName=Hero FOV End>;

var(CameraAction) const EHeroAnimation mHeroAnim<DisplayName=Animation of Hero>;
/* Should the camera jump to the hero? */
var(CameraAction) bool          bPresentHeroJumpTo<DisplayName=Jump to Hero on Present>;
var(CameraAction) float         mPresentDuration<DisplayName=Duration>;

var(CameraAction) const float   mFadeTime<DisplayName=Fade duration>;


// "SmoothMove" means, that the camera will steer towards the Waypoint after the current (WaypointIdx+1), to get a round, smooth curve (at 80% of the current moves percent)
var protected float             mSmoothMoveTimer;
var protected bool    			mSmoothMoveRunning;


function Init(delegate<OnActionCompleted> actionCompletedFunction = none)
{
	super.BaseInit(mPresentDuration, actionCompletedFunction);
}

function StartAction()
{
	local H7CombatController     combatController;

	local H7CombatArmy           army;
	local H7CombatHero           hero;

	super.StartAction();

	
	combatController = class'H7CombatController'.static.GetInstance();

	class'H7PlayerController'.static.GetPlayerController().SetFlythroughRunning(true);
    class'H7CameraActionController'.static.GetInstance().FadeFromBlack(mFadeTime);

	//`log_cam("INITIAL WP");
	AddWaypoint(mInitialVRP,mInitialRotation, mInitialViewingDistance, mInitialFOV ,IT_JUMP, 0.0f);

	army = combatController.GetArmyDefender();

	hero = army.GetHero();
	if( hero != none )
	{
		if(bPresentHeroJumpTo) 
		{
			AddWaypointHero(hero, IT_JUMP, CAM_YAW_HERO_START, CAM_PITCH_HERO_START, CAM_ROLL_HERO_START, HERO_OFFSET_START ,HERO_DISTANCE, CAM_FOV_HERO_START, , 0.0f );
		}
		else
		{
			AddWaypointHero(hero, IT_EASEINOUT, CAM_YAW_HERO_START, CAM_PITCH_HERO_START, CAM_ROLL_HERO_START, HERO_OFFSET_START ,HERO_DISTANCE, CAM_FOV_HERO_START, , 2.0f);
		}
		AddWaypointHero(hero, IT_EASEINOUT, CAM_YAW_HERO_END, CAM_PITCH_HERO_END, CAM_ROLL_HERO_END, HERO_OFFSET_END ,HERO_DISTANCE, CAM_FOV_HERO_END, mHeroAnim, mPresentDuration);
	}
	else
	{
		StopAction();
		return;
	}

	mIsRunning = true;
}

function StopAction()
{
	class'H7PlayerController'.static.GetPlayerController().SetFlythroughRunning(false);
	mIsRunning = false;
	super.StopAction();
}

function Update(float deltaTime)
{
	local float percent;
	local float percentSmooth;
	local H7CameraWaypoint smoothWP;

	super.Update(deltaTime);

	

	if(mIsRunning)
	{
		if(IsActionFinished() || mWaypointIdx >= mWaypoints.Length)
		{
			mTimer = mDuration + 1; // To make IsActionFinished() true
			return;
		}

		// ==== III. Make the Cam move along the Waypoints 
		mStepTimer += deltaTime;

		percent = CalcInterpPercentForWP(mWaypointIdx, GetTimePassedForStep());

		// We need an origin to go from, if not we do the same as the JUMP does...jumping
		if(mWaypoints[mWaypointIdx].InterpType == IT_JUMP || mWaypointIdx-1 < 0 )
		{   
			JumpCameraTo( mWaypoints[mWaypointIdx] ); //No "fromWaypoint" will make a Jump!
		}
		else
		{
			if( mWaypoints[mWaypointIdx].HeroAnim != HA_MAX )
			{
				if( H7CombatHero( mWaypoints[mWaypointIdx].TargetUnit) != none )
				{
					H7CombatHero( mWaypoints[mWaypointIdx].TargetUnit).GetAnimControl().PlayAnim( mWaypoints[mWaypointIdx].HeroAnim );
				}
			}
			MoveCameraFromTo(percent, mWaypoints[mWaypointIdx-1], mWaypoints[mWaypointIdx]);
			//must be here instead of inside MoveCameraFromTo(...), so the smoothMove to keep consistency towards same function in "PresentArmy"
			mCam.SetFOV( Lerp( mWaypoints[mWaypointIdx-1].TargetFoV ,mWaypoints[mWaypointIdx].TargetFoV, percent) ); 
		}

		// ========= SMOOTH MOVE ========
		if(GetTimePassedForStep() > 0.8f)
		{
				//there is at least one additional waypoint to go to AND it is not a Jump
			if(mWaypoints.Length > mWaypointIdx+1 && mWaypoints[mWaypointIdx].InterpType != IT_JUMP)
			{
				mSmoothMoveTimer += deltaTime;
				mSmoothMoveRunning = true;
				percentSmooth = CalcInterpPercentForWP(mWaypointIdx+1, GetTimePassedForSmoothMove());
					smoothWP.TargetPos = mCam.GetCurrentVRP();
					smoothWP.TargetRot = mCam.GetCurrentRotation();
					smoothWP.TargetViewDistance = mCam.GetTargetViewingDistance();
				MoveCameraFromTo( percentSmooth ,smoothWP, mWaypoints[mWaypointIdx+1] );
				//`log_cam("mSmoothMoveRunning"@mSmoothMoveRunning@"at"@mSmoothMoveTimer);
			}
		}

		if(GetTimePassedForStep() >= 1.0f || percent >= 1.0f)
		{
			mWaypointIdx++;
			if(mSmoothMoveRunning)
			{
				mStepTimer = mSmoothMoveTimer;
				mDuration -= mSmoothMoveTimer;
			}
			else
			{
				mStepTimer = 0.0f;
			}
			mSmoothMoveRunning = false;
			mSmoothMoveTimer = 0.0f;
		}

		if(mWaypointIdx >= mWaypoints.Length)
		{
			//`log_cam("    !!!     mWaypointIdx exceeds mWaypoints.Length       !!!  ");
			mIsRunning = FALSE;
		}
	}
}

function float GetTimePassedForSmoothMove()
{
	if(mWaypoints[mWaypointIdx + 1].Duration > 0)
	{
		return (mSmoothMoveTimer / mWaypoints[mWaypointIdx + 1].Duration);
	}
	return 1.0f;
}

