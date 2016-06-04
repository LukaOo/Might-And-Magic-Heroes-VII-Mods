//=============================================================================
// H7SeqAct_GetSelectedArmy
//=============================================================================
// Kismet action to get the current selected army in the Adventure Map
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7SeqAct_GetSelectedArmy extends SequenceAction;

var H7AdventureArmy CurrentArmy;

event Activated()
{
	CurrentArmy = class'H7AdventureController'.static.GetInstance().GetSelectedArmy();
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

