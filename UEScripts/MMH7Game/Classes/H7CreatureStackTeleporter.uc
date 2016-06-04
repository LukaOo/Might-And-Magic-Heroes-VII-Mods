//=============================================================================
// H7CreatureStackTeleporter
//=============================================================================
//
//=============================================================================
// Copyright 1998-2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CreatureStackTeleporter extends H7CreatureStackBaseMover;

var protected float mSecToVanish;
var protected float mSecToAppear;

function Initialize(H7Unit stack)
{
	super.Initialize( stack );
	mSecPerField = 0.1f;
}

function bool IsMoving() 
{ 
	return (IsInState('Moving') || IsInState('Vanish') || IsInState('Appear') || IsInState('TurnToEnemy'));
}

function Rotator GetCurrentTargetRotation()
{
	return GetTargetRotation(0);
}

protected function Rotator GetTargetRotation(int pathIndex)
{
	local Rotator rotationI, rotationIPlus;
	local Vector tVec;

	if( H7CombatMapCell( mTarget ) != none ) mTarget = H7CombatMapCell( mTarget ).GetTargetable();

	if( H7Unit( mTarget ) != none )
		tVec = class'H7CombatController'.static.GetInstance().GetGridController().GetCellLocation( H7Unit( mTarget ).GetGridPosition() );
	else
		return mMovingStack.Rotation; // don't rotate
	
	
	// middle of i and i+1
	rotationI = GetOptimalTargetRotation( mMovingStack.Location, tVec );
	
	if(pathIndex + 1 < mPath.Length)
	{
		rotationIPlus = GetOptimalTargetRotation( H7CreatureStack( mMovingStack ).GetCell().GetCenterPos(), tVec );
		return rotationIPlus;
	}

	return rotationI;
}

auto state Idle
{
	function MoveStack(array<H7BaseCell> path, optional H7IEffectTargetable target)
	{
		local H7PathPosition pathPos;

		if( path.Length == 0 )
		{
			;
			return;
		}

		//	Needed for correct rotation
		if(path.Length >= 2)
		{
			pathPos.Position = path[path.Length - 2].GetLocation();
			pathPos.Cell = path[path.Length - 2];
			mPath.AddItem(pathPos);
		}

		//	We move directly to the last cell of the path
		pathPos.Position = path[path.Length - 1].GetLocation();
		pathPos.Cell = path[path.Length - 1];
		mPath.AddItem(pathPos);
		
		mStartRot = mMovingRepresentation.Rotation;

		mTarget = target;
		if( H7BaseCell( mTarget ) != none ) mTarget = H7BaseCell( mTarget ).GetTargetable();

		mDestinationCell = path[path.Length - 1];

		GotoState('Vanish');
	}

	function AttackStack( H7IEffectTargetable target, delegate<OnAttackStackFinishedFunc> onAttackStackFinished )
	{
		OnAttackStackFinishedFunc = onAttackStackFinished;
		mStartRot = mMovingRepresentation.Rotation;
		mTarget = target;
		if( H7BaseCell( mTarget ) != none ) mTarget = H7BaseCell( mTarget ).GetTargetable();

		GotoState('TurnToEnemy');
	}

	function RotateStack(Rotator targetRot)
	{
		mLerpTargetRotation = targetRot;
		mStartRot = mMovingRepresentation.Rotation;

		GotoState('TurnToEnemy');
	}
}

state Vanish
{
	simulated event BeginState(Name PreviousStateName)
	{
		H7CreatureStack(mMovingStack).GetCreature().GetAnimControl().PlayAnim( CAN_MOVE_START/*, FieldArrive*/ );

		mSecToVanish = H7CreatureStack(mMovingStack).GetCreature().GetAnimControl().GetCurrentAnimTime() - 0.1f;
		mSecToVanish /= H7CreatureStack(mMovingStack).GetCreature().CustomTimeDilation;
		mMoveTime = 0.f;
		
		if(mMovingStack != none && H7CreatureStack( mMovingStack ).GetCreature().GetStartTeleportFXSound() != none && !class'H7SpectatorHUDCntl'.static.GetInstance().GetPopup().IsVisible())
		{
			mMovingStack.PlayAkEvent( H7CreatureStack( mMovingStack ).GetCreature().GetStartTeleportFXSound(),true,,, H7CreatureStack( mMovingStack ).Location );
		}
	}

	event UpdateMovement(float deltaTime)
	{
		mMoveTime += deltaTime;

		if( mMoveTime >= mSecToVanish )
		{
			mMoveTime = 0.f;
			FieldArrive();
		}
	}

	protected function FieldArrive()
	{
		local ParticleSystemComponent psc;

		if(H7CreatureStack( mMovingStack ).GetCreature().HasTeleportStartFX())
		{
			psc = WorldInfo.MyEmitterPool.SpawnEmitter( H7CreatureStack( mMovingStack ).GetCreature().GetTeleportStartParticleFX(), mMovingStack.Location, mMovingRepresentation.Rotation );
			class'H7CombatMapGridController'.static.GetInstance().AddParticleSystemToMonitorList( psc );
		}

		H7CreatureStack(mMovingStack).Hide();

		OpenGateOnTargetPos();

		GotoState('Moving');
	}
}

state Moving
{
	event UpdateMovement(float deltaTime)
	{
		local Rotator targetRot;
	
		mMoveTime += deltaTime;

		if( H7Unit( mTarget ) != none )
		{
			targetRot = GetTargetRotation(0);	
			mMovingRepresentation.SetRotation(targetRot);
		}
		
		if(mMoveTime >= mSecPerField)
		{
			mMoveTime = 0.f;
			FieldArrive();
		}
	}

	protected function FieldArrive()
	{
		mPath.Remove(0, 1);

		if(mPath.Length == 0)
		{
			H7CreatureStack(mMovingStack).SetGridPosition(mDestinationCell.GetCellPosition());
			GotoState('Appear');
		}
	}
}

state Appear
{
	simulated event BeginState(Name PreviousStateName)
	{
		H7CreatureStack(mMovingStack).GetCreature().GetAnimControl().PlayAnim( CAN_MOVE_END );
		H7CreatureStack(mMovingStack).Show(true);
		mSecToAppear = H7CreatureStack(mMovingStack).GetCreature().GetAnimControl().GetCurrentAnimTime() - 0.1f;
		mSecToAppear /= H7CreatureStack(mMovingStack).GetCreature().CustomTimeDilation;
		mMoveTime = 0.f;
		
		if(mMovingStack != none && H7CreatureStack( mMovingStack ).GetCreature().GetEndTeleportFXSound() != none && !class'H7SpectatorHUDCntl'.static.GetInstance().GetPopup().IsVisible())
		{
			mMovingStack.PlayAkEvent( H7CreatureStack( mMovingStack ).GetCreature().GetEndTeleportFXSound(),true,,, H7CreatureStack( mMovingStack ).Location );
		}
	}

	event UpdateMovement(float deltaTime)
	{
		mMoveTime += deltaTime;

		if(mMoveTime >= mSecToAppear)
		{
			mMoveTime = 0.f;
			FieldArrive();
		}
	}

	protected function FieldArrive()
	{
		local ParticleSystemComponent psc;

		if(H7CreatureStack( mMovingStack ).GetCreature().HasTeleportEndFX())
		{
			psc = WorldInfo.MyEmitterPool.SpawnEmitter( H7CreatureStack( mMovingStack ).GetCreature().GetTeleportEndParticleFX(), mMovingStack.Location, mMovingRepresentation.Rotation );
			class'H7CombatMapGridController'.static.GetInstance().AddParticleSystemToMonitorList( psc );
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
	simulated event BeginState(Name PreviousStateName)
	{
		local Rotator targetRot;

		mMoveTime = 0.f;
		mStartRot = mMovingStack.Rotation;
		targetRot = mStartRot - GetCurrentTargetRotation();
		if (targetRot.Yaw > 0)
		{
			H7CreatureStack(mMovingStack).GetCreature().GetAnimControl().PlayAnim( CAN_TURNLEFT );
		}   
		else
		{
			H7CreatureStack(mMovingStack).GetCreature().GetAnimControl().PlayAnim( CAN_TURNRIGHT );
		}

		AddEnemyPositionToPath();
	}

	event UpdateMovement(float deltaTime)
	{
		local Rotator targetRot, lerpRot;
	
		mMoveTime += deltaTime;

		targetRot = GetTargetRotation(0);
		
		if( class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed() <= 1.f )
		{
			lerpRot.Yaw = Lerp( mStartRot.Yaw , targetRot.Yaw , mMoveTime / mSecPerField );
		}
		else
		{
			// instant set to avoid visual glitches due to overshooting the target
			lerpRot.Yaw = targetRot.Yaw;
			mMoveTime = mSecPerField;
		}

		mMovingRepresentation.SetRotation(lerpRot);
		
		if(mMoveTime >= mSecPerField)
		{
			mMoveTime = 0.f;
			FieldArrive();
		}
	}

	protected function FieldArrive()
	{	
		// Rotating to enemy is done
		OnAttackStackFinishedFunc();
		mTarget = none;
		GotoState('Idle');
	}
}

