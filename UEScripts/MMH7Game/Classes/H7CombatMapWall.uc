/*=============================================================================
 * H7CombatMapWall
 * 
 * Copyright 2013 Limbic Entertainment All Rights Reserved.
 * =============================================================================*/
class H7CombatMapWall extends H7CombatObstacleFracturedObject
	native;

simulated function H7CombatObstacleObject PlaceObstacle( H7SiegeTownData siegeTownData, Vector spawnLocation )
{
	local string archetypePath;
	local H7CombatObstacleObject obstacleToAdd;

	if( siegeTownData.WallAndGateLevel == 0 )
	{
		// we dont have walls
		Destroy();
		return none;
	}

	// we have walls of level 1 or higher
	archetypePath = PathName( siegeTownData.SiegeObstacleWall );
	if( siegeTownData.WallAndGateLevel > 1 )
	{
		archetypePath = archetypePath $ siegeTownData.WallAndGateLevel;
	}
	obstacleToAdd = Spawn( class'H7CombatMapWall', self,, Location, Rotation, H7CombatMapWall( DynamicLoadObject( archetypePath, class'H7CombatMapWall') ) );
	Destroy();
	return obstacleToAdd;
}

simulated function ApplyDamage( H7CombatResult result, int resultIdx, bool isForecast, optional bool isRetaliation = false, optional bool raiseEvent = true )
{
	super.ApplyDamage( result, resultIdx, isForecast, isRetaliation, raiseEvent );

	// on first impact deactivate the FX
	if( !isForecast )
	{
		mFX.SetHidden(true);
	}

	if( GetLevel() == OL_DESTROYED )
	{
		mSpawnedFracturedMeshActor.FracturedStaticMeshComponent.SetTraceBlocking(false, false);
		mSpawnedFracturedMeshActor.SetCollision(false, false, true);
	}
}

