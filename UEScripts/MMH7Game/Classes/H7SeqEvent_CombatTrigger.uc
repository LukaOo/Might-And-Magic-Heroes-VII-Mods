/*============================================================================
* H7SeqEvent_CombatTrigger
* 
* Base class for combat related events.
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/

class H7SeqEvent_CombatTrigger extends H7SeqEvent_HeroEvent
	abstract
	native;

enum EWhichCombatMap
{
	H7_EWC_ANY<DisplayName="Any combat map">,
	H7_EWC_SPECIFIC<DisplayName="A specific combat map">,
};

/** The army that is attacked */
var(Properties) H7AdventureArmy mDefendingArmy<DisplayName="Enemy army">;
/** Fire on any or only a specific combat map? */
var(Properties) EWhichCombatMap mWhichCombatMap<DisplayName="Combat map to use">;
/** The name of the combat map that is started. */
var(Properties) string mCombatMapName<DisplayName="Combat map name"|EditCondition=mIsCombatMapUsed>;
/** Only an enemy controlled by a specific player triggers the event, otherwise any player will trigger it */
var(Properties) protected bool mOneEnemyPlayer<DisplayName="Enemy controlled by one player">;
/** The specific player controlling the enemy to trigger the event */
var(Properties) protected EPlayerNumber mEnemyPlayerNumber<DisplayName="Player controlling the enemy"|EditCondition=mOneEnemyPlayer>;

var private editconst transient bool mIsCombatMapUsed;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	local H7HeroEventParam param;

	if ( super.CheckH7SeqEventActivate(evtParam) )
	{
		param = H7HeroEventParam(evtParam);
		if (param != none)
		{
			return (mDefendingArmy == none || param.mEventTargetArmy == self.mDefendingArmy) && 
				(mWhichCombatMap == H7_EWC_ANY || Locs(param.mCombatMapName) == Locs(self.mCombatMapName) &&
				(!mOneEnemyPlayer || param.mEventEnemyPlayerNumber == self.mEnemyPlayerNumber));
		}
	}
	return false;
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

