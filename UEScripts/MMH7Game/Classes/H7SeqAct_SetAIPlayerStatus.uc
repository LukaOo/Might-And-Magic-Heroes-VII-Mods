/*=============================================================================
 * H7SeqAct_SetAIPlayerStatus
 * ============================================================================
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================
 */

class H7SeqAct_SetAIPlayerStatus extends SequenceAction;

var() protected EPlayerNumber mConditionPlayer<DisplayName="Player">;
var() protected EPlayerStatus mNewStatus<DisplayName="Status">;

event Activated()
{
	local H7Player p;
	p = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber(mConditionPlayer);
	if (p.GetPlayerType() == PLAYER_AI)
	{
		p.SetStatus(mNewStatus);
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

