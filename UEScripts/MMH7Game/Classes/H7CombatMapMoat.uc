/*=============================================================================
 * H7CombatMapMoat
 * 
 * Copyright 2013 Limbic Entertainment All Rights Reserved.
 * =============================================================================*/
class H7CombatMapMoat extends H7CombatObstacleObject
	native;


native function  H7Player GetPlayer();


simulated function H7CombatObstacleObject PlaceObstacle( H7SiegeTownData siegeTownData, Vector spawnLocation )
{
	local H7CombatObstacleObject obstacleToAdd;

	if( !siegeTownData.HasMoats )
	{
		// we dont have a moat
		Destroy();
		return none;
	}

	obstacleToAdd = Spawn( class'H7CombatMapMoat', self,, Location, Rotation, siegeTownData.SiegeObstacleMoat );
	obstacleToAdd.SetAbilities( mAbilities );
	Destroy();

	return obstacleToAdd;
}

