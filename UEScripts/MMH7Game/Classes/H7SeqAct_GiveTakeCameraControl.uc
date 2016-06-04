//=============================================================================
// H7SeqAct_GiveTakeCamera
//=============================================================================
// Kismet action to give player the control of Camera or take it
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7SeqAct_GiveTakeCameraControl extends SequenceAction
	implements(H7IAliasable, H7IActionable)
	native;

/** Take camera control from player */
var(Properties) protected bool mTakeCameraControl<DisplayName="Take Camera Control">;

event Activated()
{
	class'H7Camera'.static.GetInstance().LockCamera(mTakeCameraControl);
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

