//=============================================================================
// H7SeqCon_HasNoTown
//
// 
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqCon_HasNoTown extends H7SeqCon_Player
	implements(H7IConditionable)
	native;

/** The player that is checked */
var(Properties) array<EPlayerNumber> mTargetPlayers<DisplayName="Target players">;
/** Show remaining Towns for automatic minimap tracking */
var(Properties) protected bool mTrackTowns<DisplayName="Track Towns">;

function protected bool IsConditionFulfilledForPlayer(H7Player player)
{
	local array<H7Player> players;
	local H7Player p;
	local array<H7Town> towns;

	if ( mTargetPlayers.Length > 0 )//targeting player groups
	{
		players = class'H7AdventureController'.static.GetInstance().GetPlayers();
		foreach players(p)
		{
			if ( p == none )
			{
				continue;
			}
			if ( mTargetPlayers.Find(p.GetPlayerNumber()) == INDEX_NONE )
			{
				continue;
			}
			towns = p.GetTowns();
			if ( towns.Length > 0 )//at least one player has town
			{
				return false;
			}
		}
		return true;
	}
	else
	{
		towns = player.GetTowns();
		return towns.Length == 0;
	}
}

function array<H7IQuestTarget> GetQuestTargets()
{
	local array<H7IQuestTarget> targets;
	local array<H7Player> playersToTrack;
	local H7Player p;
	local array<H7Town> towns;
	local H7Town town;

	if(mTrackTowns)
	{
		playersToTrack = GetPlayersToTrack();

		foreach playersToTrack(p)
		{
			towns = p.GetTowns();
			foreach towns(town)
			{
				if(town != none)
				{
					targets.AddItem(town);
				}
			}
		}
	}

	return targets;
}

// Same as in H7SeqCon_HasNoHero
function protected array<H7Player> GetPlayersToTrack()
{
	local array<H7Player> playersToTrack;
	local array<H7Player> allPlayers;
	local H7Player p;

	playersToTrack = GetPlayers();

	allPlayers = class'H7AdventureController'.static.GetInstance().GetPlayers();
	foreach allPlayers(p)
	{
		if(p != none && playersToTrack.Find(p) == -1 && mTargetPlayers.Find(p.GetPlayerNumber()) != -1)
		{
			playersToTrack.AddItem(p);
		}
	}

	return playersToTrack;
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

