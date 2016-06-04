 // Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
class H7SeqCon_HasHeroFromFaction extends H7SeqCon_HasHeroWith
	native;

/* The Faction to be checked. */
var(Properties) protected archetype H7Faction mFaction<DisplayName="Faction">;

function protected bool IsConditionFulfilledForHero(H7AdventureHero currentHero)
{
	return currentHero.GetFaction() == mFaction;
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

