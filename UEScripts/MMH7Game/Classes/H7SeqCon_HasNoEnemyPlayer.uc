//=============================================================================
// H7SeqCon_HasNoEnemyPlayer
//
// 
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqCon_HasNoEnemyPlayer extends H7SeqCon_Player
	implements(H7IConditionable)
	native;

function protected bool IsConditionFulfilledForPlayer(H7Player player)
{
	local array<H7Player> players;
	local H7Player p;
	
	players = class'H7AdventureController'.static.GetInstance().GetPlayers();
	foreach players (p)
	{
		if ( p.GetPlayerNumber() == PN_NEUTRAL_PLAYER )
		{
			continue;//ignore
		}
		if ( p.GetPlayerNumber() == player.GetPlayerNumber() )
		{
			continue;
		}
		if (p.GetStatus() == PLAYERSTATUS_UNUSED || p.GetStatus() == PLAYERSTATUS_QUIT)
		{
			continue;
		}
		if (!p.IsPlayerHostile(player))
		{
			continue;
		}
		return false;//found a different player that is non-neutral, hostile and playing
	}
	return true;//there is no other hostile player
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

