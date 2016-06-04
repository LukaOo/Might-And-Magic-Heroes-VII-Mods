/*============================================================================
* H7SeqEvent_Loot
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/

class H7SeqEvent_Loot extends H7SeqEvent_HeroEvent
	native;

/** Triggers only for a specific item, otherwise for any item */
var(Properties) protected bool mOneItem     <DisplayName="One specific item">;
/** The required specific item */
var(Properties) protected H7ItemPile mItem  <DisplayName="Item"|EditCondition=mOneItem>;

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	return super.CheckH7SeqEventActivate(evtParam) && (!mOneItem || mItem == H7HeroEventParam(evtParam).mEventSite);
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

