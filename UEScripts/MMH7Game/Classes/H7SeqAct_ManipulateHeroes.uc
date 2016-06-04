/*=============================================================================
 * Base class for actions that target one/all/allfriendly/allenemy/interacting hero of one/all player in one/all area
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 *===========================================================================*/

class H7SeqAct_ManipulateHeroes extends SequenceAction
	implements(H7IAliasable, H7IActionable)
	abstract
	native;

/** Use the army that triggered this action */
var(Properties) protected bool mUseInteractingArmy<DisplayName="Use interacting army">;
/** Use a specific army */
var(Properties) protected H7AdventureArmy mTargetArmy<DisplayName="Target army"|EditCondition=!mUseInteractingArmy>;
/** Restriction to area */
var(Properties) protected H7Area mTargetArea<DisplayName="In target area">;
/** Affected players */
var(Properties) protected EPlayerTargetType mPlayerTargetType<DisplayName="Of Players">;
/** Affect specific player */
var(Properties) protected EPlayerNumber mTargetPlayer<DisplayName="Target player"|EditCondition=mUseTargetPlayer>;

var array<Object> mInteractingHeroObjects;
var private editconst transient bool mUseTargetPlayer;

function array<H7AdventureArmy> GetTargetArmies() 
{
	local array<H7AdventureArmy> armies;
	local array<H7AdventureArmy> tempArmies;
	local H7AdventureArmy tempArmy;
	local H7AdventureArmy interactingHero;
	local int i;

	if(mUseInteractingArmy && mInteractingHeroObjects.Length > 0)
	{
		interactingHero = H7AdventureArmy(mInteractingHeroObjects[0]);
	}

	if(interactingHero != none)
	{
		armies.AddItem(interactingHero);
	}
	else if(mTargetArmy != none)
	{
		armies.AddItem(mTargetArmy);
	}
	else
	{
		tempArmies = class'H7AdventureController'.static.GetInstance().GetArmies();

		foreach tempArmies(tempArmy)
		{
			if(tempArmy != none && mTargetArea == none || mTargetArea.IsInside(tempArmy.Location))
			{
				armies.AddItem(tempArmy);
			}
		}
	}

	// check player restriction
	if(mPlayerTargetType == PLAYER_TYPE_ONE)
	{
		for(i = armies.Length -1; i >= 0; i--)
		{
			if(armies[i].GetPlayerNumber() != mTargetPlayer)
			{
				armies.Remove(i, 1);
			}
		}
	}
	// TODO: PLAYER_TYPE_ALL_ENEMIES & PLAYER_TYPE_ALL_ALLIES once we have an ally system

	return armies;
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
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

