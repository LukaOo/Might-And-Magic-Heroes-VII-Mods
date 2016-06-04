/*============================================================================
* H7SeqAct_DisableTacticsPhase
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/

class H7SeqAct_DisableTacticsPhase extends SequenceAction;

var(Properties) bool mFlag<DisplayName="Disable Tactics Phase">;

function Activated()
{
	class'H7ReplicationInfo'.static.GetInstance().mSupressTactics = mFlag;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

