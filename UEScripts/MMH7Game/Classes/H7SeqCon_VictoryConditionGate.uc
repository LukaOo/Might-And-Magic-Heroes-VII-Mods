/*=============================================================================
 * H7SeqCon_VictoryConditionGate
 * 
 * Gate to be used to activate one of several victory condition kismet setups,
 * depending on what the player selected in the New Game Setup Menu.
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================*/

class H7SeqCon_VictoryConditionGate extends SequenceCondition
	native
	savegame;

var protected savegame int mOutputIndex;

event Activated()
{
	if(mOutputIndex < 0)
	{
		InitOutputIndex();
	}
	OutputLinks[mOutputIndex].bHasImpulse = true;
}

function InitOutputIndex()
{
	local EVictoryCondition selectedCondition;
	
	selectedCondition = class'H7TransitionData'.static.GetInstance().GetSelectedVictoryCondition();

	if(selectedCondition == E_H7_VC_DEFAULT)
	{
		mOutputIndex = 3;
	}
	else if(selectedCondition == E_H7_VC_STANDARD)
	{
		mOutputIndex = 0;
	}
	else if(selectedCondition == E_H7_VC_ASHA)
	{
		mOutputIndex = 1;
	}
	else if(selectedCondition == E_H7_VC_FORTS)
	{
		mOutputIndex = 2;
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

