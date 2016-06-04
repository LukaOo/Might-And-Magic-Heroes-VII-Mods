//=============================================================================
// Adding/Removing units from an hero/army
//
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqAct_ModHeroSkills extends H7SeqAct_ManipulateHero
	native;

var(Properties) archetype H7SKill mSkill<DisplayName="Skill to learn">;

function Activated()
{
	local H7AdventureArmy army;
	local H7AdventureHero hero;

	if (mSkill == none)
	{
		return;
	}

	army = GetTargetArmy();

	if(army == none)
	{
		return;
	}

	hero = army.GetHero();

	if (hero == none)
	{
		return;
	}

	hero.GetSkillManager().IncreaseSkillRank(mSkill.GetID(), true, true);
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

