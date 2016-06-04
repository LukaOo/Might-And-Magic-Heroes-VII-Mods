/*============================================================================
* H7SeqEvent_PlayerGetsVisibilityOfTile
*
* Fired when player recruits new hero
* 
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/

class H7SeqEvent_PlayerRecruitHero extends H7SeqEvent_PlayerEvent;

/** The specific hero to trigger the event */
var(Properties) protected archetype H7EditorHero mHero<DisplayName="Hero archetype">;

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	return super.CheckH7SeqEventActivate(evtParam) && 
		(mHero == none || H7PlayerEventParam(evtParam).mRecruitedHero == mHero);
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

