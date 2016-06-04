 // Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
class H7SeqCon_HasHeroWithAbility extends H7SeqCon_HasHeroWith
	native;

/* The Ability to be checked. Check for any Ability if set to none. */
var(Properties) protected archetype H7HeroAbility mAbility<DisplayName="Ability">;

function protected bool IsConditionFulfilledForHero(H7AdventureHero currentHero)
{
	local array<H7HeroAbility> allAbilities;
	local H7HeroAbility currentAbility;

	currentHero.GetAbilityManager().GetHeroAbilities(allAbilities);

	foreach allAbilities(currentAbility)
	{
		if(mAbility == none && currentAbility.IsAbility())
		{
			return true;
		}
		else if(class'H7GameUtility'.static.GetArchetypePath(currentAbility) == class'H7GameUtility'.static.GetArchetypePath(mAbility))
		{
			return true;
		}
	}

	return false;
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

