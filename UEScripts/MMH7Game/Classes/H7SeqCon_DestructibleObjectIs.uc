//=============================================================================
// H7SeqCon_DestructibleObject
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqCon_DestructibleObjectIs extends H7SeqCon_TimePassed
	implements(H7IConditionable)
	native;

enum EDestructibleObjectState
{
	DOS_INTACT<DisplayName="intact">,
	DOS_DESTROYED<DisplayName="destroyed">,
};

/** The destructible object that is checked */
var(Properties) protected H7GameplayFracturedMeshActor mDestructibleObject<DisplayName="The destructible object">;
/** The required state */
var(Properties) protected EDestructibleObjectState mState<DisplayName="State">;

function protected bool IsConditionFulfilled()
{
	if(class'H7WindowWeeklyCntl'.static.GetInstance().GetWindowWeeklyEffect().IsVisible()) return false; // block as long as weekly window is open

	return (mState == DOS_INTACT && !mDestructibleObject.IsFractured()) || (mState == DOS_DESTROYED && mDestructibleObject.IsFractured());
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

