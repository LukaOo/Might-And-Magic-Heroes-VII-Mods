/*============================================================================
* H7SeqEvent_CombatMapEnd
* 
* Fired when the combat map has ended.
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/

class H7SeqEvent_CombatMapEnd extends H7SeqEvent_CombatTrigger
	native;

/** Only trigger when this hero won the combat */
var(Properties) protected archetype H7EditorHero mVictoriousHero<DisplayName="Victorious hero">;

var protected H7AdventureArmy mVictoriousHeroArmy;

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	local H7HeroEventParam param;
	local H7EditorHero heroToCheck;

	if ( super.CheckH7SeqEventActivate(evtParam) )
	{
		heroToCheck = (mVictoriousHeroArmy == none) ? mVictoriousHero : mVictoriousHeroArmy.GetHeroTemplateSource();
		param = H7HeroEventParam(evtParam);
		if (param != none)
		{
			return (heroToCheck == none || param.mEventVictoriousArmy.GetHeroTemplateSource() == heroToCheck);
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

