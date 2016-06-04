 // Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
class H7SeqCon_HasHeroWithSkill extends H7SeqCon_HasHeroWith
	native;

/* The Skill to be checked. Check for any Skill if set to none. */
var(Properties) protected archetype H7Skill mSkill<DisplayName="Skill">;
/* The required skill rank. */
var(Properties) ESkillRank mRank<DisplayName="Required rank">;

function protected bool IsConditionFulfilledForHero(H7AdventureHero currentHero)
{
	local array<H7Skill> allSkills;
	local H7Skill currentSkill;

	allSkills = currentHero.GetSkillManager().GetAllSkills();

	if(mSkill == none && mRank == SR_ALL_RANKS)
	{
		return (allSkills.Length > 0);
	}

	foreach allSkills(currentSkill)
	{
		if(mSkill == none && currentSkill.GetCurrentSkillRank() == mRank)
		{
			return true;
		}
		else if(class'H7GameUtility'.static.GetArchetypePath(currentSkill) == class'H7GameUtility'.static.GetArchetypePath(mSkill))
		{
			return (mRank == SR_ALL_RANKS ? true : currentSkill.GetCurrentSkillRank() == mRank);
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

