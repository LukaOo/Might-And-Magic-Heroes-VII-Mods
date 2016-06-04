//=============================================================================
// H7AdventureMapPathPreviewer
//
// Helper for visualization of hero movement path on adventure map cells.
// 
// // Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AdventureMapPathPreviewer extends H7BasePathPreviewer;

const WAYPOINT_ICON_WIDTH = 192;
const WAYPOINT_ICON_HEIGHT = 192;
const TURN_ICON_WIDTH = 72;
const TURN_ICON_HEIGHT = 72;
const PATH_ICON_WIDTH = 68;
const PATH_ICON_HEIGHT = 68;

const SPOT_MATERIAL_NAME = "FX_Units.Adventure.M_PathSpot";
const TARGET_MATERIAL_NAME = "FX_Units.Adventure.M_PathTarget";
const WAYPOINT_MATERIAL_NAME = "FX_Units.Adventure.M_PathWaypoint";
const TURN_MATERIAL_NAME = "FX_Units.Adventure.M_PathWaypointTurn";
const TURN_TEXTURE_NAME = "FX_Units.Adventure.T_PathWaypointTurn";
const HOVER_MATERIAL_NAME = "FX_Units.Adventure.M_Hover";

var protected H7PathDot mHoverDot;

/**
 * Spawns H7PathDots which represent a walkable path on the adventure map.
 * A "dot" can represent a reachable cell (green), unreachable cell (grey),
 * target (end of path) and waypoint
 * 
 * @param       path                Array of adventure map cells
 * @param       numOfWalkableCells  How many cells the stack can traverse in the current turn
 * @param       currentMovePoints   Movement points a stack can traverse during 1 full turn
 * @param       maxMovePoints       Maxiumum movement points of a stack
 * @param       pathCosts           The individual movement costs for each cell in the path
 */
function ShowPreview( array<H7AdventureMapCell> path, int numOfWalkableCells, int currentMovePoints, int maxMovePoints, array<float> pathCosts, optional int conflictCellIndex = -1 )
{
	local LinearColor green, grey, red, dotColor;
	local Vector turnCounterOffset, spawnPos, spawnOffset;
	local int waypointCounter, maxWaypoints;
	local int pathCostIdx;
	local float remainingPathCost, cost, currentCost, totalCost;

	pathCostIdx = 0;
	waypointCounter = 1;
	maxWaypoints = 9;
	grey = MakeLinearColor( 0.75, 0.75, 0.75, 0 );
	green = MakeLinearColor( 0.25, 1.0, 0, 0 );
	red = MakeLinearColor( 0.75, 0, 0, 0 );
	turnCounterOffset.X = 0;
	turnCounterOffset.Y = 0;
	HidePreview();
	remainingPathCost = maxMovePoints;
	dotColor = green;
	foreach pathCosts( cost, pathCostIdx )
	{
		if( pathCostIdx == conflictCellIndex )
		{
			dotColor = red;
		}
		;
		totalCost += cost;
		spawnOffset.Z = DECAL_OFFSET;
		spawnPos = path[pathCostIdx].GetLocation() + spawnOffset; // offset it up so it doesn't clip the ground
		// Draw the walkable path first
		if( pathCostIdx < numOfWalkableCells )
		{
			currentCost += cost;
			// Every marker except for the last walkable cell will be a dot
			if( pathCostIdx != numOfWalkableCells - 1 )
			{
				MakeDotAt( SPOT_MATERIAL_NAME, dotColor, spawnPos, path[pathCostIdx].GetRotation(),,,,, path[pathCostIdx].mMovementType == MOVTYPE_WATER );
			}
			else
			{
				// If the path is longer than the cells we can walk in this turn, draw a waypoint marker
				if( path.Length > numOfWalkableCells )
				{
					MakeDotAt( WAYPOINT_MATERIAL_NAME, dotColor, spawnPos, path[pathCostIdx].GetRotation(), WAYPOINT_ICON_WIDTH, WAYPOINT_ICON_HEIGHT,,, path[pathCostIdx].mMovementType == MOVTYPE_WATER  );
					MakeDotAt( TURN_MATERIAL_NAME, dotColor, spawnPos + turnCounterOffset, path[pathCostIdx].GetRotation(), TURN_ICON_WIDTH, TURN_ICON_HEIGHT, TURN_TEXTURE_NAME $ waypointCounter, true, path[pathCostIdx].mMovementType == MOVTYPE_WATER );
					waypointCounter++;
				}
				// Otherwise, draw target marker
				else
				{
					MakeDotAt( TARGET_MATERIAL_NAME, dotColor, spawnPos, path[pathCostIdx].GetRotation(), WAYPOINT_ICON_WIDTH, WAYPOINT_ICON_HEIGHT,,,path[pathCostIdx].mMovementType == MOVTYPE_WATER );
				}
			}
		}
		// Now, if necessary, draw the path that can't be reached in a single turn
		else
		{
			// Subtract the tile's cost from the remaining movepoints pool
			remainingPathCost -= cost;
			if( pathCostIdx == path.Length - 1 )
			{
				// Finally, we are at the end, draw target marker
				MakeDotAt( TARGET_MATERIAL_NAME, grey, spawnPos, path[pathCostIdx].GetRotation(), WAYPOINT_ICON_WIDTH, WAYPOINT_ICON_HEIGHT,,, path[pathCostIdx].mMovementType == MOVTYPE_WATER );
			}
			else if( remainingPathCost >= cost )
			{
				// While we still have movepoints for a turn, draw a dot
				MakeDotAt( SPOT_MATERIAL_NAME, grey, spawnPos, path[pathCostIdx].GetRotation(),,,,, path[pathCostIdx].mMovementType == MOVTYPE_WATER );
			}
			else
			{
				// It's gonna take yet another turn to get there... draw waypoint marker 
				// Add another turn's worth of move points to remaining path cost
				remainingPathCost = maxMovePoints;
				// Draw the waypoint
				MakeDotAt( WAYPOINT_MATERIAL_NAME, grey, spawnPos, path[pathCostIdx].GetRotation(), WAYPOINT_ICON_WIDTH, WAYPOINT_ICON_HEIGHT,,, path[pathCostIdx].mMovementType == MOVTYPE_WATER );
				// Draw how many turns it's going to take to go where we want
				if( waypointCounter <= maxWaypoints )
				{
					MakeDotAt( TURN_MATERIAL_NAME, grey, spawnPos + turnCounterOffset, path[pathCostIdx].GetRotation(), TURN_ICON_WIDTH, TURN_ICON_HEIGHT, TURN_TEXTURE_NAME $ waypointCounter, true, path[pathCostIdx].mMovementType == MOVTYPE_WATER );
				}
				else
				{
					MakeDotAt( TURN_MATERIAL_NAME, grey, spawnPos + turnCounterOffset, path[pathCostIdx].GetRotation(), TURN_ICON_WIDTH, TURN_ICON_HEIGHT, TURN_TEXTURE_NAME $ "More", true, path[pathCostIdx].mMovementType == MOVTYPE_WATER );
				}
				waypointCounter++;
			}
		}
	}
	currentCost = currentCost;
	totalCost = totalCost;
	;

	if(currentCost > 0)
	{
		class'H7PlayerController'.static.GetPlayerController().GetHud().TriggerKismetNodePathSet();
	}

}

/**
 * Spawns a H7PathDot with custom material, color, location and rotation,
 * and adds it to the list of spawned dots so they can later be removed.
 * Can optionally provide custom dimensions and texture (for turn numbers).
 * 
 * @param       materialName                Material to use for dot
 * @param       col                         Color to use for dot material
 * @param       loc                         Location of dot
 * @param       rot                         Rotation of dot
 * @param       width                       Width of dot
 * @param       height                      Height of dot
 * @param       textureName                 Turn number texture name as String
 * 
 */
function MakeDotAt( String materialName, LinearColor col, Vector loc, Rotator rot, 
					optional int width = PATH_ICON_WIDTH, optional int height = PATH_ICON_HEIGHT, optional String textureName = "", optional bool lookAtView, optional bool isWater )
{
	
	local H7PathDot dot;

	if( mUnusedDots.Length > 0 )
	{
		dot = mUnusedDots[0];

		InitDot( dot, materialName, col, loc, rot, width, height, textureName, lookAtView, isWater );
		mUsedDots.AddItem( dot );
		mUnusedDots.RemoveItem( dot );
	}
	else
	{
		dot = Spawn( class'H7PathDot', self, , loc, rot );

		InitDot( dot, materialName, col, loc, rot, width, height, textureName, lookAtView, isWater );
		mUsedDots.AddItem( dot );
	}
}

/**
 * Initialises a path dot with necessary data for showing to the player.
 * 
 */
function InitDot( H7PathDot dot, String materialName, LinearColor col, Vector loc, Rotator rot, 
					optional int width = PATH_ICON_WIDTH, optional int height = PATH_ICON_HEIGHT, optional String textureName = "", optional bool lookAtView, optional bool isWater )
{
	local MaterialInstance matInst;	

	matInst = new(None) Class'MaterialInstanceConstant';
	matInst.SetParent( MaterialInterface( DynamicLoadObject( materialName, class'MaterialInterface' ) ) );
	if( Len(textureName) != 0 )
	{
		matInst.SetTextureParameterValue( 'Number', Texture2D( DynamicLoadObject( textureName, class'Texture2D', false ) ) );
		
	}
	matInst.SetVectorParameterValue( 'Color', col );
	dot.SetIsWater( isWater );
	dot.SetMaterial( matInst );
	dot.SetDimensions( width, height );
	dot.SetLocation( loc );
	dot.SetRotation( rot );
	dot.SetHidden( false );
	dot.mLookAtView = lookAtView;
}

/**
 * For testing the AoC borders. Spawns & returns a H7PathDot.
 * 
 * @param       materialName                Material to use for dot
 * @param       col                         Color to use for dot material
 * @param       loc                         Location of dot
 * @param       rot                         Rotation of dot
 * @param       width                       Width of dot
 * @param       height                      Height of dot
 * @param       textureName                 Turn number texture name as String
 * 
 */
function H7PathDot SpawnDotAt( String materialName, LinearColor col, Vector loc, Rotator rot, 
					optional int width = PATH_ICON_WIDTH, optional int height = PATH_ICON_HEIGHT, optional String textureName = "" )
{
	local MaterialInstance matInst;	
	local H7PathDot dot;

	dot = Spawn( class'H7PathDot', self, , loc, rot );
	matInst = new(None) Class'MaterialInstanceConstant';
	matInst.SetParent( MaterialInterface( DynamicLoadObject( materialName, class'MaterialInterface' ) ) );
	if( Len(textureName) != 0 )
	{
		matInst.SetTextureParameterValue( 'Number', Texture2D( DynamicLoadObject( textureName, class'Texture2D', false ) ) );
	}
	matInst.SetVectorParameterValue( 'Color', col );
	dot.SetMaterial( matInst );
	dot.SetDimensions( width, height );
	
	return dot;
}

/**
 * Updates the preview for a walking hero, the cell on which the hero steps will get the decal hidden.
 * 
 */
function UpdatePreview()
{
	local H7PathDot dot;

	if (mUsedDots.Length > 0)
	{
		dot = mUsedDots[0];
		if (dot != None)
		{
			dot.SetHidden( true );
			mUsedDots.RemoveItem( dot );
			mUnusedDots.AddItem( dot );
		}
	}
}




function SetHoverDot(H7AdventureMapCell cell,ECurrentArmyAction action)
{
	local LinearColor hoverColor;
	local Vector spawnPos, spawnOffset;
	local H7AdventureMapPathPreviewer pathprever;

	if( cell == none ) return;
	if(!class'H7OptionsManager'.static.GetInstance().GetSettingBool("OPT_PATH_HOVER_DECAL")) return;

	pathprever = class'H7AdventureGridManager'.static.GetInstance().GetPathPreviewer();

	if(action == CAA_NOTHING)
	{
		hoverColor = MakeLinearColor( 1.0, 0.25, 0, 0 );
	}
	else
	{
		hoverColor = MakeLinearColor( 0.25, 1.0, 0, 0 );
	}
	spawnOffset.Z = pathprever.DECAL_OFFSET;
	spawnPos = cell.GetLocation() + spawnOffset; // offset it up so it doesn't clip the ground
	
	//MakeDotAt(pathprever.SPOT_MATERIAL_NAME,green,spawnPos,cell.GetRotation());

	if(mHoverDot == none)
	{
		mHoverDot = Spawn( class'H7PathDot', self, , spawnPos, cell.GetRotation() );
	}

	InitDot( mHoverDot, pathprever.HOVER_MATERIAL_NAME, hoverColor, spawnPos, cell.GetRotation() , WAYPOINT_ICON_WIDTH , WAYPOINT_ICON_HEIGHT,,, cell.mMovementType == MOVTYPE_WATER );
	
}

function RemoveHoverDot()
{
	if(mHoverDot != none)
	{
		mHoverDot.SetHidden( true );
	}
}

function bool IsHoverDotInactive()
{
	if( mHoverDot != none )
	{
		return mHoverDot.bHidden;
	}
	else
	{
		return true;
	}
}
