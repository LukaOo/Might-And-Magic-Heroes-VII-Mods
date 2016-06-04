//=============================================================================
// H7EffectSpecialTsunami
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialTsunami extends  Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);

var() H7Wave mWaveEffect                    <DisplayName=Wave>;
var() int    mSmallCreatureShift            <DisplayName= Shift Creature whithin X Tiles>;
var() int    mBigCreatureShift              <DisplayName= Shift Big Creature whithin X Tiles>;
var() bool   mRotateRandom                  <DisplayName=Rotate Creatures in Random Direction>;

var H7BaseAbility mSource;
var Vector mStartPos, mTargetPos;
var H7Wave mTsunami;
var bool mIsDiv2;
var bool mIsAttacker, mIsAiCaster; // casted by AI -> skip stack ghosts (dude knows stuff and doesn't need preview)
var H7CombatMapGridController mGridCnt;
var array<CreaturePositon> mNewCreaturePosition;
//var array<H7CreatureStack> mCasualtyStacks;

native private function bool IsTargetOnPosition( array<H7IEffectTargetable> targets, IntPoint cellPos );
native private function PreCalculateNewCreaturePostitions( array<H7IEffectTargetable> targets );
native private function PreviewSiftToNewPosition( H7IEffectTargetable target );
native private function bool IsStackShifted(H7CreatureStack creatureStack);
native private function bool IsSpaceFree( IntPoint position );
native private function bool IsCellIsAlreadyTaken(IntPoint cellPos);
native private function bool IsCellOnGrid(IntPoint cellPos);
native private function CreaturePositon CreateCreaturePosition( IntPoint NewPos, H7CreatureStack creatureStack );

function Initialize( H7Effect effect )
{
	mIsAiCaster = effect.GetSource().GetCaster().GetPlayer().IsControlledByAI();
}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7ICaster Caster;
	local array<H7IEffectTargetable> targets;

	if( mGridCnt == none )
	{
		mGridCnt = class'H7CombatMapGridController'.static.GetInstance();
	}

	if( mSource == none )
	{
		mSource = H7BaseAbility ( effect.GetSource() );
	}

	Reset();

	effect.GetTargets( targets );
	// Calculate the start and end postition of the wave 
	CalculateInitialVectors();
	PreCalculateNewCreaturePostitions( targets );
	
	if( isSimulated )
	{
		if( !mIsAiCaster )
		{
			PreviewCreaturePositions();
		}

		mSource = none;
		mTsunami = none;
		mGridCnt = none;
		mNewCreaturePosition.Length = 0;
		//mCasualtyStacks.Length = 0;

		return;
	}

	// AI has no preview -> no need to call this
	if( !mIsAiCaster )
		class'H7CombatController'.static.GetInstance().DestroyAllStackGhosts();

	// precalc new pos of  target creatures
	Caster =  mSource.GetCasterOriginal() ;
  
	//mTsunami = class'WorldInfo'.static.GetWorldInfo().Spawn( class'H7Wave', Actor(FXOwner),, mStartPos,, mWaveEffect ); 
	//mTsunami.InitWave(mStartPos,mTargetPos, targets, HitUnit, NextWaveStep);

	if( H7Unit( Caster ) != none )
	{
		H7Unit( Caster ).InitCurrentWave( mWaveEffect, mStartPos, mTargetPos, targets, mSource, mRotateRandom );
		H7Unit( Caster ).SetNewCreaturePosition( mNewCreaturePosition);
	}

	mSource = none;
	mTsunami = none;
	mGridCnt = none;
	mNewCreaturePosition.Length = 0;
	//mCasualtyStacks.Length = 0;
}

function CalculateInitialVectors()
{
	SetStartPos();
	SetEndPos();
}

function SetEndPos()
{
	
	local H7CombatMapCell cell;
	
	cell = mGridCnt.GetCell( mStartPos );

	// Hero  cast right -> left
	if ( mSource.GetCasterOriginal().GetLocation().X > mSource.GetImpactTargetPos().X )
	{
		cell = mGridCnt.GetCombatGrid().FindNearestCellInRange( cell.mPosition, WEST, mSource.GetTsunamiRows());
	}
	// Hero  cast left -> right
	else 
	{
		if(  mIsDiv2 )
		{
			cell = mGridCnt.GetCombatGrid().FindNearestCellInRange( cell.mPosition, EAST, mSource.GetTsunamiRows() - 1);
		}
		else 
		{
			cell = mGridCnt.GetCombatGrid().FindNearestCellInRange( cell.mPosition, EAST, mSource.GetTsunamiRows() );
		}
	}

	mTargetPos = cell.GetLocation();
}

function SetStartPos()
{
	local H7CombatMapCell cell;
	local int rows;

	cell = mGridCnt.GetCell( mSource.GetImpactTargetPos() );
	mIsDiv2 = mSource.GetTsunamiRows() % 2 == 0;
	rows =  mSource.GetTsunamiRows() / 2;
	// Hero cast right -> left
	if ( mSource.GetCasterOriginal().GetLocation().X > mSource.GetImpactTargetPos().X )
	{
		mIsAttacker = false;
		if ( mIsDiv2 )
		{
			cell = mGridCnt.GetCombatGrid().FindNearestCellInRange( cell.mPosition , EAST, rows -1 );
		}
		else 
		{
			cell = mGridCnt.GetCombatGrid().FindNearestCellInRange( cell.mPosition , EAST, rows);
		}
	}
	else // Hero cast left -> right
	{
		mIsAttacker = true;
		cell = mGridCnt.GetCombatGrid().FindNearestCellInRange( cell.mPosition , WEST, rows  );
	}
	
	if( cell != none )
		mStartPos = mGridCnt.GetCenterPosForColCells( cell.mPosition.X );
}

function PreviewCreaturePositions()
{
	local int i;
	
	for ( i=0;i<mNewCreaturePosition.Length;++i )
	{
		if( mNewCreaturePosition[i].Stack == none ) { continue; }
		mNewCreaturePosition[i].Stack.CreateGhost( mGridCnt.GetCombatGrid().GetCellByIntPoint( mNewCreaturePosition[i].ToGridPosition ),, true);
	}
}

function Reset()
{
	local Vector empty;

	mStartPos = empty;
	mTargetPos = empty;
	mIsDiv2 = false;
	mIsAttacker = false;
	mNewCreaturePosition.Length = 0;
	//mCasualtyStacks.Length = 0;
	
	class'H7CombatController'.static.GetInstance().DestroyAllStackGhosts();
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_TSUNAMI","H7TooltipReplacement");
}

