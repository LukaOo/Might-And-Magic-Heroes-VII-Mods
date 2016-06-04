//=============================================================================
// H7SeqCon_Objective
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqCon_Objective extends SequenceCondition;

/** The ingame description of the objective */
var(Properties) protected string mDescription<DisplayName=Description>;

event Activated()
{
	OutputLinks[0].bHasImpulse = true;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

