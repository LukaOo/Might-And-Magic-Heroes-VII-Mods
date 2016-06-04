//=============================================================================
// H7PresentArmyCameraAction
//
// Copyright 1998-2014 Limbic Entertainment All Rights Reserved.
//=============================================================================
// TODOs: ...
//=============================================================================
	// ===================== Handbook ==================
	// I.       Check, which armies should be presented  // Defender? Attacker? Both? Only AI? HotSeat-PvP?  ==> currently just for AI! (TODO: What to do with the rest?)
	// II(1).   Collect the stacks, then hero, and GO! (aka do step III.)
	// II(2).   Collect attacker-stacks and hero, add a jump to first defender stack, collect defender-stacks and hero and GO! (aka do step III.)
	// ==================== DONE WITH INIT! --- Do the rest in 'Update()'
	// III.     Make the Cam move along the Waypoints
	// IV.      ???
	// V.       Profit!
	// =================================================

class H7PresentArmyCameraAction extends H7WaypointBasedCameraAction;

var(CameraAction) const float CREATURE_DISTANCE<DisplayName=ViewDistance on Creatures>;

var(CameraAction) const Vector CREATURE_OFFSET_START<DisplayName=Creature Position Offset Start>;
var(CameraAction) const float CAM_PITCH_CREATURE_START<DisplayName=Creature Pitch Start(in degree)>;
var(CameraAction) const float CAM_ROLL_CREATURE_START<DisplayName=Creature Roll Start(in degree)>;
var(CameraAction) const float CAM_YAW_CREATURE_START<DisplayName=Creature Yaw Start(in degree)>;
var(CameraAction) const float CAM_FOV_CREATURE_START<DisplayName=Creature FOV Start(in degree)>;

var(CameraAction) const Vector CREATURE_OFFSET_END<DisplayName=Creature Position Offset End>;
var(CameraAction) const float CAM_PITCH_CREATURE_END<DisplayName=Creature Pitch End>;
var(CameraAction) const float CAM_ROLL_CREATURE_END<DisplayName=Creature Roll End>;
var(CameraAction) const float CAM_YAW_CREATURE_END<DisplayName=Creature Yaw End>;
var(CameraAction) const float CAM_FOV_CREATURE_END<DisplayName=Creature FOV End>;

var(CameraAction) const Vector CREATURE_OFFSET_EXTRA<DisplayName=Creature Position Offset Extra>;
var(CameraAction) const float CAM_PITCH_CREATURE_EXTRA<DisplayName=Creature Pitch Extra>;
var(CameraAction) const float CAM_ROLL_CREATURE_EXTRA<DisplayName=Creature Roll Extra>;
var(CameraAction) const float CAM_YAW_CREATURE_EXTRA<DisplayName=Creature Yaw Extra>;
var(CameraAction) const float CAM_FOV_CREATURE_EXTRA<DisplayName=Creature FOV Extra>;

var(CameraAction) bool  bPresentCreatureJumpTo<DisplayName=Jump to Creature on Present>;
var(CameraAction) bool  bUseExtraPoint<DisplayName=Use Extra Position after last creature>;
var(CameraAction) const float   mFadeTime<DisplayName=Fade duration>;
var(CameraAction) float mPresentArmyDuration<DisplayName=Present Army Duration>;
var(CameraAction) float mExtraPointDuration<DisplayName=Duration after present army to extra position>;
var(CameraAction) float mEndPointDuration<DisplayName=Duration after extra point to end point>;

// "SmoothMove" means, that the camera will steer towards the Waypoint after the current (WaypointIdx+1), to get a round, smooth curve (at 80% of the current moves percent)
var protected float                   mSmoothMoveTimer;
var protected bool    				mSmoothMoveRunning;

function Init(delegate<OnActionCompleted> actionCompletedFunction = none)
{
	local float dur;

	dur = mPresentArmyDuration + mEndPointDuration;
	if(bUseExtraPoint)
	{
		dur += mExtraPointDuration;
	}
	super.BaseInit(dur, actionCompletedFunction);
}

function StartAction()
{
	local H7CombatController     combatController;
	local H7CombatArmy           army;
	local array<H7CreatureStack> stacks;
	local H7CreatureStack        lastStack, firstStack;
	local bool  showAttacker, showDefender;

	super.StartAction();

	mIsRunning = TRUE;

	class'H7PlayerController'.static.GetPlayerController().SetFlythroughRunning(true);
    class'H7CameraActionController'.static.GetInstance().FadeFromBlack(mFadeTime);

	combatController = class'H7CombatController'.static.GetInstance();

	//`log_cam("INITIAL WP");
	AddWaypoint(mInitialVRP,mInitialRotation, mInitialViewingDistance, mInitialFOV ,IT_JUMP, 0.0f);


// ==== I. Check for presentable army ====  in the current (missing) design, only AI will presented
	// #GamesCom - Player will never get attacked by AI ... TODO
	showAttacker = false;
	showDefender = true;

	//`log_cam("GAMMA showAttacker"@showAttacker@"showDefender"@showDefender@"mWaypoints.Length"@mWaypoints.Length);
	while(showAttacker || showDefender)
	{
		if(showAttacker)
		{
			//`log_cam("    Show Attacker!");
			showAttacker = false; // We will be done with the attacker after this, so don't add it again
			army = combatController.GetArmyAttacker();

			stacks.Length = 0;
			stacks = army.GetCreatureStacks();
		
			if(stacks.Length > 1)
			{
				stacks.Sort(SortFromNorthToSouth);
			}
		}
		else if(showDefender)
		{
			//`log_cam("    Show Defender!");
			showDefender = false;
			army = combatController.GetArmyDefender();
			
			stacks.Length = 0;
			stacks = army.GetCreatureStacks();

			if(stacks.Length > 1)
			{
				stacks.Sort(SortFromSouthToNorth);
			}
		}

		// ==== II. Collect stacks (and transform them to usable Waypoints) ====
		firstStack = stacks[0];
		lastStack = stacks[stacks.Length - 1];
		
		if(bPresentCreatureJumpTo)
		{
			AddWaypointStack(firstStack, IT_JUMP, CAM_YAW_CREATURE_START, CAM_PITCH_CREATURE_START, CAM_ROLL_CREATURE_START, CREATURE_OFFSET_START, CREATURE_DISTANCE, CAM_FOV_CREATURE_START, , 0.0f );
		}
		else
		{
			AddWaypointStack(firstStack, IT_EASEINOUT, CAM_YAW_CREATURE_START, CAM_PITCH_CREATURE_START, CAM_ROLL_CREATURE_START, CREATURE_OFFSET_START, CREATURE_DISTANCE, CAM_FOV_CREATURE_START, , 2.0f);
		}
		AddWaypointStack(lastStack, IT_EASEINOUT, CAM_YAW_CREATURE_END, CAM_PITCH_CREATURE_END, CAM_ROLL_CREATURE_END, CREATURE_OFFSET_END, CREATURE_DISTANCE, CAM_FOV_CREATURE_END, , mPresentArmyDuration);

	}

	if(bUseExtraPoint)
	{
		AddWaypointStack(lastStack, IT_EASEINOUT, CAM_YAW_CREATURE_EXTRA, CAM_PITCH_CREATURE_EXTRA, CAM_ROLL_CREATURE_EXTRA, CREATURE_OFFSET_EXTRA, CREATURE_DISTANCE, CAM_FOV_CREATURE_EXTRA, , mExtraPointDuration);
	}

	AddWaypoint(mCam.GetDefaultGridCenter() ,mCam.GetActiveProperties().Rotation, mCam.AdjustCombatViewingDistance(mCam.GetActiveProperties().ViewingDistance), mCam.GetActiveProperties().FieldOfView ,IT_EASEINOUT, mEndPointDuration);
}

function StopAction()
{
	class'H7PlayerController'.static.GetPlayerController().SetFlythroughRunning(false);
	super.StopAction();
	mIsRunning = FALSE;
}

function Update(float deltaTime)
{
	local float percent;
	local float percentSmooth;
	local H7CameraWaypoint smoothWP;

	super.Update(deltaTime);
	
	

	// ==== III. Make the Cam move along the Waypoints 
	if( mIsRunning )
	{
		mStepTimer += deltaTime;

		percent = CalcInterpPercentForWP(mWaypointIdx, GetTimePassedForStep());

		// We need an origin to go from, if not we do the same as the JUMP does...jumping
		if(mWaypoints[mWaypointIdx].InterpType == IT_JUMP || mWaypointIdx-1 < 0 )
		{   
			JumpCameraTo( mWaypoints[mWaypointIdx] ); //No "fromWaypoint" will make a Jump!
		}
		else
		{
			MoveCameraFromTo(percent, mWaypoints[mWaypointIdx-1], mWaypoints[mWaypointIdx]);
			//must be here instead of inside MoveCameraFromTo(...), so the smoothMove doesn't fuck shit up!
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
				mCam.SetFOV( Lerp( mCam.GetFOVAngle(), mWaypoints[mWaypointIdx + 1].TargetFoV, percentSmooth) ); 
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

		//`log_cam("Action -Present Army- is ending!"@mWaypointIdx@"of"@mWaypoints.Length-1@"TargetPos:"@mCam.GetCurrentVRP()@"StepTime:"@mStepTimer@"of"@mDurationPerStep);
		
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

delegate int SortFromNorthToSouth(H7CreatureStack A, H7CreatureStack B)
{
	if(A == none || B == none)
	{
		//`log_cam("Sorting N->S: A"@A@"and B"@B);
		return 0;
	}
	return A.Location.Y < B.Location.Y ? -1 : 0; 
}

delegate int SortFromSouthToNorth(H7CreatureStack A, H7CreatureStack B)
{
	if(A == none || B == none)
	{
		//`log_cam("Sorting S->N: A"@A@"and B"@B);
		return 0;
	}
	return A.Location.Y > B.Location.Y ? -1 : 0; 
}

