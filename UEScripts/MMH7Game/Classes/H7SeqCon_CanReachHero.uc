/*=============================================================================
 * H7SeqCon_CanReachHero
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * =============================================================================*/

class H7SeqCon_CanReachHero extends H7SeqCon_Player
	implements(H7IHeroReplaceable, H7IConditionable)
	native;

/* The hero that is checked. */
var(Properties) protected archetype H7EditorHero mCheckHero<DisplayName="Hero to be checked">;
/* The army that is checked. */
var(Properties) protected H7AdventureArmy mCheckArmy<DisplayName="Army to be checked">;
/* The hero that should be reached. */
var(Properties) protected archetype H7EditorHero mReachHero<DisplayName="Hero to be reached">;
/* The army that should be reached. */
var(Properties) protected H7AdventureArmy mReachArmy<DisplayName="Army to be reached">;
/* The player whose armies should be reached */
var(Properties) protected EPlayerNumber mReachPlayer<DisplayName="Player to be reached">;
/* Check, if the hero can be reached by movement. */
var(Properties) protected bool mWithinMovementRange<DisplayName="Within movement range">;
/* Maximum amount of tiles needed to reach the other hero. */
var(Properties) protected int mWithinTiles<ClampMin=0 | EditCondition=!mWithinMovementRange | DisplayName="Within amount of tiles">;

var protected H7AdventureArmy mInstigatingArmy;
var protected H7AdventureArmy mReachedArmy;

function protected bool IsConditionFulfilledForPlayer(H7Player thePlayer)
{
	local array<H7AdventureArmy> checkArmies, reachArmies;
	local H7AdventureArmy checkArmy, reachArmy;
	local H7AdventureMapPathfinder pathFinder;
	local array<H7AdventureMapCell> path;
	local int numOfWalkableCells;

	pathFinder = class'H7AdventureGridManager'.static.GetInstance().GetPathfinder();

	if(mCheckHero != none)
	{
		checkArmies = self.GetArmies(thePlayer, mCheckHero);
	}

	if(mCheckArmy != none)
	{
		checkArmies.AddItem(mCheckArmy);
	}

	if(checkArmies.Length == 0)
	{
		// No hero or army specified, we check all from the player
		checkArmies = thePlayer.GetArmies();
	}

	if(mReachHero != none)
	{
		reacharmies = self.GetArmies(thePlayer, mReachHero);
	}

	if(mReachArmy != none)
	{
		reachArmies.AddItem(mReachArmy);
	}

	if(reachArmies.Length == 0 && mReachPlayer != PN_PLAYER_NONE)
	{
		// No hero or army specified, we check all from the player
		reachArmies = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber(mReachPlayer).GetArmies();
	}

	foreach checkArmies(checkArmy)
	{
		foreach reachArmies(reachArmy)
		{
			path = pathFinder.GetPath(checkArmy.GetCell(), reachArmy.GetCell(), thePlayer, checkArmy.HasShip());
			if(path.Length > 0)
			{
				pathFinder.GetPathCosts(path, checkArmy.GetCell(), checkArmy.GetHero().GetCurrentMovementPoints(), numOfWalkableCells);
				if(numOfWalkableCells >= path.Length)
				{
					if(mWithinMovementRange || mWithinTiles >= numOfWalkableCells)
					{
						mInstigatingArmy = checkArmy;
						mReachedArmy = reachArmy;
						return true;
					}
				}
			}
		}
	}

	return false;
}

function array<H7AdventureArmy> GetArmies(H7Player thePlayer, H7EditorHero theHero)
{
	local array<H7AdventureArmy> playerArmies;
	local H7AdventureArmy playerArmy;
	local array<H7AdventureArmy> heroArmies;

	playerArmies = thePlayer.GetArmies();

	foreach playerArmies(playerArmy)
	{
		if(playerArmy.GetHeroTemplateSource() == theHero)
		{
			heroArmies.AddItem(playerArmy);
		}
	}

	return heroArmies;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 4;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

