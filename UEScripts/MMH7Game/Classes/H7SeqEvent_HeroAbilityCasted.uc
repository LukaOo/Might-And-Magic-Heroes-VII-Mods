class H7SeqEvent_HeroAbilityCasted extends H7SeqEvent_Heroevent;

/** The ability that is casted */
var(Properties) archetype H7HeroAbility mAbility<DisplayName="Ability">;

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	local bool bAbilityMatch;

	bAbilityMatch = mAbility == none ? true : H7HeroEventParam(evtParam).mEventCastedAbility.GetName() == mAbility.GetName();

	return super.CheckH7SeqEventActivate(evtParam) && bAbilityMatch;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

