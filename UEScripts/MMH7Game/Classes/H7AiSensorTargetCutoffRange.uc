//=============================================================================
// H7AiSensorTargetCutoffRange
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorTargetCutoffRange extends H7AiSensorBase;

var H7AdventureMapCell          mStartCell;
var array<H7AdventureMapCell>   mEndCells;
var array<float>                mDistances;

function bool CheckCache( H7AdventureMapCell sc, H7AdventureMapCell ec, out float dist )
{
	local int idx;
	if( mStartCell != sc )
	{
		mStartCell=sc;
		mEndCells.Remove(0,mEndCells.Length);
		mDistances.Remove(0,mDistances.Length);
		return false;
	}
	idx=mEndCells.Find(ec);
	if(idx!=-1)
	{
		dist=mDistances[idx];
		return true;
	}
	return false;
}

function InsertCache( H7AdventureMapCell ec, float dist )
{
	mEndCells.AddItem(ec);
	mDistances.AddItem(dist);
}

/// overrides ...

function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	local H7AdventureMapCell        endCell;
	local float                     dist;
	local H7Unit                    unit;
	local H7AdventureArmy           army, myArmy;
	local H7VisitableSite           site;
	local array<H7AdventureArmy>    reachableArmies;
	local array<H7VisitableSite>    reachableSites;

//	`LOG_AI("Sensor.TargetCutoffRange");

	if( param0.GetPType() == SP_UNIT )
	{
		unit=param0.GetUnit();
		if(unit==None || unit.GetEntityType()!=UNIT_HERO)
		{
			// wrong unit types
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			return class'H7AdventureMapPathfinder'.const.INFINITE;
		}
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
	}
	else
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		return class'H7AdventureMapPathfinder'.const.INFINITE;
	}
	
	myArmy = army;
	reachableArmies = army.GetReachableArmies();
	reachableSites = army.GetReachableSites();

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
		if(army==None) return class'H7AdventureMapPathfinder'.const.INFINITE;
		if( !army.IsGarrisoned() )
		{
			// the army is on the adventure map wandering around
			endCell = army.GetCell();
			// unreachable army (reachability is pre-calculated once)
			if( reachableArmies.Find(army)==INDEX_NONE )
			{
				return class'H7AdventureMapPathfinder'.const.INFINITE;
			}
		}
		else
		{
			site=army.GetGarrisonedSite();
			if(site!=None)
			{
				endCell = site.GetEntranceCell();
				// unreachable site (reachability is pre-calculated once)
				if( reachableSites.Find(site) == INDEX_NONE )
				{
					return class'H7AdventureMapPathfinder'.const.INFINITE;
				}
			}
			else
			{
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
			return class'H7AdventureMapPathfinder'.const.INFINITE;
		}
		endCell = site.GetEntranceCell();
		if( endCell.GetArmy()!=none && endCell.GetArmy()!=myArmy )
		{
			return class'H7AdventureMapPathfinder'.const.INFINITE;
		}
		else if( reachableSites.Find(site)==INDEX_NONE )
		{
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
		return class'H7AdventureMapPathfinder'.const.INFINITE;
	}
	
	// are we already at the target ? :)
	if( myArmy.GetCell().GetCellPosition().X == endCell.GetCellPosition().X &&
	    myArmy.GetCell().GetCellPosition().Y == endCell.GetCellPosition().Y )
	{
		return 0.0f;
	}

	// check cache for same search and return cached value if so
	if( CheckCache( myArmy.GetCell(), endCell, dist ) == true )
	{
		return dist;
	}

	if( endCell.mPathfinderData.aiDistance >= class'H7AdventureMapPathfinder'.const.INFINITE )
	{
		return class'H7AdventureMapPathfinder'.const.INFINITE;
	}
	
	dist = endCell.mPathfinderData.aiDistance;
	InsertCache(endCell,dist);
	return dist;
}
