/*============================================================================
* H7SeqEvent_LearnAbility
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/

class H7SeqEvent_LearnAbility extends H7SeqEvent_HeroEvent
	native;

/** The ability that is learned */
var(Properties) archetype H7HeroAbility mAbility<DisplayName="Ability">;

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	local bool bAbilityMatch;

	bAbilityMatch = mAbility == none ? true : H7HeroEventParam(evtParam).mEventLearnedAbility.GetName() == mAbility.GetName();

	return super.CheckH7SeqEventActivate(evtParam) && bAbilityMatch;
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

