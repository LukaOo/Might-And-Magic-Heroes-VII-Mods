/*============================================================================
* H7SeqEvent_LearnSkill
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/

class H7SeqEvent_LearnSkill extends H7SeqEvent_HeroEvent
	native;

/** The skill that is learned */
var(Properties) archetype H7Skill mSkill<DisplayName="Skill">;
/** The required skill rank */
var(Properties) ESkillRank mRank<DisplayName="Required rank">;

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	local bool bSkillMatch, bRankMatch;

	bSkillMatch = mSkill == none ? true : H7HeroEventParam(evtParam).mEventSkill.GetName() == mSkill.GetName();
	bRankMatch = mRank == SR_ALL_RANKS ? true : H7HeroEventParam(evtParam).mEventSkillRank == mRank;

	return super.CheckH7SeqEventActivate(evtParam) && bSkillMatch && bRankMatch;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

