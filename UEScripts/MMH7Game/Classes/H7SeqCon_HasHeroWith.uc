 // Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
class H7SeqCon_HasHeroWith extends H7SeqCon_Player
	implements(H7IHeroReplaceable,H7IConditionable)
	abstract
	native;

/* The hero that is checked. If set to none, it's checked if at least one out of all heroes fulfills the condition. */
var(Properties) protected archetype H7EditorHero mHero<DisplayName="Check specific hero"|EditCondition=!mUseInteractingHero>;
/* Use the hero of the army that triggered this condition. */
var(Properties) protected bool mUseInteractingHero<DisplayName="Use Interacting Hero">;

var protected H7AdventureArmy mHeroArmy;

function protected bool IsConditionFulfilledForPlayer(H7Player thePlayer)
{
	local array<H7AdventureHero> playerHeroes;
	local H7AdventureHero currentHero;
	local H7EditorHero heroToCheckAgainst;

	playerHeroes = thePlayer.GetHeroes();
	heroToCheckAgainst = (mHeroArmy != none && mUseInteractingHero) ? mHeroArmy.GetHeroTemplateSource() : mHero;

	if(mUseInteractingHero && heroToCheckAgainst == none)
	{
		return false;
	}

	foreach playerHeroes(currentHero)
	{
		if((heroToCheckAgainst == none && !mUseInteractingHero) || heroToCheckAgainst == currentHero.GetSourceArchetype())
		{
			if(IsConditionFulfilledForHero(currentHero))
			{
				return true;
			}
		}
	}

	return false;
}

function protected bool IsConditionFulfilledForHero(H7AdventureHero currentHero)
{
	return false;   // Implement in extending classes
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

