/*============================================================================
* H7SeqEvent_CollectArmy
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/

class H7SeqEvent_CollectArmy extends H7SeqEvent_HeroEvent
	native
	savegame;

var(Properties) protected int mArmyCount<DisplayName="Amount of Armies to collect"|ClampMin=1>;

var private savegame int mCounter;

// This is redundant, as it's now done in SequenceEvent. Still it's kept for the time being to be on the safe side.
var private savegame float mActivationTime;
var private savegame int mTriggerCount;
var private savegame bool mIsEnabled;

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	local bool bIsMatchedHero;

	bIsMatchedHero = super.CheckH7SeqEventActivate(evtParam);
	if (bIsMatchedHero && mCounter < mArmyCount)
	{
		mCounter++;
		if (mCounter >= mArmyCount)
		{
			return true;
		}
	}
	return false;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
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

