/*=============================================================================
 * H7SeqAct_Hide_Reveal
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================*/

class H7SeqAct_Hide_Reveal extends SequenceAction
	implements(H7IAliasable, H7IActionable, H7IRandomPropertyOwner)
	native
	savegame;

/** The object that should be hidden or revealed */
var(Properties) protected savegame H7IHideable mTargetObject<DisplayName="Target object">;
/** Hide or reveal */
var(Properties) protected EHideReveal mOperation<DisplayName="Interaction">;

event Activated()
{
	local H7EditorMapObject mapObject;

	mapObject = H7EditorMapObject(mTargetObject);
	mapObject.SetShouldHideMeshAndFX(true);

	if(mOperation == EHR_HIDE)
	{
		mTargetObject.Hide();
		if(mapObject != none)
		{
			
			mapObject.SetVisibility(false);
		}
	}
	else if(mOperation == EHR_REVEAL)
	{
		mTargetObject.Reveal();
		if(mapObject != none)
		{
			mapObject.SetVisibility(true);
		}
	}

	class'H7AdventureGridManager'.static.GetInstance().GetCurrentGrid().GetFOWController().ExploreFog();
}

function UpdateRandomProperties(Object randomObject, Object hatchedObject)
{
	if(mTargetObject == randomObject)
	{
		mTargetObject = hatchedObject;
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

