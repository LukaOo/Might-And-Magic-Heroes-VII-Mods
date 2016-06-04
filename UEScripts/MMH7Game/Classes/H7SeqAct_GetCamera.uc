//=============================================================================
// H7SeqAct_GetCamera
//=============================================================================
// Kismet action to get the current game camera
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7SeqAct_GetCamera extends SequenceAction;

var H7Camera CurrentH7Camera;

event Activated()
{
	CurrentH7Camera = class'H7Camera'.static.GetInstance();
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

