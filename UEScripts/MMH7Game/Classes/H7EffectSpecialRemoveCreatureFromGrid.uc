//=============================================================================
// H7EffectSpecialRemoveCreatureFromGrid
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialRemoveCreatureFromGrid extends Object implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);

var(RemoveCreatureFromGridEffect) float mSpeed<DisplayName=Flying Speed>;
var(RemoveCreatureFromGridEffect) int mMaxHeight<DisplayName=Fly to Height>;
var(RemoveCreatureFromGridEffect) bool mLookTowardsTargetArea<DisplayName=Look Towards Target Area>;
var(RemoveCreatureFromGridEffect) int mFlyForwardUnits<DisplayName=Fly Forward Units While Ascending>;

var public array<H7CombatMapCell> mTargetCells;
var protected H7CreatureStack mOwner;

function Initialize( H7Effect effect ) 
{
	local H7ICaster initiator;

	mTargetCells.Length = 0;
	initiator = effect.GetSource().GetInitiator();
	mOwner = H7CreatureStack( initiator );
	mOwner.SetDivingAttackArea(mTargetCells);
}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<H7IEffectTargetable> targets;
	local H7IEffectTargetable target;
	local H7CombatMapCell ownerCell;
	local IntPoint pos;
	local Rotator rota;
	local H7ICaster initiator;

	mTargetCells.Length = 0;
	initiator = effect.GetSource().GetInitiator();
	mOwner = H7CreatureStack( initiator );
	mOwner.SetDivingAttackArea(mTargetCells);

	// don't do anything on simulation, if no one casted this stuff or if the owner
	// is already away
	if(isSimulated || mOwner == none || mOwner.IsOffGrid()) 
	{
		mTargetCells.Length = 0;
		mOwner = none;
		return;
	}

	// clear array in case it contains old target cells
	mTargetCells.Length = 0;

	// get target area
	effect.GetTargets(targets);
	pos = mOwner.GetGridPosition();
	ownerCell = class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetCombatController().GetGridController().GetCombatGrid().GetCellByIntPoint(pos);
	foreach targets(target)
	{
		if(H7Unit(target) != none)
		{
			pos = H7Unit(target).GetGridPosition();
			if(mTargetCells.Find(H7BaseCell(target)) == -1)
				mTargetCells.AddItem( class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetCombatController().GetGridController().GetCombatGrid().GetCellByIntPoint(pos) );
		}
		else if(H7CombatMapCell(target) != none && mTargetCells.Find(H7CombatMapCell(target)) == -1)
		{
			mTargetCells.AddItem( H7CombatMapCell( target ) );
		}
	}

	if(mTargetCells.Find(ownerCell) != -1)
		mTargetCells.RemoveItem(ownerCell);

	// don't do stuff if target area is none
	if(mTargetCells.Length == 0)
	{
		// TODO inform someone about this shit
		;
		return;
	}

	mOwner.SetDivingAttackArea(mTargetCells);

	pos.X = mOwner.GetCreature().GetBaseSize() == CELLSIZE_2x2 ? 2 : 1;
	pos.Y = pos.X;

	rota = Rotator(mTargetCells[0].GetCenterPosByDimensions( pos ) - mOwner.GetCreature().Location);

	if(mLookTowardsTargetArea)
	{
		mOwner.GetCreature().SetRotation(rota);
	}

	OnFaceTargetDone( effect );

	mTargetCells.Length = 0;
	mOwner = none;
}

function OnFaceTargetDone( H7Effect effect )
{
	local Vector forward;

	forward = Vector( mOwner.GetCreature().Rotation ) * mFlyForwardUnits;

	mOwner.DoDivingAttackFlying( mMaxHeight+mOwner.GetLocation().Z, forward.Y, mSpeed, false, true, false, effect );

	// remove from cell and trigger all the events
	mOwner.RemoveCreatureFromCell();
	mOwner.GetCreature().GetAnimControl().PlayAnim(CAN_FLY_OUT);

	// TODO initiative bar -> "disable" dude

}


function String GetDefaultString()
{
	return "";
}

function String GetTooltipReplacement() 
{
	return "Diving Attack";
}

