//=============================================================================
// H7SeqCon_DaysPassedWithNoTown
//
// 
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqCon_DaysPassedWithNoTown extends H7SeqCon_Player
	implements(H7IConditionable)
	native;

function protected bool IsConditionFulfilledForPlayer(H7Player player)
{
	local array<H7Town> owningTowns;
	owningTowns = player.GetTowns();
	return owningTowns.Length == 0;
}

function bool HasProgress() { return mUseTimer; }

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

