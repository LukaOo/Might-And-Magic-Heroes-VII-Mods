//=============================================================================
// H7SeqAct_PresentArmyCameraAction
//=============================================================================
// Kismet Action to start an H7PresentArmyCameraAction
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqAct_PresentArmyCameraAction extends SequenceAction;

var(CameraAction) H7PresentArmyCameraAction   mActionTemplate<DisplayName=Present Army Camera Action>;

event Activated()
{
	class'H7CameraActionController'.static.GetInstance().StartPresentArmy(none, mActionTemplate);
}

