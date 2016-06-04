class H7SeqAct_SpawnAdventureObject extends SequenceAction
	implements(H7IAliasable)
	native;

/** The tile marker where the object should be spawned. */
var(Properties) protected H7TileMarker mTargetTileMarker<DisplayName="Target tile marker">;
/** The template of the object to spawn */
var(Properties) archetype H7AdventureObject mArchetype<DisplayName="Template">;

var Object SpawnedObject;

event Activated()
{
	local Object target;
	local H7AdventureGridManager gridManager;
	local H7AdventureMapCell pointingCell;
	local H7AdventurePlayerController playerControl;

	if (mArchetype == None)
	{
		return;
	}

	gridManager = class'H7AdventureGridManager'.static.GetInstance();
	if (gridManager == None)
	{
		return;
	}

	if(mTargetTileMarker == none)
	{
		foreach Targets(target)
		{
			if (Actor(target) != None)
			{
				pointingCell = gridManager.GetCellByWorldLocation( Actor(target).Location );
				if( pointingCell != none && !pointingCell.IsBlocked())
				{
					break;
				}
			}
		}
	}
	else
	{
		pointingCell = gridManager.GetCellByWorldLocation( mTargetTileMarker.Location );
	}

	if( pointingCell != none && !pointingCell.IsBlocked() )
	{
		playerControl = H7AdventurePlayerController(class'H7PlayerController'.static.GetPlayerController());
		SpawnedObject = playerControl.SpawnAdventureObject(pointingCell.GetCellPosition().X, pointingCell.GetCellPosition().Y, mArchetype);
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

