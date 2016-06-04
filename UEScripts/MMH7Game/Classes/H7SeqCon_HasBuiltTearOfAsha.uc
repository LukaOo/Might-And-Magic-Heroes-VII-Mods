//=============================================================================
// H7SeqCon_HasBuiltTearOfAsha
// checks if player has built tear of asha in any town
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqCon_HasBuiltTearOfAsha extends H7SeqCon_Player
	implements(H7IConditionable)
	native;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

function protected bool IsConditionFulfilledForPlayer(H7Player player)
{
	local H7Town town;
	local array<H7Town> towns;

	towns = class'H7AdventureController'.static.GetInstance().GetTownList();

	foreach towns(town)
	{
		if(town.GetPlayerNumber() == player.GetPlayerNumber() && town.IsBuildingBuiltByClass(class'H7TownTearOfAsha'))
		{
			return true;
		}
	}

	return false;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

