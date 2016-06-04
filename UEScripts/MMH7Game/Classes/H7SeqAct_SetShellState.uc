/*============================================================================
* H7SeqAct_SetShellState
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/

class H7SeqAct_SetShellState extends SequenceAction
	native;

/** The specific shell to activate / deactivate */
var(Properties) protected H7VisitingShell mShell<DisplayName="Shell">;
var(Properties) protected bool mState<DisplayName="State">;

event Activated()
{
	;
	mShell.SetActive(mState);
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

