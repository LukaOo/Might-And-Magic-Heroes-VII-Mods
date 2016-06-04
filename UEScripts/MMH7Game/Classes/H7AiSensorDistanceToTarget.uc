//=============================================================================
// H7AiSensorDistanceToTarget
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorDistanceToTarget extends H7AiSensorBase;

var H7AdventureMapCell          mStartCell;
var array<H7AdventureMapCell>   mEndCells;
var array<float>                mDistanceRatios;

function bool CheckCache( H7AdventureMapCell sc, H7AdventureMapCell ec, out float ratio )
{
	local int idx;
	if( mStartCell != sc )
	{
		mStartCell=sc;
		mEndCells.Remove(0,mEndCells.Length);
		mDistanceRatios.Remove(0,mDistanceRatios.Length);
		return false;
	}
	idx=mEndCells.Find(ec);
	if(idx!=-1)
	{
		ratio=mDistanceRatios[idx];
//		`LOG_AI("---D2T:CheckCache("$ec.GetGridPosition().X$","$ec.GetGridPosition().Y$":"$ratio$") @"@mEndCells.Length);
		return true;
	}
	return false;
}

function InsertCache( H7AdventureMapCell ec, float ratio )
{
	mEndCells.AddItem(ec);
	mDistanceRatios.AddItem(ratio);

//	`LOG_AI("---D2T:InsertCache("$ec.GetGridPosition().X$","$ec.GetGridPosition().Y$":"$ratio$") @"@mEndCells.Length);
}

/// overrides ...

function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	local H7AdventureGridManager		gridManager;
	local array<H7AdventureMapCell>     path;
	local H7AdventureMapCell            cell, endCell;
	local array<float>                  pathCosts;
	local float                         step, distance, ratio;
	local H7AdventureHero       hero, myHero;
	local H7Unit                unit;
	local H7AdventureArmy       army, myArmy, zocArmy;
	local H7VisitableSite       site;
	local float                 mpPerTurn; //, mpPerTurnRest;
	local float                 myArmyStrength, zocArmyStrength;
	local array<H7AdventureArmy> reachableArmies;
	local array<H7VisitableSite> reachableSites;
//	local int k;

//	`LOG_AI("Sensor.DistanceToTarget");

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
	
	mpPerTurn = hero.GetMovementPoints();

	myHero = army.GetHero();
	myArmy = army;
	reachableArmies = army.GetReachableArmies();
	reachableSites = army.GetReachableSites();

//	`LOG_AI("reachable sites for army:"@reachableSites.Length);

	myArmyStrength = myArmy.GetStrengthValue(true);

//	`LOG_AI("  Source" @ hero @ "." @ army @ "GP" @ gpStart.X @ "," @ gpStart.Y);

	if( param1.GetPType() == SP_UNIT )
	{
		unit=param1.GetUnit();
		if(unit==None)
		{
			// bad parameter
			return class'H7AdventureMapPathfinder'.const.INFINITE;
		}
		endCell = H7AdventureHero(unit).GetCell();
	}
	else if( param1.GetPType() == SP_ADVENTUREARMY )
	{
		army=param1.GetAdventureArmy();
		site=None;
		if(army==None)
		{
//			`LOG_AI("  Target Army is None. Rejecting");
			// bad parameter
			return class'H7AdventureMapPathfinder'.const.INFINITE;
		}
		hero=army.GetHero();
		
		if( !army.IsGarrisoned() )
		{
			// the army is on the adventure map wandering around
			endCell = army.GetCell();
			// unreachable army (reachability is pre-calculated once)
			if( reachableArmies.Find(army)==INDEX_NONE )
			{

//				`LOG_AI("  Target"@army@"Army is not reachable.");
				return class'H7AdventureMapPathfinder'.const.INFINITE;
			}
		}
		else
		{
//			`LOG_AI("  Target is a Garrison-Army");
			site=army.GetGarrisonedSite();
			if(site!=None)
			{
				endCell = site.GetEntranceCell();
				// unreachable site (reachability is pre-calculated once)
				if( reachableSites.Find(site) == INDEX_NONE )
				{
					return class'H7AdventureMapPathfinder'.const.INFINITE;
				}
//				`LOG_AI("  Rerouting target to site entrance" @ site );
			}
			else
			{
//				`LOG_AI("  Target"@army@"army has no place in this gruel world.");
				return class'H7AdventureMapPathfinder'.const.INFINITE;
			}
		}
	}
	else if( param1.GetPType()==SP_VISSITE )
	{
		site=param1.GetVisSite();
		army=None;
		if(site==None)
		{ 
			// bad parameter
//			`LOG_AI("   Target site unkown.");
			return class'H7AdventureMapPathfinder'.const.INFINITE;
		}
		endCell = site.GetEntranceCell();
		if( endCell.GetArmy()!=none && endCell.GetArmy()!=myArmy )
		{
//			`LOG_AI("   Target"@site@site.GetName()@" entrance is occupied by"@endCell.GetArmy().GetHero().GetName()@", so"@myArmy.GetHero().GetName()@"cannot visit!");
			return class'H7AdventureMapPathfinder'.const.INFINITE;
		}
		else if( reachableSites.Find(site)==INDEX_NONE )
		{
//			`LOG_AI("   Target"@site@site.GetName()@" is unreachable, so"@myArmy.GetHero().GetName()@"cannot visit!");
			return class'H7AdventureMapPathfinder'.const.INFINITE;
		}
	}
	else if( param1.GetPType()==SP_AMAPCELL )
	{
		endCell=param1.GetAMapCell();
		if(endCell==None)
		{
			return class'H7AdventureMapPathfinder'.const.INFINITE;
		}
		// something blocking endcell ?
		if( (endCell.GetArmy()!=none && endCell.GetArmy()!=myArmy) || endCell.IsBlocked()==true )
		{
			return class'H7AdventureMapPathfinder'.const.INFINITE;
		}
	}
	else
	{
		// wrong parameter type
		return class'H7AdventureMapPathfinder'.const.INFINITE;
	}
	
//	`LOG_AI("  Target" @ hero @ "." @ (army!=None?army:site) @ "GP" @ endCell.GetGridPosition().X @ "," @ endCell.GetGridPosition().Y);

	// are we already at the target ? :)
	if( myArmy.GetCell().GetCellPosition().X == endCell.GetCellPosition().X &&
	    myArmy.GetCell().GetCellPosition().Y == endCell.GetCellPosition().Y &&
	    myArmy.GetCell().GetGridOwner() == endCell.GetGridOwner() )
	{
		return 0.0f;
	}

	// check cache for same search and return cached value if so
	if( CheckCache( myArmy.GetCell(), endCell, ratio ) == true )
	{
		return ratio;
	}

	if( endCell.mPathfinderData.aiDistance >= class'H7AdventureMapPathfinder'.const.INFINITE )
	{
		return class'H7AdventureMapPathfinder'.const.INFINITE;
	}
	
	ratio = endCell.mPathfinderData.aiDistance / mpPerTurn;
	InsertCache(endCell,ratio);
	return ratio;

	// real pathfinding (reachability check is done beforehand)..
	path = gridManager.GetPathfinder().GetPath( myArmy.GetCell(), endCell, myHero.GetPlayer(), myArmy.HasShip(), true, false );
	
	
	
	if( path.Length != 0 )
	{
		// check if we run into hostile army on the way to the target. If we do and the hostile army's strength is at least half has strong as ours we consider it to be unreachable
		foreach path( cell )
		{
			zocArmy=cell.GetHostileArmy(myHero.GetPlayer());
			if( cell != endCell )
			{
				if( H7Garrison( cell.GetVisitableSite() ) != none && cell.GetVisitableSite().GetEntranceCell() == cell && H7Garrison( cell.GetVisitableSite() ).GetPlayer().IsPlayerHostile( myArmy.GetPlayer() ) )
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
		}

		distance=0.0f;
		pathCosts=gridManager.GetPathfinder().GetPathCosts(path,myArmy.GetCell());
		foreach pathCosts( step ) distance+=step;

		if(distance<=0.0f) return 0.0f;

//		`LOG_AI("  Out D" @ distance @ "M" @ mpPerTurn @ " (" @ (distance / mpPerTurn) @ ")" );

		
	}

//	`LOG_AI("  Out (not reachable)" );
	return class'H7AdventureMapPathfinder'.const.INFINITE;
}
