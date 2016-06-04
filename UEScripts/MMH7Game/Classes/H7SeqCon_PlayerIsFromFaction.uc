// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.

class H7SeqCon_PlayerIsFromFaction extends H7SeqCon_Player
	implements(H7IConditionable)
	native;

/* The Faction to be checked. */
var(Properties) protected archetype H7Faction mFaction<DisplayName="Faction">;

function protected bool IsConditionFulfilledForPlayer(H7Player thePlayer)
{
	return thePlayer.GetFaction() == mFaction;
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

