//=============================================================================
// H7SeqEvent_HeroEvent
//
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
// Base class for One/any hero events

class H7SeqEvent_HeroEvent extends H7SeqEvent
	implements(H7ITriggerable, H7IHeroReplaceable)
	abstract
	native;

/** Only a specific hero triggers the event, otherwise any hero will trigger it */
var(Properties) protected bool mOneHero<DisplayName="One specific hero">;
/** The specific hero to trigger the event */
var(Properties) protected archetype H7EditorHero mHero<DisplayName="Hero"|EditCondition=mOneHero>;
/** Only a hero controlled by a specific player triggers the event, otherwise any player will trigger it */
var(Properties) protected bool mOnePlayer<DisplayName="Hero controlled by one player">;
/** The specific player to trigger the event */
var(Properties) protected EPlayerNumber mPlayerNumber<DisplayName="Player controlling the hero"|EditCondition=mOnePlayer>;

var protected H7AdventureArmy mHeroArmy;

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	local H7HeroEventParam param;
	local H7EditorHero heroToCheck;

	if ( super.CheckH7SeqEventActivate(evtParam) )
	{
		heroToCheck = (mHeroArmy == none) ? mHero : mHeroArmy.GetHeroTemplateSource();
		param = H7HeroEventParam(evtParam);
		if (param != none)
		{
			return (!mOneHero || param.mEventHeroTemplate == heroToCheck) && (!mOnePlayer || param.mEventPlayerNumber == self.mPlayerNumber);
		}
	}
	return false;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 3;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

