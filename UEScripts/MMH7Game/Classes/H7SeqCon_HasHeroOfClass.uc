 // Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
class H7SeqCon_HasHeroOfClass extends H7SeqCon_HasHeroWith
	native;

/* The Class to be checked. */
var(Properties) protected archetype H7HeroClass mClass<DisplayName="Hero Class">;

function protected bool IsConditionFulfilledForHero(H7AdventureHero currentHero)
{
	return currentHero.GetHeroClass() == mClass;
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

