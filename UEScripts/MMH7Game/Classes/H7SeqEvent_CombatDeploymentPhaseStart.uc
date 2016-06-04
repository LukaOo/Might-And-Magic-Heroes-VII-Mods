/*============================================================================
* H7SeqEvent_CombatMapStarted
* 
* Fired when combat map starts deployment phase
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/

class H7SeqEvent_CombatDeploymentPhaseStart extends H7SeqEvent;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

