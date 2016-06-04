//=============================================================================
// H7ArmyVictoryCameraAction
//
// Copyright 1998-2014 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7ArmyVictoryCameraAction extends H7WaypointBasedCameraAction;

var H7CreatureStack mTargetStack;

var(CameraAction) const Vector CAM_OFFSET_START<DisplayName=Offset Start>;
var(CameraAction) const float CAM_YAW_START<DisplayName=Yaw Start>;
var(CameraAction) const float CAM_PITCH_START<DisplayName=Pitch Start>;
var(CameraAction) const float CAM_ROLL_START<DisplayName=Roll Start>;
var(CameraAction) const float CAM_VIEWDIST_START<DisplayName=ViewDistance Start>;
var(CameraAction) const float CAM_FOV_START<DisplayName=FoV Start>;

var(CameraAction) const Vector CAM_OFFSET_END<DisplayName=Offset End>;
var(CameraAction) const float CAM_YAW_END<DisplayName=Yaw End>;
var(CameraAction) const float CAM_PITCH_END<DisplayName=Pitch End>;
var(CameraAction) const float CAM_ROLL_END<DisplayName=Roll End>;
var(CameraAction) const float CAM_VIEWDIST_END<DisplayName=ViewDistance End>;
var(CameraAction) const float CAM_FOV_END<DisplayName=FoV End>;

var(CameraAction) const ECreatureAnimation mCreatureAnim<DisplayName=Animation of Creatures>;
var(CameraAction) const float mPresentCreatureDuration<DisplayName=Present Creature Duration>;
var(CameraAction) const float mZoomOutDuration<DisplayName=Zoom Out Duration>;


function Init(delegate<OnActionCompleted> actionCompletedFunction = none)
{
	super.BaseInit(mPresentCreatureDuration + mZoomOutDuration, actionCompletedFunction);
}

function StartAction()
{
	local H7CombatController combatController;
	local H7CombatArmy army;

	local array<H7CreatureStack> livingStacks;

	super.StartAction();
	class'H7PlayerController'.static.GetPlayerController().SetFlythroughRunning(true);
	combatController = class'H7CombatController'.static.GetInstance();

	if( combatController.GetArmyAttacker().WonBattle() )
	{
		army = combatController.GetArmyAttacker();
	}
	else if( combatController.GetArmyDefender().WonBattle() )
	{
		army = combatController.GetArmyDefender();
	} 
	else
	{
		StopAction();
		return;
	}
	
	// Pick random, living CreatureStack from the winning army
	army.GetSurvivingCreatureStacks(livingStacks);

	if(livingStacks.Length == 0)
	{
		StopAction();
		return;
	}

	mTargetStack = livingStacks[ FRand() * ( livingStacks.Length - 1 ) ];
	livingStacks.RemoveItem(mTargetStack);
		
	AddWaypointStack(mTargetStack, IT_JUMP, CAM_YAW_START, CAM_PITCH_START, CAM_ROLL_START, CAM_OFFSET_START, CAM_VIEWDIST_START + mTargetStack.GetHeight(), CAM_FOV_START, CAN_MAX, 0);
	AddWaypointStack(mTargetStack, IT_EASEINOUT, CAM_YAW_END, CAM_PITCH_END, CAM_ROLL_END, CAM_OFFSET_END, CAM_VIEWDIST_END + mTargetStack.GetHeight(), CAM_FOV_END, mCreatureAnim, mPresentCreatureDuration);

	AddWaypoint(mCam.GetDefaultGridCenter() ,mCam.GetActiveProperties().Rotation, mCam.AdjustCombatViewingDistance(mCam.GetActiveProperties().ViewingDistance), mCam.GetActiveProperties().FieldOfView , IT_EASEINOUT, mZoomOutDuration);
}

function StopAction()
{
	class'H7PlayerController'.static.GetPlayerController().SetFlythroughRunning(false);
	super.StopAction();
}


function Update(float deltaTime)
{
	local float percent;

	super.Update(deltaTime);

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
		if( H7CreatureStack(mWaypoints[mWaypointIdx].TargetUnit) != none && mWaypoints[mWaypointIdx].CreatureAnim != CAN_MAX )
		{
			H7CreatureStack(mWaypoints[mWaypointIdx].TargetUnit).GetCreature().GetAnimControl().PlayAnim( mWaypoints[mWaypointIdx].CreatureAnim );
		}
		MoveCameraFromTo(percent, mWaypoints[mWaypointIdx-1], mWaypoints[mWaypointIdx]);
		//must be here instead of inside MoveCameraFromTo(...), so the smoothMove to keep consistency towards same function in "PresentArmy"
		mCam.SetFOV( Lerp( mWaypoints[mWaypointIdx-1].TargetFoV ,mWaypoints[mWaypointIdx].TargetFoV, percent) ); 
	}

	if(GetTimePassedForStep() >= 0.999f || percent >= 0.999f)
	{
		mWaypointIdx++;
			
		mStepTimer = 0.0f;
	}
	if(mWaypointIdx >= mWaypoints.Length)
	{
		//`log_cam("    !!!     mWaypointIdx exceeds mWaypoints.Length       !!!  ");
		mTimer = mDuration + 1; // To make IsActionFinished() true
	}
	
}
