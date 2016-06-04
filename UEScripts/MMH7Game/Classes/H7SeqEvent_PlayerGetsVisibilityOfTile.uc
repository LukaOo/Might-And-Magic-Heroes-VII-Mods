/*============================================================================
* H7SeqEvent_PlayerGetsVisibilityOfTile
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/
class H7SeqEvent_PlayerGetsVisibilityOfTile extends H7SeqEvent_PlayerGetsVisibilityOf
	native;

/** Required tile to fire the trigger */
var(Properties) protected H7TileMarker mTargetTile<DisplayName="Required tile">;

function bool DiscoveredSomethingOfInterest(array<H7AdventureMapCell> cells)
{
	local H7AdventureMapCell uncoveredCell;

	if( mTargetTile == none ) { return false; }

	foreach cells( uncoveredCell )
	{
		if(mTargetTile.Contains(uncoveredCell) )
		{
			return true;
		}
	}

	return false;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

