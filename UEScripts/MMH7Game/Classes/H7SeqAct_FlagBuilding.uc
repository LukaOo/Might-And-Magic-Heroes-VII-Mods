/*=============================================================================
 * H7SeqAct_FlagBuilding
 * ============================================================================
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================
 */
class H7SeqAct_FlagBuilding extends SequenceAction
	implements(H7IAliasable, H7IActionable, H7IRandomPropertyOwner)
	native
	savegame;

/** The building that should be flagged */
var(Properties) savegame H7AreaOfControlSite mBuilding<DisplayName="Building">;
/** The player that is going to own the building */
var(Properties) EPlayerNumber mPlayerNumber<DisplayName="Owner">;

event Activated()
{
	if(mBuilding != none)
	{
		mBuilding.SetSiteOwner(mPlayerNumber, false);
		class'H7AdventureController'.static.GetInstance().UpdateHUD();
	}
}

function UpdateRandomProperties(Object randomObject, Object hatchedObject)
{
	if(hatchedObject.IsA('H7AreaOfControlSite'))
	{
		if(mBuilding == randomObject)
		{
			mBuilding = H7AreaOfControlSite(hatchedObject);
		}
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 3;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

