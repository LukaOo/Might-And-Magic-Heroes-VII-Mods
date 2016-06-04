/*=============================================================================
 * H7SeqAct_InteractWithBuilding
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================*/

class H7SeqAct_InteractWithBuilding extends H7SeqAct_LatentArmyAction
	implements(H7IRandomPropertyOwner)
	native
	savegame;

/** The site that will be interacted with */
var(Properties) protected savegame H7VisitableSite mSite<DisplayName=Site>;

function H7VisitableSite GetSite() { return mSite; }

function UpdateRandomProperties(Object randomObject, Object hatchedObject)
{
	if(hatchedObject.IsA('H7VisitableSite'))
	{
		if(mSite == randomObject)
		{
			mSite = H7VisitableSite(hatchedObject);
		}
	}
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

