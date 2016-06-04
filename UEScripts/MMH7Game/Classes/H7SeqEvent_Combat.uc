/*============================================================================
* H7SeqEvent_Combat
* 
* starts/wins/loses a fight with
* one/any hero/town controlled by one/any player in one/any area
* one/any neutral army in one/any area
* 
* TODO: Town and area cases
* TODO: flee? surrender?
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/

class H7SeqEvent_Combat extends H7SeqEvent_CombatTrigger
	native;

var protected vector mCombatPosition;
var protected int mTotalLosses;

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	if (super.CheckH7SeqEventActivate(evtParam))
	{
		mCombatPosition = H7HeroEventParam(evtParam).mBeforeBattleCell.GetLocation();
		mTotalLosses = class'H7ScriptingController'.static.GetInstance().GetLastCombatLosses();
		return true;
	}
	return false;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 6;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

