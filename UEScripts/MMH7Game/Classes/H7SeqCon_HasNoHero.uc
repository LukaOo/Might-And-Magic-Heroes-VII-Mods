//=============================================================================
// H7SeqCon_HasNoHero
//
// 
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqCon_HasNoHero extends H7SeqCon_Player
	implements(H7IConditionable)
	native;

/** The player that is checked */
var(Properties) protected array<EPlayerNumber> mTargetPlayers<DisplayName="Target players">;
/** Show remaining Heroes for automatic minimap tracking */
var(Properties) protected bool mTrackHeroes<DisplayName="Track Heroes">;

function protected bool IsConditionFulfilledForPlayer(H7Player player)
{
	local array<H7Player> players;
	local H7Player p;
	local int undefeatedHeroes;

	if (player == none && mTargetPlayers.Length == 0)
	{
		return false;
	}

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
			undefeatedHeroes = p.GetUndefeatedHeroesAmount();
			if ( undefeatedHeroes > 0 )//at least one player has hero
			{
				return false;
			}
		}
		return true;
	}
	else
	{
		undefeatedHeroes = player.GetUndefeatedHeroesAmount();
		return undefeatedHeroes == 0;
	}
}

function array<H7IQuestTarget> GetQuestTargets()
{
	local array<H7IQuestTarget> targets;
	local array<H7Player> playersToTrack;
	local H7Player p;
	local array<H7AdventureArmy> armies;
	local H7AdventureArmy army;

	if(mTrackHeroes)
	{
		playersToTrack = GetPlayersToTrack();

		foreach playersToTrack(p)
		{
			armies = p.GetUndefeatedHeroArmies();
			foreach armies(army)
			{
				if(army != none)
				{
					targets.AddItem(army);
				}
			}
		}
	}

	return targets;
}

// Same as in H7SeqCon_HasNoTown
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

