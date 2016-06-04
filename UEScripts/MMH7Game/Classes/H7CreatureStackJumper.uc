//=============================================================================
// H7CreatureStackJumper
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CreatureStackJumper extends H7CreatureStackBaseMover;

const HEIGHT_TO_TIME_MULT = 2.0f; // the higher -> the faster the creature will do the start fly animation or the end fly animation
const MIN_JUMP_HEIGHT = 500.0f;
const JUMP_HEIGHT_OVER_OBSTACLE = 350.0f;

var protected Vector mJumpInitialLoc;
var protected Vector mJumpTargetLoc;

var protected float mTotalMoveTime;
var protected int mPathCurrStep;
var protected bool mOldTurnJump;
var protected float mStartJumpFlyDuration;
var protected float mJumpEndPitchDuration;

var protected array<FH7FlyTimePoint> mJumpCurve;

function float GetStartJumpDuration()	{ return mStartJumpFlyDuration; }
function float GetJumpEndPitchDuration()		{ return mJumpEndPitchDuration; }

function StartElevating() { GotoState('Elevating'); }

function EndJumpSequence() { GotoState('Idle'); }

function Initialize(H7Unit stack)
{
	super.Initialize( stack );
	mSecPerField = H7CreatureStack(stack) != none ? H7CreatureStack(stack).GetCreature().GetVisuals().GetFlyingSpeed() : 1.f;
	mSecPerField /= float(MOVEMENT_DOTS_PER_CELL);
}

function bool IsMoving() 
{ 
	return (IsInState('Moving') || IsInState('WaitingElevating') || IsInState('Elevating') || IsInState('Landing') || IsInState('TurnToEnemy'));
}

function float GetSecondsPerField()
{
	mSecPerField = H7CreatureStack(mMovingStack) != none ? H7CreatureStack(mMovingStack).GetCreature().GetVisuals().GetFlyingSpeed() : 1.f;
	mSecPerField /= float(MOVEMENT_DOTS_PER_CELL);
	mSecPerField /= class'H7ReplicationInfo'.static.GetInstance().GetGameSpeedCombat();

	return mSecPerField;
}

auto state Idle
{

	function MoveStack(array<H7BaseCell> path, optional H7IEffectTargetable target)
	{	
		local array<H7BaseCell> shortendPath;

		if( path.Length == 0 )
		{
			;
			return;
		}
		shortendPath.AddItem(path[0]);
		shortendPath.AddItem(path[path.Length - 1]);
		mPath = GetSmoothPath(shortendPath);
		mStartRot = mMovingRepresentation.Rotation;

		mTarget = target;
		
		mDestinationCell = path[path.Length - 1];
		
		GetSecondsPerField();
		CalculateJumpCurve();

		H7CreatureStack(mMovingStack).GetCreature().GetAnimControl().PlayAnim( CAN_START_JUMP, SwitchToElevate); //ToDo Change Anims to Jump after jump anims are here
	}

	function AttackStack( H7IEffectTargetable target, delegate<OnAttackStackFinishedFunc> onAttackStackFinished )
	{
		OnAttackStackFinishedFunc = onAttackStackFinished;
		mTarget = target;

		GotoState('TurnToEnemy');
	}

	function SwitchToElevate()
	{
		GotoState('WaitingElevating');
	}

	function CalculateJumpCurve()
	{
		local float maxHeight, totalJumpTime;

		maxHeight = GetMaxPathHeight();

		totalJumpTime = mSecPerField * mPath.Length;
		mStartJumpFlyDuration = totalJumpTime /2;
		mJumpEndPitchDuration = totalJumpTime /2;

		mJumpCurve.Length = 0; // clear
		mJumpCurve.Insert( 0, 3 );

		mJumpCurve[0].TargetTime = 0.0f;
		mJumpCurve[0].PointInterp = FPI_InvSquared;
		mJumpCurve[0].FlyHeight = 0.0f;

		mJumpCurve[1].TargetTime = 0.60f;
		mJumpCurve[1].PointInterp = FPI_Cubed;
		mJumpCurve[1].FlyHeight = maxHeight;

		mJumpCurve[2].TargetTime = 1.0f;
		mJumpCurve[2].PointInterp = FPI_InvSquared;
		mJumpCurve[2].FlyHeight = 0.0f;
	}
		
	function float GetMaxPathHeight()
	{
		local H7PathPosition pathPos;
		local H7CombatMapCell cell;
		local float maxHeight;

		maxHeight = MIN_JUMP_HEIGHT;
		foreach mPath( pathPos )
		{
			cell = H7CombatMapCell( pathPos.Cell );
			if( cell != none )
			{
				if( cell.HasObstacle() && cell.GetObstacle().GetHeight() > maxHeight )
				{
					maxHeight = cell.GetObstacle().GetHeight();
				}
				if( cell.HasCreatureStack() && cell.GetCreatureStack().GetHeight() > maxHeight )
				{
					maxHeight = cell.GetCreatureStack().GetHeight();
				}
			}
		}

		return maxHeight + JUMP_HEIGHT_OVER_OBSTACLE;
	}
}


// function to sort FlyTimePoints
delegate int H7FlyTimePointSort(FH7FlyTimePoint A,FH7FlyTimePoint B)
{
	return A.TargetTime > B.TargetTime ? -1 : 0;
}

state JumpMovement
{
	simulated event BeginState( Name PreviousStateName )
	{
		local FH7FlyTimePoint tempPoint;
		local int i;

		// make sure we reset the start and end locations before anything else happens
		if (!mOldTurnJump)
		{
			mOldTurnJump = true;
			mJumpInitialLoc = GetCellLocation( GetCellOfTarget( mMovingStack ) );
			mJumpTargetLoc = mPath[mPath.Length - 1].Position;
		}

		if (mJumpCurve.Length > 1)
		{
			// perform sanity checks for the curve

			// sort the height curve first
			mJumpCurve.Sort(H7FlyTimePointSort);

			// clamp the points' times to 0-1 values	
			for (i=0; i<mJumpCurve.Length; i++)
			{
				mJumpCurve[i].TargetTime = FClamp(mJumpCurve[i].TargetTime, 0.0f, 1.0f);
			}

			// make sure there's an initial curve point with time as 0.0
			if (mJumpCurve[0].TargetTime > 0.0f)
			{
				tempPoint.TargetTime = 0.0f;
				tempPoint.FlyHeight = 0.0f;
				tempPoint.PointInterp = FPI_Linear;
				mJumpCurve.InsertItem(0, tempPoint);
			}

			// make sure there's a final curve point with time as 1.0
			if (mJumpCurve[mJumpCurve.Length - 1].TargetTime < 1.0f)
			{
				tempPoint.TargetTime = 1.0f;
				tempPoint.FlyHeight = 0.0f;
				tempPoint.PointInterp = FPI_Linear;
				mJumpCurve.AddItem(tempPoint);
			}
		}

		OpenGateOnTargetPos();
	}

	function UpdateRotation()
	{
		local float lerpRotAlpha, totalJumpTime, cellJumpTime, currCellJumpTime;
		local Rotator targetRot, lerpRot;
		local int oldPathStep;

		oldPathStep = mPathCurrStep;
		mPathCurrStep = (mTotalMoveTime / (mSecPerField * mPath.Length) * (mPath.Length));
		mPathCurrStep /= class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed() * H7CreatureStack(mMovingStack).GetCreature().CustomTimeDilation;

		// check if we just entered a new cell
		if (oldPathStep != mPathCurrStep)
		{
			mStartRot = mMovingRepresentation.Rotation;
		}
		targetRot = GetTargetRotation(mPathCurrStep);

		totalJumpTime = (mSecPerField * mPath.Length);
		cellJumpTime = totalJumpTime / mPath.Length;
		currCellJumpTime = mTotalMoveTime - (mPathCurrStep * cellJumpTime);
		
		lerpRotAlpha = currCellJumpTime / cellJumpTime;
				
		if( lerpRotAlpha > 1.f )
		{
			lerpRotAlpha = 1.f;
		}

		if( class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed() <= 1.f )
		{
			lerpRot.Yaw = Lerp( mStartRot.Yaw , targetRot.Yaw , lerpRotAlpha );
		}
		else
		{
			lerpRot.Yaw = targetRot.Yaw;
		}
		mMovingRepresentation.SetRotation(lerpRot);
	}

	event UpdateMovement(float deltaTime)
	{
		local Vector startPos, targetPos, lerpPos;
		local float currentHeight, currentHeightLerp, currentTimePct;
		local FH7FlyTimePoint currHeightPoint, nextHeightPoint;
		local int i;
		

		// make sure we reset the start and end locations before anything else happens
		if (!mOldTurnJump)
		{
			mOldTurnJump = true;
			mJumpInitialLoc = GetCellLocation( GetCellOfTarget( mMovingStack ) );
			mJumpTargetLoc = mPath[mPath.Length - 1].Position;
		}

		mMoveTime += deltaTime;
		mTotalMoveTime += deltaTime;

		UpdateRotation();

		startPos = mJumpInitialLoc;
		targetPos = mJumpTargetLoc;

		lerpPos.X = Lerp(startPos.X, targetPos.X, mTotalMoveTime / ((mSecPerField * mPath.Length)));
		lerpPos.Y = Lerp(startPos.Y, targetPos.Y, mTotalMoveTime / ((mSecPerField * mPath.Length)));
		lerpPos.Z = Lerp(startPos.Z, targetPos.Z, mTotalMoveTime / ((mSecPerField * mPath.Length)));
		currentHeight = 0.0f;

		// calculate the height based on the flying height curve
		if (mJumpCurve.Length > 1)
		{
			currentTimePct = mTotalMoveTime / (mSecPerField * mPath.Length);
			if (currentTimePct < 1.0f)
			{
				// get the current (and next) points in the curve
				for (i = 0; i < mJumpCurve.Length - 1; i++)
				{
					if (currentTimePct < mJumpCurve[i + 1].TargetTime)
					{
						currHeightPoint = mJumpCurve[i];
						nextHeightPoint = mJumpCurve[i + 1];

						break;
					}
				}

				// calculate the height and apply the corresponding interpolation easing method
				currentHeightLerp = (currentTimePct - currHeightPoint.TargetTime) / (nextHeightPoint.TargetTime - currHeightPoint.TargetTime);

				if (currHeightPoint.PointInterp == FPI_Cubed)
				{
					currentHeightLerp = currentHeightLerp ** 3;
				}
				if (currHeightPoint.PointInterp == FPI_Squared)
				{
					currentHeightLerp = currentHeightLerp ** 2;
				}
				else if (currHeightPoint.PointInterp == FPI_InvSquared)
				{
					currentHeightLerp = currentHeightLerp ** (0.5f);
				}

				currentHeight = Lerp(currHeightPoint.FlyHeight, nextHeightPoint.FlyHeight, currentHeightLerp);
			}
		}
		H7CreatureStack(mMovingStack).SetStackLocation(lerpPos, currentHeight);
	}
}

// waiting the animation to tell us to start elevating
state WaitingElevating
{
}

state Elevating extends JumpMovement
{
	simulated event BeginState( Name PreviousStateName )
	{
		H7CreatureStack(mMovingStack).GetCreature().GetAnimControl().PlayAnim( CAN_LOOP_JUMP );
	}

	event UpdateMovement(float deltaTime)
	{
		super.UpdateMovement(deltaTime);

		if(mMoveTime >= mStartJumpFlyDuration)
		{
			mMoveTime = 0.0f;
			FieldArrive();
		}
	}

	protected function FieldArrive()
	{
		GotoState('Landing');//Moving
	}
}

state Moving extends JumpMovement
{
	event UpdateMovement(float deltaTime)
	{
		super.UpdateMovement(deltaTime);
		
		if(mMoveTime >= mSecPerField * mPath.Length)
		{
			mMoveTime = 0.0f;
			FieldArrive();
		}
	}

	protected function FieldArrive()
	{
		GotoState('Landing');
	}
}

state Landing extends JumpMovement
{

	function UpdateRotation() { }

	event UpdateMovement(float deltaTime)
	{
		super.UpdateMovement(deltaTime);
	
		if( mMoveTime >= mJumpEndPitchDuration /*&& !mMovingStack.GetCreature().GetAnimControl().IsFlying()*/ )
		{
			mMoveTime = 0.0f;
			mTotalMoveTime = 0.0f;
			mOldTurnJump = false;
			FieldArrive();
		}
	}

	protected function FieldArrive()
	{
		if( mMovingStack.GetEntityType() == UNIT_CREATURESTACK )
		{
			H7CreatureStack(mMovingStack).SetGridPosition(mDestinationCell.GetCellPosition());
			H7CreatureStack(mMovingStack).GetCreature().GetAnimControl().PlayAnim( CAN_END_JUMP);
		}

		mStartRot = mMovingRepresentation.Rotation;

		while (mPath.Length > 0)
		{
			mPath.Remove(0, 1);
		}

		if(mTarget != none)    // We need to start rotating to enemy stack
		{
			GotoState('TurnToEnemy');
		}
		else
		{
			GotoState('Idle');
		}
	}
}

state TurnToEnemy
{
	simulated event BeginState(name previousStateName)
	{
		AddEnemyPositionToPath();
	}

	event UpdateMovement(float deltaTime)
	{
		local Rotator targetRot, lerpRot;
	
		mMoveTime += deltaTime;

		targetRot = GetTargetRotation(0);
		
		if( class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed() <= 1.f )
		{
			lerpRot.Yaw = Lerp( mStartRot.Yaw , targetRot.Yaw , mMoveTime / (mSecPerField * mPath.Length) );
		}
		else
		{
			lerpRot.Yaw = targetRot.Yaw;
			mMoveTime = mSecPerField * mPath.Length;
		}

		mMovingRepresentation.SetRotation(lerpRot);
		
		if(mMoveTime >= mSecPerField * mPath.Length)
		{
			mMoveTime -= mSecPerField * mPath.Length;

			FieldArrive();
		}
	}

	protected function FieldArrive()
	{	
		// Rotating to enemy is done
		mTarget = none;
		OnAttackStackFinishedFunc();
		GotoState('Idle');
	}
}

