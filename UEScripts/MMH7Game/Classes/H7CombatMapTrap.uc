/*=============================================================================
 * H7CombatMapTrap
 * 
 * Copyright 2013 Limbic Entertainment All Rights Reserved.
 * =============================================================================*/
class H7CombatMapTrap extends H7CombatObstacleObject;

var(Trap) protected bool                    mIsHidden<DisplayName=Is Hidden>;
var(Trap) protected bool                    mDestroyAfterTriggered<DisplayName=Destroy after triggered>;

simulated function bool   IsHidden() { return mIsHidden; }

simulated function TriggerTrap() 
{
	local H7CombatMapCell cell;
	local array<H7CombatMapCell> cells;

	SetHidden( false );

	if( mDestroyAfterTriggered )
	{ 	
		class'H7CombatMapGridController'.static.GetInstance().GetAuraManager().RemoveAurasFromCaster( self );

		cells = GetCells();
		
		foreach cells( cell ) 
		{
			cell.RemoveObstacles();
		}

		Destroy();
	}
}

simulated function H7CombatObstacleObject PlaceObstacle( H7SiegeTownData siegeTownData, Vector spawnLocation )
{
	local H7CombatObstacleObject obstacleToAdd;

	obstacleToAdd = Spawn( class'H7CombatMapTrap', self,, Location, Rotation, self );
	Destroy();
	
	return obstacleToAdd;
}

simulated function Init()
{
	super.Init();

	SetHidden( mIsHidden );
}

