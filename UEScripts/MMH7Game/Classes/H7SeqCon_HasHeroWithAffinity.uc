 // Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
class H7SeqCon_HasHeroWithAffinity extends H7SeqCon_HasHeroWith
	native;

/* The Affinity to be checked. */
var(Properties) protected EHeroAffinity mAffinity<DisplayName="Affinity">;

function protected bool IsConditionFulfilledForHero(H7AdventureHero currentHero)
{
	if(mAffinity == AFF_MIGHT)
	{
		return currentHero.IsMightHero();
	}
	else if (mAffinity == AFF_MAGIC)
	{
		return currentHero.IsMagicHero();
	}
	else
	{
		return false;
	}
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

