//=============================================================================
// H7EffectSpecialPushback
//
// 
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7EffectSpecialPushback extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);


var( Push ) private int mPushDistance<DisplayName=Push distance|ClampMin=0>;
var( Push ) private int mPushDistanceDiagonal<DisplayName=Push distance diagonal|ClampMin=0>;
var( Push ) private float mGhostOpacity<DisplayName=Opacity of Pushback Preview Entities>;

var private bool                        mIsSimulated;
var private bool                        mIsAiCaster;
var private array<H7IEffectTargetable>  mTargets;
var private EDirection                  mPushDirection;
var private H7CombatMapGridController   mCombatMapGridController;

function Initialize( H7Effect effect )
{
	mIsAiCaster = effect.GetSource().GetCaster().GetPlayer().IsControlledByAI();
}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<H7IEffectTargetable> targets;
	if( mCombatMapGridController == none )
	{
		mCombatMapGridController = class'H7CombatMapGridController'.static.GetInstance();
		if( mCombatMapGridController == none )
		{
			;
			mTargets.Length = 0;
			mCombatMapGridController = none;
			return;
		}
	}

	mIsSimulated = isSimulated;

	if( H7BaseAbility( effect.GetSource() ) == none || !H7BaseAbility( effect.GetSource() ).IsDirectionalCast() ) 
	{
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(self@effect.GetName()@"can only be used with directional abilities!",MD_QA_LOG);;
		mTargets.Length = 0;
		mCombatMapGridController = none;
		return;
	}

	mPushDirection = H7BaseAbility( effect.GetSource() ).GetAbilityDirection();

	if( !mIsAiCaster )
		DestroyPreviousGhosts();

	mTargets = container.TargetableTargets;
	effect.GetValidTargets( mTargets, targets );
	mTargets = targets;

	if( mPushDirection == EDirection_MAX || mTargets.Length == 0 ) return;

	HandlePushBackEffect();

	mTargets.Length = 0;
	mCombatMapGridController = none;
}

function DestroyPreviousGhosts()
{
	local H7IEffectTargetable trg;

	foreach mTargets(trg)
		if( H7CreatureStack( trg ) != none )
			H7CreatureStack( trg ).DestroyGhost();
}

function private HandlePushBackEffect()
{
	local int i;
	local H7CombatMapCell cell;
	local H7CreatureStack stack;

	for( i = 0; i < mTargets.Length; ++i )
	{
		stack = H7CreatureStack( mTargets[i] );
		if( stack == none ) continue;

		cell = mCombatMapGridController.GetCombatGrid().GetNeighbourCellInDirection( stack.GetCell(), mPushDirection );
		cell = GetPushTargetCell( cell, H7CreatureStack( mTargets[i] ) );

		if( mIsSimulated )
		{
			if( !mIsAiCaster )
				ShowCellPreview( cell );
		}
		else
		{
			RepositionCreatureStack( stack, cell );
		}
	}
}

function H7CombatMapCell GetPushTargetCell( H7CombatMapCell directionCell, H7CreatureStack stack )
{
	local IntPoint dif, masterPoint;
	local int distance, currentDistance;
	local H7CombatMapCell cell, targetCell;

	masterPoint = stack.GetCell().GetMaster().GetGridPosition();

	dif.X = masterPoint.X - directionCell.GetGridPosition().X;
	dif.Y = masterPoint.Y - directionCell.GetGridPosition().Y;

	distance = Abs(dif.X) == Abs(dif.Y) ? mPushDistanceDiagonal : mPushDistance;

	targetCell = stack.GetCell().GetMaster();
	for( currentDistance = 1; currentDistance <= distance; ++currentDistance )
	{
		masterPoint = stack.GetCell().GetMaster().GetGridPosition();

		dif.X = masterPoint.X - directionCell.GetGridPosition().X;
		dif.Y = masterPoint.Y - directionCell.GetGridPosition().Y;

		dif.X *= currentDistance;
		dif.Y *= currentDistance;

		dif.X *= -1;
		dif.Y *= -1;
		
		masterPoint.X += dif.X;
		masterPoint.Y += dif.Y;

		cell = class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid().GetCellByIntPoint( masterPoint );
		
		if( !CanReachCell( stack, cell ) )
		{
			return targetCell;
		}

		targetCell = cell;
	}

	return targetCell;
}

function private bool CanReachCell( H7CreatureStack stack, H7CombatMapCell cell )
{
	if( cell == none || cell.IsWarfareBuffer() ) return false;
	return stack.GetPathfinder().CanMoveToCell( cell );
}

function private RepositionCreatureStack( H7CreatureStack stack, H7CombatMapCell cell )
{
	local array<H7CombatMapCell> fakePath;
	if( stack == none ) return;

	// fake path for Entangle buff damage effect
	stack.GetPathfinder().GetPathByCell(cell, fakePath);
	stack.SetLastWalkedPath(fakePath);

	stack.RemoveCreatureFromCell();

	stack.GetMovementControl().LerpStackToLocation( cell.GetCenterByCreatureDim( stack.GetUnitBaseSizeInt() ) );

	stack.SetGridPosition( cell.GetGridPosition() );

	cell.PlaceCreature( stack, false );
}

function private ShowCellPreview( H7CombatMapCell cell )
{
	local int i;
	local array<H7CombatMapCell> highlightCells;

	for( i = 0; i < mTargets.Length; ++i )
	{
		cell.GetCellsHitByCellSize( H7Unit( mTargets[i] ).GetUnitBaseSize(), highlightCells,true );
		if( H7CreatureStack( mTargets[i] ) != none )
		{
			H7CreatureStack( mTargets[i] ).CreateGhost( highlightCells[0],, true);
		}
	}
	
	mCombatMapGridController.SetAbilityHighlightCells( highlightCells );

	// force update to show the correct cell highlights
	mCombatMapGridController.ForceGridStateUpdate();
}

function String GetTooltipReplacement() 
{
	return Repl(class'H7Loca'.static.LocalizeSave("TTR_PUSHBACK_SPECIAL","H7TooltipReplacement"),"%distance",(mPushDistance!=0?mPushDistance:mPushDistanceDiagonal));
}

function String GetDefaultString()
{
	return string(mPushDistance!=0?mPushDistance:mPushDistanceDiagonal);	
}

function string GetValue(int nr)
{
	if(nr == 1) 
	{
		return class'H7GameUtility'.static.FloatToString(mPushDistance);
	}
	else
	{
		return class'H7GameUtility'.static.FloatToString(mPushDistanceDiagonal);
	}
}

