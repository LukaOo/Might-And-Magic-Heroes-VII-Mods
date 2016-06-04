/*=============================================================================
* H7TownSiloBuilding
* =============================================================================
*  Class for the in-town Silo building. Produces a random resource
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7TownSiloBuilding extends H7TownBuilding
	savegame;

var(Silo) protected array<H7ResourceProbability> mResources<DisplayName=Possible Resources>;

var savegame H7ResourceQuantity currentResource;

function InitTownBuilding( H7Town town )
{
	super.InitTownBuilding(town);
	DetermineResource();
}

function OnBeginDay() 
{
	DetermineResource();
}

function DetermineResource()
{
	local H7ResourceProbability prob;
	local int rand, currentProb;

	currentProb = 0;
	rand = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( 100 );

	foreach mResources( prob )
	{
		currentProb += prob.mProbability;

		if( rand < currentProb )
		{
			currentResource = prob.mResource;
			break;
		}
	}
}

function array<H7ResourceQuantity>  GetIncome()
{
	local array<H7ResourceQuantity> resources;

	resources = super.GetIncome();
	resources.AddItem(currentResource);	
	
	return resources;
}

function bool ShouldDisplayIncome()
{ 
	return false; 
}
