//=============================================================================
// H7SeqAct_IntroHeroCameraAction
//=============================================================================
// Kismet Action to start an H7IntroduceHeroCameraAction
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqAct_IntroHeroCameraAction extends SequenceAction;

var(CameraAction) H7IntroduceHeroCameraAction mActionTemplate<DisplayName=Introduce Hero Camera Action>;

event Activated()
{
	class'H7CameraActionController'.static.GetInstance().StartIntroduceHero(OnActionCompleted, mActionTemplate);
}

function OnActionCompleted()
{
	ActivateOutputLink(0);
}

