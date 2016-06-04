//=============================================================================
// H7CreatureStackFlyer
//=============================================================================
// 
//=============================================================================
// Copyright 1998-2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CreatureStackFlyer extends H7CreatureStackBaseMover;

const HEIGHT_TO_TIME_MULT = 0.002f; // the higher -> the faster the creature will do the start fly animation or the end fly animation
const MIN_FLY_HEIGHT = 50.0f;
const FLY_HEIGHT_OVER_OBSTACLE = 100.0f;

var protected Vector mFlyInitialLoc;
var protected Vector mFlyTargetLoc;

var protected float mCurrentMoveTime;
var protected float mTotalMoveTime;
var protected bool mOldTurnFlight;
var protected float mStartFlyDuration;
var protected float mEndFlyDuration;
var protected bool mLandingAnimStarted;
var protected float mFlightSpeed;

var protected array<FH7FlyTimePoint> mFlyCurve;

function float GetStartFlyDuration()	                { return mStartFlyDuration; }
function float GetEndFlyDuration()		                { return mEndFlyDuration; }
function SetStartFlyDuration(float val)                 { mStartFlyDuration = val; }
function SetEndFlyDuration(float val)		            { mEndFlyDuration = val; }

function StartElevating() { GotoState('Elevating'); }

function Initialize(H7Unit stack)
{
	super.Initialize( stack );
	UpdateSecPerField();
}

protected function UpdateSecPerField()
{
	mFlightSpeed = H7CreatureStack(mMovingStack) != none ? H7CreatureStack(mMovingStack).GetFlyingSpeed() : 1.f;
	mSecPerField = mFlightSpeed;
	mSecPerField /= float(MOVEMENT_DOTS_PER_CELL);
}

function bool IsMoving() 
{ 
	return (IsInState('Moving') || IsInState('WaitingElevating') || IsInState('Elevating') || IsInState('Landing') || IsInState('TurnToEnemy'));
}

auto state Idle
{
	function MoveStack(array<H7BaseCell> path, optional H7IEffectTargetable target)
	{	
		if( path.Length == 0 )
		{
			;
			return;
		}

		UpdateSecPerField();

		mLandingAnimStarted = false;
		mPath = GetSmoothPath(path);
		mStartRot = mMovingRepresentation.Rotation;

		mTarget = target;

		mDestinationCell = path[path.Length - 1];

		H7CreatureStack(mMovingStack).GetCreature().GetAnimControl().PlayAnim( CAN_START_FLY );

		CalculateFlyCurve();

		GetSecondsPerField();

		GotoState('WaitingElevating');
	}

	function AttackStack( H7IEffectTargetable target, delegate<OnAttackStackFinishedFunc> onAttackStackFinished )
	{
		OnAttackStackFinishedFunc = onAttackStackFinished;
		mTarget = target;

		GotoState('TurnToEnemy');
	}

	function CalculateFlyCurve()
	{
		local float maxHeight, totalFlyTime, takeOffManipulator, landingManipulator, heightManipulator;

		maxHeight = GetMaxPathHeight();

		heightManipulator = maxHeight / (MIN_FLY_HEIGHT + FLY_HEIGHT_OVER_OBSTACLE);

		//We don't want to extended traveltimes to much
		if(heightManipulator > 2.f)
		{
				heightManipulator = 2.f;
		}

		takeOffManipulator = GetHeightIncreaseModifier();
		landingManipulator = GetHeightDecreaseModifier();

		totalFlyTime =  (mSecPerField * mPath.Length) * heightManipulator;
		totalFlyTime = totalFlyTime / (class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed() * H7CreatureStack(mMovingStack).GetCreature().CustomTimeDilation);
		mTotalMoveTime = totalFlyTime;

		mStartFlyDuration = (mTotalMoveTime / (takeOffManipulator + landingManipulator)) * takeOffManipulator;
		mEndFlyDuration = (mTotalMoveTime / (takeOffManipulator + landingManipulator)) * landingManipulator;

		mFlyCurve.Length = 0; // clear
		mFlyCurve.Insert( 0, 4 );

		mFlyCurve[0].TargetTime = 0.0f;
		mFlyCurve[0].PointInterp = FPI_Linear;
		mFlyCurve[0].FlyHeight = 0.0f;

		mFlyCurve[1].TargetTime = mStartFlyDuration / totalFlyTime;
		mFlyCurve[1].PointInterp = FPI_Linear;
		mFlyCurve[1].FlyHeight = maxHeight;

		mFlyCurve[2].TargetTime = ( totalFlyTime - mStartFlyDuration ) / totalFlyTime;
		mFlyCurve[2].PointInterp = FPI_Linear;
		mFlyCurve[2].FlyHeight = maxHeight;

		mFlyCurve[3].TargetTime = 1.0f;
		mFlyCurve[3].PointInterp = FPI_Linear;
		mFlyCurve[3].FlyHeight = 0.0f;
	}
		
	function float GetMaxPathHeight()
	{
		local H7PathPosition pathPos;
		local H7CombatMapCell cell;
		local float maxHeight;

		maxHeight = MIN_FLY_HEIGHT;
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

		maxHeight += H7CreatureStack(mMovingStack).GetCreature().GetVisuals().mFlyHeightOffset;

		return maxHeight + FLY_HEIGHT_OVER_OBSTACLE;
	}

	function float GetHeightIncreaseModifier()
	{
		local H7CombatMapCell cell, comparisonCell;
		local array <H7CombatMapCell> cellArray;
		local int i;
		local float flyCurveManipulator;
		local bool alreadyAdded;

		flyCurveManipulator = 3.f;

		for( i = 0; i < mPath.Length; i++ )
		{
			cell = H7CombatMapCell( mPath[i].Cell );
			alreadyAdded = false;
			
			if( cell != none )
			{
				if(cellArray.Length == 0)
				{
					cellArray.AddItem(cell);
				}

				foreach cellArray(comparisonCell)
				{
					if(cell == comparisonCell)
					{
						alreadyAdded = true;
					}
				}

				if(!alreadyAdded)
				{
					cellArray.AddItem(cell);
					alreadyAdded = false;
				}
			}
		}

		for (i = 0; i <= 3; i++)
		{
			if( cellArray.Length > i )
			{
				if( cellArray[i].HasObstacle() )
				{
					flyCurveManipulator = i+1;
					break;
				}
				if( cellArray[i].HasCreatureStack() )
				{
					flyCurveManipulator = i+1;
					break;
				}
			}
		}

		return flyCurveManipulator;
	}

	function float GetHeightDecreaseModifier()
	{
		local H7CombatMapCell cell, comparisonCell;
		local array <H7CombatMapCell> cellArray;
		local int i, max;
		local float flyCurveManipulator;
		local bool alreadyAdded;

		flyCurveManipulator = 3.f;
		max =  mPath.Length-1;

		for( i = 0; i < mPath.Length; i++)
		{
			cell = H7CombatMapCell( mPath[max-i].Cell );
			alreadyAdded = false;

			if( cell != none )
			{
				if(cellArray.Length == 0)
				{
					cellArray.AddItem(cell);
				}

				foreach cellArray(comparisonCell)
				{
					if(cell == comparisonCell)
					{
						alreadyAdded = true;
						break;
					}
				}

				if(!alreadyAdded)
				{
					cellArray.AddItem(cell);
				}
			}
		}

		for (i = 0; i <= 3; i++)
		{
			if( cellArray.Length > i )
			{
				if( cellArray[i].HasObstacle() )
				{
					flyCurveManipulator = i+1;
					break;
				}
				if( cellArray[i].HasCreatureStack() )
				{
					flyCurveManipulator = i+1;
					break;
				}
			}
		}

		return flyCurveManipulator;
	}
}

// waiting the animation to tell us to start elevating
state WaitingElevating
{
}

// function to sort FlyTimePoints
delegate int H7FlyTimePointSort(FH7FlyTimePoint A,FH7FlyTimePoint B)
{
	return A.TargetTime > B.TargetTime ? -1 : 0;
}

state FlyMovement
{
	simulated event BeginState( Name PreviousStateName )
	{
		local FH7FlyTimePoint tempPoint;
		local int i;

		// make sure we reset the start and end locations before anything else happens
		if (!mOldTurnFlight)
		{
			mOldTurnFlight = true;
			mFlyInitialLoc = GetCellLocation( GetCellOfTarget( mMovingStack ) );
			mFlyTargetLoc = mPath[mPath.Length - 1].Position;
		}

		if (mFlyCurve.Length > 1)
		{
			// perform sanity checks for the curve

			// sort the height curve first
			mFlyCurve.Sort(H7FlyTimePointSort);

			// clamp the points' times to 0-1 values	
			for (i=0; i<mFlyCurve.Length; i++)
			{
				mFlyCurve[i].TargetTime = FClamp(mFlyCurve[i].TargetTime, 0.0f, 1.0f);
			}

			// make sure there's an initial curve point with time as 0.0
			if (mFlyCurve[0].TargetTime > 0.0f)
			{
				tempPoint.TargetTime = 0.0f;
				tempPoint.FlyHeight = 0.0f;
				tempPoint.PointInterp = FPI_Linear;
				mFlyCurve.InsertItem(0, tempPoint);
			}

			// make sure there's a final curve point with time as 1.0
			if (mFlyCurve[mFlyCurve.Length - 1].TargetTime < 1.0f)
			{
				tempPoint.TargetTime = 1.0f;
				tempPoint.FlyHeight = 0.0f;
				tempPoint.PointInterp = FPI_Linear;
				mFlyCurve.AddItem(tempPoint);
			}
		}

		OpenGateOnTargetPos();
	}

	function UpdateRotation()
	{
		local float lerpRotAlpha;
		local Rotator targetRot, lerpRot;

		mStartRot = mMovingRepresentation.Rotation;
		targetRot = GetTargetRotation(mPath.Length-1);

		lerpRotAlpha = mCurrentMoveTime / mTotalMoveTime;
		FClamp( lerpRotAlpha, 0.0f, 1.f );

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
		if (!mOldTurnFlight)
		{
			mOldTurnFlight = true;
			mFlyInitialLoc = GetCellLocation( GetCellOfTarget( mMovingStack ) );
			mFlyTargetLoc = mPath[mPath.Length - 1].Position;
		}

		mMoveTime += deltaTime;
		mCurrentMoveTime += deltaTime;

		UpdateRotation();

		startPos = mFlyInitialLoc;
		targetPos = mFlyTargetLoc;
		lerpPos = VLerp( startPos, targetPos, FMin(1.0f, mCurrentMoveTime / mTotalMoveTime) );
		currentHeight = 0.0f;

		// calculate the height based on the flying height curve
		if (mFlyCurve.Length > 1)
		{
			currentTimePct = mCurrentMoveTime / mTotalMoveTime;
			if (currentTimePct < 1.0f)
			{
				// get the current (and next) points in the curve
				for (i = 0; i < mFlyCurve.Length - 1; i++)
				{
					if (currentTimePct < mFlyCurve[i + 1].TargetTime)
					{
						currHeightPoint = mFlyCurve[i];
						nextHeightPoint = mFlyCurve[i + 1];
						break;
					}
				}

				// calculate the height and apply the corresponding interpolation easing method
				currentHeightLerp = (currentTimePct - currHeightPoint.TargetTime) / (nextHeightPoint.TargetTime - currHeightPoint.TargetTime);
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

state Elevating extends FlyMovement
{
	event UpdateMovement(float deltaTime)
	{
		super.UpdateMovement(deltaTime);

		if(mMoveTime >= mStartFlyDuration)
		{
			mMoveTime = 0.0f;
			FieldArrive();
		}
	}

	protected function FieldArrive()
	{
		GotoState('Moving');
	}
}

state Moving extends FlyMovement
{
	event UpdateMovement(float deltaTime)
	{
		super.UpdateMovement(deltaTime);
		
		if( mMoveTime >= (mTotalMoveTime - mStartFlyDuration - mEndFlyDuration) )
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

state Landing extends FlyMovement
{
	simulated event BeginState( Name PreviousStateName ){}

	function UpdateRotation() { }

	event UpdateMovement(float deltaTime)
	{
		local float durationAnim, animStartPercent;

		durationAnim = H7CreatureStack(mMovingStack).GetCreature().GetAnimControl().GetAnimationDuration(CAN_END_FLY);
		animStartPercent = H7CreatureStack(mMovingStack).GetCreature().GetVisuals().GetFlyEndLanding();
		durationAnim = durationAnim * animStartPercent;

		super.UpdateMovement(deltaTime);
	
		if(durationAnim >= mTotalMoveTime - mCurrentMoveTime && !mLandingAnimStarted)
		{
			H7CreatureStack(mMovingStack).GetCreature().GetAnimControl().PlayAnim( CAN_END_FLY );
			mLandingAnimStarted = true;
		}

		if( mMoveTime >= mEndFlyDuration )
		{
			mMoveTime = 0.0f;
			mCurrentMoveTime = 0.0f;
			mOldTurnFlight = false;
			FieldArrive();
		}
	}

	protected function FieldArrive()
	{
		if( mMovingStack.GetEntityType() == UNIT_CREATURESTACK )
		{
			H7CreatureStack(mMovingStack).SetGridPosition(mDestinationCell.GetCellPosition());
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

