 // Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
class H7SeqCon_ArmyHasHero extends H7SeqCon_ArmyHas
	native;

// The Hero to be checked
var(Properties) protected archetype H7EditorHero mHero<DisplayName="Hero">;

function protected bool IsConditionFulfilledForArmy(H7AdventureArmy army)
{
	if(mHero == none)
	{
		return false;
	}
	else
	{
		return (army.GetHeroTemplateSource() == mHero);
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

