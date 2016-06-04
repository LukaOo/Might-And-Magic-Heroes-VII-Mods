/*=============================================================================
 * H7SeqAct_SpawnArmy
 * ============================================================================
 * Kismet action to spawn a new army in the Adventure Map
 * ============================================================================
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================
 */
class H7SeqAct_SpawnArmy extends SequenceAction
	implements(H7IAliasable, H7IActionable, H7IRandomPropertyOwner)
	native
	savegame;

/** The tile marker where the army should be spawned. */
var(Properties) protected H7TileMarker mTargetTileMarker<DisplayName="Target tile marker">;
/** The template of the army to spawn. */
var(Properties) protected archetype H7AdventureArmy mArmyArchetype<DisplayName="Army template">;
/** The player to give the spawned army to. */
var(Properties) protected EPlayerNumber mPlayerNumber<DisplayName="Owning player">;

/** The direction the spawned army should look into. Only available when Look at is set to none. */
var(Rotation) protected EDirection mTargetDirection<DisplayName="Direction"|EditCondition=mUseDirection>;
/** The object the spawned army should look at. */
var(Rotation) protected savegame H7EditorMapObject mTargetObject<DisplayName="Look at">;

var private transient bool mUseDirection;

var Object SpawnedObject;

event Activated()
{
	local Object target;
	local H7AdventureGridManager gridManager;
	local H7AdventureMapCell pointingCell;
	local H7AdventureArmy spawnedArmy;
	local rotator finalRotation;

	if (mArmyArchetype == None)
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
		if(mUseDirection || mTargetObject == none)
		{
			finalRotation.Yaw = class'H7GameUtility'.static.DirectionToOpposingAngle(mTargetDirection);
		}
		else
		{
			finalRotation.Yaw = (rotator(mTargetObject.Location - mTargetTileMarker.Location)).Yaw;
		}

		spawnedArmy = H7AdventurePlayerController(class'H7PlayerController'.static.GetPlayerController()).SpawnArmy(pointingCell, 
			int(mPlayerNumber), finalRotation, mArmyArchetype);

		if(spawnedArmy != none)
		{
			SpawnedObject = spawnedArmy;

			if(class'H7PlayerProfile'.static.GetInstance() != none && class'H7PlayerProfile'.static.GetInstance().GetCampTransManager() != none )
			{
				if( spawnedArmy.GetHero().GetSaveProgress() )
				{
					class'H7PlayerProfile'.static.GetInstance().GetCampTransManager().LoadStoredHero( spawnedArmy.GetHero() );
				}
			}
		}
	}
}

function UpdateRandomProperties(Object randomObject, Object hatchedObject)
{
	if(hatchedObject.IsA('H7EditorMapObject'))
	{
		if(mTargetObject == randomObject)
		{
			mTargetObject = H7EditorMapObject(hatchedObject);
		}
	}
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
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

