/*=============================================================================
 * H7SeqEvent_CellEvent
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * =============================================================================*/
class H7SeqEvent_CellEventArmy extends SequenceEvent
	implements(H7IAliasable, H7ITriggerable, H7IHeroReplaceable)
	native;

/** Only a specific hero triggers the event, otherwise any hero will trigger it */
var(Properties) protected bool mFilterOneHero<DisplayName="One specific">;
/** The specific hero to trigger the event */
var(Properties) protected archetype H7EditorHero mFilterHero<DisplayName="Hero"|EditCondition=mFilterOneHero>;
/** Only a specific player triggers the event, otherwise any player will trigger it */
var(Properties) protected bool mFilterOnePlayer<DisplayName="controlled by one">;
/** The specific player to trigger the event */
var(Properties) protected EPlayerNumber mFilterPlayerID<DisplayName="Player"|EditCondition=mFilterOnePlayer>;

var protected H7AdventureArmy mHeroArmy;

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
// (cpptext)

