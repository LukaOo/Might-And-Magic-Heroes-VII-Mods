//=============================================================================
// H7CreatureStackBaseMover
//=============================================================================
//
// Base class for all movement types (walk, fly, teleport)
//=============================================================================
// Copyright 1998-2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CreatureStackBaseMover extends Actor
	dependson(H7StructsAndEnumsNative)
	native;

var int MOVEMENT_DOTS_PER_CELL;

struct native H7PathPosition
{
	var Vector Position;
	var H7BaseCell Cell;
};

var protected H7Unit mMovingStack;
var protected Actor mMovingRepresentation;
var protected H7PlayerController mPlayerController;
var protected array<H7PathPosition> mPath;
var protected float mMoveTime;
var protected Rotator mStartRot;
var protected Vector mStartPos;
var protected H7BaseCell mDestinationCell, mCurrentCell;
var protected int mCurveMaxStepsAdv, mCurveMaxStepsCombat;

var protected Vector mLerpTargetLocation;
var protected float mLerpTimer;
var protected bool mLerpToLocation;

var protected Rotator mLerpTargetRotation;
var protected float mLerpTimerRotation;
var protected bool mLerpToRotation;

var protected float mSecPerField;

var protected H7IEffectTargetable mTarget;

function Initialize(H7Unit stack)
{
	mPlayerController = class'H7PlayerController'.static.GetPlayerController();
	mMovingStack = stack;
	mMovingRepresentation = mMovingStack.GetEntityType() == UNIT_CREATURESTACK ? H7CreatureStack(mMovingStack).GetCreature() : mMovingStack;
	if( stack.GetEntityType() == UNIT_CREATURESTACK )
	{
		mSecPerField = H7CreatureStack(stack).GetMovementSpeed();
	}
	else // hero of adventuremap
	{
		MOVEMENT_DOTS_PER_CELL = 2;
		mSecPerField = 0.13;
	}
	mSecPerField /= float(Max(MOVEMENT_DOTS_PER_CELL, 1));
}

function float GetSecondsPerField()
{
	local float gS;

	gS = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();
	gS *= mMovingRepresentation.CustomTimeDilation;
	
	if(class'H7ReplicationInfo'.static.GetInstance().IsCombatMap())
	{
		mSecPerField = H7CreatureStack(mMovingStack).GetMovementSpeed() / MOVEMENT_DOTS_PER_CELL;
	}

	return mSecPerField / gS;
}

function MoveStack(array<H7BaseCell> path, optional H7IEffectTargetable targetUnit) {}
function RotateStack(rotator targetRot) {}

delegate OnAttackStackFinishedFunc(){}
function AttackStack( H7IEffectTargetable target, delegate<OnAttackStackFinishedFunc> onAttackStackFinished )
{
	OnAttackStackFinishedFunc = onAttackStackFinished;
}

event UpdateMovement(float deltaTime) {}
function UpdateRotation() {}

function bool IsMoving() 
{ 
	return false;
}

function ClearPath()
{
	mPath.Length = 0;
}

protected function AddEnemyPositionToPath()
{
	local H7PathPosition pathPos;
	local ECellSize size;

	if(mTarget==None)
	{
		return;
	}

	if( mTarget.IsA('H7Unit') )
	{
		size = H7Unit( mTarget ).GetUnitBaseSize();
	}
	else if( mTarget.IsA('H7CombatObstacleObject') )
	{
		if( H7CombatObstacleObject( mTarget ).GetObstacleBaseSizeX() == 1 )
		{
			size = CELLSIZE_1x1;
		}
		else
		{
			size = CELLSIZE_2x2;
		}
	}

	pathPos.Cell = GetCellOfTarget( mTarget );
	pathPos.Position = ( mTarget.IsA('H7CreatureStack') || mTarget.IsA('H7WarUnit') || mTarget.IsA('H7CombatObstacleObject') ) ? H7CombatMapCell(pathPos.Cell).GetCenterPosBySize( size ) : GetCellOfTarget( mTarget ).GetLocation();

	mPath.AddItem( pathPos );
}

protected function array<H7PathPosition> GetSmoothPath(array<H7BaseCell> path)
{
	if( mMovingStack.GetEntityType() == UNIT_CREATURESTACK )
	{
		return GetSmoothCombatPath(path);
	}
	else // hero of adventuremap
	{
		return GetSmoothAdventurePath(path);
	}
}

protected function array<H7PathPosition> GetSmoothAdventurePath(array<H7BaseCell> path)
{
	local array<H7PathPosition> smoothPath;
	local array<Vector> controlPoints, chunkPoints;
	local array<H7BaseCell> pathCut;
	local H7BaseCell cell;
	local Vector bezierPoint, cellLoc;
	local float t;
	local int dotIndex, dotShortIndex, totalDots, chunkDots, movingCreatureSize, cellIndex, pathUsedPoints;
	local H7PathPosition pathPos;
	local int i;
	local bool teleCheck, shipCheck;

	movingCreatureSize = 1;

	// try to cut the path until we're done with all points
	while (path.Length > 0)
	{
		// cut the path at the point there's a teleporter, keep the rest of the path
		pathCut = path;

		controlPoints.Length = 0;
		pathUsedPoints = 0;

		// if we're at the start of the path, add our current location as a point in the path
		if (smoothPath.Length == 0)
		{
			if (H7AdventureHero(mMovingStack) != None)
			{
				pathCut.InsertItem(0, H7AdventureHero(mMovingStack).GetCell());
				path.InsertItem(0, H7AdventureHero(mMovingStack).GetCell());
			}
			else if (H7CreatureStack(mMovingStack) != None)
			{
				pathCut.InsertItem(0, H7CreatureStack(mMovingStack).GetCell());
				path.InsertItem(0, H7CreatureStack(mMovingStack).GetCell());
			}
		}
		foreach pathCut(cell, i)
		{
			cellLoc = cell.GetCenterByCreatureDim(movingCreatureSize);

			if( H7AdventureMapCell( cell ) != none )
			{
				if( i + 1 >= pathCut.Length )
				{
					teleCheck = true;
				}
				else
				{
					teleCheck = class'H7Teleporter'.static.EnterTeleporterCheck( H7AdventureMapCell( pathCut[ i ] ), H7AdventureMapCell( pathCut[ i + 1 ] ) );
					shipCheck = i + 1 < pathCut.Length && H7AdventureMapCell(pathCut[i+1]).mMovementType != MOVTYPE_WATER && H7AdventureMapCell(pathCut[i]).mMovementType == MOVTYPE_WATER;
				}
			}
			else
			{
				teleCheck = true;
			}
			// if the tile has a teleporter, use the center of the teleporter as location (instead of the entrance, which is not at the middle)
			if (H7EditorAdventureTile(cell) != None && H7EditorAdventureTile(cell).mVisitableSite != None && H7Teleporter(H7EditorAdventureTile(cell).mVisitableSite) != None && teleCheck)
			{
				// only do it if we used the teleporter sometime at the path. if we start walking while standing on it it looks weird
				if (pathUsedPoints != 0)
				{
					cellLoc = H7Teleporter(H7EditorAdventureTile(cell).mVisitableSite).Location;
				}
			}

			controlPoints.AddItem(cellLoc);
			path.Remove(0, 1);
			pathUsedPoints++;

			// if we found a teleporter/ship *for the next step*, break and only use this section of the path for now
			if (controlPoints.Length > 1 && H7AdventureMapCell(cell) != None)
			{
				if ( (H7AdventureMapCell(cell).mVisitableSite != None && H7Teleporter(H7AdventureMapCell(cell).mVisitableSite) != None && teleCheck)
					|| H7AdventureMapCell(cell).GetShip() != None || shipCheck )
				{

					break;
				}
			}
		}

		totalDots = MOVEMENT_DOTS_PER_CELL * pathUsedPoints;

		dotShortIndex = 1;
		for(dotIndex = 1; dotIndex <= totalDots; dotIndex++)
		{
			// calculate the bezier curve with a chunk of only as much as mCurveMaxStepsAdv points
			chunkPoints = controlPoints;
			if (chunkPoints.Length > mCurveMaxStepsAdv)
				chunkPoints.Length = mCurveMaxStepsAdv;

			chunkDots = (MOVEMENT_DOTS_PER_CELL * chunkPoints.Length);

			t = float(dotShortIndex) / float(chunkDots);
			bezierPoint = class'H7Math'.static.Bezier(t, chunkPoints);

			// debug
			//if (dotIndex == totalDots)
			//{
			//	DrawDebugSphere(bezierPoint, 60.0f, 4, 255,0,64, true);
			//	DrawDebugSphere(chunkPoints[chunkPoints.Length - 1], 75.0f, 4, 0,255,64, true);
			//}
			//`log("! dotIndex "$dotIndex$" totalDots "$totalDots$" / pathCut "$pathCut.Length$" / t "$t$" / dotShrtI "$dotShortIndex$" / chnkDts "$chunkDots$" / conPnts "$controlPoints.Length);

			cellIndex = DotIndexToCellIndex(dotIndex, totalDots, pathUsedPoints);
			cell = pathCut[cellIndex];

			pathPos.Position = bezierPoint;
			pathPos.Cell = cell;

			smoothPath.AddItem(pathPos);

			// rearrange the path chunk for the next iteration
			if (dotIndex % MOVEMENT_DOTS_PER_CELL == 0)
			{
				if (dotShortIndex > chunkPoints.Length * MOVEMENT_DOTS_PER_CELL / 2)
				{
					controlPoints.Remove(0, 1);
					dotShortIndex -= MOVEMENT_DOTS_PER_CELL;
				}
			}
			dotShortIndex++;
		}
	}

	return smoothPath;
}

protected function array<H7PathPosition> GetSmoothCombatPath(array<H7BaseCell> path)
{
	local array<H7PathPosition> smoothPath;
	local array<Vector> controlPoints, chunkPoints;
	local array<H7BaseCell> controlCells;
	local Vector bezierPoint;
	local float t;
	local int i, j, totalDots, dotsPerCell, dotShortIndex, chunkDots, mCurveDivision;
	local ECellSize size;
	local H7PathPosition pathPos;

	size = H7CreatureStack(mMovingStack).GetCreature().GetBaseSize();

	path.InsertItem(0, H7CreatureStack(mMovingStack).GetCell());

	mCurveDivision = 4;

	for(i = 0; i < path.Length; i++)
	{
		controlPoints.AddItem(H7CombatMapCell(path[i]).GetCenterPosBySize(size, false));
		controlCells.AddItem(path[i]);
		if (i + 1 < path.Length)
		{
			for (j = 1; j < mCurveDivision; j++)
			{
				controlPoints.AddItem( VLerp(H7CombatMapCell(path[i]).GetCenterPosBySize(size, false), H7CombatMapCell(path[i+1]).GetCenterPosBySize(size, false), float(j) / float(mCurveDivision)) );
				controlCells.AddItem(path[i]);
			}
		}
	}

	dotsPerCell = MOVEMENT_DOTS_PER_CELL / mCurveDivision;
	totalDots = (dotsPerCell * controlPoints.Length) - dotsPerCell;

	dotShortIndex = 1;
	for(i = 1; i <= totalDots; i++)
	{
		// calculate the bezier curve with a chunk of only as much as mCurveMaxStepsCombat points
		chunkPoints = controlPoints;
		if (chunkPoints.Length > mCurveMaxStepsCombat)
			chunkPoints.Length = mCurveMaxStepsCombat;

		chunkDots = dotsPerCell * (chunkPoints.Length - 1);

		t = float(dotShortIndex) / float(chunkDots);
		bezierPoint = class'H7Math'.static.Bezier(t, chunkPoints);

		//`log(i$", "$dotShortIndex$", "$chunkPoints.Length$", "$chunkDots$", "$t);
		//DrawDebugSphere(bezierPoint + Vect(0,0,20), 10, 4, 0,255,0, true);

		pathPos.Position = bezierPoint;
		pathPos.Cell = controlCells[i];

		smoothPath.AddItem(pathPos);

		// rearrange the path chunk for the next iteration
		if (i % dotsPerCell == 0)
		{
			if (dotShortIndex > chunkPoints.Length * dotsPerCell / 2)
			{
				controlPoints.Remove(0, 1);
				dotShortIndex -= dotsPerCell;
			}
		}
		dotShortIndex++;
	}

	return smoothPath;
}

protected function int DotIndexToCellIndex(int dotIndex, int totalDots, int totalCells)
{
	local int cellIndex;
	local float factor;

	factor = float(totalCells - 1)/float(totalDots - 1);

	cellIndex = Round(factor * float(dotIndex));

	return cellIndex;
}

protected function Rotator GetTargetRotation(int pathIndex)
{
	local Rotator rotationI, rotationIPlus;

	// middle of i and i+1
	rotationI = GetOptimalTargetRotation( mMovingStack.Location, mPath[pathIndex].Position );
	if(pathIndex + 1 < mPath.Length)
	{
		rotationIPlus = GetOptimalTargetRotation( mPath[pathIndex].Position, mPath[pathIndex + 1].Position);
		return rotationIPlus;
	}

	return rotationI;
}

protected function Rotator GetOptimalTargetRotation(Vector from, Vector to)
{
	local Rotator targetRot1, targetRot2;

	targetRot1 = rotator(to - from);
	targetRot2 = targetRot1;
	
	if(targetRot1.Yaw < 0)
	{
		targetRot2.Yaw += 65540;
	}
	else
	{
		targetRot2.Yaw -= 65540;
	}

	// Check which of the two rotation possibilities is optimal
	if(abs(mStartRot.Yaw - targetRot1.Yaw) < abs(mStartRot.Yaw - targetRot2.Yaw))
	{
		return targetRot1;
	}
	else
	{
		return targetRot2;
	}
}

protected function H7BaseCell GetCellOfTarget( H7IEffectTargetable target )
{
	local H7CombatMapGridController combatGridController;

	combatGridController = class'H7CombatMapGridController'.static.GetInstance();
	if( combatGridController != none && ( H7CreatureStack(target) != none || H7WarUnit( target ) != none || H7CombatObstacleObject( target ) != none ) )
	{
		return combatGridController.GetCombatGrid().GetCellByIntPoint( target.GetGridPosition() );
	}
	else
	{
		return H7AdventureHero(target).GetCell();
	}
}

protected function Vector GetCellLocation( H7BaseCell cell )
{ 
	local H7CombatMapGridController combatGridController;

	combatGridController = class'H7CombatMapGridController'.static.GetInstance();
	if( combatGridController != none )
	{
		return H7CombatMapCell(cell).GetCenterPosBySize( H7CreatureStack(mMovingStack).GetCreature().GetBaseSize(), false );
	}
	else
	{
		return H7AdventureMapCell(cell).GetLocation();
	}
}

// only for creature stacks
function OpenGateOnTargetPos()
{
	local H7CombatMapCell			cell, currentCell;
	local H7CombatMapGate			gate;
	local array<H7CombatMapCell>	cells;

	if( mPath.Length > 0 )
	{
		cell = H7CombatMapCell( mPath[mPath.Length-1].Cell );
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

function SetLerpToLocation( Vector targetLocation )
{
	mLerpTargetLocation = targetLocation;
	mLerpTimer = 0.0f;
	mLerpToLocation = true;
}

function SetLerpToRotation( Rotator targetRotation )
{
	mLerpTargetRotation = targetRotation;
	mLerpTimerRotation = 0.0f;
	mLerpToRotation = true;
}

event LerpToLocation( float deltaTime )
{
	if( mLerpToLocation )
	{
		mLerpTimer += deltaTime * 0.1f;
		if( H7CreatureStack( mMovingStack ) != none )
		{
			H7CreatureStack( mMovingStack ).SetStackLocation( VLerp( mMovingRepresentation.Location, mLerpTargetLocation, mLerpTimer ) );
		}
		else
		{
			mMovingRepresentation.SetLocation( VLerp( mMovingRepresentation.Location, mLerpTargetLocation, mLerpTimer ) );
		}

		if( mLerpTimer >= 0.1f ) 
		{

			if( H7CreatureStack( mMovingStack ) != none )
			{
				H7CreatureStack( mMovingStack ).SetStackLocation( mLerpTargetLocation );
			}
			else
			{
				mMovingRepresentation.SetLocation( mLerpTargetLocation );
			}
			mLerpToLocation = false;
			mLerpTimer = 0.0f;
			if( mMovingStack != none )
			{
				mMovingStack.StatusChanged();
			}
		}
	}
}

event LerpToRotation( float deltaTime )
{
	local Rotator lerpRot;

	if( mLerpToRotation )
	{
		mLerpTimerRotation += deltaTime * 0.1f;
		lerpRot = RLerp( mMovingRepresentation.Rotation, mLerpTargetRotation, mLerpTimerRotation );
				
		mMovingRepresentation.SetRotation( lerpRot );
		

		if( mLerpTimerRotation >= 0.1f ) 
		{
			mLerpTargetRotation = Normalize(mLerpTargetRotation);
			mMovingRepresentation.SetRotation( mLerpTargetRotation );
			mLerpToRotation = false;
			mLerpTimerRotation = 0.0f;
		}
	}
}

