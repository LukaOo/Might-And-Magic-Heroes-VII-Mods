/*============================================================================
* H7SeqAct_SupressAutoSave
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/

class H7SeqAct_SupressAutoSave extends SequenceAction;

var(Properties) bool mFlag<DisplayName="Enable Tutorial Mode">;

function Activated()
{
	class'H7ReplicationInfo'.static.GetInstance().mIsTutorial = mFlag;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

