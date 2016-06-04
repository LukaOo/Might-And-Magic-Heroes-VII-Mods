//=============================================================================
// H7CreatureStackMover
//=============================================================================
// Class that handles all creature stack movement and animation sequences for
// the combat map. It is instanced by and a member of any CreatureStack object.
//=============================================================================
// Copyright 1998-2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CreatureStackMover extends H7CreatureStackBaseMover;
	
var protected float mHeroTurnTime;
var protected float mHeroPreTurnTime;
var protected float mCreaturePreTurnTime;
var protected float mHeroPostTurnTime;
var protected float mCreaturePostTurnTime;
var protected float mCreatureTurnTimeCut;
var protected float mHeroTurnBlendAlpha;
var protected array<H7AdventureMapCell> mVisitedAdventureCells;
var protected array<H7IEffectTargetable> mPassedThroughTargetables;

var protected ParticleSystem mWaterSplashParticles;
var protected ParticleSystem mDustParticles;

var array<H7BaseCell> mLastPath;

var protected bool mInRotateMode;

function bool IsMoving() 
{ 
	return ( IsInState('Turning') || IsInState('Walking') || IsInState('TurnToEnemy') );
}

function CheckForGateAhead() { }

protected function Rotator GetCurrentTargetRotation()
{
	if(mInRotateMode)
	{
		return mLerpTargetRotation;
	}
	else
	{
		return GetTargetRotation(0);
	}
}


// # intitial state
// state of oblivion to which things are regarded as being relegated when cast aside, forgotten, past, or out of date.
auto state Limbo
{
	function MoveStack( array<H7BaseCell> path, optional H7IEffectTargetable target )
	{
		local Rotator currRot, targetRot;

		if( path.Length == 0 )
		{
			;
			// TODO: game hangs for AI because the hero command doesn't finish
			return;
		}

		mLastPath = path;

		mPath = GetSmoothPath(path);
		if (H7AdventureHero( mMovingStack ) != None && H7AdventureHero( mMovingStack ).GetAdventureArmy() != None && H7AdventureHero( mMovingStack ).GetAdventureArmy().HasShip())
		{
			mStartRot = H7AdventureHero( mMovingStack ).GetAdventureArmy().GetShip().Rotation;
			mStartPos = H7AdventureHero( mMovingStack ).GetAdventureArmy().GetShip().Location;
		}
		else
		{
			mStartRot = mMovingRepresentation.Rotation;
			mStartPos = mMovingStack.Location;
		}
		mDestinationCell = path[path.Length - 1];
		
		if (mMovingStack.GetEntityType() != UNIT_CREATURESTACK) // hero of adventuremap
		{
			mVisitedAdventureCells.Remove(0, mVisitedAdventureCells.Length);
			mVisitedAdventureCells.AddItem(mMovingStack.GetAdventureArmy().GetCell()); //	The starting cell is not considered for new cell reached handling
		}

		mTarget = target;

		targetRot = GetCurrentTargetRotation();

		if (H7AdventureHero( mMovingStack ) != None && H7AdventureHero( mMovingStack ).GetAdventureArmy() != None && H7AdventureHero( mMovingStack ).GetAdventureArmy().HasShip())
			currRot = H7AdventureHero( mMovingStack ).GetAdventureArmy().GetShip().Rotation;
		else
			currRot = mMovingRepresentation.Rotation;

		if( currRot == targetRot || Vector(currRot) dot Vector(targetRot) > 0.95f )
		{
			;
			GotoState('Walking');
		}
		else
		{
			;
			GotoState('Turning');
		}
	}

	function AttackStack( H7IEffectTargetable target, delegate<OnAttackStackFinishedFunc> onAttackStackFinished )
	{
		OnAttackStackFinishedFunc = onAttackStackFinished;
		mStartRot = mMovingRepresentation.Rotation;
		mTarget = target;

		GotoState('TurnToTarget');
	}

	function RotateStack(rotator targetRot)
	{
		mInRotateMode = true;

		mLerpTargetRotation = targetRot;

		if (H7AdventureHero( mMovingStack ) != None && H7AdventureHero( mMovingStack ).GetAdventureArmy() != None && H7AdventureHero( mMovingStack ).GetAdventureArmy().HasShip())
		{
			mStartRot = H7AdventureHero( mMovingStack ).GetAdventureArmy().GetShip().Rotation;
		}
		else
		{
			mStartRot = mMovingRepresentation.Rotation;
		}

		;
		GotoState('Turning');
	}

	Begin:
		mPath.Remove(0, mPath.Length);
		mTarget=None;

}

// # turning state for initial diagonal movement
// 
state Turning
{
	simulated event BeginState(name previousStateName)
	{
		local Rotator targetRot;
		local float gSpeed, gSpeedMin, gSpeedMax;

		if( mMovingStack.GetEntityType() == UNIT_CREATURESTACK )
		{
			// decide which way to turn and play the turning anim
			targetRot = mStartRot - GetCurrentTargetRotation();

			mHeroPreTurnTime = mCreaturePreTurnTime;
			mHeroPostTurnTime = mCreaturePostTurnTime;

			if (targetRot.Yaw > 0 || targetRot.Yaw < -32766)
			{
				;
				mHeroTurnTime = H7CreatureStack(mMovingStack).GetCreature().GetSkeletalMesh().GetAnimLength('Turn90Left') - mCreatureTurnTimeCut;
				H7CreatureStack(mMovingStack).GetCreature().GetAnimControl().PlayAnim( CAN_TURNLEFT );
			}
			else
			{
				;
				mHeroTurnTime = H7CreatureStack(mMovingStack).GetCreature().GetSkeletalMesh().GetAnimLength('Turn90Right') - mCreatureTurnTimeCut;
				H7CreatureStack(mMovingStack).GetCreature().GetAnimControl().PlayAnim( CAN_TURNRIGHT );
			}
		}
		else
		{
			// at 400% (max) gamespeed it needs an mHeroTurnTime of 1.15, at 30% (min) gamespeed it needs an mHeroTurnTime of 0.95
			if( H7CreatureStack(mMovingStack) != none )
			{
				gSpeed = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed() * H7CreatureStack(mMovingStack).GetCreature().CustomTimeDilation;
			}
			else
			{
				gSpeed = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();
			}
			gSpeedMin = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeedConstraints().X;
			gSpeedMax = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeedConstraints().Y;
			mHeroTurnTime = default.mHeroTurnTime + ((gSpeed - gSpeedMin) * 0.2f / (gSpeedMax - gSpeedMin));
		}
	}

	event UpdateMovement(float deltaTime)
	{
		local Rotator currRot, targetRot, lerpRot;
		local int DesiredYaw;
		local float gS;

		if ( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() && H7AdventureHero( mMovingStack ) != None && H7AdventureHero( mMovingStack ).GetAdventureArmy() != None && H7AdventureHero( mMovingStack ).GetAdventureArmy().HasShip())
		{
			targetRot = mInRotateMode ? GetCurrentTargetRotation() : Rotator(mPath[0].Position - mMovingRepresentation.Location);
			currRot = H7AdventureHero( mMovingStack ).GetAdventureArmy().GetShip().Rotation;
		}
		else
		{
			// check for teleporter rotation
			if ( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() && mPath.Length > 0 && class'H7Teleporter'.static.EnterTeleporterCheck( H7AdventureMapCell(mPath[0].Cell), H7AdventureMapCell(mPath[1].Cell) ))
			{
				targetRot = mInRotateMode ? GetCurrentTargetRotation() : Rotator(H7AdventureMapCell(mPath[0].Cell).GetVisitableSite().Location - mMovingRepresentation.Location);
			}
			else
			{
				targetRot = mInRotateMode ? GetCurrentTargetRotation() : Rotator(mPath[0].Position - mMovingRepresentation.Location);
			}
			currRot = mMovingRepresentation.Rotation;
		}
		
		if( H7CreatureStack(mMovingStack) != none )
		{
			gS = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed() * H7CreatureStack(mMovingStack).GetCreature().CustomTimeDilation;
		}
		else
		{
			gS = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();
		}

		if(mMoveTime * gS >= mHeroTurnTime * gS + mHeroPostTurnTime * gS)
		{
			mMoveTime = 0;
			mMovingRepresentation.SetRotation(targetRot);
			mStartRot = currRot;
			if(mInRotateMode)
			{
				mInRotateMode = false;
				// be on the safe side and try to return to the idle state (fixes Strike and Return rotation issue (combat got stuck))
				if( H7CreatureStack( mMovingStack ) != none )
				{
					H7CreatureStack( mMovingStack ).GetCreature().GetAnimControl().PlayAnim( CAN_IDLE );
				}
				GotoState('Limbo');
			}
			else
			{
				;
				GotoState('Walking');
			}
		}
		else
		{
			mMoveTime += deltaTime * gS;
			if( currRot != targetRot )
			{
				lerpRot = RLerp( mStartRot , targetRot , FMin(1.0f, FMax(0.0f, mMoveTime - mHeroPreTurnTime) / (mHeroTurnTime - mHeroPreTurnTime)), true );
				lerpRot = Normalize(lerpRot);

				mMovingRepresentation.SetRotation(lerpRot);
				if( mMovingStack.GetEntityType() == UNIT_HERO && H7AdventureHero(mMovingStack).GetAdventureArmy().HasShip() )
				{
					lerpRot.Pitch = 0;
					 H7AdventureHero(mMovingStack).GetAdventureArmy().GetShip().SetRotation( lerpRot );
				}

				if (Vector(mMovingRepresentation.Rotation) dot Vector(targetRot) < 0.9975f)
				{
					if (H7AdventureHero(mMovingStack) != None && !H7AdventureHero(mMovingStack).GetAnimControl().IsPlayingAnim())
					{
						DesiredYaw = (targetRot - mMovingRepresentation.Rotation).Yaw;
						if (DesiredYaw < 0)
						{
							DesiredYaw += 65536;
						}
						if (DesiredYaw > 65536/2)
						{
							H7AdventureHero(mMovingStack).GetAnimControl().PlayAnim( HA_TURNLEFT );
						}
						else
						{
							H7AdventureHero(mMovingStack).GetAnimControl().PlayAnim( HA_TURNRIGHT );
						}
					}
				}
			}
		}
	}
}

unreliable client function CreateFootprint(H7AdventureMapCell cell)
{
	local MaterialInstanceTimeVarying footPrintMat;
	if( cell.IsWet )
	{
		WorldInfo.MyEmitterPool.SpawnEmitter( mWaterSplashParticles, mMovingStack.Location, mMovingRepresentation.Rotation );
	}
	else
	{
		// TODO FIX IT: SpawnDecal will make the game crash after a while of using it. Possible solution is do some footstep manager,
		// similar to what the path (decal dots) is doing.
		footPrintMat = new(self) class'MaterialInstanceTimeVarying';
		footPrintMat.SetParent(MaterialInstanceTimeVarying'H7FX_Footprints.M_Groundprint_Fade');
		WorldInfo.MyDecalManager.SpawnDecal( footPrintMat, mMovingStack.Location + Vect(0,0,50), mMovingRepresentation.Rotation + Rotator(Vect(-1,-1,-1)), 200, 200, 400, false, 135 );
		WorldInfo.MyEmitterPool.SpawnEmitter( mDustParticles, mMovingStack.Location, mMovingRepresentation.Rotation );
	}
}

function InterruptAndRotate()
{
	GotoState('Limbo');
	MoveStack(mLastPath);
}

// # walking state
// 
state Walking
{
	simulated event BeginState(name previousStateName)
	{
		mMoveTime = 0.0f;
		mPassedThroughTargetables.Length = 0;
				
		if( mMovingStack.GetEntityType() == UNIT_CREATURESTACK )
		{
			CheckForGateAhead();
		}
	}

	event UpdateMovement(float deltaTime)
	{
		local Vector targetPos, lerpPos;
		local Rotator facingRot, targetRot;
		local H7AdventureMapCell targetCell, currentCell, exitCell;
		local int i, lastDotIndex, currentPathIndex;
		local bool usingTeleporter;
		local H7BaseCell previousCell;
		local H7CombatMapCell previousCellCombat;
		local H7Command command;
		local array<H7BaseCell> interruptPath;
		local bool doInterrupt;
		local H7CreatureStackGhostWalker ghostWalker;
		local EMovementType moveType;
		local float blendAlpha;
		local H7EventContainerStruct container;
		local H7IEffectTargetable target;
		local bool hasEnoughMovePointsForUsingTeleporterAndCanThisVariableNameBeAnyLonger;
		local array<H7CombatMapCell> passingCells;
		local H7CombatMapCell passingCell;

		if( mPath.Length == 0 )
		{
			if( mTarget != None )
			{
				;
				GotoState('TurnToTarget');
				return;
			}
			else
			{
				GotoState('Limbo');
				return;
			}
		}

		if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
		{
			command = class'H7CombatController'.static.GetInstance().GetCommandQueue().GetCurrentCommand();
		}
		else
		{
			command = class'H7AdventureController'.static.GetInstance().GetCommandQueue().GetCurrentCommand();
		}

		if( command != none && command.GetCommandSource() == mMovingStack && 
			command.GetCommand() == UC_MOVE && 
			command.IsRunning() && 
			( command.ShouldInterruptOnNextUpdate() || mMovingStack.IsDead() ) &&
			!command.WasInterrupted() )
		{
			doInterrupt = true;
			if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() )
			{
				// finish walking to the next tile
				currentPathIndex = mLastPath.Find( mCurrentCell );
				if( ( currentPathIndex + 1 ) >= mLastPath.Length )
				{
					interruptPath.AddItem( mCurrentCell );
				}
				else
				{
					interruptPath.AddItem( mLastPath[ ( currentPathIndex + 1 ) ] );
				}

				if( mCurrentCell.mPosition.X - interruptPath[0].mPosition.X > 1 && 
					mCurrentCell.mPosition.Y - interruptPath[0].mPosition.Y > 1 && 
					!H7AdventureMapCell( mCurrentCell ).IsTeleporterEntrance() &&
					!H7AdventureMapCell( interruptPath[0] ).IsTeleporterEntrance() )
				{
					doInterrupt = false;
				}

				if( H7AdventureMapCell( interruptPath[0] ).GetArmy() != none && H7AdventureMapCell( interruptPath[0] ).GetArmy() != H7AdventureHero( mMovingStack ).GetAdventureArmy() || 
					H7AdventureMapCell( mCurrentCell ).GetArmy() != none && H7AdventureMapCell( mCurrentCell ).GetArmy() != H7AdventureHero( mMovingStack ).GetAdventureArmy() )
				{
					doInterrupt = false;
				}
			}
			else
			{
				if( !mMovingStack.IsDead() )
				{
					class'H7FCTController'.static.GetInstance().startFCT( FCT_TEXT, H7CreatureStack(mMovingStack).GetFloatingTextLocation()+vect(0,0,150.f), mMovingStack.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_INTERRUPTED","H7FCT"), MakeColor(255,255,0,255) );
				}

				interruptPath.AddItem( mCurrentCell );
				class'H7CombatController'.static.GetInstance().GetCommandQueue().SetLastCommandExecuted( ACTION_MOVE );
			}

			if( doInterrupt )
			{
				mPath = GetSmoothPath( interruptPath );
				mDestinationCell = mCurrentCell;
				command.SetInterrupted( true );
			}
			command.SetInterruptOnNextUpdate( false );
		}

		if( mCurrentCell != mPath[0].Cell )
		{
			previousCell = mCurrentCell;
			previousCellCombat = H7CombatMapCell( previousCell );
			mCurrentCell = mPath[0].Cell;
			if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
			{
				moveType = H7CreatureStack(mMovingStack).GetMovementType();

				if(moveType == CMOVEMENT_GHOSTWALK && H7CombatMapCell( mCurrentCell).HasCreatureStack() &&  mCurrentCell != mDestinationCell && H7CombatMapCell( mCurrentCell).GetCreatureStack().Name !=  H7CreatureStack( mMovingStack ).Name )
				{
					ghostWalker = H7CreatureStack( mMovingStack ).GetMovementControl().GetGhostMover();
					ghostWalker.UpdateGhostMovement();
				}

				if( previousCellCombat != none && 
					moveType != CMOVEMENT_GHOSTWALK && moveType != CMOVEMENT_SHROUD )
				{
					if( !previousCellCombat.HasPassableAllies( H7CreatureStack( mMovingStack ) ) )
					{
						H7CombatMapCell( previousCell ).RemoveCreatureStack();
					}
				}

				if(moveType != CMOVEMENT_GHOSTWALK && moveType != CMOVEMENT_SHROUD)
				{
					H7CreatureStack( mMovingStack ).SetGridPosition( mCurrentCell.GetCellPosition() );
				}

				H7CombatMapCell( mCurrentCell ).GetCellsHitByCellSize( mMovingStack.GetUnitBaseSize(), passingCells );
				foreach passingCells(passingCell)
				{
					target = passingCell.GetTargetable();
					if( moveType == CMOVEMENT_SHROUD && target != mMovingStack )
					{
						container.Action = ACTION_MOVE;
						container.ActionTag.Length = 0;
						container.ActionTag.AddItem( TAG_SINGLE_TARGET );
						container.Targetable = target;
						container.TargetableTargets.Length = 0;
						container.TargetableTargets.AddItem( target );

						// once per creature!
						if( mPassedThroughTargetables.Find( target ) == INDEX_NONE )
						{
							target.TriggerEvents( ON_PASS_THROUGH, false, container );
							mMovingStack.TriggerEvents( ON_PASS_THROUGH, false, container );
							mPassedThroughTargetables.AddItem( target );
						}
					}
				}

				if( mCurrentCell != none )
				{
					if( mCurrentCell != mDestinationCell )
					{
						if(moveType != CMOVEMENT_GHOSTWALK && moveType != CMOVEMENT_SHROUD)
						{
							if( !H7CombatMapCell( mCurrentCell ).HasPassableAllies( H7CreatureStack( mMovingStack ) ) )
							{
								H7CombatMapCell( mCurrentCell ).PlaceCreature( H7CreatureStack( mMovingStack ), true );
							}
						}
					}
				}
			}
		}

		mMoveTime += deltaTime;
		mMoveTime = FMin(mMoveTime, GetSecondsPerField());

		targetPos = mPath[0].Position;
		facingRot = Rotator(targetPos - mMovingRepresentation.Location);
		facingRot = RLerp(mMovingRepresentation.Rotation, facingRot, mHeroTurnBlendAlpha, true);
		mMovingRepresentation.SetRotation(facingRot);

		blendAlpha = mMoveTime / GetSecondsPerField();
		if( blendAlpha > 1.0f )
		{
			blendAlpha=1.0f;
		}
		if( blendAlpha < 0.0f )
		{
			blendAlpha=0.0f;
		}
		
		lerpPos = VLerp(mStartPos, targetPos, blendAlpha );

		if( mMovingStack.GetEntityType() == UNIT_CREATURESTACK )
		{
			H7CreatureStack(mMovingStack).SetStackLocation(lerpPos);
		}
		else // hero of adventuremap
		{
			targetCell = H7AdventureMapCell(mPath[0].Cell);
			if(targetCell != none)
			{
				currentCell = H7AdventureHero( mMovingStack ).GetCell();
				for(i = 0; i < mPath.Length; i++)
				{
					if(mPath[i].Cell != currentCell)
					{
						exitCell = H7AdventureMapCell(mPath[i].Cell);
						break;
					}
				}

				hasEnoughMovePointsForUsingTeleporterAndCanThisVariableNameBeAnyLonger = H7AdventureHero( mMovingStack ).GetCurrentMovementPoints() >= H7AdventureHero( mMovingStack ).GetModifiedStatByID(STAT_PICKUP_COST);
				if( hasEnoughMovePointsForUsingTeleporterAndCanThisVariableNameBeAnyLonger )
				{
					usingTeleporter = class'H7Teleporter'.static.EnterTeleporterCheck( currentCell, exitCell );
				}

				if( usingTeleporter )
				{
					// literally teleport and force moving on to the next dot
					lerpPos = targetPos;
					mMovingStack.SetLocation( lerpPos );
					mMoveTime = GetSecondsPerField();

					facingRot = Rotator(targetPos - mMovingRepresentation.Location);
					//facingRot = RLerp(mMovingRepresentation.Rotation, facingRot, mHeroTurnBlendAlpha, true);
					facingRot.Roll = 0;
					facingRot.Pitch = 0;
					mMovingRepresentation.SetRotation(facingRot);
					if( hasEnoughMovePointsForUsingTeleporterAndCanThisVariableNameBeAnyLonger )
					{
						class'H7Teleporter'.static.EnterTeleporterCheck( currentCell,,true );
					}
					//	We skip the smoothed dots between the first dot of the teleporter entry and the last dot of the exit
					lastDotIndex = 0;
					for(i = 0; i < mPath.Length; i++)
					{
						if(mPath[i].Cell == exitCell)
						{
							lastDotIndex = i;
						}
						else
						{
							break;
						}
					}
				}
				else
				{
					if( targetCell.mMovementType == MOVTYPE_WATER && H7AdventureHero( mMovingStack ).GetAdventureArmy().HasShip() )
					{
						facingRot = Rotator(targetPos - H7AdventureHero( mMovingStack ).GetAdventureArmy().GetShip().Location);
						facingRot = RLerp(H7AdventureHero( mMovingStack ).GetAdventureArmy().GetShip().Rotation, facingRot, mHeroTurnBlendAlpha, true);
						facingRot.Pitch = 0;

						// if we're just boarding a ship, pause our movement so we can rotate in place with the ship
						if (mVisitedAdventureCells.Length > 0 && targetCell.mMovementType == MOVTYPE_WATER && H7AdventureHero( mMovingStack ).GetAdventureArmy().HasShip())
						{
							targetRot = Rotator(mPath[0].Position - mMovingRepresentation.Location);
							if (mVisitedAdventureCells.Length > 1 && mVisitedAdventureCells[mVisitedAdventureCells.Length - 2].mMovementType != MOVTYPE_WATER
								&& targetRot != facingRot)
							{
								NextTargetDot();
								InterruptAndRotate();
								return;
							}
						}
		
						H7AdventureHero( mMovingStack ).GetAdventureArmy().GetShip().SetLocation( lerpPos );
						H7AdventureHero( mMovingStack ).GetAdventureArmy().GetShip().SetRotation( facingRot );
					}
					mMovingStack.SetLocation( lerpPos );
				}
			}
		}

		if(mMoveTime >= GetSecondsPerField() )
		{
			//	Remove the smoothed dots between the first dot of the teleporter entry and the last dot of the exit
			if(usingTeleporter && lastDotIndex > 0)
			{
				mPath.Remove(0, lastDotIndex);
				mCurrentCell = mPath[0].Cell;
			}

			mMoveTime = 0.0;
			NextTargetDot();
		}
	}

	// only for creature stacks
	function CheckForGateAhead()
	{
		local H7CombatMapCell			cell, currentCell;
		local H7CombatMapGate			gate;
		local array<H7CombatMapCell>	cells;
		local int						i;

		for( i=0; i<mPath.Length; ++i )
		{
			cell = H7CombatMapCell( mPath[i].Cell );
			cell.GetCellsHitByCellSize( H7CreatureStack(mMovingStack).GetUnitBaseSize(), cells );
			foreach cells( currentCell )
			{
				if( currentCell.IsGatePassage() )
				{
					gate = H7CombatMapGate(currentCell.GetObstacle());
					if( gate != none )
					{
						gate.TryOpenGate();
						return;
					}
				}
			}
		}
	}

	function NextTargetDot()
	{
		local H7AdventureMapCell adventureCell;

		if (mMovingStack.GetEntityType() != UNIT_CREATURESTACK) // hero of adventuremap
		{
			adventureCell = (mPath.Length == 1) ? H7AdventureMapCell(mDestinationCell) : H7AdventureMapCell(mPath[0].Cell);
			if(adventureCell != none && mVisitedAdventureCells.Find(adventureCell)  == -1 )
			{
				NewCellReached(adventureCell);
				mVisitedAdventureCells.AddItem(adventureCell);
			}
		}

		
		if (H7AdventureHero( mMovingStack ) != None && H7AdventureHero( mMovingStack ).GetAdventureArmy() != None && H7AdventureHero( mMovingStack ).GetAdventureArmy().HasShip())
		{
			mStartRot = H7AdventureHero( mMovingStack ).GetAdventureArmy().GetShip().Rotation;
			mStartPos = H7AdventureHero( mMovingStack ).GetAdventureArmy().GetShip().Location;
		}
		else
		{
			mStartRot = mMovingRepresentation.Rotation;
			mStartPos = mMovingStack.Location;
		}

		mPath.Remove(0, 1); // We reached the target cell, remove it from the path

		if( mPath.Length == 0 )
		{
			if( mMovingStack.GetEntityType() == UNIT_CREATURESTACK )
			{
				H7CreatureStack(mMovingStack).SetGridPosition(mDestinationCell.GetCellPosition());
			}

			if( mTarget != None )
			{
				GotoState('TurnToTarget');
			}
			else
			{
				GotoState('Limbo');
			}
		}
	}

	function NewCellReached(H7AdventureMapCell cell)
	{
		local bool heroCanStillMove;

		heroCanStillMove = H7AdventureHero(mMovingStack).UpdatePath();
		if(heroCanStillMove)
		{
			if( cell.GetArmy() != none )
			{
				H7AdventureHero(mMovingStack).GetAdventureArmy().SetCell(cell, false, false);	//	Don't update hero location
			}
			else
			{
				H7AdventureHero(mMovingStack).GetAdventureArmy().SetCell(cell, false);	//	Don't update hero location
			}

			// spawn a footprint decal/particle
			CreateFootprint(cell);

			mLastPath.Remove(0, 1);
		}
		else
		{
			mPath.Length = 1;
			mDestinationCell = cell;
		}
	}

	Begin:
		if( mMovingStack.GetEntityType() == UNIT_CREATURESTACK )
		{
			H7CreatureStack(mMovingStack).GetCreature().GetAnimControl().PlayAnim( CAN_MOVE );
		}
		else // hero of adventuremap
		{
			H7AdventureHero(mMovingStack).GetAnimControl().PlayAnim( HA_MOVE );
		}
		if( mPath.Length == 0 )
		{
			GotoState('TurnToTarget');
		}

}

// # Turning state
//
state TurnToTarget
{
	simulated event BeginState(name previousStateName)
	{
		local Rotator targetRot;

		AddEnemyPositionToPath();

		if( mMovingStack.GetEntityType() == UNIT_CREATURESTACK )
		{
			// decide which way to turn and play the turning anim
			
			targetRot = mStartRot - GetCurrentTargetRotation();

			if (targetRot.Yaw > 0)
			{
				;
				mHeroTurnTime = H7CreatureStack(mMovingStack).GetCreature().GetSkeletalMesh().GetAnimLength('Turn90Left') - mCreatureTurnTimeCut;
				H7CreatureStack(mMovingStack).GetCreature().GetAnimControl().PlayAnim( CAN_TURNLEFT );
			}   
			else
			{
				;
				mHeroTurnTime = H7CreatureStack(mMovingStack).GetCreature().GetSkeletalMesh().GetAnimLength('Turn90Left') - mCreatureTurnTimeCut;
				H7CreatureStack(mMovingStack).GetCreature().GetAnimControl().PlayAnim( CAN_TURNRIGHT );
			}
		}
	}

	event UpdateMovement(float deltaTime)
	{
		local Rotator targetRot, lerpRot;

		if(mMoveTime >= mHeroTurnTime)
		{
			OnAttackStackFinishedFunc();
			mMoveTime = 0.0;
			targetRot = GetCurrentTargetRotation();
			mMovingRepresentation.SetRotation(targetRot);
			GotoState('Limbo');
		}
		else
		{
			mMoveTime += deltaTime;

			targetRot = GetCurrentTargetRotation();
		
			lerpRot.Yaw = Lerp( mStartRot.Yaw , targetRot.Yaw , mMoveTime / mHeroTurnTime );

			mMovingRepresentation.SetRotation(lerpRot);
		}
	}
}

