/*=============================================================================
 * H7SeqAct_MoveTo
 * 
 * Move action that targets a tile.
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ===========================================================================*/

class H7SeqAct_MoveToTile extends H7SeqAct_MoveTo
	native;

/** Target tile X position */
var(Properties) protected int mTileX<DisplayName="Target tile X position"|ClampMin=0|ClampMax=399>;
/** Target tile Y position */
var(Properties) protected int mTileY<DisplayName="Target tile Y position"|ClampMin=0|ClampMax=399>;
/** Target tile grid index */
var(Properties) protected int mTileGridIndex<DisplayName="Target tile grid index (-1 is default grid )"|ClampMin=-1|ClampMax=100>;
/** Use the position of the tile marker as target */
var(Properties) protected bool mUseTargetTileMarker<DisplayName="Use tile marker as target">;
/** The tile marker to move to */
var(Properties) protected H7TileMarker mTargetTileMarker<DisplayName="Target tile marker"|EditCondition=mUseTargetTileMarker>;

function bool IsUsingTileMarker() 
{
	return mUseTargetTileMarker && mTargetTileMarker != none;
}

function H7AdventureMapCell GetTargetCell()
{
	local H7AdventureMapCell target;
	if(IsUsingTileMarker())
	{
		target = class'H7AdventureGridManager'.static.GetInstance().GetCellByWorldLocation( mTargetTileMarker.Location );
	}
	else
	{
		target = class'H7AdventureGridManager'.static.GetInstance().GetCell( mTileX, mTileY, mTileGridIndex );
	}

	return target;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 4;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

