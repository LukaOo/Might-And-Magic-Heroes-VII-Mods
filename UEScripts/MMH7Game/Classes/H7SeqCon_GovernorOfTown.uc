//=============================================================================
// H7SeqCon_GovernorOfTown
// checks if one/any hero is governour of one/any town
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqCon_GovernorOfTown extends H7SeqCon_Player
	implements(H7IRandomPropertyOwner, H7IConditionable)
	native
	savegame;

/** The town that is checked */
var(Properties) protected savegame H7Town mSite<DisplayName=Town>;
/** The required army to govern the town */
var(Properties) protected H7AdventureArmy mGovernor<DisplayName="Governor Army">;

function protected bool IsConditionFulfilledForPlayer(H7Player player)
{
	local H7Town town;
	local array<H7Town> towns;

	if(mSite != none)
	{
		if(mSite.GetPlayerNumber() != player.GetPlayerNumber())
		{
			return false;
		}

		if(mGovernor != none && mGovernor.GetHero() != none)
		{
			// check if the hero is governor of this town
			return mSite.GetGovernor() == mGovernor.GetHero();
		}
		else
		{
			// check if this town has any governor
			return mSite.GetGovernor() != none;
		}
	}
	else
	{
		towns = class'H7AdventureController'.static.GetInstance().GetTownList();

		foreach towns(town)
		{
			if(town.GetPlayerNumber() != player.GetPlayerNumber())
			{
				continue;
			}

			if(mGovernor != none && mGovernor.GetHero() != none)
			{
				// check if the hero is governor of any town
				if(town.GetGovernor() == mGovernor.GetHero())
				{
					return true;
				}
			}
			else
			{
				// check if any town has any governor
				if(town.GetGovernor() != none)
				{
					return true;
				}
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
	return Super.GetObjClassVersion() + 2;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

