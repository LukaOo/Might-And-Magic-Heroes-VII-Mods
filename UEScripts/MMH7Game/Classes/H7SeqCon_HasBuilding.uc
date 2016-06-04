//=============================================================================
// H7SeqCon_HasBuilding
// checks if one/any town has the specified building build
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqCon_HasBuilding extends H7SeqCon_Player
	implements(H7IRandomPropertyOwner, H7IConditionable)
	native
	savegame;

/* The town that is checked */
var(Properties) protected savegame H7Town mSite<DisplayName=Town>;
/* The required type of building */
var(Properties) protected archetype H7TownBuilding mBuilding<DisplayName=Building>;

function protected bool IsConditionFulfilledForPlayer(H7Player player)
{
	local H7Town town;
	local array<H7Town> towns;

	if(mSite != none)
	{
		return mSite.GetPlayerNumber() == player.GetPlayerNumber() && mSite.IsBuildingBuilt(mBuilding);
	}
	else
	{
		towns = class'H7AdventureController'.static.GetInstance().GetTownList();

		foreach towns(town)
		{
			if(town.GetPlayerNumber() == player.GetPlayerNumber() && town.IsBuildingBuilt(mBuilding))
			{
				return true;
			}
		}
	}

	return false;
}

function UpdateRandomProperties(Object randomObject, Object hatchedObject)
{
	if(hatchedObject.IsA('H7Town'))
	{
		if(mSite == randomObject)
		{
			mSite = H7Town(hatchedObject);
		}
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

