 // Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
class H7SeqCon_HasHeroWithSpecialization extends H7SeqCon_HasHeroWith
	native;

/* The Specialization to be checked. Check for any Specialization if set to none. */
var(Properties) protected archetype H7HeroAbility mSpecialization<DisplayName="Specialization">;

function protected bool IsConditionFulfilledForHero(H7AdventureHero currentHero)
{
	return (currentHero.GetSpecialization() == mSpecialization || (mSpecialization == none && currentHero.GetSpecialization() != none));
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

