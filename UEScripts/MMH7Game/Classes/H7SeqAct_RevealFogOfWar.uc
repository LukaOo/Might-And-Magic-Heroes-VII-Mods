class H7SeqAct_RevealFogOfWar extends SequenceAction
	implements(H7IAliasable, H7IActionable)
	native;

/** Radius to reveal (in tiles) */
var(Properties) protected int mRevealRadius<DisplayName="Reveal radius"|ClampMin=1|ClampMax=300>;
/** X coordinate of the reveal center */
var(Properties) protected int mTileX<DisplayName=Target tile X position|ClampMin=0|ClampMax=399>;
/** Y coordinate of the reveal center */
var(Properties) protected int mTileY<DisplayName=Target tile Y position|ClampMin=0|ClampMax=399>;
/** Use the position of the tile marker as target */
var(Properties) protected bool mUseTargetTileMarker<DisplayName=Use tile marker as target>;
/** The tile marker to reveal the fog of war around */
var(Properties) protected H7TileMarker mTargetTileMarker<DisplayName=Target tile marker|EditCondition=mUseTargetTileMarker>;
//TODO: this action belongs to one of "for one/all player action". Refactor after implementing player action
var(Properties) EPlayerNumber mPlayerNumber<DisplayName="Target player"|ToolTip="The player that gets the fog of war revealed">;

event activated()
{
	local Object Target;
	local H7AdventureGridManager gridManager;
	local H7AdventureMapCell cell;
	local H7FOWController fogController;
	local array<IntPoint> visiblePoints;

	gridManager = class'H7AdventureGridManager'.static.GetInstance();
	if (gridManager == None)
	{
		return;
	}

	if(Targets.Length == 0)
	{
		if(mUseTargetTileMarker && mTargetTileMarker != none)
		{
			cell = gridManager.GetCellByWorldLocation(mTargetTileMarker.Location);
		}
		else
		{
			cell = gridManager.GetCell(mTileX, mTileY);
		}
	}
	else
	{
		foreach Targets(Target)
		{
			if (Actor(Target) != None)
			{
				cell = gridManager.GetCellByWorldLocation( Actor(Target).Location );
				break;
			}
		}
	}

	if( cell != none )
	{
		fogController = cell.GetGridOwner().GetFOWController();
		if( fogController != none )
		{
			class'H7Math'.static.GetMidPointCirclePoints( visiblePoints, cell.GetCellPosition(), mRevealRadius );
			fogController.HandleExploredTiles( mPlayerNumber, visiblePoints );
			fogController.ExploreFog();
		}
	}
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

