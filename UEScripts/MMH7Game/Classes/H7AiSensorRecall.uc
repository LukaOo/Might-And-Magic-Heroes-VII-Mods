//=============================================================================
// H7AiSensorRecall
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorRecall extends H7AiSensorBase;

var protected H7AdventureController mAdventureController;
var protected H7AdventureHero mActiveHero;

function protected H7Town GetClosestTown()
{
	local array<H7Town> allTowns;
	local H7Town closestTown, currentTown;
	local int currentDistance, bestDistance;

	bestDistance = MaxInt;
	
	allTowns = mAdventureController.GetTownList();

	foreach allTowns( currentTown )
	{
		if( IsOnSameGrid( currentTown ) && OwnTown( currentTown ) && HasTownPortal( currentTown ) && IsEntranceFree( currentTown ) )
		{
			currentDistance = GetDistance( currentTown, mActiveHero );
			if( currentDistance < bestDistance && currentDistance > 30 ) //TODO: Find a reasonable distance to recall from
			{
				closestTown = currentTown;
				bestDistance = currentDistance;
			}
		}
	}

	return bestDistance < MaxInt ? closestTown : none;
}

function protected bool IsOnSameGrid( H7Town town )
{
	return ( town.GetEntranceCell().GetGridOwner() == mActiveHero.GetCell().GetGridOwner() ); 
}

function protected bool HasTownPortal( H7Town town )
{
	return town.IsBuildingBuiltByClass(class'H7TownPortal');
}

function protected bool IsEntranceFree( H7Town town )
{
	local bool hasVisitingArmy, isEntranceUnblocked;

	hasVisitingArmy = town.GetVisitingArmy() == none ? true : false;

	isEntranceUnblocked = town.GetEntranceCell().GetArmy() == none ? true : false;

	return (hasVisitingArmy && isEntranceUnblocked);
}

function protected int GetDistance( H7Town town, H7AdventureHero hero )
{
	local int distance;
	local Vector start, destination;

	start = hero.GetTargetLocation();
	destination = town.GetTargetLocation();
	
	// ignore the Z-Location of the object
	start.Z = 0;
	destination.Z = 0;
	
	distance = VSize( start - destination );

	return distance;
}

function protected bool OwnTown( H7Town town )
{
	return mAdventureController.GetPlayerByNumber( town.GetPlayerNumber() ) == mActiveHero.GetPlayer() ? true : false;
}

/// overrides ...

function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	local H7AdventureHero           hero;
	local H7Unit                    unit;
	local H7VisitableSite           site;
	local H7Town                    town;
	local H7HeroAbility             spell;

//	`LOG_AI("Sensor.Recall");

	mAdventureController = class'H7AdventureController'.static.GetInstance();

	if( param0.GetPType() == SP_UNIT )
	{
		unit=param0.GetUnit();
		if(unit==None || unit.GetEntityType()!=UNIT_HERO) return 0.0f;
		hero=H7AdventureHero(unit);
		if(hero==None) return 0.0f;
		mActiveHero=hero;
	}
	if( param1.GetPType() == SP_VISSITE )
	{
		site=param1.GetVisSite();
		if(site==None) return 0.0f;
		town=H7Town(site);
		if(town==None) return 0.0f;
	}

	// look for recall spell and test if hero can teleport to it
	spell=hero.QuerySpellInstantRecall();
	if(spell!=None && spell.CanCast()==true)
	{
		if(GetClosestTown()==town)
		{
			return 1.0f;
		}
	}

	return 0.0f;
}
