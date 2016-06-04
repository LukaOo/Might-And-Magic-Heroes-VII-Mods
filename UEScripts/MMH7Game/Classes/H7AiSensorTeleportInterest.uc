//=============================================================================
// H7AiSensorTeleportInterest
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorTeleportInterest extends H7AiSensorBase;

/// overrides ...

function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	local H7AdventureGridManager		gridManager;
	local array<H7AdventureMapCell>     path;
	local array<H7AdventureMapCell>     path_target;
	local H7AdventureMapCell            cell, endCell;
	local array<float>                  pathCosts;
	local float                         step, distance, ratio, distance_target;
	local H7AdventureHero       hero, myHero;
	local H7Unit                unit;
	local H7Teleporter          teleporter,teleporter_target;
	local H7AdventureArmy       army, myArmy, zocArmy;
	local int                   mpPerTurn;
	local float                 myArmyStrength, zocArmyStrength;
	local array<H7VisitableSite> reachableSites;

//	`LOG_AI("Sensor.TeleportInterest");

	gridManager = class'H7AdventureGridManager'.static.GetInstance();

	if( param0.GetPType() == SP_UNIT )
	{
		unit=param0.GetUnit();
		if(unit==None || unit.GetEntityType()!=UNIT_HERO)
		{
			// wrong unit types
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			return class'H7AdventureMapPathfinder'.const.INFINITE;
		}
		hero=H7AdventureHero(unit);
		// get army from hero
		army=unit.GetAdventureArmy();
		if(army==None)
		{
			// bad parameter
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			return class'H7AdventureMapPathfinder'.const.INFINITE;
		}
	}
	else if( param0.GetPType() == SP_ADVENTUREARMY )
	{
		army=param0.GetAdventureArmy();
		if(army==None)
		{
			// bad parameter
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			return class'H7AdventureMapPathfinder'.const.INFINITE;
		}
		hero=army.GetHero();
	}
	else
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		return class'H7AdventureMapPathfinder'.const.INFINITE;
	}
	
	mpPerTurn = hero.GetCurrentMovementPoints();
	if(mpPerTurn <= 0 ) 
	{
		return class'H7AdventureMapPathfinder'.const.INFINITE;
	}

	myHero = army.GetHero();
	myArmy = army;
	reachableSites = army.GetReachableSites();

	myArmyStrength = myArmy.GetStrengthValue( true);

//	`LOG_AI("  Source" @ hero @ "." @ army @ "GP" @ gpStart.X @ "," @ gpStart.Y);

	if( param1.GetPType() == SP_TELEPORTER )
	{
		teleporter=param1.GetTeleporter();
		if(teleporter==None)
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			// bad parameter
			return class'H7AdventureMapPathfinder'.const.INFINITE;
		}
		// check the teleporter link target
		teleporter_target=teleporter.GetTargetTeleporter();
		if(teleporter_target==None)
		{
//			`LOG_AI("  Teleporter has no target.");
			// no link target
			return class'H7AdventureMapPathfinder'.const.INFINITE;
		}
		if(teleporter_target.IsBlockedByArmy( myArmy.GetPlayer() )==true)
		{
//			`LOG_AI("  Teleporter target is blocked by army.");
			return class'H7AdventureMapPathfinder'.const.INFINITE;
		}
		if( teleporter.IsDestroyed()==true)
		{
//			`LOG_AI("  Teleporter is destroyed.");
			return class'H7AdventureMapPathfinder'.const.INFINITE;
		}
		if( teleporter_target.IsDestroyed()==true)
		{
//			`LOG_AI("  Teleporter target is destroyed.");
			return class'H7AdventureMapPathfinder'.const.INFINITE;
		}
		if( reachableSites.Find( teleporter_target ) == INDEX_NONE )
		{
//			`LOG_AI("  Teleporter target is unreachable.");
			return class'H7AdventureMapPathfinder'.const.INFINITE;
		}
		endCell = teleporter_target.GetEntranceCell();
	}
	else
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		// wrong parameter type
		return class'H7AdventureMapPathfinder'.const.INFINITE;
	}
	
	endCell = teleporter.GetEntranceCell();
	

	distance = endCell.mPathfinderData.aiDistance;
	distance_target = teleporter_target.GetEntranceCell().mPathfinderData.aiDistance;
	// if target is closer than source we dismiss value
	if( distance > distance_target )
	{
//				`LOG_AI("  Out (target closer than source)" );
		return class'H7AdventureMapPathfinder'.const.INFINITE;
	}

	// we artificialy lengthen the path based on its base-utility value
	ratio = (distance_target * (2.0f - teleporter.GetAiBaseUtility())) / mpPerTurn;
	return ratio;

	path = gridManager.GetPathfinder().GetPath( myArmy.GetCell(), endCell, myHero.GetPlayer(), myArmy.HasShip(), true );

	if( path.Length != 0 )
	{
		// check if we run into hostile army on the way to the target. If we do and the hostile army's strength is at least half has strong as ours we consider it to be unreachable
		foreach path( cell )
		{
			zocArmy=cell.GetHostileArmy(myHero.GetPlayer());
			if( H7Garrison( cell.GetVisitableSite() ) != none && cell.GetVisitableSite().GetEntranceCell() == cell && H7Garrison( cell.GetVisitableSite() ).GetPlayer().IsPlayerHostile( army.GetPlayer() ) )
			{
				return class'H7AdventureMapPathfinder'.const.INFINITE;
			}
			if(zocArmy!=None && zocArmy!=army)
			{
				zocArmyStrength=zocArmy.GetStrengthValue(true);
				if( myArmyStrength == 0 || (zocArmyStrength*2) > myArmyStrength )
				{
//					`LOG_AI("  Out (passing by hostile army that is to strong)" );
					return class'H7AdventureMapPathfinder'.const.INFINITE;
				}
			}
		}

		distance=0.0f;
		pathCosts=gridManager.GetPathfinder().GetPathCosts(path,myArmy.GetCell());
		foreach pathCosts( step ) distance+=step;

		endCell = teleporter_target.GetEntranceCell();
		path_target = gridManager.GetPathfinder().GetPath( myArmy.GetCell(), endCell, myHero.GetPlayer(), myArmy.HasShip(), true );
		if( path_target.Length != 0 )
		{
			// check if we run into hostile army on the way to the target. If we do and the hostile army's strength is at least half has strong as ours we consider it to be unreachable
			foreach path_target( cell )
			{
				zocArmy=cell.GetHostileArmy(myHero.GetPlayer());
				if( H7Garrison( cell.GetVisitableSite() ) != none && cell.GetVisitableSite().GetEntranceCell() == cell && H7Garrison( cell.GetVisitableSite() ).GetPlayer().IsPlayerHostile( army.GetPlayer() ) )
				{
					return class'H7AdventureMapPathfinder'.const.INFINITE;
				}
				if(zocArmy!=None && zocArmy!=army)
				{
					zocArmyStrength=zocArmy.GetStrengthValue(true);
					if( myArmyStrength == 0 || (zocArmyStrength*2) > myArmyStrength )
					{
//						`LOG_AI("  Out (passing by hostile army that is to strong)" );
						return class'H7AdventureMapPathfinder'.const.INFINITE;
					}
				}
			}

			distance_target=0.0f;
			pathCosts=gridManager.GetPathfinder().GetPathCosts(path,myArmy.GetCell());
			foreach pathCosts( step ) distance_target+=step;

			// if target is closer than source we dismiss value
			if( distance > distance_target )
			{
//				`LOG_AI("  Out (target closer than source)" );
				return class'H7AdventureMapPathfinder'.const.INFINITE;
			}

			// we artificialy lengthen the path based on its base-utility value
			ratio = (distance_target * (2.0f - teleporter.GetAiBaseUtility())) / mpPerTurn;

//			`LOG_AI("  Utility" @ ratio );

			return ratio;
		}
	}

//	`LOG_AI("  Out (not reachable)" );

	return class'H7AdventureMapPathfinder'.const.INFINITE;
}
