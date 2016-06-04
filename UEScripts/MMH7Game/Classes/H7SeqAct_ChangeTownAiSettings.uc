/*=============================================================================
 * H7SeqAct_ChangeTownAiSettings
 * ============================================================================
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================
 */
class H7SeqAct_ChangeTownAiSettings extends SequenceAction
	implements(H7IAliasable, H7IActionable, H7IRandomPropertyOwner)
	native
	savegame;

/** The building that should be flagged */
var(Properties) savegame H7Town mTown<DisplayName="Town">;
var(Properties) bool mInHibernation<DisplayName="In hibernation state">;
var(Properties) bool mEnableDevelopTown<DisplayName="Enable develop town logic">;
var(Properties) bool mEnableRecruitment<DisplayName="Enable creature recruitment logic">;
var(Properties) bool mEnableTrade<DisplayName="Enable trade logic">;
var(Properties) bool mEnableHireHeroes<DisplayName="Enable hire heroes logic">;

event Activated()
{
	if(mTown!=none)
	{
		mTown.SetAiHibernationState(mInHibernation);
		mTown.SetAiEnableDevelopTown(mEnableDevelopTown);
		mTown.SetAiEnableRecruitment(mEnableRecruitment);
		mTown.SetAiEnableTrade(mEnableTrade);
		mTown.SetAiEnableHireHeroes(mEnableHireHeroes);
	}
}

function UpdateRandomProperties(Object randomObject, Object hatchedObject)
{
	if(hatchedObject.IsA('H7Town'))
	{
		if(mTown == randomObject)
		{
			mTown = H7Town(hatchedObject);
		}
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

