//=============================================================================
// H7CombatMapGridDebug
//=============================================================================
//
//=============================================================================
// Copyright 1998-2013 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7CombatMapGridDebug extends Object;

var protected H7CombatMapCell mDefendCell;
var protected Vector mDefendPosition;
var protected Rotator mCursorRotation;
var protected array<H7CombatMapCell> mCurrentAttackPositions;
var protected H7CombatMapGridController mGridController;
var protected  H7CreatureStack mAttacker;

function Setup(H7CombatMapGridController gridController)
{
	mGridController = gridController;
}

function Update(array<H7CombatMapCell> positions, H7CreatureStack attacker, H7CreatureStack defender)
{
	if( attacker == none || defender == none ) return;
	mCurrentAttackPositions = positions;
	mDefendCell = mGridController.GetCombatGrid().GetCellByIntPoint(defender.GetGridPosition());
	if( mDefendCell != none )
	{
		mDefendPosition = mDefendCell.GetCenterByCreatureDim(defender.GetUnitBaseSizeInt());
		mDefendPosition.Z = 0;
	}
	mAttacker = attacker;
}

function RenderDebugAttackPositions(Canvas myCanvas)
{
	local H7CombatMapCell cell;
	local Vector attackPos;
	local Vector screenPos,defendPos,mouseLocation;

	mGridController.GetMouseHitActorAndLocation(mouseLocation);
	mCursorRotation = rotator(mDefendCell.GetCenterPos() - mouseLocation);
	
	foreach mCurrentAttackPositions(cell)
	{
		attackPos = cell.GetCenterByCreatureDim(mAttacker.GetUnitBaseSizeInt());
		attackPos.Z = 0;
		
		screenPos = myCanvas.Project(attackPos);
		defendPos = myCanvas.Project(mDefendPosition);
		myCanvas.SetPos(screenPos.X-2,screenPos.Y-2);
		myCanvas.DrawColor = MakeColor(255,255,255,255);
		myCanvas.DrawBox( 4, 4 );
		myCanvas.Draw2DLine( screenPos.X , screenPos.Y , defendPos.X , defendPos.Y , MakeColor(255,255,255,255) );
		
		myCanvas.SetPos(screenPos.X + 10,screenPos.Y);
		myCanvas.DrawColor = MakeColor(0,255,0,255);
		myCanvas.DrawText(  mGridController.GetCombatGrid().GetAttackPositionRotation(cell, mDefendCell, mAttacker)  );
		
		myCanvas.SetPos(screenPos.X + 10,screenPos.Y + 20);
		myCanvas.DrawColor = MakeColor(0,0,255,255);
		myCanvas.DrawText( class'H7Math'.static.GetRotationDiff( mGridController.GetCombatGrid().GetAttackPositionRotation(cell, mDefendCell, mAttacker) , mCursorRotation.Yaw ) );
	}

	if(mCurrentAttackPositions.Length > 0)
	{
		// mouse
		screenPos = myCanvas.Project(mouseLocation);
		myCanvas.DrawColor = MakeColor(255,0,0,255);
		myCanvas.Draw2DLine( screenPos.X , screenPos.Y , defendPos.X , defendPos.Y , MakeColor(255,0,0,255) );

		myCanvas.SetPos(screenPos.X + 50,screenPos.Y);
		myCanvas.DrawColor = MakeColor(0,255,0,255);
		myCanvas.DrawText(  mCursorRotation.Yaw  );
		
	}

	mCurrentAttackPositions.Remove(0,mCurrentAttackPositions.Length);
}
