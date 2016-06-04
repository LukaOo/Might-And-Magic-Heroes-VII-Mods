//=============================================================================
// H7SeqAct_IntroHeroCameraAction
//=============================================================================
// Kismet Action to start an H7IntroduceHeroCameraAction
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqAct_FadeToBlack extends SequenceAction;

var(Properties) float       mDuration<DisplayName=Duration>;
var(Properties) LinearColor mColor<DisplayName=Color>;

event Activated()
{
	if(InputLinks[0].bHasImpulse)
	{
		class'H7CameraActionController'.static.GetInstance().FadeToColor(mDuration, mColor);
	}
	else if(InputLinks[1].bHasImpulse)
	{
		class'H7CameraActionController'.static.GetInstance().FadeFromColor(mDuration, mColor);
	}
}

