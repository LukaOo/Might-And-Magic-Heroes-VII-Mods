//=============================================================================
// H7EffectSpecialTeleport
//
// 
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7EffectSpecialTeleport extends Object 
	implements(H7IEffectDelegate)
	hidecategories( Object )
	native(Tussi);

var(Teleport) protected int mRange<DisplayName=Range of Teleport>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7CreatureStack stackToTeleport;
	local H7CombatMapCell teleportDestinationCell;
	local H7IEffectTargetable tmpTarget, target;
	local H7IEventManagingObject tmpEventObject;
	local array<H7IEffectTargetable> targets;
	local H7FXStruct fxStr;
	local bool canPlaceCreature;
	local int cDim;
	local IntPoint cellPos;

	if( isSimulated ) { return; }

	effect.GetTargets( targets );
	foreach targets( target )
	{
		tmpTarget = target;
	}
	tmpEventObject = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( class'H7ReplicationInfo'.static.GetInstance().GetTeleportTargetID() );
	teleportDestinationCell = H7CombatMapCell( tmpTarget );

	if(teleportDestinationCell == none) return;
	
	stackToTeleport = H7CreatureStack( tmpEventObject );

	if( stackToTeleport == none ) return;

	canPlaceCreature = class'H7CombatMapGridController'.static.GetInstance().CanPlaceCreature( teleportDestinationCell.GetGridPosition(), stackToTeleport );

	cellPos = teleportDestinationCell.GetGridPosition();
	if( cellPos.X < 2 || cellPos.X > class'H7CombatMapGridController'.static.GetInstance().GetGridSizeX() || // don't consider warunit/hero columns as "on grid"
		cellPos.Y < 0 || cellPos.Y > class'H7CombatMapGridController'.static.GetInstance().GetGridSizeY() )
	{
		canPlaceCreature = false;
	}

	// can't teleport on this shit? fuck you, player
	if( !canPlaceCreature )
	{
		cDim = stackToTeleport.GetCreature().GetBaseSize() == CELLSIZE_2x2 ? 2 : 1;
		class'H7FCTController'.static.GetInstance().startFCT(FCT_ERROR, teleportDestinationCell.GetCenterByCreatureDim( cDim ), effect.GetSource().GetInitiator().GetPlayer(),  class'H7Loca'.static.LocalizeSave("FCT_NO_VALID_TARGET","H7FCT"));
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("INVALID_SELECT");
		return;
	}

	fxStr = effect.GetFx();
	fxStr.mFXPosition = FXP_HIT_POSITION;
	class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetCombatController().GetGridController().GetEffectManager().AddToFXQueue( fxStr, effect, false,, stackToTeleport.GetCell().GetPosition1x1() );

	stackToTeleport.RemoveCreatureFromCell();
	class'H7CombatMapGridController'.static.GetInstance().PlaceCreature( teleportDestinationCell.GetCellPosition(), stackToTeleport );
	stackToTeleport.SetIsBeingTeleported(false);
	stackToTeleport.GetPathfinder().ForceUpdate();
	class'H7CombatController'.static.GetInstance().RefreshAllUnits();
	class'H7CombatMapGridController'.static.GetInstance().RecalculateReachableCells();
	
	class'H7ReplicationInfo'.static.GetInstance().SetTeleportTargetID( -1 );
}

function int GetRange()
{
	return mRange;
}

function string GetDefaultString()
{
	return string(mRange);
}

function String GetTooltipReplacement() 
{ 
	return class'H7Loca'.static.LocalizeSave("TTR_FLANK","H7TooltipReplacement"); 
}

