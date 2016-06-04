/*============================================================================
* H7SeqEvent_CombatTurn
* 
* Fires when the combat reaches certain turn for player
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/

class H7SeqEvent_CombatTurn extends H7SeqEvent_CombatTrigger;

var(Properties) int mTurn<DisplayName="Turn">;

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	return super.CheckH7SeqEventActivate(evtParam) && mTurn == H7HeroEventParam(evtParam).mCombatCurrentTurn;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

